    //
//  RCSocketManager.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import SocketRocket
import Alamofire
import SwiftyJSON
import DefaultsKit
import KeychainAccess
import GoogleMaps
import GooglePlaces
import ObjectMapper
    

protocol RCSocketManagerPositionDelegate : class {
    func getPosition(value: TrackerPositionMapperModel,expiredorNot: Bool)
}

protocol RCSocketManagerDeviceDelegate: class {
    func getDevices(value: TrackerDevicesMapperModel,expiredorNot: Bool)
}
    
class RCSocketManager: NSObject {
    
    #if DEBUG
    static let baseURLString = "https://tracapi.roadcast.co.in/api/socket"
    #else
    static let baseURLString = "https://tracapi.roadcast.co.in/api/socket"
    #endif
    
    public var positionDelegateMap:RCSocketManagerPositionDelegate?
    public var deviceDelegateMap:RCSocketManagerDeviceDelegate?
    
    public var positionDelegate:RCSocketManagerPositionDelegate?
    public var deviceDelegate:RCSocketManagerDeviceDelegate?
//    weak var eventDelegate:RCSocketManagerEventDelegate?
   
    var socket:SRWebSocket?
    var obj = MapsViewController()
    var objAddEdit = VehicleViewController()
    var connectionAttempts: Int = 0
    var isConnected: Bool = false
//    SRWebSocket(url: URL(string:RCSocketManager.baseURLString), protocols: nil, allowsUntrustedSSLCertificates: true)
    
    public static let shared = RCSocketManager()
    
     override init() {
        //Do Nothing
        self.positionDelegateMap = obj
        self.deviceDelegateMap = obj
        self.positionDelegate = objAddEdit
        self.deviceDelegate = objAddEdit
    }
    
    func connect(email:String, password:String) -> Void {

    }
    
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    func startObserving() -> Void {
        stopObserving()
        
        socket = SRWebSocket(url: URL(string:RCSocketManager.baseURLString), protocols: nil, allowsUntrustedSSLCertificates: true)
//        socket?.requestCookies = (Defaults().get(for: Key<[HTTPCookie]>("SetCookie""SetCookie")))! as [Any]
        socket?.requestCookies = RCDataManager.get(objectforKey: "SessionCookie") as? [Any]
        socket?.delegate = self
        socket?.open()
    }
    
    func stopObserving() -> Void {
        isConnected = false
        
        if socket != nil {
            socket?.close()
            socket!.delegate = nil
            socket = nil
        }
    }
    
    func reconnect() {
        isConnected = false
        connectionAttempts += 1
        
        if connectionAttempts < 6 {
            
            if connectionAttempts == 3 {
                getSession()
            }
            self.delay(2, closure: {
                self.startObserving()
            })
        } else {
            connectionAttempts = 0
            let notification: Notification = Notification(name: NSNotification.Name(rawValue: "SocketNetworkErrorNotification"),
                                                              object: nil,
                                                              userInfo: nil)
            NotificationCenter.default.post(notification as Notification)
        }
    }
    
    
    func getSession(){
        if let loginData = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data {
            if let username = loginData.email {
                let keychain = Keychain(service: "in.roadcast.bolt")
                let password: String = {
                    do {
                        return try keychain.getString("boltPassword") ?? ""
                    } catch {
                        return ""
                    }
                }()
//                let password = try? keychain.getString("boltPassword")
                
                RCLocalAPIManager.shared.session(with: username, password: password , success: { hash in
                    Defaults().set(true, for: Key<Bool>("isLoggedIn"))
                    
                }) { message in
                    UIApplication.shared.keyWindow?.makeToast(message, duration: 3.0, position: .bottom)
                }
            }
        }
    }
    
    
    deinit {
        if let socket = socket {
            socket.close()
        }
    }
}

extension RCSocketManager: SRWebSocketDelegate {
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        connectionAttempts = 0
        isConnected = true
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print(error.localizedDescription)
        reconnect()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        
        #if DEBUG
            //TODO: comment the logging for all requests
//            print(message as! String)
        #endif
        
        let expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as? [String] ?? [String]()
        
        let msgType = JSON.init(parseJSON: message as! String)
        
        if let data = msgType["positions"].array {
            var devicePosition:TrackerPositionMapperModel?
                for value in data {
                    let keyValue:String = "Position_" + value["deviceId"].stringValue
                    let decoder = JSONDecoder()
                    devicePosition = try? decoder.decode(TrackerPositionMapperModel.self, from: value.rawData())
                    
                    if let trackerPosition = devicePosition {
                        if let tempDevPos = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue)) {
                            trackerPosition.address = tempDevPos.address
                            Defaults().set(trackerPosition, for: Key<TrackerPositionMapperModel>(keyValue))
                            let cordinate = CLLocationCoordinate2D(latitude: (trackerPosition.latitude)!, longitude: (trackerPosition.longitude)!)
                            
                            RCGlobals.switchKey(&devPosCoordinateDic, fromKey: "\(tempDevPos.latitude ?? 0.0)\(tempDevPos.longitude ?? 0.0)",
                                                toKey: "\(trackerPosition.latitude ?? 0.0)\(trackerPosition.longitude ?? 0.0)")
                            
                            GMSGeocoder().reverseGeocodeCoordinate(cordinate) { (response, error) in
                                guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else {
                                    return
                                }
                                let tempAddress = lines.joined(separator: " ")
                                
                                if let tempKeyValue = devPosCoordinateDic["\(Gaddress.coordinate.latitude)\(Gaddress.coordinate.longitude)"]{
                                    if let  tempDevPos = Defaults().get(for: Key<TrackerPositionMapperModel>(tempKeyValue)) {
                                        tempDevPos.address = tempAddress
                                        Defaults().set(tempDevPos, for: Key<TrackerPositionMapperModel>(tempKeyValue))
                                        DispatchQueue.main.async {
                                            if !expiredIdArray.contains(String(trackerPosition.deviceId!)) {
                                                
                                                self.posDelegateFunc(get: trackerPosition, expiredorNot: false)
                                                
                                            } else if expiredIdArray.contains(String(trackerPosition.deviceId!)){
                                                
                                                self.posDelegateFunc(get: trackerPosition, expiredorNot: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
//            if trackerPosition != nil {
//                posDelegateFunc(get: trackerPosition)
//            }
            
        }
        
        if let datas = msgType["devices"].array {
           var trackerDevices:TrackerDevicesMapperModel!
           
            for value in datas {
                let keyValue: String = "Device_" + value["id"].stringValue
//                let decoder = JSONDecoder()
                let responseString = try? String(data: value.rawData(), encoding:String.Encoding.utf8)
                trackerDevices = Mapper<TrackerDevicesMapperModel>().map(JSONString: responseString as! String)
//                trackerDevices = try! decoder.decode(TrackerDevicesMapperModel.self, from: value.rawData())
                Defaults().set(trackerDevices, for: Key<TrackerDevicesMapperModel>(keyValue))
            }
            
            
            
            if trackerDevices != nil {
                if !expiredIdArray.contains(String(trackerDevices!.id)) {
                    
                    deviceDelegateFunc(get: trackerDevices, expiredorNot: false)
                    
                } else if expiredIdArray.contains(String(trackerDevices!.id)) {
                    
                    deviceDelegateFunc(get: trackerDevices, expiredorNot: true)
                }
            }
        }
        
        if let datas = msgType["events"].array {
            
            for value in datas {
                print(value)
            }
            
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("didClose", code, reason, wasClean)
        reconnect()
    }

//    public func googleAddress(with cordinate: CLLocationCoordinate2D) {
//
//        GMSGeocoder().reverseGeocodeCoordinate(cordinate) { (response, error) in
//            guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else {return}
//            let tempAddress = lines.joined(separator: " ")
//
//            if let tempKeyValue = devPosCoordinateDic["\(Gaddress.coordinate.latitude)\(Gaddress.coordinate.longitude)"]{
//                if let  tempDevPos = Defaults().get(for: Key<TrackerPositionMapperModel>(tempKeyValue)) {
//                    tempDevPos.address = tempAddress
//                    Defaults().set(tempDevPos, for: Key<TrackerPositionMapperModel>(tempKeyValue))
//                }
//            }
//        }
//    }
    
    func posDelegateFunc(get: TrackerPositionMapperModel, expiredorNot: Bool){
        positionDelegateMap?.getPosition(value: get, expiredorNot: expiredorNot)
        positionDelegate?.getPosition(value: get, expiredorNot: expiredorNot)
    }
    
    func deviceDelegateFunc(get: TrackerDevicesMapperModel,expiredorNot: Bool){
        deviceDelegateMap?.getDevices(value: get, expiredorNot: expiredorNot)
        deviceDelegate?.getDevices(value: get, expiredorNot: expiredorNot)
    }

//    func eventDelegateFunc(get: TrackerEventsMapperModel){
//        eventDelegate?.getEvents(value: get)
//    }
}

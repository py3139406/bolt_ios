//
//  FollowerMapViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import GoogleMaps
import SnapKit
import DefaultsKit
import Firebase
import SwiftMessages

class FollowerMapViewController: UIViewController {
    var geoFenceMapView:FollowerMapView!
    var flag = true
    private var loginUser : LoginResponseModel!
    private var device : TrackerDevicesMapperModel!
    
    var endMarker:GMSMarker!
    var startmarker:GMSMarker!
    var coordinateArray:[CLLocationCoordinate2D] = []
    var stopMarkerCoordinateArray:[CLLocationCoordinate2D] = []
    var locationArray:[CLLocation] = []
    
    
    var followerToken: String!
    private var roomReference : DatabaseReference!
    private var userReference : DatabaseReference!
    private var followerDeviceId: Int!
    private var followerFixTime: String!
    private var followerPositionId: Int!
    private var followerName: String!
    private var deviceName: String!
    private var deviceType: String!
    private var repeatTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RCMapView.clearMap()
        geoFenceMapView = FollowerMapView(frame: view.bounds)
        geoFenceMapView.searchButton.isEnabled = false
        geoFenceMapView.cancelButton.isEnabled = false
        geoFenceMapView.circleButton.isEnabled = false
        geoFenceMapView.polygonButton.isEnabled = false
        geoFenceMapView.polylineButton.isEnabled = false
        geoFenceMapView.submitButton.isEnabled = false
        geoFenceMapView.searchButton.isHidden = true
        geoFenceMapView.cancelButton.isHidden = true
        geoFenceMapView.circleButton.isHidden = true
        geoFenceMapView.polygonButton.isHidden = true
        geoFenceMapView.polylineButton.isHidden = true
        geoFenceMapView.submitButton.isHidden = true
        view.addSubview(geoFenceMapView)
        
        followerToken = Defaults().get(for: Key<String>("ShareVehicleFollowerPin")) ?? ""

        roomReference = Database.database().reference().child("bolt/rooms/\(followerToken ?? "0" )")
    userReference = Database.database().reference().child("bolt/rooms/\(followerToken ?? "0" )/users")
            
            roomReference.observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    self.addUser(type: "follower")

                    self.userReference.observeSingleEvent(of: .value, with: {(snapshot) in
                        
                        if (snapshot.childrenCount > 0) {
                            for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                guard let restDict = childSnapshot.value as? [String: Any] else { continue }
                                let userType = restDict["userType"] as? String
                                
                                if userType == "leader" {
                                    self.followerDeviceId = (restDict["deviceId"] as? Int)!
                                    self.followerFixTime = (restDict["fixTime"] as? String)!
                                    self.followerPositionId = (restDict["positionId"] as? Int)!
                                    self.followerName = (restDict["name"] as? String)!
                                    self.deviceName = (restDict["deviceName"] as? String)!
                                    self.deviceType = (restDict["deviceType"] as? String)!
                                    self.getLeaderPath()
                                }
                            }
                        }
                        
                    })
                    
                } else {
                    self.prompt("Message", "Sharing is no longer available".toLocalize, "ok".toLocalize, handler1:{_ in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        
        roomReference.observe(.childRemoved) { (snapshot) in
            if snapshot.exists() {
                if (snapshot.childrenCount > 0) {
                    for childSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        guard let restDict = childSnapshot.value as? [String: Any] else { continue }
                        let userType = restDict["userType"] as? String
                        
                        if userType == "leader" {
                            self.prompt("", "User has stopped sharing", "OK") { (_) in
                                self.stopSharing()
                            }
                        }
                    }
                }
                
            }
        }
        loginUser = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))
        
    }
    func stopSharing(){
        SwiftMessages.hideAll()
        Database.database().reference().child("bolt/rooms/\(Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? "test")/").removeValue()
        Defaults().set("", for: Key<String>("ShareVehicleRandomPin"))
        Defaults().clear(Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
        Defaults().clear(Key<String>("ShareVehicleName"))
        Defaults().clear(Key<String>("ShareVehicleFollowerPin"))
        let userRoot : DatabaseReference = self.userReference.child("\(loginUser.data?.id ?? "0")")
        userRoot.removeValue()
        self.dismiss(animated: true) {
            UIApplication.shared.keyWindow?.rootViewController = ViewController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        repeatTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(getLeaderPath), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        geoFenceMapView.mapView.clear()
        repeatTimer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addUser(type:String){
        if userReference != nil {
            let userRoot : DatabaseReference = userReference.child("\(loginUser.data?.id ?? "0")")
            
            var user : [String: Any] = [:]
            user["name"] = loginUser.data?.name
            user["userId"] = loginUser.data?.id
            user["userType"] = type
            user["isTyping"] = "\(false)"
            userRoot.setValue(user)
        }
    }
  
    @objc func getLeaderPath() {
        
        let fromDate = followerFixTime.components(separatedBy: ".")[0]
        let toDate = RCGlobals.getFormattedDate(date: Date() as NSDate, format: "yyyy-MM-dd'T'HH:mm:ss", zone: TimeZone(secondsFromGMT: 0)!)
        
        RCLocalAPIManager.shared.getFollowerPath(with: followerDeviceId, fromDate: fromDate, toDate: toDate, success: { [weak self] hash in
            guard self != nil else {
                return
            }
            var coordinateArray:[CLLocationCoordinate2D] = []
            for path in hash.data! {
                let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!), longitude: Double(path.longitude!)), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? 0), speed: Double(path.speed ?? 0), timestamp: RCGlobals.getDateFor(path.fixTime!))
                self?.locationArray.append(location)
                coordinateArray.append(location.coordinate)
            }
            self?.plotPathOnMap(points:(self?.locationArray)!, coordinateArray:coordinateArray)
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            print("\(message)")
            weakSelf.view.makeToast("path not found")
        }
    }
    
    func plotPathOnMap(points:[CLLocation],coordinateArray:[CLLocationCoordinate2D]) -> Void {
        let _ = RCPolyLine().drawpolyLineFrom(points: coordinateArray, color: UIColor.red, title: "", map: geoFenceMapView.mapView)
        
        if startmarker == nil {
            startmarker = GMSMarker(position:coordinateArray.first!)
            startmarker.map = geoFenceMapView.mapView
            startmarker.icon = GMSMarker.markerImage(with:.green)
            startmarker.title = NSLocalizedString("Start Location", comment: "Start Location")
            let snippet = self.deviceName + "\nLast updated: ".toLocalize + RCGlobals.getFormattedDate(date: (locationArray.first?.timestamp)!, format: "dd-MM-yyyy hh:mm a")
            startmarker.snippet = snippet
        }
        
        if endMarker == nil {
            endMarker = GMSMarker(position:coordinateArray.last!)
            endMarker.map = geoFenceMapView.mapView
            endMarker.icon = GMSMarker.markerImage(with:.red)
            endMarker.title = NSLocalizedString("End Location", comment: "End Location")
            let snippet = self.deviceName + "\nLast updated: " + RCGlobals.getFormattedDate(date: (locationArray.last?.timestamp)!, format: "dd-MM-yyyy hh:mm a")
            endMarker.snippet = snippet
        } else {
            endMarker.position = coordinateArray.last!
            let snippet = self.deviceName + "\nLast updated: ".toLocalize + RCGlobals.getFormattedDate(date: (locationArray.last?.timestamp)!, format: "dd-MM-yyyy hh:mm a")
            endMarker.snippet = snippet
        }
        
        fitMap(coordinates:coordinateArray)
    }
    fileprivate func setMarkerIcon(_ deviceMarker: GMSMarker) {
        switch deviceType {
        case RCTrackerType.Bike.rawValue:
            deviceMarker.icon =  #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width:  13, height:  27), interpolationQuality: .default)
            break
        case RCTrackerType.other.rawValue:
            deviceMarker.icon = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  31, height:  35), interpolationQuality: .default)
            break
        case RCTrackerType.Truck.rawValue:
            deviceMarker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width:  15, height:  33), interpolationQuality: .default)
            break
        case RCTrackerType.Personal.rawValue:
            deviceMarker.icon = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  31, height:  35), interpolationQuality: .default)
            break
        case RCTrackerType.Bus.rawValue:
            deviceMarker.icon = #imageLiteral(resourceName: "busOnPDF").resizedImage(CGSize.init(width:  15, height:  33), interpolationQuality: .default)
            break
        case RCTrackerType.Train.rawValue:
            deviceMarker.icon = #imageLiteral(resourceName: "trainOnPDF").resizedImage(CGSize.init(width:  26, height:  33), interpolationQuality: .default)
            break
        case RCTrackerType.Erickshaw.rawValue:
            deviceMarker.icon =  #imageLiteral(resourceName: "erickshawActivePDF").resizedImage(CGSize.init(width:  21, height:  23), interpolationQuality: .default)
            break
        case RCTrackerType.crane.rawValue:
            deviceMarker.icon =  #imageLiteral(resourceName: "craneoff").resizedImage(CGSize.init(width:  26, height:  31), interpolationQuality: .default)
            break
        default:
            deviceMarker.icon =  #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width:  13, height:  27), interpolationQuality: .default)
            break
        }
    }
    
    fileprivate func fitMap(coordinates: [CLLocationCoordinate2D]) -> Void {
        var bounds: GMSCoordinateBounds!
        bounds = GMSCoordinateBounds()
        for coordinate in coordinates {
            bounds = bounds.includingCoordinate(coordinate)
        }
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding: 75)
        geoFenceMapView.mapView.animate(with:updateCamera)
    }
    
  
  
}

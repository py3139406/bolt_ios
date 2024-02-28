//
//  UIGlobal.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import DefaultsKit

var appGreenTheme = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
var appDarkTheme = UIColor(red: 39/255, green: 38/255, blue: 56/255, alpha: 1)
var geoFenceBlueColor = UIColor(red: 24/255, green: 154/255, blue: 222/255, alpha: 1.0)
var blackLabelColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
var tableViewLightColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)

extension UIViewController {
    
    func getDeviceTypeAmount(deviceId: Int) -> Int {
        //MOSFETRENEWAL
        
        let paymentRateNormalString = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWAL"))?.rate ?? 0.0
        let paymentRateAISString = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWALAIS"))?.rate ?? 0.0
        let paymentNormalDoubleString = Double(paymentRateNormalString)
        let paymentAISDoubleString = Double(paymentRateAISString)
        let keyValueDevicePos = "Position_" + "\(deviceId)"
        var deviceProtocol:String = ""
        if let trackerDevicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValueDevicePos)) {
            deviceProtocol = trackerDevicePosition.protocl ?? ""
        } else {
            let expiredList:[ExpiryDataResponseModel] = Defaults().get(for: Key<[ExpiryDataResponseModel]>("expired_vehicles")) ?? []
            
            let expiredObject = expiredList.filter { (
            
            $0.deviceid == "\(deviceId)"
            
            )}.first
            
            deviceProtocol = expiredObject?.protcol ?? ""
        }
        let keyValue = "Device_" + "\(deviceId)"
        let trackerDevice: TrackerDevicesMapperModel = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))!
        let imeiString = trackerDevice.uniqueId
        
        print("tracker protocol is \(deviceProtocol)")
        print("tracker imei is \(imeiString ?? "")")
        
        
        if ((deviceProtocol.lowercased().contains("ais"))) || (imeiString?.lowercased().contains("3515100")) ?? false {
            
            let paymentAis = Int(paymentAISDoubleString)
            
            let aisvalue = calculatePercentage(value: Double(paymentAis),percentageVal: 18)
            
            let totalAisValue = paymentAis + Int(aisvalue)
            
            
            print("this tracker is an AIS Device")
            
            return totalAisValue
            
        } else {
            
            let paymentNormal = Int(paymentNormalDoubleString)
            
            
            let normalvalue = calculatePercentage(value: Double(paymentNormal),percentageVal: 18)
            let totalNormalValue = paymentNormal + Int(normalvalue)
            
            print("this tracker is an normal Device")
            
            return totalNormalValue
            
        }
    }
    func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    func showalert(_ message:String){
        let alertController = UIAlertController(title: "Message".toLocalize, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func prompt(_ message: String) -> Void {
       
        if (message.caseInsensitiveCompare("username or password is not valid.") == ComparisonResult.orderedSame) {
            let alert = UIAlertController(title: "Password changed".toLocalize, message: message.toLocalize, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".toLocalize, style: .destructive, handler: { (_) in
                let code = UIViewController()
                  code.doLogoutAction()
            }))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Message".toLocalize, message: message.toLocalize, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".toLocalize, style: .destructive, handler: nil))
            present(alert, animated: true)
        }
        
    }
    func prompt(_ title: String,_ message: String,_ buttonText: String,_ secondButtoneText: String, handler1: @escaping (UIAlertAction) -> Void, handler2: @escaping (UIAlertAction) -> Void) -> Void {
        let alert = UIAlertController(title: title, message: message.toLocalize, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: handler1))
        alert.addAction(UIAlertAction(title: secondButtoneText, style: .destructive, handler: handler2))
        present(alert, animated: true)
    }
    func prompt(_ title: String,_ message: String,_ buttonText: String, handler1: @escaping (UIAlertAction) -> Void) -> Void {
        let alert = UIAlertController(title: title, message: message.toLocalize, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .destructive, handler: handler1))
        present(alert, animated: true)
    }
    func prompt(_ title: String,_ message: String,_ buttonText: String,_ secondButtoneText: String, thirdButtoneText: String, handler1: @escaping (UIAlertAction) -> Void, handler2: @escaping (UIAlertAction) -> Void) -> Void {
        let alert = UIAlertController(title: title, message: message.toLocalize, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: handler1))
        alert.addAction(UIAlertAction(title: secondButtoneText, style: .default, handler: handler2))
        alert.addAction(UIAlertAction(title: thirdButtoneText, style: .destructive, handler: nil))
        present(alert, animated: true)
    }
    
    func compressImage(image: UIImage) -> Data {
        // Reducing file size to a 10th
        var actualHeight: CGFloat = image.size.height
        var actualWidth: CGFloat = image.size.width
        let maxHeight: CGFloat = 1136.0
        let maxWidth: CGFloat = 640.0
        var imgRatio: CGFloat = actualWidth / actualHeight
        let maxRatio: CGFloat = maxWidth / maxHeight
        var compressionQuality: CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if(imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality)
        UIGraphicsEndImageContext()
        return imageData!
    }
    
    func requestWith(imageData: Data?, fileName: String, parameters: [String: Any], onCompletion: ((String) -> Void)? = nil, onError: ((Error?) -> Void)? = nil) {
        
        
        let url = RCRouter.baseURLString + "userDocs" /* your API url */
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Cache-Control": "no-cache",
            "Content-type": "multipart/form-data",
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: "fileData[]", fileName: fileName, mimeType: "*/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    #if DEBUG
                    //TODO: comment the logging for all requests
                    print("Request: \(String(describing: response.request))") // original url request
                    print("Request Headers: \(String(describing: response.request?.allHTTPHeaderFields))") // original url request
                    print("Request Body: \(String(describing: response.request?.httpBody?.base64EncodedString()))") // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)") // response serialization result
                    //print data as json string.
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Response Data: \(utf8Text)")
                    }
                    #endif
                    print("Succesfully uploaded")
                    if let err = response.error {
                        onError?(err)
                        return
                    }
                    onCompletion?("Success")
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    func uploadLoadUnloadImages(loadUnloadData: LoadUnloadPojo, onCompletion: ((String) -> Void)? = nil, onError: ((Error?) -> Void)? = nil) {
        
        let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        let parameters:[String:Any] = ["userId":userID, "unique_id":loadUnloadData.uniqueId]
        
        let url = RCRouter.baseURLString + "uploadDocs/tms_loading" /* your API url */
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Cache-Control": "no-cache",
            "Content-type": "multipart/form-data",
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let startImageData = loadUnloadData.startImgData {
                multipartFormData.append(startImageData, withName: "start_img[]", fileName: loadUnloadData.startImg ?? "", mimeType: "image/jpg")
            }
            
            if let endImageData = loadUnloadData.endImgData {
                multipartFormData.append(endImageData, withName: "end_img[]", fileName: loadUnloadData.endImg ?? "", mimeType: "image/jpg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    #if DEBUG
                    //TODO: comment the logging for all requests
                    print("Request: \(String(describing: response.request))") // original url request
                    print("Request Headers: \(String(describing: response.request?.allHTTPHeaderFields))") // original url request
                    print("Request Body: \(String(describing: response.request?.httpBody?.base64EncodedString()))") // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)") // response serialization result
                    //print data as json string.
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Response Data: \(utf8Text)")
                    }
                    #endif
                    print("Succesfully uploaded")
                    if let err = response.error {
                        onError?(err)
                        return
                    }
                    onCompletion?("Success")
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }

    func reverseGeocoding(latiude: String, longitude: String) -> String {
        var addressText = ""
        let doubleLat = (latiude as NSString).doubleValue
        let doubleLong = (longitude as NSString).doubleValue
        let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong)
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
                guard let address = response?.firstResult(), let lines = address.lines else { return }
                addressText = lines.joined(separator: " ")
                print(addressText)
            }
        
        print(addressText)
        return addressText
    }
}


//extension UITabBar {
//    
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        super.sizeThatFits(size)
//        var sizeThatFits = super.sizeThatFits(size)
//        
//        
//        if UIDevice().userInterfaceIdiom == .phone {
//        switch UIScreen.main.nativeBounds.height {
//            case 2436:
//                sizeThatFits.height = 105
//            default:
//                sizeThatFits.height = 71
//            }
//        }else{
//            sizeThatFits.height = 71
//        }
//        return sizeThatFits
//    }
//}
public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIApplication {

    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
          return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
          if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
          }
        }
        if let presented = controller?.presentedViewController {
          return topViewController(controller: presented)
        }
        return controller
      }
//    var statusBarView: UIView? {
//        return value(forKey: "statusBar") as? UIView
//    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


public extension String {

    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
            else { return nil }

        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }

    var length: Int {
        get {
            return self.count
        }
    }

    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }

    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }

    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }

    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }

    func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.encodedOffset
    }
}

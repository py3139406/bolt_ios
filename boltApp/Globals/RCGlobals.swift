//
//  RCGlobals.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import Presentr
import KeychainAccess
import DefaultsKit
import GoogleMaps


class RCGlobals {
    
    //  public static func sortArray(unsortedArray:[RCAllTrackerDetailModel]) -> [RCAllTrackerDetailModel] {
    //        return  unsortedArray.sorted(by: { (time1, time2) -> Bool in
    //             // return time1.tstamp?.compare(time2.tstamp as! Date) == ComparisonResult.orderedDescending
    //            return time1.ignition! && !time2.ignition!
    //        })
    //    }
    enum NotificationType: String {
        
        case sos = "sos"
        case powerCut = "powercut"
        case spymode = "spymode"
        
        
    }
    
    public static func updateAnimationDate() {
        let date:String = convertDateToString(date: Date(), format: "dd-MM-yyyy", toUTC: false)
        Defaults().set(date, for: Key<String>(defaultKeyNames.animationDate.rawValue))
    }
    
    public static func isAnimtionShownForDate() -> Bool {
        var isShown:Bool = false
        let currentDate:String = convertDateToString(date: Date(), format: "dd-MM-yyyy", toUTC: false)
        let animationDate:String = Defaults().get(for: Key<String>(defaultKeyNames.animationDate.rawValue)) ?? ""
        isShown = (animationDate == currentDate)
        return isShown
    }
    
    public static func clearAnimationDate() {
        Defaults().clear(Key<String>(defaultKeyNames.animationDate.rawValue))
    }
    
    public static func getPlacesKey() -> String {
        return Defaults().get(for: Key<String>(defaultKeyNames.placesKey.rawValue)) ?? "AIzaSyDI3wOr-xVySyqOppFkHJT1kETXAQlH8Ow"
    }
    
    public static func getDateFromStringWithFormat(_ string : String, _ format : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        let formattedDate: Date = dateFormatter.date(from: string) ?? Date()
        return formattedDate
       }
    public static func isAISDevice(deviceId:Int) -> Bool {
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
        let trackerDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        let imeiString:String = trackerDevice?.uniqueId ?? "0"
        
        return deviceProtocol.lowercased().contains("ais") || imeiString.lowercased().starts(with: "3515100")
    }
    
    public static func isGPSFixValid(device: TrackerDevicesMapperModel, position: TrackerPositionMapperModel) -> Bool {
        var isGPSFixValid:Bool = false
        let lastUpdate:Double = getDateForWithoutConversionFromString(device.lastUpdate ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ").timeIntervalSince1970 * 1000
        let fixTime:Double = getDateForWithoutConversionFromString(position.fixTime ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.'000+0000'").timeIntervalSince1970 * 1000
        let currentTime:Double = getCurrentMillis()
        
        var gapInMins:Int64 = 0
        
        if lastUpdate > fixTime {
            gapInMins = Int64((lastUpdate - fixTime) / 60000)
        } else {
            gapInMins = Int64((fixTime - lastUpdate) / 60000)
        }
        
        let currentGapInMins:Int64 = Int64((currentTime - lastUpdate) / 60000)
        
        if currentGapInMins <= 15 && gapInMins <= 15 {
            isGPSFixValid = true
        }
        
        return isGPSFixValid
    }
    
    public static func isDeviceBoltCam(deviceId:Int) -> Bool {
        
        let keyValue = "Position_" + "\(deviceId)"
        let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
        let deviceProtocol:String = devicePosition?.protocl ?? "jc"
        
        return deviceProtocol.lowercased() == "boltcam"
    }
    
    public static func getStreamingData(deviceId: Int, camera: String, streamState: Int) -> [String:Any] {
        var parameters:[String:Any] = [:]
        var attributes:[String:Any] = [:]
        var type:String = "custom"
        var data:String = ""
        
        let keyValue = "Position_" + "\(deviceId)"
        let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
        let deviceProtocol:String = devicePosition?.protocl ?? "jc"
        
        if deviceProtocol.lowercased() == "boltcam" {
            attributes["index"] = streamState
            data = camera
            type = "outputControl"
        } else {
            if streamState == streamStatus.start.rawValue {
                if camera == streamCamera.inside.rawValue {
                    data = "RTMP,ON,IN"
                } else {
                    data = "RTMP,ON,OUT"
                }
            } else {
                data = "RTMP,OFF"
            }
        }
        
        attributes["data"] = data
        
        parameters = ["description":"New\u{2026}",
                  "attributes":attributes,
                  "id": "0",
                  "type":type,
                  "deviceId":deviceId,
                  "textChannel":false]
        as [String : Any]
        
        return parameters
    }
    
    public static func getLastLoadUnloadForToday(deviceId: String) -> String {
        var loadUnloadList:[LoadUnloadPojo] = Defaults().get(for: Key<[LoadUnloadPojo]>(defaultKeyNames.savedLoadUnloadData.rawValue)) ?? []
        loadUnloadList.sort(by: { ($0.startTimestamp ?? "") as String > ($1.startTimestamp ?? "") as String })
        var loadUnloadId:String = ""
        let date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
        for item in loadUnloadList {
            let startDate = getDateForWithoutConversionFromString(item.startTimestamp ?? "", format: "yyyy-MM-dd HH:mm:ss")
            if item.deviceId == deviceId && startDate > date && item.endTimestamp != nil{
                loadUnloadId = item.uniqueId
                break
            }
        }
        
        return loadUnloadId
    }
    
    public static func formatCurrentDate(format: String) -> String {
        let currentDate = Date()
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.system
        dateString = dateString.appending(dateFormatter.string(from:currentDate as Date))
        return dateString
    }
    
    public static func clearAllDefaults() {
        Defaults().clear(Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
        Defaults().clear(Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
        Defaults().clear(Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.selectedBranch.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.selectedBranchName.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.branchForReport.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.branchNameForReport.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.vehicleListSortLabel.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.shouldClearMap.rawValue))
        
    }
    
    public static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public static func switchKey<T, U>(_ myDict: inout [T:U], fromKey: T, toKey: T) {
       if let entry = myDict.removeValue(forKey: fromKey) {
           myDict[toKey] = entry
       }
    }
    
    public static func getDeviceIdListForBranch (branchId: String) -> [Int] {
        var deviceIdList:[Int] = []
        if let usersHierarchy:UsersHerarchy = Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy")) {
            let adminUsers:[ParentUsers] = usersHierarchy.allUsers
            for admin in adminUsers {
                for child in admin.parentUsers {
                    let childDevices = child.childUserDevices?.devices ?? []
                    let deviceArray = childDevices.map { Int($0)!}
                    if branchId == admin.parentId {
                        deviceIdList.append(contentsOf: deviceArray)
                    } else {
                        if branchId == child.childId {
                            deviceIdList.append(contentsOf: deviceArray)
                        }
                    }
                }
            }
        }
        return deviceIdList
    }
    
    public static func getChildListForBranch (branchId: String) -> [String] {
        var childIdList:[String] = []
        if let usersHierarchy:UsersHerarchy = Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy")) {
            let adminUsers:[ParentUsers] = usersHierarchy.allUsers
            for admin in adminUsers {
                if branchId == admin.parentId {
                    for child in admin.parentUsers {
                        childIdList.append(child.childId ?? "0")
                    }
                }
            }
        }
        return childIdList
    }
    
    public static func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    public static func dynamicImgWithLabel(lblText:String , oldImage:UIImage , rotationAngel:CGFloat)->UIView{
        let customview = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 70))
        let img = UIImageView()
        let lbl = PaddingLabel()
        
        // for view
        customview.backgroundColor = .clear
        
        
        // for label
        lbl.textColor = .white
        lbl.layer.cornerRadius = 10
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 58/255, alpha: 0.5)
        lbl.text = lblText.trimmingCharacters(in: .whitespacesAndNewlines)
        lbl.font =  UIFont.systemFont(ofSize: 10)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.frame.size.width = lbl.intrinsicContentSize.width
        customview.addSubview(lbl)
        
        img.image = imageRotatedByDegrees(oldImage: oldImage , deg: rotationAngel)
        //img.transform  = img.transform.rotated(by: rotationAngel)
        img.contentMode = .bottom
        
        customview.addSubview(img)
        
        img.snp.makeConstraints { (make) in
            //            make.top.equalTo(lbl.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(oldImage.size.height)
        }
        
        lbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(img.snp.top).offset(-2)
            make.centerX.equalToSuperview()
        }
        
        
        return customview
    }
    public static func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public static func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    public static func textToImage(text: String, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.black
        let textFont = UIFont.systemFont(ofSize: 28, weight: .regular)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public static func reverseGeocoding(_ latiude: Double,_ longitude: Double) -> String {
        var addressText = ""
        let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latiude, longitude: longitude)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            addressText = lines.joined(separator: " ")
            print(addressText)
        }
        
        print(addressText)
        return addressText
    }
    
//    public static func getNotificationFilterDictionary() -> [String:String] {
//        var dictionary: [String: String] = ["":""]
//        if let model = Defaults().get(for: Key<FilterResponseModel>("FilterResponseModel")) {
//            
//            if let ignitionOn = model.data?.ignitionOn
//            {
//                dictionary["ignitionOn"] = ignitionOn
//            }
//            if let ignitionOff = model.data?.ignitionOff
//            {
//                dictionary["ignitionOff"] = ignitionOff
//            }
//            if let geofenceExit = model.data?.geofenceExit
//            {
//                dictionary["geofenceExit"] = geofenceExit
//            }
//            if let alarm_powerCut = model.data?.alarm_powerCut
//            {
//                dictionary["alarm_powerCut"] = alarm_powerCut
//            }
//            if let alarm_value = model.data?.alarm_value
//            {
//                dictionary["alarm_value"] = alarm_value
//            }
//            if let alarm_lowBattery = model.data?.alarm_lowBattery
//            {
//                dictionary["alarm_lowBattery"] = alarm_lowBattery
//            }
//            if let alarm = model.data?.alarm
//            {
//                dictionary["alarm"] = alarm
//            }
//            if let alarm_sos = model.data?.alarm_sos
//            {
//                dictionary["alarm_sos"] = alarm_sos
//            }
//            if let alarm_overspeed = model.data?.alarm_overspeed
//            {
//                dictionary["alarm_overspeed"] = alarm_overspeed
//            }
//            if let alarm_powerRestored = model.data?.alarm_powerRestored
//            {
//                dictionary["alarm_powerRestored"] = alarm_powerRestored
//            }
//            if let deviceOverspeed = model.data?.deviceOverspeed
//            {
//                dictionary["deviceOverspeed"] = deviceOverspeed
//            }
//            if let geofenceEnter = model.data?.geofenceEnter
//            {
//                dictionary["geofenceEnter"] = geofenceEnter
//            }
//            if let alarm_vibration = model.data?.alarm_vibration
//            {
//                dictionary["alarm_vibration"] = alarm_vibration
//            }
//            if let alarm_shock = model.data?.alarm_shock
//            {
//                dictionary["alarm_shock"] = alarm_shock
//            }
//            if let commandResult = model.data?.commandResult
//            {
//                dictionary["commandResult"] = commandResult
//            }
//            if let commandResult = model.data?.alarm_powerOff
//            {
//                dictionary["alarm_powerOff"] = commandResult
//            }
//            if let commandResult = model.data?.alarm_powerOn
//            {
//                dictionary["alarm_powerOn"] = commandResult
//            }
//        }
//        return dictionary
//    }
    
    public static func getExpiryFilteredList(_ currentDevices: [TrackerDevicesMapperModel]) -> [TrackerDevicesMapperModel] {
        let expiredIdList:[String] = Defaults().get(for: Key<[String]>("expired_vehicles_id")) ?? []
        var filteredList:[TrackerDevicesMapperModel] = []
        
        for item in currentDevices {
            let deviceId:String = "\(item.id ?? 0)"
            if  !expiredIdList.contains(deviceId) {
                filteredList.append(item)
            }
        }
        
        return filteredList
    }
    
    public static func getImageFromView(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    public static func convertUTCToIST(_ dateString: String,_ patternFrom: String,_ patternTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = patternFrom
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = patternTo
        if let date = formattedDate {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    public static func convertISTToUTC(_ dateString: String,_ patternFrom: String,_ patternTo: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = patternFrom
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = patternTo
        if let date = formattedDate {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    public static func getDefaultUTCDateImageMarker(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMMM dd, yyyy '@' hh:mm a"
        return dateFormatter.string(from: formattedDate ?? Date())
    }
    
    public static func getFormattedDateFromString (datetime:String, pattern:String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = pattern
        let newDate = dateFormatter.date(from: datetime)! as NSDate
        return newDate
    }
    
    public static func getFilteredMarkerListWithTimeLimit (markerList:[MarkerFirebaseModel], startTime:NSDate, endTime:NSDate, deviceId:String) -> [MarkerFirebaseModel] {
        var updatedList:[MarkerFirebaseModel] = []
        for firebaseModel in markerList {
            let firebaseDeviceId: String = firebaseModel.deviceId!
            let timeStamp : NSDate = getFormattedDateFromString(datetime: firebaseModel.timestamp!, pattern: "yyyy-MM-dd'T'HH:mm:ssZ")
            if  firebaseDeviceId == deviceId
                && (timeStamp.timeIntervalSince1970 >= startTime.timeIntervalSince1970)
                && (timeStamp.timeIntervalSince1970 <= endTime.timeIntervalSince1970) {
                updatedList.append(firebaseModel)
            }
        }
        
        return updatedList
    }
    
    public static func getFilteredMarkerList(markerList:[MarkerFirebaseModel], deviceId:String) -> [MarkerFirebaseModel] {
        var updatedList:[MarkerFirebaseModel] = []
        for firebaseModel in markerList {
            let firebaseDeviceId: String = firebaseModel.deviceId!
            if  firebaseDeviceId == deviceId {
                updatedList.append(firebaseModel)
            }
        }
        
        return updatedList
    }
    
    public static func getFormattedData(date:NSDate) -> String {
        var dateString = "Last Updated at: "
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        dateFormatter.timeZone = NSTimeZone.system
        dateString = dateString.appending(dateFormatter.string(from:date as Date))
        return dateString
    }
    
    public static func getFormattedDataWatch(date:NSDate) -> String {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = NSTimeZone.system
        dateString = dateString.appending(dateFormatter.string(from:date as Date))
        return dateString
    }
    
    public static func getFormattedDataReportVC(date:NSDate) -> String {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.system
        dateString = dateString.appending(dateFormatter.string(from:date as Date))
        return dateString
    }
    
    
    
    public static func convertDateToString(date:Date, format:String, toUTC:Bool) -> String {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if toUTC {
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        } else {
            dateFormatter.timeZone = TimeZone.current
        }
        dateString = dateString.appending(dateFormatter.string(from:date))
        return dateString
    }
    
    public static func getFormattedHistory(date:NSDate) -> String {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:s"
        dateFormatter.timeZone = NSTimeZone.system
        dateString = dateString.appending(dateFormatter.string(from:date as Date))
        return dateString
    }
    
    
    public static func getFormattedDataReportForLabel(date:NSDate) -> String {
        var dateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.timeZone = NSTimeZone.system
        dateString = dateString.appending(dateFormatter.string(from:date as Date))
        return dateString
    }
    
    
    public static func getFormattedDate(date:NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = NSTimeZone.system
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    public static func getFormattedDate(date:NSDate, format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.system
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    public static func getFormattedDate(date:NSDate, format:String, zone:TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = zone
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    public static func getFormattedDate(date:Date, format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    public static func getFormattedDateWithoutConversion(date:Date, format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from:date)
        return dateString
    }
    
    public static func getFormattedTime(date:NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone.system
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    public static func getFormattedTimeWatch(date:NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm.ss"
        dateFormatter.timeZone = NSTimeZone.system
        let dateString = dateFormatter.string(from:date as Date)
        return dateString
    }
    
    public static func getDateDefaultUTC(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MMM-yy hh:mm a"
        return dateFormatter.string(from: formattedDate!)
    }
    
    
    public static func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    public static func validate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    public static func myMobileNumberValidate(_ number: String) -> Bool {
        let numberRegEx: String = "[0-9]{10}"
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        if mobileNumberPred.evaluate(with: number) {
            return true
        }
        return false
    }
    
    //    func getTrackerFrom(ID:String,trackerList:[RCAllTrackerDetailModel]) -> RCAllTrackerDetailModel {
    //        for tracker in trackerList {
    //            if tracker.deviceid == ID {
    //                return tracker
    //            }
    //        }
    //      return trackerList.last!
    //    }
    
    public static func getDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "dd-MMM-yy hh:mm a"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        return formattedDate ?? Date()
    }
    
    public static func getDateFrom(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:s"
        let formattedDate: Date? = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    public static func getDateFromTwo(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    
    public static func getDateFromStringFormat2(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate: Date? = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    
    public static func getDateFromString(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date = dateFormatter.date(from: string) ?? Date()
        return formattedDate
    }
    public static  func getDateDiff(start: Date, end: Date) -> Int  {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)
        let seconds = dateComponents.second
        return Int(seconds!)
    }
    
    
    public static func getStringDateFromString(_ string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: string)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MMM-yy"
        return dateFormatter.string(from: formattedDate!)
        //        return formattedDate!
    }
    
    public static func getStringDateFromStringDsh(_ string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: string)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: formattedDate!)
        //        return formattedDate!
    }
    
    
    public static func getStringDateFromString(_ string: String, informat: String, outformat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = informat
        let formattedDate: Date? = dateFormatter.date(from: string)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = outformat
        return dateFormatter.string(from: formattedDate!)
    }
    
    public static func getDateUTCToLocalFromString(_ string: String, format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = format
        var formattedDate: Date? = dateFormatter.date(from: string)
        let formattedDateString: String? = dateFormatter.string(from: formattedDate!)
        
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = format //"yyyy-MM-dd HH:mm:ss"
        formattedDate = dateFormatter.date(from: formattedDateString!)
        return formattedDate ?? Date()
    }
    
    public static func getDefaultUTCDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MMM-yy hh:mm a"
        return dateFormatter.date(from: dateFormatter.string(from: formattedDate ?? Date())) ?? Date()
    }
    
    public static func getDefaultUTCDateNotification(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        return dateFormatter.string(from: formattedDate ?? Date())
    }
    
    
    public static func getDefaultUTCDateNotificationNormal(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate: Date? = dateFormatter.date(from: dateString)
        
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        return dateFormatter.string(from: formattedDate ?? Date())
    }
    
    
    
    public static func getDateChinaToLocalFromString(_ string: String, format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        dateFormatter.dateFormat = format
        let formattedDate: Date? = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    public static func getDateForWithoutConversion(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        let formattedDate = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    public static func getDateWithoutConversionFormat(_ string: String, _ format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let formattedDate = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    public static func getDateForWithoutConversionFromString(_ string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)!
        let formattedDate = dateFormatter.date(from: string)
        return formattedDate ?? Date()
    }
    
    
    public static func getDateFor(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        let formattedDate = dateFormatter.date(from: string)
        //return default date
        return formattedDate ?? Date()
        
    }
    
    public static func getFollowerDateFor(_ string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.system
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.date(from: string)
        //return default date
        return formattedDate ?? Date()
        
    }
    
    public static func getCurrentMillis() -> Double {
        return Double(Date().timeIntervalSince1970 * 1000)
    }
    
    public static func uiColorFromHex(rgbValue: Int) -> UIColor {
        
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    
    public static func popUpView() -> Presentr {
        
        let presenter: Presentr = {
            let customPresenter = Presentr(presentationType:.custom(width:ModalSize.custom(size:Float((UIApplication.shared.keyWindow?.bounds.size.width)! * 0.9)), height:ModalSize.custom(size:Float((UIApplication.shared.keyWindow?.bounds.size.height)! * 0.5)), center:ModalCenterPosition.center))
            customPresenter.dismissOnSwipe = false
            customPresenter.roundCorners = false
            customPresenter.blurBackground = false
            customPresenter.backgroundOpacity = 0.5
            customPresenter.transitionType = nil
            customPresenter.dismissTransitionType = nil
            customPresenter.dismissAnimated = true
            return customPresenter
        }()
        return presenter
    }
    
    public static func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) " + "years ago".toLocalize
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 " + "year ago".toLocalize
            } else {
                return "Last year".toLocalize
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) " + "months ago".toLocalize
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 " + "month ago".toLocalize
            } else {
                return "Last month".toLocalize
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) " + "weeks ago".toLocalize
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 " + "week ago".toLocalize
            } else {
                return "Last week".toLocalize
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) " + "days ago".toLocalize
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 " + "day ago".toLocalize
            } else {
                return "Yesterday".toLocalize
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) " + "hours ago".toLocalize
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 " + "hour ago".toLocalize
            } else {
                return "An hour ago".toLocalize
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) " + "minutes ago".toLocalize
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 " + "minute ago".toLocalize
            } else {
                return "A minute ago".toLocalize
            }
        } else if (components.second! >= 30) {
            return "\(components.second!) " + "seconds ago".toLocalize
        } else {
            return "Just now".toLocalize
        }
        
    }
    
    
    public static func timeAgoSinceDateInSecond(_ date:Date, numericDates:Bool = false) -> Int? {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        return components.second
    }
    
    
    public static func newtimeAgoSinceDateWithoutSecond(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second,.minute,.hour,.day,.year]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) Yrs ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 Yr ago"
            } else {
                return "2 Yr ago"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) Days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 Day ago"
            } else {
                return "2 Days ago"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) Hrs ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 Hr ago"
            } else {
                return "An Hr ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) Mins ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 Min ago"
            } else {
                return "A Min ago"
            }
        } else if (components.second! >= 30) {
            return "0 Min ago"
        } else {
            return "0 Min ago"
        }
        
    }
    public static func newtimeSinceDateWithoutSecond(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.second,.minute,.hour,.day,.year]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) Yrs"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 Yr"
            } else {
                return "2 Yr"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) Days"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 Day"
            } else {
                return "2 Days"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) Hrs"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 Hr"
            } else {
                return "An Hr"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) Mins"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 Min"
            } else {
                return "A Min"
            }
        } else if (components.second! >= 30) {
            return "0 Min"
        } else {
            return "0 Min"
        }
        
    }
    
    public static func DaysAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) Yrs ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 Yr ago"
            } else {
                return "2 Yrs ago"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) Days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 Day ago"
            } else {
                return "2 Days ago"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) Hrs ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 Hr ago"
            } else {
                return "An Hr ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) Mins ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 Min ago"
            } else {
                return "A Min ago"
            }
        } else if (components.second! >= 30) {
            return "\(components.second!) Secs ago"
        } else {
            return "\(components.second!) Secs ago"
        }
    }
    
    public static func newtimeSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) Yrs"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 Yr"
            } else {
                return "2 Yrs"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) Days"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 Day"
            } else {
                return "2 Days"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) Hrs"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 Hr"
            } else {
                return "An Hr"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) Mins"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 Min"
            } else {
                return "A Min"
            }
        } else if (components.second! >= 30) {
            return "\(components.second!) Secs"
        } else {
            return "\(components.second!) Secs"
        }
    }
    
    
    public static func newtimeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) Yrs ago"
        } else if (components.year! == 1){
            if (numericDates){
                return "1 Yr ago"
            } else {
                return "2 Yrs ago"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) Days ago"
        } else if (components.day! == 1){
            if (numericDates){
                return "1 Day ago"
            } else {
                return "2 Days ago"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) Hrs ago"
        } else if (components.hour! == 1){
            if (numericDates){
                return "1 Hr ago"
            } else {
                return "An Hr ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) Mins ago"
        } else if (components.minute! == 1){
            if (numericDates){
                return "1 Min ago"
            } else {
                return "A Min ago"
            }
        } else if (components.second! >= 30) {
            return "\(components.second!) Secs ago"
        } else {
            return "\(components.second!) Secs ago"
        }
    }
    
    
    public static func convertTime(miliseconds: Int) -> String {
        
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var secondsTemp: Int = 0
        var minutesTemp: Int = 0
        var hoursTemp: Int = 0
        
        if miliseconds < 1000 {
            return "0 Sec"
        } else if miliseconds < 1000 * 60 {
            seconds = miliseconds / 1000
            return "\(seconds) Sec"
        } else if miliseconds < 1000 * 60 * 60 {
            secondsTemp = miliseconds / 1000
            minutes = secondsTemp / 60
            seconds = (miliseconds - minutes * 60 * 1000) / 1000
            if minutes > 1 {
                return "\(minutes) Mins"
            } else {
                return "\(minutes) Min"
            }
        } else if miliseconds < 1000 * 60 * 60 * 24 {
            minutesTemp = miliseconds / 1000 / 60
            hours = minutesTemp / 60
            minutes = (miliseconds - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(hours) Hr \(minutes) Min"
        } else {
            hoursTemp = miliseconds / 1000 / 60 / 60
            days = hoursTemp / 24
            hours = (miliseconds - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            minutes = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(days) Days \(hours) Hr"
        }
    }
    
    public static func convertTimeSheet(miliseconds: Int) -> String {
        
        var seconds: Int = 0
        var minutes: Int = 0
        var hours: Int = 0
        var days: Int = 0
        var secondsTemp: Int = 0
        var minutesTemp: Int = 0
        var hoursTemp: Int = 0
        
        if miliseconds < 1000 {
            return "0min"
        } else if miliseconds < 1000 * 60 {
            seconds = miliseconds / 1000
            return "0min"
        } else if miliseconds < 1000 * 60 * 60 {
            secondsTemp = miliseconds / 1000
            minutes = secondsTemp / 60
            seconds = (miliseconds - minutes * 60 * 1000) / 1000
            if minutes > 1 {
                return "\(minutes)mins"
            } else {
                return "\(minutes)min"
            }
        } else if miliseconds < 1000 * 60 * 60 * 24 {
            minutesTemp = miliseconds / 1000 / 60
            hours = minutesTemp / 60
            minutes = (miliseconds - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(hours)hr \(minutes)min"
        } else {
            hoursTemp = miliseconds / 1000 / 60 / 60
            days = hoursTemp / 24
            hours = (miliseconds - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60
            minutes = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60
            seconds = (miliseconds - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000
            return "\(days)days \(hours)hr"
        }
    }
    
    public static func convertSpeed(speed: Float) -> String {
        //        let returnSpeed:Float = Float(speed)!
        return "\(roundf(speed * 1.852))" + "kmph"
    }
    
    public static func convertSpeedInt(speed: Float) -> String {
        return "\(Int(roundf(speed * 1.852)))"
    }
    
    public static func convertDistance(distance: Double) -> String {
        //        let returndistance:Float = Float(distance)!
        return "\((distance / 1000).rounded(toPlaces: 2))" + "km"
    }
    
    public static func convertDistanceWithoutRoundOff(distance: Double) -> String {
        return "\((distance / 1000).rounded(toPlaces: 2))" + "km"
    }
    
    public static func convertDist(distance: Double) -> String {
        return "\((distance / 1000).rounded(toPlaces: 2))"
    }
    
    public static func getStringMatchRegex (pattern: String, str: String) -> Array<String> {
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            let nsstr = str as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : Array<String> = Array<String>()
            
            regex.enumerateMatches(in: str, options: [], range: all) {
                (result : NSTextCheckingResult!, _, _) in
                matches.append(nsstr.substring(with: result.range))
            }
            return matches
        }catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}


extension Dictionary where Key: Hashable, Value: Any {
    func getValue(forKeyPath components : Array<Any>) -> Any? {
        var comps = components;
        let key = comps.remove(at: 0)
        if let k = key as? Key {
            if(comps.count == 0) {
                return self[k]
            }
            if let v = self[k] as? Dictionary<AnyHashable,Any> {
                return v.getValue(forKeyPath : comps)
            }
        }
        return nil
    }
}

extension String {
    var fullRange: Range<String.Index> {
        return self.startIndex ..< self.endIndex
    }
}

extension Array {
    mutating func removeObject<T>(obj: T) where T : Equatable {
        self = self.filter({$0 as? T != obj})
    }
    
}

extension NSMutableAttributedString {
    
    public func setAsLink( _ textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

class InsetLabel: UILabel {
    let topInset = CGFloat(0)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(20)
    let rightInset = CGFloat(20)
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

class RCLabel : UILabel {
    
    var textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}



extension String{
    var toLocalize:String{
        return NSLocalizedString(self, comment: "")
    }
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    
    func downloadedForWatch(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, token: String) {
        contentMode = mode
        
        
        
        // var request = URLRequest(url: url)
        
        //        let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: cookieURL)!)
        //        let headers = HTTPCookie.requestHeaderFields(with: cookies!)
        //        var request  = URLRequest(url: url)
        // request.allHTTPHeaderFields=headers
        
        let cookieObject = Defaults().get(for: Key<String>("CookieValue"))
        
        //        request.setValue(cookieObject, forHTTPHeaderField: "Cookie")
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Cookie": "JSESSIONID=" + cookieObject!
        ]
        
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers as! [String : String]
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print(json)
                } catch {
                    print(error)
                }
                
            }
        })
        
        dataTask.resume()
        
        
        //        URLSession.shared.dataTask(with: request) { data, response, error in
        //            print("response = \(response)")
        //            print("data = \(data)")
        //            guard
        //                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        //               // let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        //                let data = data, error == nil,
        //                let image = UIImage(data: data)
        //                else { return }
        //            DispatchQueue.main.async() {
        //                self.image = image
        //            }
        //            }.resume()
    }
    
    
    
    
    func downloadedForWatch(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, token: String) {
        guard let url = URL(string: link) else { return }
        downloadedForWatch(from: url, contentMode: mode, token: token)
    }
}

extension Data{
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension Date {
    mutating func changeDays(by days: Int)  {
        self = Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    
    func years(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: sinceDate, to: self).year
    }
    
    func months(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: sinceDate, to: self).month
    }
    
    func days(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: sinceDate, to: self).day
    }
    
    func hours(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: sinceDate, to: self).hour
    }
    
    func minutes(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: sinceDate, to: self).minute
    }
    
    func seconds(sinceDate: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: sinceDate, to: self).second
    }
    
    
}


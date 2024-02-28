//
//  RCBaseClient.swift
//  AlamofireDemo
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import DefaultsKit
import KeychainAccess

let appname = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String

class RCRequestRetrier: RequestRetrier {
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?) -> Void
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let serverResponse = request.response, serverResponse.statusCode == 412 {
            requestsToRetry.append(completion)
            if !isRefreshing {
                refresh { [weak self] succeeded, accessToken in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    weakSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    private func refresh(completion: @escaping RefreshCompletion) -> Void {
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        //        RCRouterClient.shared.request(URL: RCRouter.refresh("8380993993"), loadingMessage: "", success: { [weak self] (response: DataResponse<RCTokenModel>) in
        //            guard let weakSelf = self else {
        //                return
        //            }
        //            if let model = response.result.value {
        //                if model.status {
        //                    let keyChain = KeychainWrapper()
        //                    keyChain.mySetObject(model.token, forKey: kSecValueData)
        //                    keyChain.writeToKeychain()
        //                    completion(true, model.token)
        //                } else {
        //                    completion(false, nil)
        //                }
        //                weakSelf.isRefreshing = false
        //            }
        //
        //        }) { (error) in
        //            completion(false, nil)
        //        }
    }
    
}

enum RCRouter: URLRequestConvertible {
    //    #if DEBUG
    //    static let baseURLString = "https://bolt.roadcast.co.in/api/v1/index.php/"
    //    static let baseAPIURLString = "https://boltapi.roadcast.co.in/api/"
    //    static let baseImageURLString = "https://boltapi.roadcast.co.in"
    //    static let parkingScheduleURL = "https://bolt.roadcast.co.in:8300"
    //    static let multipleShareURL = "https://bolt.roadcast.co.in/track/device_share.php?key="
    //    static let singleShareURL = "https://bolt.roadcast.co.in/share?id="
    //    #else
    //    static let baseURLString = "https://bolt.roadcast.co.in/api/v1/index.php/"
    //    static let baseAPIURLString = "https://boltapi.roadcast.co.in/api/"
    //    static let baseImageURLString = "https://boltapi.roadcast.co.in"
    //    static let parkingScheduleURL = "https://bolt.roadcast.co.in:8300"
    //    static let multipleShareURL = "https://bolt.roadcast.co.in/track/device_share.php?key="
    //    static let singleShareURL = "https://bolt.roadcast.co.in/share?id="
    //    #endif
    //https://track.roadcast.co.in/api/v1/index.php/route/54152/2022-06-22%2022:27:00/2022-06-23%2009:35:21/1 } { Status Code: 200, Headers {
#if DEBUG
    static let baseURLString = "https://track.roadcast.co.in/api/v1/index.php/"
    static let baseAPIURLString = "https://tracapi.roadcast.co.in/api/"
    static let baseImageURLString = "https://tracapi.roadcast.co.in"
    static let parkingScheduleURL = "https://track.roadcast.co.in:8300"
    static let multipleShareURL = "https://track.roadcast.co.in/v1/auth/live?token="
    static let singleShareURL = "https://track.roadcast.co.in/share?id="
    static let pyBaseURLString = "https://api-track-py.roadcast.co.in/api/v1/auth/"
    static let pathURL = "https://routing.roadcast.co.in/ors/v2/directions/"
#else
    static let baseURLString = "https://track.roadcast.co.in/api/v1/index.php/"
    static let baseAPIURLString = "https://tracapi.roadcast.co.in/api/"
    static let baseImageURLString = "https://tracapi.roadcast.co.in"
    static let parkingScheduleURL = "https://track.roadcast.co.in:8300"
    static let multipleShareURL = "https://track.roadcast.co.in/v1/auth/live?token="
    static let singleShareURL = "https://track.roadcast.co.in/share?id="
    static let pyBaseURLString = "https://api-track-py.roadcast.co.in/api/v1/auth/"
    static let pathURL = "https://routing.roadcast.co.in/ors/v2/directions/"
#endif
    
    case playbackRoute(String,String,String,String)
    case login(Parameters)
    case register(Parameters)
    case events(Parameters)
    case session(Parameters)
    case sendOTP(String,String)
    case forgetPassword(Parameters)
    case resetPassword(Parameters)
    case devices
    case positions
    case addDevice(Parameters)
    case checkUser(String,String)
    case getSelDevicePath(Int)
    case getSelDeviceDailyPath(Int)
    case getReport(String, String, String)
    case getReportRange(String, String, String, String)
    case getGeofence(Parameters)
    case linkGeofence(Int, Int)
    case unlinkGeofence(Int, Int)
    case updateGeofence(Int, Parameters)
    case deleteGeofence(Int)
    case getReportPath(Int, String, String)
    case owlMode(Parameters)
    case createGeofence(Parameters)
    case sendCommand(Parameters)
    case followerPath(Int, String, String)
    case getNotifications(String)
    case getOlderNotifications(String,String)
    case usersHierarchy(Int)
    case updateDevices(Int, Parameters)
    case parkingMode(Parameters)
    case UpdateUseDetails(String,Parameters)
    case loginInfo(Int)
    case lastActivationTime(Int)
    case singleVehicleGeoFence(Parameters)
    case deleteSession
    case getDeviceDetails(String)
    case getUserImageData(String, String)
    case putCarsData(String, Parameters)
    case syncVehicleModes(String)
    case devicePopUpDetails(String, String)
    case getParkingModeSchedulerDetails()
    case putParkingModeSchedulerDetails(String, Parameters)
    case postParkingModeSchedulerDetails([Parameters])
    case postFuelDetails(Parameters)
    case getFuelDetails
    case liveStreaming(Parameters)
    case getMonthlyDistance(String,String,String)
    case getPaymentRates                               //
    case postPaymentOrderId(Parameters)                //
    case postPaymentSignature(Parameters)
    case getAllPaymentHistory
    case getCallCredits(String)
    case sendOverspeedAlert(Parameters)
    case getPOIInfo
    case addPOIInfo(Parameters)
    case updatePOIInfo(String, Parameters)
    case googleAssistent(Parameters)
    case getExpiredVehicles
    case notificationalert
    case onnotificationfilter(Parameters)
    case notificationdelete(String,String)
    case getReachabilityReports(String,String,String)
    case saveReachabilitReport(Parameters)
    case updateACDoorSirenAlarm(String, Parameters)
    case loadUnloadRequest(Parameters)
    case getShareURL(Parameters)
    case getTempaltes(String)
    case getTempalteDevices(String)
    case addTemplateData(Parameters)
    case updateTemplateData(String,Parameters)
    case pyLogin(Parameters)
    case pyNotificationsGet()
    case getJWTToken(Parameters)
    case deleteUser(Int)
    case taskStatusRequest(String)
    //    case getDeviceReq(String)
    //    case reports
    //    case postions
    //
    //    case getTaskStatus(Parameters)
    case getParkingData
    case postParkingData(Parameters)
    case patchParkingData(String,Parameters)
    //
    //
    case pyGetNotif
    case getOTP(String)
    case verifyOTP(Parameters)
    case getCompanyConfig
    case getPathBetweenPoints(Parameters)
    case getDeviceDrivers(String)
    case getCallToken(Parameters)
    case getDeviceReq(String)
    case getPyReports(String,Parameters)
//      case pyPostNotif(Parameters)
      case userConfig(String)
//      case updateDeviceNew(Parameters)
//      case patchUserDetails(String,Parameters)
//    case getPlaybackPath(Parameters)
    
    case updateProfileImage(String,Parameters)
    case deletePOIInfo(String)
    case pyPostNotif(Parameters)
    
    var method: Alamofire.HTTPMethod {
        switch self {
            
        case.deleteUser(_):
            return.get
        case.taskStatusRequest(_):
            return.get
            
        case .getJWTToken:
            return .post
            //        case .getDeviceReq:
            //            return .get
            //        case .getPlaybackPath(_):
            //            return .get
            //        case .reports:
            //            return .get
            //        case .postions:
            //            return .get
        case .playbackRoute:
            return .get
        case .login:
            return .post
        case .register:
            return .post
        case .session:
            return .post
        case .sendOTP:
            return .get
        case .forgetPassword:
            return .post
        case .resetPassword:
            return .post
        case .events:
            return .get
        case .devices:
            return .get
        case .positions:
            return .get
        case .addDevice:
            return .post
        case .checkUser:
            return .get
        case .getSelDevicePath:
            return .get
        case .getSelDeviceDailyPath:
            return .get
        case .getReport:
            return .get
        case .getReportRange:
            return .get
        case .getGeofence:
            return .get
        case .linkGeofence:
            return .post
        case .unlinkGeofence:
            return .delete
        case .notificationdelete:
            return .delete
        case .updateGeofence:
            return .put
        case .deleteGeofence:
            return .delete
        case .getReportPath:
            return .get
        case .owlMode:
            return .post
        case .createGeofence:
            return .post
        case .sendCommand:
            return .post
        case .followerPath:
            return .get
        case .getNotifications:
            return .get
        case .getOlderNotifications:
            return .get
        case .usersHierarchy:
            return .get
        case .updateDevices:
            return .put
        case .parkingMode:
            return .post
        case .UpdateUseDetails:
            return .put
        case .loginInfo:
            return .post
        case .lastActivationTime:
            return .get
        case .singleVehicleGeoFence:
            return .get
        case .deleteSession:
            return .delete
        case .getDeviceDetails:
            return .get
        case .getUserImageData:
            return .get
        case .putCarsData:
            return .put
        case .syncVehicleModes:
            return .get
        case .devicePopUpDetails:
            return .get
        case .getParkingModeSchedulerDetails:
            return .get
        case .putParkingModeSchedulerDetails:
            return .patch
        case .postParkingModeSchedulerDetails:
            return .post
            
        case .liveStreaming:
            return .post
        case .getFuelDetails:
            return .get
        case .postFuelDetails:
            return .post
        case .getMonthlyDistance:
            return .get
            
        case .getPaymentRates:
            return .get
            
        case .postPaymentOrderId:
            return .post
            
        case .postPaymentSignature:
            return .post
            
        case .getAllPaymentHistory:
            return .get
            
        case .getCallCredits:
            return .get
            
        case .sendOverspeedAlert:
            return .post
            
        case .getPOIInfo:
            return .get
        case .addPOIInfo:
            return .post
        case .updatePOIInfo:
            return .put
        case .deletePOIInfo:
            return .delete
        case .googleAssistent:
            return .patch
        case .getExpiredVehicles:
            return .get
        case .notificationalert:
            return .get
        case .onnotificationfilter:
            return .post
        case .getReachabilityReports:
            return .get
        case .saveReachabilitReport:
            return .post
        case .updateACDoorSirenAlarm:
            return .put
        case .loadUnloadRequest:
            return .post
        case .getShareURL:
            return .get
        case .getTempaltes:
            return .get
        case .getTempalteDevices:
            return .get
        case .addTemplateData:
            return .post
        case .updateTemplateData:
            return .put
        case .pyLogin(_):
            return .post
        case .pyNotificationsGet():
            return .get
        case .getParkingData:
            return .get
            //
            //        case .:
            //              return .get
        case .postParkingData(_):
            return .post
        case .patchParkingData(_,_):
            return .patch
        case .pyGetNotif:
            return.get
        case .verifyOTP(_):
            return .post
        case .getOTP(_):
            return .get
        case .getCompanyConfig:
            return .get
        case .getPathBetweenPoints(_):
            return .post
        case .getDeviceDrivers(_):
            return .get
        case .getCallToken(_):
            return .post
        case .getDeviceReq:
            return .get
        case .getPyReports(_, _):
            return .get
        case .userConfig(_):
            return .get
        case .updateProfileImage(_, _):
            return .patch
        case .pyPostNotif(_):
            return .post
            
        }
    }
    
    var path: String {
        switch self {
        case.deleteUser(let userId):
            return "delete_user?user_id=\(userId)"
        case.taskStatusRequest(let taskId):
            return "get_task_status?task_id=\(taskId)"
        case .login(_):
            return "login"
        case .register(_):
            return "register"//+appname
        case .session(_):
            return "session"
        case .sendOTP(let countryCode, let mobile):
            return "sendOTP/"+countryCode+"/"+mobile+"/"+appname
        case .forgetPassword(_):
            return "accounts/forgotPassword"
        case .resetPassword(_):
            return "accounts/resetPassword"
        case .events(_):
            return "reports/events"
        case .devices:
            return "devices"
        case .notificationalert:
            return "notificationSetting"
        case .positions:
            return "positions"
        case .addDevice(_):
            return "add_device"
        case .checkUser(let countryCode, let mobile):
            return "access/"+countryCode+"/"+mobile+"/"+appname
        case .getSelDevicePath(let deviceId):
            return "path/"+"\(deviceId)"
        case .getSelDeviceDailyPath(let deviceId):
            return "path/"+"\(deviceId)"+"/1"
        case .getReport(let report, let deviceId, let reportDate):
            return "reports/"+report+"/\(deviceId)"+"/"+reportDate+"/"+reportDate
            
        case .getReportRange(let report, let deviceId, let reportStartDate, let reportEnddate):
            
            return "reports/"+report+"/\(deviceId)"+"/"+reportStartDate+"/"+reportEnddate
            
        case .getGeofence(_):
            return "geofences"
        case .notificationdelete(let id, let type):
            return "notificationSetting/" + type + "/" + id
        case .linkGeofence(_, _), .unlinkGeofence(_, _):
            return "permissions"
        case .updateGeofence(let id, _):
            return "geofences/"+"\(id)"
        case .deleteGeofence(let id):
            return "geofences/"+"\(id)"
        case .getReportPath(let deviceId, let from, let to):
            return "route/"+"\(deviceId)"+"/"+from+"/"+to
        case .owlMode(_):
            return "owlMode"
        case .createGeofence(_):
            return "geofences"
        case .sendCommand(_):
            return "commands/send"
        case .followerPath(let deviceId, let from, let to):
            return "followerPath/"+"\(deviceId)"+"/"+from+"/"+to
        case .getNotifications(let deviceIds):
            return "reports/events/"+"\(deviceIds)"
        case .getOlderNotifications(let deviceIds, let lastNotiId):
            return "reports/events/\(deviceIds)?before=\(lastNotiId)"
        case .usersHierarchy(let deviceId):
            return "users/hierarchy/"+"\(deviceId)"
        case .updateDevices(let deviceId, _):
            return "devices/\(deviceId)"
        case .parkingMode(_):
            return "parkingMode"
        case .UpdateUseDetails(let id,_):
            return "users/\(id)"
        case .loginInfo(let id):
            return "loginInfo/\(id)"
        case .lastActivationTime(let id):
            return "ignitionOff/\(id)"
        case .singleVehicleGeoFence(_):
            return "geofences"
        case .deleteSession:
            return "session"
        case .getDeviceDetails(let deviceId):
            return "getDevicesWithExtraFields?userId=\(deviceId)"
        case .getUserImageData(let userId, let imageName):
            return "userDocs/\(userId)/\(imageName)"
        case .putCarsData(let deviceId, _):
            return "devices/\(deviceId)?extraFields=true"
        case .syncVehicleModes(let userID):
            return "vehicleModes/\(userID)"
        case .devicePopUpDetails(let deviceID, let date):
            return "devicePopupDetails/\(deviceID)/\(date)"
        case .getParkingModeSchedulerDetails():
            return "parking_mode"
        case .putParkingModeSchedulerDetails(let deviceID, _):
            return "parking_mode/\(deviceID)"
        case .postParkingModeSchedulerDetails(_):
            return "parking_mode"
            
        case .liveStreaming(_):
            return "commands/send"
        case .onnotificationfilter(_):
            return "notificationSetting"
            
        case .playbackRoute(let deviceId, let dateFrom, let dateTo, let duration):
            return "route"+"/\(deviceId)"+"/"+dateFrom+"/"+dateTo+"/"+duration
        case .getFuelDetails:
            return "deviceFuel"
            
        case .postFuelDetails(_):
            return "deviceFuel"
            
        case .getMonthlyDistance(let deviceIDArrayString, let startDate, let endDate):
            return "reports/monthly_dist/\(deviceIDArrayString)/\(startDate)/\(endDate)"
            
        case .getPaymentRates:
          return "payment_rates"
          
        case .postPaymentSignature(_):
          return "verify_razor_payment"
          
        case .postPaymentOrderId(_):
          return "payment_orders"
          
        case .getAllPaymentHistory:
            return "payment_orders"
            
        case .getCallCredits(let userId):
            return "userConfig/\(userId)"
            
        case .sendOverspeedAlert(_):
            return "updateSpeedLimit"
            
        case .getPOIInfo,.addPOIInfo(_):
            return "poi"
        case .updatePOIInfo(let id, _),.deletePOIInfo(let id):
            return "poi/\(id)"
        case .googleAssistent(_):
            return "updateUser"
        case .getExpiredVehicles:
            return "expiredDevices"
        case .getReachabilityReports(let deviceId, let reportStartDate, let reportEnddate):
            return "reachabilityAlerts/"+"\(deviceId)"+"/"+reportStartDate+"/"+reportEnddate
        case .saveReachabilitReport(_):
            return "reachabilityAlerts"
        case .updateACDoorSirenAlarm(let userId, _):
            return "config/\(userId)"
        case .loadUnloadRequest(_):
            return "/tms/loading"
        case .getShareURL(_):
            return "get_public_tracking_token"
        case .getTempaltes(let userId):
            return "config/alertTemplates/app/\(userId)"
        case .getTempalteDevices(let tempId):
            return "config/alertTemplates/app/device/\(tempId)"
        case .addTemplateData(_):
            return "config/alertTemplates"
        case .updateTemplateData(let deviceId , _):
            return "config/alertTemplates/\(deviceId)"
        case .pyLogin(_):
            return "login"
        case .pyNotificationsGet():
            return "last_500_user_events?days=10&limit=200"
        case .getJWTToken(_):
            return "login"
            //        case .getDeviceReq(_):
            //            return "add_device"
            //
        case .getParkingData:
            return "parking_mode"
        case .postParkingData(_):
            return "parking_mode"
        case .patchParkingData(let id,_):
            return "parking_mode/\(id)"
        case .pyGetNotif:
            return "get_deprecated_notification_status"
        case .getOTP(let username):
            return "register_user?username=\(username)&company_id=\(companyId)"
        case .verifyOTP(let otp):
            return "register_user"
        case .getCompanyConfig:
            return "about_company_links?company_id=\(companyId)"
        case .getPathBetweenPoints(_):
            return "driving-car/geojson"
        case .getDeviceDrivers(let deviceId):
            return "get_device_driver/\(deviceId)"
        case .getCallToken(_):
            return "pushy_device_token"
        case .getDeviceReq(_):
            return "add_device"
        case .getPyReports(let type, _):
            return "reports/\(type)"
        case .userConfig(let userId):
            return "user_config?user_id_equal=\(userId)"
        case .updateProfileImage(let configId, _):
            return "user_config/\(configId)"
        case .pyPostNotif(_):
            return "update_deprecated_notification_status"
      
        }
        
    }
    
    var baseURLPath: String {
        switch self {
          
        case .login(_), .register(_), .checkUser(_, _), .sendOTP(_, _), .resetPassword(_), .forgetPassword(_), .getSelDevicePath(_), .getSelDeviceDailyPath(_), .getReport(_, _, _),
             .getReportRange(_, _, _, _),.getReportPath(_, _, _), .owlMode(_), .followerPath(_, _, _),
             .getNotifications(_), .usersHierarchy(_), .updateDevices(_, _),.parkingMode(_),.UpdateUseDetails(_, _),
             .loginInfo(_),.lastActivationTime(_), .getDeviceDetails(_), .getUserImageData(_, _),
             .putCarsData(_,_), .syncVehicleModes(_), .playbackRoute(_, _, _, _),.devicePopUpDetails(_, _),.getMonthlyDistance(_, _,_),
             .postFuelDetails(_),.getCallCredits(_),.sendOverspeedAlert(_),.getFuelDetails,
             .getPOIInfo,.addPOIInfo(_),.updatePOIInfo(_,_),.notificationdelete(_,_), .devices,.notificationalert,.googleAssistent(_),.onnotificationfilter(_), .getExpiredVehicles,
             .getReachabilityReports(_,_,_), .saveReachabilitReport(_), .updateACDoorSirenAlarm(_, _), .getOlderNotifications(_, _),.getTempaltes(_),.getTempalteDevices(_),.addTemplateData(_),.updateTemplateData(_,_):
          
            return RCRouter.baseURLString
            
        case .session(_), .positions, .events(_), .getGeofence(_), .linkGeofence(_, _),
                .unlinkGeofence(_, _), .updateGeofence(_, _), .deleteGeofence(_), .createGeofence(_), .
            sendCommand(_),.singleVehicleGeoFence(_), .liveStreaming(_),.deleteSession:
            
            return RCRouter.baseAPIURLString
            
        case .loadUnloadRequest(_):
            return RCRouter.parkingScheduleURL
            
        case .pyLogin(_),.pyNotificationsGet(),.patchParkingData(_, _), .getParkingModeSchedulerDetails(),.putParkingModeSchedulerDetails(_, _),.postParkingModeSchedulerDetails(_),.getJWTToken(_),.getParkingData,.postParkingData(_),.pyGetNotif,.deleteUser(_),.taskStatusRequest(_),.getOTP(_),.verifyOTP(_),.getCompanyConfig,.getDeviceDrivers(_),.getCallToken(_), .getShareURL(_),.addDevice(_),.getDeviceReq(_),.getPyReports(_, _),.userConfig(_),.updateProfileImage(_, _),.deletePOIInfo(_),.getAllPaymentHistory,.getPaymentRates,.postPaymentOrderId(_),.postPaymentSignature(_),.pyPostNotif(_):
            return RCRouter.pyBaseURLString
            
        case .getPathBetweenPoints(_):
            return RCRouter.pathURL
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: baseURLPath)!.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        let jwtToken = Defaults().get(for: Key<String>("jwt_token")) ?? ""
        urlRequest.allHTTPHeaderFields = ["cache-control": "no-cache","Content-Type": "application/json"]
        let keychain = Keychain(service: "in.roadcast.bolt")
        let boltToken = try? keychain.getString("boltToken") ?? ""
        
        switch self {
        case .login(let parameters),.verifyOTP(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .register(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .owlMode(let parameters), .createGeofence(let parameters), .liveStreaming(let parameters),.onnotificationfilter(let parameters), .updateGeofence(_, let parameters), .UpdateUseDetails(_, let parameters),
             .sendOverspeedAlert(let parameters), .updateACDoorSirenAlarm(_, let parameters),.updateTemplateData(_, let parameters),.parkingMode(let parameters), .pyLogin(let parameters):
          
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            return urlRequest
            
        case .session(let parameters),.addTemplateData(let parameters):
            //                urlRequest.httpBody = try! URLEncoding.data(w: parameters, options: [])
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            return urlRequest
            
        case .events(let parameters):
            
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            let tempUrl = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempUrl?.replacingOccurrences(of: "%5B%5D=", with: "="))!)
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            return urlRequest
            
        case .getGeofence(let parameters), .singleVehicleGeoFence(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            return urlRequest
            
        case .forgetPassword(let parameters), .resetPassword(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .devices,.notificationalert, .positions, .deleteGeofence(_), .getNotifications(_), .usersHierarchy(_),
             .getFuelDetails,.getCallCredits(_),.notificationdelete(_,_),
             .getMonthlyDistance(_, _, _),.getPOIInfo, .getExpiredVehicles, .getReachabilityReports(_,_,_)
             ,.getTempaltes(_),.getTempalteDevices(_):
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            return urlRequest
            
        case .sendCommand(let parameters),.updateDevices(_, let parameters):
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .linkGeofence(let deviceId, let geofenceId), .unlinkGeofence(let deviceId, let geofenceId):
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            let httpdBodyString = "{\"deviceId\":" + "\(deviceId)" + ",\"geofenceId\":" + "\(geofenceId)" + "}"
            urlRequest.httpBody = httpdBodyString.data(using: String.Encoding.utf8)
            return urlRequest
            
        case .deleteSession:
            urlRequest.setValue(RCDataManager.get(objectforKey: "SessionCookie") as? String, forHTTPHeaderField: "Cookie")
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            return urlRequest
            
        case .getDeviceDetails(_),.devicePopUpDetails(_,_):
            let tempURL = urlRequest.url?.absoluteString
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%3F", with: "?"))!)
            return urlRequest
            
        case .putCarsData(_, let parameters):
            let tempURL = urlRequest.url?.absoluteString
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%3F", with: "?"))!)
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .getParkingModeSchedulerDetails():
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .putParkingModeSchedulerDetails(let deviceId, let parameters):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
        case .postParkingModeSchedulerDetails(let parameters):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .playbackRoute(_, _, _, _):
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return urlRequest
        case .addPOIInfo(let parameters), .updatePOIInfo(_, let parameters), .saveReachabilitReport(let parameters), .postFuelDetails(let parameters):
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
        case .googleAssistent(let parameters):
            // urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            return urlRequest
        case .getOlderNotifications(_, _):
            let tempURL = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%3F", with: "?"))!)
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            return urlRequest
        case .loadUnloadRequest(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue(boltToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .pyNotificationsGet(),.deletePOIInfo(_):
            let tempURL = urlRequest.url?.absoluteString
            //urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%3F", with: "?"))!)
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%26", with: "&"))!)
            let tempurl2 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl2?.replacingOccurrences(of: "%3F", with: "?"))!)
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .getJWTToken(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .pyGetNotif,.getPaymentRates,.getAllPaymentHistory:
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .deleteUser(_),.taskStatusRequest(_),.getOTP(_),.getCompanyConfig,.getDeviceDrivers(_),.userConfig(_):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            let tempURL = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%26", with: "&"))!)
            let tempurl2 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl2?.replacingOccurrences(of: "%3F", with: "?"))!)
            let tempurl3 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl3?.replacingOccurrences(of: "%3A", with: ":"))!)
            return urlRequest
            
        case .getPathBetweenPoints(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .getCallToken(let parameters),.postPaymentOrderId(let parameters),.postPaymentSignature(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            return urlRequest
            
        case .getShareURL(let parameters):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            let tempURL = urlRequest.url?.absoluteString
            
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%26", with: "&"))!)
            let tempurl2 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl2?.replacingOccurrences(of: "%3F", with: "?"))!)
            let tempurl3 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl3?.replacingOccurrences(of: "%3A", with: ":"))!)
            return urlRequest
            
            
        case .addDevice(let parameters):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        case .getDeviceReq(let taskId):
            //
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["task_id":taskId])
            let tempURL = urlRequest.url?.absoluteString
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            //urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%3F", with: "?"))!)
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%26", with: "&"))!)
            let tempurl2 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl2?.replacingOccurrences(of: "%3F", with: "?"))!)
            return urlRequest
            
        case .getPyReports(_,let parameters):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
            let tempURL = urlRequest.url?.absoluteString
            
            urlRequest.url = URL(string: (tempURL?.replacingOccurrences(of: "%26", with: "&"))!)
            let tempurl2 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl2?.replacingOccurrences(of: "%3F", with: "?"))!)
            let tempurl3 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl3?.replacingOccurrences(of: "%3A", with: ":"))!)
            let tempurl4 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl4?.replacingOccurrences(of: "%5B", with: "["))!)
            let tempurl5 = urlRequest.url?.absoluteString
            urlRequest.url = URL(string: (tempurl5?.replacingOccurrences(of: "%5D", with: "]"))!)
            return urlRequest
            
        case.updateProfileImage(_, let parameters),.pyPostNotif(let parameters):
            urlRequest.setValue(jwtToken, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
            return urlRequest
            
        default:
            return urlRequest
        }
    }
}


class RCRouterClient: SessionManager {
    
    public static let shared: RCRouterClient = {
        let instance = RCRouterClient(configuration: URLSessionConfiguration.default, delegate: SessionDelegate(), serverTrustPolicyManager: nil)
        instance.session.configuration.timeoutIntervalForRequest = 45
        instance.retrier = RCRequestRetrier()
        return instance
    }()
    
    private override init?(session: URLSession, delegate: SessionDelegate, serverTrustPolicyManager: ServerTrustPolicyManager?) {
        super.init(session: session, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
        //do nothing
    }
    
    private override init(configuration: URLSessionConfiguration, delegate: SessionDelegate, serverTrustPolicyManager: ServerTrustPolicyManager?) {
        super.init(configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
        //do nothing
    }
    
    public func request<T: BaseMappable>(URL: URLRequestConvertible, loadingMessage: String?, success: @escaping (DataResponse<T>) -> Void, failure: ((Error) -> Void)?) -> Void {
        
        var HUD: MBProgressHUD?
        if !(loadingMessage?.isEmpty)! {
            let topWindow = UIApplication.shared.keyWindow
            HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
            HUD?.animationType = .fade
            HUD?.mode = .indeterminate
            HUD?.labelText = loadingMessage!
        }
        
        
        request(URL).validate(statusCode: 200..<202).responseObject { (response: DataResponse<T>) in
            
#if DEBUG
            //TODO: comment the logging for all requests
            print("Request: \(String(describing: response.request))")   // original url request
            print("Request Headers: \(String(describing: response.request?.allHTTPHeaderFields))")   // original url request
            //            print("Request Body: \(String(describing: response.request?.httpBody?.base64EncodedString()))")   // original url request
            if let requestData = response.request?.httpBody, let utf8Text = String(data: requestData, encoding: .utf8) {
                print("Request Body: \(utf8Text)")   // original url request
            }
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            //print data as json string.
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response Data: \(utf8Text)")
            }
#endif
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                HUD?.hide(true)
                success(response)
            case .failure(let error):
                HUD?.hide(true)
                if response.response?.statusCode == 204 {
                    failure?(MyError.noDataFoundError)
                }else if response.response?.statusCode == 202 {
                    failure?(MyError.noResponse)
                }else if response.response?.statusCode == 401 {
                    failure?(MyError.notAuthorized)
                }else if response.response?.statusCode == 500 {
                    failure?(MyError.INTERNAL_SERVER_ERROR)
                }else if response.response?.statusCode == 600 {
                    failure?(MyError.INTERNET_FAILURE)
                }else if response.response?.statusCode == 400 {
                    failure?(MyError.BAD_REQUEST)
                }else if response.response?.statusCode == 503 {
                    failure?(MyError.SERVER_DOWN)
                }
                else{
                    failure?(error)
                }
            }
        }
    }
    
    public func requestArray<T: BaseMappable>(URL: URLRequestConvertible, loadingMessage: String?, success: @escaping (DataResponse<[T]>) -> Void, failure: ((Error) -> Void)?) -> Void {
        
        var HUD: MBProgressHUD?
        if !(loadingMessage?.isEmpty)! {
            let topWindow = UIApplication.shared.keyWindow
            HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
            HUD?.animationType = .fade
            HUD?.mode = .indeterminate
            HUD?.labelText = loadingMessage!
        }
        
        request(URL).validate(statusCode: 200..<204).responseArray { (response: DataResponse<[T]>) in
            
#if DEBUG
            //TODO: comment the logging for all requests
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            //print data as json string.
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response Data: \(utf8Text)")
            }
#endif
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                HUD?.hide(true)
                success(response)
            case .failure(let error):
                HUD?.hide(true)
                if response.response?.statusCode == 204 {
                    failure?(MyError.noDataFoundError)
                }else if response.response?.statusCode == 401 {
                    failure?(MyError.notAuthorized)
                }else if response.response?.statusCode == 500 {
                    failure?(MyError.INTERNAL_SERVER_ERROR)
                }else if response.response?.statusCode == 600 {
                    failure?(MyError.INTERNET_FAILURE)
                }else if response.response?.statusCode == 400 {
                    failure?(MyError.BAD_REQUEST)
                }else if response.response?.statusCode == 503 {
                    failure?(MyError.SERVER_DOWN)
                }
                else{
                    failure?(error)
                }
            }
        }
    }
    
    public func requestJson(URL: URLRequestConvertible, loadingMessage: String?, success: @escaping (DataResponse<Any>) -> Void, failure: ((Error) -> Void)?) -> Void {
        
        var HUD: MBProgressHUD?
        if !(loadingMessage?.isEmpty)! {
            let topWindow = UIApplication.shared.keyWindow
            HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
            HUD?.animationType = .fade
            HUD?.mode = .indeterminate
            HUD?.labelText = loadingMessage!
        }
        
        request(URL).validate(statusCode: 200..<205).responseJSON { (response: DataResponse<Any>) in
            
#if DEBUG
            //TODO: comment the logging for all requests
            print("Request: \(String(describing: response.request))")   // original url request
            print("Request Headers: \(String(describing: response.request?.allHTTPHeaderFields))")   // original url request
            //            print("Request Body: \(String(describing: response.request?.httpBody?.base64EncodedString()))")   // original url request
            if let requestData = response.request?.httpBody, let utf8Text = String(data: requestData, encoding: .utf8) {
                print("Request Body: \(utf8Text)")   // original url request
            }
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            //print data as json string.
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response Data: \(utf8Text)")
            }
#endif
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                HUD?.hide(true)
                success(response)
            case .failure(let error):
                HUD?.hide(true)
                if response.response?.statusCode == 204 {
                    failure?(MyError.noDataFoundError)
                }else if response.response?.statusCode == 401 {
                    failure?(MyError.notAuthorized)
                }else if response.response?.statusCode == 500 {
                    failure?(MyError.INTERNAL_SERVER_ERROR)
                }else if response.response?.statusCode == 600 {
                    failure?(MyError.INTERNET_FAILURE)
                }else if response.response?.statusCode == 400 {
                    failure?(MyError.BAD_REQUEST)
                }else if response.response?.statusCode == 503 {
                    failure?(MyError.SERVER_DOWN)
                } else if response.response?.statusCode == 200 {
                    success(response)
                }
                else{
                    failure?(error)
                }
            }
        }
    }
    
    public func requestShareJson(URL: URLRequestConvertible, loadingMessage: String?, success: @escaping (DataResponse<Any>) -> Void, failure: ((Error) -> Void)?) -> Void {
        
        var HUD: MBProgressHUD?
        if !(loadingMessage?.isEmpty)! {
            let topWindow = UIApplication.shared.keyWindow
            HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
            HUD?.animationType = .fade
            HUD?.mode = .indeterminate
            HUD?.labelText = loadingMessage!
        }
        
        request(URL).validate(statusCode: 200..<410).responseJSON { (response: DataResponse<Any>) in
            
#if DEBUG
            //TODO: comment the logging for all requests
            print("Request: \(String(describing: response.request))")   // original url request
            print("Request Headers: \(String(describing: response.request?.allHTTPHeaderFields))")   // original url request
            //            print("Request Body: \(String(describing: response.request?.httpBody?.base64EncodedString()))")   // original url request
            if let requestData = response.request?.httpBody, let utf8Text = String(data: requestData, encoding: .utf8) {
                print("Request Body: \(utf8Text)")   // original url request
            }
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            //print data as json string.
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Response Data: \(utf8Text)")
            }
#endif
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success:
                HUD?.hide(true)
                if response.response?.statusCode == 200 || response.response?.statusCode == 409 {
                    success(response)
                } else if response.response?.statusCode == 204 {
                    failure?(MyError.noDataFoundError)
                } else if response.response?.statusCode == 401 {
                    failure?(MyError.notAuthorized)
                } else {
                    success(response)
                }
            case .failure(let error):
                HUD?.hide(true)
                if response.response?.statusCode == 500 {
                    failure?(MyError.INTERNAL_SERVER_ERROR)
                }else if response.response?.statusCode == 600 {
                    failure?(MyError.INTERNET_FAILURE)
                }else if response.response?.statusCode == 400 {
                    failure?(MyError.BAD_REQUEST)
                }else if response.response?.statusCode == 503 {
                    failure?(MyError.SERVER_DOWN)
                } else if response.response?.statusCode == 200 {
                    success(response)
                }
                else {
                    failure?(error)
                }
            }
        }
    }
    
}

//TO throw custom errors
public enum MyError: Error {
    case noDataFoundError // 204
    case noResponse //202
    case notAuthorized // 401
    case INTERNAL_SERVER_ERROR //500
    case INTERNET_FAILURE // 600
    case RESPONSE_SUCCESS //200
    case BAD_REQUEST // 400 device is not online
    case SERVER_DOWN // 503
    
    
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noDataFoundError:
            return NSLocalizedString("No data found.", comment: "Bolt error")
        case .noResponse:
            return NSLocalizedString("No Response from Device.", comment: "Bolt error")
        case .notAuthorized:
            return NSLocalizedString("Username or password is not valid.", comment: "Bolt error")
        case .INTERNAL_SERVER_ERROR:
            return NSLocalizedString("Some problem has occured please try later.", comment: "Bolt error")
        case .INTERNET_FAILURE:
            return NSLocalizedString("Please check your internet connection", comment: "Bolt error")
        case .RESPONSE_SUCCESS:
            return NSLocalizedString("Requests successful", comment: "Bolt error")
        case .BAD_REQUEST:
            return NSLocalizedString("Some problem has occured please try later.", comment: "Bolt error")
        case .SERVER_DOWN:
            return NSLocalizedString("Some problem has occured please try later.", comment: "Bolt error")
            
            
        }
    }
}



//
//  RCLocalAPIManager.swift
//  Bus993
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Alamofire
import DefaultsKit
import Firebase
import ObjectMapper
import TSMessages
import GoogleMaps
import GooglePlaces
import Realm
import RealmSwift
import ObjectMapper_Realm
import KeychainAccess


let companyId:String = "18"

class RCLocalAPIManager {
    let keychain = Keychain(service: "in.roadcast.bolt")
    
    /// Enum to provide choice between receive OTP via call or message
    ///
    /// - message: Message option
    /// - call: Call option
    public enum RCOTPRetry: Int {
        case message = 0
        case call
    }
    
    /// Class singelton designated initializer
    public static let shared = RCLocalAPIManager()
    
    private init() {
        //do nothing
    }
    
    /// Request to login user. This request sends an OTP to the entered mobile number
    ///
    /// - Parameters:
    ///   - countryCode: Dailing code for country
    ///   - mobile: Mobile number for the user
    ///   - success: Success closure
    ///   - failure: Failure closure
    public func login(loadingMsg:String,with userName: String, password: String, isLogin: Bool,
                      success: @escaping (LoginResponseModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        var fcmToken = ""
        if(isLogin){
            fcmToken = Defaults().get(for: Key<String>("RCFCMToken")) ?? ""
            if fcmToken == "" {
                fcmToken = Messaging.messaging().fcmToken ?? ""
            }
        }
        
        let parameters = ["password": password, "token": fcmToken, "deviceType": "iOS", "userName": userName]
        RCRouterClient.shared.request(URL: RCRouter.login(parameters),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<LoginResponseModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<LoginResponseModel>("LoginResponseModel"))
                                                success(model)
                                                
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func pylogin(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let passowrd = UserDefaults.standard.string(forKey: "userPassword") ?? ""
        let username  = UserDefaults.standard.string(forKey: "userName") ?? ""
      
        let parameters = ["username": username, "password": passowrd]
        RCRouterClient.shared.request(URL: RCRouter.pyLogin(parameters as Parameters),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<AuthTokenModel>) in
                                        if let model = response.result.value {
                                            if !model.token.isEmpty {
                                                let keychain = Keychain(service: "in.roadcast.bolt")
                                                do {
                                                    try keychain.set(model.token, key: "authToken")
                                                }
                                                catch let error {
                                                    print(error)
                                                }
                                                success("success")
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getCompanyConfig(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getCompanyConfig,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<CompanyConfigModel>) in
                                        if let model = response.result.value {
                                            Defaults().set(model.google_key, for: Key<String>(defaultKeyNames.placesKey.rawValue))
                                            success("success")
                                        } else {
                                            failure("failure")
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getDeviceDrivers(deviceId: String,success: @escaping (DriverInfoResponseModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getDeviceDrivers(deviceId),
                                      loadingMessage: "Please wait...",
                                      success: { (response: DataResponse<DriverInfoResponseModel>) in
                                        if let model = response.result.value {
                                            success(model)
                                        } else {
                                            failure("failure")
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getCallToken(deviceImei: String,success: @escaping (CallTokenResponseModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        var fcmToken = Defaults().get(for: Key<String>("RCFCMToken")) ?? ""
        if fcmToken == "" {
            fcmToken = Messaging.messaging().fcmToken ?? ""
        }
        let params:[String:Any] = ["unique_id":deviceImei,"token":fcmToken]
        RCRouterClient.shared.request(URL: RCRouter.getCallToken(params),
                                      loadingMessage: "Please wait...",
                                      success: { (response: DataResponse<CallTokenResponseModel>) in
                                        if let model = response.result.value {
                                            success(model)
                                        } else {
                                            failure("failure")
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getPathBtwnPoints(
        point1:CLLocationCoordinate2D,
        point2:CLLocationCoordinate2D,
        success: @escaping ([[Double]]) -> Void,
        failure: @escaping (String) -> Void) {
            
        let origin:[Double] = [point1.longitude,point1.latitude]
        let destination:[Double] = [point2.longitude,point2.latitude]
        let coordinates:[[Double]] = [origin,destination]
        let params:[String:Any] = ["coordinates":coordinates]
        
        RCRouterClient.shared.request(URL: RCRouter.getPathBetweenPoints(params),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<PointPathResponseModel>) in
                                        if let model = response.result.value {
                                            let array:[[Double]] = model.features.first?.geometry?.coordinates ?? []
                                            success(array)
                                        } else {
                                            failure("failure")
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func pyNotificationsGet(
                      success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        
        RCRouterClient.shared.request(URL: RCRouter.pyNotificationsGet(),
                                      loadingMessage: "",
                                      
                                      success: { (response: DataResponse<ReportsEventsModel>) in
                                        if let models = response.result.value {
                                            let eventsData: [ReportsEventsModelData] = models.data!
                                           Defaults().set(eventsData, for: Key<[ReportsEventsModelData]>("allNotifications"))
                                            success("success")
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getUserConfig(
        success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
            let userId = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
            
            RCRouterClient.shared.request(URL: RCRouter.userConfig(userId),
                                          loadingMessage: "",
                                          success: { (response: DataResponse<UserConfigResponseModel>) in
                if let models = response.result.value {
                    let data: [UserConfigResponseModelData] = models.data ?? []
                    if let firstData = data.first {
                        Defaults().set(firstData, for: Key<UserConfigResponseModelData>("user_config"))
                        if let alarmSetting = firstData.alarm_settings {
                            Defaults().set(alarmSetting, for: Key<UserConfigAlarmSettingResponse>("alarm_settings"))
                        }
                        if let profileUrl = firstData.user_profile_pic {
                            Defaults().set(profileUrl, for: Key<String>("profile_url"))
                        }
                        if let configId = firstData.id {
                            Defaults().set("\(configId)", for: Key<String>("configId"))
                        }
//                        if let callCount = firstData.
                        Defaults().set("\(firstData.calls_count ?? 0)", for: Key<String>("CallCredits"))
                    }
                }
                success("success")
            }) { (error) in
                failure(error.localizedDescription)
            }
    }
    
    public func updateProfileImage(imageUrl:String,
        success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        let configId:String = Defaults().get(for: Key<String>("configId")) ?? "0"
        let params:[String:Any] = ["user_profile_pic":imageUrl]
            
            RCRouterClient.shared.requestJson(URL: RCRouter.updateProfileImage(configId,params),
                                          loadingMessage: "",
                                          success: { (response: DataResponse<Any>) in
                Defaults().set(imageUrl, for: Key<String>("profile_url"))
                success("success")
            }) { (error) in
                failure(error.localizedDescription)
            }
    }
    
    public func register(with userName: String, password: String, fname: String, lname: String, email: String, companyName: String, countryCode: String, activate: Bool,
                         success: @escaping (RegisterResponseModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let parameters = ["userName": userName, "password": password,"fname":fname ,"lname": lname,
                          "email": email, "companyName": companyName, "countryCode": countryCode,
                          "activate":activate, "appName": appname] as [String : Any]
        RCRouterClient.shared.request(URL: RCRouter.register(parameters),
                                      loadingMessage: "Verifying",
                                      success: { (response: DataResponse<RegisterResponseModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<RegisterResponseModel>("RegisterResponseModel"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func checkUserExists(with countryCode: String, usernName: String, success: @escaping (CheckUserModel) -> Void,
                                failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.checkUser(countryCode,usernName),
                                      loadingMessage: "Verifying",
                                      success: { (response: DataResponse<CheckUserModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<CheckUserModel>("CheckUserModel"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong, please try again")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func session(with email: String,password: String, success: @escaping (SessionResponseModel) -> Void,
                        failure: @escaping (String) -> Void) -> Void {
        let parameters = ["email":email ,"password": password]
        RCRouterClient.shared.request(URL: RCRouter.session(parameters),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<SessionResponseModel>) in
                                        if let model = response.result.value {
                                            Defaults().set(model, for: Key<SessionResponseModel>("SessionResponseModel"))
                                            if let setCookie = HTTPCookieStorage.shared.cookies {
                                                
                                                RCDataManager.set(value: setCookie, forKey: "SessionCookie")
                                                
                                                for c : HTTPCookie in setCookie {
                                                    
                                                    let cookieProps = NSMutableDictionary()
                                                    cookieProps.setValue(c.value, forKey: "CookieValue")
                                                    
                                                    Defaults().clear(Key<String>("CookieValue"))
                                                    Defaults().set(c.value, for: Key<String>("CookieValue"))
                                                    
                                                    
                                                }
                                                
                                                //  Defaults().set(setCookie.va, for: Key<String>("SessionCookie"))
                                                
                                                success(model)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    
    public func deleteSession(with success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.requestJson(URL: RCRouter.deleteSession,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<Any>) in
                                        RCDataManager.delete(objectforKey: "SessionCookie")
                                        // Defaults().clear(Key<String>("SessionCookie"))
                                      }) { (error) in
            if error.localizedDescription == MyError.noDataFoundError.localizedDescription {
                success("success")
                RCDataManager.delete(objectforKey: "SessionCookie")
                //Defaults().clear(Key<String>("SessionCookie"))
            } else {
                failure(error.localizedDescription)
            }
        }
    }
    public func getShareURL(with parameters: [String:Any],
                            success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestShareJson(URL: RCRouter.getShareURL(parameters),
                                               loadingMessage: "Please wait...",
                                               success: { (response: DataResponse<Any>) in
            if let models = response.result.value, JSONSerialization.isValidJSONObject(models) {
                if let dictionary = models as? [String: Any] {
                    if let dataValue = dictionary["data"] as? String {
                        success(dataValue)
                    } else {
                        failure("failed")
                    }
                } else {
                    failure("failed")
                }
            } else {
                failure("failed")
                
            }
            
        }) { (error) in
            failure(error.localizedDescription)
        }
        
        
    }
    
    public func sendOTP(with countryCode: String, usernName: String, success: @escaping (CheckUserModel) -> Void,
                        failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.sendOTP(countryCode,usernName),
                                      loadingMessage: "Sending OTP",
                                      success: { (response: DataResponse<CheckUserModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<CheckUserModel>("CheckUserModel"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong, please try again")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func get7DayDistanceDevice(startDate: String, endDate: String, deviceIdString: String,
                                      success: @escaping (TotalDistanceRealmModel) -> Void,
                                      failure: @escaping (String) -> Void) -> Void {
        
        //let realm = try! Realm()
        let realmDistanceObjects = DBManager.shared.getResults(RealmObject: TotalDistanceRealmModel.self)//realm.objects(TotalDistanceRealmModel.self)
        let realmDistanceDataObjects = DBManager.shared.getResults(RealmObject: TotalDistanceRealmModelData.self)// realm.objects(TotalDistanceRealmModelData.self)
        
        
        //try! realm.write {
        for objectdi in realmDistanceObjects {
            DBManager.shared.deleteFromDb(object: objectdi)
        }
        
        for objectda in realmDistanceDataObjects {
            DBManager.shared.deleteFromDb(object: objectda)
        }
        
        // }
        
        
        RCRouterClient.shared.request(URL: RCRouter.getMonthlyDistance(deviceIdString,startDate,endDate),
                                      loadingMessage: "Please wait...",
                                      success: { (response: DataResponse<TotalDistanceRealmModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                for monthlyModel in model.data {
                                                    DBManager.shared.addData(object: monthlyModel)
                                                }
                                                success(model)
                                            } else {
                                                failure("Something went wrong, please try again")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func getMonthlyDistanceDevice(startDate: String, endDate: String, deviceIdString: String,
                                         success: @escaping (RealmTotalDistanceMonthlyModel) -> Void,
                                         failure: @escaping (String) -> Void) -> Void {
        
        let realm = try! Realm()
        let realmDistanceObjects = realm.objects(RealmTotalDistanceMonthlyModel.self)
        let realmDistanceDataObjects = realm.objects(RealmTotalDistanceMonthlyModelData.self)
        
        try! realm.write {
            realm.delete(realmDistanceObjects)
            realm.delete(realmDistanceDataObjects)
        }
        
        
        RCRouterClient.shared.request(URL: RCRouter.getMonthlyDistance(deviceIdString,startDate,endDate),
                                      loadingMessage: "Please wait...",
                                      success: { (response: DataResponse<RealmTotalDistanceMonthlyModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                for monthlyModel in model.data {
                                                    DBManager.shared.addData(object: monthlyModel)
                                                }
                                                success(model)
                                            } else {
                                                failure("Something went wrong, please try again")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func forgetPassword(with username: String,success: @escaping (ForgetPasswordResponse) -> Void,
                               failure: @escaping (String) -> Void) -> Void {
        let parameters = ["username":username]
        RCRouterClient.shared.request(URL: RCRouter.forgetPassword(parameters),
                                      loadingMessage: "Verifying",
                                      success: { (response: DataResponse<ForgetPasswordResponse>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<ForgetPasswordResponse>("ForgetPasswordResponse"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getPaymentRates(success: @escaping (String) -> Void,
                                failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getPaymentRates,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<PaymentRatesModel>) in
                                        if let model = response.result.value {
                                            if let paymentData = model.data {
                                                for i in paymentData {
                                                    Defaults().set(i, for: Key<PaymentRatesModelData>("Payment_\(i.type!)"))
                                                }
                                                success("success")
                                            } else {
                                               failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    
    public func getExpiredVehicles(with loadingMsg:String, success: @escaping (String) -> Void,
                                   failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getExpiredVehicles,
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<ExpiryResponseModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                let expiredList:[ExpiryDataResponseModel] = model.data ?? []
                                                var expiredIdList:[String] = Defaults().get(for: Key<[String]>("expired_vehicles_id")) ?? []
                                                for item in expiredList {
                                                    if !expiredIdList.contains(item.deviceid ?? "") {
                                                        expiredIdList.append(item.deviceid ?? "")
                                                    }
                                                }
                                                Defaults().set(expiredIdList, for: Key<[String]>("expired_vehicles_id"))
                                                success("success")
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getPOIData(with loadingMsg:String, success: @escaping (String) -> Void,
                           failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getPOIInfo,
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<POIInfoModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model.data ?? [], for: Key<[POIInfoDataModel]>("POI"))
                                                success("success")
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getTemplates(with loadingMsg:String, success: @escaping ([TemplateDataModel]) -> Void,
                             failure: @escaping (String) -> Void) -> Void {
        let userId =  "\(Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel"))?.id ?? 0)"
        RCRouterClient.shared.request(URL: RCRouter.getTempaltes(userId),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<TemplateModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
//                                                Defaults().set(model.data ?? [], for: Key<[TemplateDataModel]>("getTemplate"))
                                                success(model.data ?? [])
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getTemplateDevices(with loadingMsg:String,tempId:String, success: @escaping ([TemplateDevicesDataModel]) -> Void,
                             failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getTempalteDevices(tempId),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<TemplateDevicesModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model.data ?? [])
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func addPOIData(with parameters: [String:Any],
                           loadingMsg: String,
                           success: @escaping (String) -> Void,
                           failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.addPOIInfo(parameters),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<POIInfoModel>) in
                                        if let model = response.result.value {
                                            success("success")
                                            print(model)
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    public func addTemplateData(with parameters: [String:Any],loadingMsg: String,success: @escaping (String) -> Void,failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.requestJson(URL: RCRouter.addTemplateData(parameters),loadingMessage: loadingMsg,success: { (_) in
                                        success("success")
                                      }) { (error) in
        failure(error.localizedDescription)
    }
    }
    public func updateTemplateData(with parameters: [String:Any],id:String,loadingMsg: String,success: @escaping (String) -> Void,failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.requestJson(URL: RCRouter.updateTemplateData(id, parameters),loadingMessage: loadingMsg,success: { (_) in
                                        success("success")
                                      }) { (error) in
        failure(error.localizedDescription)
    }
    }
    public func updatePOIData(with parameters: [String:Any],
                              id: String,
                              loadingMsg: String,
                              success: @escaping (String) -> Void,
                              failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL: RCRouter.updatePOIInfo(id, parameters),
                                          loadingMessage: loadingMsg,
                                          success: { (_) in
                                            success("success")
                                          }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func deletePOIData(with id: String,
                              loadingMsg: String,
                              success: @escaping (String) -> Void,
                              failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL: RCRouter.deletePOIInfo(id),
                                          loadingMessage: loadingMsg,
                                          success: { (_) in
            success("success")
        }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func resetPassword(with userId: String, password: String, success: @escaping (StringResponseModel) -> Void,
                              failure: @escaping (String) -> Void) -> Void {
        let parameters = ["userId":userId, "password":password]
        RCRouterClient.shared.request(URL: RCRouter.resetPassword(parameters),
                                      loadingMessage: "Loading",
                                      success: { (response: DataResponse<StringResponseModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success"{
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            
            failure(error.localizedDescription)
        }
    }
    
    
    public func getPaymentHistory(success: @escaping ([PaymentHistoryResponseModelData]) -> Void,
                                  failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getAllPaymentHistory,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<PaymentHistoryResponseModel>) in
                                        if let model = response.result.value {
                                            success(model.data ?? [])
                                        } else {
                                            failure("Something went wrong")
                                        }
                                      }) { (error) in
            
            failure(error.localizedDescription)
        }
    }
    
    public func getCallCredits(userId: String,success: @escaping (String) -> Void,
                               failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getCallCredits(userId),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<CallCountModel>) in
                                        if let model = response.result.value {
                                            
                                            if model.status == "success"{
                                                if let modelData = model.data {
                                                    
                                                    let callCredits = modelData.calls_count
                                                    let thirdPartyValue = modelData.third_party_value
                                                    Defaults().set(callCredits ?? "0", for: Key<String>("CallCredits"))
                                                    Defaults().set(modelData.isload_unload_visible ?? "0", for: Key<String>("isLoadUnloadVisible"))
                                                    Defaults().set(thirdPartyValue ?? "", for: Key<String>("thirdPartyValue"))
                                                    
                                                }
                                                
                                                success("success")
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            
            failure(error.localizedDescription)
        }
    }
    
    
    
    public func getRazorPayOrderID(with deviceIdArray: [String], value: Double, type: String = "RENEWAL" , success: @escaping (RazorPayOrderIDModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        var parameters : [String:Any] = [:]
        
        if type == "RENEWAL" {
            
            parameters =  ["device_ids": deviceIdArray,
                           "amount": value,
                           "type": "RENEW",
                           "app_name": appname
            ] as [String : Any]
            
        } else {
            
            parameters = ["amount": value,
                          "type": "CALL",
                          "app_name": appname
            ] as [String : Any]
            
        }
        
        
        RCRouterClient.shared.request(URL: RCRouter.postPaymentOrderId(parameters),
                                      loadingMessage: "Authenticating, Please wait...",
                                      success: { (response: DataResponse<RazorPayOrderIDModel>) in
                                        if let model = response.result.value {
//                                            if model.status == "success"{
                                                success(model)
//                                            } else {
//                                                failure("Something went wrong")
//                                            }
                                        } else {
                                            failure("Something went wrong")
                                        }
                                      }) { (error) in
            
            failure(error.localizedDescription)
        }
    }
    
    public func verifyRazorPayPayment(orderID: String, paymentId: String, signature: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let parameters = ["razorpay_order_id": orderID, "razorpay_payment_id": paymentId,"razorpay_signature": signature] as [String : Any]
        
        RCRouterClient.shared.requestJson(URL: RCRouter.postPaymentSignature(parameters), loadingMessage: "Verifying payment, Please wait...", success: { (response: DataResponse<Any>) in
            success("success")
        }, failure: { error in
            failure(error.localizedDescription)
        })
        
//        RCRouterClient.shared.request(URL: RCRouter.postPaymentSignature(parameters),
//                                      loadingMessage: "Verifying payment, Please wait...",
//                                      success: { (response: DataResponse<RazorPayOrderIDModel>) in
//                                        if let model = response.result.value {
//                                            if model.status == "success"{
//                                                success(model.status ?? "success")
//                                            } else {
//                                                failure("Something went wrong")
//                                            }
//                                        }
//                                      }) { (error) in
//
//            failure(error.localizedDescription)
//        }
    }
    
    public func googleAssistent(googleAssistentEmailId: String, defaultDeviceId: String,  success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let parameters = ["email": googleAssistentEmailId, "default_device_id": defaultDeviceId ] as [String : Any]
        
        RCRouterClient.shared.requestJson(URL: RCRouter.googleAssistent(parameters),loadingMessage: "",success: { (_)  in
            print("Success")
            success("")
            
        }) { (error) in
            
            failure(error.localizedDescription)
        }
    }
    
    
    public func gettingFuelDetails( success: @escaping (FuelModelApi) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.getFuelDetails,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<FuelModelApi>) in
                                        if let model = response.result.value {
                                            if model.message == "success." {
                                                // if model.data.count != 0 {
                                                for fuelModel in model.data {
                                                    DBManager.shared.addDataUpdate(object: fuelModel)
                                                }
                                                
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func postFuelDetails(deviceID: Int, totalDistance:String,paymentType: String,
                                imageName: String, amount: String,priceLitre:String,
                                fuelFilled: String, fuelType: String, milage: String,
                                success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        
        let currentdate = Date()
        let timeStamp = RCGlobals.getFormattedHistory(date: currentdate as NSDate)
        
        let parameters : [String:Any] = ["image_name":imageName,
                                         "payment_type":paymentType,
                                         "amount": amount,
                                         "device_id":deviceID,
                                         "total_distance": totalDistance,
                                         "price_per_litre":priceLitre,
                                         "fuel_filled":fuelFilled,
                                         "fuel_type":fuelType,
                                         "timestamp":timeStamp,
                                         "mileage":milage]
        
        RCRouterClient.shared.requestJson(URL: RCRouter.postFuelDetails(parameters), loadingMessage: "Saving Fuel Data",
                                          success: { (_) in
                                            
                                            success("success in posting data")
                                            
                                            RCLocalAPIManager.shared.gettingFuelDetails(success: { (success) in
                                                print("success in getting details")
                                            }) { (error) in
                                                print("failure in fuel")
                                            }
                                            
                                          }) { (_) in
            failure("Error in saving Fuel Data")
        }
        
    }
    
    public func getSelDevicePath(with deviceId: Int, success: @escaping (DeviceRouteModel) -> Void,
                                 failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.getSelDevicePath(deviceId),
                                      loadingMessage: "Getting path",
                                      success: { (response: DataResponse<DeviceRouteModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getSelDeviceDailyPath(with deviceId: Int, success: @escaping (DeviceDailyPathModel) -> Void,
                                      failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.getSelDeviceDailyPath(deviceId),
                                      loadingMessage: "Getting Daily path",
                                      success: { (response: DataResponse<DeviceDailyPathModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getTripsReport(with deviceId: String, loadingMsg: String, startDate: String, endDate: String = "",success: @escaping (TripsReportModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        let parameters:[String:Any] = [
            "start":startDate,
            "end":endDate,
            "device_ids":deviceId,
            "timezone_offset":"-330",
            "inputs":"[]"
        ]
        RCRouterClient.shared.request(URL: RCRouter.getPyReports("trip", parameters),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<TripsReportModel>) in
                                        if let model = response.result.value {
//                                            if model.status == "success" {
                                            success(model)
//                                            } else {
//                                                failure("Something went wrong")
//                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
        
        
        
        
    }
    
    public func getSummaryReport(with deviceId: String, startDate: String, endDate: String = "",success: @escaping (SummaryReportModel) -> Void,
                                 failure: @escaping (String) -> Void) -> Void {
        let parameters:[String:Any] = [
            "start":startDate,
            "end":endDate,
            "device_ids":deviceId,
            "timezone_offset":"-330",
            "inputs":"[]"
        ]
        RCRouterClient.shared.request(URL: RCRouter.getPyReports("summary", parameters),
                                      loadingMessage: "Getting reports",
                                      success: { (response: DataResponse<SummaryReportModel>) in
                                        if let model = response.result.value {
//                                            if model.status == "success" {
                                                success(model)
//                                            } else {
//                                                failure("Something went wrong")
//                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func getStopsReport(with deviceId: String, startDate: String, endDate: String = "" ,
                               success: @escaping (StopsReportModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getReportRange("stops", deviceId, startDate, endDate),
                                      loadingMessage: "Getting reports",
                                      success: { (response: DataResponse<StopsReportModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
        
    }
    
    public func getKmsReport(with deviceId: String, startDate: String, endDate: String = "" ,
                             success: @escaping (DistanceReportModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getReportRange("monthly_dist", deviceId, startDate, endDate),
                                      loadingMessage: "Getting reports",
                                      success: { (response: DataResponse<DistanceReportModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
        
    }
    
    public func getReachabilityReport(with deviceId: String, startDate: String, endDate: String = "" ,
                                      success: @escaping (ReachabilityReportModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.getReachabilityReports(deviceId, startDate, endDate),
                                      loadingMessage: "Getting reports",
                                      success: { (response: DataResponse<ReachabilityReportModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
        
    }
    
    public func saveReachabilityReport(with parameters: [String:Any],
                                       success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL: RCRouter.saveReachabilitReport(parameters),
                                          loadingMessage: "Please wait...",
                                          success: { (_) in
                                            success("success")
                                          }) { (error) in
            failure(error.localizedDescription)
        }
        
        
    }
    
    public func sendLoadUnloadData(with parameters:[String:Any], success: @escaping (LoadUnloadResponseModelData) -> Void, failure: @escaping (String) -> Void ) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.loadUnloadRequest(parameters),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<LoadUnloadResponseModel>) in
                                        
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                if let data = model.data {
                                                    success(data)
                                                } else {
                                                    failure("error")
                                                }
                                            } else {
                                                failure("error")
                                            }
                                        }
                                        
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func addDevice(loadingMsg:String ,deviceName: String, activationCode:String, imeiNumber:String, success: @escaping (String) -> Void,
                          failure: @escaping (String) -> Void) -> Void {
        let parameters = ["name":deviceName,"activation_code":activationCode,"imei":imeiNumber] as [String : Any]
        RCRouterClient.shared.requestJson(URL: RCRouter.addDevice(parameters),
                                      loadingMessage:loadingMsg,
                                      success: {(response: DataResponse<Any>) in
                                        if let models = response.result.value {
                                            if let dictionary = models as? [String: Any] {
                                                if let taskId = dictionary["task_id"] as? String {
                                                    print(taskId)
                                                    success(taskId)
                                                }
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getDeviceRequest(loadingMsg:String ,taskId: String, success: @escaping (_ Dictionary:[String: Any] ) -> Void,
                          failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.requestJson(URL: RCRouter.getDeviceReq(taskId),
                                      loadingMessage:loadingMsg,
                                      success: {(response: DataResponse<Any>) in
                                        if let models = response.result.value {
                                            if let dictionary = models as? [String: Any] {
                                                success(dictionary)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func updateDevice(with deviceModel: TrackerDevicesMapperModel, success: @escaping (AddDeviceModel) -> Void,
                             failure: @escaping (String) -> Void) -> Void {
        
        
        let attributes:[String:Any] = ["alertNumber": deviceModel.attributes?.alertNumber as Any,
                                       "centerNumber": deviceModel.attributes?.centerNumber as Any,
                                       "countryCode": deviceModel.attributes?.countryCode as Any,
                                       "overspeedAlert": deviceModel.attributes?.overspeedAlert as Any,
                                       "overspeedValue": deviceModel.attributes?.overspeedValue as Any,
                                       "vibrationAlert": deviceModel.attributes?.vibrationAlert as Any,
                                       "prevOdometer": deviceModel.attributes?.prevOdometer as Any,
                                       "speedLimit": deviceModel.attributes?.speedLimit as Any]
        
        let parameters:[String:Any] = ["attributes": attributes as Any, "category": deviceModel.category as Any,
                                       "contact": deviceModel.contact as Any, "geofenceIds": deviceModel.geofenceIds as Any,
                                       "groupId": deviceModel.groupId as Any, "id": deviceModel.id as Any,
                                       "lastUpdate": deviceModel.lastUpdate as Any, "model": deviceModel.model as Any,
                                       "name": deviceModel.name as Any, "phone": deviceModel.phone as Any,
                                       "positionId": deviceModel.positionId as Any, "status": deviceModel.status as Any,
                                       "uniqueId": deviceModel.uniqueId as Any]
        
        RCRouterClient.shared.request(URL: RCRouter.updateDevices(deviceModel.id, parameters),
                                      loadingMessage: "Verifying",
                                      success: { (response: DataResponse<AddDeviceModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<AddDeviceModel>("AddDeviceModel"))
                                                success(model)
                                            } else {
                                                failure(model.message!)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    
    //    public func deviceResponse(with type: String, success: @escaping (DeviceResponseModel) -> Void, failure: @escaping (String) -> Void) -> Void {
    //        let parameters = ["type":type ,"token": Defaults().get(for: Key<String>("RCFCMToken")) ?? "", "deviceType": "iOS"]
    //        RCRouterClient.shared.request(URL: RCRouter.deviceResponse(parameters),
    //                                      loadingMessage: "Verifying",
    //                                      success: { (response: DataResponse<DeviceResponseModel>) in
    //                                        if let model = response.result.value {
    //                                            if model.type == "message" {
    //                                                Defaults().set(model, for: Key<DeviceResponseModel>("DeviceResponseModel"))
    //                                                success(model)
    //                                            } else {
    //                                                failure("Something went wrong")
    //                                            }
    //                                       }
    //        }) { (error) in
    //            failure(error.localizedDescription)
    //        }
    //    }
    
    public func getDevices(success: @escaping ([TrackerDevicesMapperModel]) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.devices,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<TrackerDeviceResponseMapperModel>) in
                                        
                                        var imeiNumbers = [String]()
                                        
                                        if let responseData = response.result.value {
                                            if let models = responseData.data {
                                                
                                                Defaults().set(models, for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
                                                
                                                for model in models {
                                                    
                                                    if let imeiString = model.uniqueId {
                                                        
                                                        imeiNumbers.append(imeiString)
                                                        
                                                    }
                                                    
                                                    let keyValue = "Device_" + "\(model.id!)"
                                                    Defaults().set(model, for: Key<TrackerDevicesMapperModel>(keyValue))
                                                }
                                                
                                                Defaults().set(imeiNumbers, for: Key<[String]>("imeiNumbers"))
                                                
                                                if TSMessage.isNotificationActive() {
                                                    TSMessage.dismissActiveNotification()
                                                }
                                                
                                                success(models)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getPositions(success: @escaping ([TrackerPositionMapperModel]) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.requestArray(URL: RCRouter.positions,
                                           loadingMessage: "",
                                           success: { (response: DataResponse<[TrackerPositionMapperModel]>) in
                                            if let models = response.result.value {
                                                
                                                Defaults().set(models, for: Key<[TrackerPositionMapperModel]>("allPositions"))
                                                
                                                //    var expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as! [String] ?? [String]()
                                                
                                                
                                                //#sani
                                                
                                                for model in models {
                                                    
                                                    let keyValue = "Position_" + "\(model.deviceId!)"
                                                    
                                                    //                                            let cordinate = CLLocationCoordinate2D(latitude: (model.latitude)!, longitude(model.longitude)!)
                                                    //                                              self.googleAddress(with: cordinate, onCompletion: { (googleAddress) in
                                                    //                                                    model.address = googleAddress
                                                    //                                                  Defaults().set(model, for: Key<TrackerPositionMapperModel>(keyValue))
                                                    //                                                    if model.id == models.last?.id {
                                                    //                                                            success(models)
                                                    //                                                        }
                                                    //                                                    })
                                                    Defaults().set(model, for: Key<TrackerPositionMapperModel>(keyValue))
                                                    
                                                }
                                                success(models)
                                                
                                            }
                                           }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getEvents(success: @escaping ([EventsModel]) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let calendar = Calendar.current
        let twoDaysAgo = RCGlobals.getFormattedDate(date: calendar.date(byAdding: .day, value: -2, to: Date())!, format: "yyyy-MM-dd")
        let oneDayAhead = RCGlobals.getFormattedDate(date: calendar.date(byAdding: .day, value: +1, to: Date())!, format: "yyyy-MM-dd")
        
        var parameters = ["limit":100, "start":0, "type":"allEvents", "from":twoDaysAgo, "to":oneDayAhead] as [String : Any]
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        let allDevices = RCGlobals.getExpiryFilteredList(data)
        
        var deviceIds: [Int] = []
        for device in allDevices {
            deviceIds.append(device.id!)
            
        }
        parameters["deviceId"] = deviceIds
        
        RCRouterClient.shared.requestArray(URL: RCRouter.events(parameters),
                                           loadingMessage: "",
                                           success: { (response: DataResponse<[EventsModel]>) in
                                            if let models = response.result.value {
                                                Defaults().set(models, for: Key<[EventsModel]>("allEvents"))
                                                success(models)
                                            }
                                           }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getGeofences(loadingMsg:String , with type: String, id: Int, success: @escaping ([GeofenceModel]) -> Void, failure: @escaping (String) -> Void) -> Void {
        let parameters = [type:id]
        RCRouterClient.shared.requestArray(URL: RCRouter.getGeofence(parameters),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<[GeofenceModel]>) in
                                        if let model = response.result.value {
                                            success(model)
                                        }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func linkGeofence(with deviceId: Int, geofenceId: Int, success: @escaping (String) -> Void,
                             failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.linkGeofence(deviceId, geofenceId),
                                      loadingMessage: "Getting geofences",
                                      success: { (response: DataResponse<GeofenceModel>) in
                                        success("success")
                                      }) { (error) in
            if error.localizedDescription == MyError.noDataFoundError.localizedDescription {
                success("success")
            }else {
                failure(error.localizedDescription)
            }
        }
    }
    
    public func unlinkGeofence(with deviceId: Int, geofenceId: Int, success: @escaping (String) -> Void,
                               failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.unlinkGeofence(deviceId, geofenceId),
                                      loadingMessage: "Getting geofences",
                                      success: { (response: DataResponse<GeofenceModel>) in
                                        success("success")
                                      }) { (error) in
            if error.localizedDescription == MyError.noDataFoundError.localizedDescription {
                success("success")
            }else {
                failure(error.localizedDescription)
            }
        }
    }
    
    public func updateGeofence(with geofenceId: Int, type: String, name: String, description: String,
                               area: String, success: @escaping (GeofenceModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let attributes = ["type":type]
        let parameters = ["id":geofenceId, "attributes":attributes, "name":name, "area":area] as [String : Any]
        RCRouterClient.shared.request(URL: RCRouter.updateGeofence(geofenceId, parameters),
                                      loadingMessage: "Updating geofences",
                                      success: { (response: DataResponse<GeofenceModel>) in
                                        if let model = response.result.value {
                                            success(model)
                                            //                                            if model.status == "success" {
                                            //                                                success(model)
                                            //                                            } else {
                                            //                                                failure("Something went wrong")
                                            //                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func deleteGeofence(with geofenceId: Int, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.deleteGeofence(geofenceId),
                                      loadingMessage: "Updating geofences",
                                      success: { (response: DataResponse<GeofenceModel>) in
                                        if let model = response.result.value {
                                            success("success")
                                            print(model)
                                            //                                            if model.status == "success" {
                                            //                                                success("")
                                            //                                            } else {
                                            //                                                failure("Something went wrong")
                                            //                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func getReportPath(with deviceId: Int, fromDate: String, toDate: String, success: @escaping (ReportPathModel) -> Void,
                              failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.getReportPath(deviceId, fromDate, toDate),
                                      loadingMessage: "Getting Details",
                                      success: { (response: DataResponse<ReportPathModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure(model.message!)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getPlaybackRoute(with deviceId: String, fromDate: String, toDate: String, duration: String,
                                 success: @escaping (PlaybackReportModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        //let duration = "1"
        RCRouterClient.shared.request(URL: RCRouter.playbackRoute(deviceId, fromDate, toDate, duration),
                                      loadingMessage: "Getting Path",
                                      success: { (response: DataResponse<PlaybackReportModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure(model.message!)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func owlModeOnOff(with deviceId: Int, type: String, success: @escaping (StringResponseModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        let parameters = ["deviceId":deviceId, "type":type] as [String : Any]
        RCRouterClient.shared.request(URL: RCRouter.owlMode(parameters),
                                      loadingMessage: "Updating Vehicle",
                                      success: { (response: DataResponse<StringResponseModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func createGeofence(with name: String, area: String, type:String, success: @escaping (GeofenceModel) -> Void,
                               failure: @escaping (String) -> Void) -> Void {
        let attributes = ["type":type]
        let parameters = ["id":-1, "name": name, "attributes":attributes, "area": area, "calendarId":0] as [String : Any]
        RCRouterClient.shared.request(URL: RCRouter.createGeofence(parameters),
                                      loadingMessage: "Getting geofences",
                                      success: { (response: DataResponse<GeofenceModel>) in
                                        if let model = response.result.value {
                                            success(model)
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func sendCommand(with deviceId: Int, command:String, success: @escaping (SendCommandModel) -> Void,
                            failure: @escaping (String) -> Void) -> Void {
        
        let attributes = ["data":command]
        let parameters = ["id":0,"description":"New\u{2026}","deviceId":deviceId,"attributes":attributes,"type":"custom",
                          "textChannel":false] as [String : Any]
        
        RCRouterClient.shared.request(URL: RCRouter.sendCommand(parameters),
                                      loadingMessage: "Updating device",
                                      success: { (response: DataResponse<SendCommandModel>) in
                                        if let model = response.result.value {
                                            success(model)
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func sendOverspeedaLERT(deviceId: Int, speed:String, speedType: Bool, deviceProtocolType: String,success: @escaping (SendCommandModel) -> Void,
                                   failure: @escaping (String) -> Void) -> Void {
        
        //{"speedType":true,"type":"gt06","deviceId":29232,"speed":"80"}
        
        let parameters = ["speedType":speedType,"deviceId":deviceId,"speed": speed, "type": deviceProtocolType] as [String : Any]
        
        RCRouterClient.shared.request(URL: RCRouter.sendOverspeedAlert(parameters),
                                      loadingMessage: "Updating device",
                                      success: { (response: DataResponse<SendCommandModel>) in
                                        if let model = response.result.value {
                                            success(model)
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    public func postnotificationonfilter(filterType:String, success: @escaping (String) -> Void,
                                         failure: @escaping (String) -> Void) -> Void {
        
        
        
        let parameters = ["type": filterType] as [String : Any]
        
        RCRouterClient.shared.request(URL: RCRouter.onnotificationfilter(parameters),
                                      loadingMessage: "Please wait...",
                                      success: { (response: DataResponse<NotificationOnFilterModel>) in
                                        if let model = response.result.value {
                                            if let data = model.data {
                                                var value = data
                                                if data.isEmpty {
                                                    value = "1"
                                                }
                                                success(value)
                                            } else {
                                                success("1")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    public func deletenotificationAlert(with filterId: String, filterType:String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.notificationdelete(filterId, filterType),
                                      loadingMessage: "Please wait...",
                                      success: { (response: DataResponse<DeleteNotificationModel>) in
                                        if let model = response.result.value {
                                            success("success")
                                            print(model)
                                        }
                                        
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func getFollowerPath(with deviceId: Int, fromDate: String, toDate: String, success: @escaping (FollowerPathModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.followerPath(deviceId, fromDate, toDate),
                                      loadingMessage: "Getting Path",
                                      success: { (response: DataResponse<FollowerPathModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure(model.message!)
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func getNotifications(success: @escaping (ReportsEventsModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        //        let calendar = Calendar.current
        //        let twoDaysAgo = RCGlobals.getFormattedDate(date: calendar.date(byAdding: .day, value: -2, to: Date())!, format: "yyyy-MM-dd")
        //        let oneDayAhead = RCGlobals.getFormattedDate(date: calendar.date(byAdding: .day, value: +1, to: Date())!, format: "yyyy-MM-dd")
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        let allDevices: [TrackerDevicesMapperModel] = RCGlobals.getExpiryFilteredList(data) 
        
        var deviceIds: [Int] = []
        for device in allDevices {
            deviceIds.append(device.id!)
        }
        
        let deviceIdsString: String = (deviceIds.map{String($0)}).joined(separator: ",")
        
        RCRouterClient.shared.request(URL: RCRouter.getNotifications(deviceIdsString),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<ReportsEventsModel>) in
                                        if let models = response.result.value {
                                            let eventsData: [ReportsEventsModelData] = models.data!
                                            Defaults().set(eventsData, for: Key<[ReportsEventsModelData]>("allNotifications"))
                                            success(models)
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
//    public func addParking(with parameters:[String : Any], loadingMsg: String,
//                            success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
//        
//        RCRouterClient.shared.requestJson(URL: RCRouter.postParkingData(parameters),
//                                      loadingMessage: loadingMsg,
//                                      success: { (response: DataResponse<Any>) in
////                                        if let model = response.result.value {
////                                            if model.status == "success" {
////                                                Defaults().set(model, for: Key<ParkingModeModel>("ParkingModeModel"))
//                                                success("")
////                                            } else {
////                                                failure("Something went wrong")
////                                            }
////                                        }
//                                      }) { (error) in
//            failure(error.localizedDescription)
//        }
//    }
//    public func updateParking(with parameters:[String : Any], loadingMsg: String, id: String,
//                            success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
//        
//        RCRouterClient.shared.requestJson(URL: RCRouter.patchParkingData(id, parameters),
//                                      loadingMessage: loadingMsg,
//                                      success: { (response: DataResponse<Any>) in
////                                        if let model = response.result.value {
////                                            if model.status == "success" {
////                                                Defaults().set(model, for: Key<ParkingModeModel>("ParkingModeModel"))
//                                                success("")
////                                            } else {
////                                                failure("Something went wrong")
////                                            }
////                                        }
//                                      }) { (error) in
//            failure(error.localizedDescription)
//        }
//    }
//    public func getJWTToken(userName:String,password:String,success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
//        let parameters = ["username": userName,"password": password]
//        RCRouterClient.shared.requestJson(URL: RCRouter.getJWTToken(parameters as Parameters),
//                                      loadingMessage: "",
//                                      success: {(response: DataResponse<Any>) in
//                                        if let models = response.result.value {
//                                            if let dictionary = models as? [String: Any] {
//                                                if let token = dictionary["token"] as? String {
//                                                    print(token)
//                                                    Defaults().set(token, for: Key<String>(defaultKeyNames.jwt_token.rawValue))
////                                                    let jwt:String = String(token.dropFirst(7))
////                                                    do {
////                                                        let payload = try self.decode(jwtToken: jwt) as [String: Any]
////                                                        let identity:[String:Any] = payload["identity"]  as! [String: Any]
////                                                        let userId:Int = identity["id"] as! Int
////                                                        let name:String = identity["name"] as! String
////                                                        let type:String = identity["type"] as! String
////                                                        Defaults().set(userId, for: Key<Int>(defaultKeyNames.userId.rawValue))
////                                                        Defaults().set(name, for: Key<String>(defaultKeyNames.name.rawValue))
////                                                        Defaults().set(type, for: Key<String>(defaultKeyNames.userType.rawValue))
////
////                                                        success("success")
////                                                    } catch {
////                                                        failure("failure")
////                                                    }
//                                                }
//                                            } else {
//                                                failure("failure")
//                                            }
//                                        } else {
//                                            failure("failure")
//                                        }
//                                      }) { (error) in
//            failure(error.localizedDescription)
//           
//        }
//    }
    public func getJWTToken(loadingMsg:String,success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        let passowrd = UserDefaults.standard.string(forKey: "userPassword") ?? ""
        let username = UserDefaults.standard.string(forKey: "userName") ?? ""
        
        let parameters = ["username": username,"password": passowrd]
        RCRouterClient.shared.requestJson(URL: RCRouter.getJWTToken(parameters as Parameters),
                                      loadingMessage: "",
                                      success: {(response: DataResponse<Any>) in
                                        if let models = response.result.value {
                                            if let dictionary = models as? [String: Any] {
                                                if let token = dictionary["token"] as? String {
                                                    print(token)
                                                    Defaults().set(token, for: Key<String>(defaultKeyNames.jwt_token.rawValue))
                                                }
                                                success("success")
                                            } else {
                                                failure("failure")
                                            }
                                        } else {
                                            failure("failure")
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
           
        }
    }
    public func getOlderNotifications(lastNotiId: String, success: @escaping (ReportsEventsModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        //        let calendar = Calendar.current
        //        let twoDaysAgo = RCGlobals.getFormattedDate(date: calendar.date(byAdding: .day, value: -2, to: Date())!, format: "yyyy-MM-dd")
        //        let oneDayAhead = RCGlobals.getFormattedDate(date: calendar.date(byAdding: .day, value: +1, to: Date())!, format: "yyyy-MM-dd")
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        let allDevices: [TrackerDevicesMapperModel] = RCGlobals.getExpiryFilteredList(data)
        
        var deviceIds: [Int] = []
        for device in allDevices {
            deviceIds.append(device.id!)
        }
        
        let deviceIdsString: String = (deviceIds.map{String($0)}).joined(separator: ",")
        
        RCRouterClient.shared.request(URL: RCRouter.getOlderNotifications(deviceIdsString, lastNotiId),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<ReportsEventsModel>) in
                                        if let models = response.result.value {
                                            var newNoti = Defaults().get(for: Key<[ReportsEventsModelData]>("allNotifications")) ?? []
                                            let eventsData: [ReportsEventsModelData] = models.data!
                                            for item in eventsData {
                                                newNoti.append(item)
                                            }
                                            Defaults().set(newNoti, for: Key<[ReportsEventsModelData]>("allNotifications"))
                                            success(models)
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    
    public func getnotificationAlert(with loadingMsg:String, success: @escaping (FilterResponseModelData) -> Void,
                                     failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.pyGetNotif,
                                      loadingMessage: "",
                                      success: { (response: DataResponse<FilterResponseModelData>) in
                                        if let model = response.result.value {
                                            Defaults().set(model, for: Key<FilterResponseModelData>("FilterResponseModel"))
                                            success(model)
                                        }
                                        
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    public func postNotificationAlert(with parameters:[String : Any], loadingMsg: String,
                            success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL: RCRouter.pyPostNotif(parameters),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<Any>) in
                                                success("success")
                                      }) { (error) in
                                failure(error.localizedDescription)
        }
    }
    
    public func getUsersHierarchy(success: @escaping (Any) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL:
                                            RCRouter.usersHierarchy(Int(Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0")!),
                                          loadingMessage: "",
                                          success: { (response: DataResponse<Any>) in
                                            if let models = response.result.value {
                                                
                                                let userHierarchy = UsersHerarchy()
                                                
                                                if let dictionary = models as? [String: Any] {
                                                    if let status = dictionary["status"] as? String {
                                                        // access individual value in dictionary
                                                        print(status)
                                                        if let nestedDictionary = dictionary["data"] as? [String: Any] {
                                                            // access all parent users
                                                            for (key, value) in nestedDictionary {
                                                                let tempParentUser = ParentUsers()
                                                                tempParentUser.parentId = key
                                                                
                                                                if (JSONSerialization.isValidJSONObject(value)){
                                                                    if let nestedDictionary2 = value as? [String: Any] {
                                                                        // access all child users
                                                                        for (key, value) in nestedDictionary2 {
                                                                            let tempChildUser = ChildUsers()
                                                                            tempChildUser.childId = key
                                                                            
                                                                            if (JSONSerialization.isValidJSONObject(value)){
                                                                                if let nestedDictionary3 = value as? [String: Any] {
                                                                                    // access child name and devices
                                                                                    for (key, value) in nestedDictionary3 {
                                                                                        tempChildUser.childName = key
                                                                                        if (JSONSerialization.isValidJSONObject(value)){
                                                                                            //contain devices
                                                                                            if let nestedDictionary4 = value as? [String: Any] {
                                                                                                // access child name and devices
                                                                                                let tempUserDevices = UserDevices()
                                                                                                for (key, _) in nestedDictionary4 {
                                                                                                    tempUserDevices.devices.append(key)
                                                                                                }
                                                                                                tempChildUser.childUserDevices = tempUserDevices
                                                                                            }
                                                                                        }else{
                                                                                            //No devices
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            tempParentUser.parentUsers.append(tempChildUser)
                                                                        }
                                                                    }
                                                                }
                                                                userHierarchy.allUsers.append(tempParentUser)
                                                            }
                                                        }
                                                    }
                                                }
                                                Defaults().set(userHierarchy, for: Key<UsersHerarchy>("UsersHerarchy"))
                                                success(models)
                                            }
                                            
                                          }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    //    public func checkLogout(errorString: String) -> String {
    //
    //        if errorString == MyError.notAuthorized.localizedDescription {
    //            RCSocketManager.shared.stopObserving()
    //            RCMapView.clearMap()
    //
    //            OperationQueue.main.addOperation {
    //                let closureHandler1 = { (action:UIAlertAction!) -> Void in
    //                    self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
    //                }
    //                self.prompt("Message", errorString, "Logout", handler1: closureHandler1)
    //            }
    //
    //            let domain = Bundle.main.bundleIdentifier!
    //            UserDefaults.standard.removePersistentDomain(forName: domain)
    //            UserDefaults.standard.synchronize()
    //            self.view.window?.rootViewController = LoginViewController()
    //
    //
    //        }
    //        return errorString
    //    }
    
    public func parkingMode(with deviceId: Int, mode: String,
                            success: @escaping (ParkingModeModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        var loadingMessage = ""
        let parameters = ["deviceId": deviceId, "mode": mode ] as [String : Any]
        if mode == "on" {
            loadingMessage = "Activating Parking Mode"
        } else {
            loadingMessage = "Deactivating Parking Mode"
        }
        RCRouterClient.shared.request(URL: RCRouter.parkingMode(parameters),
                                      loadingMessage: loadingMessage,
                                      success: { (response: DataResponse<ParkingModeModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<ParkingModeModel>("ParkingModeModel"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func UpdateUseDetails(with id:String, fname:String,lname:String,email:String,mobile:String,
                                 success:@escaping(UpdateUseDetails) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        let parameters = ["fname": fname, "lname": lname, "email":email,"mobile":mobile ] as [String : Any]
        RCRouterClient.shared.request(URL: RCRouter.UpdateUseDetails(id,parameters),
                                      loadingMessage: "Updating user details",
                                      success: { (response: DataResponse<UpdateUseDetails>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<UpdateUseDetails>("UpdateUseDetails"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    
    public func loginInfo(with id:Int,success:@escaping(loginInfoModel) -> Void, failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.loginInfo(id),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<loginInfoModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<loginInfoModel>("loginInfoModel"))
                                                Defaults().set(model.data?.user?.login ?? "user", for: Key<String>("loginType"))
                                                Defaults().set(model.data?.user?.google_assistant_email ?? "", for: Key<String>("google_assistant_email"))
                                                Defaults().set(model.data?.user?.default_device_id ?? "0", for: Key<String>("default_device_id"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func updateACDoorSirenAlarm(with parameters: [String:Any],
                                       userId: String,
                                       loadingMsg: String,
                                       success: @escaping (String) -> Void,
                                       failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL: RCRouter.updateACDoorSirenAlarm(userId, parameters),
                                          loadingMessage: loadingMsg,
                                          success: { (_) in
                                            success("success")
                                          }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    
    public func lastActivationTime(with id:Int,loadingMsg:String,success:@escaping(LastActivationTimeModel) -> Void,
                                   failure: @escaping (String) -> Void) -> Void {
        
        RCRouterClient.shared.request(URL: RCRouter.lastActivationTime(id), loadingMessage:loadingMsg,
                                      success: { (response: DataResponse<LastActivationTimeModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                Defaults().set(model, for: Key<LastActivationTimeModel>("LastActivationTimeModel"))
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func singleVehicleGeoFence(with type: String, deviceId: Int,
                                      success: @escaping ([SingleVehicleGeoFence]) -> Void,
                                      failure: @escaping (String) -> Void) -> Void {
        let parameters = [type:deviceId]
        RCRouterClient.shared.requestArray(URL: RCRouter.singleVehicleGeoFence(parameters),
                                           loadingMessage: "",
                                           success: { (response: DataResponse<[SingleVehicleGeoFence]>) in
                                            if let model = response.result.value {
                                                success(model)
                                            }
                                           }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getDevicesDetails(_ loadingMsg:String = "",success: @escaping (EditDevicesInfosModel) -> Void,
                                  failure: @escaping (String) -> Void) -> Void {
        let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        RCRouterClient.shared.request(URL: RCRouter.getDeviceDetails(userID),
                                      loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<EditDevicesInfosModel>) in
                                        if let model = response.result.value {
                                            Defaults().set(model, for: Key<EditDevicesInfosModel>("EditDevicesInfosModel"))
                                            success(model)
                                        }
                                        
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getUserImageData(imageName: String, success: @escaping(UserCarsDocsModel) -> Void,
                                 failure: @escaping(String) -> Void) -> Void {
        let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        RCRouterClient.shared.request(URL: RCRouter.getUserImageData(userID, imageName), loadingMessage: "Please wait", success: { (response: DataResponse<UserCarsDocsModel>) in
            if let model = response.result.value {
                success(model)
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func putUsersCarsData(deviceId: String, first: String, second: String, deviceDetails: [String:Any] = [:],
                                 success: @escaping(PutUsersCarDataModel) -> Void,
                                 failure: @escaping(String) -> Void) -> Void {
        
        var parameter : [String: Any] = [:]
        if first == "" {
            parameter = deviceDetails
            
        } else {
            parameter = [first: second]
        }
        RCRouterClient.shared.request(URL: RCRouter.putCarsData(deviceId, parameter), loadingMessage: "", success: { (response: DataResponse<PutUsersCarDataModel>) in
            if let model = response.result.value {
                success(model)
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func putParkingSchedule(deviceID: Int , isSchedulerOn: Bool, days: [String],
                                   start_time: String,end_time:String, success: @escaping (String) -> Void,
                                   failure: @escaping (String) -> Void) -> Void {
        let parkingScheduleData = Defaults().get(for: Key<[ParkingSchedulerModelData]>("parkingScheduler")) ?? []
        var parkingData: ParkingSchedulerModelData? = nil
        for item in parkingScheduleData {
            if ((item.device_id ?? 0) == Int(deviceID) ) {
                parkingData = item
                break
            }
        }
        let parameters = ["device_id": deviceID, "parking_schedule": isSchedulerOn, "parking_schedule_days":days,"parking_schedule_start_utc":start_time,"parking_schedule_end_utc":end_time ]
            as [String : Any]
        var requestData:[[String:Any]] = []
        requestData.append(parameters)
        if parkingData != nil {
            RCRouterClient.shared.requestJson(URL: RCRouter.putParkingModeSchedulerDetails("\(parkingData?.id ?? 0)", parameters), loadingMessage: "Saving Details",success: { (response: DataResponse<Any>) in
                success(" String")
            })
            { (error) in
                failure(error.localizedDescription)
            }
        } else {
            RCRouterClient.shared.requestJson(URL: RCRouter.postParkingModeSchedulerDetails(requestData), loadingMessage: "Saving Details",success: { (response: DataResponse<Any>) in
            success(" String")
            
        })
        { (error) in
            failure(error.localizedDescription)
            }
        }
    }
    
    public func syncVehicleModes(loadingMsg: String,success: @escaping(SyncVehicleModesModel) -> Void, failure: @escaping(String) -> Void) -> Void {
        let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        RCRouterClient.shared.request(URL: RCRouter.syncVehicleModes(userID), loadingMessage: loadingMsg,
                                      success: { (response: DataResponse<SyncVehicleModesModel>) in
                                        if let model = response.result.value {
                                            if model.status == "success" {
                                                success(model)
                                            } else {
                                                failure("Somthing went wrong, please try again later.")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getDevicesPopupDetails(deviceID: String, date: String, success: @escaping(DevicePopupDetailsModel) -> Void,
                                       failure: @escaping(String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.devicePopUpDetails(deviceID, date), loadingMessage: "", success: { (response: DataResponse<DevicePopupDetailsModel>) in
            if let model = response.result.value {
                if model.status == "success" {
                    success(model)
                } else {
                    failure("Somthing went wrong, please try again later.")
                }
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
    }
    
    public func getParkingSchedule(deviceID: Int, loadingMessage:String , success: @escaping (ParkingSchedulerData) -> Void,
                                   failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.request(URL: RCRouter.getParkingModeSchedulerDetails(),
                                      loadingMessage: loadingMessage,
                                      success: { (response: DataResponse<ParkingSchedulerData>) in
                                        if let model = response.result.value {
                                            if model.status ?? false {
                                                success(model)
                                            } else {
                                                failure("Something went wrong")
                                            }
                                        }
                                      }) { (error) in
            failure(error.localizedDescription)
        }
    }
//    public func getParkingSchedule(with loadingMessage:String , success: @escaping  (ParkingSchedulerModel) -> Void,
//                                   failure: @escaping (String) -> Void) -> Void {
////        let userName = ""
////        let pass = ""
//
////        let parameters: [String:Any] = ["username":userName,"password":pass]
//        RCRouterClient.shared.request(URL: RCRouter.getParkingData,
//                                      loadingMessage: loadingMessage,
//                                      success: { (response: DataResponse<ParkingSchedulerModel>) in
//                                        if let model = response.result.value {
//                                            if model.success == true {
//                                                success(model)
//                                            } else {
//                                                failure("Something went wrong")
//                                            }
//                                        }
//                                      }) { (error) in
//            failure(error.localizedDescription)
//        }
//    }
    public func liveStreaming(loadingMsg:String
                              ,deviceID: Int, parameters:[String:Any], success: @escaping(String) -> Void,
                              failure: @escaping(String) -> Void) -> Void {
        
        RCRouterClient.shared.requestJson(URL: RCRouter.liveStreaming(parameters), loadingMessage: loadingMsg, success: { (_) in
            
            Defaults().set(deviceID, for: Key<Int>("streamingDeviceId"))
            
            success("success")
            
        }) { (err) in
            
            failure(err.localizedDescription)
        }
        
    }
    public func checkUserExists(with countryCode: String, usernName: String, loadingMsg:String, success: @escaping (CheckUserModel) -> Void, failure: @escaping (String) -> Void) -> Void {
           RCRouterClient.shared.request(URL: RCRouter.checkUser(countryCode,usernName),
                                         loadingMessage: loadingMsg,
                                         success: { (response: DataResponse<CheckUserModel>) in
               if let model = response.result.value {
                   //                          if model.status == "success" {
                   if model.message == "User already exists." {
                       failure(model.message ?? "")
                   } else {
                       Defaults().set(model, for: Key<CheckUserModel>("CheckUserModel"))
                       success(model)
                   }
                   //                          } else {
                   //                            failure("Something went wrong, please try again")
                   //                          }
               }
           }) { (error) in
               failure(error.localizedDescription)
           }
       }
       public func deleteUser(success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
              let userId = (Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel")))?.id ?? 0
              RCRouterClient.shared.requestJson(URL: RCRouter.deleteUser(userId),
                                            loadingMessage: "",
                                            success: { (response: DataResponse<Any>) in
                  if let models = response.result.value {
                      if let dictionary = models as? [String: Any] {
                          if let taskId = dictionary["task_id"] as? String {
                              print(taskId)
                              Defaults().set(taskId, for: Key<String>(defaultKeyNames.taskId.rawValue))
                              success(taskId)
                          }
                      }
                  } else {
                      failure("Request failed.")
                  }
              }) { (error) in
                  failure(error.localizedDescription)
              }
              
          }
          public func getTaskStatusRequest(loadingMsg:String ,taskId: String, success: @escaping (_ Dictionary:[String: Any] ) -> Void,
                                failure: @escaping (String) -> Void) -> Void {
              RCRouterClient.shared.requestJson(URL: RCRouter.taskStatusRequest(taskId),
                                            loadingMessage:loadingMsg,
                                            success: {(response: DataResponse<Any>) in
                                              if let models = response.result.value {
                                                  if let dictionary = models as? [String: Any] {
                                                      success(dictionary)
                                                  }
                                              }
                                            }) { (error) in
                  failure(error.localizedDescription)
              }
          }
    
    
    
    public func getOTP(username: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        RCRouterClient.shared.requestJson(URL: RCRouter.getOTP(username),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<Any>) in
            if let _ = response.result.value {
                success("success")
            } else {
                failure("Request failed.")
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
    public func verifyOTP(otp: String, success: @escaping (String) -> Void, failure: @escaping (String) -> Void) -> Void {
        let username = Defaults().get(for: Key<String>("signUpUserName")) ?? ""
        let password = Defaults().get(for: Key<String>("signupPassword")) ?? ""
        let parameters:[String:String] = ["username":"\(username)","password":"\(password)","otp":"\(otp)","company_id":companyId]
        RCRouterClient.shared.requestJson(URL: RCRouter.verifyOTP(parameters),
                                      loadingMessage: "",
                                      success: { (response: DataResponse<Any>) in
            if let models = response.result.value {
                if let dictionary = models as? [String: Any] {
                    if let taskId = dictionary["task_id"] as? String {
                        print(taskId)
                        Defaults().set(taskId, for: Key<String>(defaultKeyNames.taskId.rawValue))
                        success(taskId)
                    }
                }else{
                    success("success")
                }
            } else {
                failure("Request failed.")
            }
        }) { (error) in
            failure(error.localizedDescription)
        }
        
    }
    
}


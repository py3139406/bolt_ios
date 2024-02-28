//
//    TrackerDevicesMapperModel
//
//    Create by Anshul Jain on 1/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class TrackerDevicesMapperModel : Codable, Mappable{
    
    var attributes : DeviceAttribute?
    var category : String?
    var contact : String?
    var geofenceIds : [Int]?
    var groupId : Int?
    var id : Int!
    var lastUpdate : String?
    var model : String?
    var name : String?
    var phone : String?
    var positionId : Int64!
    var status : String?
    var uniqueId : String?
    var vechileIdelTime:String?
    var showIdleIcon:Bool?
    
    init() {
        
    }
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        attributes <- map["attributes"]
        category <- map["category"]
        contact <- map["contact"]
        geofenceIds <- map["geofenceIds"]
        groupId <- map["groupId"]
        id <- map["id"]
        lastUpdate <- map["lastUpdate"]
        model <- map["model"]
        name <- map["name"]
        phone <- map["phone"]
        positionId <- map["positionId"]
        status <- map["status"]
        uniqueId <- map["uniqueId"]
        vechileIdelTime <- map["vechileIdelTime"]
        showIdleIcon <- map["showIdleIcon"]
        
        
    }
    
    enum CodingKeys: String, CodingKey {
        case attributes
        case category = "category"
        case contact = "contact"
        case geofenceIds = "geofenceIds"
        case groupId = "groupId"
        case id = "id"
        case lastUpdate = "lastUpdate"
        case model = "model"
        case name = "name"
        case phone = "phone"
        case positionId = "positionId"
        case status = "status"
        case uniqueId = "uniqueId"
        case vechileIdelTime = "vechileIdelTime"
        case showIdleIcon = "showIdleIcon"
        
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        attributes = try values.decodeIfPresent(DeviceAttribute.self, forKey:.attributes)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        contact = try values.decodeIfPresent(String.self, forKey: .contact)
        geofenceIds = try values.decodeIfPresent([Int].self, forKey: .geofenceIds)
        groupId = try values.decodeIfPresent(Int.self, forKey: .groupId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lastUpdate = try values.decodeIfPresent(String.self, forKey: .lastUpdate)
        model = try values.decodeIfPresent(String.self, forKey: .model)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        positionId = try values.decodeIfPresent(Int64.self, forKey: .positionId)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        uniqueId = try values.decodeIfPresent(String.self, forKey: .uniqueId)
        vechileIdelTime = try values.decodeIfPresent(String.self, forKey: .vechileIdelTime)
        showIdleIcon = try values.decodeIfPresent(Bool.self, forKey: .showIdleIcon)
       
    }
}

class DeviceAttribute : Codable, Mappable{
    
    var alertNumber : String?
    var centerNumber : String?
    var countryCode : String?
    var overspeedAlert : String?
    var overspeedValue : String?
    var vibrationAlert : String?
    var prevOdometer :  Int?
    var imei: String?
    var speedLimit: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        alertNumber <- map["alertNumber"]
        centerNumber <- map["centerNumber"]
        countryCode <- map["countryCode"]
        overspeedAlert <- map["overspeedAlert"]
        overspeedValue <- map["overspeedValue"]
        vibrationAlert <- map["vibrationAlert"]
        prevOdometer <- (map["prevOdometer"])
        imei <- map["imei"]
        speedLimit <- map["speedLimit"]
    }
    
    
    enum CodingKeys: String, CodingKey {
        case alertNumber = "alertNumber"
        case centerNumber = "centerNumber"
        case countryCode = "countryCode"
        case overspeedAlert = "overspeedAlert"
        case overspeedValue = "overspeedValue"
        case vibrationAlert = "vibrationAlert"
        case prevOdometer = "prevOdometer"
        case imei = "imei"
        case speedLimit = "speedLimit"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        alertNumber = try values.decodeIfPresent(String.self, forKey: .alertNumber)
        centerNumber = try values.decodeIfPresent(String.self, forKey: .centerNumber)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        overspeedAlert = try values.decodeIfPresent(String.self, forKey: .overspeedAlert)
        overspeedValue = try values.decodeIfPresent(String.self, forKey: .overspeedValue)
        vibrationAlert = try values.decodeIfPresent(String.self, forKey: .vibrationAlert)
        imei = try values.decodeIfPresent(String.self, forKey: .imei)
        speedLimit = try values.decodeIfPresent(String.self, forKey: .speedLimit)
        
        if let temp = try values.decodeIfPresent(Int.self, forKey: .prevOdometer) {
            prevOdometer = temp
        } else {
            prevOdometer = 0
//            if let tmpPrevOdometer = try values.decodeIfPresent(Int.self, forKey: .prevOdometer) {
//                prevOdometer = tmpPrevOdometer
//            }else {
//                prevOdometer = 0
//            }
        }
      
    }
}

class TrackerDeviceResponseMapperModel: Codable,Mappable {
    var data : [TrackerDevicesMapperModel]?
    var message : String?
    var status : String?

    required init?(map: Map){}

    func mapping(map: Map){
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

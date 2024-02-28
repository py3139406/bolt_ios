//
//    EventsModel.swift
//
//    Create by Anshul Jain on 2/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class EventsModel : Codable, Mappable{
    
    var attributes : String?
    var deviceId : Int?
    var geofenceId : Int?
    var id : Int!
    var positionId : Int64?
    var serverTime : String?
    var type : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        attributes <- map["attributes"]
        deviceId <- map["deviceId"]
        geofenceId <- map["geofenceId"]
        id <- map["id"]
        positionId <- map["positionId"]
        serverTime <- map["serverTime"]
        type <- map["type"]
        
    }
}

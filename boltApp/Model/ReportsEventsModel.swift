//
//  ReportsEventsModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation

import ObjectMapper


class ReportsEventsModel : Codable, Mappable{
    
    var data : [ReportsEventsModelData]?
    var message : String?
    var status : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
    
}


class ReportsEventsModelData : Codable, Mappable{
    
    var attributes : ReportsEventsModelAttribute?
    var deviceId : Int?
    var geofenceId : Int64?
    var name: String?
    var id : Int64!
    var positionId : Int64?
    var type : String?
    var geofencename : String?
    var fixtime : Int64?
    var serverTime : Int64?
    var latitude : Double?
    var longitude : Double?
    var address : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        attributes <- map["attributes"]
        deviceId <- map["deviceid"]
        geofenceId <- (map["geofenceId"],RCInteger64Transformer())
        id <- (map["id"],RCInteger64Transformer())
        positionId <- (map["positionId"],RCInteger64Transformer())
        fixtime <- map["fixtime"]
        type <- map["type"]
        name <- map["name"]
        geofencename <- map["geofencename"]
        serverTime <- map["serverTime"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        address <- map["address"]
    }
    
}


class ReportsEventsModelAttribute : Codable, Mappable{
    
    var alarmType : String?
    var speed : Double?
    var speedLimit : Double?
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        alarmType <- map["alarm"]
        speed <- map["speed"]
        speedLimit <- map["speedLimit"]
    }
    
    
}

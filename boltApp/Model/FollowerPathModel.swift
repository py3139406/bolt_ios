//
//    FollowerPathModel.swift
//
//    Create by Anshul Jain on 20/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class FollowerPathModel : Codable, Mappable{
    
    var data : [FollowerPathModelData]?
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

class FollowerPathModelData : Codable, Mappable{
    
    var accuracy : Int?
    var address : String?
    var altitude : Int?
    var attributes : FollowerPathModelAttribute?
    var course : Int?
    var deviceId : Int?
    var deviceTime : String?
    var fixTime : String?
    var id : Int64?
    var latitude : Double?
    var longitude : Double?
    var outdated : Bool?
    var protocol1 : String?
    var serverTime : String?
    var speed : Int?
    var type : String?
    var valid : Bool?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        accuracy <- map["accuracy"]
        address <- map["address"]
        altitude <- map["altitude"]
        attributes <- map["attributes"]
        course <- map["course"]
        deviceId <- map["deviceId"]
        deviceTime <- map["deviceTime"]
        fixTime <- map["fixTime"]
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        outdated <- map["outdated"]
        protocol1 <- map["protocol"]
        serverTime <- map["serverTime"]
        speed <- map["speed"]
        type <- map["type"]
        valid <- map["valid"]
        
    }
}

class FollowerPathModelAttribute : Codable, Mappable{
    
    var distance : Float?
    var ignition : Bool?
    var motion : Bool?
    var sat : Int?
    var totalDistance : Float?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        distance <- map["distance"]
        ignition <- map["ignition"]
        motion <- map["motion"]
        sat <- map["sat"]
        totalDistance <- map["totalDistance"]
        
    }
}

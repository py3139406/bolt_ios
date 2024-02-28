//
//  DeviceResponseModel.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper

class DeviceResponseModel : Codable, Mappable{
    
    var attributes : Attribute2?
    var deviceId : Int?
    var geofenceId : Int?
    var id : Int?
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


class Attribute2 : Codable, Mappable{
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        
    }
    
   
    
}

//
//  DeviceDailyPathModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class DeviceDailyPathModel : Codable, Mappable {
    
    var data : [DeviceDailyPathModelData]?
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
class DeviceDailyPathModelData : Codable, Mappable {
    
    var course : String?
    var fixtime : String?
    var id : String?
    var ignition : String?
    var latitude : String?
    var longitude : String?
    var servertime : String?
    var speed : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        course <- map["course"]
        fixtime <- map["fixtime"]
        id <- map["id"]
        ignition <- map["ignition"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        servertime <- map["servertime"]
        speed <- map["speed"]
        
    }
   
    
}

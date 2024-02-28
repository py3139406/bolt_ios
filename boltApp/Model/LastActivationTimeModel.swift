//
//  LastActivationTime.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class LastActivationTimeModel :Codable, Mappable{
    
    var data : [LastActivationTimeData]?
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


class LastActivationTimeData : Codable, Mappable{
    var deviceId : String?
    var ignitionTime : String?
    var type : String?
 
    required init?(map: Map){}
  
    func mapping(map: Map)
    {
        deviceId <- map["deviceId"]
        ignitionTime <- map["ignitionTime"]
        type <- map["type"]
        
    }
    

    
    
    
}

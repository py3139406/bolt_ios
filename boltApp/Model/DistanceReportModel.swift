//
//  DistanceReportModel.swift
//  Bolt
//
//  Created by Shanky on 27/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper


class DistanceReportModel : Codable, Mappable{
    
    var data : [DistanceReportModelData]?
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

class DistanceReportModelData : Codable, Mappable{
    
    var deviceId : String?
    var deviceName : String?
    var distance : String?
    var startTime : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        deviceId <- (map["device_id"], StringTransform())
        deviceName <- map["device_name"]
        distance <- (map["distance"], StringTransform())
        startTime <- map["start_time"]
    }
}

class ParticularDistanceReportModel{
    var deviceId : String?
    var deviceName : String?
    var distanceList : [String] = []
    var totalDistance : Double = 0
}

//
//  ReachabilityReportModel.swift
//  Bolt
//
//  Created by Shanky on 27/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper


class ReachabilityReportModel : Codable, Mappable{
    
    var data : [ReachabilityReportModelData]?
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

class ReachabilityReportModelData : Codable, Mappable{
    
    var deviceId : String?
    var deviceName : String?
    var distance : String?
    var startTime : String?
    var status : String?
    var dateAdded : String?
    var radius : String?
    var reachDate : String?
    var latAtReach : String?
    var lngAtReach : String?
    var geofenceId : String?
    var lat : String?
    var lng : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        deviceId <- (map["device_id"], StringTransform())
        deviceName <- map["deviceName"]
        distance <- (map["distance"], StringTransform())
        startTime <- map["start_time"]
        status <- map["status"]
        dateAdded <- map["date_added"]
        radius <- (map["radius"], StringTransform())
        reachDate <- map["reach_date"]
        latAtReach <- (map["lat_at_reach"], StringTransform())
        lngAtReach <- (map["lng_at_reach"], StringTransform())
        geofenceId <- (map["geofence_id"], StringTransform())
        lat <- (map["lat"], StringTransform())
        lng <- (map["lng"], StringTransform())
    }
}

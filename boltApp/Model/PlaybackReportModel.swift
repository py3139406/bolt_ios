//
//  PlaybackReportModel.swift
//  Bolt
//
//  Created by Roadcast on 06/02/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper


class PlaybackReportModel : Codable, Mappable{
    
    var data : [PlaybackReportModelData]?
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

class PlaybackReportModelData : Codable, Mappable {
    
    var course : String?
    var fixtime : String = ""
    var id : String?
    var ignition : String?
    var latitude : String?
    var longitude : String?
    var speed : String?
    var totalDistance: Double?
    var distance: Double?
    
   
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        course <- map["course"]
        fixtime <- map["fixtime"]
        id <- map["id"]
        ignition <- map["ignition"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        speed <- map["speed"]
        totalDistance <- map["totalDistance"]
        distance <- map["distance"]
        
    }
}
//class PlaybackEventsModelAttribute : Codable, Mappable{
//
//    var totalDistance : Double?
//    var ignition : Bool?
//
//    required init?(map: Map) {}
//
//   func mapping(map: Map)
//   {
//       totalDistance <- map["totalDistance"]
//       ignition <- map["ignition"]
//}
//}

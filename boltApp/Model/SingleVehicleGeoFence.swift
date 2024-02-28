//
//  SingleVehicleGeoFence.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class SingleVehicleGeoFence : Codable, Mappable{
    
    var area : String?
    var attributes : SingleVehicleGeoFenceAttribute?
    var calendarId : Int?
    var descriptionField : String?
    var id : Int?
    var name : String?

    required init?(map: Map){}
   
    
    func mapping(map: Map)
    {
        area <- map["area"]
        attributes <- map["attributes"]
        calendarId <- map["calendarId"]
        descriptionField <- map["description"]
        id <- map["id"]
        name <- map["name"]
        
    }
  
}

class SingleVehicleGeoFenceAttribute : Codable, Mappable{
    
    var areaColor : String?
    var type : String?
    

    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        areaColor <- map["areaColor"]
        type <- map["type"]
        
    }

    
}

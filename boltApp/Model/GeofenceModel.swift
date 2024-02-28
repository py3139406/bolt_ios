//
//    GeofenceModel.swift
//
//    Create by Anshul Jain on 7/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class GeofenceModel : Codable, Mappable {
    
    var area : String = ""
    var attributes : GeofenceModelAttribute?
    var calendarId : Int = 0
    var descriptionField : String = ""
    var id : Int = 0
    var name : String = ""
    
    
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

class GeofenceModelAttribute : Codable, Mappable{
    
    var type : String?
    var areaColor: String?
    var set_default: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        type <- map["type"]
        areaColor <- map["areaColor"]
        set_default <- map["set_default"]
        
    }
}

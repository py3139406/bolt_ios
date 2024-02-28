//
//    ReportPathModel.swift
//
//    Create by Anshul Jain on 9/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class ReportPathModel : Codable, Mappable{
    
    var data : [ReportPathModelData]?
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

class ReportPathModelData : Codable, Mappable{
    
    var course : String?
    var fixtime : String?
    var id : String?
    var ignition : String?
    var latitude : String?
    var longitude : String?
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
        speed <- map["speed"]
        
    }
}

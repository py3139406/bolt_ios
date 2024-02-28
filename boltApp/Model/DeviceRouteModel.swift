//
//    DeviceRouteModel.swift
//
//    Create by Anshul Jain on 6/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class DeviceRouteModel : Codable, Mappable{
    
    var data : [DeviceRouteModelData]?
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

class DeviceRouteModelData : Codable, Mappable{
    
    var course : String?
    var id : String?
    var ignition : String?
    var latitude : String?
    var longitude : String?
    var speed : String?
    var servertime : String?
    var fixtime : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        course <- map["course"]
        id <- map["id"]
        ignition <- map["ignition"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        speed <- map["speed"]
        servertime <- map["servertime"]
        fixtime <- map["fixtime"]
        
    }
}

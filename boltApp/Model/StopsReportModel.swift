//
//    StopsReportModel.swift
//
//    Create by Anshul Jain on 6/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class StopsReportModel : Codable, Mappable{
    
    var data : [StopsReportModelData]?
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

class StopsReportModelData : Codable, Mappable{
    
    var address : String?
    var averageSpeed : String?
    var deviceId : String?
    var deviceName : String?
    var distance : String?
    var duration : String?
    var endTime : String?
    var engineHours : String?
    var latitude : String?
    var longitude : String?
    var maxSpeed : String?
    var positionId : String?
    var spentFuel : String?
    var startTime : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        address <- map["address"]
        averageSpeed <- (map["averageSpeed"], StringTransform())
        deviceId <- (map["deviceId"], StringTransform())
        deviceName <- map["deviceName"]
        distance <- (map["distance"], StringTransform())
        duration <- (map["duration"], StringTransform())
        endTime <- map["endTime"]
        engineHours <- (map["engineHours"], StringTransform())
        latitude <- (map["latitude"], StringTransform())
        longitude <- (map["longitude"], StringTransform())
        maxSpeed <- map["maxSpeed"]
        positionId <- (map["positionId"], StringTransform())
        spentFuel <- (map["spentFuel"], StringTransform())
        startTime <- map["startTime"]
        
    }
}

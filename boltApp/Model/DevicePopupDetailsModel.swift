//
//  DevicePopupDetailsModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class DevicePopupDetailsModel : Codable, Mappable {
    
    var data : DevicePopupDetailsModelData?
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
class DevicePopupDetailsModelData : Codable, Mappable {
    
    var averageSpeed : Double?
    var deviceId : String?
    var distance : Double?
    var endPosId : String?
    var endTime : String?
    var engineHours : Int?
    var idleTime : Int?
    var maxSpeed : String?
    var maxSpeedTime : String?
    var noOfStops : Int?
    var spentFuel : Int?
    var startPosId : String?
    var startTime : String?
    var tripDistance : Double?
    var tripDuration : Int?
    

    required init?(map: Map){}

    
    func mapping(map: Map)
    {
        averageSpeed <- map["averageSpeed"]
        deviceId <- map["deviceId"]
        distance <- map["distance"]
        endPosId <- map["endPosId"]
        endTime <- map["endTime"]
        engineHours <- map["engineHours"]
        idleTime <- map["idleTime"]
        maxSpeed <- map["maxSpeed"]
        maxSpeedTime <- map["maxSpeedTime"]
        noOfStops <- map["noOfStops"]
        spentFuel <- map["spentFuel"]
        startPosId <- map["startPosId"]
        startTime <- map["startTime"]
        tripDistance <- map["tripDistance"]
        tripDuration <- map["tripDuration"]
        
    }
    
    
    
    
}

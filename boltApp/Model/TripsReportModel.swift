//
//    TripsReportModel.swift
//
//    Create by Anshul Jain on 6/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class TripsReportModel : Codable, Mappable{
    
    var data : [TripsReportModelData]?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        
    }
}

class TripsReportModelData : Codable, Mappable{
    
    var timestamp : String?
    var avg_speed : Double?
    var crash : Int?
    var device_id : Int?
    var device_name : String?
    var distance : Double?
    var driver_mobile : String?
    var driver_name : String?
    var driving_safety_score : Double?
    var duration : String?
    var end_battery_level : String?
    var end_lat : Double?
    var end_lng : Double?
    var end_location : String?
    var end_odometer : Int?
    var end_position_id : Int?
    var end_power : String?
    var end_time : String?
    var excessive_idle_time : String?
    var excessive_over_speed : Int?
    var harsh_acceleration : Int?
    var harsh_braking : Int?
    var harsh_cornering : Int?
    var max_speed : Double?
    var max_speed_time : String?
    var night_driving_count : Int?
    var over_ignition : Int?
    var over_motion : Int?
    var over_speed : Int?
    var power_difference : String?
    var start_battery_level : String?
    var start_lat : Double?
    var start_lng : Double?
    var start_location : String?
    var start_odometer : Int?
    var start_position_id : Int?
    var start_power : String?
    var start_time : String?
    var utilization : Double?
    var endAddress : String?
    var startAddress : String?
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        timestamp <- map["@timestamp"]
        avg_speed <- map["avg_speed"]
        crash <- map["crash"]
        device_id <- map["device_id"]
        device_name <- map["device_name"]
        distance <- map["distance"]
        driver_mobile <- map["driver_mobile"]
        driver_name <- map["driver_name"]
        driving_safety_score <- map["driving_safety_score"]
        duration <- map["duration"]
        end_battery_level <- map["end_battery_level"]
        end_lat <- map["end_lat"]
        end_lng <- map["end_lng"]
        end_location <- map["end_location"]
        end_odometer <- map["end_odometer"]
        end_position_id <- map["end_position_id"]
        end_power <- map["end_power"]
        end_time <- map["end_time"]
        excessive_idle_time <- map["excessive_idle_time"]
        excessive_over_speed <- map["excessive_over_speed"]
        harsh_acceleration <- map["harsh_acceleration"]
        harsh_braking <- map["harsh_braking"]
        harsh_cornering <- map["harsh_cornering"]
        max_speed <- map["max_speed"]
        max_speed_time <- map["max_speed_time"]
        night_driving_count <- map["night_driving_count"]
        over_ignition <- map["over_ignition"]
        over_motion <- map["over_motion"]
        over_speed <- map["over_speed"]
        power_difference <- map["power_difference"]
        start_battery_level <- map["start_battery_level"]
        start_lat <- map["start_lat"]
        start_lng <- map["start_lng"]
        start_location <- map["start_location"]
        start_odometer <- map["start_odometer"]
        start_position_id <- map["start_position_id"]
        start_power <- map["start_power"]
        start_time <- map["start_time"]
        utilization <- map["utilization"]
        endAddress <- map["endAddress"]
        startAddress <- map["startAddress"]
        
    }
}

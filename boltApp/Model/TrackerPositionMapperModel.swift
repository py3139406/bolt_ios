//
//    TrackerPositionMapperModel.swift
//
//    Create by Anshul Jain on 1/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class TrackerPositionMapperModel : Codable, Mappable{
    
    var accuracy : Float?
    var address : String?
    var altitude : Float?
    var attributes : PositionMapperAttribute?
    var course : Float?
    var deviceId : Int?
    var deviceTime : String?
    var fixTime : String?
    var id : Int64?
    var latitude : Double?
    var longitude : Double?
//    var network : String?
    var outdated : Bool?
    var protocl : String?
    var serverTime : String?
    var speed : Float?
    var type : String?
    var valid : Bool?
    
    enum CodingKeys: String, CodingKey {
        case accuracy = "accuracy"
        case address = "address"
        case altitude = "altitude"
        case attributes
        case course = "course"
        case deviceId = "deviceId"
        case deviceTime = "deviceTime"
        case fixTime = "fixTime"
        case id = "id"
        case latitude = "latitude"
        case longitude = "longitude"
        //        case network = "network"
        case outdated = "outdated"
        case protocl = "protocol"
        case serverTime = "serverTime"
        case speed = "speed"
        case type = "type"
        case valid = "valid"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accuracy = try values.decodeIfPresent(Float.self, forKey: .accuracy)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        altitude = try values.decodeIfPresent(Float.self, forKey: .altitude)
        attributes = try values.decodeIfPresent(PositionMapperAttribute.self, forKey:.attributes)
        course = try values.decodeIfPresent(Float.self, forKey: .course)
        deviceId = try values.decodeIfPresent(Int.self, forKey: .deviceId)
        deviceTime = try values.decodeIfPresent(String.self, forKey: .deviceTime)
        fixTime = try values.decodeIfPresent(String.self, forKey: .fixTime)
        id = try values.decodeIfPresent(Int64.self, forKey: .id)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        //        network = try values.decodeIfPresent(String.self, forKey: .network)
        outdated = try values.decodeIfPresent(Bool.self, forKey: .outdated)
        protocl = try values.decodeIfPresent(String.self, forKey: .protocl)
        serverTime = try values.decodeIfPresent(String.self, forKey: .serverTime)
        speed = try values.decodeIfPresent(Float.self, forKey: .speed)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        valid = try values.decodeIfPresent(Bool.self, forKey: .valid)
    }
    
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        accuracy <- map["accuracy"]
//        address <- map["address"]
        altitude <- map["altitude"]
        attributes <- map["attributes"]
        course <- map["course"]
        deviceId <- map["deviceId"]
        deviceTime <- map["deviceTime"]
        fixTime <- map["fixTime"]
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
//        network <- map["network"]
        outdated <- map["outdated"]
        protocl <- map["protocol"]
        serverTime <- map["serverTime"]
        speed <- map["speed"]
        type <- map["type"]
        valid <- map["valid"]
        
    }
}

class PositionMapperAttribute : Codable, Mappable {
    //fuel field add.
    
    var batteryLevel : Int?
    var distance : Float?
    var motion : Bool?
    var totalDistance : Double?
    var ignition : Bool?
    var door: Bool?
    var fuel: Double?
    var steps: Int?
    var battery: Double?
    var extBatt: Double?
    var charge: Bool?
    var power: Double?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        batteryLevel <- map["batteryLevel"]
        distance <- map["distance"]
        motion <- map["motion"]
        totalDistance <- map["totalDistance"]
        ignition <- map["ignition"]
        door <- map["door"]
        fuel  <- map["fuel"]
        steps  <- map["steps"]
        battery  <- map["battery"]
        power  <- map["power"]
        charge  <- map["charge"]
        extBatt  <- map["extBatt"]
        
    }
    
    enum CodingKeys: String, CodingKey {
        case batteryLevel = "batteryLevel"
        case distance = "distance"
        case motion = "motion"
        case totalDistance = "totalDistance"
        case ignition = "ignition"
        case door = "door"
        case fuel = "fuel"
        case steps = "steps"
        case battery = "battery"
        case power = "power"
        case extBatt = "extBatt"
        case charge = "charge"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        batteryLevel = try values.decodeIfPresent(Int.self, forKey: .batteryLevel)
        distance = try values.decodeIfPresent(Float.self, forKey: .distance)
        motion = try values.decodeIfPresent(Bool.self, forKey: .motion)
        totalDistance = try values.decodeIfPresent(Double.self, forKey: .totalDistance)
        ignition = try values.decodeIfPresent(Bool.self, forKey: .ignition)
        door = try values.decodeIfPresent(Bool.self, forKey: .door)
        fuel = try values.decodeIfPresent(Double.self, forKey: .fuel)
        steps = try values.decodeIfPresent(Int.self, forKey: .steps)
        battery = try values.decodeIfPresent(Double.self, forKey: .battery)
        power = try values.decodeIfPresent(Double.self, forKey: .power)
        charge = try values.decodeIfPresent(Bool.self, forKey: .charge)
        extBatt = try values.decodeIfPresent(Double.self, forKey: .extBatt)
    }

}

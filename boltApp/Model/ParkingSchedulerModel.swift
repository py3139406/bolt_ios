//
//  ParkingSchedulerModel.swift
//  Bolt
//
//  Created by Vishesh on 4/9/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class ParkingSchedulerData : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var status : Bool?
    var data : [DataClass]?
    var message : String?
    var total : Int?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        status <- map["success"]
        data <- map["data"]
        message <- map["message"]
        total <- map["total"]
        
    }
}

class DataClass : Mappable , Codable {
    
    var device_id : Int?
    var id : Int?
    var parking_mode:Bool?
    var parking_schedule:Bool?
    var parking_schedule_days : [String]?
    var parking_schedule_end_utc : String?
    var parking_schedule_start_utc : String?
    
    required init?(map: Map) {    }

    func mapping(map: Map) {
        device_id <- map["device_id"]
        id <- map["id"]
        parking_mode <- map["parking_mode"]
        parking_schedule <- map["parking_schedule"]
        parking_schedule_days <- map["parking_schedule_days"]
        parking_schedule_start_utc <- map["parking_schedule_start_utc"]
        parking_schedule_end_utc <- map["parking_schedule_end_utc"]
    }
}


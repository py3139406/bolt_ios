//
//  ParkingSchedulerModel.swift
//  findMe
//
//  Created by Roadcast on 30/09/21.
//  Copyright © 2021 Roadcast Tech Solutions. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class ParkingSchedulerModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var success : Bool?
    var data : [ParkingSchedulerModelData]?
    var total : Int64?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        success <- map["success"]
        data <- map["data"]
        total <- map["total"]
        
    }
}

class ParkingSchedulerModelData : Mappable , Codable {
    
    var created_on:String?
    var updated_on:String?
    var device_id : Int64?
    var id : Int64?
    var user_id : Int64?
    var parking_mode:Bool?
    var parking_schedule:Bool?
    var parking_schedule_days : [String]?
    var parking_schedule_end_utc : String?
    var parking_schedule_start_utc : String?

    
    required init?(map: Map) {    }

    func mapping(map: Map) {
        created_on <- map["created_on"]
        updated_on <- map["updated_on"]
        device_id <- map["device_id"]
        id <- map["id"]
        user_id <- map["user_id"]
        parking_mode <- map["parking_mode"]
        parking_schedule <- map["parking_schedule"]
        parking_schedule_days <- map["parking_schedule_days"]
        parking_schedule_start_utc <- map["parking_schedule_start_utc"]
        parking_schedule_end_utc <- map["parking_schedule_end_utc"]
    }
    
    
}



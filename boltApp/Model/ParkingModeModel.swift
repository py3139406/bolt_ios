//
//  ParkingModeModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class ParkingModeModel : Codable, Mappable{
    
    var data : Bool?
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

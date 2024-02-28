//
//  DriverInfoResponseModel.swift
//  Bolt
//
//  Created by Vishal Jain on 18/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class DriverInfoResponseModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var device_id : String = ""
    var mobile : String = ""
    var name : String = ""
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        device_id <- map["device_id"]
        mobile <- map["mobile"]
        name <- map["name"]
        
    }
}

//
//  CallTokenResponseModel.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class CallTokenResponseModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var app_id : String = ""
    var token : String = ""
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        app_id <- map["app_id"]
        token <- map["token"]
    }
}

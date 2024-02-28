//
//  UserConfigResponseModel.swift
//  Bolt
//
//  Created by Vishal Jain on 30/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class UserConfigResponseModel : Mappable,Codable {
    
    required init(from decoder: Decoder) { }
    
    var success : Bool?
    var data : [UserConfigResponseModelData]?
    var total : Int64?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        success <- map["success"]
        data <- map["data"]
        total <- map["total"]
        
    }
}


class UserConfigResponseModelData : Mappable,Codable {
    
    var alarm_settings : UserConfigAlarmSettingResponse?
    var calls_count : Int64?
    var id : Int64?
    var fcm_sender_id : String?
    var marker_cluster : Int?
    var marker_label : Int?
    var marker_animate : Int?
    var third_party_value : String?
    var user_id : Int?
    var user_profile_pic : String?
    var user_type : String?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        alarm_settings <- map["alarm_settings"]
        calls_count <- map["calls_count"]
        id <- map["id"]
        fcm_sender_id <- map["fcm_sender_id"]
        marker_cluster <- map["marker_cluster"]
        marker_label <- map["marker_label"]
        marker_animate <- map["marker_animate"]
        third_party_value <- map["third_party_value"]
        user_id <- map["user_id"]
        user_profile_pic <- map["user_profile_pic"]
        user_type <- map["user_type"]
        
    }
}


class UserConfigAlarmSettingResponse : Mappable,Codable {
    
    var alarm : String?
    var name : String?
    var type : String?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        alarm <- map["alarm"]
        name <- map["name"]
        type <- map["type"]
        
    }
}


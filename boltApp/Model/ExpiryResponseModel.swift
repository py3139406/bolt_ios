//
//  ExpiryResponseModel.swift
//  Bolt
//
//  Created by Shanky on 17/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class ExpiryResponseModel : Codable, Mappable {
    
    var data : [ExpiryDataResponseModel]?
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

class ExpiryDataResponseModel: Codable, Mappable {
    var userid : String?
    var deviceid : String?
    var id : String?
    var name : String?
    var uniqueid : String?
    var subscriptionExpiryDate : String?
    var protcol : String?
    
    required init?(map: Map){}
    init() {
        
    }
    func mapping(map: Map)
    {
        userid <- map["userid"]
        deviceid <- map["deviceid"]
        id <- map["id"]
        name <- map["name"]
        uniqueid <- map["uniqueid"]
        subscriptionExpiryDate <- map["subscription_expiry_date"]
        protcol <- map["protocol"]
        
    }
}

//
//  PaymentRatesModel.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper


class PaymentRatesModel : Codable, Mappable {
    
    var data : [PaymentRatesModelData]?
    var message : String?
    var status : String?

    required init?(map: Map){}

    func mapping(map: Map){
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

class PaymentRatesModelData : Codable, Mappable {
    
    var id : Int?
    var type : String?
    var rate : Double?
    var tax : Double?
    var razorpaySecretkey : String?
    var razorpayApikey : String?
    var validityYears : Int?
 
    required init?(map: Map){}

    
    func mapping(map: Map){
      
        id <- map["id"]
        type <- map["type"]
        rate <- map["rate"]
        tax <- map["tax"]
        validityYears <- map["validity_years"]
        razorpaySecretkey <- map["razorpay_secret_key"]
        razorpayApikey <- map["razorpay_api_key"]
    }
}

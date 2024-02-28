//
//  RazorPayOrderIDModel.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class RazorPayOrderIDModel : Codable, Mappable {
    
    var data : RazorPayOrderIDModelData?
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

class RazorPayOrderIDModelData : Codable, Mappable {
    
    var paymentOrderId : Int?
    var razorpayOrder : String?
    
  
    required init?(map: Map){}
 
    
    func mapping(map: Map)
    {
        paymentOrderId <- map["payment_orders_id"]
        razorpayOrder <- map["razor_pay_order"]
        
    }
    

    
}

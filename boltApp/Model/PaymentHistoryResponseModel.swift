//
//  PaymentHistoryResponseModel.swift
//  Bolt
//
//  Created by vishal jain on 25/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class PaymentHistoryResponseModel : Codable, Mappable {
    
    //    required init(from decoder: Decoder) {
    //
    //    }
    var data : [PaymentHistoryResponseModelData]?
    var success : Bool?
    var total : Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["data"]
        success <- map["success"]
        total <- map["total"]
    }
}

class PaymentHistoryResponseModelData : Codable, Mappable{
    
    var amount: Double?
    var app_name : String?
    var companyID : Int?//
    var createdOn : String? //
    var credited : Bool?
    var deviceIDS : String?//
    var email : String? //
    var id : Int?
    var ipAddress : String?//
    var mobile : String?
    var name : String?
    var notes : String?
    var razorpayOrderID : String?
    var razorpayPaymentID : String?
    var razorpaySignature : String?
    var status : String?
    var type : String?
    var updatedOn :  String?
    var userID : Int?
    var uuid : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        
        amount <- map["amount"]
        app_name <- map["app_name"]
        companyID <- map["company_id"]
        createdOn <- map["created_on"]
        credited <- map["credited"]
        deviceIDS <- map["device_ids"]
        email <- map["email"]
        id <- map["id"]
        ipAddress <- map["ip_address"]
        mobile <- map["mobile"]
        name <- map["name"]
        notes <- map["notes"]
        razorpayOrderID <- map["razorpay_order_id"]
        razorpayPaymentID <- map["razorpay_payment_id"]
        razorpaySignature <- map["razorpay_signature"]
        status <- map["status"]
        type <- map["type"]
        updatedOn <- map["updated_on"]
        userID <- map["user_id"]
        uuid <- map["uuid"]
    }
    
}

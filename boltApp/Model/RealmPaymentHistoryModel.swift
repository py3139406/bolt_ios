//
//  RealmPaymentHistoryModel.swift
//  Bolt
//
//  Created by Saanica Gupta on 02/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import Realm
import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm


class RealmPaymentHistoryModel : Object, Mappable {
  
  //var data : [FuelModelApiData]?
  var data = List<RealmPaymentHistoryModelData>()
  @objc dynamic  var message : String?
  @objc dynamic var status : String?
  
  
  required convenience init?(map: Map){
       self.init()
   }
  
  func mapping(map: Map)
  {
    data <- (map["data"],ListTransform<RealmPaymentHistoryModelData>())
    message <- map["message"]
    status <- map["status"]
    
  }
  
  override static func primaryKey() -> String? {
         return "message"
     }
}

class RealmPaymentHistoryModelData : Object, Mappable {
  
  @objc dynamic var id : String?
  @objc dynamic var user_id : String?
  @objc dynamic var insert_date : String?
  @objc dynamic var razorpay_order_id : String?
  @objc dynamic var razorpay_payment_id : String?
  @objc dynamic var razorpay_signature : String?
  @objc dynamic var status : String?
  @objc dynamic var type : String?
  @objc dynamic var device_id : String?
  @objc dynamic var amount : String?

  required convenience init?(map: Map){
       self.init()
   }
  
  func mapping(map: Map) {
    
    id <- map["id"]
    user_id <- map["user_id"]
    insert_date <- map["insert_date"]
    razorpay_order_id <- map["razorpay_order_id"]
    razorpay_payment_id <- map["razorpay_payment_id"]
    razorpay_signature <- map["razorpay_signature"]
    status <- map["status"]
    type <- map["type"]
    device_id <- map["device_id"]
    amount <- map["amount"]
  }
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
}

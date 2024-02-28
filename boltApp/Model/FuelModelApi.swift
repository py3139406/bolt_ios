//
//  FuelModelApi.swift
//  Bolt
//
//  Created by Saanica Gupta on 28/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//


import Realm
import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm


class FuelModelApi : Object, Mappable {
  
  //var data : [FuelModelApiData]?
  var data = List<FuelModelApiData>()
  @objc dynamic  var message : String?
  @objc dynamic var status : String?
  
  
  required convenience init?(map: Map){
       self.init()
   }
  
  func mapping(map: Map)
  {
    data <- (map["data"],ListTransform<FuelModelApiData>())
    message <- map["message"]
    status <- map["status"]
    
  }
  
  override static func primaryKey() -> String? {
         return "message"
     }
}

class FuelModelApiData : Object, Mappable {
  
  @objc dynamic var id : String?
  @objc dynamic var userId : String?
  @objc dynamic var device_id : String?
  @objc dynamic var timestamp : String?
  @objc dynamic var total_distance : String?
  @objc dynamic var mileage : String?
  @objc dynamic var fuel_filled : String = "0.0"
  @objc dynamic var price_per_litre : String?
  @objc dynamic var fuel_type : String?
  @objc dynamic var payment_type : String?
  @objc dynamic var update_time: String?
  @objc dynamic var amount: String?
  @objc dynamic var image_name: String?
  
  
  required convenience init?(map: Map){
       self.init()
   }
  
  func mapping(map: Map) {
    
    id <- map["id"]
    userId <- map["user_id"]
    device_id <- map["device_id"]
    timestamp <- map["timestamp"]
    total_distance <- map["total_distance"]
    mileage <- map["mileage"]
    fuel_filled <- map["fuel_filled"]
    price_per_litre <- map["price_per_litre"]
    fuel_type <- map["fuel_type"]
    payment_type <- map["payment_type"]
    image_name <- map["image_name"]
    update_time <- map["update_time"]
    amount <- map["amount"]
    
  }
  
  override static func primaryKey() -> String? {
          return "id"
      }
  
}

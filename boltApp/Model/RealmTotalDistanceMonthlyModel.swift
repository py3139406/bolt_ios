//
//  RealmTotalDistanceMonthlyModel.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import Realm
import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm


class RealmTotalDistanceMonthlyModel : Object, Mappable {
  
  //var data : [FuelModelApiData]?
  var data = List<RealmTotalDistanceMonthlyModelData>()
  @objc dynamic  var message : String?
  @objc dynamic var status : String?
  
  
  required convenience init?(map: Map){
       self.init()
   }
  
  func mapping(map: Map)
  {
    data <- (map["data"],ListTransform<RealmTotalDistanceMonthlyModelData>())
    message <- map["message"]
    status <- map["status"]
    
  }
  
  override static func primaryKey() -> String? {
         return "message"
     }
}

class RealmTotalDistanceMonthlyModelData : Object, Mappable {
  
  @objc dynamic var distance : String = "0.0"
  @objc dynamic var device_id : String?
  @objc dynamic var start_time : String?
  @objc dynamic var device_name : String?
  @objc dynamic var TotalDistance : String = "0.0"

  required convenience init?(map: Map){
       self.init()
   }
  
  func mapping(map: Map) {
    
    distance <- map["distance"]
    device_id <- map["device_id"]
    start_time <- map["start_time"]
    device_name <- map["device_name"]
    
  }
  
  
}

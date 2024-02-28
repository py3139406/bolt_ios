//
//  CallCountModel.swift
//  Bolt
//
//  Created by Saanica Gupta on 02/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper


class CallCountModel : Codable, Mappable{
    
    var data : CallCountModelData?
    var message : Bool?
    var status : String?
    
    
    required init?(map: Map){}
 
    
    func mapping(map: Map)
    {
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
    
    
}

class CallCountModelData : Codable, Mappable{
    
  var calls_count : String?
  var third_party_value: String?
  var isload_unload_visible:String?
  
    required init?(map: Map){}
    
    
    func mapping(map: Map){
      
      calls_count <- map["calls_count"]
      third_party_value <- map["third_party_value"]
      isload_unload_visible <- map["isload_unload_visible"]

        
    }
}

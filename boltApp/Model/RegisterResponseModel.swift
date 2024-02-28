//
//  RegisterResponseModel.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class RegisterResponseModel : Codable ,Mappable{
    
    var data : RegisterResponseModelData?
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

class RegisterResponseModelData : Codable, Mappable{
    
    var error : String?
    
    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        error <- map["error"]
        
    }
    
}
    


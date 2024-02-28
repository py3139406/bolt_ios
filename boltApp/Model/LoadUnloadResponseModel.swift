//
//  LoadUnloadResponseModel.swift
//  Bolt
//
//  Created by Shanky on 17/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class LoadUnloadResponseModel : Codable ,Mappable{
    
    var data : LoadUnloadResponseModelData?
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

class LoadUnloadResponseModelData : Codable, Mappable{
    
    var insertId : String?
    var loadingType : String?
    var uniqueId : String?
    
    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        insertId <- map["insertId"]
        loadingType <- map["loading_type"]
        uniqueId <- map["unique_id"]
    }
    
}

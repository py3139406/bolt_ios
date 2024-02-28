//
//  SyncVehicleModesModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper

class SyncVehicleModesModel : Codable, Mappable {
    
    var data : SyncVehicleModesModelData?
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
class SyncVehicleModesModelData : Codable, Mappable {
    
    var owlMode : [String]?
    var parkingMode : [String]?
    
    required init?(map: Map){}
  
    
    func mapping(map: Map)
    {
        owlMode <- map["owlMode"]
        parkingMode <- map["parkingMode"]
        
    }
    
}

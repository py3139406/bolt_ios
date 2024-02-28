//
//    SendCommandModel.swift
//
//    Create by Anshul Jain on 18/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited

import Foundation
import ObjectMapper

class SendCommandModel : Codable, Mappable{
    
    var attributes : SendCommandModelAttribute?
    var descriptionField : String?
    var deviceId : Int?
    var id : Int?
    var textChannel : Bool?
    var type : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        attributes <- map["attributes"]
        descriptionField <- map["description"]
        deviceId <- map["deviceId"]
        id <- map["id"]
        textChannel <- map["textChannel"]
        type <- map["type"]
        
    }
    
}

class SendCommandModelAttribute : Codable, Mappable{
    
    var data : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        data <- map["data"]
        
    }
    
}

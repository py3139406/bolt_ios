//
//  TemplateDevicesModel.swift
//  Bolt
//
//  Created by Roadcast on 26/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//


import Foundation
import ObjectMapper

class TemplateDevicesModel: Codable,Mappable {
    var data : [TemplateDevicesDataModel]?
    var message : String?
    var status : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

class TemplateDevicesDataModel : Codable, Mappable {
    
    var id: String = ""
    var  deviceid:String  = ""
    var  template_id:String  = ""
    required init?(map: Map){}
    
    
    func mapping(map: Map){
        id <- map["id"]
        deviceid <- map["deviceid"]
        template_id <- map["template_id"]
    }
}


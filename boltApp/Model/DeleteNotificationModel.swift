//
//  DeleteNotificationModel.swift
//  Bolt
//
//  Created by Vivek Kumar on 20/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class DeleteNotificationModel : Codable, Mappable{
    
    var data : String?
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

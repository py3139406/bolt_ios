//
//  POIInfoModel.swift
//  Bolt
//
//  Created by Shanky on 02/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class POIInfoModel : Codable,Mappable {
    var data : [POIInfoDataModel]?
    var message : String?
    var status : String?

    required init?(map: Map){}

    func mapping(map: Map){
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

class POIInfoDataModel : Codable, Mappable {
    
    var id : String?
    var userid : String?
    var lat : String?
    var lng : String?
    var type : String?
    var title : String?
    var description : String?
    var address : String?
    var image : String?
 
    required init?(map: Map){}

    
    func mapping(map: Map){
      
        id <- map["id"]
        userid <- map["userid"]
        lat <- map["lat"]
        lng <- map["lng"]
        type <- map["type"]
        title <- map["title"]
        description <- map["description"]
        address <- map["address"]
        image <- map["image"]
        
    }
}

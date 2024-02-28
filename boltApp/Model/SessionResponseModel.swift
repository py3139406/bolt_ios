//
//  SessionResponseModel.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper



class SessionResponseModel : Codable, Mappable{
    
    var admin : Bool?
    var attributes : Attribute?
    var coordinateFormat : String?
    var deviceLimit : Int?
    var deviceReadonly : Bool?
    var disabled : Bool?
    var distanceUnit : String?
    var email : String?
    var expirationTime : String?
    var id : Int?
    var latitude : Int?
    var longitude : Int?
    var map2 : String?
    var name : String?
    var password : String?
    var phone : String?
    var readonly : Bool?
    var speedUnit : String?
    var timezone : String?
    var token : String?
    var twelveHourFormat : Bool?
    var userLimit : Int?
    var zoom : Int?
    
    
  
    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        admin <- map["admin"]
        attributes <- map["attributes"]
        coordinateFormat <- map["coordinateFormat"]
        deviceLimit <- map["deviceLimit"]
        deviceReadonly <- map["deviceReadonly"]
        disabled <- map["disabled"]
        distanceUnit <- map["distanceUnit"]
        email <- map["email"]
        expirationTime <- map["expirationTime"]
        id <- map["id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        map2 <- map["map"]
        name <- map["name"]
        password <- map["password"]
        phone <- map["phone"]
        readonly <- map["readonly"]
        speedUnit <- map["speedUnit"]
        timezone <- map["timezone"]
        token <- map["token"]
        twelveHourFormat <- map["twelveHourFormat"]
        userLimit <- map["userLimit"]
        zoom <- map["zoom"]
        
    }
   
}


class Attributes : Codable, Mappable{
    
    var activationTime : Int?
    var active : String?
    var blocked : String?
    var code : String?
    var companyname : String?
    var countryCode : String?
    var email : String?
    var password : String?
    
    
   
    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        activationTime <- map["activation_time"]
        active <- map["active"]
        blocked <- map["blocked"]
        code <- map["code"]
        companyname <- map["companyname"]
        countryCode <- map["country_code"]
        email <- map["email"]
        password <- map["password"]
        
    }

    
}

//
//  UpdateUseDetails.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class UpdateUseDetails : Codable, Mappable{
    
    var data : UpdateUseDetailsData?
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

class UpdateUseDetailsData : Codable, Mappable{
    
    var admin : Bool?
    var attributes : UpdateUseDetailsAttribute?
    var coordinateFormat : String?
    var deviceLimit : Int?
    var deviceReadonly : Bool?
    var disabled : Bool?
    var email : String?
    var expirationTime : String?
    var id : Int?
    var latitude : Int?
    var limitCommands : Bool?
    var login : String?
    var longitude : Int?
    var usermap : String?
    var name : String?
    var password : String?
    var phone : String?
    var poiLayer : String?
    var readonly : Bool?
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
        email <- map["email"]
        expirationTime <- map["expirationTime"]
        id <- map["id"]
        latitude <- map["latitude"]
        limitCommands <- map["limitCommands"]
        login <- map["login"]
        longitude <- map["longitude"]
        usermap <- map["usermap"]
        name <- map["name"]
        password <- map["password"]
        phone <- map["phone"]
        poiLayer <- map["poiLayer"]
        readonly <- map["readonly"]
        token <- map["token"]
        twelveHourFormat <- map["twelveHourFormat"]
        userLimit <- map["userLimit"]
        zoom <- map["zoom"]
        
    }
  
    
}


class UpdateUseDetailsAttribute : Codable, Mappable{
    
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

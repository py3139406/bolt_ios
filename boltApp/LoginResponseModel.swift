//
//    LoginResponseModel.swift
//
//    Create by Anshul Jain on 30/11/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class LoginResponseModel : Codable, Mappable{
    
    var data : LoginResponseModelData?
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

class LoginResponseModelData : Codable, Mappable{
    
    var admin : Bool?
    var attributes : Attribute?
    var coordinateFormat : String?
    var deviceLimit : Int?
    var deviceReadonly : Bool?
    var disabled : Bool?
    var distanceUnit : String?
    var email : String?
    var expirationTime : String?
    var id : String?
    var latitude : Int?
    var longitude : Int?
    var map1 : String?
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
        map1 <- map["map"]
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

class Attribute : Codable, Mappable{
    
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

class AuthTokenModel : Codable, Mappable{
    
    var token : String = ""
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        token <- map["token"]
        
    }
}

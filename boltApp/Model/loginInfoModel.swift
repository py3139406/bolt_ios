//
//  loginInfoModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class loginInfoModel : Codable, Mappable{
    
    var data : loginInfoModelData?
    var message : Bool?
    var status : String?
    
    
  
    required init?(map: Map){}
 
    
    func mapping(map: Map)
    {
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
    
 

    
}

class loginInfoModelData : Codable, Mappable{
    
    var icons : String?
    var user : loginInfoModelDataUser?
    
    
  
    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        icons <- map["icons"]
        user <- map["user"]
        
    }

    
}

class loginInfoModelDataUser : Codable, Mappable{
    
    var admin : String?
    var alarmSettings : String?
    var attributes : String?
    var coordinateformat : String?
    var devicelimit : String?
    var devicereadonly : String?
    var disabled : String?
    var email : String?
    var expirationtime : String?
    var hashedpassword : String?
    var id : String?
    var latitude : String?
    var limitcommands : String?
    var login : String?
    var longitude : String?
    var rmap : String?
    var name : String?
    var phone : String?
    var poilayer : String?
    var readonly : String?
    var salt : String?
    var token : String?
    var twelvehourformat : String?
    var userlimit : String?
    var zoom : String?
    var google_assistant_email:String?
    var default_device_id:String?
  
    required init?(map: Map){}
    
    
    func mapping(map: Map)
    {
        admin <- map["admin"]
        alarmSettings <-  map["alarm_settings"]
        attributes <- map["attributes"]
        coordinateformat <- map["coordinateformat"]
        devicelimit <- map["devicelimit"]
        devicereadonly <- map["devicereadonly"]
        disabled <- map["disabled"]
        email <- map["email"]
        expirationtime <- map["expirationtime"]
        hashedpassword <- map["hashedpassword"]
        id <- map["id"]
        latitude <- map["latitude"]
        limitcommands <- map["limitcommands"]
        login <- map["login"]
        longitude <- map["longitude"]
        rmap <- map["map"]
        name <- map["name"]
        phone <- map["phone"]
        poilayer <- map["poilayer"]
        readonly <- map["readonly"]
        salt <- map["salt"]
        token <- map["token"]
        twelvehourformat <- map["twelvehourformat"]
        userlimit <- map["userlimit"]
        zoom <- map["zoom"]
        google_assistant_email <- map["google_assistant_email"]
        default_device_id <- map["default_device_id"]
    }
    
   
    
}

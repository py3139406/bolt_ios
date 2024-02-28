//
//  ForgetPasswordResponse.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation

import ObjectMapper


class ForgetPasswordResponse : Codable, Mappable{
    
    var data : ForgetPasswordResponseData?
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

class ForgetPasswordResponseData : Codable, Mappable{
    
    var oTP : String?
    var countryCode : String?
    var userId : String?
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        oTP <- map["OTP"]
        countryCode <- map["countryCode"]
        userId <- map["userId"]
        
    }
}

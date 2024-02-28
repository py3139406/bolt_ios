//
//    ForgotPasswordModel.swift
//
//    Create by Anshul Jain on 6/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class ForgotPasswordModel : Codable, Mappable{
    
    var data : ForgotPasswordModelData?
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


class ForgotPasswordModelData : Codable, Mappable{
    
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

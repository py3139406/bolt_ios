//
//    FirebaseUserModel.swift
//
//    Create by Anshul Jain on 18/12/2017
//    Copyright © Roadcast Tech Solutions Private Limited
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class FirebaseUserModel : Codable, Mappable{
    
    var deviceId : Int?
    var fixTime : String?
    var isTyping : Bool?
    var mobileNumber : Int?
    var name : String?
    var positionId : Int64?
    var userId : Int?
    var userType : String?
    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        deviceId <- map["deviceId"]
        fixTime <- map["fixTime"]
        isTyping <- map["isTyping"]
        mobileNumber <- map["mobileNumber"]
        name <- map["name"]
        positionId <- map["positionId"]
        userId <- map["userId"]
        userType <- map["userType"]
        
    }
}

//
//  EditDevicesInfosModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import ObjectMapper


class EditDevicesInfosModel : Codable, Mappable{
    
    var data : [EditDevicesInfosModelData]?
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

class EditDevicesInfosModelData : Codable, Mappable {
    
    var carRcCopy : String?
    var cngCertificateUpload : String?
    var cngFittedBy : String?
    var cngLeakExpiry : String?
    var dateAdded : String?
    var hbtTestDate : String?
    var id : String?
    var insuranceExpiryDate : String?
    var insuranceUpload : String?
    var lastServiceDate : String?
    var name : String?
    var nextServiceDate : String?
    var phone : String?
    var pollutionCertificateUpload : String?
    var pollutionExpiryDate : String?
    var registrationCertificateUrl : String?
    var subscriptionExpiryDate : String?
    var uniqueId : String?
    var vehicleBrand : String?
    var vehicleModel : String?
    var vehicleRegistrationNumber : String?
    var vehicleType : String?
    var fitnessUploadUrl: String?
    var fitnessExpiryDate: String?
    var nationalPermitUpload: String?
    var nationalPermitExpiry: String?
    var fiveYearPermitUpload: String?
    var fiveYearPermitExpiry : String?
    var taxUpload: String?
    var taxExpiry: String?
    
    init() {
        
    }
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        carRcCopy <- map["car_rc_copy"]
        cngCertificateUpload <- map["cng_certificate_upload"]
        cngFittedBy <- map["cng_fitted_by"]
        cngLeakExpiry <- map["cng_leak_expiry"]
        dateAdded <- map["date_added"]
        hbtTestDate <- map["hbt_test_date"]
        id <- map["id"]
        insuranceExpiryDate <- map["insurance_expiry_date"]
        insuranceUpload <- map["insurance_upload"]
        lastServiceDate <- map["last_service_date"]
        name <- map["name"]
        nextServiceDate <- map["next_service_date"]
        phone <- map["phone"]
        pollutionCertificateUpload <- map["pollution_certificate_upload"]
        pollutionExpiryDate <- map["pollution_expiry_date"]
        registrationCertificateUrl <- map["registration_certificate_url"]
        subscriptionExpiryDate <- map["subscription_expiry_date"]
        uniqueId <- map["uniqueId"]
        vehicleBrand <- map["vehicle_brand"]
        vehicleModel <- map["vehicle_model"]
        vehicleRegistrationNumber <- map["vehicle_registration_number"]
        vehicleType <- map["vehicle_type"]
        fitnessUploadUrl <- map["fitness_upload_url"]
        fitnessExpiryDate <- map["fitness_expiry_date"]
        nationalPermitUpload <- map["national_permit_upload"]
        nationalPermitExpiry <- map["national_permit_expiry"]
        fiveYearPermitUpload <- map["five_year_permit_upload"]
        fiveYearPermitExpiry <- map["five_year_permit_expiry"]
        taxUpload <- map["token_tax_upload"]
        taxExpiry <- map["token_tax_expiry"]
    }
    
    
}

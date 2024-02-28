//
//  CompanyConfigModel.swift
//  Bolt
//
//  Created by Vishal Jain on 18/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class CompanyConfigModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var about_link : String = ""
    var faq_link : String = ""
    var google_key : String = ""
    var privacy_policy : String = ""
    var terms_and_conditions : String = ""
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        about_link <- map["about_link"]
        faq_link <- map["faq_link"]
        google_key <- map["google_key"]
        privacy_policy <- map["privacy_policy"]
        terms_and_conditions <- map["terms_and_conditions"]
        
    }
}

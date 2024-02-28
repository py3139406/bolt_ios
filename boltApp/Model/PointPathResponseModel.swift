//
//  PointPathResponseModel.swift
//  Bolt
//
//  Created by Vishal Jain on 18/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import AlamofireObjectMapper
import ObjectMapper

class PointPathResponseModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var features : [FeatureResponseModel] = []
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        features <- map["features"]
        
    }
}

class FeatureResponseModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var geometry : GeometryResponseModel?
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        geometry <- map["geometry"]
        
    }
}

class GeometryResponseModel : Mappable,Codable {
    
    required init(from decoder: Decoder) {

    }
    var coordinates : [[Double]] = []
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        
        coordinates <- map["coordinates"]
        
    }
}

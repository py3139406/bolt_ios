//
//  MarkerFirebaseModel.swift
//  Bolt
//
//  Created by Shanky on 22/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class MarkerFirebaseModel: Codable {
    
    var imagePathList : [String]?
    var title : String?
    var description : String?
    var timestamp : String?
    var userLat : Double?
    var userLng : Double?
    var deviceLat : Double?
    var deviceLng : Double?
    var deviceId : String?
}


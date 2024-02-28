//
//  RealmSevenDayDistanceModel.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSevenDayDistanceModel: Object {
    
    @objc dynamic var device_id: String?
    @objc dynamic var totalSevenDayDistance: String?
    @objc dynamic var y1: String = "0.0"
    @objc dynamic var y2: String = "0.0"
    @objc dynamic var y3: String = "0.0"
    @objc dynamic var y4: String = "0.0"
    @objc dynamic var y5: String = "0.0"
    @objc dynamic var y6: String = "0.0"
    @objc dynamic var y7: String = "0.0"
    @objc dynamic var y8: String = "0.0"
    @objc dynamic var deviceName: String?

    
    override static func primaryKey() -> String? {
        return "device_id"
    }

}



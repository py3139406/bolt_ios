//
//  LoadUnloadPojo.swift
//  Bolt
//
//  Created by Shanky on 16/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation

class LoadUnloadPojo: NSObject, Codable {
    var uniqueId:String = ""
    var deviceId:String = "0"
    var startTimestamp:String?
    var startLat:String?
    var startLng:String?
    var startImg:String?
    var startImgData:Data?
    var endTimestamp:String?
    var endLat:String?
    var endLng:String?
    var endImg:String?
    var endImgData:Data?
    var timeTaken:String?
    var notes:String?
    var loadingType:String?
    var insertRowId:String?
    
}

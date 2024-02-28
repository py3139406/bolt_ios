//
//  FilterResponseModel.swift
//  Bolt
//
//  Created by Vivek Kumar on 20/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import Foundation
import Foundation
import ObjectMapper


class FilterResponseModel : Codable, Mappable {
    
    var data : FilterResponseModelData?
    var message : String?
    var status : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

class FilterResponseModelData : Codable, Mappable {
    
    var alarm_accident:String?
    var alarm_hardAcceleration:String?
    var alarm_lowBattery:String?
    var alarm_powerCut:String?
    var alarm_powerOff:String?
    var alarm_powerOn:String?
    var alarm_powerRestored:String?
    var alarm_shock:String?
    var alarm_sos:String?
    var alarm_tampering:String?
    var alarm_tow:String?
    var alarm_vibration:String?
    var deviceOverspeed:String?
    var geofenceEnter:String?
    var geofenceExit:String?
    var group_id:Double?
    var ignitionOff:String?
    var ignitionOn:String?
    
    var notify_accident:Bool?
    var notify_geofenceEnter:Bool?
    var notify_geofenceExit:Bool?
    var notify_hardAcceleration:Bool?
    var notify_hardBraking:Bool?
    var notify_hardCornering:Bool?
    var notify_ignitionOff:Bool?
    var notify_ignitionOn:Bool?
    var notify_lowBattery:Bool?
    var notify_overspeed:Bool?
    var notify_powerCut:Bool?
    var notify_powerOff:Bool?
    var notify_powerOn:Bool?
    var notify_powerRestored:Bool?
    var notify_shock:Bool?
    var notify_sos:Bool?
    var notify_tampering:Bool?
    var notify_tow:Bool?
    var notify_vibration:Bool?
    
    required init?(map: Map){}
    
    
    func mapping(map: Map){
        alarm_accident <- map["alarm_accident"]
        alarm_hardAcceleration <- map["alarm_hardAcceleration"]
        alarm_lowBattery <- map["alarm_lowBattery"]
        alarm_powerCut <- map["alarm_powerCut"]
        alarm_powerOff <- map["alarm_powerOff"]
        alarm_powerOn <- map["alarm_powerOn"]
        alarm_powerRestored <- map["alarm_powerRestored"]
        alarm_shock <- map["alarm_shock"]
        alarm_sos <- map["alarm_sos"]
        alarm_tampering <- map["alarm_tampering"]
        alarm_tow <- map["alarm_tow"]
        alarm_vibration <- map["alarm_vibration"]
        deviceOverspeed <- map["deviceOverspeed"]
        geofenceEnter <- map["geofenceEnter"]
        geofenceExit <- map["geofenceExit"]
        group_id <- map["group_id"]
        ignitionOff <- map["ignitionOff"]
        ignitionOn <- map["ignitionOn"]
        notify_accident <- map["notify_accident"]
        notify_geofenceEnter <- map["notify_geofenceEnter"]
        notify_geofenceExit <- map["notify_geofenceExit"]
        notify_hardAcceleration <- map["notify_hardAcceleration"]
        notify_hardBraking <- map["notify_hardBraking"]
        notify_hardCornering <- map["notify_hardCornering"]
        notify_ignitionOff <- map["notify_ignitionOff"]
        notify_ignitionOn <- map["notify_ignitionOn"]
        notify_lowBattery <- map["notify_lowBattery"]
        notify_overspeed <- map["notify_overspeed"]
        notify_powerCut <- map["notify_powerCut"]
        notify_powerOff <- map["notify_powerOff"]
        notify_powerOn <- map["notify_powerOn"]
        notify_powerRestored <- map["notify_powerRestored"]
        notify_shock <- map["notify_shock"]
        notify_sos <- map["notify_sos"]
        notify_tampering <- map["notify_tampering"]
        notify_tow <- map["notify_tow"]
        notify_vibration <- map["notify_vibration"]
        
        
    }
}

//
//  TemplateModel.swift
//  Bolt
//
//  Created by Roadcast on 26/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import ObjectMapper

class TemplateModel: Codable,Mappable {
    var data : [TemplateDataModel]?
    var message : String?
    var status : String?
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        data <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

class TemplateDataModel : Codable, Mappable {
    
    var id: String?
    var  name:String?
    var userid:String?
    var ignition_on: String?
    var ignition_off: String?
    var geofence_enter: String?
    var  geofence_exit: String?
    var overspeed:  String?
    var  sos: String?
    var  power_cut: String?
    var  st_alert_repetition: String?
    var  st_alert_time_difference: String?
    var  st_work_start_time: String?
    var st_work_end_time: String?
    var is_stoppage_alert: String?
    var is_mail: String?
    var  is_sms: String?
    var  mobile: String?
    var  email: String?
    var  max_limit: String?
    var  geo_scheduling: String?
    required init?(map: Map){}
    
    
    func mapping(map: Map){
        
        id <- map["id"]
        userid <- map["userid"]
        name <- map["name"]
        ignition_on <- map["ignition_on"]
        ignition_off <- map["ignition_off"]
        geofence_enter <- map["geofence_enter"]
        geofence_exit <- map["geofence_exit"]
        overspeed <- map["overspeed"]
        sos <- map["sos"]
        power_cut <- map["power_cut"]
        st_alert_repetition <- map["st_alert_repetition"]
        st_alert_time_difference <- map["st_alert_time_difference"]
        st_work_start_time <- map["st_work_start_time"]
        st_work_end_time <- map["st_work_end_time"]
        is_stoppage_alert <- map["is_stoppage_alert"]
        is_mail <- map["is_mail"]
        is_sms <- map["is_sms"]
        mobile <- map["mobile"]
        email <- map["email"]
        max_limit <- map["max_limit"]
        geo_scheduling <- map["geo_scheduling"]
    }
}


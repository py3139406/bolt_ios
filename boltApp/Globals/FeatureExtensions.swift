//
//  FeatureExtensions.swift
//  Bolt
//
//  Created by Shanky on 26/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation

enum NotifTypeKeys:String {
    case notify_accident  = "notify_accident"
    case notify_geofenceEnter  = "notify_geofenceEnter"
    case notify_geofenceExit  = "notify_geofenceExit"
    case notify_ignitionOff  = "notify_ignitionOff"
    case notify_ignitionOn  = "notify_ignitionOn"
    case notify_lowBattery  = "notify_lowBattery"
    case notify_overspeed  = "notify_overspeed"
    case notify_powerCut  = "notify_powerCut"
    case notify_powerOff  = "notify_powerOff"
    case notify_powerOn  = "notify_powerOn"
    case notify_powerRestored  = "notify_powerRestored"
    case notify_shock  = "notify_shock"
    case notify_sos  = "notify_sos"
    case notify_tow  = "notify_tow"
    case notify_vibration  = "notify_vibration"
}

enum TableCellIdentifiers : String {
    case stopReport = "report_stops"
    case tripSummaryReport = "report_trip_summary"
    case kmReport = "report_kms"
    case reachibilityReport = "report_reachability"
    case vehicleListTable = "vehicle_list"
    case multipleShareTableCell = "multipleShareTableCell"
    case vehicleDetailsCell = "vehicleDetailsCell"
}

enum SelectedReportType : String {
    case stops = "STOPS"
    case trips = "TRIPS"
    case summary = "DAILY"
    case kilometer = "DAILY KM"
    case reachability = "REACHABILITY"
}

enum defaultKeyNames : String {
    case allDevices = "allDevices"
    case shouldClearMap = "should_clear_map"
    case deviceSelectedState = "device_selected_state"
    case selectedDeviceList = "selected_device_list"
    case vehicleListSortLabel = "vehicleListSortLabel"
    case multipleSelectionAllowed = "multipleSelectionAllowed"
    case selectedBranch = "selectedBranch"
    case selectedBranchName = "selectedBranchName"
    case branchForReport = "seletedBranchReport"
    case branchNameForReport = "branchNameReport"
    case loadUnloadStartTime = "loadUnloadStartTime"
    case isLoadUnloadTimerRunning = "isLoadUnloadTimerRunning"
    case savedLoadUnloadData = "savedLoadUnloadData"
    case loadUnloadType = "loadUnloadType"
    case currentLoadingId = "currentLoadingId"
    case currentLoadingDeviceId = "currentLoadingDeviceId"
    case currentLoadingDeviceName = "currentLoadingDeviceName"
    case streamingCamera = "streamingCamera"
    case jwt_token = "jwt_token"
    case taskId = "task_id"
    case placesKey = "places_key"
    case callIMEI = "call_imei"
    case callName = "call_name"
    case callAppId = "call_app_id"
    case callAppToken = "call_app_token"
    case ongoingCall = "ongoingCall"
    case acceptScreenShown = "acceptScreenShown"
    case animationDate = "animation_date"
    case animationData = "animation_data"
}

enum vehicleSelectedState : Int {
    case all = 0
    case ignitionOn = 1
    case ignitionOff = 2
    case inactive = 3
    case offline = 4
}

enum notificationFilter : Int {
    case ignitionOn = 1
    case ignitionOff = 2
    case geofenceEnter = 3
    case geofenceExit = 4
    case overspeed = 5
    case powerCut = 6
    case vibration = 7
    case lowBattery = 8
    case others = 9
}

enum ImagePrefix : String {
    case loadStartPrefix = "LOAD_START_"
    case loadStopPrefix = "LOAD_STOP_"
    case unloadStartPrefix = "UNLOAD_START_"
    case unloadStopPrefix = "UNLOAD_STOP_"
}

enum LoadingType : Int {
    case load = 1
    case unload = 2
}

enum streamCamera : String {
    case inside = "2"
    case outside = "1"
}

enum streamStatus : Int {
    case start = 1
    case stop = 2
}

enum jcCommands : String {
    case insideStart = "RTMP,ON,IN"
    case outsideStart = "RTMP,ON,OUT"
    case stop = "RTMP,OFF"
}

enum sheetDataKeys : String {
    case ignitionTimeLabel = "ignition_time_label"
    case ignitionTimeValue = "ignition_time_value"
    case stopCountValue = "stop_count_value"
    case idleTimeValue = "idle_time_value"
    case movingTimeValue = "moving_time_value"
    case maxSpeedValue = "max_speed_value"
    case avgSpeedValue = "avg_speed_value"
    case totalDistValue = "total_dist_value"
    case tripDistLabel = "trip_dist_label"
    case tripDistValue = "trip_dist_value"
    case tripDurLabel = "trip_dur_label"
    case tripDurValue = "trip_dur_value"
}

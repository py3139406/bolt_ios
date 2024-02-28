//
//  MoreInfoVC.swift
//  Bolt
//
//  Created by Vivek Kumar on 12/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import DefaultsKit
import SnapKit
import RealmSwift
import KeychainAccess
import SwiftSoup
import Alamofire
import CoreLocation
import Realm
import ObjectMapper_Realm

class MoreInfoVC: UIViewController {
    var moreinfoview: MoreInfoView!
    var alarmSetting: [String: String]?
    var type: String?
    var alarm: String?
    var login_model: loginInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmSettingFunction()
        moreinfoview = MoreInfoView(frame: CGRect.zero)
        moreinfoview.backgroundColor = appDarkTheme
        view.backgroundColor = appDarkTheme
        moreinfoview.layer.cornerRadius = 5
        moreinfoview.layer.masksToBounds = true
        view.addSubview(moreinfoview)
        constraints()
        moreinfoview.crossButton.addTarget(self, action: #selector(dismissBtnAction(_sender:)), for: .touchUpInside)
        let stringWatch = "Device_Watch"
        let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        let keyValue = "Device_" + "\(deviceId)"
        let trackerDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        
        let keyValuePos = "Position_" + "\(deviceId)"
        let trackerPosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
        
        checkForParkingMode(deviceID: deviceId )
        checkForImmobilizedVehicle(deviceId: deviceId )
        
        checkForTemprature(trackerPosition: trackerPosition)
        checkForNetwork(trackerDevice: trackerDevice, isWatch: false)
        ignitionOnOffFunction(trackerDevices: trackerDevice, trackerPosition: trackerPosition)
        vehicleGeofenceFunction(trackerDevice: trackerDevice)
        let batteryLevel:Int = trackerPosition?.attributes?.batteryLevel ?? 0
//        if let batteryLevel = trackerPosition?.attributes?.batteryLevel {
            if batteryLevel >= 0 {
                moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "baton")
                moreinfoview.moreinfothirdrow.batStatusLabel.text = "\(batteryLevel)"
            } else {
                if let battery = trackerPosition?.attributes?.battery {
                    if battery >= 0 && battery < 1 {
                        moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "batoff")
                        moreinfoview.moreinfothirdrow.batStatusLabel.text = "\(Int(battery))"
                    } else if battery >= 1 {
                        moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "baton")
                        moreinfoview.moreinfothirdrow.batStatusLabel.text = "\(Int(battery))"
                    } else if battery >= 100 {
                        moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "baton")
                        moreinfoview.moreinfothirdrow.batStatusLabel.text = "100"
                    } else {
                        moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
                    }
                } else {
                    moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
                }
            }
//            if batteryLevel >= 0 && batteryLevel <= 1 {
//                moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
//            } else {
//                moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "batoff")
//            }
//        } else {
//            moreinfoview.moreinfothirdrow.batImage.image = #imageLiteral(resourceName: "batoff")
//        }
        
        let power:Double = trackerPosition?.attributes?.power ?? 0.0
        if let extBatt:Double = trackerPosition?.attributes?.extBatt {
            if extBatt != -1.0 {
                if extBatt >= 0 && extBatt < 1 {
                    moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "batoff")
                    moreinfoview.moreinfothirdrow.extBatStatusLabel.text = "\(Int(extBatt))"
                } else if extBatt >= 1 {
                    moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "baton")
                    moreinfoview.moreinfothirdrow.extBatStatusLabel.text = "\(Int(extBatt))"
                } else {
                    moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
                }
            } else {
                if power >= 0 && power < 1 {
                    moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "batoff")
                    moreinfoview.moreinfothirdrow.extBatStatusLabel.text = "\(Int(power))"
                } else if power >= 1 {
                    moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "baton")
                    moreinfoview.moreinfothirdrow.extBatStatusLabel.text = "\(Int(power))"
                } else {
                    moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
                }
            }
        } else {
            if power >= 0 && power < 1 {
                moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "batoff")
                moreinfoview.moreinfothirdrow.extBatStatusLabel.text = "\(Int(power))"
            } else if power >= 1 {
                moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "baton")
                moreinfoview.moreinfothirdrow.extBatStatusLabel.text = "\(Int(power))"
            } else {
                moreinfoview.moreinfothirdrow.extBatImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
            }
        }
        
        
        
        
        if alarmSetting != nil && type != nil {
            if let door = trackerPosition?.attributes?.door {
                if type == "ac" {
                    if door {
                        moreinfoview.moreinfosecondrow.acImage.image = #imageLiteral(resourceName: "acon")
                        moreinfoview.moreinfosecondrow.acStatusLabel.text = "ON"
                    } else {
                        moreinfoview.moreinfosecondrow.acImage.image = #imageLiteral(resourceName: "acoff")
                        moreinfoview.moreinfosecondrow.acStatusLabel.text = "OFF"
                    }
                } else if type == "door" {
                    if door {
                        moreinfoview.moreinfosecondrow.doorImage.image = #imageLiteral(resourceName: "dooron")
                        moreinfoview.moreinfosecondrow.doorStatusLabel.text = "OPEN"
                    } else {
                        moreinfoview.moreinfosecondrow.doorImage.image = #imageLiteral(resourceName: "dooroff")
                        moreinfoview.moreinfosecondrow.doorStatusLabel.text = "CLOSED"
                    }
                }
            } else {
                moreinfoview.moreinfosecondrow.acImage.image = #imageLiteral(resourceName: "acoff")
                moreinfoview.moreinfosecondrow.acStatusLabel.text = "OFF"
                moreinfoview.moreinfosecondrow.doorImage.image = #imageLiteral(resourceName: "dooroff")
                moreinfoview.moreinfosecondrow.doorStatusLabel.text = "CLOSED"
            }
        }
        
    }
    
    func alarmSettingFunction() {
        login_model =   Defaults().get(for: Key<loginInfoModel>("loginInfoModel")) ?? nil
        if login_model != nil {
            if login_model?.data?.user?.alarmSettings != nil {
                alarmSetting = (RCGlobals.convertToDictionary(text: (login_model?.data?.user?.alarmSettings)!) as! [String : String])
            }
        }
        checkForAlamrAndType()
    }
    
    func checkForAlamrAndType() {
        if alarmSetting != nil{
            type =  alarmSetting!["type"]?.lowercased()
            alarm = alarmSetting!["alarm"]?.lowercased()
        }
    }
    
    func vehicleGeofenceFunction(trackerDevice: TrackerDevicesMapperModel? ) {
        if let geofence = trackerDevice?.geofenceIds {
            if geofence.count > 0 {
                moreinfoview.moreinfofirstrow.geoImage.image = #imageLiteral(resourceName: "Asset 11-1")
                moreinfoview.moreinfofirstrow.geoStatusLabel.text = "INSIDE"
            } else {
                moreinfoview.moreinfofirstrow.geoImage.image = #imageLiteral(resourceName: "geoout")
                moreinfoview.moreinfofirstrow.geoStatusLabel.text = "OUTSIDE"
            }
        }
    }
    
    func ignitionOnOffFunction(trackerDevices: TrackerDevicesMapperModel?, trackerPosition: TrackerPositionMapperModel?) {
        if trackerDevices?.lastUpdate == nil || Date().timeIntervalSince(RCGlobals.getDateFor((trackerDevices?.lastUpdate)!)) > 86400 {
            moreinfoview.moreinfofirstrow.ignitionImage.image = #imageLiteral(resourceName: "Asset 3")
            moreinfoview.moreinfofirstrow.ignitionStatusLabel.text = "N/A"
        } else {
            if let ignition = trackerPosition?.attributes?.ignition {
                if ignition {
                    if trackerPosition?.speed == 0.0 {
                        moreinfoview.moreinfofirstrow.ignitionImage.image = #imageLiteral(resourceName: "Asset 3")
                        moreinfoview.moreinfofirstrow.ignitionStatusLabel.text = "IDLE"
                    } else {
                        moreinfoview.moreinfofirstrow.ignitionImage.image = #imageLiteral(resourceName: "ignon")
                        moreinfoview.moreinfofirstrow.ignitionStatusLabel.text = "ON"
                    }
                } else {
                    moreinfoview.moreinfofirstrow.ignitionImage.image = #imageLiteral(resourceName: "ignoff")
                    moreinfoview.moreinfofirstrow.ignitionStatusLabel.text = "OFF"
                }
            }
        }
    }
    
    func checkForParkingMode(deviceID: Int) {
        
        let parkingVehicles = Defaults().get(for: Key<[Int]>("onlineDeviceStatusIds")) ?? []
        if parkingVehicles.contains(where: { $0 == deviceID }) {
            moreinfoview.moreinfosecondrow.parkingImage.image = #imageLiteral(resourceName: "parking_icon").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
            moreinfoview.moreinfosecondrow.parkingStatusLabel.text = "ON"
        } else {
            moreinfoview.moreinfosecondrow.parkingImage.image = #imageLiteral(resourceName: "Asset 18-1").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
            moreinfoview.moreinfosecondrow.parkingStatusLabel.text = "OFF"
        }
    }
    
    func checkForImmobilizedVehicle(deviceId: Int) {
        let immboilizedVehicle = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices")) ?? []
        if immboilizedVehicle.contains(where: { $0.id == deviceId } ) {
            moreinfoview.moreinfofirstrow.immoImage.image = #imageLiteral(resourceName: "immobilizeButton")
            moreinfoview.moreinfofirstrow.immoStatusLabel.text = "ON"
        } else {
            moreinfoview.moreinfofirstrow.immoImage.image = #imageLiteral(resourceName: "mobilized")
            moreinfoview.moreinfofirstrow.immoStatusLabel.text = "OFF"
        }
    }
    
    func checkForTemprature(trackerPosition: TrackerPositionMapperModel?) {
        //        if let temperature = trackerPosition
    }
    
    func checkForNetwork(trackerDevice: TrackerDevicesMapperModel?, isWatch: Bool) {
        if let status = trackerDevice?.status {
            if !isWatch {
                
                if status == "online" {
                    moreinfoview.moreinfofirstrow.networkImage.image = #imageLiteral(resourceName: "neton")
                    moreinfoview.moreinfofirstrow.networkStatusLabel.text = "CONNECTED"
                } else {
                    moreinfoview.moreinfofirstrow.networkImage.image = #imageLiteral(resourceName: "netoff")
                    moreinfoview.moreinfofirstrow.networkStatusLabel.text = "DISCONNECTED"
                }
                
            } else {
                
                
                if status == "online" {
                    bottomSheetWatch.statusScroll.networkImage.image = #imageLiteral(resourceName: "neton")
                    bottomSheetWatch.statusScroll.networkStatusLabel.text = "CONNECTED"
                } else {
                    bottomSheetWatch.statusScroll.networkImage.image = #imageLiteral(resourceName: "netoff")
                    bottomSheetWatch.statusScroll.networkStatusLabel.text = "DISCONNECTED"
                }
                
            }
            
        } else {
            
            if !isWatch {
                moreinfoview.moreinfofirstrow.networkImage.image = #imageLiteral(resourceName: "netoff")
                moreinfoview.moreinfofirstrow.networkStatusLabel.text = "DISCONNECTED"
            } else {
                bottomSheetWatch.statusScroll.networkImage.image = #imageLiteral(resourceName: "netoff")
                bottomSheetWatch.statusScroll.networkStatusLabel.text = "DISCONNECTED"
            }
        }
    }
    
    func constraints()
    {
        moreinfoview.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(0.9 * kscreenwidth)
            make.height.equalTo(0.48 * kscreenheight)
        }
    }
    
    @objc func dismissBtnAction(_sender : UIButton){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}


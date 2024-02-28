//
//  RCMarker.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import DefaultsKit
import Foundation
import CoreLocation
import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils

enum RCTrackerType: String {
    case Car = "car"
    case Truck = "truck"
    case Bus = "bus"
    case Bike = "bike"
    case Personal = "personal"
    case Train = "subway"
    case Erickshaw = "erickshaw"
    case crane = "steam"
    case pet = "pet"
    
    case other
}

class RCMarker: GMSMarker{//, GMUClusterItem {
    
    override init() {
        super.init()
        self.map = RCMapView.mapView
    }
    
    static func dropMarker(atPoint:CLLocationCoordinate2D,title:String,snippet:String,rotationAngle:CLLocationDegrees,device: TrackerDevicesMapperModel?) -> RCMarker {
        let vehicleIconLabel = Defaults().get(for: Key<String>("vehicleIconSortLabel")) ?? "MEDIUM"
        let  marker = RCMarker(position:atPoint)
        marker.title = title
        if snippet != "" {
            marker.snippet = snippet
        } else {
            marker.snippet = "\(device?.id ?? 0)"
        }
        marker.rotation = rotationAngle
        marker.appearAnimation = .none
        marker.userData = device?.id
        marker.tracksInfoWindowChanges = true
        marker.isFlat = true
        // for marker icon size
        var  CarWidth:Int = 0 ,  TruckWidth:Int = 0 ,BusWidth:Int = 0,BikeWidth:Int = 0 ,PersonalWidth:Int = 0 ,TrainWidth:Int = 0 ,ErickshawWidth:Int = 0 ,craneWidth:Int = 0,petWidth:Int = 0 ,otherWidth:Int = 0
        ,CarHeight:Int = 0 ,TruckHeight:Int = 0 ,BusHeight:Int = 0 ,BikeHeight:Int = 0,PersonalHeight:Int = 0 ,TrainHeight:Int = 0 ,ErickshawHeight:Int = 0,craneHeight:Int = 0 ,petHeight:Int = 0 ,otherHeight:Int = 0
        if vehicleIconLabel == "SMALL" {
            CarWidth = 13
            TruckWidth = 15
            BusWidth = 15
            BikeWidth = 13
            PersonalWidth = 31
            TrainWidth = 26
            ErickshawWidth = 21
            craneWidth = 26
            petWidth = 13
            otherWidth = 27
            
            CarHeight = 27
            TruckHeight = 33
            BusHeight = 33
            BikeHeight = 27
            PersonalHeight = 35
            TrainHeight = 33
            ErickshawHeight = 23
            craneHeight = 31
            petHeight = 26
            otherHeight = 30
        } else if vehicleIconLabel == "LARGE" {
            CarWidth = 17
            TruckWidth = 20
            BusWidth = 20
            BikeWidth = 17
            PersonalWidth = 40
            TrainWidth = 35
            ErickshawWidth = 30
            craneWidth = 35
            petWidth = 17
            otherWidth = 40
            
            CarHeight = 37
            TruckHeight = 43
            BusHeight = 43
            BikeHeight = 37
            PersonalHeight = 45
            TrainHeight = 43
            ErickshawHeight = 33
            craneHeight = 36
            petHeight = 37
            otherHeight = 45
        }
        else {
            CarWidth = 15
            TruckWidth = 17
            BusWidth = 17
            BikeWidth = 15
            PersonalWidth = 35
            TrainWidth = 30
            ErickshawWidth = 25
            craneWidth = 30
            petWidth = 15
            otherWidth = 35
            
            CarHeight = 32
            TruckHeight = 38
            BusHeight = 38
            BikeHeight = 32
            PersonalHeight = 40
            TrainHeight = 38
            ErickshawHeight = 28
            craneHeight = 36
            petHeight = 31
            otherHeight = 40
        }
        
        let ofType:RCTrackerType = RCTrackerType(rawValue: device?.category ?? "car") ?? RCTrackerType.Car
        
        var isOffline:Bool = false
        var isInactive:Bool = false
        var isRunning:Bool = false
        var isIdle:Bool = false
        
        if device?.lastUpdate == nil ||
            Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) >= 86400 {
            isOffline = true
        } else {
            if Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) < 86400 {
                isInactive = true
            } else {
                let keyValue = "Position_" + "\(device?.id ?? 0)"
                let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                let ignition = devicePosition?.attributes?.ignition ?? false
                
                if ignition == false {
                    isRunning = false
                } else {
                    isRunning = true
                    if (device?.showIdleIcon ?? false) == true {
                        isIdle = true
                    }
                }
            }
        }
        
        switch ofType {
        case .other:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "marker6").resizedImage(CGSize.init(width: otherWidth, height: otherHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "personal_inactive")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "personal_idle")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  otherWidth, height:  otherHeight), interpolationQuality: .default)
                        }
                    } else {
                       marker.icon = #imageLiteral(resourceName: "marker3").resizedImage(CGSize.init(width:  otherWidth, height:  otherHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
        case .Truck:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "truckGray").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "truck_inactive")!.resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "truck_idle")!.resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "truck-off").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                    }
                }
            }
            
            break
        case .Personal:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "marker6").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "personal_inactive")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "personal_idle")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "marker3").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
            
        case .Bus:
            if isOffline {
                marker.icon = UIImage(named: "busInactivePDF")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "bus_inactive")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "bus_idle")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "busOnPDF").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        }
                    } else {
                       marker.icon = UIImage(named: "busOffPDF")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                    }
                }
            }
            break
            
        case .Train:
            if isOffline {
                marker.icon = UIImage(named: "trainInactivePDF")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "train_inactive")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "train_idle")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "trainOnPDF").resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = UIImage(named: "trainOffPDF")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
            
        case .Erickshaw:
            if isOffline {
                marker.icon = UIImage(named: "erickshawInactivePDF")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "erickshaw_inactive")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "erickshaw_idle")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "erickshawActivePDF").resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = UIImage(named: "erickshawOffPDF")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
            
        case .Bike:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "bikeGray").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "bike_inactive")!.resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "bike_idle")!.resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "bikeoff").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                    }
                }
            }
            break
        case .crane:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "craneoff_1.png").resizedImage(CGSize.init(width:  CarWidth, height:  craneHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "crane_inactive")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "crane_idle")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "craneoff").resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = UIImage(named: "craneoff_1")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
        default:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "carGray").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "car_inactive")!.resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "car_idle")!.resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                        }else{
                            marker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "car-iconred").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                    }
                }
            }
        }
                
        let markerShowed = Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
        
        if markerShowed == false {
                        
            return marker
            
        } else {
            
            let markerIcon = marker.icon!
            
            let rotation:CGFloat = CGFloat(marker.rotation)
            
            let dynamicView:UIView = RCGlobals.dynamicImgWithLabel(lblText: title, oldImage: markerIcon, rotationAngel: rotation)
            
            marker.iconView = dynamicView
            
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.7)
            
            marker.rotation = 0
                        
            return marker
        }
        
        
    }
    
    
    static func updateMarker(marker:RCMarker, atPoint:CLLocationCoordinate2D, title:String, snippet:String, rotationAngle:CLLocationDegrees,device: TrackerDevicesMapperModel?) -> RCMarker {
        let vehicleIconLabel = Defaults().get(for: Key<String>("vehicleIconSortLabel")) ?? "MEDIUM"
        //        let  marker = RCMarker(position:atPoint)
        marker.title = title
        if snippet != "" {
            marker.snippet = snippet
        } else {
            marker.snippet = "\(device?.id ?? 0)"
        }
        marker.rotation = rotationAngle
        marker.appearAnimation = .none
        marker.userData = device?.id
        marker.tracksInfoWindowChanges = true
        marker.isFlat = true
        // for marker icon size
         var  CarWidth:Int = 0 ,  TruckWidth:Int = 0 ,BusWidth:Int = 0,BikeWidth:Int = 0 ,PersonalWidth:Int = 0 ,TrainWidth:Int = 0 ,ErickshawWidth:Int = 0 ,craneWidth:Int = 0,petWidth:Int = 0 ,otherWidth:Int = 0
         ,CarHeight:Int = 0 ,TruckHeight:Int = 0 ,BusHeight:Int = 0 ,BikeHeight:Int = 0,PersonalHeight:Int = 0 ,TrainHeight:Int = 0 ,ErickshawHeight:Int = 0,craneHeight:Int = 0 ,petHeight:Int = 0 ,otherHeight:Int = 0
         if vehicleIconLabel == "SMALL" {
             CarWidth = 13
             TruckWidth = 15
             BusWidth = 15
             BikeWidth = 13
             PersonalWidth = 31
             TrainWidth = 26
             ErickshawWidth = 21
             craneWidth = 26
             petWidth = 13
             otherWidth = 27
             
             CarHeight = 27
             TruckHeight = 33
             BusHeight = 33
             BikeHeight = 27
             PersonalHeight = 35
             TrainHeight = 33
             ErickshawHeight = 23
             craneHeight = 31
             petHeight = 26
             otherHeight = 30
         } else if vehicleIconLabel == "LARGE" {
             CarWidth = 17
             TruckWidth = 20
             BusWidth = 20
             BikeWidth = 17
             PersonalWidth = 40
             TrainWidth = 35
             ErickshawWidth = 30
             craneWidth = 35
             petWidth = 17
             otherWidth = 40
             
             CarHeight = 37
             TruckHeight = 43
             BusHeight = 43
             BikeHeight = 37
             PersonalHeight = 45
             TrainHeight = 43
             ErickshawHeight = 33
             craneHeight = 36
             petHeight = 37
             otherHeight = 45
         }
         else {
             CarWidth = 15
             TruckWidth = 17
             BusWidth = 17
             BikeWidth = 15
             PersonalWidth = 35
             TrainWidth = 30
             ErickshawWidth = 25
             craneWidth = 30
             petWidth = 15
             otherWidth = 35
             
             CarHeight = 32
             TruckHeight = 38
             BusHeight = 38
             BikeHeight = 32
             PersonalHeight = 40
             TrainHeight = 38
             ErickshawHeight = 28
             craneHeight = 36
             petHeight = 31
             otherHeight = 40
         }
        
        let ofType:RCTrackerType = RCTrackerType(rawValue: device?.category ?? "car") ?? RCTrackerType.Car
        
        var isOffline:Bool = false
        var isInactive:Bool = false
        var isRunning:Bool = false
        var isIdle:Bool = false
        
        if device?.lastUpdate == nil ||
            Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) >= 86400 {
            isOffline = true
        } else {
            if Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) < 86400 {
                isInactive = true
            } else {
                let keyValue = "Position_" + "\(device?.id ?? 0)"
                let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                let ignition = devicePosition?.attributes?.ignition ?? false
                
                if ignition == false {
                    isRunning = false
                } else {
                    isRunning = true
                    if (device?.showIdleIcon ?? false) == true {
                        isIdle = true
                    }
                }
            }
        }
        
        switch ofType {
        case .other:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "marker6").resizedImage(CGSize.init(width: otherWidth, height: otherHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "personal_inactive")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "personal_idle")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  otherWidth, height:  otherHeight), interpolationQuality: .default)
                        }
                    } else {
                       marker.icon = #imageLiteral(resourceName: "marker3").resizedImage(CGSize.init(width:  otherWidth, height:  otherHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
        case .Truck:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "truckGray").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "truck_inactive")!.resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "truck_idle")!.resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "truck-off").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                    }
                }
            }
            
            break
        case .Personal:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "marker6").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "personal_inactive")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "personal_idle")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "marker3").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
            
        case .Bus:
            if isOffline {
                marker.icon = UIImage(named: "busInactivePDF")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "bus_inactive")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "bus_idle")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "busOnPDF").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        }
                    } else {
                       marker.icon = UIImage(named: "busOffPDF")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                    }
                }
            }
            break
            
        case .Train:
            if isOffline {
                marker.icon = UIImage(named: "trainInactivePDF")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "train_inactive")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "train_idle")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "trainOnPDF").resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = UIImage(named: "trainOffPDF")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
            
        case .Erickshaw:
            if isOffline {
                marker.icon = UIImage(named: "erickshawInactivePDF")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "erickshaw_inactive")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "erickshaw_idle")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "erickshawActivePDF").resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = UIImage(named: "erickshawOffPDF")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
            
        case .Bike:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "bikeGray").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "bike_inactive")!.resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "bike_idle")!.resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "bikeoff").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                    }
                }
            }
            break
        case .crane:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "craneoff_1.png").resizedImage(CGSize.init(width:  CarWidth, height:  craneHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "crane_inactive")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "crane_idle")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                        } else {
                            marker.icon = #imageLiteral(resourceName: "craneoff").resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = UIImage(named: "craneoff_1")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                    }
                }
            }
            marker.rotation = 0.0
            break
        default:
            if isOffline {
                marker.icon = #imageLiteral(resourceName: "carGray").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    marker.icon = UIImage(named: "car_inactive")!.resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            marker.icon = UIImage(named: "car_idle")!.resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                        }else{
                            marker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                        }
                    } else {
                        marker.icon = #imageLiteral(resourceName: "car-iconred").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                    }
                }
            }
        }
        
        let markerShowed = Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
        
        if markerShowed == false {
            
            return marker
            
        } else {
            
            let markerIcon = marker.icon!
            
            let rotation:CGFloat = CGFloat(marker.rotation)
            
            let dynamicView:UIView = RCGlobals.dynamicImgWithLabel(lblText: title, oldImage: markerIcon, rotationAngel: rotation)
            
            marker.iconView = dynamicView
            
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.7)
            
            marker.rotation = 0
            
            return marker
            
        }
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    static func changeWhiteColorTransparent(_ image: UIImage) -> UIImage {
        let rawImageRef = image.cgImage as! CGImage
        let colorMasking : [CGFloat] = [222, 255, 222, 255, 222, 255]
        UIGraphicsBeginImageContext(image.size)
        let maskedImageRef: CGImage = rawImageRef.copy(maskingColorComponents: colorMasking)!
        do {
            //if in iphone
            UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: image.size.height)
            UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        }
        
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let result = UIGraphicsGetImageFromCurrentImageContext() as! UIImage
        
        
        UIGraphicsEndImageContext()
        return result ?? UIImage()
    }
    
    static func captureScreen(_ viewcapture : UIView) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(viewcapture.frame.size, viewcapture.isOpaque, 0.0)
        viewcapture.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func clearMarker(marker:RCMarker, forMap:GMSMapView) -> Void {
        marker.map = nil
    }
    
    
    static func clearAllMarkers(markers:[RCMarker],map:GMSMapView) -> Void {
        for marker in markers{
            RCMarker.clearMarker(marker:marker, forMap:map)
        }
    }
    
    static func getDeviceIcon(device: TrackerDevicesMapperModel) -> UIImage {
        // for marker icon size
        let  CarWidth:Int = 13 ,  TruckWidth:Int = 15 ,BusWidth:Int = 15,BikeWidth:Int = 13 ,PersonalWidth:Int = 31 ,TrainWidth:Int = 26 ,ErickshawWidth:Int = 21 ,craneWidth:Int = 26,otherWidth:Int = 27
        
        ,CarHeight:Int = 27 ,TruckHeight:Int = 33 ,BusHeight:Int = 33 ,BikeHeight:Int = 27,PersonalHeight:Int = 35 ,TrainHeight:Int = 33 ,ErickshawHeight:Int = 23,craneHeight:Int = 31,otherHeight:Int = 30
        
        var deviceImage:UIImage = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
        
        let ofType:RCTrackerType = RCTrackerType(rawValue: device.category ?? "car") ?? RCTrackerType.Car
        
        var isOffline:Bool = false
        var isInactive:Bool = false
        var isRunning:Bool = false
        var isIdle:Bool = false
        
        if device.lastUpdate == nil ||
            Date().timeIntervalSince(RCGlobals.getDateFor(device.lastUpdate!)) >= 86400 {
            isOffline = true
        } else {
            if Date().timeIntervalSince(RCGlobals.getDateFor(device.lastUpdate!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor(device.lastUpdate!)) < 86400 {
                isInactive = true
            } else {
                let keyValue = "Position_" + "\(device.id ?? 0)"
                let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                let ignition = devicePosition?.attributes?.ignition ?? false
                
                if ignition == false {
                    isRunning = false
                } else {
                    isRunning = true
                    if (device.showIdleIcon ?? false) == true {
                        isIdle = true
                    }
                }
            }
        }
        
        switch ofType {
        case .other:
            if isOffline {
                deviceImage = #imageLiteral(resourceName: "marker6").resizedImage(CGSize.init(width: otherWidth, height: otherHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "personal_inactive")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "personal_idle")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  otherWidth, height:  otherHeight), interpolationQuality: .default)
                        }
                    } else {
                       deviceImage = #imageLiteral(resourceName: "marker3").resizedImage(CGSize.init(width:  otherWidth, height:  otherHeight), interpolationQuality: .default)
                    }
                }
            }
            
            break
        case .Truck:
            if isOffline {
                deviceImage = #imageLiteral(resourceName: "truckGray").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "truck_inactive")!.resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "truck_idle")!.resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = #imageLiteral(resourceName: "truck-off").resizedImage(CGSize.init(width:  TruckWidth, height:  TruckHeight), interpolationQuality: .default)
                    }
                }
            }
            deviceImage = RCGlobals.imageRotatedByDegrees(oldImage: deviceImage, deg: -90)
            break
        case .Personal:
            if isOffline {
                deviceImage = #imageLiteral(resourceName: "marker6").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "personal_inactive")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "personal_idle")!.resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "personalMarker").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = #imageLiteral(resourceName: "marker3").resizedImage(CGSize.init(width:  PersonalWidth, height:  PersonalHeight), interpolationQuality: .default)
                    }
                }
            }
            break
            
        case .Bus:
            if isOffline {
                deviceImage = UIImage(named: "busInactivePDF")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "bus_inactive")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "bus_idle")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "busOnPDF").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        }
                    } else {
                       deviceImage = UIImage(named: "busOffPDF")!.resizedImage(CGSize.init(width:  BusWidth, height:  BusHeight), interpolationQuality: .default)
                    }
                }
            }
            deviceImage = RCGlobals.imageRotatedByDegrees(oldImage: deviceImage, deg: -90)
            break
            
        case .Train:
            if isOffline {
                deviceImage = UIImage(named: "trainInactivePDF")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "train_inactive")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "train_idle")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "trainOnPDF").resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = UIImage(named: "trainOffPDF")!.resizedImage(CGSize.init(width:  TrainWidth, height:  TrainHeight), interpolationQuality: .default)
                    }
                }
            }
            
            break
            
        case .Erickshaw:
            if isOffline {
                deviceImage = UIImage(named: "erickshawInactivePDF")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "erickshaw_inactive")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "erickshaw_idle")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "erickshawActivePDF").resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = UIImage(named: "erickshawOffPDF")!.resizedImage(CGSize.init(width:  ErickshawWidth, height:  ErickshawHeight), interpolationQuality: .default)
                    }
                }
            }
            
            break
            
        case .Bike:
            if isOffline {
                deviceImage = #imageLiteral(resourceName: "bikeGray").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "bike_inactive")!.resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "bike_idle")!.resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = #imageLiteral(resourceName: "bikeoff").resizedImage(CGSize.init(width:  BikeWidth, height:  BikeHeight), interpolationQuality: .default)
                    }
                }
            }
            deviceImage = RCGlobals.imageRotatedByDegrees(oldImage: deviceImage, deg: -90)
            break
        case .crane:
            if isOffline {
                deviceImage = #imageLiteral(resourceName: "craneoff_1.png").resizedImage(CGSize.init(width:  CarWidth, height:  craneHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "crane_inactive")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "crane_idle")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                        } else {
                            deviceImage = #imageLiteral(resourceName: "craneoff").resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = UIImage(named: "craneoff_1")!.resizedImage(CGSize.init(width:  craneWidth, height:  craneHeight), interpolationQuality: .default)
                    }
                }
            }
            
            break
        default:
            if isOffline {
                deviceImage = #imageLiteral(resourceName: "carGray").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
            } else {
                if isInactive {
                    deviceImage = UIImage(named: "car_inactive")!.resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                } else {
                    if isRunning {
                        if isIdle {
                            deviceImage = UIImage(named: "car_idle")!.resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                        }else{
                            deviceImage = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                        }
                    } else {
                        deviceImage = #imageLiteral(resourceName: "car-iconred").resizedImage(CGSize.init(width:  CarWidth, height:  CarHeight), interpolationQuality: .default)
                    }
                }
            }
            deviceImage = RCGlobals.imageRotatedByDegrees(oldImage: deviceImage, deg: -90)
            
        }
        
        return deviceImage
        
    }
    
    
}

class GeoFenceMarker: GMSMarker {
    
    override init() {
        super.init()
        self.map = RCMapView.mapView
    }
    
    
    static func dropMarker(atPoint:CLLocationCoordinate2D,title:String,snippet:String,rotationAngle:CLLocationDegrees, isDraggable: Bool) -> GeoFenceMarker {
        let marker = GeoFenceMarker(position:atPoint)
        marker.title = title
        marker.snippet = snippet
        marker.rotation = rotationAngle
        marker.appearAnimation = .none
        marker.isDraggable = isDraggable
        marker.isFlat = true
        return marker
    }
    
}


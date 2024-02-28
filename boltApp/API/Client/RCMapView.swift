//
//  RCMapView.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import GoogleMaps

let kMapStyle = "[" +
    "{" +
    "    \"featureType\": \"transit.line\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"lightness\": 70" +
    "    }" +
    "    ]" +
    "}" +
"]"


class RCMapView : GMSMapView {
    
     override init(frame: CGRect) {
     super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    public static let mapView:RCMapView = {
        let sharedMap = RCMapView(frame: CGRect.zero)
        sharedMap.isMyLocationEnabled = true
        sharedMap.mapType = .normal
        sharedMap.isBuildingsEnabled = false
        sharedMap.isIndoorEnabled = false
        sharedMap.accessibilityElementsHidden = true
        sharedMap.settings.myLocationButton = true
        sharedMap.settings.compassButton = true
        sharedMap.setMinZoom(kGMSMinZoomLevel, maxZoom:kGMSMaxZoomLevel)
        
        do {
            // Set the map style by passing the URL of the local file.
            sharedMap.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        return sharedMap
    }()
    
    static func clearMap() -> Void {
        RCMapView.mapView.clear()
    }
}

class RCMainMap : GMSMapView {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.isMyLocationEnabled = true
        self.mapType = .normal
        self.isBuildingsEnabled = false
        self.isIndoorEnabled = false
        self.accessibilityElementsHidden = true
        self.settings.myLocationButton = true
        self.settings.compassButton = true
        self.setMinZoom(kGMSMinZoomLevel, maxZoom:kGMSMaxZoomLevel)
        self.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 5)
        
    do {
            // Set the map style by passing the URL of the local file.
            self.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

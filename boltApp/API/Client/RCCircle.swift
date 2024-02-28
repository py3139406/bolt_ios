//
//  File.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import GoogleMaps


class RCCircle: GMSCircle {
    
   override init() {
        super.init()
    }
    
    
    static func drawCircleWithCenter(point: CLLocation, radius: Double, title: String, color: UIColor = UIColor.blue, map: GMSMapView) -> RCCircle {
        let circleOverlay = RCCircle(position:point.coordinate, radius:radius)
        circleOverlay.fillColor = color.withAlphaComponent(0.3)
        circleOverlay.strokeColor = color
        circleOverlay.strokeWidth = 2
        circleOverlay.title = title
        circleOverlay.isTappable = true
        circleOverlay.map = map
        return circleOverlay
    }
    
   static func clear(circle:RCCircle) -> Void {
        circle.map = nil
    }
    
}

extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/Double.pi)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * Double.pi/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }
}

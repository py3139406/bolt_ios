//
//  RCPolygon.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//


import GoogleMaps

class RCPolygon : GMSPolygon {
    
    
    override init() {
        super.init()
    }
    
    public static func drawPolygon(points:[CLLocationCoordinate2D], title: String, color: UIColor = UIColor.red, map:GMSMapView) -> RCPolygon {
        let path = GMSMutablePath()
        for point in points {
            path.add(point)
        }
        // Create the polygon, and assign it to the map.
        let polygon = RCPolygon(path: path)
        polygon.fillColor = color.withAlphaComponent(0.3)
        polygon.strokeColor = color
        polygon.isTappable = true
        polygon.title = title
        polygon.strokeWidth = 2
        polygon.map = map
        return polygon
    }
    
    static func clear(polygon:RCPolygon) -> Void {
        polygon.map = nil
    }
}


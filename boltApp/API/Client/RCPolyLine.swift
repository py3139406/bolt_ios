//
//  RCPolyLine.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//


import GoogleMaps

class RCPolyLine : GMSPolyline {

    
    override init() {
         super.init()
         self.strokeWidth = 2.0
         self.strokeColor = .red
        self.isTappable = true
         self.geodesic = true
         self.map = RCMapView.mapView
    }
    
    init(mapView:GMSMapView) {
        super.init()
        self.strokeWidth = 2.0
        self.strokeColor = .red
        self.isTappable = true
        self.geodesic = true
        self.map = mapView
    }
    
  public func drawpolyLineFrom(pointA:CLLocation,pointB:CLLocation) ->Void {
        let path = GMSMutablePath()
        path.add(pointA.coordinate)
        path.add(pointB.coordinate)
        self.path = path
    }
    
    public func drawpolyLineFrom(points: [CLLocationCoordinate2D], color: UIColor, title: String, map: GMSMapView) -> GMSMutablePath {
        let path = GMSMutablePath()
        for point in points {
            path.add(point)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 2.0
        polyline.strokeColor = color
        polyline.title = title
        polyline.geodesic = true
        polyline.map = map
        self.path = path
        return path
    }
    
    public func drawReturnpolyLineFrom(points:[CLLocationCoordinate2D]) -> GMSMutablePath {
        let path = GMSMutablePath()
        for point in points {
            path.add(point)
        }
        self.path = path
        return path
    }
    
  public  func returnPolyLineFrom(points:[CLLocation]) -> GMSMutablePath {
        let path = GMSMutablePath()
        for point in points {
            path.add(point.coordinate)
        }
        return path
    }
    
    
    public func addPolyLineAt(point:CLLocationCoordinate2D,path:GMSMutablePath) -> GMSMutablePath {
        path.add(point)
        self.path = path
        return path
    }
    
    public func addPolyLineAt(point:CLLocation,path:GMSMutablePath) -> GMSMutablePath {
        path.add(point.coordinate)
        self.path = path
        return path
    }

}

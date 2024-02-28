//
//  GeoMapViewOnlyController
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import GooglePlaces
import GoogleMaps



class GeoMapViewOnlyController: UIViewController {
    
    var geoFence_MapView:GeoFenceMapView!
    var flag = true
    var fenceMarker:GMSMarker!
    var fenceCircle:RCCircle!
    var fencePolygon: RCPolygon!
    var fencePolylinePath: GMSMutablePath!
    var radius:Double!
    var location:CLLocation!
    var type: RCGeofenceType = RCGeofenceType.Circle
    var markersLocations: [CLLocationCoordinate2D] = []
    var geofenceToShow: GeofenceModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RCMapView.clearMap()
        geoFence_MapView = GeoFenceMapView(frame: view.bounds)
        
        geoFence_MapView.searchButton.isEnabled = true
        geoFence_MapView.cancelButton.isEnabled = true
        geoFence_MapView.circleButton.isEnabled = true
        geoFence_MapView.polygonButton.isEnabled = true
        geoFence_MapView.polylineButton.isEnabled = true
        geoFence_MapView.submitButton.isEnabled = true
        view.addSubview(geoFence_MapView)
        
        geoFence_MapView.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        
        geoFence_MapView.searchButton.addTarget(self, action: #selector(searchPlace), for: .touchUpInside)
        
        geoFence_MapView.slider.addTarget(self, action:#selector(sliderValueChanged(sender:)), for:.valueChanged)
        
        geoFence_MapView.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        
        geoFence_MapView.circleButton.addTarget(self, action: #selector(circleButtonAction), for: .touchUpInside)
        
        geoFence_MapView.polygonButton.addTarget(self, action: #selector(polygonButtonAction), for: .touchUpInside)
        
        geoFence_MapView.polylineButton.addTarget(self, action: #selector(polylineButtonAction), for: .touchUpInside)
       
        addNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if geofenceToShow != nil {
            checkTypeOfGeofence()
        }
    }

    @objc func submitButtonAction(){
        
        let alert = UIAlertController(title: "Update Geofence".toLocalize, message: "Enter a text".toLocalize, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Name".toLocalize
        }
        alert.addAction(UIAlertAction(title: "Submit".toLocalize, style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            switch self.type {
            case RCGeofenceType.Circle:
                if(self.radius == nil) && (self.location == nil){
                    self.showalert("Please create a geofence first".toLocalize)
                }else {
                    let area:String = "CIRCLE (" + "\(self.location.coordinate.latitude)"  + " " + "\(self.location.coordinate.longitude)" + ", " + String(format:"%.1f", self.radius) + ")"
                  
                    if self.geofenceToShow != nil {
                        self.updateGeoFence(geofenceId:self.geofenceToShow.id, type: "circle", name: textField?.text ?? self.geofenceToShow.name, description: self.geofenceToShow.descriptionField, area: area)
                    }else{
                        self.createGeofence(name: textField?.text ?? "Name", area: area, type: "circle")
                    }
                }
            case RCGeofenceType.Polygon:
                if self.markersLocations.count > 0 {
                    let tempArea = (self.markersLocations.map{String($0.latitude) + " " + String($0.longitude)}).joined(separator: ",")
                    let area:String = "POLYGON ((" + tempArea + "))"
               //     self.createGeofence(name: textField?.text ?? "Name", area: area, type: "polygon")
                    
                    if self.geofenceToShow != nil {
                        self.updateGeoFence(geofenceId:self.geofenceToShow.id, type: "circle", name: textField?.text ?? self.geofenceToShow.name, description: self.geofenceToShow.descriptionField, area: area)
                    }else{
                        self.createGeofence(name: textField?.text ?? "Name", area: area, type: "circle")
                    }
                }else {
                    self.showalert("Please create a geofence first".toLocalize)
                }
            case RCGeofenceType.Polyline:
                if self.markersLocations.count > 0 {
                    let tempArea = (self.markersLocations.map{String($0.latitude) + " " + String($0.longitude)}).joined(separator: ",")
                    let area:String = "LINESTRING (" + tempArea + ")"
                //    self.createGeofence(name: textField?.text ?? "Name", area: area, type: "polyline")
                   
                    if self.geofenceToShow != nil {
                        self.updateGeoFence(geofenceId:self.geofenceToShow.id, type: "circle", name: textField?.text ?? self.geofenceToShow.name, description: self.geofenceToShow.descriptionField, area: area)
                    }else{
                        self.createGeofence(name: textField?.text ?? "Name", area: area, type: "circle")
                    }
                }else {
                    self.showalert("Please create a geofence first".toLocalize)
                }
            default:
                print("default value")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @objc func circleButtonAction(){
        cancelButtonAction()
        type = RCGeofenceType.Circle
        geoFence_MapView.slider.isHidden = false
        RCMapView.clearMap()
        markersLocations.removeAll()
        
        let coordinate = geoFence_MapView.mapView.projection.coordinate(for: geoFence_MapView.mapView.center)
        GeoFenceMarker.dropMarker(atPoint: coordinate, title: "", snippet: "", rotationAngle: 0.0, isDraggable: true)
        
        location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if radius == nil {
            radius = 500
        }
        
        plotGeoFenceOnMap(point:location, radius:radius!)
        
        fitMap(coordinates: [coordinate])
    }
    
    @objc func polygonButtonAction() {
        type = RCGeofenceType.Polygon
        cancelButtonAction()
        geoFence_MapView.slider.isHidden = true
        RCMapView.clearMap()
        markersLocations.removeAll()
    }
    @objc func polylineButtonAction() {
        type = RCGeofenceType.Polyline
        cancelButtonAction()
        geoFence_MapView.slider.isHidden = true
        RCMapView.clearMap()
        markersLocations.removeAll()
    }
    
    @objc func cancelButtonAction(){
        flag = !flag
        geoFence_MapView.circleLabel.isHidden  = flag
        geoFence_MapView.polygonLabel.isHidden  = flag
        geoFence_MapView.polylineLabel.isHidden = flag
        geoFence_MapView.circleButton.isHidden  = flag
        geoFence_MapView.polygonButton.isHidden = flag
        geoFence_MapView.polylineButton.isHidden = flag
        
        if flag{
            geoFence_MapView.cancelButton.setImage(#imageLiteral(resourceName: "plus").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
            
        }else{
            geoFence_MapView.cancelButton.setImage(#imageLiteral(resourceName: "cross").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        }
        
    }
    
    
    
    @objc func sliderValueChanged(sender:UISlider) -> Void {
        let value  = geoFence_MapView.slider.value
        radius = Double(value) * 20
        radius = Double(round(radius!*100/100))
        if location != nil {
            fenceCircle.map = nil
            fenceMarker.map = nil
            plotGeoFenceOnMap(point:location, radius:radius!)
        }
    }
   
    @objc func searchPlace() {
        let autocompleteController = GMSAutocompleteViewController()
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func checkTypeOfGeofence(){
        if geofenceToShow != nil {
            if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                }
                let _ = RCPolygon.drawPolygon(points: locations, title: "", color: self.hexStringToUIColor(hex: (geofenceToShow.attributes?.areaColor)!), map: geoFence_MapView.mapView)
                
                fitMap(coordinates: locations)
                
            } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
                let circleFence = RCCircle.drawCircleWithCenter(point:locations, radius:Double(coordinates[2])!, title: "", map:(geoFence_MapView.mapView)!)
                fitMap(coordinates: [locations.coordinate])
                let update = GMSCameraUpdate.fit(circleFence.bounds())
                geoFence_MapView.mapView.animate(with: update)
                
            } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                }
                let _ = RCPolyLine().drawpolyLineFrom(points: locations,color: UIColor.red,title: "", map: geoFence_MapView.mapView)
//                RCPolygon.drawPolygon(points: locations, map: geoFence_MapView.mapView)
                fitMap(coordinates: locations)
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        geofenceToShow = nil
        geoFence_MapView.mapView.clear()
    }
    
    func createGeofence(name: String, area: String, type:String) {
        RCLocalAPIManager.shared.createGeofence(with: name, area: area, type:type, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            UIApplication.shared.keyWindow?.makeToast("Geofence added successfully".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.dismiss(animated: true, completion: nil)
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("please try again")
            print(message)
        }
        
    }
    
    func updateGeoFence(geofenceId:Int,type:String,name:String,description:String,area:String) {
        RCLocalAPIManager.shared.updateGeofence(with: geofenceId, type: type, name: name, description: description, area: area, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            UIApplication.shared.keyWindow?.makeToast("Geofence Updated successfully".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.dismiss(animated: true, completion: nil)
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("please try again")
            print(message)
        }
    }
   
    
    
    
    func addNav(){
        let navItem = UINavigationItem(title: "")
        let leftButton = UIBarButtonItem(image:#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 22), interpolationQuality: .default), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(backTapped))
        leftButton.tintColor = appGreenTheme
        navItem.leftBarButtonItem = leftButton
        navItem.title = "View Geofence".toLocalize
        geoFence_MapView.navBar.setItems([navItem], animated: false)
    }
    
    @objc func backTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func getGeofence(name: String, area: String, type:String) {
        RCLocalAPIManager.shared.createGeofence(with: name, area: area, type:type, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            UIApplication.shared.keyWindow?.makeToast("Geofence added successfully".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.dismiss(animated: true, completion: nil)
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("please try again")
            print(message)
        }
        
    }
    
    @objc func getPlotGeofence() {
        type = RCGeofenceType.Circle
        RCMapView.clearMap()
        markersLocations.removeAll()
        
        plotGeoFenceOnMap(point:location, radius:radius!)
//        fitMap(coordinates: [coordinate])
    }
    
    
    func plotGeoFenceOnMap(point:CLLocation,radius:Double) -> Void {
        fenceCircle = RCCircle.drawCircleWithCenter(point:point, radius:radius, title: "", map:(geoFence_MapView.mapView)!)
        fenceMarker = GMSMarker(position:point.coordinate)
        fenceMarker?.map = geoFence_MapView.mapView
        fenceMarker?.isDraggable = true
        //        bounds.append(point.coordinate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func fitMap(coordinates: [CLLocationCoordinate2D]) -> Void {
        var bounds: GMSCoordinateBounds!
        bounds = GMSCoordinateBounds()
        for coordinate in coordinates {
            bounds = bounds.includingCoordinate(coordinate)
        }
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding: 75)
        geoFence_MapView.mapView.animate(with:updateCamera)
    }
    
}





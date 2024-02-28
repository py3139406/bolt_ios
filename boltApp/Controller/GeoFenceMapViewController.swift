//
//  GeoFenceMapViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import GooglePlaces
import GoogleMaps


enum RCGeofenceType :Int {
    case Circle = 0
    case Polygon
    case Polyline
    case Direction
}


class GeoFenceMapViewController: UIViewController {
    
    var geoFenceMapView:GeoFenceMapView!
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
    var markerLocation :CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNav()
        geoFenceMapView = GeoFenceMapView()
        view.addSubview(geoFenceMapView)
        setConstraints()
        checkGeofenceType()
        
        geoFenceMapView.cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        geoFenceMapView.searchButton.addTarget(self, action: #selector(searchPlace), for: .touchUpInside)
        geoFenceMapView.slider.addTarget(self, action:#selector(sliderValueChanged(sender:)), for:.valueChanged)
        geoFenceMapView.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        
        geoFenceMapView.circleButton.addTarget(self, action: #selector(circleButtonAction), for: .touchUpInside)
        geoFenceMapView.polygonButton.addTarget(self, action: #selector(polygonButtonAction), for: .touchUpInside)
        geoFenceMapView.polylineButton.addTarget(self, action: #selector(polylineButtonAction), for: .touchUpInside)
        geoFenceMapView.satelliteBtn.addTarget(nil, action: #selector(changeMapTypeBtnAction), for: .touchUpInside)
        geoFenceMapView.mapView.delegate = self
    }
    func checkGeofenceType(){
        if let geofence = geofenceToShow {
            switch geofence.attributes?.type {
            case "polyline":
                geoFenceMapView.slider.isHidden = true
                break
            case "circle":
                geoFenceMapView.slider.isHidden = false
                break
            case "polygon":
                geoFenceMapView.slider.isHidden = true
                break
            default:
                break
            }
        }
    }
    
    func setConstraints(){
        geoFenceMapView.snp.makeConstraints { (make) in
          if #available(iOS 11, *){
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
          }else{
            make.edges.equalToSuperview()
          }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        geoFenceMapView.mapView.clear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            checkTypeOfGeofence()
    }
    
    @objc func changeMapTypeBtnAction(sender:UIButton){
         
         if sender.currentImage == #imageLiteral(resourceName: "Asset 67") {
             geoFenceMapView.mapView.mapType = .satellite
             geoFenceMapView.satelliteBtn.setImage(#imageLiteral(resourceName: "Asset 66"), for: .normal)
             //geoFenceMapView.satelliteBtn.text = "Normal Map".toLocalize
         }else{
             geoFenceMapView.mapView.mapType = .normal
             geoFenceMapView.satelliteBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for: .normal)
             //geoFenceMapView.satelliteBtn.text = "Satellite Map".toLocalize
         }
         
     }
    func addNav(){
        self.navigationItem.title = "geofence"
        let leftButton = UIBarButtonItem(image:#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(backTapped))
        leftButton.tintColor = appGreenTheme
        navigationController?.navigationItem.leftBarButtonItem = leftButton
       
    }
    
    @objc func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func submitButtonAction(){
        
        if geofenceToShow == nil && markersLocations.count <= 1 && location == nil{
            self.view.makeToast("Please add atleast one area first")
            return
        }
        var titleText = "Update Geofence"
        if  geofenceToShow  == nil {
            titleText = "Submit Geofence"
        }
        let alert = UIAlertController(title:titleText.toLocalize, message: "enter name".toLocalize, preferredStyle: .alert)
        alert.addTextField { (textField) in
            if let geofence = self.geofenceToShow{
                textField.text = geofence.name
            }
        }
        alert.addAction(UIAlertAction(title: "Submit".toLocalize, style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            switch self.type {
            case RCGeofenceType.Circle:
                if(self.radius == nil) && (self.location == nil){
                    self.showalert("Please create a geofence first".toLocalize)
                }else {
                    let area:String = "CIRCLE (" + "\(self.location.coordinate.latitude)"  + " " + "\(self.location.coordinate.longitude)" + ", " + String(format:"%.1f", self.radius) + ")"
                    //  self.createGeofence(name: textField?.text ?? "Name", area: area, type: "circle")
                    if self.geofenceToShow != nil {
                        self.updateGeoFence(geofenceId:self.geofenceToShow.id, type: "circle", name: textField?.text ?? self.geofenceToShow.name, description: self.geofenceToShow.descriptionField , area: area)
                    }else{
                        self.createGeofence(name: textField?.text ?? "No name", area: area, type: "circle")
                    }
                    
                }
            case RCGeofenceType.Polygon:
                if self.markersLocations.count > 0 {
                    let tempArea = (self.markersLocations.map{String($0.latitude) + " " + String($0.longitude)}).joined(separator: ",")
                    let area:String = "POLYGON ((" + tempArea + "))"
                    //    self.createGeofence(name: textField?.text ?? "Name", area: area, type: "polygon")
                    
                    if self.geofenceToShow != nil {
                        self.updateGeoFence(geofenceId:self.geofenceToShow.id, type: "polygon", name: textField?.text ?? self.geofenceToShow.name, description: self.geofenceToShow.descriptionField , area: area)
                    }else{
                        self.createGeofence(name: textField?.text ?? "No name", area: area, type: "polygon")
                    }
                }else {
                    self.showalert("Please create a geofence first".toLocalize)
                }
            case RCGeofenceType.Polyline:
                if self.markersLocations.count > 0 {
                    let tempArea = (self.markersLocations.map{String($0.latitude) + " " + String($0.longitude)}).joined(separator: ",")
                    let area:String = "LINESTRING (" + tempArea + ")"
                    
                    //  self.createGeofence(name: textField?.text ?? "Name", area: area, type: "polyline")
                    if self.geofenceToShow != nil {
                        self.updateGeoFence(geofenceId:self.geofenceToShow.id, type: "polyline", name: textField?.text ?? self.geofenceToShow.name, description: self.geofenceToShow.descriptionField , area: area)
                    }else{
                        self.createGeofence(name: textField?.text ?? "No name", area: area, type: "polyline")
                    }
                }else {
                    self.showalert("Please create a geofence first".toLocalize)
                }
            default:
                print("default value")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel".toLocalize, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
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
            weakSelf.prompt(message)
        }
        
    }
    
    func updateGeoFence(geofenceId:Int,type:String,name:String,description:String,area:String) {
        RCLocalAPIManager.shared.updateGeofence(with: geofenceId, type: type, name: name, description: description, area: area, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            UIApplication.shared.keyWindow?.makeToast("Geofence Updated successfully".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.navigationController?.popViewController(animated: true)
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt(message)
        }
    }
    
    
    @objc func circleButtonAction() {
        geoFenceMapView.mapView.clear()
        cancelButtonAction()
        type = RCGeofenceType.Circle
        geoFenceMapView.slider.isHidden = false
        markersLocations.removeAll()
    }
    
    
    
    @objc func polygonButtonAction() {
        geoFenceMapView.mapView.clear()
        type = RCGeofenceType.Polygon
        cancelButtonAction()
        geoFenceMapView.slider.isHidden = true
        markersLocations.removeAll()
        
    }
    
    @objc func polylineButtonAction() {
        geoFenceMapView.mapView.clear()
        type = RCGeofenceType.Polyline
        cancelButtonAction()
        geoFenceMapView.slider.isHidden = true
        markersLocations.removeAll()
    }
    
    @objc func cancelButtonAction(){
        flag = !flag
        geoFenceMapView.circleLabel.isHidden  = flag
        geoFenceMapView.polygonLabel.isHidden  = flag
        geoFenceMapView.polylineLabel.isHidden = flag
        geoFenceMapView.circleButton.isHidden  = flag
        geoFenceMapView.polygonButton.isHidden = flag
        geoFenceMapView.polylineButton.isHidden = flag
        
        if flag{
            geoFenceMapView.cancelButton.setImage(#imageLiteral(resourceName: "plus").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
            
        }else{
            geoFenceMapView.cancelButton.setImage(#imageLiteral(resourceName: "cross").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        }
        
    }
    
    @objc func sliderValueChanged(sender:UISlider) -> Void {
        let value  = geoFenceMapView.slider.value
        radius = Double(value) * 20
        radius = Double(round(radius!*100/100))
        if location != nil {
            fenceCircle.radius = radius
        }

    }
    
    @objc func getPlotGeofence() {
        type = RCGeofenceType.Circle
        markersLocations.removeAll()
        
        plotGeoFenceOnMap(point:location, radius:radius!)
        //        fitMap(coordinates: [coordinate])
    }
    
    
    func plotGeoFenceOnMap(point:CLLocation,radius:Double) -> Void {
        fenceCircle = RCCircle.drawCircleWithCenter(point:point, radius:radius, title: "", map:(geoFenceMapView.mapView)!)
        fenceMarker = GMSMarker(position:point.coordinate)
        fenceMarker?.map = geoFenceMapView.mapView
        fenceMarker?.isDraggable = true
        let update = GMSCameraUpdate.fit(fenceCircle.bounds())
        geoFenceMapView.mapView.animate(with: update)
        fenceCircle.map = geoFenceMapView.mapView
        //        bounds.append(point.coordinate)
    }
    func checkTypeOfGeofence(){
        if geofenceToShow != nil {
            if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))

                }
                for i in locations {
                    let marker = GeoFenceMarker.dropMarker(atPoint: i, title: "Geofence" , snippet:"", rotationAngle: 0.0, isDraggable: true)
                    marker.icon = UIImage(named: "default_marker")
                    marker.map = geoFenceMapView.mapView
                }
                fencePolygon = RCPolygon.drawPolygon(points: locations, title: "Geofence", color: hexStringToUIColor(hex: (geofenceToShow.attributes?.areaColor) ?? "#189ADE"), map: geoFenceMapView.mapView)
                
                fitMap(coordinates: locations)
            
               
            } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
                self.location = locations
                fenceCircle = RCCircle.drawCircleWithCenter(point:locations, radius:Double(coordinates[2])!, title: "", map:(geoFenceMapView.mapView)!)
                let marker = GeoFenceMarker.dropMarker(atPoint: locations.coordinate, title: geofenceToShow.name , snippet:"", rotationAngle: 0.0, isDraggable: true)
                marker.icon = UIImage(named: "default_marker")
                radius = Double(coordinates[2])
                marker.map = geoFenceMapView.mapView
                fitMap(coordinates: [locations.coordinate])
                let update = GMSCameraUpdate.fit(fenceCircle.bounds())
                geoFenceMapView.mapView.animate(with: update)
                
            } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                }
                for i in locations {
                    let marker = GeoFenceMarker.dropMarker(atPoint: i, title: "Geofence" , snippet:"", rotationAngle: 0.0, isDraggable: true)
                    marker.icon = UIImage(named: "default_marker")
                    marker.map = geoFenceMapView.mapView
                }
                fencePolylinePath = RCPolyLine().drawpolyLineFrom(points: locations, color: UIColor.red, title: "", map: geoFenceMapView.mapView)
//                let _ = RCPolygon.drawPolygon(points: locations, map: geoFenceMapView.mapView)
                fitMap(coordinates: locations)
                
            }
        }
    }
    
    
    @objc func searchPlace() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
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
        geoFenceMapView.mapView.animate(with:updateCamera)
    }
    
}

extension GeoFenceMapViewController: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        if type == RCGeofenceType.Circle {
            fenceCircle.map = nil
            fenceMarker.map = nil
            //        bounds.removeLast()
            location = CLLocation(latitude:marker.position.latitude, longitude:marker.position.longitude)
            //        bounds.append(location.coordinate)
            plotGeoFenceOnMap(point:location,radius:radius!)
        }else if type == RCGeofenceType.Polygon {
            fencePolygon.map = nil
            markersLocations.append(marker.position)
        }else if type == RCGeofenceType.Polyline {
            markersLocations.append(marker.position)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
       if type == RCGeofenceType.Polygon {
               markersLocations.append(coordinate)
        
               let marker = GeoFenceMarker.dropMarker(atPoint: coordinate, title: "geofence", snippet: "", rotationAngle: 0.0, isDraggable: false)
               marker.icon = UIImage(named: "default_marker")
               marker.map = mapView
               if markersLocations.count > 1 {
                   if fencePolygon != nil {
                    RCPolygon.clear(polygon: fencePolygon)
                   }
                   
                   var areaaaColour: String
                   
                if geofenceToShow != nil {
                       
                       if let geofenccc = geofenceToShow.attributes {
                           
                           areaaaColour = geofenccc.areaColor ?? "189ADE"
                           
                       } else {
                           areaaaColour = "189ADE"
                       }
                   } else {
                       areaaaColour = "189ADE"
                   }
                   
                print("markers coordinated :\(markersLocations)")
                   fencePolygon = RCPolygon.drawPolygon(points: markersLocations, title: "geofence", color: hexStringToUIColor(hex: areaaaColour)  , map: geoFenceMapView.mapView)
               }
           }else if type == RCGeofenceType.Polyline {
               markersLocations.append(coordinate)
               let marker =  GeoFenceMarker.dropMarker(atPoint: coordinate, title: "geofence", snippet: "", rotationAngle: 0.0, isDraggable: false)
               marker.icon = UIImage(named: "default_marker")
               marker.map = mapView
               if markersLocations.count == 2 {
                   fencePolylinePath = RCPolyLine(mapView: geoFenceMapView.mapView).drawReturnpolyLineFrom(points: markersLocations)
               }
               if markersLocations.count > 2 {
                   fencePolylinePath = RCPolyLine(mapView: geoFenceMapView.mapView).addPolyLineAt(point: coordinate, path: fencePolylinePath)
               }
           }else if type == RCGeofenceType.Circle {
            geoFenceMapView.mapView.clear()
            location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let marker =  GeoFenceMarker.dropMarker(atPoint: coordinate, title: "geofence", snippet: "", rotationAngle: 0.0, isDraggable: false)
            marker.icon = UIImage(named: "default_marker")
            marker.map = mapView
            if radius == nil {
                radius = 500
            }
            plotGeoFenceOnMap(point:location, radius:radius!)
        }
       }
    
}

extension GeoFenceMapViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if type == RCGeofenceType.Circle {
            location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            if radius == nil {
                radius = 500
            }
            plotGeoFenceOnMap(point:location, radius:radius!)
            
        }else if type == RCGeofenceType.Polygon {

            markersLocations.append(place.coordinate)
            fitMap(coordinates: [place.coordinate])
        }else if type == RCGeofenceType.Polyline {
            markersLocations.append(place.coordinate)
            fitMap(coordinates: [place.coordinate])
        }
      let _ = GeoFenceMarker.dropMarker(atPoint: place.coordinate, title: place.name ?? "", snippet: place.formattedAddress ?? "", rotationAngle: 0.0, isDraggable: true)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


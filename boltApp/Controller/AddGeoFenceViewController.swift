//
//  AddGeoFenceViewController.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class AddGeoFenceViewController: UIViewController {
    
    var tracker:TrackerDevicesMapperModel!
    var bounds:[CLLocationCoordinate2D] = []
    var fenceMarker:GMSMarker!
    var fenceCircle:RCCircle!
    var radius:Double?
    var location:CLLocation!
    weak var addGeoFenceView:AddGeoFenceView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContainer()
        addConstraints()
        setUpButtons()
        checkForGeoFence()
        setUpMap()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(withTracker:TrackerDevicesMapperModel) {
        self.init(nibName:nil, bundle:nil)
        tracker = withTracker
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addContainer() -> Void{
        addGeoFenceView = view.createAndAddSubView(view:"RCAddGeoFenceView") as? AddGeoFenceView
    }
    
    func setUpButtons() -> Void {
        addGeoFenceView?.saveButton.addTarget(self, action:#selector(didTapSaveButton), for:.touchUpInside)
        addGeoFenceView?.newGeoFenceButton.addTarget(self, action:#selector(didtapNewGeoFenceButton), for:.touchUpInside)
        addGeoFenceView?.slider.addTarget(self, action:#selector(sliderValueChanged(sender:)), for:.valueChanged)
    }
    
    func addConstraints() -> Void {
        addGeoFenceView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(view)
        })
    }
    
    func setUpMap() -> Void {
        addGeoFenceView?.geoFenceMapView.delegate = self
    }
    
    func checkForGeoFence() -> Void {
//        RCLocalAPIManager.shared.checkGeoFences(trackerID:tracker.deviceid!, success: {[weak self] (geoFenceDetails) in
//            self?.location = CLLocation(latitude:geoFenceDetails.latitude!, longitude:geoFenceDetails.longitude!)
//            self?.radius = geoFenceDetails.radius!
//            self?.plotTrackerOnMap()
//            self?.plotGeoFenceOnMap(point:(self?.location)!, radius:(self?.radius)!)
//            self?.fitMapToBounds(coordinates:(self?.bounds)!)
//        }) {[weak self] (error) in
//            self?.plotTrackerOnMap()
//            self?.fitMapToBounds(coordinates:(self?.bounds)!)
//            let alert = UIAlertController(title:NSLocalizedString("Message", comment: "Message"), message:error, preferredStyle:.alert)
//            alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok"), style:.destructive, handler:nil))
//            self?.present(alert, animated:true, completion:nil)
//            print("Not available")
//
//        }
    }
    
    func plotGeoFenceOnMap(point:CLLocation,radius:Double) -> Void {
        fenceCircle = RCCircle.drawCircleWithCenter(point:point, radius:radius, title: "", map:(addGeoFenceView?.geoFenceMapView)!)
        fenceMarker = GMSMarker(position:point.coordinate)
        fenceMarker?.map = addGeoFenceView?.geoFenceMapView
        fenceMarker?.isDraggable = true
        bounds.append(point.coordinate)
    }
    
    func plotTrackerOnMap() -> Void {
//        let point  = CLLocation(latitude:tracker.latitude!, longitude:tracker.longitude!)
//        let marker = GeoFenceMarker.dropMarker(atPoint:point.coordinate, title:"", snippet:"", rotationAngle:tracker.course!, isRunning:tracker.ignition!, ofType:RCTrackerType(rawValue: tracker.vehicletype!)!, inActive: tracker.inActive)
//        marker.map = addGeoFenceView?.geoFenceMapView
//        bounds.append(point.coordinate)
    }
    
    @objc func didTapSaveButton() -> Void {
        if location == nil {
            let alert = UIAlertController(title:NSLocalizedString("Message", comment: "Message"), message:NSLocalizedString("Please add GeoFence First", comment: "Please add GeoFence First"), preferredStyle:.alert)
            alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok"), style:.destructive, handler:nil))
            present(alert, animated:true, completion:nil)
        }else {
//            RCLocalAPIManager.shared.setGeoFences(trackerID:self.tracker.deviceid!, latitude:String(location.coordinate.latitude), longitude:String(location.coordinate.longitude), radius:"\(radius ?? 500)", success: {[weak self]() in
//                let alert = UIAlertController(title:NSLocalizedString("Message", comment: "Message"), message:NSLocalizedString("Successfully added GeoFence", comment:"Successfully added GeoFence"), preferredStyle:.alert)
//                alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok"), style:.destructive, handler:nil))
//                self?.present(alert, animated:true, completion:nil)
//                print("success")
//
//            }) {[weak self] (error) in
//                //alert
//                let alert = UIAlertController(title:NSLocalizedString("Message", comment: "Message"), message:NSLocalizedString("Try again later.", comment: "Try again later."), preferredStyle:.alert)
//                alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: "Ok"), style:.destructive, handler:nil))
//                self?.present(alert, animated:true, completion:nil)
//            }
        }
    }
    
    @objc func didtapNewGeoFenceButton() -> Void {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func sliderValueChanged(sender:UISlider) -> Void {
        let value  = addGeoFenceView?.slider.value
        radius = Double(value!) * 100
        radius = Double(round(radius!*100/100))
        print(radius ?? "")
        if location != nil {
            fenceCircle.map = nil
            fenceMarker.map = nil
            plotGeoFenceOnMap(point:location, radius:radius!)
        }
    }
    
    func fitMapToBounds(coordinates:[CLLocationCoordinate2D]) -> Void {
        var bounds = GMSCoordinateBounds(coordinate:coordinates.first!, coordinate:coordinates.last!)
        for marker in coordinates {
            bounds = bounds.includingCoordinate(marker)
        }
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding:74)
        addGeoFenceView?.geoFenceMapView.animate(with:updateCamera)
    }
 
}

extension AddGeoFenceViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if location == nil {
            
        }else{
            fenceMarker.map = nil
            fenceCircle.map = nil
            bounds.removeLast()
        }
        location = CLLocation(latitude:place.coordinate.latitude, longitude:place.coordinate.longitude)
        bounds.append(location.coordinate)
        if radius == nil {
            radius = 500
        }
        
        plotGeoFenceOnMap(point:location, radius:radius!)
        fitMapToBounds(coordinates:bounds)
        dismiss(animated:true, completion:nil)
    }
    
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        dismiss(animated:true, completion:nil)
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

extension AddGeoFenceViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        fenceCircle.map = nil
        fenceMarker.map = nil
        bounds.removeLast()
        location = CLLocation(latitude:marker.position.latitude, longitude:marker.position.longitude)
        bounds.append(location.coordinate)
        plotGeoFenceOnMap(point:location,radius:radius!)
    }
    
}

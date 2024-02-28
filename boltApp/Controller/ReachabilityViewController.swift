//
//  ReachabilityViewController.swift
//  Bolt
//
//  Created by Roadcast on 19/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit
import GooglePlaces
import GoogleMaps

class ReachabilityViewController: UIViewController {
    var reachView:ReachabilityView!
    //for vehicleview
    var vehicleview: VehicleView!
//    var filterdata = [String]()
    var searching = false
    var allDevices = [TrackerDevicesMapperModel]()
    var selectedField:String = ""
    var allGeofences = [GeofenceModel]()
    var geoLocation = CLLocationCoordinate2D()
    var radius:Double = 0
    var isCameraMoved:Bool = false
    var isMyLoactionTapped:Bool = false
    var circle:GMSCircle?
    var vehicleFiltered:[TrackerDevicesMapperModel] = []
    var geoFiltered:[GeofenceModel] = []
    var selectedDeviceId:Int = 0
    var selectedGeofenceId:Int = 0
    var geofenceToShow: GeofenceModel!
    var selectedDateFrom:String = "" // yyyy-MM-dd
    var selectedDateTo:String = ""  // yyyy-MM-dd
    var selectedTime:String = ""    // HH:mm
    var datePpicker : UIDatePicker!
    var toolBbar = UIToolbar()
    var fromDateString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        let devices = RCGlobals.getExpiryFilteredList(data)
        for item in devices {
            if item.lastUpdate != nil {
                allDevices.append(item)
            }
        }
        geoLocation.latitude = 0
        geoLocation.longitude = 0
        allGeofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel")) ?? []
        
        navigationBarFunction()
        setViews()
        setConstraints()
        setVehicleView()
        setActions()
        
        if allDevices.count > 0 {
            reachView.selectVehicleTextField.text = allDevices[0].name
            selectedDeviceId = allDevices[0].id
        }
    }
    func setActions(){
        reachView.selectVehicleTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showVehicleTable(sender:))))
        reachView.newLocBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newLocationTap(sender:))))
        reachView.existGeoBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(geofenceTap(sender:))))
        reachView.emailBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emailBtnTap(sender:))))
        reachView.notifBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notifBtnTap(sender:))))
        reachView.geofenceAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showGeofenceTable(sender:))))
        reachView.radiusField.delegate = self
        
        reachView.radiusField.addTarget(self, action: #selector(ReachabilityViewController.textFieldDidChange(_:)), for: .editingChanged)
        reachView.newLocAddress.isUserInteractionEnabled = true
        reachView.newLocAddress.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(newLocationSearch)))
        reachView.dateTimeField.isUserInteractionEnabled = true
        reachView.dateTimeField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectDateTime)))
        
        reachView.mapView.delegate = self
        
        reachView.saveBtn.addTarget(self, action: #selector(saveReachability), for: .touchUpInside)
        
    }
    
    @objc func saveReachability () {
        if selectedDeviceId == 0 {
            UIApplication.shared.keyWindow?.makeToast("Please select a vehicle first.", duration: 1.0, position: .bottom)
            return
        }
        if selectedGeofenceId == 0 {
            if radius == 0 {
                UIApplication.shared.keyWindow?.makeToast("Please enter radius.", duration: 1.0, position: .bottom)
                return
            }
            if geoLocation.latitude == 0 || geoLocation.longitude == 0 {
                UIApplication.shared.keyWindow?.makeToast("Please select a location for alerts.", duration: 1.0, position: .bottom)
                return
            }
        }
        
        if selectedDateFrom.isEmpty || selectedDateTo.isEmpty {
            UIApplication.shared.keyWindow?.makeToast("Please select date & time.", duration: 1.0, position: .bottom)
            return
        }
        
        var emailStatus:Int = 0
        if reachView.emailBtn.isSelected {
            emailStatus = 1
        }
        var notiStatus:Int = 0
        if reachView.notifBtn.isSelected {
            notiStatus = 1
        }
        var parameters:[String:Any] = ["device_id":selectedDeviceId,"from":selectedDateFrom,"to":selectedDateTo,"reach_time":selectedTime,"email":emailStatus, "web":notiStatus]
        
        if selectedGeofenceId != 0 {
            parameters["geofence_id"] = selectedGeofenceId
        } else {
            parameters["lat"] = geoLocation.latitude
            parameters["lng"] = geoLocation.longitude
            parameters["radius"] = radius
        }
        
        RCLocalAPIManager.shared.saveReachabilityReport(with: parameters, success:  { hash in
            UIApplication.shared.keyWindow?.makeToast("Alert added successfully", duration: 2.0, position: .bottom)
            self.backTapped()
        }) { message in
            UIApplication.shared.keyWindow?.makeToast("Request failed, Please try again.", duration: 1.0, position: .bottom)
        }
    }
    
    @objc func selectDateTime () {
        doDatePicker()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let radiusString = textField.text
        self.radius = Double(radiusString ?? "0") ?? 0
        createGeofence()
    }
    
    @objc func newLocationSearch() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc func newLocationTap(sender:RadioButton){
        if  reachView.newLocBtn.isSelected == false {
            // address
            reachView.newLocAddress.isHidden = false
            reachView.geofenceAddress.isHidden = true
            // self change
            reachView.existGeoBtn.isSelected = false
            reachView.newLocBtn.isSelected = true
            // radius field change
            reachView.radiusField.isHidden = false
            reachView.kmLabel.isHidden = false
            
            reachView.mapPin.isHidden = false
            
            selectedGeofenceId = 0
            
            reachView.mapView.clear()
            
            createGeofence()
            
        }
    }
    @objc func geofenceTap(sender:RadioButton){
        if allGeofences.count == 0 {
            self.view.makeToast("Please add some geofence first")
            reachView.existGeoBtn.isSelected = false
            return
        }
        if  reachView.existGeoBtn.isSelected == false {
            // address
            reachView.newLocAddress.isHidden = true
            reachView.geofenceAddress.isHidden = false
            // self change
            reachView.existGeoBtn.isSelected = true
            reachView.newLocBtn.isSelected = false
            // radius change
            reachView.radiusField.isHidden = true
            reachView.kmLabel.isHidden = true
            
            reachView.mapPin.isHidden = true
            
            geofenceToShow = allGeofences[0]
            
            selectedGeofenceId = allGeofences[0].id 
            
            reachView.geofenceAddress.text = geofenceToShow.name
            
            createExistingGeofence()
        }
    }
    @objc func emailBtnTap(sender:RadioButton){
        if  reachView.emailBtn.isSelected {
            reachView.emailBtn.isSelected = false
        } else {
            reachView.emailBtn.isSelected = true
        }
    }
    @objc func notifBtnTap(sender:RadioButton){
        if  reachView.notifBtn.isSelected {
            reachView.notifBtn.isSelected = false
        } else {
            reachView.notifBtn.isSelected = true
        }
    }
    @objc func showVehicleTable(sender:UITapGestureRecognizer){
        vehicleview.selectvehicleLabel.text = "Select Vehicle"
        vehicleview.resultautoSearchController.placeholder = "Select Vehicle"
        selectedField = "showVehicleTabel"
        
        UIView.animate(withDuration: 0.02) {
            self.vehicleview.isHidden = false
        }
        self.vehicleview.vehicleTableView.reloadData()
    }
    @objc func showGeofenceTable(sender:UITapGestureRecognizer){
        vehicleview.selectvehicleLabel.text = "Select Geofence"
        vehicleview.resultautoSearchController.placeholder = "Select Geofence"
        selectedField = "showGeoTabel"
        UIView.animate(withDuration: 0.02) {
            self.vehicleview.isHidden = false
        }
        self.vehicleview.vehicleTableView.reloadData()
    }
    func  setVehicleView(){
        vehicleview = VehicleView(frame: CGRect(x: 0, y: 0, width: screensize.width, height: screensize.height))
        vehicleview.backgroundColor = .clear
        self.view.addSubview(vehicleview)
        vehicleview.isHidden = true
        vehicleview.vehicleTableView.backgroundColor = .clear
        
        vehicleview.vehicleTableView.register(VehicleTableViewCell.self,
                                              forCellReuseIdentifier: "vehicleCell")
        vehicleview.vehicleTableView.register(geoofenceTableViewCell.self,
                                              forCellReuseIdentifier: "geofenceCell")
        vehicleview.vehicleTableView.isScrollEnabled = true
        vehicleview.vehicleTableView.delegate = self
        vehicleview.vehicleTableView.dataSource = self
        vehicleview.resultautoSearchController.delegate = self
    }
    func setViews(){
        reachView = ReachabilityView(frame: CGRect.zero)
        view.addSubview(reachView)
    }
    func setConstraints(){
        reachView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    func navigationBarFunction() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        //  self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar-3"), style: .plain, target: self, action: nil)
        // self.navigationItem.title = "Reports"
    }
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func moveCamera (_ position: CLLocationCoordinate2D) {
        if circle != nil {
            let circleBounds = circle!.bounds()
            
            reachView.mapView.animate(with: GMSCameraUpdate.fit(circleBounds, withPadding: 20))
        } else {
            let camera = GMSCameraPosition.camera(withTarget: position, zoom: 15)
            reachView.mapView.camera = camera
        }
    }
    
    func moveToLocation() {
        reachView.mapView.clear()
        
        moveCamera(geoLocation)
    }
    
    func createGeofence() {
        if radius != 0{
            
            if circle == nil {
                circle = GMSCircle(position: geoLocation, radius: radius * 1000)
            }
            
            
            circle!.position = geoLocation
            circle!.radius = radius * 1000
            
            circle!.strokeColor = UIColor.blue
            
            circle!.fillColor = UIColor.blue.withAlphaComponent(0.3)
            
            circle!.strokeWidth = 1
            
            circle!.map = reachView.mapView
            
            let circleBounds = circle!.bounds()
            
            reachView.mapView.animate(with: GMSCameraUpdate.fit(circleBounds, withPadding: 20))
        } else {
            reachView.mapView.clear()
        }
    }
    
    func createExistingGeofence() {
        reachView.mapView.clear()
        if geofenceToShow != nil {
            if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                }
                let _ = RCPolygon.drawPolygon(points: locations, title: "", color: hexStringToUIColor(hex: (geofenceToShow.attributes?.areaColor ?? "189ADE")), map: reachView.mapView)
                
                fitMap(coordinates: locations)
                
            } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
                let circleFence = RCCircle.drawCircleWithCenter(point:locations, radius:Double(coordinates[2])!, title: "", map:(reachView.mapView)!)
                fitMap(coordinates: [locations.coordinate])
                let update = GMSCameraUpdate.fit(circleFence.bounds())
                reachView.mapView.animate(with: update)
                
            } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                }
                let _ = RCPolyLine().drawpolyLineFrom(points: locations,color: UIColor.red , title: "", map: reachView.mapView)
                //                let _ = RCPolygon.drawPolygon(points: locations, map: geoFenceMapView.mapView)
                fitMap(coordinates: locations)
                
            }
        }
    }
    
    fileprivate func fitMap(coordinates: [CLLocationCoordinate2D]) -> Void {
        var bounds: GMSCoordinateBounds!
        bounds = GMSCoordinateBounds()
        for coordinate in coordinates {
            bounds = bounds.includingCoordinate(coordinate)
        }
        let updateCamera = GMSCameraUpdate.fit(bounds, withPadding: 20)
        reachView.mapView.animate(with:updateCamera)
    }
    
}
//  vehicle table delegate
extension ReachabilityViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRow:Int = 0
        
        if selectedField == "showVehicleTabel" {
            if searching {
                totalRow = vehicleFiltered.count
            } else {
                totalRow = allDevices.count
            }
        } else if selectedField == "showGeoTabel" {
            if searching {
                totalRow = geoFiltered.count
            } else {
                totalRow = allGeofences.count
            }
        }
        
        return totalRow
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VehicleTableViewCell!
        if selectedField == "showVehicleTabel" {
            cell = vehicleview.vehicleTableView.dequeueReusableCell(withIdentifier: "vehicleCell") as? VehicleTableViewCell
            if searching {
                cell.itemnameLabel!.text = vehicleFiltered[indexPath.row].name
            }
            else {
                cell.itemnameLabel!.text = allDevices[indexPath.row].name
            }
            return cell
        }
        
        if selectedField == "showGeoTabel" {
            cell = vehicleview.vehicleTableView.dequeueReusableCell(withIdentifier: "vehicleCell") as? VehicleTableViewCell
            if searching {
                cell.itemnameLabel!.text = geoFiltered[indexPath.row].name
            }
            else {
                cell.itemnameLabel!.text = allGeofences[indexPath.row].name
            }
            return cell
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(40.0)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor.black
    }
    
    // MARK:- selectVehicleAndGeofence
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if selectedField == "showVehicleTabel" {
            print("You selected cell #\(indexPath.row)")
            
            if searching {
                reachView.selectVehicleTextField.text = vehicleFiltered[indexPath.row].name
                selectedDeviceId = vehicleFiltered[indexPath.row].id
            } else {
                reachView.selectVehicleTextField.text = allDevices[indexPath.row].name
                selectedDeviceId = allDevices[indexPath.row].id
            }
            
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.02) {
                self.vehicleview.isHidden = true
            }
        }  else  if selectedField == "showGeoTabel" {
            if searching {
                reachView.geofenceAddress.text = geoFiltered[indexPath.row].name
                selectedGeofenceId = geoFiltered[indexPath.row].id 
                geofenceToShow = geoFiltered[indexPath.row]
                createExistingGeofence()
            } else {
                reachView.geofenceAddress.text = allGeofences[indexPath.row].name
                selectedGeofenceId = allGeofences[indexPath.row].id 
                geofenceToShow = allGeofences[indexPath.row]
                createExistingGeofence()
            }
            
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.02) {
                self.vehicleview.isHidden = true
            }
        }
        
    }
}
extension ReachabilityViewController:UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reachView.selectVehicleTextField.endEditing(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        reachView.selectVehicleTextField.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = NSPredicate(format: "self contains[c] %@",
                                 vehicleview.resultautoSearchController.text!)
        if selectedField == "showVehicleTabel" {
            vehicleFiltered.removeAll()
            
            for item in allDevices {
                if item.name?.lowercased().contains(searchText.lowercased()) ?? false {
                    vehicleFiltered.append(item)
                }
            }
            
            if vehicleFiltered.count == 0 {
                searching = false
            } else {
                searching = true
            }
            
        } else if selectedField == "showGeoTabel" {
            geoFiltered.removeAll()
            
            for item in allGeofences {
                if item.name.lowercased().contains(searchText.lowercased()) ?? false {
                    geoFiltered.append(item)
                }
            }
            
            if geoFiltered.count == 0 {
                searching = false
            } else {
                searching = true
            }
            
        }
        
        self.vehicleview.vehicleTableView.reloadData()
    }
}
extension ReachabilityViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For radius field validation
        if textField == reachView.radiusField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

extension ReachabilityViewController: GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        geoLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        isMyLoactionTapped = false
        reachView.newLocAddress.text = place.formattedAddress ?? "Not available"
        
        moveToLocation()
        
        createGeofence()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ReachabilityViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        isMyLoactionTapped = false
        if reachView.existGeoBtn.isSelected == false {
            geoLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            reachView.mapView.clear()
            moveToLocation()
            createGeofence()
            reverseGeocoding(latiude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        if reachView.existGeoBtn.isSelected == true {
            return true
        }
//            geoLocation = mapView.camera.target
//            reachView.mapView.clear()
//            moveToLocation()
//            createGeofence()
//            reverseGeocoding(latiude: geoLocation.latitude, longitude: geoLocation.longitude)
//            return true
//        } else {
//            return false
//        }
        isMyLoactionTapped = true
        return false

    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if (isCameraMoved || isMyLoactionTapped) && reachView.existGeoBtn.isSelected == false {
            isCameraMoved = false
            isMyLoactionTapped = false
            
            
            geoLocation = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
            
            createGeofence()
            
            reverseGeocoding(latiude: position.target.latitude, longitude: position.target.longitude)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        isCameraMoved = gesture
        if gesture {
            isMyLoactionTapped = false
        }
    }
    
}

extension ReachabilityViewController {
    func reverseGeocoding(latiude: Double, longitude: Double) {
        let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latiude, longitude: longitude)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            let addressText = lines.joined(separator: " ")
            self.reachView.newLocAddress.text = addressText
        }
    }
}

extension ReachabilityViewController {
    func doDatePicker(){
        // DatePicker
        self.datePpicker = UIDatePicker()
        self.datePpicker?.backgroundColor = UIColor.white
        self.datePpicker?.datePickerMode = UIDatePickerMode.date
        self.datePpicker?.tintColor = .black
        let now = Date()
        self.datePpicker.minimumDate = now;
        let modifiedDate = Calendar.current.date(byAdding: .month, value: 2, to: now)!
        self.datePpicker.maximumDate = modifiedDate
        
        //datePicker.center = view.center
        view.addSubview(self.datePpicker)
        
        // ToolBar
        toolBbar = UIToolbar()
        toolBbar.barStyle = .blackTranslucent
        toolBbar.backgroundColor = .black
        
        toolBbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
       // toolBbar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let name = UIBarButtonItem(title: "From date", style: .plain, target: self, action: nil)
        toolBbar.setItems([cancelButton ,name, spaceButton, doneButton], animated: true)
        toolBbar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBbar)
        self.toolBbar.isHidden = false
        if #available(iOS 13.4, *) {
            datePpicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            datePpicker.tintColor = .black
            datePpicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        setPickerConstraints(datePicker: datePpicker, toolBar: toolBbar)
    }
    
    @objc func doneClick() {
        datePpicker.isHidden = true
        toolBbar.isHidden = true
        
        selectedDateFrom = RCGlobals.convertDateToString(date: datePpicker.date, format: "yyyy-MM-dd", toUTC: false)
        
        fromDateString = RCGlobals.convertDateToString(date: datePpicker.date, format: "MMM dd, yyyy", toUTC: false)
        
        doTimePicker()
    }
    
    @objc func cancelClick() {
        datePpicker.isHidden = true
        self.toolBbar.isHidden = true
    }
    
    func doTimePicker() {
        // DatePicker
        self.datePpicker = UIDatePicker()
        self.datePpicker?.backgroundColor = UIColor.white
        self.datePpicker?.tintColor = .black
        self.datePpicker?.datePickerMode = UIDatePickerMode.dateAndTime
        let now = Date()
        self.datePpicker.minimumDate = now;
        let modifiedDate = Calendar.current.date(byAdding: .month, value: 2, to: now)!
        self.datePpicker.maximumDate = modifiedDate
        
        //datePicker.center = view.center
        view.addSubview(self.datePpicker)
        
        // ToolBar
        toolBbar = UIToolbar()
        toolBbar.barStyle = .blackTranslucent
        toolBbar.backgroundColor = .black
        
        toolBbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
       // toolBbar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let name = UIBarButtonItem(title: "To date & Time", style: .plain, target: self, action: nil)
        toolBbar.setItems([cancelButton ,name, spaceButton, doneButton], animated: true)
        toolBbar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBbar)
        self.toolBbar.isHidden = false
        if #available(iOS 13.4, *) {
            datePpicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            datePpicker.tintColor = .black
            datePpicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        setPickerConstraints(datePicker: datePpicker, toolBar: toolBbar)
    }
    
    @objc func doneTimePick() {
        datePpicker.isHidden = true
        toolBbar.isHidden = true
        
        selectedDateTo = RCGlobals.convertDateToString(date: datePpicker.date, format: "yyyy-MM-dd", toUTC: false)
        
        selectedTime = RCGlobals.convertDateToString(date: datePpicker.date, format: "HH:mm", toUTC: false)
        
        let toDateString = RCGlobals.convertDateToString(date: datePpicker.date, format: "MMM dd, yyyy", toUTC: false)
        
        let time = RCGlobals.convertDateToString(date: datePpicker.date, format: "hh:mm a", toUTC: false)
        
        reachView.dateTimeField.text = "\(fromDateString) - \(toDateString) @ \(time)"
    }
}


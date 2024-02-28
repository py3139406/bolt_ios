//
//  VehicleViewController.swift
//  Bolt
//
//  Created by Roadcast on 05/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
import DefaultsKit
import GoogleMaps

protocol addEditAllVehicleDelegate: class {
    func viewAllVehiclesTapped()
    func selectedVehiclesTapped(deviceIds: [Int])
    func specificVehicleTypeTapped(vehicleType: Int?)
    func multipleSelectedDeviceId(deviceIds: [Int])
}

var devPosCoordinateDic:[String:String] = [:]
var isListVisible:Bool = false
var vehicleListView:VehicleListView!
var deviceList:[TrackerDevicesMapperModel] = []
var branchId:String = "0"

class VehicleViewController: UIViewController, UIGestureRecognizerDelegate {
    weak var delegate: addEditAllVehicleDelegate?
    lazy var mapController = MapsViewController()
    let refreshControl = UIRefreshControl()
    var lastUpdateModel : [LastActivationTimeData]?
    var isMultipleSelectEnabled:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue)) ?? false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setViews()
        setConstraints()
        setActions()
        self.delegate = mapController
        isListVisible = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getIgnitionTime()
        updateVehicleList()
        
        isMultipleSelectEnabled = Defaults().get(for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue)) ?? false
        
        isListVisible = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        refreshControl.endRefreshing()
        isListVisible = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isListVisible = true
    }
    
    func setViews(){
        vehicleListView = VehicleListView()
        vehicleListView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        view.addSubview(vehicleListView)
    }
    func setConstraints(){
        vehicleListView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    func setNavigation(){
        view.backgroundColor = appGreenTheme
        self.navigationController?.isNavigationBarHidden =  true
    }
    
    func setActions(){
        vehicleListView.vehicleTable.register(VehicleListTableViewCell.self, forCellReuseIdentifier: TableCellIdentifiers.vehicleListTable.rawValue)
        vehicleListView.vehicleTable.delegate = self
        vehicleListView.vehicleTable.dataSource = self
        
        let ignitionOnGesture = UITapGestureRecognizer(target: self, action: #selector(ignitionOnTapped(_:)))
        let ignitionOffGesture = UITapGestureRecognizer(target: self, action: #selector(ignitionOffTapped(_:)))
        let inactiveGesture = UITapGestureRecognizer(target: self, action: #selector(inactiveTapped(_:)))
        let offlineGesture = UITapGestureRecognizer(target: self, action: #selector(offlineTapped(_:)))
        vehicleListView.ignitionOnView.addGestureRecognizer(ignitionOnGesture)
        vehicleListView.ignitionOffView.addGestureRecognizer(ignitionOffGesture)
        vehicleListView.inactiveView.addGestureRecognizer(inactiveGesture)
        vehicleListView.offlineView.addGestureRecognizer(offlineGesture)
        
        vehicleListView.viewAllBtn.addTarget(self, action: #selector(viewAllTapped), for: .touchUpInside)
        let guesture = UITapGestureRecognizer(target: self, action: #selector(showUserList))
        guesture.numberOfTouchesRequired = 1
        vehicleListView.userListView.addGestureRecognizer(guesture)
        // add refresh controller
        vehicleListView.vehicleTable.refreshControl = refreshControl
        refreshControl.addTarget(self, action:  #selector(refreshAction(_:)), for: .valueChanged)
        vehicleListView.vehicleTable.refreshControl?.tintColor = .black
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        vehicleListView.vehicleTable.addGestureRecognizer(longPressGesture)
        vehicleListView.searchBar.addTarget(self, action: #selector(searchingCall), for: .allEditingEvents)

    }
    @objc func searchingCall(){
        updateVehicleList()
    }
    @objc func showUserList(){
        present(TreeViewController(), animated: true, completion: nil)
    }
    @objc private func refreshAction(_ sender: Any) {
        getDevices()
    }
    func getDevices() {
        RCLocalAPIManager.shared.getDevices(success: { [weak self] hash in
            guard let weakSelf = self else { return }
            weakSelf.getPositions()
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            UIApplication.shared.keyWindow?.makeToast("Unable to fetch vehicles data due to poor internet connectivity".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.dismiss(animated: true, completion: nil)
            weakSelf.refreshControl.endRefreshing()
        }
    }
    
    func getPositions() {
        RCLocalAPIManager.shared.getPositions(success: { [weak self] hash in
            guard let weakSelf = self else { return }
            UIApplication.shared.keyWindow?.makeToast("Vehicles updated".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.dismiss(animated: true, completion: nil)
            weakSelf.refreshControl.endRefreshing()
            self?.updateVehicleList()
            
            DispatchQueue.main.async {
                self?.refreshGoogleAddress()
            }
            
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            UIApplication.shared.keyWindow?.makeToast("Unable to fetch vehicles data due to poor internet connectivity".toLocalize, duration: 2.0, position: .bottom)
            weakSelf.dismiss(animated: true, completion: nil)
            weakSelf.refreshControl.endRefreshing()
        }
    }
    public func refreshGoogleAddress() {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        let allDevices = RCGlobals.getExpiryFilteredList(data)
        for i in allDevices {
            let keyValue = "Position_" + "\(i.id ?? 0)"
            if let  devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue)) {
                if let devLat = devicePosition.latitude, let devLng = devicePosition.longitude {
                    devPosCoordinateDic["\(devLat)\(devLng)"] = keyValue
                    updateGoogleAddress(devicePosition: devicePosition, keyValue: keyValue)
                }
            }
        }
    }
    
    public func updateGoogleAddress(devicePosition: TrackerPositionMapperModel, keyValue: String) {
        if let devLat = devicePosition.latitude, let devLng = devicePosition.longitude {
            let cordinate = CLLocationCoordinate2D(latitude: devLat, longitude: devLng)
            GMSGeocoder().reverseGeocodeCoordinate(cordinate) { (response, error) in
                guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else { return}
                let tempAddress = lines.joined(separator: " ")
                if let  tempDevPos = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue)) {
                    tempDevPos.address = tempAddress
                    //#sani
                    Defaults().set(tempDevPos, for: Key<TrackerPositionMapperModel>(keyValue))
                    vehicleListView.vehicleTable.reloadData()
                }
            }
        }
    }
    
    @objc func viewAllTapped() {
        let selectedState = Defaults().get(for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue)) ?? vehicleSelectedState.all.rawValue
        var selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
        
        if selectedDeviceIdArray.count > 0 || selectedState != vehicleSelectedState.all.rawValue {
            Defaults().set(true, for: Key<Bool>(defaultKeyNames.shouldClearMap.rawValue))
            Defaults().set(vehicleSelectedState.all.rawValue, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
            updateVehicleList()
            selectedDeviceIdArray.removeAll()
            Defaults().set(selectedDeviceIdArray, for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue))
            Defaults().set(false, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
            delegate?.viewAllVehiclesTapped()
        }
        
//        let tabBarController: UITabBarController = (vehicleListView.window?.rootViewController as? UITabBarController)!
//        tabBarController.selectedIndex = 0
    }
    
    @objc func ignitionOnTapped(_ sender: UITapGestureRecognizer) {
        handleStateType(vehicleType: vehicleSelectedState.ignitionOn.rawValue)
    }
    
    @objc func ignitionOffTapped(_ sender: UITapGestureRecognizer) {
        handleStateType(vehicleType: vehicleSelectedState.ignitionOff.rawValue)
    }
    
    @objc func inactiveTapped(_ sender: UITapGestureRecognizer) {
        handleStateType(vehicleType: vehicleSelectedState.inactive.rawValue)
    }
    
    @objc func offlineTapped(_ sender: UITapGestureRecognizer) {
        handleStateType(vehicleType: vehicleSelectedState.offline.rawValue)
    }
    
    func handleStateType(vehicleType: Int) {
        let selectedState = Defaults().get(for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue)) ?? vehicleSelectedState.all.rawValue
        var selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
        if  selectedDeviceIdArray.count > 0 || selectedState != vehicleType {
            selectedDeviceIdArray.removeAll()
            Defaults().set(selectedDeviceIdArray, for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue))
            Defaults().set(false, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
            Defaults().set(true, for: Key<Bool>(defaultKeyNames.shouldClearMap.rawValue))
            Defaults().set(vehicleType, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
            updateVehicleList()
        }
        if deviceList.count == 1 {
            var idArray:[Int] = []
            idArray.append(deviceList[0].id ?? 0)
            delegate?.selectedVehiclesTapped(deviceIds: idArray)
        } else {
            delegate?.specificVehicleTypeTapped(vehicleType: vehicleType)
        }
//        if let tabBarController: UITabBarController = (vehicleListView.window?.rootViewController as? UITabBarController) {
//            tabBarController.selectedIndex = 0
//        }
    }
    
    func updateVehicleList () {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        deviceList = RCGlobals.getExpiryFilteredList(data)
        
        branchId = Defaults().get(for: Key<String>(defaultKeyNames.selectedBranch.rawValue)) ?? "0"
        
        if branchId != "0" {
            // MARK: Handling for branch selection.
            let deviceIdList = RCGlobals.getDeviceIdListForBranch(branchId: branchId)
            
            let branchName:String = Defaults().get(for: Key<String>(defaultKeyNames.selectedBranchName.rawValue)) ?? "User"
            
            vehicleListView.listLbl.text = branchName
            
            deviceList = deviceList.filter{( deviceIdList.contains($0.id) )}
            
        } else {
            vehicleListView.listLbl.text = "User"
        }
        
        updateDevicesStateCount()
        
        deviceList = filterListStateWise()
        
        let searchText:String = vehicleListView.searchBar.text ?? ""
        
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        deviceList = searchFilterList(trimmed)
        
        let vehicleSortingLabel = Defaults().get(for: Key<String>(defaultKeyNames.vehicleListSortLabel.rawValue)) ?? "Default"
        
        switch vehicleSortingLabel {
        case "Last Update":
            deviceList.sort(by: { ($0.lastUpdate?.lowercased() ?? "") as String > ($1.lastUpdate?.lowercased() ?? "") as String })
        case "Name":
            deviceList.sort(by: { ($1.name?.lowercased() ?? "") as String > ($0.name?.lowercased() ?? "") as String })
        default:
            deviceList.sort(by: { $0.positionId > $1.positionId })
        }
        
        handleStateIndicatorViews()
        
        vehicleListView.vehicleTable.reloadData()
    }
    
    func updateDevicesStateCount() {
        var ignitonOnCount:Int  = 0
        var ignitonOffCount:Int  = 0
        var inactiveCount:Int  = 0
        var offlineCount:Int  = 0
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        var allDevices = RCGlobals.getExpiryFilteredList(data)
        
        branchId = Defaults().get(for: Key<String>(defaultKeyNames.selectedBranch.rawValue)) ?? "0"
        
        if branchId != "0" {
            // MARK: Handling for branch selection.
            let deviceIdList = RCGlobals.getDeviceIdListForBranch(branchId: branchId)
                                    
            allDevices = allDevices.filter{( deviceIdList.contains($0.id) )}
            
        }
        
        for device in allDevices {

            let keyValueDevice: String = "Device_\(device.id ?? 0)"
            
            let item:TrackerDevicesMapperModel = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValueDevice))!
            if item.lastUpdate == nil ||
                Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) >= 86400 {
                offlineCount += 1
            } else {
                if Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) < 86400 {
                    inactiveCount += 1
                } else {
                    let keyValue = "Position_" + "\(item.id ?? 0)"
                    let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                    let ignition = devicePosition?.attributes?.ignition ?? false
                    
                    if ignition == false {
                        ignitonOffCount += 1
                    } else {
                        ignitonOnCount += 1
                    }
                }
            }
        }
        let totalCount = ignitonOnCount + ignitonOffCount + inactiveCount + offlineCount
        
        vehicleListView.ignitionOnLabel.text = "\(ignitonOnCount)"
        vehicleListView.ignitionOffLabel.text = "\(ignitonOffCount)"
        vehicleListView.inactiveLabel.text = "\(inactiveCount)"
        vehicleListView.offlineLabel.text = "\(offlineCount)"
        vehicleListView.viewAllBtn.setTitle(" VIEW ALL VEHICLES (\(totalCount)) ", for: .normal)
    }
    
    func filterListStateWise() -> [TrackerDevicesMapperModel] {
        let selectedState = Defaults().get(for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue)) ?? vehicleSelectedState.all.rawValue
        if selectedState == vehicleSelectedState.all.rawValue {
            return deviceList
        }
        var updatedList:[TrackerDevicesMapperModel] = []
        for item in deviceList {
            if selectedState == vehicleSelectedState.ignitionOn.rawValue {
                let keyValue = "Position_" + "\(item.id ?? 0)"
                let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                if let ignition = devicePosition?.attributes?.ignition  {
                    if item.lastUpdate != nil &&
                        Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) < 600 && ignition == true {
                        updatedList.append(item)
                    }
                }
            } else if selectedState == vehicleSelectedState.ignitionOff.rawValue {
                let keyValue = "Position_" + "\(item.id ?? 0)"
                let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                if let ignition = devicePosition?.attributes?.ignition  {
                    if item.lastUpdate != nil &&
                        Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) < 600 && ignition == false {
                        updatedList.append(item)
                    }
                }
            } else if selectedState == vehicleSelectedState.inactive.rawValue {
                if item.lastUpdate != nil &&
                    Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) < 86400 {
                    updatedList.append(item)
                }
            } else if selectedState == vehicleSelectedState.offline.rawValue {
                if item.lastUpdate == nil ||
                    Date().timeIntervalSince(RCGlobals.getDateFor(item.lastUpdate!)) >= 86400 {
                    updatedList.append(item)
                }
            }
        }
        
        return updatedList
    }
    
    func searchFilterList(_ searchText : String) -> [TrackerDevicesMapperModel] {
        if searchText.isEmpty {
            return deviceList
        }
        var updatedList:[TrackerDevicesMapperModel] = []
        for item in deviceList {
            if item.name?.lowercased().contains(searchText.lowercased()) ?? false {
                updatedList.append(item)
            }
        }
        return updatedList
    }
    
    func handleStateIndicatorViews() {
        let selectedState = Defaults().get(for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue)) ?? vehicleSelectedState.all.rawValue
        switch selectedState {
        case vehicleSelectedState.ignitionOn.rawValue:
            vehicleListView.ignitionOnView.alpha = 1.0
            vehicleListView.ignitionOffView.alpha = 0.6
            vehicleListView.inactiveView.alpha = 0.6
            vehicleListView.offlineView.alpha = 0.6
            break
        case vehicleSelectedState.ignitionOff.rawValue:
            vehicleListView.ignitionOnView.alpha = 0.6
            vehicleListView.ignitionOffView.alpha = 1.0
            vehicleListView.inactiveView.alpha = 0.6
            vehicleListView.offlineView.alpha = 0.6
            break
        case vehicleSelectedState.inactive.rawValue:
            vehicleListView.ignitionOnView.alpha = 0.6
            vehicleListView.ignitionOffView.alpha = 0.6
            vehicleListView.inactiveView.alpha = 1.0
            vehicleListView.offlineView.alpha = 0.6
            break
        case vehicleSelectedState.offline.rawValue:
            vehicleListView.ignitionOnView.alpha = 0.6
            vehicleListView.ignitionOffView.alpha = 0.6
            vehicleListView.inactiveView.alpha = 0.6
            vehicleListView.offlineView.alpha = 1.0
            break
        default:
            vehicleListView.ignitionOnView.alpha = 1.0
            vehicleListView.ignitionOffView.alpha = 1.0
            vehicleListView.inactiveView.alpha = 1.0
            vehicleListView.offlineView.alpha = 1.0
            break
        }
    }
    
    func getGeofencaNameContainingLocation(_ deviceLocation: CLLocation)  -> String? {
        
        let geofencesList:[GeofenceModel] = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults")) ?? []
        
        var nameOfGeofence = ""
        
        for geofenceToShow in geofencesList {
            
            if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let gmsPath = GMSMutablePath()
                for i in 0...(coordinates.count - 1) {
                    var pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
                    let number = i % 2
                    if number == 0 {
                        pointLocation.latitude = Double(coordinates[i]) ?? 0
                    } else {
                        pointLocation.longitude = Double(coordinates[i]) ?? 0
                    }
                    gmsPath.add(pointLocation)
                }
                
                let deviceCoordinate = deviceLocation.coordinate
                
                if GMSGeometryContainsLocation(deviceCoordinate, gmsPath, true) {
                    nameOfGeofence = geofenceToShow.name 
                }
            } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
                
                let radius = Double(coordinates[2])!
                let center = locations
                
                let distanceFromCenter = deviceLocation.distance(from: center)
                
                if distanceFromCenter < radius {
                    
                    nameOfGeofence = geofenceToShow.name 
                    // inside
                }
                
            } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let gmsPath = GMSMutablePath()
                for i in 0...(coordinates.count - 1) {
                    var pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
                    let number = i % 2
                    if number == 0 {
                        pointLocation.latitude = Double(coordinates[i]) ?? 0
                    } else {
                        pointLocation.longitude = Double(coordinates[i]) ?? 0
                    }
                    gmsPath.add(pointLocation)
                }
                
                let deviceCoordinate = deviceLocation.coordinate
                
                if GMSGeometryIsLocationOnPathTolerance(deviceCoordinate, gmsPath, true, 25) {
                    nameOfGeofence = geofenceToShow.name 
                }
            }
            if !nameOfGeofence.isEmpty {
                break
            }
        }
        
        return nameOfGeofence
        
    }
    
    func getIgnitionTime() {
        let tempId =  Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel"))?.id ?? 0
        var id: Int?
        let expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as? [String] ?? [String]()
        
        if !expiredIdArray.contains(String(tempId)) {
            id = tempId
        }
        
        if id != nil {
            RCLocalAPIManager.shared.lastActivationTime(with:id!, loadingMsg: "",success: { [weak self] hash in
                guard let weakSelf = self else {
                    return
                }
                // weakSelf.lastUpdateModel =
                var dataIn: [LastActivationTimeData] = []
                let data = Defaults().get(
                    for: Key<LastActivationTimeModel>("LastActivationTimeModel"))?.data
                for i in data! {
                    if !expiredIdArray.contains(String(i.deviceId!)) {
                        dataIn.append(i)
                    }
                }
                
                weakSelf.lastUpdateModel = dataIn
                
                
                vehicleListView.vehicleTable.reloadData()
            }) { [weak self] message in
                guard let _ = self else {
                    return
                }
                //                weakSelf.prompt(message)
                UIApplication.shared.keyWindow?.makeToast(message, duration: 3.0, position: .bottom)
            }
        }
    }
    
    func getDeviceIgnitionTime(devicePosition: TrackerPositionMapperModel) -> String {
        var ignitionTime:String = "N/A"
        if let ignition = devicePosition.attributes?.ignition  {
            if lastUpdateModel != nil {
                for i in lastUpdateModel!{
                    if let deviceId = devicePosition.deviceId {
                        if i.deviceId == String(deviceId)  && i.type == (ignition ? "ignitionOn" : "ignitionOff") {
                            if let ignitionTimeTemp = i.ignitionTime {
                                ignitionTime = RCGlobals.newtimeSinceDate( RCGlobals.getDefaultUTCDate(ignitionTimeTemp) )
                            }
                            break
                        }
                    }
                }
            }
        }
        return ignitionTime
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: vehicleListView.vehicleTable)
            if let indexPath = vehicleListView.vehicleTable.indexPathForRow(at: touchPoint) {
                isMultipleSelectEnabled = true
                Defaults().set(true, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
                let deviceIdSelected: Int = deviceList[indexPath.row].id ?? 0
                Defaults().set(true, for: Key<Bool>(defaultKeyNames.shouldClearMap.rawValue))
                var selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
                if selectedDeviceIdArray.contains(deviceIdSelected) {
                    selectedDeviceIdArray.removeObject(obj: deviceIdSelected)
                    if let cell = vehicleListView.vehicleTable.cellForRow(at: indexPath) as? VehicleListTableViewCell {
                        cell.containerView.backgroundColor = .white
                    }
                } else {
                    selectedDeviceIdArray.append(deviceIdSelected)
                    if let cell = vehicleListView.vehicleTable.cellForRow(at: indexPath) as? VehicleListTableViewCell {
                        cell.containerView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
                    }
                }
                if selectedDeviceIdArray.count > 0 {
                    Defaults().set(true, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
                } else {
                    isMultipleSelectEnabled = false
                    Defaults().set(false, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
                }
                Defaults().set(selectedDeviceIdArray, for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue))
                
            }
        }
    }
    
}
extension VehicleViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.vehicleListTable.rawValue, for: indexPath) as! VehicleListTableViewCell
        cell.selectionStyle = .none
        
        let keyValueDevice: String = "Device_\(deviceList[indexPath.row].id ?? 0)"
        
        let device:TrackerDevicesMapperModel = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValueDevice))!
        
        let selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
        
        if isMultipleSelectEnabled {
            if selectedDeviceIdArray.contains(device.id) {
                cell.containerView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
            } else {
                cell.containerView.backgroundColor = .white
            }
        } else {
            cell.containerView.backgroundColor = .white
        }
        
        cell.vehicleNameLabel.text = device.name
        
        if(device.lastUpdate == nil ) {
            cell.lastUpdateTitle.text = "Last Updated: ".toLocalize + "N/A"
        } else {
            let lastUpdated = RCGlobals.newtimeSinceDateWithoutSecond( RCGlobals.getDateFor((device.lastUpdate!)) )
            cell.lastUpdateTitle.text = "Last Updated: ".toLocalize + lastUpdated
        }
        
        cell.markerIgnitionTimeLbl.text = "N/A"
        
        cell.gpsImg.image = #imageLiteral(resourceName: "Layer 2-2")
        
        if (device.status ?? "offline") != "online" {
            cell.networkImg.image = #imageLiteral(resourceName: "netoff")
        } else {
            cell.networkImg.image = #imageLiteral(resourceName: "neton")
        }
        
        cell.odoTitle.text = "ODOM: N/A"
        cell.totalDistTitle.text = "TOTAL DIST: N/A"
        
        cell.addressLabel.text = "N/A"
        
        cell.markerImg.image = RCMarker.getDeviceIcon(device: device)
        
        let keyValue = "Position_" + "\(device.id ?? 0)"
        let devPos = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
        if let devicePosition = devPos {
            
            cell.markerIgnitionTimeLbl.text = getDeviceIgnitionTime(devicePosition: devicePosition)
            
            let coords : CLLocation = CLLocation(latitude: devicePosition.latitude ?? 0.0 , longitude: devicePosition.longitude ?? 0.0)

            let pointOfInterestLocation: String = getGeofencaNameContainingLocation(coords) ?? ""
        
            if pointOfInterestLocation == "" {
                cell.addressLabel.text = devicePosition.address ?? "N/A"
            } else {
                cell.addressLabel.text = pointOfInterestLocation
            }
            
            let isValidGPS:Bool = devicePosition.valid ?? false
            
            if isValidGPS == true && RCGlobals.isGPSFixValid(device: device, position: devicePosition) {
                cell.gpsImg.image = #imageLiteral(resourceName: "gpsIcon")
            }
            
            let speedKnots = devicePosition.speed ?? 0
            
            let speed = roundf(speedKnots * 1.852)
            
            if let ignition  = devicePosition.attributes?.ignition {
                if ignition{
                    cell.currSpeedTitle.text = "CURR. SPD: \(speed)KMPH"
                }else {
                    cell.currSpeedTitle.text = "CURR. SPD: 0KMPH"
                }
                
            }else {
                cell.currSpeedTitle.text = "CURR. SPD: 0KMPH"
            }
            
            let totalDistance:Double = (devicePosition.attributes?.totalDistance ?? 0) / 1000
            
//            if totalDistance > 1000 {
//                cell.odoTitle.text = "ODOM: \((totalDistance / 1000).rounded(toPlaces: 1))K km"
//            } else {
                cell.odoTitle.text = "ODOM: \(String(format: "%.0f", totalDistance)) km"
//            }
            
            var currentDistance:String = "N/A"
            
            if let prevOdo = device.attributes?.prevOdometer {
                let odometer:Double = Double(prevOdo / 1000)
                let distanceCalculated = totalDistance - odometer
                
                if distanceCalculated > 0 {
                    currentDistance = "\(distanceCalculated.rounded(toPlaces: 1)) km"
                } else {
                    currentDistance = "0 km"
                }
                
            }
            
            cell.totalDistTitle.text = "TOTAL DIST: \(currentDistance)"
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deviceIdSelected: Int = deviceList[indexPath.row].id ?? 0
        Defaults().set(true, for: Key<Bool>("should_clear_map"))
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !isMultipleSelectEnabled {
            var selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
            selectedDeviceIdArray.removeAll()
            selectedDeviceIdArray.append(deviceIdSelected)
            Defaults().set(false, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
            Defaults().set(selectedDeviceIdArray, for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue))
            delegate?.selectedVehiclesTapped(deviceIds: selectedDeviceIdArray)
            if let tabBarController: UITabBarController = (vehicleListView.window?.rootViewController as? UITabBarController) {
                tabBarController.selectedIndex = 0
            }
        } else {
            var selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
            if selectedDeviceIdArray.contains(deviceIdSelected) {
                selectedDeviceIdArray.removeObject(obj: deviceIdSelected)
                if let cell = vehicleListView.vehicleTable.cellForRow(at: indexPath) as? VehicleListTableViewCell  {
                    cell.containerView.backgroundColor = .white
                }
            } else {
                selectedDeviceIdArray.append(deviceIdSelected)
                if let cell = vehicleListView.vehicleTable.cellForRow(at: indexPath) as? VehicleListTableViewCell  {
                    cell.containerView.backgroundColor = UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0)
                }
            }
            Defaults().set(selectedDeviceIdArray, for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue))
            if selectedDeviceIdArray.count == 0 {
                isMultipleSelectEnabled = false
                Defaults().set(false, for: Key<Bool>(defaultKeyNames.multipleSelectionAllowed.rawValue))
//                delegate?.selectedVehiclesTapped(deviceIds: selectedDeviceIdArray)
//                if let tabBarController: UITabBarController = (vehicleListView.window?.rootViewController as? UITabBarController) {
//                    tabBarController.selectedIndex = 0
//                }
            } else {
                delegate?.multipleSelectedDeviceId(deviceIds: selectedDeviceIdArray)
            }
        }
    }
    
}
extension VehicleViewController: SelectedUserHierarchyDelegate {
    func selectedUser(userId: String?, userName: String?) {
        
        branchId = userId ?? "0"
        
        Defaults().set(branchId, for: Key<String>(defaultKeyNames.selectedBranch.rawValue))
        
        Defaults().set(userName ?? "User", for: Key<String>(defaultKeyNames.selectedBranchName.rawValue))
        
        
//        updateVehicleList()
        
        // MARK: Handling for branch selection.
        
        
        //       selectedUserId = userId
        //       selectedUserName = userName ?? "Users".toLocalize
        //
        //       rowsForTableView()
        //       initList()
        //
        //       addEditView.myTableView.reloadData()
    }
}

extension VehicleViewController: RCSocketManagerPositionDelegate, RCSocketManagerDeviceDelegate {
    func getPosition(value: TrackerPositionMapperModel, expiredorNot: Bool) {
        if isListVisible {
            updateDevicesStateCount()
            vehicleListView.vehicleTable.reloadData()
        }
    }
    
    func getDevices(value: TrackerDevicesMapperModel, expiredorNot: Bool) {
        if isListVisible {
            updateDevicesStateCount()
            vehicleListView.vehicleTable.reloadData()
        }
    }
    
    
}


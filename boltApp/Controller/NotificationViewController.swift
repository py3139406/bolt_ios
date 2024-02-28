//
//  NotificationViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import GoogleMaps
import DefaultsKit

class NotificationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // var expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as! [String] ?? [String]()
    var allFilteredNotifs: [ReportsEventsModelData] = []
    var filteredValidDevices: [TrackerDevicesMapperModel] = [] //contains not expired subscription devices
    var notificationView: NotificationView!
    private let refreshControl = UIRefreshControl()
    lazy var pickerView = UIPickerView()
    var selectedID: Int?
    var isSelectedAnnouncement = false
    var selectedSegmentIndex:Int = 0
    var login_model: loginInfoModel?
    var alarmSetting :[String:String]?
    var type:String?
    var alarm:String?
    var rows: [ReportsEventsModelData] = {
        var data = Defaults().get(for: Key<[ReportsEventsModelData]>("allNotifications")) ?? []
        return data
    }()
    var allDevices: [TrackerDevicesMapperModel]!
    var displayRows: [ReportsEventsModelData] = []
    
    fileprivate func viewsFunctionAndDelegate() {
        notificationView = NotificationView(frame: CGRect.zero)
        view.addSubview(notificationView)
        view.backgroundColor = appDarkTheme
        dataForPicker()
        pickerView.delegate = self
        pickerView.dataSource = self
        notificationView.myTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "notification")
        notificationView.myTableView.dataSource = self
        notificationView.myTableView.delegate = self
        notificationView.filterButton.addTarget(self, action: #selector(openFilter(_:)), for: .touchUpInside)
        notificationView.segmentControl.addTarget(self, action: #selector((segmentTapped)), for: .valueChanged)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Defaults().clear(Key<[String]>("filterSelectedOptions"))
        
        displayRows = rows
        allFilteredNotifs = rows
        viewsFunctionAndDelegate()
        setConstraints()
        showPickerView()
        updateRows()
        checkForAlamrAndType()
        
        setUpRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadThroughFilter(_:)),
                                               name: NSNotification.Name(rawValue: "filter"), object: nil)
    }
    func setConstraints(){
        notificationView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    func checkForAlamrAndType(){
        login_model =   Defaults().get(for: Key<loginInfoModel>("loginInfoModel")) ?? nil
        if login_model != nil {
            if login_model?.data?.user?.alarmSettings != nil{
                alarmSetting = (RCGlobals.convertToDictionary(text: (login_model?.data?.user?.alarmSettings)!) as! [String : String])
                if alarmSetting != nil{
                    type =  alarmSetting!["type"]?.lowercased()
                    alarm = alarmSetting!["alarm"]?.lowercased()
                }
            }
        }
    }
    
    @objc func segmentTapped(sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        //        Defaults().set([], for: Key<[GeofenceModel]>("allUserGeofenceModel"))
        //            allGeofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel"))!
        
        switch sender.selectedSegmentIndex {
        case 0:
            notificationView.myTableView.refreshControl = refreshControl
            reloadNotifications()
            
        case 1:
            notificationView.myTableView.refreshControl = nil
            reloadAnnouncements()
            
        default:
            print("ERROR")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEvents()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        refreshControl.endRefreshing()
    }
    
    @objc func reloadNotifications() {
        
        isSelectedAnnouncement = false
        notificationView.filterButton.isHidden = false
        notificationView.vehicleTextField.isHidden = false
        notificationView.vehicleTextField.isUserInteractionEnabled = true
        
        updateRows()
    }
    
    
    @objc func reloadAnnouncements() {
        
        //if isSelectedAnnouncement == false {
        
        let filterArray = ["promotion"]
        var temprows: [ReportsEventsModelData] = []
        
        filterArray.forEach { (i) in
            temprows += rows.filter( { $0.type == i } )
        }
        
        displayRows = temprows
        displayRows = displayRows.sorted(by: { $0.id > $1.id })
        isSelectedAnnouncement = true
        
        notificationView.filterButton.isHidden = true
        notificationView.vehicleTextField.isUserInteractionEnabled = false
        notificationView.vehicleTextField.isHidden = true
        
        //}
        //    } else {
        //      displayRows = rows
        //      isSelectedAnnouncement = false
        //      notificationView.filterButton.isHidden = false
        //      notificationView.vehicleTextField.isUserInteractionEnabled = true
        //    }
        //
        notificationView.myTableView.reloadData()
        
    }
    
    @objc func reloadThroughFilter(_ notify: NSNotification) {
        
        let filterArray = notify.userInfo?["myArray"] as! [String]
        Defaults().set(filterArray, for: Key<[String]>("filterSelectedOptions"))
        print(filterArray)
        
        updateRows()
    }
    
    func getFilteredNotification(_ filterArray: [String]) -> [ReportsEventsModelData]{
        var temprows: [ReportsEventsModelData] = []
        
        if filterArray.count == 0 {
            return rows
        }
        
        for item in rows {
            switch item.type {
            case "ignitionOn":
                if !filterArray.contains("ignitionOn") {
                    temprows.append(item)
                }
                break
            case "ignitionOff":
                if !filterArray.contains("ignitionOff") {
                    temprows.append(item)
                }
                break
            case "geofenceEnter":
                if !filterArray.contains("geofenceEnter") {
                    temprows.append(item)
                }
                break
            case "geofenceExit":
                if !filterArray.contains("geofenceExit") {
                    temprows.append(item)
                }
                break
            case "deviceOverspeed":
                if !filterArray.contains("overspeed") {
                    temprows.append(item)
                }
                break
            case "alarm":
                let alarmType:String = item.attributes?.alarmType ?? ""
                switch alarmType {
                case "overspeed":
                    if !filterArray.contains("overspeed") {
                        temprows.append(item)
                    }
                    break
                case "powerCut":
                    if !filterArray.contains("powerCut") {
                        temprows.append(item)
                    }
                    break
                case "vibration":
                    if !filterArray.contains("vibration") {
                        temprows.append(item)
                    }
                    break
                case "lowBattery":
                    if !filterArray.contains("lowBattery") {
                        temprows.append(item)
                    }
                    break
                default:
                    if !filterArray.contains("others") {
                        temprows.append(item)
                    }
                }
                break
            default:
                if !filterArray.contains("others") {
                    temprows.append(item)
                }
                break
            }
        }
        
        return temprows
    }
    
    func setUpRefresh() {
        if #available(iOS 10.0, *) {
            notificationView.myTableView.refreshControl = refreshControl
        } else {
            notificationView.myTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
        notificationView.myTableView.refreshControl?.tintColor = .white
    }
    
    func dataForPicker() {
        let expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as? [String] ?? [String]()
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        allDevices = RCGlobals.getExpiryFilteredList(data)
        for i in allDevices {
            if !expiredIdArray.contains(String(i.id)) {
                filteredValidDevices.append(i)
            }
        }
        
    }
    
    @objc private func refreshAction(_ sender: Any) {
//        RCLocalAPIManager.shared.getNotifications(success: { [weak self] hash in
//            guard let weakSelf = self else { return }
//            UIApplication.shared.keyWindow?.makeToast("Notifications updated".toLocalize, duration: 2.0, position: .bottom)
//            weakSelf.dismiss(animated: true, completion: nil)
//            weakSelf.refreshControl.endRefreshing()
//            weakSelf.updateRows()
//        }) { [weak self] message in
//            guard let weakSelf = self else { return }
//            UIApplication.shared.keyWindow?.makeToast("Unable to fetch Notifications due to poor internet connectivity".toLocalize,duration: 2.0, position: .bottom)
//            weakSelf.dismiss(animated: true, completion: nil)
//            weakSelf.refreshControl.endRefreshing()
//        }
        
        getEvents()
    }
    
    @objc fileprivate func openFilter(_ sender: UIButton) {
        let filter = FilterController()
        filter.view.backgroundColor = .clear
        filter.modalPresentationStyle = .custom
        self.present(filter, animated: true, completion: nil)
    }
    
    func updateRows() {
        
        if selectedID == nil {
            rows = Defaults().get(for: Key<[ReportsEventsModelData]>("allNotifications")) ?? []
        } else {
            rows = Defaults().get(for: Key<[ReportsEventsModelData]>("allNotifications")) ?? []
            rows = rows.filter( { $0.deviceId == selectedID } )
        }
        if rows.count  > 1 {
          //  rows.sort(by: { $0.id > $1.id })
        }
        
        if let arraySelections = Defaults().get(for: Key<[String]>("filterSelectedOptions")) {
            displayRows = getFilteredNotification(arraySelections)
          //  displayRows = displayRows.sorted(by: { $0.id > $1.id })
        } else {
            displayRows = rows
        }
        
        
        
        notificationView.myTableView.reloadData()
    }
    
    func getEvents() {
        RCLocalAPIManager.shared.pyNotificationsGet(success: { [weak self] hash in
            guard let weakSelf = self else { return }
            weakSelf.refreshControl.endRefreshing()
            weakSelf.updateRows()
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.refreshControl.endRefreshing()
          //  weakSelf.prompt(message)
            print("\(message)")
           
        }
    }
    
    private func showPickerView() {
        
        //Mark: ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerView))
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let allVehicle = UIBarButtonItem(title: "All vehicles", style: .plain, target: self, action: #selector(selectAllfunction))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPickerView))
        
        toolbar.setItems([cancelButton, spaceButton1, allVehicle, spaceButton2,doneButton ], animated: true)
        
        notificationView.vehicleTextField.inputAccessoryView = toolbar
        notificationView.vehicleTextField.inputView = pickerView
        
    }
    
    
    @objc func donePickerView() {
        selectedID = filteredValidDevices[pickerView.selectedRow(inComponent: 0)].id
        if notificationView.vehicleTextField.isEditing {
            notificationView.vehicleTextField.text = filteredValidDevices[pickerView.selectedRow(inComponent: 0)].name
        }
        updateRows()
        self.view.endEditing(true)
    }
    
    @objc func selectAllfunction() {
        if notificationView.vehicleTextField.isEditing {
            notificationView.vehicleTextField.text = "All vehicles"
        }
        selectedID = nil
        updateRows()
        self.view.endEditing(true)
    }
    
    
    @objc func cancelPickerView() {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredValidDevices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredValidDevices[row].name
    }
    
}
extension NotificationViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        notificationView.customCell = tableView.dequeueReusableCell(withIdentifier: "notification",
                                                                    for: indexPath) as? NotificationTableViewCell
        
        notificationView.customCell.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 56/255, alpha: 1)
        
        let lastUpdated = ""
        if let tempServerTime = displayRows[indexPath.row].fixtime {
            let date = Date(timeIntervalSince1970: TimeInterval(tempServerTime/1000))
            let dateString = RCGlobals.convertDateToString(date: date, format: "dd-MM-yyyy", toUTC: false)
            let time = RCGlobals.convertDateToString(date: date, format: "hh:mm a", toUTC: false)
            notificationView.customCell.timeLabel.text = "\(dateString)\n\(time)"
        }
        let keyValue = "Device_" + "\(displayRows[indexPath.row].deviceId ?? 0)"
        let device = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        self.notificationView.customCell.addressPlace.text = " "
        if let latitude = displayRows[indexPath.row].latitude, let longitude = displayRows[indexPath.row].longitude {
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            if let serverAddress = self.displayRows[indexPath.row].address {
                self.notificationView.customCell.addressPlace.text = serverAddress
            } else {
                self.notificationView.customCell.addressPlace.text = " "
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
                    if self.displayRows.count == 0 {
                        return
                    }
                    if error != nil {
                        return
                    }
                    guard let address = response?.firstResult(), let lines = address.lines else { return }
                    
                    self.notificationView.customCell.addressPlace.text = lines.joined(separator: " ").toLocalize
                    
                    self.displayRows[indexPath.row].address = lines.joined(separator: " ")
                }
            }
            
        }
        
        switch displayRows[indexPath.row].type! {
            
        case "promotion":
            notificationView.customCell.label.text = "Last command for ".toLocalize + (device?.name ?? "vehicle".toLocalize)
                + " was sucessfully sent".toLocalize + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "settingNotification")
            break
            
        case "commandResult":
            notificationView.customCell.label.text = "Last command for ".toLocalize + (device?.name ?? "vehicle".toLocalize)
                + " was sucessfully sent".toLocalize + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "settingNotification")
            break
            
        case "ignitionOff":
            notificationView.customCell.label.text = "Ignition off alert ".toLocalize  + "for ".toLocalize
                + (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "removeicon")
            break
            
        case "ignitionOn":
            notificationView.customCell.label.text = "Ignition on alert ".toLocalize + "for ".toLocalize
                + (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
            break
            
        case "geofenceExit":
            notificationView.customCell.label.text = (device?.name ?? "vehicle".toLocalize) + " has exit geofence ".toLocalize
                + "(\(displayRows[indexPath.row].geofencename ?? ""))" +   "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "geofenceicon")
            break
            
        case "geofenceEnter":
            notificationView.customCell.label.text = (device?.name ?? "vehicle".toLocalize) + " has entered geofence ".toLocalize
                + "(\(displayRows[indexPath.row].geofencename ?? ""))" +  "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "geofenceicon")
            break
            
        case "deviceStopped":
            notificationView.customCell.label.text = "Device stopped alert ".toLocalize + "for ".toLocalize
                + (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "removeicon")
            break
            
        case "deviceMoving":
            notificationView.customCell.label.text = "Device moving alert ".toLocalize + "for ".toLocalize
                + (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
            break
            
        case "deviceOnline":
            notificationView.customCell.label.text = "Device online alert ".toLocalize + "for ".toLocalize
                +  (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
            break
            
            
        case "deviceOffline":
            notificationView.customCell.label.text = "Device offline alert ".toLocalize + "for ".toLocalize +
                (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "removeicon")
            break
            
        case "deviceUnknown":
            notificationView.customCell.label.text = "Device unknown alert ".toLocalize + "for ".toLocalize +
                (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
            break
            
        case "powerCut":
            notificationView.customCell.label.text = "Powercut Alarm ".toLocalize + "for ".toLocalize +
                (device?.name ?? "vehicle".toLocalize) + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "powercut")
            break
            
        case "deviceOverspeed":
            let knots:Double = displayRows[indexPath.row].attributes?.speed ?? 0
            let speed:Double = (knots * 1.852).rounded(toPlaces: 1)
            notificationView.customCell.label.text = "Overspeed alert ( \(speed) kmph ) generated for " +
                (device?.name ?? "vehicle".toLocalize) + "\n\(lastUpdated)"
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "overspeed")
            break
            
        case "alarm":
            var tempType = (displayRows[indexPath.row].attributes?.alarmType ?? "Alert".toLocalize).firstUppercased
            notificationView.customCell.label.text = "\(tempType.toLocalize)" + " alert for ".toLocalize +
                (device?.name ?? "vehicle".toLocalize) + "\n\(lastUpdated)"
            
            switch displayRows[indexPath.row].attributes?.alarmType {
            case "overspeed"?:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "overspeed")
                break
            case "vibration"?:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "vibration")
                break
            case "lowBattery"?:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "lowbattery")
                break
            case "powerCut"?:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "powercut")
                break
            case "powerOn"?:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
                if alarmSetting != nil && type != nil {
                    if type == "ac"{
                        tempType = "AC on"
                        notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "ac_on")
                    }else if type == "door"{
                        tempType = "Door open"
                        notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "door_on")
                    }else if type == "siren"{
                        tempType = "Siren on"
                        notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "siren_on")
                    }
                }
                notificationView.customCell.label.text = "\(tempType.toLocalize)" + " alert for ".toLocalize +
                    (device?.name ?? "vehicle".toLocalize) + "\n\(lastUpdated)"
                break
            case "powerOff"?:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "removeicon")
                if alarmSetting != nil && type != nil {
                    if type == "ac"{
                        tempType = "AC off"
                        notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "ac_off")
                    }else if type == "door"{
                        tempType = "Door closed"
                        notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "door_off")
                    }else if type == "siren"{
                        tempType = "Siren off"
                        notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "siren_off")
                    }
                }
                notificationView.customCell.label.text = "\(tempType.toLocalize)" + " alert for ".toLocalize +
                    (device?.name ?? "vehicle".toLocalize) + "\n\(lastUpdated)"
                break
            default:
                notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
                break
            }
            
            break
            
        default:
//            let msg:String = "(\(displayRows[indexPath.row].type ?? "power".toLocalize))"
//            notificationView.customCell.label.text =  msg + " alert ".toLocalize + "for ".toLocalize + (device?.name) ?? "vehicle".toLocalize + "\n" + lastUpdated
            notificationView.customCell.iconImage.image = #imageLiteral(resourceName: "greenNotification")
            break
            
        }
        return notificationView.customCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row  == displayRows.count - 1 {
//            print("now at bottom you can DO STUFF")
//
//            tableView.addLoading(indexPath) {
//                UIView.animate(withDuration: 2) {
//                    let lastNotiId:String = "\(self.displayRows.last?.id ?? 0)"
//                    self.fetchOlderNotifications(lastNotiId: lastNotiId)
//                }
//               tableView.stopLoading()
//            }
//        }
    }
    
    func fetchOlderNotifications(lastNotiId: String) {
        RCLocalAPIManager.shared.getOlderNotifications(lastNotiId:lastNotiId, success: { [weak self] hash in
            guard let weakSelf = self else { return }
            weakSelf.updateRows()
        }) { message in
            print("older notification request failed: \(message)")
            
        }
    }
    
}

extension String {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
extension UITableView{

    func indicatorView() -> UIActivityIndicatorView{
        var activityIndicatorView = UIActivityIndicatorView()
        if self.tableFooterView == nil{
            let indicatorFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: 40)
            activityIndicatorView = UIActivityIndicatorView(frame: indicatorFrame)
            activityIndicatorView.isHidden = false
            activityIndicatorView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            activityIndicatorView.isHidden = true
            self.tableFooterView = activityIndicatorView
            return activityIndicatorView
        }else{
            return activityIndicatorView
        }
    }

    func addLoading(_ indexPath:IndexPath, closure: @escaping (() -> Void)){
        indicatorView().startAnimating()
        if let lastVisibleIndexPath = self.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath && indexPath.row == self.numberOfRows(inSection: 0) - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    closure()
                }
            }
        }
        indicatorView().isHidden = false
    }

    func stopLoading(){
        indicatorView().stopAnimating()
        indicatorView().isHidden = true
    }
}

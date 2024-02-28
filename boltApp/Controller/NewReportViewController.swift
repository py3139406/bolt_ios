//
//  NewReportViewController.swift
//  Bolt
//
//  Created by Roadcast on 19/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import CVCalendar
import DefaultsKit
import GoogleMaps
import Firebase
import KeychainAccess

class NewReportViewController: UIViewController {
    var reportView:NewReportView!
    var totalDevices: [TrackerDevicesMapperModel] = []
    var pickerView = UIPickerView()
    var summaryReportArray: [SummaryReportModelData] = []
    var tripsReportArray: [TripsReportModelData] = []
    var stopsReportArray: [StopsReportModelData] = []
    var kmsReportArray: [ParticularDistanceReportModel] = []
    var reachabilitReportArray : [ReachabilityReportModelData] = []
    var secondDate: String = ""
    var currentorStartDate: String = ""
    var apiStartDate: String = ""
    var apiEndDate: String = ""
    var isRangeselected = false
    var selectedDeviceId: Int = 0
    var selectedReportType:String!
    var screenHeight = UIScreen.main.bounds.height
    var scrollViewContentHeight:CGFloat!
    var isAllSelected:Bool = false
    var searchedReportType:String!
    let toolbar = UIToolbar()
    var pickerHeight:CGFloat = 200
    var toolbarHeight:CGFloat = 50
    var isPickerOpen:Bool = false
    // Marker
    
    var markerList:[MarkerFirebaseModel] = []
    
    var second = 3
    var timer: Timer!
    
    var markerRef : DatabaseReference!
    
    var deviceIdArray : [String]! = []
    
    var dateArray : [String]! = []
    
    var kmDateArray : [String]! = []
    
    var dateCounter : Int = 0
    
    var deviceCounter : Int = 0
    
    var isSelectAll : Bool = false
    
    var HUD: MBProgressHUD?
    
    var imageDownloadCounter: Int  = 0
    
    var markerDownloadCounter: Int = 0
    
    var downloadFailCounter: Int = 0
    
    //DATE Picker
    var isDateRange:Bool = false
    var selectedDateFrom:Date = Date()
    var selectedDateTo:Date = Date()
    var datePpicker : UIDatePicker!
    var toolBbar = UIToolbar()
    var fromDateString:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFunction()
        setViews()
        setConstraints()
        setActions()
        self.selectedReportType = SelectedReportType.trips.rawValue
        reportView.newReportTableView.allowsSelection = true
        initialSelectedVehicle()
        Auth.auth().signInAnonymously { (user, error) in
        }
    }
    func initialSelectedVehicle(){
        
        if totalDevices.count > 0 {
            if selectedDeviceId == 0 {
                selectedDeviceId = totalDevices[0].id
                self.reportView.selectVehicleLabel.text = totalDevices[0].name
                isAllSelected = false
            } else {
                let device = totalDevices.filter({ $0.id == selectedDeviceId}).first
                
                reportView.selectVehicleLabel.text = device?.name
                reportView.selectVehicleLabel.alpha = 1.0
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        gettingTotalDevices()
        updateVehicleList()
    }
    func updateVehicleList () {
        let   branchId = Defaults().get(for: Key<String>(defaultKeyNames.branchForReport.rawValue)) ?? "0"
        if branchId != "0" {
            // MARK: Handling for branch selection.
            let deviceIdList = RCGlobals.getDeviceIdListForBranch(branchId: branchId)
            let branchName:String = Defaults().get(for: Key<String>(defaultKeyNames.branchNameForReport.rawValue)) ?? "User"
            reportView.userSelection.text = branchName
            totalDevices = totalDevices.filter{( deviceIdList.contains($0.id) )}
        } else {
            reportView.userSelection.text = "USERS"
        }
    }
    func getDeviceMarkersForDate(date:String,deviceId:String){
        
        markerRef = Database.database().reference().child("Bolt/Markers").child(deviceId).child(date)
        
        markerRef.observe(.childAdded, with: { [] (snapshot) in
            if let response = snapshot.value as? [String : AnyObject] {
                let markerFirebaseModel:MarkerFirebaseModel = MarkerFirebaseModel()
                markerFirebaseModel.deviceId = deviceId
                markerFirebaseModel.title = response["title"] as? String
                markerFirebaseModel.description = response["description"] as? String
                markerFirebaseModel.timestamp = response["timestamp"] as? String
                markerFirebaseModel.userLat = response["userLat"] as? Double
                markerFirebaseModel.userLng = response["userLng"] as? Double
                markerFirebaseModel.deviceLat = response["deviceLat"] as? Double
                markerFirebaseModel.deviceLng = response["deviceLng"] as? Double
                markerFirebaseModel.imagePathList = response["imagePathList"] as? [String]
                self.markerList.append(markerFirebaseModel)
            }
        })
        
        createTimer()
    }
    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        second -= 1
        if second == 0 {
            timer.invalidate()
            markerRef.removeAllObservers()
            if  dateCounter < dateArray.count-1 {
                dateCounter += 1
                second = 3
                getDeviceMarkersForDate(date: dateArray[dateCounter], deviceId: deviceIdArray[deviceCounter])
            } else {
                if  deviceCounter < deviceIdArray.count-1 {
                    deviceCounter += 1
                    second = 3
                    getDeviceMarkersForDate(date: dateArray[dateCounter], deviceId: deviceIdArray[deviceCounter])
                } else {
                    dateCounter = 0
                    deviceCounter = 0
                    second = 3
                    // Update report list here.
                    hideAdditionalInfoProgress()
                    
                    reportView.newReportTableView.reloadData()
                }
            }
        }
    }
    
    @objc func downloadTapped(sender: CustomTapGestureRecognizer) {
        let markers : [MarkerFirebaseModel]  = sender.markersArray
        if  markers.count > 0 {
            handleImageDownloads(indexMarkerList : markers)
        } else {
            self.prompt("There are no markers available to download for this report.")
        }
    }
    
    func handleImageDownloads(indexMarkerList: [MarkerFirebaseModel]) {
        showAdditionalInfoProgress("Downloading images...")
        markerDownloadCounter = 0
        imageDownloadCounter = 0
        downloadMarkerImages(indexMarkerList[self.markerDownloadCounter], indexMarkerList)
    }
    
    func downloadMarkerImages(_ markerFirebaseModel: MarkerFirebaseModel, _ indexMarkerList: [MarkerFirebaseModel]) {
        markerDownloadCounter += 1
        imageDownloadCounter = 0
        downloadImages(markerFirebaseModel.imagePathList![self.imageDownloadCounter], markerFirebaseModel, indexMarkerList)
    }
    
    func downloadImages(_ imageUrl: String, _ markerFirebaseModel: MarkerFirebaseModel, _ indexMarkerList: [MarkerFirebaseModel]) {
        imageDownloadCounter += 1
        let storage = Storage.storage()
        
        let httpsReference = storage.reference(forURL: imageUrl)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let time = NSDate()
        
        let dateTime = RCGlobals.getFormattedDate(date: time, format: "yyyy_MM_ddHH_mm_ss", zone:NSTimeZone.system)
        
        let fileName : String = "\(markerFirebaseModel.deviceId ?? "0")_\(dateTime)_\(imageDownloadCounter)"
        
        let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent("\(fileName).png")
        
        _ = httpsReference.write(toFile: destinationPath) { url, error in
            if error != nil {
                // Uh-oh, an error occurred!
                self.downloadFailCounter += 1
                self.handleRestImages(markerFirebaseModel,indexMarkerList)
            } else {
                // Local file URL for "images/island.jpg" is returned
                self.handleRestImages(markerFirebaseModel, indexMarkerList)
            }
        }
    }
    
    func handleRestImages(_ markerFirebaseModel: MarkerFirebaseModel, _ indexMarkerList: [MarkerFirebaseModel]) {
        if  self.imageDownloadCounter < markerFirebaseModel.imagePathList!.count {
            self.downloadImages(markerFirebaseModel.imagePathList![imageDownloadCounter], markerFirebaseModel, indexMarkerList)
        } else {
            if  self.markerDownloadCounter < indexMarkerList.count {
                downloadMarkerImages(indexMarkerList[markerDownloadCounter], indexMarkerList)
            } else {
                self.hideAdditionalInfoProgress()
                self.imageDownloadCounter = 0
                self.markerDownloadCounter = 0
                if  downloadFailCounter > 0 {
                    self.prompt("Unable to download some images")
                } else {
                    self.prompt("All images downloaded successfully.")
                }
            }
        }
    }
    
    @objc func otherreports(){
        let keychain = Keychain(service: "in.roadcast.bolt")
        let username:String = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email ?? ""
        let password: String = {
            do {
                return try keychain.getString("boltPassword") ?? ""
            } catch {
                return ""
            }
        }()
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        guard let url = URL(string: "https://track.roadcast.co.in/v1/auth/login?url=/app/report&basic=\(base64LoginString)") else { return }
        UIApplication.shared.open(url)
        
    }
    
    func showAdditionalInfoProgress (_ message: String) {
        let topWindow = UIApplication.shared.keyWindow
        HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        HUD?.animationType = .fade
        HUD?.mode = .indeterminate
        HUD?.labelText = message
    }
    
    func hideAdditionalInfoProgress () {
        HUD?.hide(true)
    }
    
    fileprivate func navigationBarFunction() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar-3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        self.navigationItem.title = "Reports"
    }
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    func setActions(){
        reportView.newReportTableView.register(NewReportTableViewCell.self, forCellReuseIdentifier: TableCellIdentifiers.reachibilityReport.rawValue)
        reportView.newReportTableView.register(KilometreTableViewCell.self, forCellReuseIdentifier: TableCellIdentifiers.kmReport.rawValue)
        reportView.newReportTableView.register(DateViewCell.self, forCellReuseIdentifier: TableCellIdentifiers.tripSummaryReport.rawValue)
        reportView.newReportTableView.register(StopsViewCell.self, forCellReuseIdentifier: TableCellIdentifiers.stopReport.rawValue)
        reportView.newReportTableView.delegate = self
        reportView.newReportTableView.dataSource = self
        reportView.selectVehicleLabel.delegate = self
        reportView.selectVehicleLabel.rightView?.isUserInteractionEnabled = false
        
        reportView.dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(datePicker)))
        //        let guesture = UITapGestureRecognizer(target: self, action: #selector(showPickerView))
        //        guesture.numberOfTouchesRequired = 1
        //        reportView.selectVehicleLabel.addGestureRecognizer(guesture)
        reportView.searchBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchButtonTap)))
        reportView.reportTypeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reportTypePicker)))
        
        reportView.userSelection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userSelectionTapped)))
        reportView.userBtn.addTarget(self, action: #selector(userSelectionTapped), for: .touchUpInside)
        reportView.othrBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(otherreports)))
        reportView.othrBtn.addTarget(self, action: #selector(otherreports), for: .touchUpInside)

    }
    
    @objc func userSelectionTapped() {
        let tree = TreeViewController()
        tree.isReportView = true
        self.present(tree, animated: true, completion: nil)
    }
    
    @objc func datePicker(){
        presentAlertWithTitle(title: "Open Calendar", message: "Please select one option",
                              options: "Single Date", "Ranged Date", "Cancel") { (option) in

                                switch(option) {
                                case "Single Date":
                                    self.isDateRange = false
                                    self.doDatePicker()
                                    break
                                case "Ranged Date":
                                    self.isDateRange = true
                                    self.doDatePicker()
                                    break
                                case "Cancel":
                                    break
                                default:
                                    break
                                }
        }
        
        //        let newCalender = CalenderController()
        //
        //
        //            newCalender.callback = {
        //              (beatCount) in
        //              let isRangeSelected = Defaults().get(for: Key<Bool>("rangeDate")) ?? false
        //                 if !isRangeSelected {
        //              self.currentorStartDate  = RCGlobals.getFormattedDataReportVC(date: beatCount![0] as NSDate)
        //              self.secondDate = ""
        //              self.dateArray.removeAll()
        //              self.dateArray.append(RCGlobals.getFormattedDate(date: beatCount![0] as NSDate))
        //            } else {
        //                    self.currentorStartDate  = RCGlobals.getFormattedDataReportVC(date: beatCount![0] as NSDate)
        //                    self.secondDate = RCGlobals.getFormattedDataReportVC(date: beatCount![1] as NSDate)
        //                    self.isRangeselected = true
        //                    self.dateArray.removeAll()
        //
        //                    var startDate = beatCount![0] as Date
        //                    self.dateArray.append(RCGlobals.getFormattedDateWithoutConversion(date: startDate, format: "dd-MM-yyyy"))
        //
        //                    let endDate = beatCount![1] as Date
        //
        //                    let fmt = DateFormatter()
        //                    fmt.dateFormat = "dd/MM/yyyy"
        //
        //                    while startDate < endDate {
        //                        print(fmt.string(from: startDate))
        //                        startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        //                        self.dateArray.append(RCGlobals.getFormattedDateWithoutConversion(date: startDate, format: "dd-MM-yyyy"))
        //                    }
        //                    print(self.dateArray)
        //                  }
        //        }
        //       // newCalender.isRangeSelected = false
        //        newCalender.view.backgroundColor = .clear
        //        newCalender.modalPresentationStyle = .custom
        //        newCalender.dateTextField = reportView.dateLabel
        //        self.present(newCalender, animated: true, completion: nil)
    }
    @objc func searchButtonTap(){
        let dateField = reportView.dateLabel.text
        let vehicleField = reportView.selectVehicleLabel.text
        self.searchedReportType = selectedReportType
        if dateField?.count == 0 {
            self.prompt("Please select Date")
        } else if vehicleField?.count == 0 {
            self.prompt("Please select vehicle")
        } else if selectedReportType?.count == 0 {
            self.prompt("Please select report type")
        } else {
            switch selectedReportType {
            case SelectedReportType.stops.rawValue:
                getStopsReport(devicesID: "\(selectedDeviceId)")
                break
            case SelectedReportType.trips.rawValue:
                deviceIdArray.removeAll()
                deviceIdArray.append("\(selectedDeviceId)")
                getTripsReport(devicesID: "\(selectedDeviceId)")
                break
            case SelectedReportType.summary.rawValue:
                if isAllSelected {
                    let ids = totalDevices.map( { String($0.id) } ).joined(separator: ",")
                    deviceIdArray.removeAll()
                    for device in totalDevices {
                        deviceIdArray.append("\(device.id ?? 0)")
                    }
                    getSummaryReport(devicesID: ids)
                } else {
                    deviceIdArray.removeAll()
                    deviceIdArray.append("\(selectedDeviceId)")
                    getSummaryReport(devicesID: "\(selectedDeviceId)")
                }
                break
            case SelectedReportType.kilometer.rawValue:
                if isAllSelected {
                    let ids = totalDevices.map( { String($0.id) } ).joined(separator: ",")
                    deviceIdArray.removeAll()
                    getDistanceKmReport(devicesID: ids)
                } else {
                    deviceIdArray.removeAll()
                    getDistanceKmReport(devicesID: "\(selectedDeviceId)")
                }
                break
            case SelectedReportType.reachability.rawValue:
                deviceIdArray.removeAll()
                getReachabilityReport(devicesID: "\(selectedDeviceId)")
                break
            default:
                print("default")
                break
            }
            
        }
        
    }
    
    func getStopsReport(devicesID: String) {
        
        RCLocalAPIManager.shared.getStopsReport(with: devicesID, startDate: currentorStartDate, endDate: secondDate, success: { [weak self] hash in
            guard self != nil else {
                return
            }
            
            let stopsData:[StopsReportModelData] = hash.data ?? []
            self?.stopsReportArray = stopsData.sorted(by: {
                ($0.startTime ?? "") > ($1.startTime ?? "")
            })
            self?.reportView.newReportTableView.reloadData()
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.stopsReportArray.removeAll()
            weakSelf.reportView.newReportTableView.reloadData()
            weakSelf.prompt("no data found")
            print(message)
        }
    }
    
    func getTripsReport(devicesID: String) {
        
        RCLocalAPIManager.shared.getTripsReport(with: devicesID, loadingMsg: "Getting reports", startDate: apiStartDate, endDate: apiEndDate, success: { [weak self] hash in
            guard self != nil else {
                return
            }
            
//            self?.showAdditionalInfoProgress("Fetching additional Info...")
            self?.markerList.removeAll()
//            let date = self?.dateArray[self?.dateCounter ?? 0]
//            let deviceId = self?.deviceIdArray[self?.deviceCounter ?? 0]
//            self?.getDeviceMarkersForDate(date: date!, deviceId: deviceId!)
            let data:[TripsReportModelData] = hash.data ?? []
            self?.tripsReportArray = data.sorted(by: {
                ($0.start_time ?? "") > ($1.start_time ?? "")
            })
            self?.reportView.newReportTableView.reloadData()
            
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.tripsReportArray.removeAll()
            weakSelf.reportView.newReportTableView.reloadData()
            weakSelf.prompt("no data found")
            print(message)
        }
    }
    
    func getSummaryReport(devicesID: String) {
        RCLocalAPIManager.shared.getSummaryReport(with: devicesID, startDate: apiStartDate, endDate: apiEndDate, success:  { [weak self] hash in
            guard self != nil else { return }
            
            self?.handleSummaryReport(hash)
            
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.summaryReportArray.removeAll()
            weakSelf.reportView.newReportTableView.reloadData()
            weakSelf.prompt("no data found")
            print(message)
        }
    }
    
    func handleSummaryReport(_ data:SummaryReportModel) {
        let summaryData:[SummaryReportModelData] = data.data ?? []
        self.summaryReportArray = summaryData.sorted(by: {
            ($0.start_time ?? "") > ($1.start_time ?? "")
        })
//        self.summaryReportArray = data.data!
//        self.showAdditionalInfoProgress("Fetching additional Info...")
        self.markerList.removeAll()
        self.reportView.newReportTableView.reloadData()
//        let date = self.dateArray[self.dateCounter]
//        let deviceId = self.deviceIdArray[self.deviceCounter]
//        self.getDeviceMarkersForDate(date: date, deviceId: deviceId)
    }
    
    func getDistanceKmReport(devicesID: String) {
        RCLocalAPIManager.shared.getKmsReport(with: devicesID, startDate: currentorStartDate, endDate: secondDate, success:  { [weak self] hash in
            guard self != nil else { return }
            
            self?.handleDistanceReport(array: hash.data!)
            
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.kmsReportArray.removeAll()
            weakSelf.reportView.newReportTableView.reloadData()
            weakSelf.prompt("no data found")
            print(message)
        }
    }
    
    func getReachabilityReport(devicesID: String) {
        RCLocalAPIManager.shared.getReachabilityReport(with: devicesID, startDate: currentorStartDate, endDate: secondDate, success:  { [weak self] hash in
            guard let weakSelf = self else { return }
            
            weakSelf.reachabilitReportArray = hash.data!
            weakSelf.reportView.newReportTableView.reloadData()
            
            if weakSelf.reachabilitReportArray.isEmpty {
                weakSelf.prompt("No data available")
            }
            
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.reachabilitReportArray.removeAll()
            weakSelf.reportView.newReportTableView.reloadData()
            weakSelf.prompt("No data available")
            print(message)
        }
    }
    
    func handleDistanceReport(array: [DistanceReportModelData]) {
        kmsReportArray.removeAll()
        var kms : [String] = []
        var distancePojo = ParticularDistanceReportModel()
        distancePojo.deviceId = ""
        distancePojo.deviceName = ""
        distancePojo.distanceList = kms
        distancePojo.totalDistance = 0
        var totalDistance:Double = 0.0
        var counter:Int = 0
        for item in array {
            counter += 1
            let startDate = RCGlobals.getDateChinaToLocalFromString((item.startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMM dd, yyyy")
            let dist = RCGlobals.convertDist(distance: Double(item.distance ?? "0")!)
            var stringDatePlusKm:String = ""
            if dist.count == 3 {
                stringDatePlusKm = dateLabel + "           " + dist
            } else {
                stringDatePlusKm = dateLabel + "          " + dist
            }
            
            if distancePojo.deviceId != item.deviceId {
                if !distancePojo.deviceId!.isEmpty {
                    distancePojo.distanceList = kms
                    distancePojo.totalDistance = totalDistance
                    kmsReportArray.append(distancePojo)
                }
                distancePojo = ParticularDistanceReportModel()
                totalDistance = 0
                kms.removeAll()
                distancePojo.deviceId = item.deviceId!
                distancePojo.deviceName = item.deviceName!
            }
            totalDistance += Double(item.distance ?? "0") ?? 0
            kms.append(stringDatePlusKm)
            
            if counter == array.count {
                if !isSelectAll {
                    distancePojo.deviceId = item.deviceId!
                    distancePojo.deviceName = item.deviceName!
                    distancePojo.distanceList = kms
                    distancePojo.totalDistance = totalDistance
                    kmsReportArray.append(distancePojo)
                } else {
                    distancePojo.distanceList = kms
                    distancePojo.totalDistance = totalDistance
                    kmsReportArray.append(distancePojo)
                }
            }
            
        }
        
        handleKMUnavailableForDate()
    }
    
    func handleKMUnavailableForDate () {
        var updatedArray: [ParticularDistanceReportModel] = []
        for item in kmsReportArray {
            var updatedkmsList: [String] = []
            let currentkmsList = item.distanceList
            for selectedDate in kmDateArray {
                var isReportExist = false
                var updatedKMString:String = ""
                for kmString in currentkmsList {
                    if kmString.lowercased().contains(selectedDate.lowercased()) {
                        isReportExist = true
                        updatedKMString = kmString
                        break
                    }
                }
                if !isReportExist {
                    updatedKMString = selectedDate + "           " + "0.00"
                }
                updatedkmsList.append(updatedKMString)
            }
            item.distanceList = updatedkmsList
            updatedArray.append(item)
        }
        
        kmsReportArray = updatedArray
        
        reportView.newReportTableView.reloadData()
    }
    
    @objc func reportTypePicker(){
        if  isPickerOpen {
            self.reportView.selectVehicleLabel.endEditing(true)
            isPickerOpen = false
        }
        let alc = UIAlertController(title: " ".toLocalize, message: "Select Report Type".toLocalize, preferredStyle: .actionSheet)
        let stops = UIAlertAction(title: "STOPS".toLocalize, style: .default, handler: { (_) in
            self.selectedReportType = SelectedReportType.stops.rawValue
            self.reportView.reportTypeLabel.text = "STOPS"
            self.initialSelectedVehicle()
            
        })
        let trips = UIAlertAction(title: "TRIPS".toLocalize, style: .default, handler: { (_) in
            self.selectedReportType = SelectedReportType.trips.rawValue
            self.reportView.reportTypeLabel.text = "TRIPS"
            self.initialSelectedVehicle()
            
        })
        let daily = UIAlertAction(title: "DAILY".toLocalize, style: .default, handler: {(_) in
            self.selectedReportType = SelectedReportType.summary.rawValue
            self.reportView.reportTypeLabel.text = "DAILY"
            
        })
        let kmReport = UIAlertAction(title: "DAILY KM".toLocalize, style: .default, handler: {(_) in
            self.selectedReportType = SelectedReportType.kilometer.rawValue
            self.reportView.reportTypeLabel.text = "DAILY KM"
            
        })
        let reachReport = UIAlertAction(title: "REACHABILITY".toLocalize, style: .default, handler: {(_) in
            self.selectedReportType = SelectedReportType.reachability.rawValue
            self.reportView.reportTypeLabel.text = "REACHABILITY"
            self.initialSelectedVehicle()
            
        })
        alc.addAction(stops)
        alc.addAction(trips)
        alc.addAction(daily)
        alc.addAction(kmReport)
        alc.addAction(reachReport)
        self.present(alc, animated: true, completion: nil)
    }
    @objc func showPickerView() {
        isPickerOpen = true
        pickerView.delegate = self
        pickerView.dataSource = self
        setUpToolBar()
    }
    func setUpToolBar(){
        toolbar.sizeToFit()
        toolbar.backgroundColor = .black
        toolbar.tintColor = .white
        toolbar.barStyle = .blackTranslucent
        if  reportView.reportTypeLabel.text == SelectedReportType.summary.rawValue || reportView.reportTypeLabel.text == SelectedReportType.kilometer.rawValue {
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerView))
            let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let allVehicle = UIBarButtonItem(title: "All vehicles", style: .plain, target: self, action: #selector(selectAllfunction))
            let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPickerView))
            toolbar.setItems([cancelButton, spaceButton1, allVehicle, spaceButton2,doneButton], animated: true)
            reportView.selectVehicleLabel.inputAccessoryView = toolbar
            reportView.selectVehicleLabel.inputView = pickerView
            
        } else {
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerView))
            let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let spaceButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPickerView))
            
            toolbar.setItems([cancelButton, spaceButton1, spaceButton2, spaceButton3,doneButton ], animated: true)
            reportView.selectVehicleLabel.inputAccessoryView = toolbar
            reportView.selectVehicleLabel.inputView = pickerView
        }
    }
    @objc func donePickerView() {
        reportView.selectVehicleLabel.alpha = 1
        reportView.selectVehicleLabel.endEditing(true)
        pickerView.removeFromSuperview()
        toolbar.removeFromSuperview()
    }
    
    @objc func selectAllfunction() {
        self.view.endEditing(true)
        reportView.selectVehicleLabel.text = "All vehicles selected"
        reportView.selectVehicleLabel.alpha = 0.6
        isAllSelected = true
        pickerView.removeFromSuperview()
        toolbar.removeFromSuperview()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        reportView.dateLabel.resignFirstResponder()
        reportView.selectVehicleLabel.resignFirstResponder()
        reportView.reportTypeLabel.resignFirstResponder()
    }
    @objc func cancelPickerView() {
        reportView.selectVehicleLabel.alpha = 1
        self.view.endEditing(true)
        pickerView.removeFromSuperview()
        toolbar.removeFromSuperview()
    }
    
    func setViews(){
        reportView = NewReportView(frame: CGRect.zero)
        reportView.isScrollEnabled = false
        reportView.showsVerticalScrollIndicator = false
        reportView.bounces = false
        reportView.delegate = self
        scrollViewContentHeight = reportView.intrinsicContentSize.height
        view.addSubview(reportView)
        gettingTotalDevices()
    }
    func gettingTotalDevices(){
        totalDevices.removeAll()
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
        let allDevices = RCGlobals.getExpiryFilteredList(data ?? [])
        for item in allDevices {
            if item.lastUpdate != nil {
                totalDevices.append(item)
            }
        }
    }
    func setConstraints(){
        reportView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
    }
    
    func getCoordinates(geofenceToShow : GeofenceModel, deviceLocation: CLLocation)  -> String? {
        
        var nameOfGeofence = ""
        
        if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
            let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
            //                var locations: [CLLocationCoordinate2D] = []
            //                for i in stride(from: 0, to: coordinates.count, by: 2) {
            //                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
            //                }
            let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
            
            let radius = Double(coordinates[2])!
            let center = locations
            
            let distanceFromCenter = deviceLocation.distance(from: center)
            
            if distanceFromCenter > radius {
                // outside
                
                
            } else {
                
                nameOfGeofence = geofenceToShow.name 
                
                // inside
            }
            
        } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
            let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
            let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
            
            let radius = Double(coordinates[2])!
            let center = locations
            
            let distanceFromCenter = deviceLocation.distance(from: center)
            
            if distanceFromCenter > radius {
                // outside
                
                
            } else {
                
                nameOfGeofence = geofenceToShow.name 
                
                // inside
            }
            
        } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
            let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
            //                var locations: [CLLocationCoordinate2D] = []
            //                for i in stride(from: 0, to: coordinates.count, by: 2) {
            //                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
            //                }
            let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
            let radius = Double(coordinates[2])!
            let center = locations
            
            let distanceFromCenter = deviceLocation.distance(from: center)
            
            if distanceFromCenter > radius {
                // outside
                
                
            } else {
                
                nameOfGeofence = geofenceToShow.name 
                
                // inside
            }
            
            
        }
        
        return nameOfGeofence
        
    }
}


extension NewReportViewController:UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        var count:Int = 0
        if selectedReportType == SelectedReportType.stops.rawValue {
            count =  stopsReportArray.count
        } else if selectedReportType == SelectedReportType.trips.rawValue {
            count =  tripsReportArray.count
        } else if selectedReportType == SelectedReportType.summary.rawValue {
            count =  summaryReportArray.count
        } else if selectedReportType == SelectedReportType.kilometer.rawValue {
            count =  kmsReportArray.count
        } else if selectedReportType == SelectedReportType.reachability.rawValue {
            count =  reachabilitReportArray.count
        } else {
            count =  0
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchedReportType == SelectedReportType.stops.rawValue {
            let stopsCell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.stopReport.rawValue, for: indexPath) as! StopsViewCell
            
            let startDate = RCGlobals.getDateChinaToLocalFromString((stopsReportArray[indexPath.section].startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
            let timeLabel = RCGlobals.getFormattedDate(date: startDate, format: "h:mm a")
            stopsCell.dateLabel.text = dateLabel
            stopsCell.leftLabel.text = timeLabel
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((stopsReportArray[indexPath.section].latitude)! as NSString).doubleValue, longitude: ((stopsReportArray[indexPath.section].longitude)! as NSString).doubleValue)
            
            let coords : CLLocation = CLLocation(latitude: ((stopsReportArray[indexPath.section].latitude)! as NSString).doubleValue, longitude: ((self.stopsReportArray[indexPath.section].longitude)! as NSString).doubleValue)
            
            var pointOfInterestLocation: String = ""
            let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
            
            if geofences?.count != 0 {
                for geofence in geofences! {
                    pointOfInterestLocation = self.getCoordinates(geofenceToShow: geofence, deviceLocation: coords) ?? ""
                    if !pointOfInterestLocation.isEmpty {
                        stopsCell.leftTextView.text = pointOfInterestLocation
                        break
                    }
                }
            }
            
            if pointOfInterestLocation.isEmpty {
                
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
                    if self.stopsReportArray.count == 0 {
                        return
                    }
                    if error != nil {
                        if let serverAddress = self.stopsReportArray[indexPath.section].address {
                            stopsCell.leftTextView.text = serverAddress
                        } else {
                            stopsCell.leftTextView.text = "No Address"
                        }
                    }
                    guard let address = response?.firstResult(), let lines = address.lines else { return }
                    
                    stopsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
                    
                    self.stopsReportArray[indexPath.section].address = lines.joined(separator: " ")
                }
            }
//            stopsCell.showdistaceLabel.text = RCGlobals.convertDistanceWithoutRoundOff(distance: Double(stopsReportArray[indexPath.section].distance ?? "0")!)
            stopsCell.showtimeLabel.text = RCGlobals.convertTime(miliseconds: Int(stopsReportArray[indexPath.section].duration ?? "0")!)
//            stopsCell.showaverageLabel.text = RCGlobals.convertSpeed(speed: Float(stopsReportArray[indexPath.section].averageSpeed ?? "0.0")!)
            // stopsCell.layer.cornerRadius = 20
            stopsCell.selectionStyle = .none
            return stopsCell
        } else if searchedReportType == SelectedReportType.trips.rawValue {
            let tripsCell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.tripSummaryReport.rawValue, for: indexPath) as! DateViewCell
            
            let startDate = RCGlobals.getDateWithoutConversionFormat((tripsReportArray[indexPath.section].start_time)!, "yyyy-MM-dd HH:mm:ss") as Date
            let endDate = RCGlobals.getDateWithoutConversionFormat((tripsReportArray[indexPath.section].end_time)!, "yyyy-MM-dd HH:mm:ss") as Date
            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
            let starttimeLabel = RCGlobals.getFormattedDate(date: startDate, format: "hh:mm a")
            let endtimeLabel = RCGlobals.getFormattedDate(date: endDate, format: "hh:mm a")
            
            tripsCell.dateLabel.text = dateLabel
            tripsCell.leftLabel.text = starttimeLabel
            tripsCell.rightLabel.text = endtimeLabel
            
            let startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: tripsReportArray[indexPath.section].start_lat ?? 0.0, longitude: tripsReportArray[indexPath.section].start_lng ?? 0.0)
            
            let startcoords : CLLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
            
            let endCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                latitude: tripsReportArray[indexPath.section].end_lat ?? 0.0,
                longitude: tripsReportArray[indexPath.section].end_lng ?? 0.0)
            
            let endcoords : CLLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
            
            var pointOfInterestLocationStart: String = ""
            let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
            
            if geofences?.count != 0 {
                
                for geofence in geofences! {
                    pointOfInterestLocationStart = self.getCoordinates(geofenceToShow: geofence, deviceLocation: startcoords) ?? ""
                    if !pointOfInterestLocationStart.isEmpty {
                        tripsCell.leftTextView.text = pointOfInterestLocationStart
                        break
                    }
                }
                
            }
            
            var pointOfInterestLocationEnd: String = ""
            
            if geofences?.count != 0 {
                
                for geofence in geofences! {
                    
                    
                    pointOfInterestLocationEnd = self.getCoordinates(geofenceToShow: geofence, deviceLocation: endcoords) ?? ""
                    if !pointOfInterestLocationEnd.isEmpty {
                        tripsCell.rightTextView.text = pointOfInterestLocationEnd
                        break
                    }
                }
                
            }
            
            let geocoder = GMSGeocoder()
            if pointOfInterestLocationStart.isEmpty {
                
                geocoder.reverseGeocodeCoordinate(startCoordinate) { (response, error) in
                    if self.tripsReportArray.count == 0 {
                        return
                    }
                    if error != nil {
                        if let serverAddress = self.tripsReportArray[indexPath.section].startAddress {
                            tripsCell.leftTextView.text = serverAddress
                        } else {
                            tripsCell.leftTextView.text = "No Address"
                        }
                    }
                    guard let address = response?.firstResult(), let lines = address.lines else { return }
                    
                    tripsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
                    
                    self.tripsReportArray[indexPath.section].startAddress = lines.joined(separator: " ")
                }
            }
            if pointOfInterestLocationEnd.isEmpty {
                
                geocoder.reverseGeocodeCoordinate(endCoordinate) { (response, error) in
                    if self.tripsReportArray.count == 0 {
                        return
                    }
                    if error != nil {
                        if let serverAddress = self.tripsReportArray[indexPath.section].endAddress {
                            tripsCell.rightTextView.text = serverAddress
                        } else {
                            tripsCell.rightTextView.text = "No Address"
                        }
                    }
                    guard let address = response?.firstResult(), let lines = address.lines else { return }
                    
                    tripsCell.rightTextView.text = lines.joined(separator: " ").toLocalize
                    
                    self.tripsReportArray[indexPath.section].endAddress = lines.joined(separator: " ")
                }
            }
            
            tripsCell.carNameLabel.text = tripsReportArray[indexPath.section].device_name ?? ""
            tripsCell.showdistaceLabel.text = "\((tripsReportArray[indexPath.section].distance ?? 0.0).rounded(toPlaces: 1))"
            tripsCell.showtimeLabel.text = tripsReportArray[indexPath.section].duration ?? "0 H 0 M"
            tripsCell.showaverageLabel.text = "\((tripsReportArray[indexPath.section].avg_speed ?? 0.0).rounded(toPlaces: 1))"
            
            let harshBraking:Int = tripsReportArray[indexPath.section].harsh_braking ?? 0
            let harshCorner:Int = tripsReportArray[indexPath.section].harsh_cornering ?? 0
            let harshAcceleration:Int = tripsReportArray[indexPath.section].harsh_acceleration ?? 0
            let overspeed:Int = tripsReportArray[indexPath.section].over_speed ?? 0
            let drivingSafetyScore:Double = tripsReportArray[indexPath.section].driving_safety_score ?? 0.0
            let sum:Int = harshBraking + harshCorner + harshAcceleration + overspeed
            
            tripsCell.photoLabel.text = "Safety Event Count : \(sum)"
            tripsCell.showDrivingSafetyLabel.text = "\(drivingSafetyScore.rounded(toPlaces: 1))"
            tripsCell.showExcessiveIdleTimeLabel.text = tripsReportArray[indexPath.section].excessive_idle_time ?? "0"
            if drivingSafetyScore >= 8.75 {
                tripsCell.showColorCodeView.backgroundColor = appGreenTheme
            } else if drivingSafetyScore < 8.75 && drivingSafetyScore > 7.5 {
                tripsCell.showColorCodeView.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1.0)
            } else {
                tripsCell.showColorCodeView.backgroundColor = UIColor(red: 249/255, green: 53/255, blue: 55/255, alpha: 1.0)
            }
            //tripsCell.layer.cornerRadius = 20
            tripsCell.selectionStyle = .none
            return tripsCell
        } else if searchedReportType == SelectedReportType.summary.rawValue {
            let tripsCell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.tripSummaryReport.rawValue, for: indexPath) as! DateViewCell
            
            let startDate = RCGlobals.getDateWithoutConversionFormat((summaryReportArray[indexPath.section].start_time)!, "yyyy-MM-dd HH:mm:ss") as Date
            let endDate = RCGlobals.getDateWithoutConversionFormat((summaryReportArray[indexPath.section].end_time)!, "yyyy-MM-dd HH:mm:ss") as Date
            let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
            let starttimeLabel = RCGlobals.getFormattedDate(date: startDate, format: "h:mm a")
            let endtimeLabel = RCGlobals.getFormattedDate(date: endDate, format: "h:mm a")
            
//            if isAllSelected {
                tripsCell.carNameLabel.text = summaryReportArray[indexPath.section].device_name ?? ""
//            } else {
//                tripsCell.carNameLabel.text = ""
//            }
            tripsCell.dateLabel.text = dateLabel
            tripsCell.leftLabel.text = starttimeLabel
            tripsCell.rightLabel.text = endtimeLabel
            let startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                latitude: summaryReportArray[indexPath.section].start_lat ?? 0.0,
                longitude: summaryReportArray[indexPath.section].start_lng ?? 0.0)
            
            let startcoords : CLLocation = CLLocation(
                latitude: startCoordinate.latitude,
                longitude: startCoordinate.longitude)
            
            let endCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(
                latitude: summaryReportArray[indexPath.section].end_lat ?? 0.0,
                longitude: summaryReportArray[indexPath.section].end_lng ?? 0.0)
            
            let endcoords : CLLocation = CLLocation(
                latitude: endCoordinate.latitude,
                longitude: endCoordinate.longitude)
            
            var pointOfInterestLocationStart: String = ""
            let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
            
            if geofences?.count != 0 {
                
                for geofence in geofences! {
                    pointOfInterestLocationStart = self.getCoordinates(geofenceToShow: geofence, deviceLocation: startcoords) ?? ""
                    if !pointOfInterestLocationStart.isEmpty {
                        tripsCell.leftTextView.text = pointOfInterestLocationStart
                        break
                    }
                }
                
            }
            
            var pointOfInterestLocationEnd: String = ""
            
            if geofences?.count != 0 {
                
                for geofence in geofences! {
                    
                    
                    pointOfInterestLocationEnd = self.getCoordinates(geofenceToShow: geofence, deviceLocation: endcoords) ?? ""
                    if !pointOfInterestLocationEnd.isEmpty {
                        tripsCell.rightTextView.text = pointOfInterestLocationEnd
                        break
                    }
                }
                
            }
            
            let geocoder = GMSGeocoder()
            if pointOfInterestLocationStart.isEmpty {
                
                geocoder.reverseGeocodeCoordinate(startCoordinate) { (response, error) in
                    if self.summaryReportArray.count == 0 {
                        return
                    }
                    if error != nil {
                        if let serverAddress = self.summaryReportArray[indexPath.section].startAddress {
                            tripsCell.leftTextView.text = serverAddress
                        } else {
                            tripsCell.leftTextView.text = "No Address"
                        }
                    }
                    guard let address = response?.firstResult(), let lines = address.lines else { return }
                    
                    tripsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
                    
                    self.summaryReportArray[indexPath.section].startAddress = lines.joined(separator: " ")
                }
            }
            if pointOfInterestLocationEnd.isEmpty {
                
                geocoder.reverseGeocodeCoordinate(endCoordinate) { (response, error) in
                    if self.summaryReportArray.count == 0 {
                        return
                    }
                    if error != nil {
                        if let serverAddress = self.summaryReportArray[indexPath.section].endAddress {
                            tripsCell.rightTextView.text = serverAddress
                        } else {
                            tripsCell.rightTextView.text = "No Address"
                        }
                    }
                    guard let address = response?.firstResult(), let lines = address.lines else { return }
                    
                    tripsCell.rightTextView.text = lines.joined(separator: " ").toLocalize
                    
                    self.summaryReportArray[indexPath.section].endAddress = lines.joined(separator: " ")
                }
            }
            
            tripsCell.showdistaceLabel.text = "\((summaryReportArray[indexPath.section].distance ?? 0.0).rounded(toPlaces: 1))"
            tripsCell.showtimeLabel.text = "24 Hrs"
            tripsCell.showaverageLabel.text = "\((summaryReportArray[indexPath.section].avg_speed ?? 0.0).rounded(toPlaces: 1))"
            let harshBraking:Int = summaryReportArray[indexPath.section].harsh_braking ?? 0
            let harshCorner:Int = summaryReportArray[indexPath.section].harsh_cornering ?? 0
            let harshAcceleration:Int = summaryReportArray[indexPath.section].harsh_acceleration ?? 0
            let overspeed:Int = summaryReportArray[indexPath.section].over_speed ?? 0
            let drivingSafetyScore:Double = summaryReportArray[indexPath.section].driving_safety_score ?? 0.0
            let sum:Int = harshBraking + harshCorner + harshAcceleration + overspeed
            
            tripsCell.photoLabel.text = "Safety Event Count : \(sum)"
            tripsCell.showDrivingSafetyLabel.text = "\(drivingSafetyScore.rounded(toPlaces: 1))"
            tripsCell.showExcessiveIdleTimeLabel.text = summaryReportArray[indexPath.section].excessive_idle_time ?? ""
            if drivingSafetyScore >= 8.75 {
                tripsCell.showColorCodeView.backgroundColor = appGreenTheme
            } else if drivingSafetyScore < 8.75 && drivingSafetyScore > 7.5 {
                tripsCell.showColorCodeView.backgroundColor = UIColor(red: 255/255, green: 235/255, blue: 59/255, alpha: 1.0)
            } else {
                tripsCell.showColorCodeView.backgroundColor = UIColor(red: 249/255, green: 53/255, blue: 55/255, alpha: 1.0)
            }
            tripsCell.layer.cornerRadius = 20
            tripsCell.selectionStyle = .none
            return tripsCell
        } else if searchedReportType == SelectedReportType.kilometer.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.kmReport.rawValue, for: indexPath) as! KilometreTableViewCell
            
            print("indexpath row is \(indexPath.row)")
            let appDarkTheme = UIColor(red: 38/255, green: 39/255, blue: 58/255, alpha: 1.0)
            cell.backgroundColor = appDarkTheme
            cell.selectionStyle = .none
            
            let kiloms : [String] = kmsReportArray[indexPath.section].distanceList
            
            cell.titleLabel.text = kmsReportArray[indexPath.section].deviceName
            
            cell.setup(names: kiloms, totalDist: kmsReportArray[indexPath.section].totalDistance)
            
            return cell
        } else if searchedReportType == SelectedReportType.reachability.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.reachibilityReport.rawValue) as! NewReportTableViewCell
            let data = reachabilitReportArray[indexPath.row]
            cell.vehicleName.text = data.deviceName ?? "Not available"
            cell.statusText.text = data.status ?? "reached"
            let createdDate:String = RCGlobals.convertUTCToIST(data.dateAdded ?? "0", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd hh:mm a")
            let reachedDate:String = RCGlobals.convertUTCToIST(data.reachDate ?? "0", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd hh:mm a")
            cell.createdText.text = createdDate 
            cell.reachText.text = reachedDate
            cell.radiusText.text = "\(data.radius ?? "0") km"
            let geocoder = GMSGeocoder()
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((reachabilitReportArray[indexPath.section].latAtReach)! as NSString).doubleValue, longitude: ((reachabilitReportArray[indexPath.section].lngAtReach)! as NSString).doubleValue)
            
            geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
                if self.reachabilitReportArray.count == 0 {
                    return
                }
                guard let address = response?.firstResult(), let lines = address.lines else { return }
                
                cell.destAddText.text = lines.joined(separator: " ").toLocalize
            }
            
            updateReachabilityMap(cell.mapView, data)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.reachibilityReport.rawValue) as! NewReportTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navController = ReportMapsViewController()
        
        switch searchedReportType {
        case SelectedReportType.stops.rawValue:
            navController.reportType = 0
            navController.stopsReportData = stopsReportArray[indexPath.section]
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(navController, animated:true)
            break
        case SelectedReportType.trips.rawValue:
            navController.reportType = 1
//            let startDate = RCGlobals.getDateChinaToLocalFromString((tripsReportArray[indexPath.section].start_time)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//            let endDate = RCGlobals.getDateChinaToLocalFromString((tripsReportArray[indexPath.section].end_time)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
            
//            let markerImageList = RCGlobals.getFilteredMarkerListWithTimeLimit(markerList: self.markerList, startTime: startDate, endTime: endDate, deviceId: (tripsReportArray[indexPath.section].deviceId)!)
            
            navController.tripsReportData = tripsReportArray[indexPath.section]
//            navController.markerImages = markerImageList
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(navController, animated:true)
            break
        case SelectedReportType.summary.rawValue:
            navController.reportType = 2
//            let markerImageList = RCGlobals.getFilteredMarkerList(markerList: self.markerList, deviceId: (summaryReportArray[indexPath.section].deviceId)!)
            
            navController.summaryReportData = summaryReportArray[indexPath.section]
//            navController.markerImages = markerImageList
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(navController, animated:true)
            break
        default:
            print("Report tapped: \(indexPath.section)")
        }
    }
    
    fileprivate func updateReachabilityMap(_ mapView: RCMainMap, _ data : ReachabilityReportModelData) {
        mapView.delegate = self
        
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds()
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((data.latAtReach)! as NSString).doubleValue, longitude: ((data.lngAtReach)! as NSString).doubleValue)
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 13, height: 27), interpolationQuality: .default)
        
        marker.map = mapView
        
        bounds = bounds.includingCoordinate(coordinate)
        
        let geofenceId = Int(data.geofenceId ?? "0")
        
        if  geofenceId != 0 {
            let allGeofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel")) ?? []
            let geofence = allGeofences.filter({ $0.id == geofenceId}).first
            
            if let geofenceToShow = geofence {
                if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                    let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                    var locations: [CLLocationCoordinate2D] = []
                    for i in stride(from: 0, to: coordinates.count, by: 2) {
                        let location = CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!)
                        locations.append(location)
                        bounds = bounds.includingCoordinate(location)
                    }
                    if let stringColor = geofenceToShow.attributes?.areaColor {
                        _ = RCPolygon.drawPolygon(points: locations, title: geofenceToShow.name, color: hexStringToUIColor(hex: stringColor), map: mapView)
                    } else {
                        _ = RCPolygon.drawPolygon(points: locations, title: geofenceToShow.name, map: mapView)
                    }
                } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                    let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                    let locations: CLLocation = CLLocation(latitude: Double(coordinates[0]) ?? 0.0, longitude: Double(coordinates[1]) ?? 0.0)
                    if let stringColor = geofenceToShow.attributes?.areaColor {
                        let circle = RCCircle.drawCircleWithCenter(point:locations, radius:Double(coordinates[2]) ?? 0.0, title: geofenceToShow.name, color: self.hexStringToUIColor(hex: stringColor), map:(mapView))
                        bounds = bounds.includingBounds(circle.bounds())
                    } else {
                        let circle = RCCircle.drawCircleWithCenter(point: locations, radius: Double(coordinates[2]) ?? 0.0, title: geofenceToShow.name, map: (mapView))
                        bounds = bounds.includingBounds(circle.bounds())
                    }
                } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                    let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                    var locations: [CLLocationCoordinate2D] = []
                    for i in stride(from: 0, to: coordinates.count, by: 2) {
                        let location = CLLocationCoordinate2D(latitude: Double(coordinates[i]) ?? 0.0, longitude: Double(coordinates[i+1]) ?? 0.0)
                        locations.append(location)
                        bounds = bounds.includingCoordinate(location)
                    }
                    if let stringColor = geofenceToShow.attributes?.areaColor {
                        RCPolyLine().drawpolyLineFrom(points: locations, color: hexStringToUIColor(hex: stringColor), title: (geofenceToShow.name) , map: mapView)
                    } else {
                        RCPolyLine().drawpolyLineFrom(points: locations, color: UIColor.red,title: (geofenceToShow.name), map: mapView)
                    }
                }
            }
            
        } else {
            let geoCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((data.lat)! as NSString).doubleValue, longitude: ((data.lng)! as NSString).doubleValue)
            
            let radius = ((data.radius)! as NSString).doubleValue * 1000
            let circle = GMSCircle(position: geoCoordinate, radius: radius)
            
            circle.strokeColor = UIColor.blue
            
            circle.fillColor = UIColor.blue.withAlphaComponent(0.3)
            
            circle.strokeWidth = 1
            
            circle.map = mapView
            
            bounds = bounds.includingBounds(circle.bounds())
            
            bounds = bounds.includingCoordinate(geoCoordinate)
            
        }
        
        mapView.setMinZoom(1, maxZoom: 20)
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 20.0 , left: 10.0 ,bottom: 20.0 ,right: 10.0)))
        
    }
    
}

extension NewReportViewController : GMSMapViewDelegate {
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return false
    }
}

extension NewReportViewController:UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return totalDevices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return totalDevices[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDeviceId = totalDevices[row].id
        self.reportView.selectVehicleLabel.text = totalDevices[row].name
        isAllSelected = false
    }
}

extension NewReportViewController : SelectedUserHierarchyDelegate {
    func selectedUser(userId: String?, userName: String?) {
        Defaults().set(userId ?? "0", for: Key<String>(defaultKeyNames.branchForReport.rawValue))
        Defaults().set(userName ?? "User", for: Key<String>(defaultKeyNames.branchNameForReport.rawValue))
    }
}

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var markersArray: [MarkerFirebaseModel] = []
}
extension NewReportViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showPickerView()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
extension NewReportViewController {
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(options[index])
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension NewReportViewController {
    func doDatePicker(){
        // DatePicker
        self.datePpicker = UIDatePicker()
        self.datePpicker?.datePickerMode = UIDatePickerMode.date
        self.datePpicker?.tintColor = .black
        self.datePpicker?.backgroundColor = .white
        let now = Date()
        self.datePpicker.maximumDate = now;
        let modifiedDate = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        self.datePpicker.minimumDate = modifiedDate
        
        //datePicker.center = view.center
        view.addSubview(self.datePpicker)
        
        // ToolBar
        toolBbar = UIToolbar()
        toolBbar.barStyle = .blackTranslucent
        toolBbar.backgroundColor = .black
        
        toolBbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBbar.sizeToFit()
        
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
            self.datePpicker?.tintColor = .black
            self.datePpicker?.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        setPickerConstraints(datePicker: datePpicker, toolBar: toolBbar)
    }
    @objc func doneClick() {
        datePpicker.isHidden = true
        toolBbar.isHidden = true
        
        selectedDateFrom = datePpicker.date
        
        fromDateString = RCGlobals.convertDateToString(date: datePpicker.date, format: "MMM dd, yyyy", toUTC: false)
        
        currentorStartDate = RCGlobals.convertDateToString(date: selectedDateFrom, format: "yyyy-MM-dd", toUTC: false)
        secondDate = RCGlobals.convertDateToString(date: selectedDateFrom, format: "yyyy-MM-dd", toUTC: false)
        
        apiStartDate = RCGlobals.convertDateToString(date: selectedDateFrom.startOfDay, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toUTC: true)
        apiEndDate = RCGlobals.convertDateToString(date: selectedDateFrom.endOfDay, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toUTC: true)
        
        
        if isDateRange {
            doEndDatePicker()
        } else {
            reportView.dateLabel.text = "\(fromDateString) - \(fromDateString)"
            dateArray.removeAll()
            kmDateArray.removeAll()
            kmDateArray.append(RCGlobals.convertDateToString(date: selectedDateFrom, format: "MMM dd, yyyy", toUTC: false))
            dateArray.append(currentorStartDate)
        }
    }
    
    @objc func cancelClick() {
        datePpicker.isHidden = true
        self.toolBbar.isHidden = true
    }
    
    func doEndDatePicker() {
        // DatePicker
        self.datePpicker = UIDatePicker()
        self.datePpicker?.backgroundColor = .white
        self.datePpicker?.tintColor = .black
        self.datePpicker?.datePickerMode = UIDatePickerMode.date
        let now = Date()
        self.datePpicker.maximumDate = now;
        let modifiedDate = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        self.datePpicker.minimumDate = modifiedDate
        
        //datePicker.center = view.center
        view.addSubview(self.datePpicker)
        
        // ToolBar
        toolBbar = UIToolbar()
        toolBbar.barStyle = .blackTranslucent
        toolBbar.backgroundColor = .black
        
        toolBbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBbar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndDatePick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let name = UIBarButtonItem(title: "To date", style: .plain, target: self, action: nil)
        toolBbar.setItems([cancelButton ,name, spaceButton, doneButton], animated: true)
        toolBbar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBbar)
        self.toolBbar.isHidden = false
        if #available(iOS 13.4, *) {
            datePpicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            self.datePpicker?.tintColor = .black
            self.datePpicker?.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        setPickerConstraints(datePicker: datePpicker, toolBar: toolBbar)
    }
    
    
    @objc func doneEndDatePick() {
        datePpicker.isHidden = true
        toolBbar.isHidden = true
        
        selectedDateTo = datePpicker.date
        
        secondDate = RCGlobals.convertDateToString(date: selectedDateTo, format: "yyyy-MM-dd", toUTC: false)
        apiEndDate = RCGlobals.convertDateToString(date: selectedDateTo.endOfDay, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toUTC: true)
        
        let toDateString = RCGlobals.convertDateToString(date: datePpicker.date, format: "MMM dd, yyyy", toUTC: false)
        
        reportView.dateLabel.text = "\(fromDateString) - \(toDateString)"
        
        dateArray.removeAll()
        
        //        dateArray.append(RCGlobals.convertDateToString(date: selectedDateFrom, format: "yyyy-MM-dd", toUTC: false))
        
        
        kmDateArray.removeAll()
        //        kmDateArray.append(RCGlobals.convertDateToString(date: selectedDateFrom, format: "MMM dd, yyyy", toUTC: false))
        
        while selectedDateFrom <= selectedDateTo {
            
            dateArray.append(RCGlobals.convertDateToString(date: selectedDateFrom, format: "yyyy-MM-dd", toUTC: false))
            
            kmDateArray.append(RCGlobals.convertDateToString(date: selectedDateFrom, format: "MMM dd, yyyy", toUTC: false))
            
            selectedDateFrom = Calendar.current.date(byAdding: .day, value: 1, to: selectedDateFrom)!
            
        }
        
    }
}
extension UIViewController {
func setPickerConstraints(datePicker:UIDatePicker , toolBar:UIToolbar){
    datePicker.snp.makeConstraints { (make) in
        if #available(iOS 11.0, *) {
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        } else {
            make.bottom.equalToSuperview()
        }
        make.height.equalToSuperview().multipliedBy(0.2)
        make.width.equalToSuperview()
    }
    toolBar.snp.makeConstraints { (make) in
        make.bottom.equalTo(datePicker.snp.top)
        make.height.equalTo(50)
        make.width.equalToSuperview()
    }
}
}

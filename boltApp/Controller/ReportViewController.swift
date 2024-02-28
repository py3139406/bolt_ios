////
////  ReportViewController.swift
////  boltApp
////
////  Created By Anshul Jain on 25-March-2019
////  Copyright © Roadcast Tech Solutions Private Limited
////
//
//import UIKit
//import SnapKit
//import DefaultsKit
//import GoogleMaps
//import CVCalendar
//import Firebase
//
//class ReportViewController: UIViewController {
//
//  let SCREEN_HEIGHT = UIScreen.main.bounds.height
//  let SCREEN_WIDTH = UIScreen.main.bounds.width
//  var reportView: ReportsView!
//  //var datePicker: MIDatePicker!
//  var dateFormatter = DateFormatter()
//  var selectedDate: String!
//  var allDevices: [TrackerDevicesMapperModel]!
//  lazy var devicesPicker: UIPickerView = UIPickerView()
//  var selectedVehicleIndex: Int!
//  var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
//  var overlayButton: UIButton!
//  var summaryReportData: SummaryReportModel!
//  var tripsReportData: TripsReportModel!
//  var stopsReportData: StopsReportModel!
//  var namesArray = [["20 january, 2020  20.0km","b","c"],["d","e"],["f"],["g","h"],[],["j"]]
//
//  //var firstDate: String = ""
//  var secondDate: String = ""
//  var currentorStartDate: String = ""
//  var isRangeselected = false
//
//  var isKilometreReportSelected = false
//
//  var count = 0
//
//    // Marker
//
//    var markerList:[MarkerFirebaseModel] = []
//
//    var second = 3
//    var timer: Timer!
//
//    var markerRef : DatabaseReference!
//
//    var deviceIdArray : [String]! = []
//
//    var dateArray : [String]! = []
//
//    var dateCounter : Int = 0
//
//    var deviceCounter : Int = 0
//
//    var isSelectAll : Bool = false
//
//    var HUD: MBProgressHUD?
//
//    var imageDownloadCounter: Int  = 0
//
//    var markerDownloadCounter: Int = 0
//
//    var downloadFailCounter: Int = 0
//
//  fileprivate lazy var usersHierarchy: UsersHerarchy? = {
//    return Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy")) ?? nil
//  }()
//
//  fileprivate func navigationBarFunction() {
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
//    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "calendar-3"), style: .plain, target: self, action: nil)
//    self.navigationItem.title = "Reports"
//  }
//
//  fileprivate func delegateAndFunctions() {
//
//
//    reportView.vechileTextField.addTarget(self, action: #selector(selectVehicle), for: UIControlEvents.editingDidBegin)
//    reportView.userSelection.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userSelectionTapped(_:))))
//    reportView.segmentedController.addTarget(self, action: #selector(valueChange(_:)), for: UIControlEvents.valueChanged)
//    reportView.searchButton.addTarget(self, action: #selector(searchButton(_:)), for: .touchUpInside)
//    reportView.radioButton.addTarget(self, action: #selector(selectAllVehicle(_:)), for: .touchUpInside)
//    reportView.radioBtnForKilometreReport.addTarget(self, action: #selector(selectKmReport(_:)), for: .touchUpInside)
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    reportView = ReportsView(frame: view.frame)
//
//    reportView.tripsTableView.register(KilometreTableViewCell.self, forCellReuseIdentifier: "KilometreTableViewCell")
//
//    setupView()
//
//    Auth.auth().signInAnonymously { (user, error) in
//
//    }
//
//  }
//
//    func getDeviceMarkersForDate(date:String,deviceId:String){
//
//        markerRef = Database.database().reference().child("Bolt/Markers").child(deviceId).child(date)
//
//        markerRef.observe(.childAdded, with: { [] (snapshot) in
//            if let response = snapshot.value as? [String : AnyObject] {
//                let markerFirebaseModel:MarkerFirebaseModel = MarkerFirebaseModel()
//                markerFirebaseModel.deviceId = deviceId
//                markerFirebaseModel.title = response["title"] as? String
//                markerFirebaseModel.description = response["description"] as? String
//                markerFirebaseModel.timestamp = response["timestamp"] as? String
//                markerFirebaseModel.userLat = response["userLat"] as? Double
//                markerFirebaseModel.userLng = response["userLng"] as? Double
//                markerFirebaseModel.deviceLat = response["deviceLat"] as? Double
//                markerFirebaseModel.deviceLng = response["deviceLng"] as? Double
//                markerFirebaseModel.imagePathList = response["imagePathList"] as? [String]
//                self.markerList.append(markerFirebaseModel)
//            }
//        })
//
//        createTimer()
//    }
//
//    func createTimer(){
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateTime(){
//        second -= 1
//        if second == 0 {
//            timer.invalidate()
//            markerRef.removeAllObservers()
//            if  dateCounter < dateArray.count-1 {
//                dateCounter += 1
//                second = 3
//                getDeviceMarkersForDate(date: dateArray[dateCounter], deviceId: deviceIdArray[deviceCounter])
//            } else {
//                if  deviceCounter < deviceIdArray.count-1 {
//                    deviceCounter += 1
//                    second = 3
//                    getDeviceMarkersForDate(date: dateArray[dateCounter], deviceId: deviceIdArray[deviceCounter])
//                } else {
//                    dateCounter = 0
//                    deviceCounter = 0
//                    second = 3
//                    // Update report list here.
//                    hideAdditionalInfoProgress()
//
//                    reportView.tripsTableView.delegate = self
//                    reportView.tripsTableView.dataSource = self
//                    reportView.tripsTableView.register(DateViewCell.self, forCellReuseIdentifier: "tripsIdentifier")
//                    reportView.tripsTableView.reloadData()
//                }
//            }
//        }
//    }
//
//
//  func setupView() {
//
//    self.navigationController?.isNavigationBarHidden = false
//
//    reportView.vechileTextField.delegate = self
//    reportView.calenderTextField.delegate = self
//
//    view.backgroundColor =  UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
//    view.addSubview(reportView)
//
//
//    delegateAndFunctions()
//    reportView.vechileTextField.inputView = devicesPicker
//    checkForSegmentSelectedIndex()
//    navigationBarFunction()
//
//    let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("allDevices"))
//    allDevices = RCGlobals.getExpiryFilteredList(data ?? [])
//    setUpPickerViews()
//
//    reportView.tripsTableView.allowsSelection = true
//  }
//
//  @objc func setupCalendar(){
//
//    let singleDate = { (action: UIAlertAction) -> Void in
//      let newCalender = CalenderController()
//      newCalender.callback = {
//        (beatCount) in
//
//        self.currentorStartDate  = RCGlobals.getFormattedDataReportVC(date: beatCount![0] as NSDate)
//        self.secondDate = ""
//        let currentFormattedDate = RCGlobals.getFormattedDataReportForLabel(date: beatCount![0] as NSDate)
//        self.reportView.calenderTextField.text = currentFormattedDate
//        self.dateArray.removeAll()
//        self.dateArray.append(RCGlobals.getFormattedDate(date: beatCount![0] as NSDate))
//      }
//      self.isRangeselected = false
//      newCalender.isRangeSelected = false
//      newCalender.view.backgroundColor = .clear
//      newCalender.modalPresentationStyle = .custom
//      self.present(newCalender, animated: true, completion: nil)
//    }
//
//    let rangedDate = { (action: UIAlertAction) -> Void in
//      let newCalender = CalenderController()
//      newCalender.callback = {
//        (beatCount) in
//
//        self.currentorStartDate  = RCGlobals.getFormattedDataReportVC(date: beatCount![0] as NSDate)
//        self.secondDate = RCGlobals.getFormattedDataReportVC(date: beatCount![1] as NSDate)
//        let firstFormattedDate = RCGlobals.getFormattedDataReportForLabel(date: beatCount![0] as NSDate)
//
//        let secondFormatteddate = RCGlobals.getFormattedDataReportForLabel(date: beatCount![1] as NSDate)
//
//        let dateStringCurrent = firstFormattedDate + " - " + secondFormatteddate
//        self.isRangeselected = true
//        self.reportView.calenderTextField.text = dateStringCurrent
//
//        self.dateArray.removeAll()
//
//        var startDate = beatCount![0] as Date
//
//        self.dateArray.append(RCGlobals.getFormattedDateWithoutConversion(date: startDate, format: "dd-MM-yyyy"))
//
//        let endDate = beatCount![1] as Date
//
//        let fmt = DateFormatter()
//        fmt.dateFormat = "dd/MM/yyyy"
//
//        while startDate < endDate {
//            print(fmt.string(from: startDate))
//            startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
//            self.dateArray.append(RCGlobals.getFormattedDateWithoutConversion(date: startDate, format: "dd-MM-yyyy"))
//        }
//
////        self.dateArray.append(RCGlobals.getFormattedDateWithoutConversion(date: endDate, format: "dd-MM-yyyy"))
//
//        print(self.dateArray)
//
//      }
//
//      newCalender.isRangeSelected = true
//      newCalender.view.backgroundColor = .clear
//      newCalender.modalPresentationStyle = .custom
//      self.present(newCalender, animated: true, completion: nil)
//    }
//
//    let alertSheet = UIAlertController(title: "Open Calendar", message: "Please select one option", preferredStyle: .actionSheet)
//    alertSheet.addAction(UIAlertAction(title: "Single Date", style: .default, handler: singleDate))
//    alertSheet.addAction(UIAlertAction(title: "Ranged Date", style: .default, handler: rangedDate))
//    alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//    present(alertSheet, animated: true, completion: nil)
//
//  }
//
//
//  func checkForSegmentSelectedIndex() {
//    reportView.radioBtnForKilometreReport.transform = CGAffineTransform(scaleX: 0, y: 0)
//    reportView.kilometerReport.transform = CGAffineTransform(scaleX: 0, y: 0)
//    reportView.radioButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//    reportView.selectAllLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
//  }
//
//  override func viewWillAppear(_ animated: Bool) {
//    rowsForTableView()
//  }
//
//  @IBAction func valueChange(_ sender: UISegmentedControl){
//    stopsReportData = nil
//    tripsReportData = nil
//    summaryReportData = nil
//
//
//    switch sender.selectedSegmentIndex {
//    case 0:
//      reportView.radioBtnForKilometreReport.transform = CGAffineTransform(scaleX: 0, y: 0)
//      reportView.radioBtnForKilometreReport.isSelected = false
//      reportView.kilometerReport.transform = CGAffineTransform(scaleX: 0, y: 0)
//      reportView.radioButton.isSelected = false
//      reportView.vechileTextField.isEnabled = true
//      reportView.radioButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//      reportView.selectAllLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
//      checkForVehicleText()
//      reportView.tripsTableView.isHidden = true
//      reportView.backgroundView.isHidden = false
//      isKilometreReportSelected = false
//
//    case 1:
//      reportView.radioBtnForKilometreReport.transform = CGAffineTransform(scaleX: 0, y: 0)
//      reportView.radioBtnForKilometreReport.isSelected = false
//      reportView.kilometerReport.transform = CGAffineTransform(scaleX: 0, y: 0)
//      reportView.radioButton.isSelected = false
//      reportView.vechileTextField.isEnabled = true
//      reportView.radioButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//      reportView.selectAllLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
//      checkForVehicleText()
//      reportView.tripsTableView.isHidden = true
//      reportView.backgroundView.isHidden = false
//      isKilometreReportSelected = false
//
//    default:
//      reportView.radioBtnForKilometreReport.transform = .identity
//      reportView.kilometerReport.transform = .identity
//      reportView.radioButton.transform = .identity
//      reportView.selectAllLabel.transform = .identity
//      reportView.tripsTableView.isHidden = true
//      reportView.backgroundView.isHidden = false
//    }
//    reportView.tripsTableView.reloadData()
//
//  }
//
//  func checkForVehicleText() {
//    if reportView.vechileTextField.text == "All vehicles" {
//      reportView.vechileTextField.text = ""
//    } else {
//      print("other")
//    }
//  }
//
//  override func viewWillDisappear(_ animated: Bool) {
//    self.overlayButton.removeFromSuperview()
//  }
//
//  @objc func selectAllVehicle(_ sender: RadioButton) {
//    if !sender.isSelected {
//      reportView.vechileTextField.text = "All vehicles"
//      reportView.vechileTextField.isEnabled = false
//      sender.isSelected = !sender.isSelected
//        self.isSelectAll = true
//    } else {
//      reportView.vechileTextField.text = ""
//      reportView.vechileTextField.isEnabled = true
//      sender.isSelected = !sender.isSelected
//        self.isSelectAll = false
//    }
//
//  }
//
//    @objc func selectKmReport(_ sender: RadioButton) {
//       if !sender.isSelected {
//          isKilometreReportSelected = true
//
//
//
//         //reportView.vechileTextField.text = "All vehicles"
//         //reportView.vechileTextField.isEnabled = false
//         sender.isSelected = !sender.isSelected
//       } else {
//        isKilometreReportSelected = false
//        // reportView.vechileTextField.text = ""
//        // reportView.vechileTextField.isEnabled = true
//         sender.isSelected = !sender.isSelected
//       }
//
//
//     }
//
//  //    func setupDatePicker() {
//  //        datePicker = MIDatePicker.getFromNib()
//  //        dateFormatter.dateFormat = "yyy/MM/dd"
//  //        datePicker.delegate = self
//  //        datePicker.config.startDate = Date()
//  //        datePicker.config.animationDuration = 0.25
//  //        datePicker.config.cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel")
//  //        datePicker.config.confirmButtonTitle = NSLocalizedString("Confirm", comment: "Confirm")
//  //        datePicker.config.contentBackgroundColor = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
//  //        datePicker.config.headerBackgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
//  //        datePicker.config.confirmButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
//  //        datePicker.config.cancelButtonColor = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
//  //    }
//
//  func setUpPickerViews() -> Void {
//
//    // Overlay view constraints setup
//
//    overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//    overlayButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//    overlayButton.alpha = 0
//
//    overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
//
//    if !overlayButton.isDescendant(of: reportView) { reportView.addSubview(overlayButton) }
//
//    overlayButton.translatesAutoresizingMaskIntoConstraints = false
//
//    reportView.addConstraints([
//      NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: reportView, attribute: .bottom, multiplier: 1, constant: 0),
//      NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: reportView, attribute: .top, multiplier: 1, constant: 0),
//      NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: reportView, attribute: .leading, multiplier: 1, constant: 0),
//      NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: reportView, attribute: .trailing, multiplier: 1, constant: 0)
//      ]
//    )
//
//
//    devicesPicker.showsSelectionIndicator = true
//    devicesPicker.delegate = self
//    devicesPicker.dataSource = self
//    devicesPicker.tag = 1
//
//    let toolBar = UIToolbar()
//    toolBar.barStyle = UIBarStyle.default
//    toolBar.isTranslucent = true
//    toolBar.tintColor = .black
//    toolBar.sizeToFit()
//
//    let doneButton = UIBarButtonItem(title: "Done".toLocalize, style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
//    let titleButton = UIBarButtonItem(title: "Select Vehicle".toLocalize, style:UIBarButtonItemStyle.plain, target: nil, action: nil)
//    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//
//    toolBar.setItems([titleButton, spaceButton, doneButton], animated: false)
//    toolBar.isUserInteractionEnabled = true
//
//    reportView.vechileTextField.inputAccessoryView = toolBar
//  }
//
//  @objc func selectVehicle(){
//    self.overlayButton.alpha = 1
//  }
//
//  @IBAction func cancelButtonDidTapped(_ sender: AnyObject) {
//    self.overlayButton.alpha = 0
//    //        self.overlayButton.removeFromSuperview()
//    reportView.vechileTextField.endEditing(true)
//  }
//
//  @objc func donePicker(){
//    self.overlayButton.alpha = 0
//    if(reportView.vechileTextField.text?.count == 0 && allDevices.count > 0) {
//      selectedVehicleIndex = 0
//      reportView.vechileTextField.text = allDevices[0].name
//    }
//    reportView.vechileTextField.endEditing(true)
//  }
//
//  @objc func userSelectionTapped(_ sender: UIButton) {
//    let tree = TreeViewController()
//    tree.isReportView = true
//    present(tree, animated: true, completion: nil)
//  }
//
//  private func rowsForTableView() {
//    if selectedUserId != nil {
//      var filterDevices: [Int] = []
//      let allParentUsers:[ParentUsers] = usersHierarchy!.allUsers
//      for user in allParentUsers {
//        if user.parentUsers.contains(where: { $0.childId == selectedUserId }) {
//          let childUser = user.parentUsers.filter { $0.childId == selectedUserId }
//          if childUser.first?.childUserDevices != nil {
//            filterDevices += (childUser.first?.childUserDevices?.devices.map { Int($0)!})!
//          }
//        }
//      }
//      let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("allDevices"))
//      allDevices = RCGlobals.getExpiryFilteredList(data ?? [])
//      allDevices = allDevices.filter{ filterDevices.contains($0.id) }
//    }
//    reportView.userSelection.text = selectedUserName
//  }
//
//  //    @objc func selectDate(){
//  //        datePicker.show(inVC:self, completion:nil)
//  //    }
//
//  @objc func searchButton(_ sender: UIButton) {
//    if reportView.radioButton.isSelected {
//      allVehicleReports()
//    } else {
//      singleVehicleReport()
//    }
//  }
//
//  fileprivate func allVehicleReports() {
//    if (reportView.calenderTextField.text?.isEmpty)! {
//      self.showalert("Please select date".toLocalize)
//    } else {
//      let ids = allDevices.map( { String($0.id) } ).joined(separator: ",")
//        deviceCounter = 0
//        deviceIdArray.removeAll()
//        for device in allDevices {
//            let keyValuePos = "Position_" + "\(device.id ?? 0)"
//            let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
//            if  devPostition != nil {
//                deviceIdArray.append("\(device.id ?? 0)")
//            }
//        }
//      print(ids)
//      getSummaryReport(devicesID: ids)
//      reportView.tripsTableView.isHidden = false
//      reportView.backgroundView.isHidden = true
//    }
//  }
//
//  fileprivate func singleVehicleReport() {
//    if (reportView.calenderTextField.text?.isEmpty)! && (reportView.vechileTextField.text?.isEmpty)! {
//      self.showalert("Please select date and your vehicle".toLocalize)
//    }else if (reportView.calenderTextField.text?.isEmpty)!{
//      self.showalert("Please select a date".toLocalize)
//    }else if (reportView.vechileTextField.text?.isEmpty)!{
//      self.showalert("Please select your vehicle".toLocalize)
//    }else{
//        deviceCounter = 0
//        deviceIdArray.removeAll()
//        deviceIdArray.append("\(allDevices[selectedVehicleIndex].id!)")
//      switch reportView.segmentedController.selectedSegmentIndex {
//      case 0:
//        getStopsReport(devicesID: String(allDevices[selectedVehicleIndex].id!))
//        reportView.tripsTableView.isHidden = false
//        reportView.backgroundView.isHidden = true
//      case 1:
//        getTripsReport(devicesID: String(allDevices[selectedVehicleIndex].id!))
//        reportView.tripsTableView.isHidden = false
//        reportView.backgroundView.isHidden = true
//      case 2:
//        getSummaryReport(devicesID: String(allDevices[selectedVehicleIndex].id!))
//        reportView.tripsTableView.isHidden = false
//        reportView.backgroundView.isHidden = true
//      default:
//        getSummaryReport(devicesID: String(allDevices[selectedVehicleIndex].id!))
//        reportView.tripsTableView.isHidden = false
//        reportView.backgroundView.isHidden = true
//      }
//    }
//  }
//
//  func getStopsReport(devicesID: String) {
//
//    RCLocalAPIManager.shared.getStopsReport(with: devicesID, startDate: currentorStartDate, endDate: secondDate, success: { [weak self] hash in
//      guard self != nil else {
//        return
//      }
//
//      self?.stopsReportData = hash
//      self?.reportView.tripsTableView.delegate = self
//      self?.reportView.tripsTableView.dataSource = self
//      self?.reportView.tripsTableView.register(StopsViewCell.self, forCellReuseIdentifier: "stopsIdentifier")
//      self?.reportView.tripsTableView.reloadData()
//    }) { [weak self] message in
//      guard let weakSelf = self else { return }
//      weakSelf.stopsReportData = nil
//      weakSelf.reportView.tripsTableView.reloadData()
//      weakSelf.prompt(message)
//    }
//  }
//
//  func getTripsReport(devicesID: String) {
//    RCLocalAPIManager.shared.getTripsReport(with: devicesID, reportDate: currentorStartDate, endDate: secondDate, success: {
//      [weak self] hash  in
//      guard self != nil else { return }
//      self?.tripsReportData = hash
//      self?.reportView.tripsTableView.delegate = self
//      self?.reportView.tripsTableView.dataSource = self
//      self?.reportView.tripsTableView.register(DateViewCell.self, forCellReuseIdentifier: "tripsIdentifier")
//      self?.reportView.tripsTableView.reloadData()
//        self?.markerList.removeAll()
//        self?.showAdditionalInfoProgress("Fetching additional Info...")
//        let date = self?.dateArray[self?.dateCounter ?? 0]
//        let deviceId = self?.deviceIdArray[self?.deviceCounter ?? 0]
//        self?.getDeviceMarkersForDate(date: date!, deviceId: deviceId!)
//
//    }) { [weak self] message in
//      guard let weakSelf = self else { return }
//      weakSelf.tripsReportData = nil
//      weakSelf.reportView.tripsTableView.reloadData()
//      weakSelf.prompt(message)
//    }
//  }
//
//  func getSummaryReport(devicesID: String) {
//    RCLocalAPIManager.shared.getSummaryReport(with: devicesID, reportDate: currentorStartDate, endDate: secondDate, isRangeSelected: isRangeselected, success:  { [weak self] hash in
//      guard self != nil else { return }
//
//      self?.setDateForSummary(hash)
//
//          }) { [weak self] message in
//      guard let weakSelf = self else { return }
//      weakSelf.summaryReportData = nil
//      weakSelf.reportView.tripsTableView.reloadData()
//      weakSelf.prompt(message)
//    }
//  }
//
//    func showAdditionalInfoProgress (_ message: String) {
//        let topWindow = UIApplication.shared.keyWindow
//        HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
//        HUD?.animationType = .fade
//        HUD?.mode = .indeterminate
//        HUD?.labelText = message
//    }
//
//    func hideAdditionalInfoProgress () {
//        HUD?.hide(true)
//    }
//
//  func setDateForSummary(_ data:SummaryReportModel) {
//    self.summaryReportData = data
//    self.reportView.tripsTableView.delegate = self
//    self.reportView.tripsTableView.dataSource = self
//    self.reportView.tripsTableView.register(DateViewCell.self, forCellReuseIdentifier: "tripsIdentifier")
//    self.reportView.tripsTableView.reloadData()
//
//    self.showAdditionalInfoProgress("Fetching additional Info...")
//    self.markerList.removeAll()
//    let date = self.dateArray[self.dateCounter]
//    let deviceId = self.deviceIdArray[self.deviceCounter]
//    self.getDeviceMarkersForDate(date: date, deviceId: deviceId)
//  }
//
//  @objc func backTapped() {
//   self.dismiss(animated: true, completion: nil)
//  }
//  override var prefersStatusBarHidden: Bool {
//    return true
//  }
//
//  override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Dispose of any resources that can be recreated.
//  }
//
//
//
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    reportView.calenderTextField.resignFirstResponder()
//    reportView.vechileTextField.resignFirstResponder()
//  }
//
//}
//
//
//
//extension ReportViewController: UITextFieldDelegate {
//    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    reportView.calenderTextField.resignFirstResponder()
//    reportView.vechileTextField.resignFirstResponder()
//    return true
//  }
//
//  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//    if textField == self.reportView.calenderTextField {
//      setupCalendar()
//      return false //do not show keyboard
//    }
//    return true
//  }
//}
//
//extension ReportViewController: UITableViewDelegate {
//
////      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
////      {
////          let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 7))
////          headerView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
////          return headerView
////      }
////
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    let navController = ReportMapsViewController()
//    navController.reportType = reportView.segmentedController.selectedSegmentIndex
//    switch reportView.segmentedController.selectedSegmentIndex {
//    case 0:
//      navController.stopsReportData = stopsReportData.data?[indexPath.section]
//      tableView.deselectRow(at: indexPath, animated: true)
//         self.navigationController?.pushViewController(navController, animated:true)
//    case 1:
//
//        let startDate = RCGlobals.getDateChinaToLocalFromString((tripsReportData.data?[indexPath.section].startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//        let endDate = RCGlobals.getDateChinaToLocalFromString((tripsReportData.data?[indexPath.section].endTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//
//        let markerImageList = RCGlobals.getFilteredMarkerListWithTimeLimit(markerList: self.markerList, startTime: startDate, endTime: endDate, deviceId: (tripsReportData.data?[indexPath.section].deviceId)!)
//
//      navController.tripsReportData = tripsReportData.data?[indexPath.section]
//        navController.markerImages = markerImageList
//      tableView.deselectRow(at: indexPath, animated: true)
//         self.navigationController?.pushViewController(navController, animated:true)
//    case 2:
//        if isKilometreReportSelected == false {
//
//            let markerImageList = RCGlobals.getFilteredMarkerList(markerList: self.markerList, deviceId: (summaryReportData.data?[indexPath.section].deviceId)!)
//
//            navController.summaryReportData = summaryReportData.data?[indexPath.section]
//            navController.markerImages = markerImageList
//            tableView.deselectRow(at: indexPath, animated: true)
//            self.navigationController?.pushViewController(navController, animated:true)
//        }
//    default:
//      navController.stopsReportData = stopsReportData.data?[indexPath.section]
//      tableView.deselectRow(at: indexPath, animated: true)
//         self.navigationController?.pushViewController(navController, animated:true)
//    }
//
//  }
//
////  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////    var returnHeight = 0
////    //if isKilometreReportSelected == false {
//////    if UIDevice().userInterfaceIdiom == .phone {
//////      switch UIScreen.main.nativeBounds.height {
//////      case 1136:
//////        returnHeight = 30
//////      case 1334:
//////        returnHeight = 60
//////      case 1920, 2208:
//////        returnHeight = 100
//////      case 2436:
//////        returnHeight = 200
//////      default:
//////        returnHeight = 50
//////      }
//////    }
//////    return  (tableView.frame.height - CGFloat(returnHeight))
//////    } else {
//////
//////      return 40
//////    }
////
////    return autom
////  }
//}
//
//
//extension ReportViewController: UITableViewDataSource {
//  func numberOfSections(in tableView: UITableView) -> Int {
//    switch reportView.segmentedController.selectedSegmentIndex {
//    case 0:
//      if stopsReportData == nil {
//        return 0
//      }else {
//        return stopsReportData.data?.count ?? 0
//      }
//    case 1:
//      if tripsReportData == nil {
//        return 0
//      }else {
//        return tripsReportData.data?.count ?? 0
//      }
//    case 2:
//      if isKilometreReportSelected == true {
//
//        if summaryReportData == nil {
//               return 0
//             }else {
//               return 1
//             }
//
//      } else {
//      if summaryReportData == nil {
//        return 0
//      }else {
//        return summaryReportData.data?.count ?? 0
//      }
//      }
//    default:
//      return 0
//    }
//  }
//
////  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
////
////   // if isKilometreReportSelected == true {
////         let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 30))
////         view.backgroundColor = .clear
////
////         return view
////    //}
////
////    //return nil
////
////     }
//
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 1
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    let customView = UIView()
//    customView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
//
//    switch reportView.segmentedController.selectedSegmentIndex {
//    case 0:
//      let stopsCell = tableView.dequeueReusableCell(withIdentifier: "stopsIdentifier", for: indexPath) as! StopsViewCell
//
//      let startDate = RCGlobals.getDateChinaToLocalFromString((stopsReportData.data?[indexPath.section].startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//      let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
//      let timeLabel = RCGlobals.getFormattedDate(date: startDate, format: "h:mm a")
//      stopsCell.dateLabel.text = dateLabel
//      stopsCell.leftLabel.text = timeLabel
//      let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((stopsReportData.data?[indexPath.section].latitude)! as NSString).doubleValue, longitude: ((stopsReportData.data?[indexPath.section].longitude)! as NSString).doubleValue)
//
//      let coords : CLLocation = CLLocation(latitude: ((self.stopsReportData.data?[indexPath.section].latitude)! as NSString).doubleValue, longitude: ((self.stopsReportData.data?[indexPath.section].longitude)! as NSString).doubleValue)
//
//      var pointOfInterestLocation: String = ""
//      let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
//
//      if geofences?.count != 0 {
//
//        for geofence in geofences! {
//
//          if pointOfInterestLocation == "" {
//            pointOfInterestLocation = self.getCoordinates(geofenceToShow: geofence, deviceLocation: coords) ?? ""
//          }
//
//          // pointOfInterestLocation = geofenceName ?? ""
//
//        }
//
//      }
//
//      let geocoder = GMSGeocoder()
//      geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
//        if self.stopsReportData == nil {
//          return
//        }
//        if error != nil {
//          if pointOfInterestLocation == "" {
//
//            stopsCell.leftTextView.text = self.stopsReportData.data?[indexPath.section].address?.toLocalize
//          } else {
//            stopsCell.leftTextView.text = pointOfInterestLocation
//          }
//
//        }
//        guard let address = response?.firstResult(), let lines = address.lines else { return }
//
//        if pointOfInterestLocation == "" {
//          stopsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
//        } else {
//          stopsCell.leftTextView.text = pointOfInterestLocation
//        }
//        //stopsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
//
//
//        self.stopsReportData.data?[indexPath.section].address = lines.joined(separator: " ")
//      }
//      stopsCell.showdistaceLabel.text = RCGlobals.convertDistanceWithoutRoundOff(distance: Double(stopsReportData.data?[indexPath.section].distance ?? "0")!)
//      stopsCell.showtimeLabel.text = RCGlobals.convertTime(miliseconds: Int(stopsReportData.data?[indexPath.section].duration ?? "0")!)
//      stopsCell.showaverageLabel.text = RCGlobals.convertSpeed(speed: Float(stopsReportData.data?[indexPath.section].averageSpeed ?? "0.0")!)
//      stopsCell.layer.cornerRadius = 20
//      stopsCell.selectionStyle = .none
//      return stopsCell
//
//
//    case 1:
//      let tripsCell = tableView.dequeueReusableCell(withIdentifier: "tripsIdentifier", for: indexPath) as! DateViewCell
//
//      let startDate = RCGlobals.getDateChinaToLocalFromString((tripsReportData.data?[indexPath.section].startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//      let endDate = RCGlobals.getDateChinaToLocalFromString((tripsReportData.data?[indexPath.section].endTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//      let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
//      let starttimeLabel = RCGlobals.getFormattedDate(date: startDate, format: "h:mm a")
//      let endtimeLabel = RCGlobals.getFormattedDate(date: endDate, format: "h:mm a")
//
//      tripsCell.dateLabel.text = dateLabel
//      tripsCell.leftLabel.text = starttimeLabel
//      tripsCell.rightLabel.text = endtimeLabel
//      let startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((tripsReportData.data?[indexPath.section].startLat)! as NSString).doubleValue, longitude: ((tripsReportData.data?[indexPath.section].startLon)! as NSString).doubleValue)
//
//      let startcoords : CLLocation = CLLocation(latitude: ((tripsReportData.data?[indexPath.section].startLat)! as NSString).doubleValue, longitude: ((tripsReportData.data?[indexPath.section].startLon)! as NSString).doubleValue)
//
//      var pointOfInterestLocationStart: String = ""
//      let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
//
//      if geofences?.count != 0 {
//
//        for geofence in geofences! {
//
//          if pointOfInterestLocationStart == "" {
//            pointOfInterestLocationStart = self.getCoordinates(geofenceToShow: geofence, deviceLocation: startcoords) ?? ""
//          }
//
//          // pointOfInterestLocation = geofenceName ?? ""
//
//        }
//
//      }
//
//
//      let endCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((tripsReportData.data?[indexPath.section].endLat)! as NSString).doubleValue, longitude: ((tripsReportData.data?[indexPath.section].endLon)! as NSString).doubleValue)
//
//      let endcoords : CLLocation = CLLocation(latitude: ((tripsReportData.data?[indexPath.section].endLat)! as NSString).doubleValue, longitude: ((tripsReportData.data?[indexPath.section].endLon)! as NSString).doubleValue)
//
//      var pointOfInterestLocationEnd: String = ""
//      //let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
//
//      if geofences?.count != 0 {
//
//        for geofence in geofences! {
//
//          if pointOfInterestLocationEnd == "" {
//            pointOfInterestLocationEnd = self.getCoordinates(geofenceToShow: geofence, deviceLocation: endcoords) ?? ""
//          }
//
//          // pointOfInterestLocation = geofenceName ?? ""
//
//        }
//
//      }
//
//      let geocoder = GMSGeocoder()
//      geocoder.reverseGeocodeCoordinate(startCoordinate) { (response, error) in
//        if self.tripsReportData == nil {
//          return
//        }
//        if error != nil {
//
//          if pointOfInterestLocationStart == "" {
//            tripsCell.leftTextView.text = self.tripsReportData.data?[indexPath.section].startAddress ?? "No address".toLocalize
//          } else {
//            tripsCell.leftTextView.text = pointOfInterestLocationStart
//          }
//
//          // tripsCell.leftTextView.text = self.tripsReportData.data?[indexPath.section].startAddress ?? "No address".toLocalize
//        }
//        guard let address = response?.firstResult(), let lines = address.lines else { return }
//
//        if pointOfInterestLocationStart == "" {
//          tripsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
//        } else {
//          tripsCell.leftTextView.text = pointOfInterestLocationStart
//        }
//
//        //tripsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
//
//        self.tripsReportData.data?[indexPath.section].startAddress = lines.joined(separator: " ")
//      }
//      geocoder.reverseGeocodeCoordinate(endCoordinate) { (response, error) in
//        if self.tripsReportData == nil {
//          return
//        }
//        if error != nil {
//          //tripsCell.rightTextView.text = self.tripsReportData.data?[indexPath.section].endAddress ?? "No address".toLocalize
//          if pointOfInterestLocationEnd == "" {
//            tripsCell.rightTextView.text = self.tripsReportData.data?[indexPath.section].endAddress ?? "No address".toLocalize
//          } else {
//            tripsCell.rightTextView.text = pointOfInterestLocationEnd
//          }
//
//        }
//        guard let address = response?.firstResult(), let lines = address.lines else { return }
//        //tripsCell.rightTextView.text = lines.joined(separator: " ").toLocalize
//        if pointOfInterestLocationEnd == "" {
//          tripsCell.rightTextView.text = lines.joined(separator: " ").toLocalize
//        } else {
//          tripsCell.rightTextView.text = pointOfInterestLocationEnd
//        }
//
//        self.tripsReportData.data?[indexPath.section].endAddress = lines.joined(separator: " ")
//      }
//
//      let startTime = RCGlobals.getFormattedDateFromString(datetime: (tripsReportData.data?[indexPath.section].startTime)!, pattern: "yyyy-MM-dd HH:mm:ss") as NSDate
//      let endTime = RCGlobals.getFormattedDateFromString(datetime: (tripsReportData.data?[indexPath.section].endTime)!, pattern: "yyyy-MM-dd HH:mm:ss") as NSDate
//
//      let markerImageList = RCGlobals.getFilteredMarkerListWithTimeLimit(markerList: self.markerList, startTime: startTime, endTime: endTime, deviceId: (tripsReportData.data?[indexPath.section].deviceId)!)
//
//      tripsCell.showmarkerLabel.text = "\(markerImageList.count)"
//
//      let tapGesture = CustomTapGestureRecognizer(target: self,action: #selector(downloadTapped(sender:)))
//
//      tapGesture.markersArray = markerImageList
//
//      tripsCell.photoView.addGestureRecognizer(tapGesture)
//
//      if markerImageList.count > 0 {
//        tripsCell.photoView.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 169/255, alpha: 1.0)
//      } else {
//        tripsCell.photoView.backgroundColor = .lightGray
//      }
//
//      tripsCell.carNameLabel.text = ""
//      tripsCell.showdistaceLabel.text = RCGlobals.convertDistanceWithoutRoundOff(distance: Double(tripsReportData.data?[indexPath.section].distance ?? "0")!)
//      tripsCell.showtimeLabel.text = RCGlobals.convertTime(miliseconds: Int(tripsReportData.data?[indexPath.section].duration ?? "0")!)
//      tripsCell.showaverageLabel.text = RCGlobals.convertSpeed(speed: Float(tripsReportData.data?[indexPath.section].averageSpeed ?? "0")!)
//      tripsCell.layer.cornerRadius = 20
//      tripsCell.selectionStyle = .none
//      return tripsCell
//    case 2:
//
//      if isKilometreReportSelected == false {
//      let tripsCell = tableView.dequeueReusableCell(withIdentifier: "tripsIdentifier", for: indexPath) as! DateViewCell
//
//      let startDate = RCGlobals.getDateChinaToLocalFromString((summaryReportData.data?[indexPath.section].startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//      let endDate = RCGlobals.getDateChinaToLocalFromString((summaryReportData.data?[indexPath.section].endTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//      let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
//      let starttimeLabel = RCGlobals.getFormattedDate(date: startDate, format: "h:mm a")
//      let endtimeLabel = RCGlobals.getFormattedDate(date: endDate, format: "h:mm a")
//
//      if reportView.radioButton.isSelected {
//        tripsCell.carNameLabel.text = summaryReportData.data?[indexPath.section].deviceName
//      } else {
//        tripsCell.carNameLabel.text = ""
//      }
//      tripsCell.dateLabel.text = dateLabel
//      tripsCell.leftLabel.text = starttimeLabel
//      tripsCell.rightLabel.text = endtimeLabel
//      let startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((summaryReportData.data?[indexPath.section].startLat)! as NSString).doubleValue, longitude: ((summaryReportData.data?[indexPath.section].startLon)! as NSString).doubleValue)
//
//      let startcoords : CLLocation = CLLocation(latitude: ((summaryReportData.data?[indexPath.section].startLat)! as NSString).doubleValue, longitude: ((summaryReportData.data?[indexPath.section].startLon)! as NSString).doubleValue)
//
//      var pointOfInterestLocationStart: String = ""
//      let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
//
//      if geofences?.count != 0 {
//
//        for geofence in geofences! {
//
//          if pointOfInterestLocationStart == "" {
//            pointOfInterestLocationStart = self.getCoordinates(geofenceToShow: geofence, deviceLocation: startcoords) ?? ""
//          }
//
//          // pointOfInterestLocation = geofenceName ?? ""
//
//        }
//
//      }
//
//
//      let endCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ((summaryReportData.data?[indexPath.section].endLat)! as NSString).doubleValue, longitude: ((summaryReportData.data?[indexPath.section].endLon)! as NSString).doubleValue)
//
//      let endcoords : CLLocation = CLLocation(latitude: ((summaryReportData.data?[indexPath.section].endLat)! as NSString).doubleValue, longitude: ((summaryReportData.data?[indexPath.section].endLon)! as NSString).doubleValue)
//
//      var pointOfInterestLocationEnd: String = ""
//      //let geofences = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
//
//      if geofences?.count != 0 {
//
//        for geofence in geofences! {
//
//          if pointOfInterestLocationEnd == "" {
//            pointOfInterestLocationEnd = self.getCoordinates(geofenceToShow: geofence, deviceLocation: endcoords) ?? ""
//          }
//
//          // pointOfInterestLocation = geofenceName ?? ""
//
//        }
//
//      }
//
//      let geocoder = GMSGeocoder()
//      geocoder.reverseGeocodeCoordinate(startCoordinate) { (response, error) in
//        if self.summaryReportData == nil {
//          return
//        }
//        if error != nil {
//
//          if pointOfInterestLocationStart == "" {
//            tripsCell.leftTextView.text = self.summaryReportData.data?[indexPath.section].startAddress ?? "No address".toLocalize
//          } else {
//            tripsCell.leftTextView.text = pointOfInterestLocationStart
//          }
//
//          //                        tripsCell.leftTextView.text = self.summaryReportData.data?[indexPath.section].startAddress ?? "No address".toLocalize
//        }
//        guard let address = response?.firstResult(), let lines = address.lines else { return }
//
//        if pointOfInterestLocationStart == "" {
//          tripsCell.leftTextView.text =  lines.joined(separator: " ").toLocalize
//        } else {
//          tripsCell.leftTextView.text = pointOfInterestLocationStart
//        }
//        //tripsCell.leftTextView.text = lines.joined(separator: " ").toLocalize
//        self.summaryReportData.data?[indexPath.section].startAddress = lines.joined(separator: " ")
//      }
//      geocoder.reverseGeocodeCoordinate(endCoordinate) { (response, error) in
//        if self.summaryReportData == nil {
//          return
//        }
//        if error != nil {
//          //tripsCell.rightTextView.text = self.summaryReportData.data?[indexPath.section].endAddress ?? "No address".toLocalize
//
//          if pointOfInterestLocationEnd == "" {
//            tripsCell.rightTextView.text = self.summaryReportData.data?[indexPath.section].endAddress ?? "No address".toLocalize
//          } else {
//            tripsCell.rightTextView.text = pointOfInterestLocationEnd
//          }
//        }
//        guard let address = response?.firstResult(), let lines = address.lines else { return }
//        //tripsCell.rightTextView.text = lines.joined(separator: " ").toLocalize
//        if pointOfInterestLocationEnd == "" {
//          tripsCell.rightTextView.text = lines.joined(separator: " ").toLocalize
//        } else {
//          tripsCell.rightTextView.text = pointOfInterestLocationEnd
//        }
//        self.summaryReportData.data?[indexPath.section].endAddress = lines.joined(separator: " ")
//      }
//
//        let markerImageList = RCGlobals.getFilteredMarkerList(markerList: self.markerList, deviceId: (summaryReportData.data?[indexPath.section].deviceId)!)
//
//        tripsCell.showmarkerLabel.text = "\(markerImageList.count)"
//
//        let tapGesture = CustomTapGestureRecognizer(target: self,action: #selector(downloadTapped(sender:)))
//
//        tapGesture.markersArray = markerImageList
//
//        tripsCell.photoView.addGestureRecognizer(tapGesture)
//
//        if markerImageList.count > 0 {
//          tripsCell.photoView.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 169/255, alpha: 1.0)
//        } else {
//          tripsCell.photoView.backgroundColor = .lightGray
//        }
//
//     // tripsCell.leftTextView.text = summaryReportData.data?[indexPath.section].startAddress ?? "No address".toLocalize
//     // tripsCell.rightTextView.text = summaryReportData.data?[indexPath.section].endAddress ?? "No address".toLocalize
//      tripsCell.showdistaceLabel.text = RCGlobals.convertDistance(distance: Double(summaryReportData.data?[indexPath.section].distance ?? "0")!)
//      tripsCell.showtimeLabel.text = "24 Hrs"
//      tripsCell.showaverageLabel.text = RCGlobals.convertSpeed(speed: Float(summaryReportData.data?[indexPath.section].averageSpeed ?? "0")!)
//      tripsCell.layer.cornerRadius = 20
//      tripsCell.selectionStyle = .none
//      return tripsCell
//      } else {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "KilometreTableViewCell", for: indexPath) as! KilometreTableViewCell
//
//        print("indexpath row is \(indexPath.row)")
//               print("count is \(count)")
//        let appDarkTheme = UIColor(red: 38/255, green: 39/255, blue: 58/255, alpha: 1.0)
//        cell.backgroundColor = appDarkTheme
//        cell.selectionStyle = .none
//
//
//        var datasum: [SummaryReportModelData] = []
//        var kiloms : [String] = []
//
//
//        if let summaryData = summaryReportData.data {
//
//        for data in summaryData {
//          datasum.append(data)
//          let startDate = RCGlobals.getDateChinaToLocalFromString((data.startTime)!, format: "yyyy-MM-dd HH:mm:ss") as NSDate
//          let dateLabel = RCGlobals.getFormattedDate(date: startDate, format: "MMMM dd, yyyy")
//          let dist = RCGlobals.convertDistanceWithoutRoundOff(distance: Double(data.distance ?? "0")!)
//
//          let stringDatePlusKm = dateLabel + "          " + dist
//          kiloms.append(stringDatePlusKm)
//
//
//        }
//
//
//          cell.titleLabel.text = summaryReportData.data?[indexPath.section].deviceName
//          cell.setup(names: kiloms)
//
//        }
//
//           return cell
//     }
//
//    default:
//      let tripsCell = tableView.dequeueReusableCell(withIdentifier: "tripsIdentifier", for: indexPath) as! DateViewCell
//      tripsCell.dateLabel.text = "November 07, 2017"
//      tripsCell.layer.cornerRadius = 20
//      tripsCell.selectionStyle = .none
//      return tripsCell
//    }
//
//  }
//
//    @objc
//    func downloadTapped(sender: CustomTapGestureRecognizer) {
////        print(sender.markersArray)
//
//        let markers : [MarkerFirebaseModel]  = sender.markersArray
//        if  markers.count > 0 {
//            handleImageDownloads(indexMarkerList : markers)
//        } else {
//            self.prompt("There are no markers available to download for this report.")
//        }
//    }
//
//    func handleImageDownloads(indexMarkerList: [MarkerFirebaseModel]) {
//        showAdditionalInfoProgress("Downloading images...")
//        markerDownloadCounter = 0
//        imageDownloadCounter = 0
//        downloadMarkerImages(indexMarkerList[self.markerDownloadCounter], indexMarkerList)
//    }
//
//    func downloadMarkerImages(_ markerFirebaseModel: MarkerFirebaseModel, _ indexMarkerList: [MarkerFirebaseModel]) {
//        markerDownloadCounter += 1
//        imageDownloadCounter = 0
//        downloadImages(markerFirebaseModel.imagePathList![self.imageDownloadCounter], markerFirebaseModel, indexMarkerList)
//    }
//
//    func downloadImages(_ imageUrl: String, _ markerFirebaseModel: MarkerFirebaseModel, _ indexMarkerList: [MarkerFirebaseModel]) {
//        imageDownloadCounter += 1
//        let storage = Storage.storage()
//
//        let httpsReference = storage.reference(forURL: imageUrl)
//
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//
//        let time = NSDate()
//
//        let dateTime = RCGlobals.getFormattedDate(date: time, format: "yyyy_MM_ddHH_mm_ss", zone:NSTimeZone.system)
//
//        let fileName : String = "\(markerFirebaseModel.deviceId ?? "0")_\(dateTime)_\(imageDownloadCounter)"
//
//        let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent("\(fileName).png")
//
//        _ = httpsReference.write(toFile: destinationPath) { url, error in
//            if error != nil {
//            // Uh-oh, an error occurred!
//                self.downloadFailCounter += 1
//                self.handleRestImages(markerFirebaseModel,indexMarkerList)
//            } else {
//            // Local file URL for "images/island.jpg" is returned
//                self.handleRestImages(markerFirebaseModel, indexMarkerList)
//            }
//        }
//    }
//
//    func handleRestImages(_ markerFirebaseModel: MarkerFirebaseModel, _ indexMarkerList: [MarkerFirebaseModel]) {
//        if  self.imageDownloadCounter < markerFirebaseModel.imagePathList!.count {
//            self.downloadImages(markerFirebaseModel.imagePathList![imageDownloadCounter], markerFirebaseModel, indexMarkerList)
//        } else {
//            if  self.markerDownloadCounter < indexMarkerList.count {
//                downloadMarkerImages(indexMarkerList[markerDownloadCounter], indexMarkerList)
//            } else {
//                self.hideAdditionalInfoProgress()
//                self.imageDownloadCounter = 0
//                self.markerDownloadCounter = 0
//                if  downloadFailCounter > 0 {
//                    self.prompt("Unable to download some images")
//                } else {
//                    self.prompt("All images downloaded successfully.")
//                }
//            }
//        }
//    }
//
//
//  func getCoordinates(geofenceToShow : GeofenceModel, deviceLocation: CLLocation)  -> String? {
//
//    var nameOfGeofence = ""
//
//    if geofenceToShow.area?.uppercased().range(of:"POLYGON") != nil {
//      let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area!)
//      //                var locations: [CLLocationCoordinate2D] = []
//      //                for i in stride(from: 0, to: coordinates.count, by: 2) {
//      //                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
//      //                }
//      let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
//
//      let radius = Double(coordinates[2])!
//      let center = locations
//
//      let distanceFromCenter = deviceLocation.distance(from: center)
//
//      if distanceFromCenter > radius {
//        // outside
//
//
//      } else {
//
//        nameOfGeofence = geofenceToShow.name ?? "unnamed Point Of Interest"
//
//        // inside
//      }
//
//    } else if geofenceToShow.area?.uppercased().range(of:"CIRCLE") != nil {
//      let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area!)
//      let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
//
//      let radius = Double(coordinates[2])!
//      let center = locations
//
//      let distanceFromCenter = deviceLocation.distance(from: center)
//
//      if distanceFromCenter > radius {
//        // outside
//
//
//      } else {
//
//        nameOfGeofence = geofenceToShow.name ?? "unnamed Point Of Interest"
//
//        // inside
//      }
//
//    } else if geofenceToShow.area?.uppercased().range(of:"LINESTRING") != nil {
//      let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area!)
//      //                var locations: [CLLocationCoordinate2D] = []
//      //                for i in stride(from: 0, to: coordinates.count, by: 2) {
//      //                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
//      //                }
//      let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
//      let radius = Double(coordinates[2])!
//      let center = locations
//
//      let distanceFromCenter = deviceLocation.distance(from: center)
//
//      if distanceFromCenter > radius {
//        // outside
//
//
//      } else {
//
//        nameOfGeofence = geofenceToShow.name ?? "unnamed Point Of Interest"
//
//        // inside
//      }
//
//
//    }
//
//    return nameOfGeofence
//
//  }
//
//
//  func reverseGeocoding(latiude: String, longitude: String, cell: UITableViewCell, identifier: String) {
//    var addressText = ""
//    let doubleLat = (latiude as NSString).doubleValue
//    let doubleLong = (longitude as NSString).doubleValue
//    let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: doubleLat, longitude: doubleLong)
//    let geocoder = GMSGeocoder()
//    geocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
//      guard let address = response?.firstResult(), let lines = address.lines else { return }
//      addressText = lines.joined(separator: " ")
//      print(addressText)
//    }
//  }
//
//}
//
//extension ReportViewController: UIPickerViewDelegate {
//
//  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//    return 50
//  }
//
//  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//    if allDevices.count > 0 {
//      return allDevices[row].name!
//    } else {
//      return nil
//    }
//
//  }
//
//  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//    selectedVehicleIndex = row
//    print(row)
//    if allDevices.count > 0 {
//      reportView.vechileTextField.text = allDevices[row].name
//    } else {
//      return
//    }
//  }
//}
//
//
//extension ReportViewController: UIPickerViewDataSource {
//
//  func numberOfComponents(in pickerView: UIPickerView) -> Int {
//    return 1
//  }
//
//  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    return allDevices.count
//  }
//
//}
//
////extension ReportViewController: MIDatePickerDelegate {
////
////    func miDatePicker(_ amDatePicker: MIDatePicker, didSelect date: Date) {
////        reportView.calenderTextField.text = dateFormatter.string(from: date)
////        let aString = dateFormatter.string(from: date)
////        selectedDate = aString.replacingOccurrences(of:"/", with:"-")
////    }
////
////    func miDatePickerDidCancelSelection(_ amDatePicker: MIDatePicker) {
////
////    }
////}
//
//extension ReportViewController : SelectedUserHierarchyDelegate {
//  func selectedUser(userId: String?, userName: String?) {
//    selectedUserId = userId
//    selectedUserName = userName ?? "Users".toLocalize
//  }
//}
//
//class CustomTapGestureRecognizer: UITapGestureRecognizer {
//    var markersArray: [MarkerFirebaseModel] = []
//}
//
//
//
//

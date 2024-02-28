//
//  DashboardController.swift
//  Bolt
//
//  Created by Saanica Gupta on 31/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftCharts
import DefaultsKit
import Realm
import RealmSwift
import Charts

class DashboardController: UIViewController , UITextFieldDelegate
, UISearchBarDelegate {
    let dashboardView = DashboardView()
    let cell = "cell"
    var filterdata = [String]()
    var searching = false
    var vehicleview: VehicleView!
    var geofenceView:geofenceTableView!
//    //MARK: properties
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    var isFenceInsideTapped = false
    var arrayTotalDistance : [RealmSevenDayDistanceModel] = []
    var selectedIndexPath = 0
    var isVehicleSelected:Bool = false
    
    
    var ignitionOnCount: Int = 0
    var ignitionOffCount: Int = 0
    var notActiveCount: Int = 0
    var geofenceInArray = [TrackerDevicesMapperModel]()
    var geofenceOutArray = [TrackerDevicesMapperModel]()
    var allDevices = [TrackerDevicesMapperModel]()
    var allDevicesNameArray = [String]()
    var realm: Realm!
    var monthlyDistanceDict = [String:String]()
    
    var inActiveCountTenMins = 0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.02) {
            self.vehicleview.isHidden = false
        }
        self.vehicleview.vehicleTableView.reloadData()
    }
    
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view .backgroundColor = .appbackgroundcolor
        addNavigationBar()
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        allDevices = RCGlobals.getExpiryFilteredList(data)
        addview()
        addlabel()
        addCircularRing()
        addbutton()
        addConstraints()
        addvehicleview()
        addGeofenceview()
//        findIndividulSevenDayDistance()
//        findMonthlyDistance()
        call7DaysDistanceApi()
        addActions()
     
    }
    func addActions() {
        let totalVehicleGuesture = UITapGestureRecognizer(target: self, action: #selector(showTotalVehicle(_:)))
        totalVehicleGuesture.numberOfTouchesRequired = 1
        dashboardView.totalVehiclesContainerView.addGestureRecognizer(totalVehicleGuesture)
        
        let inactiveVehicleGuesture = UITapGestureRecognizer(target: self, action: #selector(showOffline(_:)))
        inactiveVehicleGuesture.numberOfTouchesRequired = 1
        dashboardView.inactiveContainerView.addGestureRecognizer(inactiveVehicleGuesture)
        
        let insideFenceVehicleGuesture = UITapGestureRecognizer(target: self, action: #selector(showInsideFenceVehicle(_:)))
        insideFenceVehicleGuesture.numberOfTouchesRequired = 1
        dashboardView.insidefenceContainerView.addGestureRecognizer(insideFenceVehicleGuesture)
        
        let outsideFenceVehicleGuesture = UITapGestureRecognizer(target: self, action: #selector(showOutsideFenceVehicle(_:)))
        outsideFenceVehicleGuesture.numberOfTouchesRequired = 1
        dashboardView.outsideContainerView.addGestureRecognizer(outsideFenceVehicleGuesture)
        
        let circularRingFirstGuesture = UITapGestureRecognizer(target: self, action: #selector(showInactive(_:)))
        circularRingFirstGuesture.numberOfTouchesRequired = 1
        dashboardView.Inactivelab.addGestureRecognizer(circularRingFirstGuesture)

        
        let circularRingSecondGuesture = UITapGestureRecognizer(target: self, action: #selector(showIgnitionOnVehicle(_:)))
        circularRingSecondGuesture.numberOfTouchesRequired = 1
        dashboardView.IgnitionOnlab.addGestureRecognizer(circularRingSecondGuesture)
        
        let circularRingThirdGuesture = UITapGestureRecognizer(target: self, action: #selector(showIgnitionOffVehicle(_:)))
        circularRingThirdGuesture.numberOfTouchesRequired = 1
        dashboardView.IgnitionOfflab.addGestureRecognizer(circularRingThirdGuesture)

    }
    @objc func showInactive(_ sender:UITapGestureRecognizer) {
        Defaults().set(vehicleSelectedState.inactive.rawValue, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
        let controller = ViewController()
        controller.isDashboardCalled = true
        self.view.window?.rootViewController = controller
    }
    @objc func showIgnitionOnVehicle(_ sender:UITapGestureRecognizer) {
        Defaults().set(vehicleSelectedState.ignitionOn.rawValue, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
        let controller = ViewController()
        controller.isDashboardCalled = true
        self.view.window?.rootViewController = controller
    }
    @objc func showIgnitionOffVehicle(_ sender:UITapGestureRecognizer) {
        Defaults().set(vehicleSelectedState.ignitionOff.rawValue, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
        let controller = ViewController()
        controller.isDashboardCalled = true
        self.view.window?.rootViewController = controller
    }
    @objc func showTotalVehicle(_ sender:UITapGestureRecognizer) {
        Defaults().set(vehicleSelectedState.all.rawValue, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
        let controller = ViewController()
        controller.isDashboardCalled = true
        self.view.window?.rootViewController = controller
    }
    @objc func showOffline(_ sender:UITapGestureRecognizer) {
        Defaults().set(vehicleSelectedState.offline.rawValue, for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue))
        let controller = ViewController()
        controller.isDashboardCalled = true
        self.view.window?.rootViewController = controller
    }
    @objc func showInsideFenceVehicle(_ sender:UITapGestureRecognizer){
        print("insidebtn tapp")
        isFenceInsideTapped = true
        geofenceView.insideGeofenceLabel.text = "Inside geofence"
        UIView.animate(withDuration: 0.02) {
            self.geofenceView.isHidden = false
        }
        self.geofenceView.geofenceTableView.reloadData()
    }
    @objc func showOutsideFenceVehicle(_ sender:UITapGestureRecognizer){
        print("outsidebtn tapp")
        isFenceInsideTapped = false
        geofenceView.insideGeofenceLabel.text = "Outside geofence"
        UIView.animate(withDuration: 0.02) {
            self.geofenceView.isHidden = false
        }
        
        self.geofenceView.geofenceTableView.reloadData()
    }
    
    @objc func namefieldaction(){
        print("tapp")
        
        UIView.animate(withDuration: 0.02) {
            self.vehicleview.isHidden = false
        }
        self.vehicleview.vehicleTableView.reloadData()
        
    }
    
    func call7DaysDistanceApi() {
        //RCLocalAPIManager.shared.mon
        let currentDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let startDateString = RCGlobals.getFormattedDate(date: endDate! as NSDate)
        let endDateString = RCGlobals.getFormattedDate(date: currentDate as NSDate)
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        
        let devicesAll = RCGlobals.getExpiryFilteredList(data)
        
        var deviceId : String = ""
        
        for dev in devicesAll {
            deviceId.append(String(dev.id))
            deviceId.append(",")
        }
        
        
        RCLocalAPIManager.shared.get7DayDistanceDevice(startDate: startDateString,
                                                       endDate: endDateString, deviceIdString: deviceId,
                                                       success: { (_) in
                                                        self.callMonthlyDistanceApi()
                                                        print("success in getting monthly distance")
        }) { (_) in
            self.callMonthlyDistanceApi()
            print("failure in getting monthly distance")
        }
    }
    
    func callMonthlyDistanceApi() {
        //RCLocalAPIManager.shared.mon
        
        let endDate = Date()
        let currentDate = endDate.startOfMonth() //Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let startDateString = RCGlobals.getFormattedDate(date: currentDate as NSDate)
        let endDateString = RCGlobals.getFormattedDate(date: endDate as NSDate)
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        
        let devicesAll = RCGlobals.getExpiryFilteredList(data)
        
        //        var deviceId : String = ""//chnages doone now
        
        for dev in devicesAll {
            deviceId.append(String(dev.id))
            deviceId.append(",")
        }
        
        
        RCLocalAPIManager.shared.getMonthlyDistanceDevice(startDate: startDateString,
                                                          endDate: endDateString, deviceIdString: deviceId,
                                                          success: { (_) in
                                                            
                                                            print("success in getting monthly distance")

                                                            self.findIndividulSevenDayDistance()
                                                            self.findMonthlyDistance()
                                                            self.dashboardView.graphCollectionView.reloadData()
        }) { (_) in
            print("failure in getting monthly distance")
        }
    }
    
    func findMonthlyDistance() {
        
        for device in allDevices {
            monthlyDistanceDict.updateValue("0.0Km", forKey: "\(device.id!)")
        }
        
        let distanceSevenDayData = realm.objects(RealmTotalDistanceMonthlyModelData.self).toArray()
        
        for device in allDevices {
            let distanceObjects = distanceSevenDayData.filter {
                (($0.device_id!.contains("\(device.id!)")))
            }
            
            
            var distancePerDevice = 0.0
            
            for i in distanceObjects {
                
                let DistanceString = i.distance //?? "0.0"
                let distanceDouble = Double(DistanceString) ?? 0.0
                distancePerDevice += distanceDouble
                let distanceInKm = distancePerDevice/1000
                let distRounded = distanceInKm.rounded(toPlaces: 2)
                monthlyDistanceDict.updateValue("\(distRounded)Km", forKey: "\(device.id!)")
            }
            
        }
    }
    
    func findIndividulSevenDayDistance() {
        
        try! realm = Realm()
        var axisPoints = [String:String]()
        for i in 0...8 {
            let endDate = Calendar.current.date(byAdding: .day, value: -i, to: Date())
            axisPoints.updateValue("", forKey: "device_ID")
            let currentDateInFormat = RCGlobals.getFormattedDataReportVC(date: endDate! as NSDate)
            axisPoints.updateValue("0.0", forKey: currentDateInFormat)
        }
        for device in allDevices {
            
            let distanceSevenDayData = realm.objects(TotalDistanceRealmModelData.self).toArray()
            
            let distanceObjects = distanceSevenDayData.filter {
                (($0.device_id!.contains("\(device.id!)")))
            }
            
            let distanceObjectSorted = distanceObjects.sorted(by: {RCGlobals.getDateFromTwo($0.start_time!) < RCGlobals.getDateFromTwo($1.start_time!)} )
            
            var distancePerDevice = 0.0
            axisPoints.updateValue("\(device.id!)", forKey: "device_ID")
            axisPoints.updateValue("\(device.name!)", forKey: "device_Name")
            
            if  distanceObjectSorted.count > 0 {
                
                for i in distanceObjectSorted {
                    
                    
                    let DistanceString = i.distance //?? "0.0"
                    let distanceDouble = Double(DistanceString) ?? 0.0
                    //                let timeDate = RCGlobals.getStringDateFromStringDsh(i.start_time ?? "")
                    let istDate = RCGlobals.convertUTCToIST(i.start_time ?? "", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd")
                    //                distancePerDevice += distanceDouble
                    for key in axisPoints.keys {
                        if key == istDate {
                            let distInKm = distanceDouble/1000
                            axisPoints.updateValue("\(distInKm)", forKey: key)
                        }
                        //                    else {
                        //                        if key != "device_ID" && key != "device_Name" {
                        //                            axisPoints.updateValue("0", forKey: key)
                        //                        }
                        //                    }
                    }
                    
                }
            } else {
                for key in axisPoints.keys {
                    if key != "device_ID" && key != "device_Name" {
                        axisPoints.updateValue("0", forKey: key)
                    }
                }
            }
            
//            let distKm = distancePerDevice/1000
            
            
            let offline = RealmSevenDayDistanceModel()
            offline.device_id = axisPoints["device_ID"]
            offline.deviceName = axisPoints["device_Name"]
            let endDate = Calendar.current.date(byAdding: .day, value: -8, to: Date())
            let currentDateInFormat = RCGlobals.getFormattedDataReportVC(date: endDate! as NSDate)
            offline.y1 = axisPoints["\(currentDateInFormat)"] ?? "0.0"
            
            let endDate1 = Calendar.current.date(byAdding: .day, value: -7, to: Date())
            let currentDateInFormat1 = RCGlobals.getFormattedDataReportVC(date: endDate1! as NSDate)
            offline.y2 = axisPoints["\(currentDateInFormat1)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat1)"] ?? "0.0") ?? 0
            
            let endDate2 = Calendar.current.date(byAdding: .day, value: -6, to: Date())
            let currentDateInFormat2 = RCGlobals.getFormattedDataReportVC(date: endDate2! as NSDate)
            offline.y3 = axisPoints["\(currentDateInFormat2)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat2)"] ?? "0.0") ?? 0
            
            let endDate3 = Calendar.current.date(byAdding: .day, value: -5, to: Date())
            let currentDateInFormat3 = RCGlobals.getFormattedDataReportVC(date: endDate3! as NSDate)
            offline.y4 = axisPoints["\(currentDateInFormat3)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat3)"] ?? "0.0") ?? 0
            
            let endDate4 = Calendar.current.date(byAdding: .day, value: -4, to: Date())
            let currentDateInFormat4 = RCGlobals.getFormattedDataReportVC(date: endDate4! as NSDate)
            offline.y5 = axisPoints["\(currentDateInFormat4)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat4)"] ?? "0.0") ?? 0
            
            let endDate5 = Calendar.current.date(byAdding: .day, value: -3, to: Date())
            let currentDateInFormat5 = RCGlobals.getFormattedDataReportVC(date: endDate5! as NSDate)
            offline.y6 = axisPoints["\(currentDateInFormat5)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat5)"] ?? "0.0") ?? 0
            
            let endDate6 = Calendar.current.date(byAdding: .day, value: -2, to: Date())
            let currentDateInFormat6 = RCGlobals.getFormattedDataReportVC(date: endDate6! as NSDate)
            offline.y7 = axisPoints["\(currentDateInFormat6)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat6)"] ?? "0.0") ?? 0
            
            let endDate7 = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            let currentDateInFormat7 = RCGlobals.getFormattedDataReportVC(date: endDate7! as NSDate)
            offline.y8 = axisPoints["\(currentDateInFormat7)"] ?? "0.0"
            
            distancePerDevice += Double(axisPoints["\(currentDateInFormat7)"] ?? "0.0") ?? 0
            
            offline.totalSevenDayDistance = "\(distancePerDevice)"
            
            DBManager.shared.addDataUpdate(object: offline)
        }
        
        
        let objects = realm.objects(RealmSevenDayDistanceModel.self)
        arrayTotalDistance = objects.toArray()
        
        
    }
    
    private func addNavigationBar() {
//        let appearance  = UINavigationBar.appearance()
//        appearance.barTintColor = .appbackgroundcolor
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func findTotalDistanceForAllDevices() -> String {
        
        var totalDistanceNew = 0.0
        
        for device in allDevices {
            
            let keyValue = "Position_" + "\(device.id ?? 0)"
            let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
            
            if let totalDistance = devicePosition?.attributes?.totalDistance {
                let prevOdometer = Double(device.attributes?.prevOdometer ?? 0)
                
                totalDistanceNew = totalDistanceNew + (totalDistance - prevOdometer)/1000
                
            }
        }
        
        let distanceTotalRounded = totalDistanceNew.rounded(toPlaces: 2)
        return "\(distanceTotalRounded)"
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterdata.removeAll(keepingCapacity: true)
        let filter = NSPredicate(format: "self contains[c] %@",
                                 vehicleview.resultautoSearchController.text!)
        
        let array = (allDevicesNameArray as NSArray).filtered(using: filter)
        filterdata = array as! [String]
        
        if filterdata.count == 0 {
            searching = false
            
        } else {
            
            searching = true
            
        }
        
        self.vehicleview.vehicleTableView.reloadData()
    }
    
    func scrollAutomaticallyLeft() {
        
        if let coll  = dashboardView.graphCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if (((indexPath?.row ?? 0)) < allDevicesNameArray.count){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! - 1, section: (indexPath?.section)!)
                    
                    dashboardView.leftbutton.isHidden = (indexPath1?.row == 0)
                    dashboardView.rightbutton.isHidden = (indexPath1?.row == (allDevicesNameArray.count-1))
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
    }

    
    func addvehicleview() {
        
        vehicleview = VehicleView(frame: view.bounds)
        vehicleview.backgroundColor = .clear
        self.view.addSubview(vehicleview)
        vehicleview.isHidden = true
        vehicleview.vehicleTableView.register(VehicleTableViewCell.self,
                                              forCellReuseIdentifier: "cell")
        vehicleview.vehicleTableView.isScrollEnabled = true
        vehicleview.vehicleTableView.delegate = self
        vehicleview.vehicleTableView.dataSource = self
        vehicleview.resultautoSearchController.delegate = self
    }
    
    func addGeofenceview() {
        geofenceView = geofenceTableView(frame: CGRect.zero)
        geofenceView.backgroundColor = .clear
        self.geofenceView.isHidden = true
        self.view.addSubview(geofenceView)
        
        geofenceView.geofenceTableView.register(geoofenceTableViewCell.self,forCellReuseIdentifier: "geocell")
        geofenceView.geofenceTableView.isScrollEnabled = true
        geofenceView.geofenceTableView.delegate = self
        geofenceView.geofenceTableView.dataSource = self
        addGeofenceviewConstraints()
    }
    
    func addGeofenceviewConstraints() {
        geofenceView.snp.makeConstraints{(make) in
            if #available(iOS 11.0, *) {
                make.bottom.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                
                make.bottom.top.left.right.equalToSuperview()
                
            }
        }
    }
    
    func scrollAutomaticallyRight() {
        if let coll  = dashboardView.graphCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < allDevicesNameArray.count-1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1,
                                                section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    dashboardView.rightbutton.isHidden = (indexPath1?.row == (allDevicesNameArray.count-1))
                    dashboardView.leftbutton.isHidden = (indexPath1?.row == 0)
                }
                
            }
        }
    }
    
    
    func addview(){
        self.view.addSubview(dashboardView)
        
        self.dashboardView.graphCollectionView.delegate = self
        self.dashboardView.graphCollectionView.dataSource = self
        self.dashboardView.graphCollectionView.reloadData()
        self.dashboardView.graphCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func addlabel(){
        for device in allDevices {
            
            if device.lastUpdate != nil {
                if Date().timeIntervalSince(RCGlobals.getDateFor(device.lastUpdate!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor(device.lastUpdate!)) <= 86400 {
                    inActiveCountTenMins = inActiveCountTenMins + 1
                }
            }
            
            if device.lastUpdate == nil ||
                Date().timeIntervalSince(RCGlobals.getDateFor(device.lastUpdate!)) > 86400 {
                notActiveCount = notActiveCount + 1
                
            } else {
                let keyValue = "Position_" + "\(device.id ?? 0)"
                let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
                if let ignition = devicePosition?.attributes?.ignition  {
                    if ignition {
                        ignitionOnCount = ignitionOnCount + 1
                        
                    } else {
                        ignitionOffCount = ignitionOffCount + 1
                    }
                }
            }
            
            if let geofence = device.geofenceIds {
                
                if geofence.count > 0 {
                    
                    geofenceInArray.append(device)
                    
                    
                } else {
                    
                    geofenceOutArray.append(device)
                    
                }
            }
            
            allDevicesNameArray.append(device.name ?? "")
        }
        
        let dist = findTotalDistanceForAllDevices()
        dashboardView.distance.text = "\(dist)" + "Km"
        let totalVehicleCount = allDevices.count
        dashboardView.totalVehiclesDataLabel.text = "\(totalVehicleCount)"
        dashboardView.insidefenceDataLabel.text = "\(geofenceInArray.count)"
        dashboardView.inactiveDataLabel.text = "\(notActiveCount)"
        dashboardView.outsideDataLabel.text = "\(geofenceOutArray.count)"
        dashboardView.selectVehicleTextField.delegate = self
        dashboardView.Inactivelab.text = "Inactive (10 mins)"
    }
    
    func addCircularRing(){
        let totalCount = allDevices.count
        dashboardView.circularRing.denominator = totalCount
        dashboardView.circularRing2.denominator = totalCount
        dashboardView.circularRing3.denominator = totalCount
        dashboardView.circularRing.numerator = inActiveCountTenMins
        dashboardView.circularRing2.numerator = ignitionOnCount
        dashboardView.circularRing3.numerator = ignitionOffCount
    }
    
    func addConstraints(){
        dashboardView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
        
    }
    
    func addbutton(){
        
        dashboardView.leftbutton.addTarget(self, action: #selector(leftbtnAction), for: .touchUpInside)
        
        dashboardView.rightbutton.addTarget(self, action: #selector(rightbtnAction), for: .touchUpInside)
         dashboardView.cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
    }
    
    @objc func leftbtnAction(){
        scrollAutomaticallyLeft()
        print("left pressed")
    }
    @objc func rightbtnAction(){
        scrollAutomaticallyRight()
        print("right pessed ")
    }
    @objc func cancelBtnAction(){
        dashboardView.selectVehicleTextField.text = "Select Vehicle"
        self.isVehicleSelected = false
        dashboardView.graphCollectionView.reloadData()
    }
    
    
}

extension DashboardController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
extension DashboardController:UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) ->  Int {
        return  allDevicesNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = dashboardView.graphCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.backgroundColor = .white
        var realmObject:TrackerDevicesMapperModel // = allDevices[indexPath.row]
        if isVehicleSelected {
            realmObject = allDevices[self.selectedIndexPath]
        } else {
            realmObject = allDevices[indexPath.row]
            self.dashboardView.cancelBtn.isHidden = true
        }
        cell.collectionView.name.font = UIFont.systemFont(ofSize: 20)
        let objectDistance = arrayTotalDistance.filter({$0.device_id == "\(realmObject.id!)"}).first
        cell.collectionView.name.text = realmObject.name
        cell.collectionView.thismonthdistance.text = monthlyDistanceDict["\(realmObject.id!)"] 
        if let dataObject = objectDistance {
            let distance = Double(dataObject.totalSevenDayDistance ?? "0")?.rounded(toPlaces: 2)
            cell.collectionView.lastdaydistance.text = "\(distance ?? 0) Km "
            
            var objectsY = [Double(dataObject.y8)!,Double(dataObject.y7)!,Double(dataObject.y6)!,Double(dataObject.y5)!,Double(dataObject.y4)!,Double(dataObject.y3)!,Double(dataObject.y2)!]
            
            objectsY.reverse()
            
            setDataCount(objectsY, cell.collectionView.lineChartView)
            
        }
        
        //        cell.addchart()
        return cell
    }
    
    func setDataCount(_ objects:[Double],_ chartView:LineChartView) {
        let values = (0..<objects.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: objects[i], icon: #imageLiteral(resourceName: "sos"))
        }
        
        let set1 = LineChartDataSet(entries: values, label: "Distance")
        
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 0]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(UIColor(red:48.0/255.0, green: 174.0/255.0, blue: 159.0/255.0, alpha:1))
        set1.setCircleColor(.white)
        set1.valueTextColor = .white
        set1.lineWidth = 2
        set1.circleRadius = 4
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        set1.drawFilledEnabled = false
        
        chartView.legend.textColor = .white
        
        let data = LineChartData(dataSet: set1)
        
        chartView.data = data
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
}

extension UIColor {
    static let appbackgroundcolor = UIColor(red:38/255 , green:39/255 ,blue:58/255, alpha:1.0)
    static let appviewbgcolor = UIColor(red: 29/255, green: 28/255, blue: 42/255, alpha: 1.0)
    
}
class MyCollectionViewCell: UICollectionViewCell{
    var collectionView: DashboardCollectionView!
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    var circleColors = [NSUIColor]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        addviewcell()
        addConstraintsCell()
    }
    
    func addviewcell(){
        collectionView = DashboardCollectionView()
        collectionView.backgroundColor = .appbackgroundcolor
        self.contentView.addSubview(collectionView)
        
    }
    
    func addConstraintsCell() {
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.contentView.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- VehicleTableView
extension DashboardController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalRow:Int!
        
        if tableView == self.vehicleview.vehicleTableView {
            if searching {
                totalRow = filterdata.count
            } else {
                totalRow = allDevices.count
            }
        }
        
        if tableView == self.geofenceView.geofenceTableView {
            
            if isFenceInsideTapped == false {
                totalRow = geofenceOutArray.count
            } else {
                totalRow = geofenceInArray.count
            }
        }
        
        return totalRow
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:VehicleTableViewCell!
        var cell2:geoofenceTableViewCell!
        if tableView == self.vehicleview.vehicleTableView {
            cell = vehicleview.vehicleTableView.dequeueReusableCell(withIdentifier: "cell") as? VehicleTableViewCell
            if searching {
                cell.itemnameLabel!.text = filterdata[indexPath.row]
            }
            else {
                cell.itemnameLabel!.text = allDevicesNameArray[indexPath.row]
            }
            return cell
        }
        
        if tableView == self.geofenceView.geofenceTableView {
            cell2 = geofenceView.geofenceTableView.dequeueReusableCell(withIdentifier: "geocell") as? geoofenceTableViewCell
            if isFenceInsideTapped == false {
                geofenceView.insideGeofenceLabel.text = "Outside geofence"
                cell2.cellitemLabel.text = geofenceOutArray[indexPath.row].name
            } else {
                geofenceView.insideGeofenceLabel.text = "Inside geofence"
                cell2.cellitemLabel.text = geofenceInArray[indexPath.row].name
            }
            return cell2
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
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if tableView == self.vehicleview.vehicleTableView{
            print("You selected cell #\(indexPath.row)")
            
            if searching {
                dashboardView.selectVehicleTextField.text =   filterdata[indexPath.row]
            } else {
                dashboardView.selectVehicleTextField.text = allDevicesNameArray[indexPath.row]
            }
            self.view.endEditing(true)
            self.selectedIndexPath = indexPath.row
            self.isVehicleSelected = true
            self.dashboardView.cancelBtn.isHidden = false
            self.dashboardView.graphCollectionView.reloadData()
            UIView.animate(withDuration: 0.02) {
                self.vehicleview.isHidden = true
            }
        }
        
        if tableView == self.geofenceView.geofenceTableView {
            UIView.animate(withDuration: 0.02) {
                self.geofenceView.isHidden = true
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}


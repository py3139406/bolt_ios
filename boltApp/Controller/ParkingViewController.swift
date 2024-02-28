//
//  ParkingViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

var globalPark = 0
var globalParkName = ""

class ParkingViewController: UIViewController {
    
    
    var isParkingOn = false
    var parkingview: ParkingView!
    let cellId = "PARKINGCELLID"
    var allDevices: [TrackerDevicesMapperModel]!
    var listOfDevicesToshow: [TrackerDevicesMapperModel] = []
    var onlineDeviceStatusIds = [Int]() // to show green icon againt vechile name
    var isParkedOn = false
    var isParkingModeOn : Bool!
    var searchActive : Bool = false
    var filtered:[TrackerDevicesMapperModel]!
     var isSchedularOn:Bool = false
     var parkingTimerData : [String] = []
    let duration = 5.0
    var lightOnTimer:Timer!
    var lightOffTimer:Timer!
    var oneTime:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewAndButtonFuctions()
        parkingview.searchBar.delegate = self
        addDoneButtonOnKeyboard()
        isParkingModeOn = UserDefaults.standard.bool(forKey: "isParkingModeOn")
        if isParkingModeOn == false {
            self.tabBarItem.selectedImage = UIImage(named: "parkingModeWhite")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
            self.tabBarItem.image = UIImage(named: "parkingModeonTabBar")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
        }
        else {
            self.tabBarItem.selectedImage = UIImage(named: "parking_icon")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
            self.tabBarItem.image = UIImage(named: "parking_icon")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
        }
        getParkingTimeScheduler()
        
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        parkingview.searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        parkingview.searchBar.endEditing(true)
    }
    func  getParkingTimeScheduler(){
        Defaults().clear(Key<Bool>("parkingScheduler"))
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        let allDevices: [TrackerDevicesMapperModel] = RCGlobals.getExpiryFilteredList(data)
        
        
        RCLocalAPIManager.shared.getParkingSchedule(deviceID: 0, loadingMessage: "", success: { (park) in
            let eventsData: [DataClass] = park.data!
            Defaults().set(eventsData, for: Key<[DataClass]>("parkingScheduler"))
            self.updateListTimeScheduler()
        }) { [weak self] message in
            guard self != nil else {
                return
            }
            print("\(message)")
           // weakself.view.makeToast("no data")
        }
    }
    func updateListTimeScheduler(){
        parkingTimerData.removeAll()
        let parkingScheduleData = Defaults().get(for: Key<[DataClass]>("parkingScheduler")) ?? []
        for item in parkingScheduleData {
            if item.parking_schedule ?? false {
                parkingTimerData.append("\(item.device_id ?? 0)")
            }
        }
        self.parkingview.parkingtableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        parkingSyncRequest(loading:"")
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("diddisappear")
    }
    func addViewAndButtonFuctions() {
        parkingview = ParkingView()
        parkingview.backgroundColor = .white
        view.addSubview(parkingview)
        addConstraints()
        view.backgroundColor = appGreenTheme
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
        allDevices = RCGlobals.getExpiryFilteredList(data ?? [])
        
        parkingview.parkingtableView.register(ParkingTableViewCell.self, forCellReuseIdentifier: cellId)
        parkingview.parkingtableView.delegate = self
        parkingview.parkingtableView.dataSource = self
        parkingview.infoButton.addTarget(self, action: #selector(infoBtnAction(_:)), for: .touchUpInside)
        parkingview.syncVehicleModeButton.addTarget(self, action: #selector(syncParkingModeVehicle(_:)), for: .touchUpInside)
    }
    func addConstraints(){
        parkingview.snp.makeConstraints { (make) in
            if #available(iOS 11, *){
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            }else{
                make.edges.equalToSuperview()
            }
        }
    }
    @objc func infoBtnAction(_ sender:UIButton) {
        let pvc = PopUpViewController()
        pvc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChildViewController(pvc)
        self.view.addSubview(pvc.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // lightOn()
        getDevices()

    }
    // diwali themes
//    func lightOn(){
//        lightOnTimer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(openLight), userInfo: nil, repeats: false)
//    }
//    @objc func openLight() {
//        UIView.animate(withDuration: 0.0 , animations: {
//                        self.parkingview.lightImg.image =  #imageLiteral(resourceName: "ic_lights_off.png")
//            print("lighton")
//
//        }, completion: { _ in
//            self.lightOff()
//        })
//    }
//    func lightOff(){
//        lightOffTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(closeLight), userInfo: nil, repeats: false)
//    }
//
//   @objc func closeLight() {
//    UIView.animate(withDuration: 0.0 , animations: { [self] in
//
//            parkingview.lightImg.image = #imageLiteral(resourceName: "ic_lights_on.png")
//            print("light off")
//
//        } , completion: { _ in
//            self.lightOn()
//        })
//    }
    
    //<= diwali 
    
    func getDevices(){
        // last update not nill
        listOfDevicesToshow.removeAll()
        for i in allDevices {
            if i.lastUpdate != nil {
                listOfDevicesToshow.append(i)
            }
        }
        if Defaults().get(for: Key<[Int]>("onlineDeviceStatusIds")) != nil {
             onlineDeviceStatusIds  = Defaults().get(for: Key<[Int]>("onlineDeviceStatusIds"))!
        }
    }
    
    func syncParkingModeVehicle2() {
        RCLocalAPIManager.shared.syncVehicleModes(loadingMsg:"", success: { [weak self] model in
            guard let weakself = self else { return }
            weakself.syncingFunction(parkingArray: (model.data?.parkingMode)!)
            if (model.data?.parkingMode!.isEmpty)!{
                UserDefaults.standard.set(false, forKey: "isParkingModeOn")
            
            
            }else {
                
            }
        }) { [weak self] message in
            guard let weakself = self else { return }
            print("\(message)")
            weakself.view.makeToast("no data")
        }
    }
    
    @objc func syncParkingModeVehicle(_ sender: UIButton?) {
        parkingSyncRequest(loading:"Syncing...")
    }
    
    func parkingSyncRequest(loading:String){
        RCLocalAPIManager.shared.syncVehicleModes(loadingMsg:loading ,success: { [weak self] model in
            guard let weakself = self else { return }
            weakself.syncingFunction(parkingArray: (model.data?.parkingMode)!)
             if (model.data?.parkingMode!.isEmpty)! {
                self!.tabBarItem.selectedImage = UIImage(named: "parkingModeWhite")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
                self!.tabBarItem.image = UIImage(named: "parkingModeonTabBar")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
             }else {
                self!.tabBarItem.selectedImage = UIImage(named: "parking_icon")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
            self!.tabBarItem.image = UIImage(named: "parking_icon")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
             }
        }) { [weak self] message in
            guard let weakself = self else { return }
            print("\(message)")
            weakself.view.makeToast("no data")
        }
    }

    
    func syncingFunction(parkingArray: [String]) {
        onlineDeviceStatusIds = parkingArray.map({Int($0)!})
        Defaults().set(onlineDeviceStatusIds, for: Key<[Int]>("onlineDeviceStatusIds"))
        if onlineDeviceStatusIds.count > 0 {
            Defaults().set(true, for: Key<Bool>("isParkedOn"))
            UserDefaults.standard.set(true, forKey: "isParkingModeOn")
        } else {
            Defaults().set(false, for: Key<Bool>("isParkedOn"))
            UserDefaults.standard.set(false, forKey: "isParkingModeOn")
        }
        reloadTable()
    }
    func reloadTable(){
        var  parkingOnList: [TrackerDevicesMapperModel] = []
         var  parkingOffList: [TrackerDevicesMapperModel] = []
        if onlineDeviceStatusIds.count > 0 {
            for item in listOfDevicesToshow {
                if onlineDeviceStatusIds.contains(item.id){
                    parkingOnList.append(item)
                } else {
                    parkingOffList.append(item)
                }
            }
            
            parkingOnList.append(contentsOf: parkingOffList)
            
            listOfDevicesToshow = parkingOnList
            parkingview.parkingtableView.reloadData()
            
        }
        getParkingTimeScheduler()
    }
    func requestForParkingMode(id deviceId: Int, mode: String, tableCell: ParkingTableViewCell) {
        RCLocalAPIManager.shared.parkingMode(with: deviceId, mode: mode, success: { [weak self] hash in
            guard let weakSelf = self else {return }
            weakSelf.postParkingMode(cell: tableCell, deviceId: deviceId, mode: mode)
            
        }) {[weak self] message in
            guard let weakSelf = self else {return}
            weakSelf.prompt("Parking mode activation failed".toLocalize)
        }
    }
    @objc func tapOnButton(sender: UIButton) {
        let cell = sender.superview?.superview as! ParkingTableViewCell
        let index_Path = parkingview.parkingtableView.indexPath(for: cell)
        let currentDeviceModel = self.listOfDevicesToshow[(index_Path?.row)!]
        let deviceId = currentDeviceModel.id ?? 0
        let keyValue = "Position_" + "\(deviceId)"
        let devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue))
        if sender.currentImage == #imageLiteral(resourceName: "newRedNotification") {
            if let ignition = devicePosition?.attributes?.ignition {
                if ignition && currentDeviceModel.lastUpdate != nil && Date().timeIntervalSince(RCGlobals.getDateFor(currentDeviceModel.lastUpdate!)) <= 86400   {
                    let alc = UIAlertController(title: "Parking Mode".toLocalize, message: "Vehicle\'s ignition is on.\nAre you sure you want to activate parking mode for this vehicle?".toLocalize, preferredStyle: .alert)
                    let noBtn = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
                    let yesBtn = UIAlertAction(title: "Yes".toLocalize, style: .default, handler: { (_) in
                        self.requestForParkingMode(id: deviceId, mode: "on", tableCell: cell)
                    })
                    alc.addAction(noBtn)
                    alc.addAction(yesBtn)
                    present(alc, animated: true, completion: nil)
                } else if ignition == false && currentDeviceModel.lastUpdate != nil &&
                    Date().timeIntervalSince(RCGlobals.getDateFor(currentDeviceModel.lastUpdate!)) <= 86400{
                    requestForParkingMode(id: deviceId, mode: "on", tableCell: cell)
                } else {
                    requestForParkingMode(id: deviceId, mode: "on", tableCell: cell)
                }
            } else {
                requestForParkingMode(id: deviceId, mode: "on", tableCell: cell)
            }
        } else {
            requestForParkingMode(id: deviceId, mode: "off", tableCell: cell)
        }
    }
    
    @objc func parkingTimerTapped(_ sender: UIButton) {
        let cell = sender.superview?.superview as! ParkingTableViewCell
        let index_Path = parkingview.parkingtableView.indexPath(for: cell)
        let currentDeviceModel = self.listOfDevicesToshow[(index_Path?.row)!]
        let deviceId = currentDeviceModel.id ?? 0
        let nav = UINavigationController(rootViewController: ParkingModeScheduleView())
        self.present(nav, animated: true, completion: nil)
        globalParkName = cell.nameLabel.text!
        globalPark = deviceId
    }

    @objc func backTapped(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    func postParkingMode(cell: ParkingTableViewCell, deviceId: Int, mode: String) {
        if (mode == "on") {
            cell.iconImageView.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
            cell.backgroundColor = .white
            self.tabBarItem.selectedImage = #imageLiteral(resourceName: "parking_icon").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
            Defaults().set(true, for: Key<Bool>("isParkedOn"))
            UserDefaults.standard.set(true, forKey: "isParkingModeOn")
            self.onlineDeviceStatusIds.append(deviceId)
            Defaults().set(onlineDeviceStatusIds, for: Key<[Int]>("onlineDeviceStatusIds"))
        } else {
            cell.iconImageView.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
            cell.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
            self.onlineDeviceStatusIds = self.onlineDeviceStatusIds.filter(){ $0 != deviceId }
            Defaults().set(onlineDeviceStatusIds, for: Key<[Int]>("onlineDeviceStatusIds"))
            if self.onlineDeviceStatusIds.count == 0 {
                self.tabBarItem.selectedImage = UIImage(named: "parkingModeWhite")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
                self.tabBarItem.image = UIImage(named: "parkingModeonTabBar")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal)
                Defaults().set(false, for: Key<Bool>("isParkedOn"))
                UserDefaults.standard.set(false, forKey: "isParkingModeOn")
            }
        }
    }
}
extension ParkingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        } else {
         return listOfDevicesToshow.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(searchActive) {
            listOfDevicesToshow = filtered
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ParkingTableViewCell
         cell.nameLabel.text = listOfDevicesToshow[indexPath.row].name
        // update timer
        if parkingTimerData.contains("\(listOfDevicesToshow[indexPath.row].id ?? 0)"){
            cell.timerImageView.setImage(UIImage(named: "clock-2"), for: .normal)
        } else {
            cell.timerImageView.setImage(UIImage(named: "clock"), for: .normal)
        }
        //<-
        cell.iconImageView.addTarget(self, action: #selector(tapOnButton(sender:)), for: .touchUpInside)
        cell.timerImageView.addTarget(self, action: #selector(parkingTimerTapped(_:)), for: .touchUpInside)
        
       
        
        if onlineDeviceStatusIds.count > 0 {
            if (onlineDeviceStatusIds.contains(listOfDevicesToshow[indexPath.row].id)) {
                cell.iconImageView.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
                cell.backgroundColor = .white
            }else {
                cell.iconImageView.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                cell.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
            }
        } else {
            cell.iconImageView.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
            cell.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        }
        cell.selectionStyle = .none
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}


extension ParkingViewController: UISearchBarDelegate {
    
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.text = ""
       searchActive = false
       listOfDevicesToshow = allDevices
       searchBar.showsCancelButton = false
       reloadTable()
       searchBar.endEditing(true)
       
       
   }
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       searchBar.endEditing(true)
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       parkingview.searchBar.endEditing(true)
   }
   
   func  searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
       
       if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
           searchActive = false
           listOfDevicesToshow = allDevices
       } else {
           searchActive = true
           filtered = listOfDevicesToshow.filter({ (text) -> Bool in
               let tmp: NSString = text.name! as NSString
               let range = tmp.range(of: searchText, options: .caseInsensitive)
               return range.location != NSNotFound
           })
       }
       reloadTable()
   }
   
}

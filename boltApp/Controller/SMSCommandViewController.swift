//
//  SMSCommandViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import MessageUI
import DefaultsKit

class SMSCommandViewController: UIViewController {
    
    var data: String!
    
    var configuration: SMSCommandView!
    //for vehicleview
    var vehicleview: VehicleView!
    
    var menuTextArray = ["Overspeed Calibration"]
    var menuIcon = [ #imageLiteral(resourceName: "Configuration7"), #imageLiteral(resourceName: "Layer 2 (2)"), #imageLiteral(resourceName: "ic_ac_inactive"), #imageLiteral(resourceName: "ic_siren_inactive")]//, #imageLiteral(resourceName: "ic_siren_inactive"), #imageLiteral(resourceName: "Configuration9")]
    var allDevices:[TrackerDevicesMapperModel] = []
    var vehicleFiltered:[TrackerDevicesMapperModel] = []
    
    lazy var devicesPicker = UIPickerView()
    var overlayButton: UIButton!
    var alarm:String = ""
    var type:String = ""
    var progress: MBProgressHUD?
    var searching:Bool = false
    var selectedDevice: TrackerDevicesMapperModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterDevices()
        
        if allDevices.count > 0 {
            selectedDevice = allDevices.first
        }
        setVehicleView()
        setConstraints()
        setActions()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        getAlarmTypeAndState()
        
       
    }
    private func setConstraints(){
        configuration.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
        vehicleview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    func filterDevices() {
        allDevices = []
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
        let totalDevices = RCGlobals.getExpiryFilteredList(data ?? [])
        for item in totalDevices {
            if item.lastUpdate != nil {
                allDevices.append(item)
            }
        }
    }
    
    func  setVehicleView(){
        view.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        configuration = SMSCommandView()
        view.addSubview(configuration)
        
        vehicleview = VehicleView()
        vehicleview.backgroundColor = .clear
        self.view.addSubview(vehicleview)
        vehicleview.isHidden = true
        vehicleview.vehicleTableView.backgroundColor = .clear
        
    }
  private func setActions(){
    configuration.configurationTableView.delegate = self
    configuration.configurationTableView.dataSource = self
    configuration.configurationTableView.register(SMSViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    
    vehicleview.vehicleTableView.register(VehicleTableViewCell.self,
                                          forCellReuseIdentifier: "vehicleCell")
    vehicleview.vehicleTableView.isScrollEnabled = true
    vehicleview.vehicleTableView.delegate = self
    vehicleview.vehicleTableView.dataSource = self
    vehicleview.resultautoSearchController.delegate = self
    }
    
    func getAlarmTypeAndState() {
        let login_model: loginInfoModel? = Defaults().get(for: Key<loginInfoModel>("loginInfoModel")) ?? nil
        
        var alarmSetting :[String:String]?
        
        if login_model != nil {
            if login_model?.data?.user?.alarmSettings != nil{
                alarmSetting = (RCGlobals.convertToDictionary(text: (login_model?.data?.user?.alarmSettings)!) as! [String : String])
            }
            
        }
        if alarmSetting != nil{
            type =  alarmSetting!["type"]?.lowercased() ?? ""
            alarm = alarmSetting!["alarm"]?.lowercased() ?? ""
        }
        
    }
    
    @objc func backTapped(){
         self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTrackerViaInternet(speed: String, speedType: Bool, deviceId: Int, deviceProtocol: String) {
        RCLocalAPIManager.shared.sendOverspeedaLERT(deviceId: deviceId, speed: speed, speedType: speedType, deviceProtocolType: deviceProtocol, success: { [weak self] hash in
            guard self != nil else { return }
            
            let keyValue = "Device_" + "\(Int(self?.selectedDevice.id ?? 0))"
            let updateDevice: TrackerDevicesMapperModel = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))!
            
            let speedCurrent = Double(speed) ?? 0.0
            let speedInKnots = speedCurrent * 0.53996
            
            
            
            updateDevice.attributes?.speedLimit = "\(speedInKnots)"
            
            
            Defaults().set(updateDevice, for: Key<TrackerDevicesMapperModel>(keyValue))
            RCLocalAPIManager.shared.updateDevice(with: updateDevice, success: { [weak self] hash in
                guard self != nil else { return }
                RCLocalAPIManager.shared.getDevices(success: { [weak self] hash in
                    guard self != nil else {
                        return
                    }
                    self?.filterDevices()
                }) { [weak self] message in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.prompt("please try again")
                    print(message)
                }
                }, failure: { [weak self] message in
                    guard let weakSelf = self else { return }
                    weakSelf.prompt("please try again")
                    print(message)
            })
            
            UIApplication.shared.keyWindow?.makeToast("Vehicle updated successfully.".toLocalize, duration: 2.0, position: .bottom)
            
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.prompt("please try again")
            print(message)
        }
    }
    
    func updateAlarm(name:String, type:String, state:String) {
        let id =  "\(Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel"))?.id ?? 0)"
        let alarmParam:[String:Any] = ["name":name,"type":type,"alarm":state]
        let parameters:[String:Any] = ["alarm_settings":alarmParam]
        showProgress()
        RCLocalAPIManager.shared.updateACDoorSirenAlarm(with: parameters,userId: id, loadingMsg: "" ,success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.getLoginInfo()
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateAlarmAfterRequest()
            weakSelf.prompt("Request failed, Please try again.")
        }
    }
    
    func getLoginInfo() {
        let id =  Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel"))?.id
        RCLocalAPIManager.shared.loginInfo(with: id!,success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateAlarmAfterRequest()
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateAlarmAfterRequest()
            weakSelf.prompt("Request failed, Please try again.")
        }
    }
    
    func showProgress() {
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = "Please wait...".toLocalize
    }
    
    func hideProgress() {
        progress?.hide(true)
    }
    
    func updateAlarmAfterRequest() {
        hideProgress()
        getAlarmTypeAndState()
        configuration.configurationTableView.reloadData()
    }
    
}

extension SMSCommandViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == configuration.configurationTableView {
            return menuTextArray.count
        } else {
            if searching {
                return vehicleFiltered.count
            } else {
                return allDevices.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == configuration.configurationTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? SMSViewCell
            let title:String = menuTextArray[indexPath.row]
            // MARK: To set same height for all rows
            cell!.configToggle.setImage(#imageLiteral(resourceName: "newRedNotification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            cell?.selectionStyle = .none
            cell!.menuText.text = title
            switch title {
            case "Overspeed Calibration":
                cell!.leftIcon.image = menuIcon[indexPath.row].resizedImage(CGSize.init(width: 20 , height: 18), interpolationQuality: .default)
                cell!.configToggle.isHidden = true
            default:
                cell!.configToggle.isHidden = false
                updateToggleView(cell!.configToggle, title)
                cell!.leftIcon.image = menuIcon[indexPath.row].resizedImage(CGSize.init(width: 18 , height: 18), interpolationQuality: .default)
            }
            
            return cell!
        } else {
            let vehicleCell = tableView.dequeueReusableCell(withIdentifier: "vehicleCell", for: indexPath) as? VehicleTableViewCell
            if searching {
                vehicleCell?.itemnameLabel.text = vehicleFiltered[indexPath.row].name ?? ""
            } else {
                vehicleCell?.itemnameLabel.text = allDevices[indexPath.row].name ?? ""
            }
            return vehicleCell!
        }
    }
    
    func updateToggleView (_ sender: UIButton, _ title: String) {
        switch title {
        case "Door" :
            if type == "door" && alarm == "on" {
                sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                sender.setImage(#imageLiteral(resourceName: "newRedNotification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            sender.addTarget(self, action: #selector(doorToggleTapped(_:)), for: .touchUpInside)
            break
        case "AC" :
            if type == "ac" && alarm == "on" {
                sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                sender.setImage(#imageLiteral(resourceName: "newRedNotification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            sender.addTarget(self, action: #selector(acToggleTapped(_:)), for: .touchUpInside)
            break
        case "Siren" :
            if type == "siren" && alarm == "on" {
                sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                sender.setImage(#imageLiteral(resourceName: "newRedNotification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            sender.addTarget(self, action: #selector(sirenToggleTapped(_:)), for: .touchUpInside)
            break
        default:
            print("Do Nothing")
        }
    }
    
    @objc func doorToggleTapped(_ sender: UIButton) {
        var message:String = "off"
        if type == "door" {
            if alarm != "on" {
                message = "on"
            }
        } else {
            message = "on"
        }
        
        let alertController = UIAlertController(title: "Door Alarm", message: "Turn \(message) door alarm,\nAre you sure?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes".toLocalize, style: .destructive, handler: { alert -> Void in
            self.updateAlarm(name: "Door", type: "door", state: message)
        })
        
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func acToggleTapped(_ sender: UIButton) {
        var message:String = "off"
        if type == "ac" {
            if alarm != "on" {
                message = "on"
            }
        } else {
            message = "on"
        }
        
        let alertController = UIAlertController(title: "AC Alarm", message: "Turn \(message) ac alarm,\nAre you sure?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes".toLocalize, style: .destructive, handler: { alert -> Void in
            self.updateAlarm(name: "AC", type: "ac", state: message)
        })
        
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func sirenToggleTapped(_ sender: UIButton) {
        var message:String = "off"
        if type == "siren" {
            if alarm != "on" {
                message = "on"
            }
        } else {
            message = "on"
        }
        
        let alertController = UIAlertController(title: "Siren Alarm", message: "Turn \(message) siren alarm,\nAre you sure?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes".toLocalize, style: .destructive, handler: { alert -> Void in
            self.updateAlarm(name: "Siren", type: "siren", state: message)
        })
        
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == configuration.configurationTableView {
            switch indexPath.row {
            case 0:
//                promptOverspeed("Overspeed Calibration".toLocalize, "To turn off overspeed calibration set to 0".toLocalize)
                vehicleview.selectvehicleLabel.text = "Select Vehicle"
                vehicleview.resultautoSearchController.placeholder = "Select Vehicle"
                
                UIView.animate(withDuration: 0.02) {
                    self.vehicleview.isHidden = false
                }
                self.vehicleview.vehicleTableView.reloadData()
                
            default:
                print("Do nothing.")
            }
        }else {
            self.view.endEditing(true)
            UIView.animate(withDuration: 0.02) {
                self.vehicleview.isHidden = true
            }
            if searching {
                selectedDevice = vehicleFiltered[indexPath.row]
            } else {
                selectedDevice = allDevices[indexPath.row]
            }
            promptOverspeed("Overspeed Calibration".toLocalize, "To turn off overspeed calibration set to 0".toLocalize)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SMSCommandViewController {
    func promptOverspeed(_ title: String, _ message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveButton = UIAlertAction(title: "Save".toLocalize, style: .default) { (action) in
            let number = alert.textFields![0] as UITextField
            
            let deviceId = Int(self.selectedDevice.id ?? 0)
            let keyValue = "Position_" + "\(deviceId)"
            if let updateDevice: TrackerPositionMapperModel = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue)) {
                
                if let numberdata = number.text {
                    
                    if numberdata != "0" {
                        
                        self.updateTrackerViaInternet(speed: numberdata, speedType: true, deviceId: deviceId, deviceProtocol: updateDevice.protocl ?? "")
                    } else {
                        self.updateTrackerViaInternet(speed: "0", speedType: false, deviceId: deviceId, deviceProtocol: updateDevice.protocl ?? "")
                    }
                    
                } else {
                    self.updateTrackerViaInternet(speed: "0", speedType: false, deviceId: deviceId, deviceProtocol: updateDevice.protocl ?? "")
                }
                
            }
        }
        alert.addAction(saveButton)
        alert.addAction(UIAlertAction(title: "Cancel".toLocalize, style: .destructive, handler: nil))
        alert.addTextField { (textFields) in
            let speedValue = (Double(self.selectedDevice.attributes?.speedLimit ?? "0") ?? 0) * 1.852
            textFields.attributedPlaceholder = NSAttributedString(string: "\(speedValue.rounded(toPlaces: 1))", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
            textFields.keyboardType = .numberPad
        }
        present(alert, animated: true)
    }
}

extension SMSCommandViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        let message: String!
        switch result {
        case .cancelled:
            message = NSLocalizedString("Cancelled", comment: "Cancelled")
            print("cancelled")
        case .failed:
            message = NSLocalizedString("Failed", comment: "Failed")
            print("failed")
        case .sent:
            message = NSLocalizedString("Sent", comment: "Sent")
            print("sent")
            
        }
        
        controller.dismiss(animated:true, completion:nil)
        let alert  = UIAlertController(title: NSLocalizedString("Message", comment: "Message"), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment:"OK"), style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension SMSCommandViewController : UISearchBarDelegate {
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = NSPredicate(format: "self contains[c] %@",
                                 vehicleview.resultautoSearchController.text!)
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
        
        self.vehicleview.vehicleTableView.reloadData()
    }
}

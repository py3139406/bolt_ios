//
//  AppSettingViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import UserNotifications
import KeychainAccess
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseMessaging
var isBannerAlertSelected = true

class AppSettingViewController: UIViewController {
    //mark:- properties
    var flag = Defaults().get(for: Key<Bool>("NotificationOnOffSetting")) ?? true
    var immobilizeFlag = Defaults().get(for: Key<Bool>("ImmobilizePasswordSetting")) ?? false
    var langSelected = Defaults().get(for: Key<String>("LangSelected")) ?? "English"
    
    var menuArray = ["Language".toLocalize, "Notifications".toLocalize, "Types of notifications".toLocalize,
                     "Notification Tone".toLocalize, "Show/Hide Geofences".toLocalize,"Stop duration report".toLocalize,"Show marker label".toLocalize,"Show marker cluster".toLocalize, "Call Credits".toLocalize , "Require password for immobilization".toLocalize,"Vehicle list sort".toLocalize,"Vehicle icon size".toLocalize,"Homescreen".toLocalize]//, "Alert Configuration".toLocalize
    var appSetting =  AppSettingView()
    var cell: AppSettingViewCell!
    var newView = ColorPickerView()
    var player: AVAudioPlayer?
    let alertButton = UIButton()
    let volumeButton = UIButton()
    let alertLabel = UILabel()
    var optionchoice:String = ""
    var isPlaying:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let markerShowed = Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
        if markerShowed == false {
            Defaults().set(false,for: Key<Bool>("ShowMarkerSettings"))
        }
        self.callCalledCreditsApi()
        view.backgroundColor = .white
        appSetting = AppSettingView(frame: CGRect.zero)
        appSetting.settingMenuView.delegate = self
        appSetting.settingMenuView.dataSource = self
        appSetting.settingMenuView.register(AppSettingViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        view.addSubview(appSetting)
        setConstraints()
        self.navigationItem.title = "App Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dashicon3").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("view disappeared")
    }
    func   setConstraints(){
        appSetting.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func backTapped(){
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.callCalledCreditsApi()
    }
    
    func callCalledCreditsApi() {
        RCLocalAPIManager.shared.getUserConfig(success: { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.appSetting.settingMenuView.reloadData()
        }, failure: { [weak self] error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.appSetting.settingMenuView.reloadData()
        })
        
    }
    
}

extension AppSettingViewController {
    @objc func notificationTapped(_ sender: UIButton) {
        if flag == false {
            let closureHandler1 = { (action: UIAlertAction!) -> Void in
                sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
                self.didTapNotificationSwiter(isLogin: true)
            }
            prompt("Turn On Notifications".toLocalize, "Do you want to turn on the notifications".toLocalize, "YES".toLocalize, "NO".toLocalize, handler1: closureHandler1, handler2: { _ in })
        }
        else if flag == true {
            let closureHandler1 = { (action:UIAlertAction!) -> Void in
                sender.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
                self.didTapNotificationSwiter(isLogin: false)
            }
            prompt("Turn Off Notifications".toLocalize, "Do you want to turn off the notifications ?".toLocalize, "YES".toLocalize, "NO".toLocalize, handler1: closureHandler1, handler2: {_ in })
        }
        
    }
    @objc func immobilizePaasword(sender:UIButton){
        
        self.immobilizeFlag = Defaults().get(for: Key<Bool>("ImmobilizePasswordSetting")) ?? false
        
        let alertController = UIAlertController(title: "Enter Password", message: "Please enter password to proceed further.", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "******"
            textField.font = UIFont.systemFont(ofSize: 20)
            textField.textAlignment = .center
            textField.textColor = .black
            textField.isSecureTextEntry = true
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let alerttext =  alertController.textFields?.first?.text
            let keychain = Keychain(service: "in.roadcast.bolt")
            let password: String = {
                do {
                    return try keychain.getString("boltPassword") ?? ""
                } catch {
                    return ""
                }
            }()
            if alerttext == password {
                
                if self.immobilizeFlag == true {
                    Defaults().set(false, for: Key<Bool>("ImmobilizePasswordSetting"))
                    
                    sender.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
                    self.prompt("Successful")
                    
                } else if self.immobilizeFlag == false {
                    sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
                    Defaults().set(true, for: Key<Bool>("ImmobilizePasswordSetting"))
                    self.prompt("Successful")
                }
            }
            else{
                self.prompt("Please enter a valid password")
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func vehicleListSortLabel(_ sender:Any){
        let alert  = UIAlertController(title: "Please select vehicle list sort type", message: "", preferredStyle: .alert)
        let defaultLabel = UIAlertAction(title: "Default", style: .default) { (_) in
            Defaults().set("Default",for: Key<String>("vehicleListSortLabel"))
            self.appSetting.settingMenuView.reloadData()
        }
        let nameLabel = UIAlertAction(title: "Name", style: .default) { (_) in
            Defaults().set("Name",for: Key<String>("vehicleListSortLabel"))
            self.appSetting.settingMenuView.reloadData()
        }
        let lastUpdateLabel = UIAlertAction(title: "Last Update", style: .default) { (_) in
            Defaults().set("Last Update",for: Key<String>("vehicleListSortLabel"))
            self.appSetting.settingMenuView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .destructive)
        alert.addAction(defaultLabel)
        alert.addAction(nameLabel)
        alert.addAction(lastUpdateLabel)
        alert.addAction(cancelButton)
        //   alert.view.frame = CGRect(x: sender.bounds.origin.x, y: sender.frame.size.height, width: 200, height: 100)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func homescreenChange(_ sender:Any){
        let alert  = UIAlertController(title: "Please select vehicle list sort type", message: "", preferredStyle: .alert)
        let defaultLabel = UIAlertAction(title: "Map Screen", style: .default) { (_) in
            Defaults().set("Map Screen",for: Key<String>("homescreenLabel"))
            self.appSetting.settingMenuView.reloadData()
        }
        let nameLabel = UIAlertAction(title: "List of vehicles", style: .default) { (_) in
            Defaults().set("List of vehicles",for: Key<String>("homescreenLabel"))
            self.appSetting.settingMenuView.reloadData()
        }
        let lastUpdateLabel = UIAlertAction(title: "Dashboard", style: .default) { (_) in
            Defaults().set("Dashboard",for: Key<String>("homescreenLabel"))
            self.appSetting.settingMenuView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .destructive)
        alert.addAction(defaultLabel)
        alert.addAction(nameLabel)
       // alert.addAction(lastUpdateLabel)
        alert.addAction(cancelButton)
        //   alert.view.frame = CGRect(x: sender.bounds.origin.x, y: sender.frame.size.height, width: 200, height: 100)
        self.present(alert, animated: true, completion: nil)
    }
    @objc func vehicleIconSortLabel(){
        let alert  = UIAlertController(title: "Please select vehicle list icon size", message: "", preferredStyle: .alert)
        let defaultLabel = UIAlertAction(title: "SMALL", style: .default) { (_) in
            Defaults().set("SMALL",for: Key<String>("vehicleIconSortLabel"))
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
            self.appSetting.settingMenuView.reloadData()
        }
        let nameLabel = UIAlertAction(title: "MEDIUM", style: .default) { (_) in
            Defaults().set("MEDIUM",for: Key<String>("vehicleIconSortLabel"))
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
            self.appSetting.settingMenuView.reloadData()
        }
        let lastUpdateLabel = UIAlertAction(title: "LARGE", style: .default) { (_) in
            Defaults().set("LARGE",for: Key<String>("vehicleIconSortLabel"))
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
            self.appSetting.settingMenuView.reloadData()
        }
        let cancelButton = UIAlertAction(title: "CANCEL", style: .destructive)
        alert.addAction(defaultLabel)
        alert.addAction(nameLabel)
        alert.addAction(lastUpdateLabel)
        alert.addAction(cancelButton)
        //   alert.view.frame = CGRect(x: sender.bounds.origin.x, y: sender.frame.size.height, width: 200, height: 100)
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc func showMarker(_ sender: UIButton) {
        let markerShowed =  Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
        if markerShowed == false {
            sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
            Defaults().set(true, for: Key<Bool>("ShowMarkerSettings"))
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
        }
        else if markerShowed == true {
            sender.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
            Defaults().set(false, for: Key<Bool>("ShowMarkerSettings"))
        }
    }
    
    
    @objc func showMarkerCluster(_ sender: UIButton) {
        let markerShowed =  Defaults().get(for: Key<Bool>("ShowClusterMarkerSettings")) ?? false
        if markerShowed == false {
            sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
            Defaults().set(true, for: Key<Bool>("ShowClusterMarkerSettings"))
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
        }
        else if markerShowed == true {
            sender.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
            Defaults().set(false, for: Key<Bool>("ShowClusterMarkerSettings"))
        }
    }
    
    @objc func showGeofences() {
        self.navigationController?.pushViewController(HideGeofenceController(), animated: true)
    }
    @objc func showNotificationType() {
        self.navigationController?.pushViewController(NotificationFilterViewController(), animated: true)
    }
    
    @objc func offTickMarker(_ sender: UIButton) {
        let closureHandler2 = { (action:UIAlertAction!) -> Void in
            sender.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
            Defaults().set(false, for: Key<Bool>("ShowMarkerSettings"))
            UIApplication.shared.keyWindow?.makeToast("Marker settings updated successfully.".toLocalize, duration: 1.0, position: .bottom)
        }
        prompt("Hide Marker Label for vehicles".toLocalize, "Do you want to hide labels for vehicles".toLocalize, "YES".toLocalize, "NO".toLocalize, handler1: closureHandler2, handler2: {_ in })
    }
    
    @objc func onTickMarker(_ sender: UIButton) {
        let closureHandler2 = { (action: UIAlertAction!) -> Void in
            sender.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
            Defaults().set(true, for: Key<Bool>("ShowMarkerSettings"))
            UIApplication.shared.keyWindow?.makeToast("Marker settings updated successfully.".toLocalize, duration: 1.0, position: .bottom)
        }
        prompt("Show Marker Label for vehicles".toLocalize, "Do you want to see labels for vehicles".toLocalize, "YES".toLocalize, "NO".toLocalize, handler1: closureHandler2, handler2: { _ in })
    }
    
    func didTapNotificationSwiter(isLogin: Bool) -> Void {
        
        let username = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email ?? ""
        
        let keychain = Keychain(service: "in.roadcast.bolt")
        let password: String = {
            do {
                return try keychain.getString("boltPassword") ?? ""
            } catch {
                return ""
            }
        }()
        
        Messaging.messaging().token { result, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
                self.turnOnNotification(username, password, isLogin)
            } else if let result = result {
                print("Remote instance ID token: \(result)")
                Defaults().set(result, for: Key<String>("RCFCMToken"))
                self.turnOnNotification(username, password, isLogin)
            }
        }
        
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instance ID: \(error)")
//                self.turnOnNotification(username, password, isLogin)
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                Defaults().set(result.token, for: Key<String>("RCFCMToken"))
//                self.turnOnNotification(username, password, isLogin)
//            }
//        }
        
    }
    
    func turnOnNotification(_ username:String, _ password:String, _ isLogin:Bool) {
        RCLocalAPIManager.shared.login(loadingMsg: "", with: username, password: password , isLogin: isLogin, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            Defaults().set(isLogin, for: Key<Bool>("NotificationOnOffSetting"))
            weakSelf.flag = isLogin
            weakSelf.appSetting.settingMenuView.reloadData()
            UIApplication.shared.keyWindow?.makeToast("Notification settings updated successfully.".toLocalize, duration: 1.0, position: .bottom)
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.appSetting.settingMenuView.reloadData()
            weakSelf.prompt("please try again")
            print(message)
        }
    }
    func showTemplateView(){
        self.navigationController?.pushViewController(TemplateVC(), animated: true)
    }
    func languageSetting(x: String, y:String) {
        Bundle.setLanguage(x)
        Defaults().set(y, for: Key<String>("LangSelected"))
        RCDataManager.set(string:x, forKey:"LanguagePreference")
        self.langSelected = Defaults().get(for: Key<String>("LangSelected")) ?? "English"
        menuArray = ["Language".toLocalize, "Notifications".toLocalize, "Types of notifications".toLocalize,
                     "Notification Tone".toLocalize
            , "Show/Hide Geofences".toLocalize,"Stop duration report".toLocalize,"Show marker label".toLocalize,"Show marker cluster".toLocalize, "Call Credits".toLocalize , "Require password for immobilization".toLocalize,"Vehicle list sort".toLocalize,"Vehicle icon size".toLocalize,"Homescreen".toLocalize]//,"Alert Configuration".toLocalize
        self.appSetting.settingMenuView.reloadData()
        
    }
    func didTapSelectLanguage() -> Void {
        
        let actionSheet = UIAlertController(title:NSLocalizedString("Message", comment: "Message"), message:"", preferredStyle:.alert)
        
        actionSheet.addAction(UIAlertAction(title:"English", style:.default, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
            self.languageSetting(x: "en", y: "English")
        }))
        
        actionSheet.addAction(UIAlertAction(title:"हिंदी", style:.default, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
            self.languageSetting(x: "hi", y: "Hindi")
            
        }))
        
        actionSheet.addAction(UIAlertAction(title:"தமிழ்", style:.default, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
            self.languageSetting(x: "ta", y: "Tamil")
        }))
        
        actionSheet.addAction(UIAlertAction(title:"తెలుగు", style:.default, handler: { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
            self.languageSetting(x: "te", y: "Telugu")
        }))
        
        actionSheet.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment:"Cancel"), style:.cancel, handler:nil))
        present(actionSheet, animated:true, completion:nil)
    }
}

extension AppSettingViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            didTapSelectLanguage()
        case 3 :
            notifTone()
        case 4:
            showGeofences()
        case 2:
            showNotificationType()
        case 8:
            showCallCreditsVC()
//        case 12:
//            showTemplateView()
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    @objc func notifTone(){
        if isBannerAlertSelected {
            UNUserNotificationCenter.current().getNotificationSettings(){ (settings) in
                switch settings.alertStyle {
                    
                case .alert:
                    isBannerAlertSelected = false
                    DispatchQueue.main.async {
                        let alc = UIAlertController(title: "Message".toLocalize, message: "Notification is alredy set".toLocalize, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK".toLocalize, style: .destructive, handler: nil)
                        alc.addAction(ok)
                        self.present(alc, animated: true, completion: nil)
                    }
                    
                case .none:
                    
                    DispatchQueue.main.async {
                        
                        let alc = UIAlertController(title: "Notification Setting".toLocalize, message: "Click on Setting > Notifications > Switch On Allow Notification and choose Alert style as Banner".toLocalize, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Setting".toLocalize, style: .default, handler: { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }})
                        alc.addAction(ok)
                        let cancelAction = UIAlertAction(title: "Cancel".toLocalize, style: .destructive, handler: nil)
                        alc.addAction(cancelAction)
                        self.present(alc, animated: true, completion: nil)
                        
                    }
                    
                case .banner:
                    
                    print("do nothing")
                    
                    DispatchQueue.main.async {
                        
                        let alc = UIAlertController(title: "Notification Setting".toLocalize, message: "Please  press on setting > Bolt > Notification > Switch On Allow Notification and choose Alert style as Banner".toLocalize, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Setting".toLocalize, style: .default, handler: { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }})
                        alc.addAction(ok)
                        let cancelAction = UIAlertAction(title: "Cancel".toLocalize, style: .destructive, handler: nil)
                        alc.addAction(cancelAction)
                        self.present(alc, animated: true, completion: nil)
                        //
                    }
                }
            }
            
        } else {
            view.makeToast("coming soon...", duration: 2.0, position: .bottom)
        }
    }
    
    @objc func showCallCreditsVC() {
        let paymentHistory = RechargeCallCreditVC()
        self.navigationController?.pushViewController(paymentHistory, animated: true)
    }
    func showColorPickerForCar() {
        
        let popoverVC = storyboard?.instantiateViewController(withIdentifier: "colorPickerPopover") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 446)
        if let popoverController = popoverVC.popoverPresentationController {
            // popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverController.delegate = self as? UIPopoverPresentationControllerDelegate
            // popoverVC.delegate = self
        }
        present(popoverVC, animated: true, completion: nil)
    }
    
    func displaySoundsAlert() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Play Sound", message: nil, preferredStyle: UIAlertController.Style.alert)
            for i in 1000...1010 {
                alert.addAction(UIAlertAction(title: "\(i)", style: .default, handler: {_ in
                    AudioServicesPlayAlertSound(UInt32(i))
                    self.displaySoundsAlert()
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func setupalertactivity() {
        var textLabel = ""
        presentAlertWithTitle(title: "", message: "",
                              options: "Low", "Medium", "High") { (option) in
                                self.optionchoice = option
                                switch(option) {
                                case "Low":
                                    textLabel = "Low"
                                    UserDefaults.standard.set(textLabel, forKey: "textLabel")
                                    self.appSetting.settingMenuView.reloadData()
                                    // self.playAlertSound()
                                    break
                                case "Medium":
                                    textLabel = "Medium"
                                    UserDefaults.standard.set(textLabel, forKey: "textLabel")
                                    self.appSetting.settingMenuView.reloadData()
                                    //   self.playAlertSound()
                                    break
                                case "High":
                                    textLabel = "High"
                                    UserDefaults.standard.set(textLabel, forKey: "textLabel")
                                    self.appSetting.settingMenuView.reloadData()
                                    //   self.playAlertSound()
                                    break
                                default:
                                    self.dismiss(animated: true, completion: nil)
                                    break
                                }
        }
    }
    
    @objc func setStopSuration() {
        let alert = UIAlertController(title: "Stop duration".toLocalize , message: nil , preferredStyle: .alert)
        
        let stopDuration:Int = Defaults().get(for: Key<Int>("stop_duration")) ?? 5
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "\(stopDuration) mins"
        })
        
        alert.addAction(UIAlertAction(title: "SAVE".toLocalize, style: .default, handler: { action in
            if let duration = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if !duration.isEmpty {
                    let durationValue = Int(duration) ?? 5
                    if durationValue < 5 {
                        UIApplication.shared.keyWindow?.makeToast("Duration should be greater than 5 mins", duration: 2.0, position: .bottom)
                    } else {
                        Defaults().set(durationValue, for: Key<Int>("stop_duration"))
                        self.appSetting.settingMenuView.reloadData()
                    }
                } else {
                    UIApplication.shared.keyWindow?.makeToast("Field cannot be empty.", duration: 2.0, position: .bottom)
                }
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".toLocalize, style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
}

extension AppSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? AppSettingViewCell
        cell.selectionStyle = .none
        cell.leftText.text = menuArray[indexPath.row]
        cell.isUserInteractionEnabled = true
        cell.notificationButton.removeTarget(nil, action: nil, for: .allEvents)
 cell.notificationButton.setImage(nil, for: .normal)
 cell.notificationButton.setTitle(.none, for: .normal)
        switch menuArray[indexPath.row] {
        case "Language".toLocalize:
            cell.midBtn.isHidden = true
            cell.notificationButton.isHidden = true
            cell.languageLabel.isHidden = false
            cell.languageLabel.text = langSelected
        case "Notifications".toLocalize:
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            if (flag){
                cell.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            cell.notificationButton.addTarget(self, action: #selector(notificationTapped(_ :)), for: .touchUpInside)
            
        case "Types of notifications".toLocalize:
            cell.notificationButton.isHidden = false
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.setImage(#imageLiteral(resourceName: "backimg-1"), for: .normal)
            cell.notificationButton.addTarget(self, action: #selector(showNotificationType), for: .touchUpInside)
            
        case "Notification Tone".toLocalize:
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            cell.notificationButton.setTitle("Default", for: .normal)
            cell.notificationButton.titleLabel?.underline()
            
        case "Show/Hide Geofences".toLocalize:
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            cell.notificationButton.setImage(#imageLiteral(resourceName: "backimg-1"), for: .normal)
            cell.notificationButton.addTarget(self, action: #selector(showGeofences), for: .touchUpInside)
            
        case "Stop duration report".toLocalize:
            let stopDuration:Int = Defaults().get(for: Key<Int>("stop_duration")) ?? 5
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            cell.notificationButton.setTitle("\(stopDuration) Mins", for: .normal)
            cell.notificationButton.titleLabel?.underline()
            cell.notificationButton.addTarget(self, action: #selector(setStopSuration), for: .touchUpInside)
            
        case "Show marker label".toLocalize:
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            let markerShowed = Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
            if markerShowed == true {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            cell.notificationButton.addTarget(self, action: #selector(showMarker(_:)), for: .touchUpInside)
            
        case "Show marker cluster".toLocalize:
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            let markerClusterShow = Defaults().get(for: Key<Bool>("ShowClusterMarkerSettings")) ?? false
            if markerClusterShow == true {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            cell.notificationButton.addTarget(self, action: #selector(showMarkerCluster(_:)), for: .touchUpInside)
            
        case "Call Credits".toLocalize:
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            cell.notificationButton.isHidden = false
            let callCredits = Defaults().get(for: Key<String>("CallCredits")) ?? " 0 "
            cell.notificationButton.setTitle("\(callCredits) left ", for: .normal)
            cell.notificationButton.setImage(#imageLiteral(resourceName: "righticon").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
            cell.notificationButton.semanticContentAttribute = UIApplication.shared
                .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
            cell.notificationButton.addTarget(self, action: #selector(showCallCreditsVC), for: .touchUpInside)
            
        case "Require password for immobilization".toLocalize:
            cell.notificationButton.isHidden = false
            cell.midBtn.isHidden = true
            cell.languageLabel.isHidden = true
            if immobilizeFlag == true {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else if immobilizeFlag == false {
                cell.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
            cell.notificationButton.addTarget(self, action: #selector(immobilizePaasword(sender:)), for: .touchUpInside)
            
        case "Vehicle list sort".toLocalize:
            cell.notificationButton.isHidden = false
            cell.languageLabel.isHidden = true
            cell.midBtn.isHidden = false
            cell.midBtn.isUserInteractionEnabled = true
            let vehicleLabel = Defaults().get(for: Key<String>("vehicleListSortLabel")) ?? "Default"
            cell.midBtn.setTitle(vehicleLabel, for: .normal)
            cell.notificationButton.setImage(UIImage(named: "menu")!.resizedImage(CGSize.init(width: 30, height: 30), interpolationQuality: .default), for: .normal)
            cell.notificationButton.addTarget(self, action: #selector(vehicleListSortLabel(_:)), for: .touchUpInside)
            cell.midBtn.addTarget(self, action: #selector(vehicleListSortLabel(_:)), for: .touchUpInside)
            
        case "Vehicle icon size".toLocalize:
            cell.notificationButton.isHidden = false
            cell.languageLabel.isHidden = true
            cell.midBtn.isHidden = false
            cell.midBtn.isUserInteractionEnabled = true
            let vehicleLabel = Defaults().get(for: Key<String>("vehicleIconSortLabel")) ?? "MEDIUM"
            cell.midBtn.setTitle(vehicleLabel, for: .normal)
            cell.notificationButton.setImage(UIImage(named: "menu")!.resizedImage(CGSize.init(width: 30, height: 30), interpolationQuality: .default), for: .normal)
            cell.notificationButton.addTarget(self, action: #selector(vehicleIconSortLabel), for: .touchUpInside)
            cell.midBtn.addTarget(self, action: #selector(vehicleIconSortLabel), for: .touchUpInside)
        case "Homescreen".toLocalize:
            cell.notificationButton.isHidden = false
            cell.languageLabel.isHidden = true
            cell.midBtn.isHidden = false
            cell.midBtn.isUserInteractionEnabled = true
            let vehicleLabel = Defaults().get(for: Key<String>("homescreenLabel")) ?? "Map Screen"
            cell.midBtn.setTitle(vehicleLabel, for: .normal)
            cell.notificationButton.setImage(UIImage(named: "menu")!.resizedImage(CGSize.init(width: 30, height: 30), interpolationQuality: .default), for: .normal)
            cell.notificationButton.addTarget(self, action: #selector(homescreenChange(_:)), for: .touchUpInside)
            cell.midBtn.addTarget(self, action: #selector(homescreenChange(_:)), for: .touchUpInside)
        case  "Alert Configuration".toLocalize:
            cell.notificationButton.isHidden = false
            cell.notificationButton.setImage(#imageLiteral(resourceName: "backimg-1"), for: .normal)
            
        default:
            break
        }
        return cell
    }
    func addAlertButton(){
        let getTextlabel = UserDefaults.standard.string(forKey: "textLabel") ?? ""
        alertButton.setImage(UIImage(named: "singlePlayicon")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        cell.addSubview(alertButton)
        volumeButton.setImage(UIImage(named: "icons8-sort-down-30")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        volumeButton.backgroundColor = .appbackgroundcolor
        cell.addSubview(volumeButton)
        
        alertLabel.textColor = .appGreen
        alertLabel.text = getTextlabel
        alertLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cell.addSubview(alertLabel)
        
        alertLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(volumeButton.snp.left).offset(-10)
            // make.size.equalTo(10)
        }
        volumeButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            // make.size.equalTo(10)
        }
        alertButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(alertLabel.snp.left).offset(-20)
            // make.size.equalTo(10)
        }
        volumeButton.addTarget(self, action: #selector(setupalertactivity), for: .touchUpInside)
        alertButton.addTarget(self, action: #selector(playAlertSound), for: .touchUpInside)
    }
    
    @objc func selectVolumeLabel(sender:UIButton){
        
    }
    @objc func  playAlertSound(){
        let setLabeled = UserDefaults.standard.string(forKey: "textLabel") ?? "Low"
        guard let url = Bundle.main.url(forResource: "spymode_sound", withExtension: "mp3") else { return }
        do {
            // try AVAudioSession.sharedInstance().setCategory(., mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            if optionchoice == setLabeled
            {
                player?.volume = 0.2
            }else if optionchoice == setLabeled
            {
                player?.volume = 0.5
            }
            else if optionchoice == setLabeled
            {
                player?.volume = 1.0
            }
            guard let player = player else { return }
            if !isPlaying{
                alertButton.setImage(UIImage(named: "pause")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
                player.play()
                isPlaying = true
            } else {
                player.stop()
                alertButton.setImage(UIImage(named: "singlePlayicon")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
                isPlaying = false
            }
            //                do {
            //                    sleep(5)
            //                }
            //            player.stop()
            //}
            //            AVAudioSession.sharedInstance().outputVolume == 0.5
        } catch let error {
            print(error.localizedDescription)
        }
        
        
    }
    
    //    @objc func btnTapped(_ sender: UIButton)
    //    {
    //        let cell = sender.superview as! AppSettingViewCell
    //               let index_Path = appSetting.settingMenuView.indexPath(for: cell)
    //        switch index_Path?.row {
    ////                 case 9? :
    ////                let alert = UIAlertController(title: "Stop Duration".toLocalize , message: nil , preferredStyle: .alert)
    ////                
    ////                alert.addTextField(configurationHandler: { textField in
    ////                    textField.placeholder = "5 Mins".toLocalize
    ////                })
    ////                
    ////                alert.addAction(UIAlertAction(title: "SAVE".toLocalize, style: .default, handler: { action in
    ////                    
    ////                    if let name = alert.textFields?.first?.text {
    ////                        let title = NSMutableAttributedString(string:NSLocalizedString(name, comment: ""))
    ////                        title.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, title.length))
    ////                        UserDefaults.standard.set(name, forKey: "minutes")
    ////                        title.addAttribute(NSAttributedStringKey.foregroundColor, value: appGreenTheme, range: NSMakeRange(0,title.length))
    ////                        title.addAttribute(NSAttributedStringKey.font, value:UIFont.systemFont(ofSize: UIFont.systemFontSize + 2, weight: .regular) , range: NSMakeRange(0, title.length))
    ////                        
    ////                      
    ////                        
    ////                    }
    ////                }))
    ////                alert.addAction(UIAlertAction(title: "CANCEL".toLocalize, style: .destructive, handler: nil))
    ////                self.present(alert, animated: true)
    //                
    //                
    ////               case 4?:
    ////                    let colorChose = VehicleColorPickerVC()
    ////                    colorChose.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    ////                    self.addChildViewController(colorChose)
    ////                    self.view.addSubview(colorChose.view)
    ////                    self.appSetting.settingMenuView.reloadData()
    ////                   //colorChose.didMove(toParentViewController: self)
    //////                    let nav = UINavigationController(rootViewController: colorChose)
    //////                    self.present(nav, animated: true, completion: nil)
    //////                    self.navigationController?.pushViewController(colorChose, animated: true)
    ////               default:
    ////                print("go")
    ////               case .none:
    ////                <#code#>
    ////               case .some(_):
    ////                <#code#>
    //        case .none:
    //            <#code#>
    //        case .some(_):
    //            <#code#>
    //        }
    //}
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // height constraint
        let constraintHeight = NSLayoutConstraint(
            item: alertController.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 150)
        alertController.view.addConstraint(constraintHeight)
        
        // width constraint
        let constraintWidth = NSLayoutConstraint(
            item: alertController.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
            NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
        alertController.view.addConstraint(constraintWidth)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(options[index])
            }))
        }
        self.present(alertController, animated: true){
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        //tableView.contentSize.height / CGFloat(menuArray.count)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
}



//
//  ToolsViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import DefaultsKit
import KeychainAccess
import FirebaseCrashlytics
import FreshchatSDK

class ToolsViewController: UIViewController {
    //MARK:- Tools View
    var toolsView: ToolView!
    lazy var reportViewController = NewReportViewController()
    let keychain = Keychain(service: "in.roadcast.bolt")
    var toolsTitleLabel = ["DASHBOARD","HELP","REPORTS","IMMOBILIZE","VOICE ASSIST","GEOFENCE","POI","QRSCAN AND CALL","APP SETTINGS","EDIT VEHICLE INFO","PROFILE","CONFIGURATION","SUBSCRIPTIONS"]//,"FAQ","LOGOUT","ADMIN","LIVE STREAMING","LOAD/UNLOAD"
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = appGreenTheme
        self.navigationController?.isNavigationBarHidden = true
        addScrollView()
        addConstraints()
        setActions()
        updateToolsList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateToolsList()
    }
    func  updateToolsList(){
        toolsTitleLabel.removeAll()
        toolsTitleLabel.append(contentsOf: ["DASHBOARD","HELP","REPORTS","IMMOBILIZE","VOICE ASSIST","GEOFENCE","POI","QRSCAN AND CALL","APP SETTINGS","EDIT VEHICLE INFO","PROFILE","CONFIGURATION","SUBSCRIPTIONS"])
        let loginType = Defaults().get(for: Key<String>("loginType"))
        var allDevices = [TrackerDevicesMapperModel]()
        var devices : [TrackerDevicesMapperModel] = []
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        allDevices = RCGlobals.getExpiryFilteredList(data)
        let positionsDevices = Defaults().get(for: Key<[TrackerPositionMapperModel]>("allPositions")) ??  []
        for i in positionsDevices {
            let deviceProtocol = ["jc".lowercased() , "boltcam".lowercased()]
            if (i.protocl?.contains(deviceProtocol[0]))! || (i.protocl?.contains(deviceProtocol[1]))! {
                
                print("i is \(i.deviceId!)")
                
                
                for j in allDevices {
                    
                    if j.id! == i.deviceId! {
                        
                        devices.append(j)
                    }
                    
                }
            }
        }
        if devices.count > 0 {
             toolsTitleLabel.append("LIVE STREAMING")
        }
        let isLoadUnloadVisible = Defaults().get(for: Key<String>("isLoadUnloadVisible"))
        if isLoadUnloadVisible == "1"{
             toolsTitleLabel.append("LOAD/UNLOAD")
        }
        if loginType == "admin" {
              toolsTitleLabel.append("ADMIN")
        }
        toolsTitleLabel.append("FAQ")
        toolsTitleLabel.append("LOGOUT")
        toolsView.collectionView.reloadData()
        
    }
    func setActions(){
        toolsView.collectionView.delegate = self
        toolsView.collectionView.dataSource = self
        toolsView.collectionView.register(ToolViewCell.self, forCellWithReuseIdentifier: "tools")
        
    }
    func poiCall(){
        let controller = UINavigationController(rootViewController: POIViewController())
        controller.navigationBar.backgroundColor = .white
        self.present(controller, animated: false, completion: nil)
    }
    func qrScanCall(){
        let controller = UINavigationController(rootViewController: QRScanVehicleListVC())
        controller.navigationBar.backgroundColor = .white
        self.present(controller, animated: false, completion: nil)
    }
    func dashboardCall(){
        let navController = UINavigationController(rootViewController: DashboardController())
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        
        self.present(navController, animated: false, completion: nil)
        
    }
    func subscriptionCall() {
        let navController = UINavigationController(rootViewController: SubscriptiomMainVC())
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated: false, completion: nil)
    }
    
    func geofenceCall() {
        let navController = UINavigationController(rootViewController: GeoViewController())
        navController.navigationBar.backgroundColor = UIColor.white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
    }
    
    func profileCall() {
        
        let navController = UINavigationController(rootViewController: ProfileViewController())
        navController.navigationBar.barTintColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
    }
    
    func connectAndShareCall() {
        let navController = UINavigationController(rootViewController: ShareVC())
        navController.navigationBar.backgroundColor = UIColor.white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
    }
    
    func voiceAssistCall() {
//        let navController = UINavigationController(rootViewController: GoogleAssistanceHelpVC())
//        navController.navigationBar.backgroundColor = UIColor.white
//        navController.navigationBar.tintColor = appGreenTheme
//        self.present(navController, animated:false, completion: nil)
        
        let alert = UIAlertController(title: "Alert", message: "Feature coming soon", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
//        self.prompt("feature coming soon..")
        
        
    }
    
    func editVehicleInfoCall() {
        let navController = UINavigationController(rootViewController: EditVehicleInfoController())
        self.present(navController, animated: true, completion: nil)
    }
    
    func logoutCall() {
        self.prompt("Logout", "Are you sure?", "NO", "YES", handler1: { (_) in

        }) { (_) in
             let username = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email
             let password: String = {
                 do {
                     return try self.keychain.getString("boltPassword") ?? ""
                 } catch {
                     return ""
                 }
             }()
            RCLocalAPIManager.shared.login(loadingMsg: "Please wait...", with: username ?? "", password: password, isLogin: false, success: { [weak self] hash in

                RCLocalAPIManager.shared.deleteSession(with: { (self) in }, failure: { (self) in })

                guard let weakSelf = self else { return }

                weakSelf.completeLogout()

            }) { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.crashlyticsLog(errorMsg: message, username: username ?? "", password: password)
                weakSelf.prompt("Logout", "Unable to logout,\nDo you want to go to login screen?", "NO", "YES", handler1: { (_) in} , handler2: { (_) in
                    weakSelf.completeLogout()
                })
            }
        }
    }
    
    fileprivate func crashlyticsLog(errorMsg: String, username: String, password: String) {
        print("send logs to crashlytics.")
        let boltToken: String = {
            do {
                return try self.keychain.getString("boltToken") ?? ""
            } catch {
                return ""
            }
        }()
        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("The request failed:-\(errorMsg)", comment: errorMsg),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("The response returned:-\(errorMsg)", comment: errorMsg),
          NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment: ""),
          "ProductID": "",
          "View": "ToolsViewController",
            "UserId": username,
            "password": password,
            "token": boltToken
        ]

        let error = NSError.init(domain: NSCocoaErrorDomain,
                                 code: 400,
                                 userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
        
        Crashlytics.crashlytics().log("Logout error: \(errorMsg)")
    }
    
    fileprivate func completeLogout() {
        DBManager.shared.deleteAllFromDatabase()
        
        do {
            try keychain.remove("boltPassword")
            try keychain.remove("boltToken")
        } catch let error { print("error: \(error)") }
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        Defaults().clear(Key<Bool>("isParkingBadgeVisible"))
        Defaults().clear(Key<Bool>("allNotifications"))
        Defaults().set("Map Screen",for: Key<String>("homescreenLabel"))
        

        RCSocketManager.shared.stopObserving()
        markers.removeAll()
        RCMapView.clearMap()
        
        Defaults().clear(Key<Bool>("isFirstTimeList"))
        
        RCGlobals.clearAllDefaults()
        
        self.view.window?.rootViewController = LoginViewController()
    }
    
    func addScrollView(){
        toolsView = ToolView()
        view.addSubview(toolsView)
    }
    func reportsCall(){
        let navController = UINavigationController(rootViewController: NewReportViewController())
        navController.navigationBar.backgroundColor = UIColor.white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
        
    }
    func immobilizeCall(){
        let navController = UINavigationController(rootViewController: ImmobilizeViewController())
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
    }
    
    func appSettingsCall() {
        let navController = UINavigationController(rootViewController: AppSettingViewController())
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
    }
    
    func configurationCall(){
        let navController = UINavigationController(rootViewController: SMSCommandViewController())
        navController.navigationBar.backgroundColor = UIColor.white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
    }
    
    
    func helpCall(){
        let thirdPartyValue:String = Defaults().get(for: Key<String>("thirdPartyValue")) ?? ""
        if thirdPartyValue.isEmpty
            || thirdPartyValue == "Roadcast"
            || thirdPartyValue == "globetoyota"
            || thirdPartyValue == "roadcast_harshcar"
            || thirdPartyValue == "roadcast_spcar"
            || thirdPartyValue == "royal_fleet" {
            
            let user = FreshchatUser.sharedInstance();
            
            // To set an identifiable first name for the user
            user.firstName = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.name;
            
            //To set user's email id
            user.email = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.attributes?.email ?? "";
            
            //To set user's phone number
            user.phoneCountryCode=(Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.attributes?.countryCode ?? "91";
            user.phoneNumber = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email;
            
            // FINALLY, REMEMBER TO SEND THE USER INFORMATION SET TO FRESHCHAT SERVERS
            Freshchat.sharedInstance().setUser(user)
            
            Freshchat.sharedInstance().showConversations(self)
        } else {
            showContactAdminDialog()
        }
    }
    
    func showContactAdminDialog() {
        let message = "For help, Please contact your admin or service provider."
        let alertController = UIAlertController(title: "Help", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func faqCall(){
        let navController = UINavigationController(rootViewController: FAQController())
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated: false, completion: nil)
    }
    
    func loadUnloadCall(){
        
        let isLoadUnloadRunning = Defaults().get(for: Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue)) ?? false
        
        if isLoadUnloadRunning {
            let navController = UINavigationController(rootViewController: LoadUnloadViewController())
            navController.navigationBar.backgroundColor = .white
            navController.navigationBar.tintColor = appGreenTheme
            self.present(navController, animated: false, completion: nil)
        } else {
            let navController = UINavigationController(rootViewController: LoadUnloadSelectVehicleViewController())
            navController.navigationBar.backgroundColor = .white
            navController.navigationBar.tintColor = appGreenTheme
            self.present(navController, animated: false, completion: nil)
        }
    }
    func adminCall(){
        let navController = UINavigationController(rootViewController: AdminViewController())
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated: false, completion: nil)
    }
    
    func liveStreamingCall(){
            let navController = UINavigationController(rootViewController: LiveStreamingVC())
            self.present(navController, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addConstraints(){
        toolsView.snp.makeConstraints { (make) in
            if #available(iOS 11, *){
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            }else{
                make.edges.equalToSuperview()
            }
        }
    }
}
extension ToolsViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  20
        let collectionViewSize = screensize.width - padding
        
        return CGSize(width: collectionViewSize/2, height:collectionViewSize/2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return toolsTitleLabel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tools", for: indexPath) as! ToolViewCell
        cell.addShadow()
        cell.label.text = toolsTitleLabel[indexPath.row]
        switch toolsTitleLabel[indexPath.row]{
        case "DASHBOARD":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "Asset 1")
        case "HELP":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "001-idea")
        case "REPORTS":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "dashicon1")
        case "IMMOBILIZE":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "dashicon2")
        case "VOICE ASSIST":
            cell.img.isHidden = true
            cell.label.isHidden = true
            cell.voiceLabel.isHidden = false
            cell.voiceImg.isHidden = false
            cell.googleImg.isHidden = false
            cell.newIcon.isHidden = false
            cell.voiceImg.image = #imageLiteral(resourceName: "mic")
            cell.googleImg.image = #imageLiteral(resourceName: "poweredby")
            cell.voiceLabel.text = "VOICE ASSIST"
            cell.newIcon.image = #imageLiteral(resourceName: "new label")
        case "GEOFENCE":
             updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "dashicon5")
        case "POI":
            updateLabelVisibility(cell: cell)
            cell.img.image = UIImage(named: "poi")
        case "QRSCAN AND CALL":
            updateLabelVisibility(cell: cell)
            cell.img.image = UIImage(named: "scan_and_request_call")
        case "APP SETTINGS":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "dashicon3")
        case "EDIT VEHICLE INFO":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "tools")
        case "PROFILE":
            updateLabelVisibility(cell: cell)
            cell.img.image = UIImage(named: "profile")
        case "CONNECT & SHARE":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "Share")
        case "CONFIGURATION":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "002-smartphone")
        case "SUBSCRIPTIONS":
            updateLabelVisibility(cell: cell)
            cell.img.image = UIImage(named: "subscri")
        case "FAQ":
            updateLabelVisibility(cell: cell)
            cell.img.image = UIImage(named: "faq")
        case "LOGOUT":
            updateLabelVisibility(cell: cell)
            cell.img.image = #imageLiteral(resourceName: "logoutlogo")
        case "ADMIN":
            updateLabelVisibility(cell: cell)
            cell.img.image = UIImage(named: "admin")
            case "LIVE STREAMING":
                updateLabelVisibility(cell: cell)
                cell.img.image = UIImage(named: "live streaming")
            case "LOAD/UNLOAD":
                updateLabelVisibility(cell: cell)
                cell.img.image = UIImage(named: "loadUnload-1")
        default:
            break
        }
        return cell
    }
    func updateLabelVisibility(cell:ToolViewCell){
        cell.img.isHidden = false
        cell.label.isHidden = false
        cell.voiceLabel.isHidden = true
        cell.voiceImg.isHidden = true
        cell.googleImg.isHidden = true
        cell.newIcon.isHidden = true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        switch toolsTitleLabel[indexPath.row]{
        case "DASHBOARD":
            dashboardCall()
        case "HELP":
            helpCall()
        case "REPORTS":
            reportsCall()
        case "IMMOBILIZE":
            immobilizeCall()
        case "VOICE ASSIST":
            voiceAssistCall()
        case "GEOFENCE":
            geofenceCall()
        case "POI":
            poiCall()
        case "QRSCAN AND CALL":
            qrScanCall()
        case "APP SETTINGS":
            appSettingsCall()
        case "EDIT VEHICLE INFO":
            editVehicleInfoCall()
        case "PROFILE":
            profileCall()
        case "CONNECT & SHARE":
            connectAndShareCall()
        case "CONFIGURATION":
            configurationCall()
        case "SUBSCRIPTIONS":
            subscriptionCall()
        case "FAQ":
            faqCall()
        case "LOGOUT":
            logoutCall()
        case "LOAD/UNLOAD":
            loadUnloadCall()
        case "LIVE STREAMING":
            liveStreamingCall()
        case "ADMIN":
            adminCall()
        default:
            break
        }
    }
}
extension UIViewController {
    func doLogoutAction() {
        _ = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email
        //        let keychain = Keychain(service: "in.roadcast.bolt")
        //        let password = try? keychain.getString("boltPassword")
        RCSocketManager.shared.stopObserving()
        markers.removeAll()
        RCMapView.clearMap()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        RCGlobals.clearAllDefaults()
        
        let top = UIApplication.shared.keyWindow?.rootViewController
        top?.present(LoginViewController(), animated: true, completion: nil)
        
    }
    
}


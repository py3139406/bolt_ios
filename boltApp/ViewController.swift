//
//  ViewController.swift
//  boltApp
//
//  Created by Arshad Ali on 10/11/17.
//  Copyright © 2017 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit
import SwiftMessages
import Hero
import RevealingSplashView
import SnapKit
import GooglePlaces
import KeychainAccess


var modelFlag = 0
var tabBarHeight: CGFloat!
var height: CGFloat!
var update = 0
var deviceId = ""
let screensize = UIScreen.main.bounds.size

class ViewController: UITabBarController, UITabBarControllerDelegate{
    var onlineDeviceStatusIds = Array<Int>() // is used to change icon of parking mode
    
    var gesture: UITapGestureRecognizer!
    let reveal = RevealingSplashView(iconImage:#imageLiteral(resourceName: "boltii"), iconInitialSize: CGSize(width: 160, height: 160), backgroundColor: UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1))
    var expiryDateArray: [String] = []
    var expiredVehicles: [String] = []
    var expireInSevenDays: [String] = []
    var expiredVehicleRegistrationName: [String] = []
    var expireInSevenDaysRegistrationName: [String] = []
    var expiredDeviceIds: [String] = []
    let username = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email
    var isDashboardCalled:Bool?
    let keychain = Keychain(service: "in.roadcast.bolt")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        Defaults().set(false, for: Key<Bool>("isPopUpPresented"))
        Defaults().set(false, for: Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue))
        Defaults().set(false, for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue))
        NotificationCenter.default.addObserver(self, selector:#selector(openAlertPopup), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 10, weight: .medium)], for: .normal)
        
       tokenRequest()
        getFuelDetails()
        getPOIDataRequest()
    }
    
    func tokenRequest() {
        RCLocalAPIManager.shared.getJWTToken(loadingMsg: "") { (success) in
            print(success)
            self.getCompanyConfig()
            self.getUserConfig()
        } failure: { (message) in
            if message == MyError.notAuthorized.localizedDescription {
                self.prompt("Password Changed", "It seems someone has changed password for this account, Please try login again with new credentials.", "OK", handler1: { _ in
                    self.completeLogout()
                })
            } else {
                print(message)
            }
        }
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
    
    fileprivate func getUserConfig() {
        RCLocalAPIManager.shared.getUserConfig(success: { response in
            print("Success in user config")
        }, failure: { error in
            print("Failure in user config")
        })
    }
    
    fileprivate func getFuelDetails() {
        RCLocalAPIManager.shared.gettingFuelDetails(success: { (success) in
            print("success in getting details")
        }) { (error) in
            print("failure in fuel")
        }
    }
    
    func getCompanyConfig() {
        RCLocalAPIManager.shared.getCompanyConfig { (success) in
            GMSPlacesClient.provideAPIKey(RCGlobals.getPlacesKey())
        } failure: { (message) in
            print(message)
        }
    }
    
    func getPOIDataRequest () {
        RCLocalAPIManager.shared.getPOIData(with:"", success: { (success) in
            print("success in getting POI info")
        }) { (failure) in
            print("failure in getting POI info")
        }
    }
    
    @objc func openAlertPopup() {
        if Defaults().has(Key<String>("AlertPopWindow")) {
            if let alertType = Defaults().get(for: Key<String>("AlertPopWindow")) {
                let popUpVC = SosAlertController()
                popUpVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                if alertType == "sos" {
                    popUpVC.alertType = "sos"
                } else if alertType == "powerCut" {
                    popUpVC.alertType = "powerCut"
                } else if alertType == "spymode"  {
                    popUpVC.alertType = "spymode"
                }
                self.present(popUpVC, animated: true, completion: nil)
            }
        } else {
            
            let isCallOngoing:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue)) ?? false
            if !isCallOngoing {
                handleBackgroundQRNotification()
            }
        }
    }
    
    func handleBackgroundQRNotification() {
        if let callName = Defaults().get(for: Key<String>(defaultKeyNames.callIMEI.rawValue)) {
            let acceptShown:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue)) ?? false
            if !acceptShown {
                self.present(AcceptCallVC(), animated: true, completion: nil)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addTabBar()
        getUserHierarchy()
        let vehicleLabel = Defaults().get(for: Key<String>("homescreenLabel")) ?? "Map Screen"
        let checkHomeScreen = Defaults().get(for: Key<Bool>("checkHomeScreen")) ?? false
        if checkHomeScreen == true{
            if vehicleLabel == "List of vehicles" {
                self.selectedIndex = 1
            } else {
                self.selectedIndex = 0
            }
            Defaults().set(false,for: Key<Bool>("checkHomeScreen"))
        }else {
            self.selectedIndex = 0
        }
        if let dash =  isDashboardCalled {
            if dash {
                self.selectedIndex = 1
            }else {
                self.selectedIndex = 0
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        RCLocalAPIManager.shared.getPaymentRates(success: { (success) in
            print("success in getting payent rates")
        }) { (failure) in
            print("failure in getting payment rates")
        }
        
        if Defaults().has(Key<String>("AlertPopWindow")) {
            if let alertType = Defaults().get(for: Key<String>("AlertPopWindow")) {
                let popUpVC = SosAlertController()
                popUpVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                if alertType == "sos" {
                    popUpVC.alertType = "sos"
                } else if alertType == "powerCut" {
                    popUpVC.alertType = "powerCut"
                } else if alertType == "spymode"  {
                    popUpVC.alertType = "spymode"
                }
                self.present(popUpVC, animated: true, completion: nil)
            }
        } else {
            let isCallOngoing:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue)) ?? false
            if !isCallOngoing {
                handleBackgroundQRNotification()
            }
        }
    }
    
    func deviceName() -> String {
           var systemInfo = utsname()
           uname(&systemInfo)
           let str = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
               return String(cString: ptr)
           }
           return str
       }

    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size }()
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        height = defaultTabBarHeight.height
    }
    func addTabBar(){
        let trackingimg1 = UIImageView(image: #imageLiteral(resourceName: "tracking"))
        let trackingimg2 = UIImageView(image: #imageLiteral(resourceName: "tracking"))
        let vehicleimg1 = UIImageView(image: #imageLiteral(resourceName: "tools"))
        let vehicleimg2 = UIImageView(image: #imageLiteral(resourceName: "tools"))
        let toolimg1 = UIImageView(image: #imageLiteral(resourceName: "tool"))
        let toolimg2 = UIImageView(image: #imageLiteral(resourceName: "tool"))
        let notificationimg1 = UIImageView(image: #imageLiteral(resourceName: "notification"))
        let notificationimg2 = UIImageView(image: #imageLiteral(resourceName: "notification"))
       // let parkingimg1 = UIImageView(image: #imageLiteral(resourceName: "parkingModeonTabBar"))
        //  let parkingimg2 = UIImageView(image: #imageLiteral(resourceName: "parkingModeonTabBar"))
        
        let mapViewController = MapsViewController()
        mapViewController.findExpiryDate { (_) in
            print("logged in")
        }
        Defaults().set(false, for: Key<Bool>("isPopUpPresentedInMainController"))
        let mapTabBarItem = UITabBarItem(title: "Tracking", image: trackingimg1.image?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal) , selectedImage: trackingimg2.image?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default))
        mapViewController.tabBarItem = mapTabBarItem
        
        
        let addEditViewController = VehicleViewController()
        let addEditTabBarItem = UITabBarItem(title: "Vehicles", image: vehicleimg1.image?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal) , selectedImage: vehicleimg2.image?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default))
        addEditViewController.tabBarItem = addEditTabBarItem
        
        let toolsViewController = ToolsViewController()
        
        var toolTabBarItem: UITabBarItem!
        
        
        toolTabBarItem = UITabBarItem(title: nil, image: toolimg1.image?.resizedImage(CGSize.init(width: 57, height: 15), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal) , selectedImage: toolimg2.image?.resizedImage(CGSize.init(width: 57, height: 15), interpolationQuality: .default))
        toolTabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        
        toolsViewController.tabBarItem = toolTabBarItem
        
        
        
        let notificationController = NotificationViewController()
        let notificationBarItem = UITabBarItem(title: "Notifications", image: notificationimg1.image?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal) , selectedImage: notificationimg2.image?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default))
        
        notificationController.tabBarItem = notificationBarItem
        
        
        let parkingViewController = ParkingViewController()
        let flag = Defaults().get(for: Key<Bool>("isParkedOn")) ?? false
        var parkingTabBarItem = UITabBarItem()
        
        if flag {
            parkingTabBarItem = UITabBarItem(title: "Parking".toLocalize, image: UIImage(named: "parking_icon")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), selectedImage:UIImage(named: "parking_icon")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal))
            parkingViewController.tabBarItem = parkingTabBarItem
        }else{
            parkingTabBarItem = UITabBarItem(title: "Parking".toLocalize, image: UIImage(named: "parkingModeonTabBar")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "parkingModeWhite")?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal))
            parkingViewController.tabBarItem = parkingTabBarItem
        }
        
        self.viewControllers = [mapViewController,addEditViewController,toolsViewController,notificationController,parkingViewController]
        self.tabBar.barStyle = .default
        self.tabBar.barTintColor = .white
        self.tabBar.unselectedItemTintColor = appGreenTheme
        self.tabBar.tintColor = .white
        let numberOfItems = CGFloat(tabBar.items!.count)
        print("height\(defaultTabBarHeight.height)")
        
        // set tabbar height
        tabBarHeight = defaultTabBarHeight.height + 34
//        if #available(iOS 11.0, *) {
//            let tabBarItemSize = CGSize(width: self.tabBar.frame.size.width / numberOfItems, height:tabBarHeight )
//            tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1), size:tabBarItemSize)
//        } else {
//            let tabBarItemSize = CGSize(width: self.tabBar.frame.size.width / numberOfItems, height:defaultTabBarHeight.height ) //
//            tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1), size:tabBarItemSize)
//        }
//        let modelname = deviceName()
//     //   iPhonex = 10,3 10,6 XR= 11,8 XS = 11,2, XS Max = 11,6 11,4 , phone11 = 12,1 , 11Pro= 12,1 , 11ProMax= 12,5 SE= 12,8 , 12 mini = 13,1 , 12= 13,2 12pro = 13,3 , 12promax = 13,4
//
//        if ( modelname == "iPhone10,3" || modelname == "iPhone10,6" || modelname == "iPhone11,8" || modelname == "iPhone11,2" || modelname == "iPhone11,6" || modelname == "iPhone11,4" ||  modelname == "iPhone12,1" || modelname == "iPhone12,5" || modelname == "iPhone13,1" || modelname == "iPhone13,2" || modelname == "iPhone13,3" || modelname == "iPhone13,4") {
//            let tabBarItemSize = CGSize(width: self.tabBar.frame.size.width / numberOfItems, height:tabBarHeight )
//            tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1), size:tabBarItemSize)
//        } else {
//            let tabBarItemSize = CGSize(width: self.tabBar.frame.size.width / numberOfItems, height:defaultTabBarHeight.height ) //
//            tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1), size:tabBarItemSize)
//        }
        
        
        if #available(iOS 11.0, *) {
            if (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20) {
                let tabBarItemSize = CGSize(width: self.tabBar.frame.size.width / numberOfItems, height:tabBarHeight )
                tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: appGreenTheme, size:tabBarItemSize)
            } else {
                let tabBarItemSize = CGSize(width: self.tabBar.frame.size.width / numberOfItems, height:defaultTabBarHeight.height ) //
                tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: appGreenTheme, size:tabBarItemSize)
            }
        } else {
            // Fallback on earlier versions
        }
        // end
        print("new height\(String(describing: tabBarHeight))")
        self.tabBar.barTintColor = .white
        self.tabBar.isOpaque = false
        self.tabBar.backgroundColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1)], for: .normal)
        
        let sharePin = Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? ""
        if sharePin != "" {
            let shareDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
            
            let status2 = MessageView.viewFromNib(layout: .statusLine)
            status2.backgroundView.backgroundColor = UIColor(red: 120.0/255.0, green:171.0/255.0, blue: 70.0/255.0, alpha: 1)
            status2.bodyLabel?.textColor = .white
            status2.configureContent(body: "Connected - " + (shareDevice?.name)!)
            var status2Config = SwiftMessages.defaultConfig
            status2Config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            status2Config.duration = .forever
            status2Config.preferredStatusBarStyle = .lightContent
            SwiftMessages.show(config: status2Config, view: status2)
            
        }
        
    }
    
    
    //For Tab Bar Selected Background Color
    
    func getUserHierarchy(){
        RCLocalAPIManager.shared.getUsersHierarchy(success: { [weak self] hash in
            guard self != nil else {
                return
            }
            
        }) { [weak self] message in
            guard self != nil else {
                return
            }
            //            weakSelf.prompt(message)
        }
        
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if let vc = viewController as? UINavigationController {
            vc.popViewController(animated: false)
        }
    }
    
}
extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}


//
//  AppDelegate.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import Fabric
import Crashlytics
import GooglePlaces
import GoogleMaps
import DefaultsKit
import Firebase
import FirebaseStorage
import UserNotifications
import IQKeyboardManagerSwift
import RevealingSplashView
import Presentr
import KeychainAccess
import Siren
import BlueCapKit
import Realm
import RealmSwift
import FreshchatSDK

struct Singletons {
    static let manager = CentralManager(queue: DispatchQueue(label: "in.roadcast.bolt", qos: .background))
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //  TISensorTagProfiles.create(profileManager: Singletons.profileManager)
        Defaults().set(false, for: Key<Bool>("isPopUpPresented"))
        realmMigration()
        // save language
        if let language = RCDataManager.get(stringforKey: "LanguagePreference") {
            Bundle.setLanguage(language)
        }
        
        
        Fabric.with([Crashlytics.self])
        
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyDI3wOr-xVySyqOppFkHJT1kETXAQlH8Ow")
        
        IQKeyboardManager.sharedManager().enable = true
        
        window = UIWindow()
        let appId = "d5068ead-83ca-4a74-a93e-89b6a9f3edd4"
        let appKey = "fc13696a-2426-499b-a0c7-a5d53cf5afc6"
        
        let freschatConfig: FreshchatConfig = FreshchatConfig.init(appID: appId, andAppKey: appKey)
        freschatConfig.gallerySelectionEnabled = true; // set NO to disable picture selection for messaging via gallery
        freschatConfig.cameraCaptureEnabled = true; // set NO to disable picture selection for messaging via camera
        freschatConfig.showNotificationBanner = true; // set to NO if you don't want to show the in-app notification banner upon receiving a new message while the app is open
        
        Freshchat.sharedInstance().initWith(freschatConfig)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        downloadAnimation()
        
        if let isLoogedIn = Defaults().get(for: Key<Bool>("isLoggedIn")) {
            if isLoogedIn {
                update = update + 1
                let font: UIFont = UIFont(name: "AppleSDGothicNeo-Light", size: 13)!
                UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
                
                let followerToken = Defaults().get(for: Key<String>("ShareVehicleFollowerPin")) ?? ""
                
                if followerToken != "" {
                    window?.rootViewController = FolloweShareViewController()
                } else {
                    Defaults().set(true,for: Key<Bool>("checkHomeScreen"))
                    if RCGlobals.isAnimtionShownForDate() {
                        window?.rootViewController = ViewController()
                    } else {
                        window?.rootViewController = SplashAnimationVC()
                    }
                    
                }
                if let option = launchOptions {
                    let info = option[UIApplicationLaunchOptionsKey.remoteNotification]
                    if info != nil {
                        Defaults().set(true,for: Key<Bool>("checkHomeScreen"))
                        if RCGlobals.isAnimtionShownForDate() {
                            window?.rootViewController = ViewController()
                        } else {
                            window?.rootViewController = SplashAnimationVC()
                        }
                    }
                }
            }
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
        
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        sirenCheck()
        
        
        // [END register_for_notifications]
        //      SPLaunchAnimation.asTwitter(onWindow: self.window!)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
            
        }
        
        
        let isDelete = Defaults().get(for: Key<Bool>("isRealmDeleteRight")) ?? false
        if isDelete == false {
            deleteEverythingRealm()
        }
        return true
    }
    
    func downloadAnimation() {
        let storage = Storage.storage()
        
        let httpsReference = storage.reference().child("AnimationFiles").child("splash_animation.gif")
        
        // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let imageData = data {
                    Defaults().set(imageData, for: Key<Data>(defaultKeyNames.animationData.rawValue))
                }
            }
        }
    }
    
    func realmMigration(){
        // Inside your application(application:didFinishLaunchingWithOptions:)
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 2,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        
    }
    
    
    
    
    
    
    func deleteEverythingRealm() {
        
        let isDelete = Defaults().get(for: Key<Bool>("isRealmDeleteRight")) ?? false
        
        if isDelete == false {
            DBManager.shared.deleteAllFromDatabase()
        }
        Defaults().set(true,for: Key<Bool>("isRealmDeleteRight"))
    }
    
    
    
    //  func removeRealmData(){
    //
    //   var currentDate = Date()
    //    var currentDate = RCGlobals.getFormattedDate(date: currentDate as NSDate)
    //
    //    var endOfMonthDate = Date.endOfMonth()
    //
    //
    //    let realm = try! Realm()
    //    try! realm.write {
    //      realm.deleteAll()
    //    }
    //
    //  }
    
    func sirenCheck(){
        
        let siren = Siren.shared
        
        siren.alertType = .option
        
        siren.alertMessaging = SirenAlertMessaging(updateTitle: NSAttributedString(string:"Update Available"), updateMessage: NSAttributedString(string:"A new version of Bolt is available. Please update to latest version."), updateButtonMessage: NSAttributedString(string:"Update"), nextTimeButtonMessage: NSAttributedString(string:"OK, next time it is!"), skipVersionButtonMessage: NSAttributedString(string:"Please don't push skip, please don't!"))
        
        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        
        siren.checkVersion(checkType: .immediately)
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        update = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //        update = 0
        
        
        RCSocketManager.shared.stopObserving()
        if Singletons.manager.isScanning {
            Singletons.manager.stopScanning()
        }
        if Singletons.manager.peripherals.count > 0 {
            Singletons.manager.disconnectAllPeripherals()
            Singletons.manager.removeAllPeripherals()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //        update = 0
        
        Siren.shared.checkVersion(checkType: .immediately)
        
        Defaults().set(false, for: Key<Bool>("isPopUpPresented"))
        Defaults().set(false, for: Key<Bool>("isPopUpPresentedInMainController"))
        
        if Defaults().get(for: Key<Bool>("isLoggedIn")) ?? false {
            RCSocketManager.shared.startObserving()
            // popUpViewForAlerts()
        }
        
        getDevices()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [RCGlobals.NotificationType.spymode.rawValue])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [RCGlobals.NotificationType.powerCut.rawValue])
        // scheduleLocal(identifierType: RCGlobals.NotificationType.spymode.rawValue)
        
        handleBackgroundNotification()
        
    }
    
    func handleBackgroundNotification() {
        if Defaults().get(for: Key<String>(defaultKeyNames.callIMEI.rawValue)) != nil {
            let acceptShown:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue)) ?? false
            if !acceptShown {
                UIApplication.topViewController()?.present(AcceptCallVC(), animated: true, completion: nil)
            }
        }
    }
    
    func getDevices() {
        RCLocalAPIManager.shared.getDevices(success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.getPositions()
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            print(weakSelf)
        }
    }
    
    func getPositions() {
        RCLocalAPIManager.shared.getPositions(success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.getExpiredVehiclesData()
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.getExpiredVehiclesData()
        }
    }
    
    func getExpiredVehiclesData() {
        RCLocalAPIManager.shared.getExpiredVehicles(with:"", success: { (success) in
            print("success in getting expired vehicles info")
        }) { (failure) in
            print("failure in getting expired vehicles info")
        }
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        Siren.shared.checkVersion(checkType: .daily)
        
        ReachabilityManager.shared()
        update = 0
        var freahchatUnreadCount = Int()
        Freshchat.sharedInstance().unreadCount { (unreadCount) in
            freahchatUnreadCount = unreadCount
        }
        UIApplication.shared.applicationIconBadgeNumber = freahchatUnreadCount;
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        update = update + 1
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Freshchat.sharedInstance().setPushRegistrationToken(deviceToken)
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        Defaults().set("\(token ?? "")", for: Key<String>("RCFCMToken"))
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
        }
        let deviceName = userInfo["vehicleName"] as! String
        let mode = userInfo["mode"] as! String
        let uniqueId = userInfo["unique_id"] as? String
        
        let event = userInfo["eventType"] as! String
        if event == "sos" {
            Defaults().set("sos", for: Key<String>("AlertPopWindow"))
            Defaults().set(deviceName, for: Key<String>("deviceName"))
            //  scheduleLocal(identifierType: RCGlobals.NotificationType.sos.rawValue)
        } else if event == "powerCut" {
            Defaults().set("CutOff", for: Key<String>("AlertPopWindow"))
            Defaults().set(deviceName, for: Key<String>("deviceName"))
            scheduleLocal(identifierType: RCGlobals.NotificationType.powerCut.rawValue)
        } else {
            if event == "unauthorised_parking" {
                Defaults().set(deviceName, for: Key<String>("deviceName"))
                Defaults().set(deviceName, for: Key<String>(defaultKeyNames.callName.rawValue))
                Defaults().set(uniqueId ?? "", for: Key<String>(defaultKeyNames.callIMEI.rawValue))
            } else {
                if mode == "parking" || mode == "owl" {
                    Defaults().set("spymode", for: Key<String>("AlertPopWindow"))
                    Defaults().set(deviceName, for: Key<String>("deviceName"))
                    // scheduleLocal(identifierType: RCGlobals.NotificationType.spymode.rawValue)
                }
            }
        }
        
        if event == "unauthorised_parking" {
            Defaults().clear(Key<String>("AlertPopWindow"))
        }
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
        }
        guard let tempDevice = userInfo["vehicleName"], let tempEvent = userInfo["eventType"] else { return }
        
        let deviceName = tempDevice as! String
        let mode = userInfo["mode"] as! String
        let uniqueId = userInfo["unique_id"] as? String
        
        
        
        let event = tempEvent as! String
        //        let event = userInfo["eventType"] as! String
        if event == "sos" {
            Defaults().set("sos", for: Key<String>("AlertPopWindow"))
            Defaults().set(deviceName, for: Key<String>("deviceName"))
            //scheduleLocal(identifierType: RCGlobals.NotificationType.sos.rawValue)
        } else if event == "powerCut" {
            Defaults().set("CutOff", for: Key<String>("AlertPopWindow"))
            Defaults().set(deviceName, for: Key<String>("deviceName"))
            //            scheduleLocal(identifierType: RCGlobals.NotificationType.powerCut.rawValue)
        } else {
            if event == "unauthorised_parking" {
                //            Defaults().set("unauthorised_parking", for: Key<String>("AlertPopWindow"))
                Defaults().set(deviceName, for: Key<String>("deviceName"))
                Defaults().set(deviceName, for: Key<String>(defaultKeyNames.callName.rawValue))
                Defaults().set(uniqueId ?? "", for: Key<String>(defaultKeyNames.callIMEI.rawValue))
            } else {
                if mode == "parking" || mode == "owl" {
                    Defaults().set("spymode", for: Key<String>("AlertPopWindow"))
                    Defaults().set(deviceName, for: Key<String>("deviceName"))
                }
            }
        }
        
        if event == "unauthorised_parking" {
            Defaults().clear(Key<String>("AlertPopWindow"))
        }
        
        let tempDeviceName = Defaults().get(for: Key<String>("deviceName")) ?? ""
        
        let state = UIApplication.shared.applicationState
        if state == .active && (tempDeviceName == deviceName) {
            // foreground
            if event == "unauthorised_parking" {
                let isCallOngoing:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue)) ?? false
                if !isCallOngoing {
                    let acceptShown:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue)) ?? false
                    if !acceptShown {
                        UIApplication.topViewController()?.present(AcceptCallVC(), animated: true, completion: nil)
                    }
                }
                
            } else {
                if window?.rootViewController is SosAlertController {
                    print("do nothing")
                } else {
                    let popUpVC = SosAlertController()
                    popUpVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    // window?.topMostController()?.present(popUpVC, animated: true, completion: nil)
                    window?.rootViewController?.present(popUpVC, animated: true, completion: nil)
                    window?.makeKeyAndVisible()
                    window?.isHidden = false
                }
            }
        }
        
    }
    
    func scheduleLocal(identifierType: String) {
        let content = UNMutableNotificationContent()
        // content.title = NSString.localizedUserNotificationString(forKey: "reminder!", arguments: nil)
        // content.body = NSString.localizedUserNotificationString(forKey: "Reminder body.", arguments: nil)
        
        if identifierType == RCGlobals.NotificationType.spymode.rawValue {
            content.sound =  UNNotificationSound(named: "spyModeAlert.wav")
        } else if identifierType == RCGlobals.NotificationType.powerCut.rawValue  {
            content.sound =  UNNotificationSound(named: "cutOffAlert.wav")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let identifier = identifierType
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("local notification created successfully.")
            }
        })
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        //handle the opening the app from here
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            //user has opend the app from usl here get the
            let URL: URL? = userActivity.webpageURL
            let followerTokenForChat: String = URL?.query?.replacingOccurrences(of: "id=", with: "") ?? ""
            
            if let isLoogedIn = Defaults().get(for: Key<Bool>("isLoggedIn")) {
                if isLoogedIn {
                    
                    Defaults().set(followerTokenForChat, for: Key<String>("ShareVehicleFollowerPin"))
                    
                    let font: UIFont = UIFont(name: "AppleSDGothicNeo-Light", size: 13)!
                    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
                    
                    if window?.topMostController() is ViewController {
                        //do nothing nothing to present here
                    } else {
                        //present controller here
                        //                        application.keyWindow?.rootViewController?.present(FolloweShareViewController(), animated: true, completion: nil)
                        window?.rootViewController = FolloweShareViewController()
                    }
                    
                }
            } else {
                window?.rootViewController = LoginViewController()
            }
        }
        return true
        
    }
    
    
}

extension AppDelegate: MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        Defaults().set(fcmToken ?? "", for: Key<String>("RCFCMToken"))
        if let isLoogedIn = Defaults().get(for: Key<Bool>("isLoggedIn")) {
            let isNotificationsOn:Bool = Defaults().get(for: Key<Bool>("NotificationOnOffSetting")) ?? false
            if isLoogedIn && isNotificationsOn {
                let userName = UserDefaults.standard.string(forKey: "userName") ?? ""
                let userPassword = UserDefaults.standard.string(forKey: "userPassword") ?? ""
                RCLocalAPIManager.shared.login(loadingMsg: "", with: userName, password: userPassword, isLogin: true, success: { _ in
                    print("success")
                }) { (_) in
                    print("failed")
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if Freshchat.sharedInstance().isFreshchatNotification(notification.request.content.userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(notification.request.content.userInfo, andAppstate: UIApplication.shared.applicationState) //Handled for freshchat notifications
        } else {
            if notification.request.content.userInfo.count == 0 {
                return
            }
            
            let mode = notification.request.content.userInfo["mode"] as? String
            let deviceName = notification.request.content.userInfo["vehicleName"] as? String
            
            let event = notification.request.content.userInfo["eventType"] as? String
            let uniqueId = notification.request.content.userInfo["unique_id"] as? String
            if event == "sos" {
                Defaults().set("sos", for: Key<String>("AlertPopWindow"))
                Defaults().set(deviceName ?? "", for: Key<String>("deviceName"))
                //  scheduleLocal(identifierType: RCGlobals.NotificationType.sos.rawValue)
            } else if event == "powerCut" {
                Defaults().set("CutOff", for: Key<String>("AlertPopWindow"))
                Defaults().set(deviceName ?? "", for: Key<String>("deviceName"))
                scheduleLocal(identifierType: RCGlobals.NotificationType.powerCut.rawValue)
            } else {
                if event == "unauthorised_parking" {
                    Defaults().set(deviceName ?? "", for: Key<String>("deviceName"))
                    Defaults().set(deviceName ?? "", for: Key<String>(defaultKeyNames.callName.rawValue))
                    Defaults().set(uniqueId ?? "", for: Key<String>(defaultKeyNames.callIMEI.rawValue))
                } else {
                    if mode == "parking" || mode == "owl" {
                        Defaults().set("spymode", for: Key<String>("AlertPopWindow"))
                        Defaults().set(deviceName ?? "", for: Key<String>("deviceName"))
                        // scheduleLocal(identifierType: RCGlobals.NotificationType.spymode.rawValue)
                    }
                }
            }
            
            if event == "unauthorised_parking" {
                Defaults().clear(Key<String>("AlertPopWindow"))
            }
            
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive: UNNotificationResponse,
                                withCompletionHandler: @escaping () -> ()) {
        if Freshchat.sharedInstance().isFreshchatNotification(didReceive.notification.request.content.userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(didReceive.notification.request.content.userInfo, andAppstate: UIApplication.shared.applicationState) //Handled for freshchat notifications
        } else {
            let deviceName = didReceive.notification.request.content.userInfo["vehicleName"] as! String
            let mode = didReceive.notification.request.content.userInfo["mode"] as! String
            
            let event = didReceive.notification.request.content.userInfo["eventType"] as! String
            
            let uniqueId = didReceive.notification.request.content.userInfo["unique_id"] as? String
            if event == "sos" {
                Defaults().set("sos", for: Key<String>("AlertPopWindow"))
                Defaults().set(deviceName , for: Key<String>("deviceName"))
                //  scheduleLocal(identifierType: RCGlobals.NotificationType.sos.rawValue)
            } else if event == "powerCut" {
                Defaults().set("CutOff", for: Key<String>("AlertPopWindow"))
                Defaults().set(deviceName , for: Key<String>("deviceName"))
                scheduleLocal(identifierType: RCGlobals.NotificationType.powerCut.rawValue)
            } else {
                if event == "unauthorised_parking" {
                    Defaults().set(deviceName , for: Key<String>("deviceName"))
                    Defaults().set(deviceName , for: Key<String>(defaultKeyNames.callName.rawValue))
                    Defaults().set(uniqueId ?? "", for: Key<String>(defaultKeyNames.callIMEI.rawValue))
                } else {
                    if mode == "parking" || mode == "owl" {
                        Defaults().set("spymode", for: Key<String>("AlertPopWindow"))
                        Defaults().set(deviceName , for: Key<String>("deviceName"))
                        // scheduleLocal(identifierType: RCGlobals.NotificationType.spymode.rawValue)
                    }
                }
            }
            
            if event == "unauthorised_parking" {
                Defaults().clear(Key<String>("AlertPopWindow"))
            }
            
            
            withCompletionHandler() //For other notifications
        }
    }
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

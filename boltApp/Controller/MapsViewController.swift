//
//  MapsViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import GooglePlaces
import GoogleMaps
import DefaultsKit
import SnapKit
import RealmSwift
import KeychainAccess
import SwiftSoup
import Alamofire
import CoreLocation
import Realm
import ObjectMapper_Realm
import Firebase
import FirebaseAuth
import FirebaseDatabase
import GoogleMapsUtils

public enum RCPlotType: Int {
    case marker
    case polyline
}
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}
var isLoadedFirstTime = true
var markers:[RCMarker] = []
var flag = true
var isSelectedDevice: Bool = true
var selectedDeviceId: Int = 0
var isPathButtonTapped: Bool = false
var isDailyButtonTapped: Bool = false
var polyPath:GMSMutablePath?
var gmsPath:GMSMutablePath = GMSMutablePath()
var isBottomSheetVisible: Bool = false
var isBottomSheetVisibleWatch: Bool = false
var bottomSheetDeviceId: Int = 0
var bottomSheetHeight: CGFloat = 0.0
var bottomSheet: BottomSheetView!
var temp = 0
var bottomSheetWatch : BottomSheetWatchView!
var realm: Realm!
var totalDistance:Double = 0
var isSecondFlag = false
var isMapMoved: Bool = false
var nearbyplaceview: NearByPlacesView!
var kscreenheight = UIScreen.main.bounds.height
var kscreenwidth = UIScreen.main.bounds.width
let nearbyitem : [String] = ["Gas stations" , "Restroom","Restaurant", "Medical Facility","Police Station"]
let nearbyitemSearchList : [String] = ["petrol","Restroom","Restaurant","hospital","Police"]
let nearbyimages = [#imageLiteral(resourceName: "petrol") , #imageLiteral(resourceName: "Restroom") ,#imageLiteral(resourceName: "Restraunt") , #imageLiteral(resourceName: "Medical") , #imageLiteral(resourceName: "plolice") ]
let cell = "cell"

var isnearbyplaceButtonTapped: Bool  = false
var isNearbyVehicleTapped = false
var indexDevicePath = 0
var isPlayBackButtonTapped: Bool = false//

var isTrailing:Bool = false
var trailingLocationDict:[Int:[CLLocationCoordinate2D]] = [:]
var trailingPolylineDict:[Int:GMSMutablePath] = [:]
var polyLine:GMSPolyline?

class MapsViewController: UIViewController {
    let nc = NotificationCenter.default
    var isPresentSecondExpiryPopup = false
    var realm: Realm!
    //for popups
    var expiryDateArray: [String] = []
    var expiredVehicles: [String] = []
    var expireInSevenDays: [String] = []
    var expiredVehicleRegistrationName: [String] = []
    var expireInSevenDaysRegistrationName: [String] = []
    var expiredDeviceIds: [String] = []
    var LocationArray: [CLLocation] = []
    var StopsLocationArray: [CLLocation] = []
    var StopsCoordinateArray:[CLLocationCoordinate2D] = []
    var coordinateArray:[CLLocationCoordinate2D] = []
    var bounds = GMSCoordinateBounds()
    var ignitionOnOffLocationArray:[String] = []
    var idleTime:Float = 0.0
    var startmarker: GMSMarker!
    var endMarker: GMSMarker!
    var expiredAlert = "Your Subscription has Expired!"
    var expireInSevenAlert = "Your Subscription is about to Expire in a week!"
    var deviceId: String = ""
    var locationArray: [CLLocationCoordinate2D] = []
    var mapHomeView: MapView!
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var alarmSetting: [String: String]?
    var selectedDeviceLatitute: Double?
    var selectedDeviceLongitute: Double?
    var login_model: loginInfoModel?
    var bottomSheetData: DevicePopupDetailsModel?
    var type: String?
    var alarm: String?
    var isParkingModeOn : Bool!
    var watchProtocol = "watch"
    var currentLocation: CLLocation!
    let locManager = CLLocationManager()
    var isSelectedDashboard = false
    let kClusterItemCount = 38
    let kCameraLatitude = -33.8
    let kCameraLongitude = 151.2
    var allDevices:[TrackerDevicesMapperModel]!
    //MARK:- Playback Variables
    var locale = NSLocale.current
    var datePpicker : UIDatePicker!
    var toolBbar = UIToolbar()
    var timeTo : String = ""
    //MARK: Second
    var dateFormatter = DateFormatter()
    var datePppicker : UIDatePicker!
    var toolBbbar = UIToolbar()
    var datePpppicker : UIDatePicker!
    var toolBbbbar = UIToolbar()
    var dateFrom : String = ""
    var playbackview : PlayBackView!
    var replaySpeed:Double = 1
    var markerType:Int = 0
    var optionchoise: String = ""
    var dateFromInDate = Date()
    var timeToInDate = Date()
    var selectdeviceid: String = ""
    var firstTimeSelected:String = ""
    var lastTimeSelected:String = ""
    var firstDateSelected: String = ""
    var secondDateSelected:String = ""
    var datearray: [String] = []
    var idleTimeDifferenceArray:[Int] = []
    var idleIntervalArray:[String] = []
    var animateIndex: Int = 0
    var pathMarker: GMSMarker!
    var combinationOfDateAndTime:String = ""
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    //MARK:- Playback Variables Ends
    var subtitle:[String] = ["CURRENT TRIP DIST.","LAST IGNITION ON","MAXIMUM SPEED"]
    var subtitle1:[String] = ["TRIP DURATION","NO. OF STOPS","TOTAL DAILY DIST."]
    var sheetData:[String:String] = [:]
    var maxspeed: String = ""
    var totaldis: String = ""
    var tripduration: String = ""
    var tripdistance:String = ""
    var ignitiontime:String = ""
    var noofstops:String = ""
    var orders: BottomViewCollectionViewCell!
    let cell1 = "cell"
    let moreinfoController = MoreInfoVC()
    var pageControl: UIPageControl!
    var thisWidth:CGFloat = 0
    // Image Markers
    var multipleselectionEnabled: Bool = false
    var selectedDeviceIdArray: [Int] = []
    var dateCounter:Int = 0
    var completePlayBackPath:[PlaybackReportModelData] = []
    
    var markerList:[MarkerFirebaseModel] = []
    
    var second = 3
    var timer: Timer!
    
    var markerRef : DatabaseReference!
    
    var withLimit : Bool = false
    
    var startTime : NSDate!
    
    var endTime : NSDate!
    
    var HUD: MBProgressHUD?
    
    var poiMarkerList: [GMSMarker] = []
    var MarkerList:[GMSMarker] = []
    var LabelMarkerList:[GMSMarker] = []
    var poiLabelMarkerList: [GMSMarker] = []
    var pathSelectedId = 0
    var directionCounter:Int = 0
    
    fileprivate var didTapMarker:Bool = false
    
    fileprivate lazy var devices: [TrackerDevicesMapperModel]? = {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        return RCGlobals.getExpiryFilteredList(data)
    }()
    
    fileprivate lazy var positions: [TrackerPositionMapperModel]? = {
        return Defaults().get(for: Key<[TrackerPositionMapperModel]>("allPositions")) ?? []
    }()
    
    fileprivate lazy var usersHierarchy:UsersHerarchy? = {
        return Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy")) ?? nil
    }()
    
    func getDevices(value: TrackerDevicesMapperModel, expiredorNot: Bool) {
        if expiredorNot {
            
        } else if !expiredorNot {
            updateDeviceOnly(device: value)
        }
    }
    
    func getPosition(value: TrackerPositionMapperModel,expiredorNot: Bool) {
        if expiredorNot {
            
        } else if !expiredorNot {
            updateDevicePosition(position: value)
        }
    }
    
    var singleGeoFence: [SingleVehicleGeoFence]?
    
    var clusterManager: GMUClusterManager!
    var markerArrayList:[GMSMarker] = []
    var markerSetting = Defaults().get(for: Key<Bool>("ShowClusterMarkerSettings")) ?? false
    
    var isMarkerLabelShowed:Bool = Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
    
    var selectedUserId: String = Defaults().get(for: Key<String>(defaultKeyNames.selectedBranch.rawValue)) ?? "0"
    
    var selectedVehicleType:Int = Defaults().get(for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue)) ?? vehicleSelectedState.all.rawValue
    
    var destinationMarker:GMSMarker?
    
    var directionMarkerArray:[GMSMarker] = []
    
    //MARK:- Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callCalledCreditsApi()
        nc.addObserver(self, selector: #selector(findExpiryDate), name: Notification.Name("UserLoggedIn"), object: nil)
        mapHomeView = MapView(frame: view.bounds)
        view.addSubview(mapHomeView)
        getDevices()
        drawMultipleGeofencesOnMap()
        alarmSettingFunction()
        usersHierarchy = Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy")) ?? nil
        RCMapView.mapView.delegate = self
        bottomSheetFunction()
        mapHomeView.directionButton.addTarget(nil, action:#selector(directionButtonAction(sender:)), for: .touchUpInside)
        mapHomeView.backButton.addTarget(self, action: #selector(backbuttontapped), for: .touchUpInside)
        mapHomeView.searchButton.addTarget(self, action: #selector(googlePlaceSearch), for: .touchUpInside)
        navigationItem.backBarButtonItem = UIBarButtonItem()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backbuttontapped))
        
        Auth.auth().signInAnonymously { (user, error) in
            
        }
        setUpOptionButtonView()
        //* cluster manager
        initClusterManager()
        // getGeofences for reachability
        getGeofences()
        
    }
    @objc func googlePlaceSearch(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func getGeofences() {
        let userId = (Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel")))?.id ?? 0
        RCLocalAPIManager.shared.getGeofences(loadingMsg: "", with: "userId", id: userId, success: { hash in
            print("Geofences saved successfully.")
            Defaults().set(hash, for: Key<[GeofenceModel]>("allUserGeofenceModel"))
            self.setGeofenceForPointOfInterests()
        }) { message in
            print("unable to fetch geofences: \(message)")
        }
    }
    
    func initClusterManager() {
        let iconGenerator = MapClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: RCMapView.mapView, clusterIconGenerator: iconGenerator)
        self.clusterManager = GMUClusterManager(map: RCMapView.mapView, algorithm: algorithm, renderer: renderer)
       // clusterManager.setMapDelegate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTrailing = false
        if let marker = destinationMarker {
            marker.map = nil
            polyLine?.map = nil
            if trailingPolylineDict[selectedDeviceId] != nil {
                trailingLocationDict.removeAll()
                trailingPolylineDict.removeAll()
                initDevicePosition(device: selectedDeviceId)
            }
        }
        isMarkerLabelShowed = Defaults().get(for: Key<Bool>("ShowMarkerSettings")) ?? false
        let shouldClearMap = Defaults().get(for: Key<Bool>("should_clear_map"))
        markerSetting = Defaults().get(for: Key<Bool>("ShowClusterMarkerSettings")) ?? false
        isMapMoved = false
        if shouldClearMap == true{
            if clusterManager != nil {
                clusterManager.clearItems()
            }
            RCMapView.clearMap()
            handleMarkerPlotting()
        }
    }
    
    func handleMarkerPlotting () {
        let selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
        selectedVehicleType = Defaults().get(for: Key<Int>(defaultKeyNames.deviceSelectedState.rawValue)) ?? vehicleSelectedState.all.rawValue
        
        if selectedDeviceIdArray.count == 1 {
            selectedVehiclesTapped(deviceIds: selectedDeviceIdArray)
            initDevicePosition(device: selectedDeviceId)
        } else {
            initDevicesPositions(vehicleType: selectedVehicleType)
        }
    }
    // Marker fetchCode
    
    func getDeviceMarkersForDate(deviceId:String){
        second = 3
        let topWindow = UIApplication.shared.keyWindow
        HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        HUD?.animationType = .fade
        HUD?.mode = .indeterminate
        HUD?.labelText = "Fetching additional info...".toLocalize
        
        let time = NSDate()
        
        markerList.removeAll()
        
        let date = RCGlobals.getFormattedDate(date: time, format: "dd-MM-yyyy", zone:TimeZone(identifier:"UTC")!)
        
        markerRef = Database.database().reference().child("Bolt/Markers").child(deviceId).child(date)
        
        markerRef.observe(.childAdded, with: { [] (snapshot) in
            if let response = snapshot.value as? [String : AnyObject] {
                let markerFirebaseModel:MarkerFirebaseModel = MarkerFirebaseModel()
                markerFirebaseModel.deviceId = deviceId
                if let title = response["title"] as? String{
                    markerFirebaseModel.title = title
                }
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
        if selectedDeviceId == 0
        {
            selectedDeviceId = bottomSheetDeviceId
        }
        if second == 0 {
            timer.invalidate()
            markerRef.removeAllObservers()
            HUD?.hide(true)
            if  withLimit {
                let filteredList : [MarkerFirebaseModel]  = RCGlobals.getFilteredMarkerListWithTimeLimit(markerList: markerList, startTime: startTime, endTime: endTime, deviceId: "\(selectedDeviceId)")
                plotImageMarkersOnMap(markerImageList: filteredList)
            } else {
                plotImageMarkersOnMap(markerImageList: markerList)
            }
        }
    }
    
    func plotImageMarkersOnMap (markerImageList: [MarkerFirebaseModel]) {
        for markerFirebaseModel in markerImageList {
            let coordinates = CLLocationCoordinate2D(latitude: markerFirebaseModel.deviceLat!, longitude: markerFirebaseModel.deviceLng!)
            let imageMarker = GMSMarker(position: coordinates)
            imageMarker.map = mapHomeView.rcMapView
            imageMarker.icon = #imageLiteral(resourceName: "ic_camera_icon").resizedImage(CGSize.init(width: 35, height: 48), interpolationQuality: .default)
            imageMarker.title = "Image_Title"
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                let jsonData = try encoder.encode(markerFirebaseModel)
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                    imageMarker.snippet = jsonString
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func callCalledCreditsApi() {
        let userId = (Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel")))?.id ?? 0
        RCLocalAPIManager.shared.getCallCredits(userId: "\(userId)", success: { (success) in
            print(success)
        }) { (failure) in
            print(failure)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationItem.backBarButtonItem = UIBarButtonItem()
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backbuttontapped))

        if !flag {
            OptionButtonTapped()
        }
        mapHomeView.directionButton.isHidden = true
        //        openPopUpAlertController()
        checkForBottomSheet()
        isPresentSecondExpiryPopup = false
        
        let selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
        if selectedDeviceIdArray.count == 1 {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    func setGeofenceForPointOfInterests() {
        
        let geofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel"))
        
        var geofenceWithSetDefauls : [GeofenceModel] = []
        
        if geofences?.count != 0 && geofences != nil {
            
            for geofence in geofences! {
                
                if let attributes = geofence.attributes {
                    
                    if attributes.set_default != nil && attributes.set_default != "0" {
                        
                        print("geofence area is : \(geofence.area)")
                        
                        if geofence.area != nil {
                            
                            geofenceWithSetDefauls.append(geofence)
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        Defaults().set(geofenceWithSetDefauls,for: Key<[GeofenceModel]>("geofenceWithSetDefaults"))
        
        
        
        
    }
    
    func setUpOptionButtonView() {
        mapHomeView.trafficButton.isHidden  = true
        mapHomeView.trafficlabel.isHidden  = true
        mapHomeView.nearbyplaceButton.isHidden = true
        mapHomeView.nearbyplaceLabel.isHidden = true
        
        mapHomeView.showPOIButton.isHidden = true
        mapHomeView.showPOILabel.isHidden = true
        
//        mapHomeView.nearbyVehicleLabel.isHidden = true
//        mapHomeView.nearbyVehicleButton.isHidden = true
        
        //        mapHomeView.addPOIButton.isHidden = true
        //        mapHomeView.addPOILabel.isHidden = true
        
        mapHomeView.nearbyVehicleLabel.isHidden = true
        mapHomeView.nearbyVehicleButton.isHidden = true
        
        mapHomeView.reachButton.isHidden = true
        mapHomeView.reachLabel.isHidden = true
        
        mapHomeView.trailButton.isHidden = true
        mapHomeView.trailLabel.isHidden = true
        
        mapHomeView.showPOIButton.setImage(#imageLiteral(resourceName: "ic_poi_hidden"), for: .normal)
        mapHomeView.showPOILabel.text = "Show POI".toLocalize
        
        mapHomeView.trafficButton.addTarget(self, action:#selector(trafficButtonTapped), for: .touchUpInside)
        
        mapHomeView.changeMapTypeBtn.addTarget(nil, action:#selector(changeMapTypeBtnAction(sender:)), for: .touchUpInside)
        
        mapHomeView.optionButton.addTarget(self, action:#selector(OptionButtonTapped), for: .touchUpInside)
        
        mapHomeView.nearbyVehicleButton.addTarget(nil, action: #selector(nearbyVehicleTapped), for: .touchUpInside)
        
        mapHomeView.nearbyplaceButton.addTarget(nil, action: #selector(nearbyplacestapped), for: .touchUpInside)
        
        //   mapHomeView.addPOIButton.addTarget(nil, action: #selector(addNewPOI), for: .touchUpInside)
      //  mapHomeView.nearbyVehicleButton.addTarget(nil, action: #selector(nearbyVehicleTapped), for: .touchUpInside)
        
        mapHomeView.showPOIButton.addTarget(nil, action: #selector(showHidePOI(sender:)), for: .touchUpInside)
        mapHomeView.reachButton.addTarget(nil, action: #selector(reachabilityCall(sender:)), for: .touchUpInside)
        mapHomeView.trailButton.addTarget(nil, action: #selector(showTrailPath(_:)), for: .touchUpInside)
        if !isnearbyplaceButtonTapped && mapHomeView.nearbyplaceButton != nil {
            mapHomeView.nearbyplaceButton.setImage(#imageLiteral(resourceName: "Nearby"), for:.normal)
        }
        
        if !isNearbyVehicleTapped && mapHomeView.nearbyVehicleButton != nil {
            mapHomeView.nearbyVehicleButton.setImage(#imageLiteral(resourceName: "ic_nearby_vehicle"), for:.normal)
        }
        
//        if !isNearbyVehicleTapped && mapHomeView.nearbyVehicleButton != nil {
//            mapHomeView.nearbyVehicleButton.setImage(#imageLiteral(resourceName: "ic_nearby_vehicle"), for:.normal)
//        }
    }
    @objc func showTrailPath(_ sender:UIButton){
        if !isTrailing {
            mapHomeView.trailButton.setImage(#imageLiteral(resourceName: "trail"), for: .normal)
            mapHomeView.trailLabel.text = "Hide Trail".toLocalize
            OptionButtonTapped()
            isTrailing = true
            trailingLocationDict.removeAll()
            trailingPolylineDict.removeAll()
        } else {
            mapHomeView.trailButton.setImage(#imageLiteral(resourceName: "trail_copy"), for: .normal)
            mapHomeView.trailLabel.text = "Show Trail".toLocalize
            OptionButtonTapped()
            isTrailing = false
            trailingLocationDict.removeAll()
            trailingPolylineDict.removeAll()
            initDevicePosition(device: selectedDeviceId)
        }
    }
    @objc func reachabilityCall(sender:UIButton){
        let controller = UINavigationController(rootViewController: ReachabilityViewController())
        controller.navigationBar.backgroundColor = .white
        self.present(controller, animated: false, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if nearbyplaceview != nil {
            nearbyplaceview.isHidden = true
            
        }
        
        if !flag {
            OptionButtonTapped()
        }
        if Defaults().get(for: Key<Bool>("isPopUpPresented")) == false &&
            Defaults().get(for: Key<Bool>("isPopUpPresentedInMainController")) == false {
            showExpiredSubscriptionDatePopup()
        }
        
        let selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
        if selectedDeviceIdArray.count == 1 {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
    }
    
    func alarmSettingFunction() {
        login_model =   Defaults().get(for: Key<loginInfoModel>("loginInfoModel")) ?? nil
        if login_model != nil {
            if login_model?.data?.user?.alarmSettings != nil {
                alarmSetting = (RCGlobals.convertToDictionary(text: (login_model?.data?.user?.alarmSettings)!) as! [String : String])
            }
        }
        checkForAlamrAndType()
    }
    
    func checkForAlamrAndType() {
        if alarmSetting != nil{
            type =  alarmSetting!["type"]?.lowercased()
            alarm = alarmSetting!["alarm"]?.lowercased()
        }
    }
    
    func bottomSheetFunction() {
        if let height = self.tabBarController?.tabBar.frame.size.height {
            bottomSheetHeight = (view.frame.size.height / 1.9) + (height)
            bottomSheet = BottomSheetView(frame: CGRect(x: 0, y: self.view.frame.maxY + 400,
                                                        width: view.frame.size.width,
                                                        height: bottomSheetHeight - 400))
            bottomSheet.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)//70,71,102
        }
        view.addSubview(bottomSheet)
        
        bottomSheet.tripDetailsCollection.delegate = self
        bottomSheet.tripDetailsCollection.dataSource = self
        bottomSheet.tripDetailsCollection.register(BottomViewCollectionViewCell.self, forCellWithReuseIdentifier: "cell1")
        pageControl = UIPageControl(frame: CGRect.zero)
        pageControl.numberOfPages = 4
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor =  UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        pageControl.hidesForSinglePage = true
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints{(make) in
            make.top.equalTo(bottomSheet.tripDetailsCollection.snp.bottom).offset(0.001 * kscreenheight)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.4 * kscreenwidth)
            make.height.equalTo(0.03 * kscreenheight)
        }
        if let height = self.tabBarController?.tabBar.frame.size.height {
            
            bottomSheetHeight = (view.frame.size.height / 2) + (height)
            bottomSheetWatch = BottomSheetWatchView(frame: CGRect(x: 0, y: view.frame.maxY + 400, width: view.frame.size.width, height: bottomSheetHeight - 400))
        }
        view.addSubview(bottomSheetWatch)
        
        bottomSheetWatch.timeLabel.delegate = self
        bottomSheet.moreInfoButton.addTarget(self, action: #selector(moreinfotapped(_:)), for: .touchUpInside)
        bottomSheetWatch.timeButton.addTarget(self, action: #selector(alarmLabelWatchPressed(sender:)), for: .touchUpInside)
        
        let stringWatch = "Device_Watch"
        let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        if let date24 = Defaults().get(for: Key<String>("\(deviceId)_AlarmOn")){
            
            bottomSheetWatch.timeButton.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
            bottomSheetWatch.timeLabel.text = date24
            
        }
        
        bottomSheetWatch.realtimeButton.addTarget(self, action: #selector(careModeEnabled(sender:)), for: .touchUpInside)
        
        bottomSheet.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))
        /// Daily Path
        bottomSheet.liveshareView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(liveShareTapped)))
        /// Ignition Path
        bottomSheet.calldriverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callDriverTapped)))
        /// Path replay
        bottomSheet.pathreplayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setupPathChooser)))
        bottomSheet.addphotoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhotoTapped)))
        
        bottomSheet.fuelmeterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFuelController(_:))))
        
        
        bottomSheetWatch.newfeatureScroll.isUserInteractionEnabled = true
        bottomSheetWatch.newfeatureScroll.ignitionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cameraBtnWatchModePressed(_:))))
        
        
        bottomSheetWatch.newfeatureScroll.isUserInteractionEnabled = true
        bottomSheetWatch.newfeatureScroll.watchUpdateImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(updateWatchTImeWithMobileTimeBtnPressed(_:))))
        
        bottomSheetWatch.newfeatureScroll.geoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callWatchBtnPressed(_:))))
        
        
        bottomSheetWatch.newfeatureScroll.networkImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAlbumWatchPressed(_:))))
        
        bottomSheetWatch.newfeatureScroll.immoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phonebookBtnPressed(sender:))))
        
    }
    
    @objc func liveShareTapped() {
        let page = ShareLocPopVC()
        page.deviceId = bottomSheetDeviceId
        page.modalPresentationStyle = .custom
        self.present(page, animated: true, completion: nil)
    }
    
    @objc func callDriverTapped() {
        RCLocalAPIManager.shared.getDeviceDrivers(deviceId: "\(bottomSheetDeviceId)", success: { driverInfo in
            var array:[DriverInfoResponseModel] = []
            array.append(driverInfo)
            self.presentCallDriver(title: "Call Driver", message: "Choose driver", options: array, completion: { driver in
                if let url = URL(string: "tel://\(driver.mobile)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    self.prompt("Unable to call admin ( \(driver.mobile) )")
                }
            })
        }, failure: { error in
            self.prompt("Unable to get drivers.")
        })
    }
    
    @objc func moreinfotapped(_ sender: UIButton )
    {
        let controller = MoreInfoVC()
        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        
        
    }
    
    
    @objc func phonebookBtnPressed(sender: UIButton) {
        
        let addcontacVC = AddContactVC()
        let stringWatch = "Device_Watch"
        let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        addcontacVC.watchId = deviceId
        let navController = UINavigationController(rootViewController: addcontacVC)
        
        // Creating a navigation controller with resultController at the root of the navigation stack.
        
        navController.navigationBar.backgroundColor = UIColor.white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated:false, completion: nil)
        
    }
    
    
    
    @objc func careModeEnabled(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        let stringWatch = "Device_Watch"
        let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        if !sender.isSelected {
            
            sender.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
            
            RCLocalAPIManager.shared.sendCommand(with: deviceId, command: "UPLOAD,600",
                                                 success: {  data in
                                                    
                                                    sender.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
                                                    Defaults().set(false, for: Key<Bool>("CareMode_\(deviceId)"))
                                                    
                                                    UIApplication.shared.keyWindow?.makeToast("Device updated Successfully".toLocalize,
                                                                                              duration: 2.0, position: .bottom)
                                                    
                                                 }) { (data) in
                
                UIApplication.shared.keyWindow?.makeToast("Device Not updated".toLocalize,
                                                          duration: 2.0, position: .bottom)
                
            }
            
            
        } else {
            
            
            RCLocalAPIManager.shared.sendCommand(with: deviceId, command: "UPLOAD,60",
                                                 success: { data in
                                                    
                                                    sender.setImage(#imageLiteral(resourceName: "green notification"), for: .normal)
                                                    Defaults().set(true, for: Key<Bool>("CareMode_\(deviceId)"))
                                                    
                                                    UIApplication.shared.keyWindow?.makeToast("Device updated Successfully".toLocalize,
                                                                                              duration: 2.0, position: .bottom)
                                                    
                                                 }) { (data) in
                
                UIApplication.shared.keyWindow?.makeToast("Device Not updated".toLocalize,
                                                          duration: 2.0, position: .bottom)
                
            }
            
        }
        
    }
    
    @objc func alarmLabelWatchPressed(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        
        let stringWatch = "Device_Watch"
        let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        if !sender.isSelected {
            
            sender.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
            
            if let date24 = Defaults().get(for: Key<String>("\(deviceId)_AlarmOn")) {
                let timeString = "REMIND," + date24 + "-0-0"
                
                RCLocalAPIManager.shared.sendCommand(with: deviceId, command: timeString, success: { (_) in
                    
                    print("Disabling alarm for watch is successful")
                    let currentDate = Date()
                    let calendar = Calendar.current
                    let comp = calendar.dateComponents([.hour, .minute], from: currentDate)
                    _ = comp.hour!
                    _ = comp.minute!
                    Defaults().clear(Key<String>("\(deviceId)_AlarmOn"))
                    
                }) { (_) in
                    
                    print("Disabline alarm for watch is failure")
                }
                
            }
            
            
        } else {
            
            let time = bottomSheetWatch.timeLabel.text!
            
            print("time for alarm is \(time)")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let date = dateFormatter.date(from: time)
            dateFormatter.dateFormat = "HH:mm"
            let date24 = dateFormatter.string(from: date ?? Date())
            
            let timeString = "REMIND," + date24 + "-1-1"
            
            RCLocalAPIManager.shared.sendCommand(with: deviceId, command: timeString, success: { (_) in
                
                Defaults().set(date24, for: Key<String>("\(deviceId)_AlarmOn"))
                sender.setImage(#imageLiteral(resourceName: "green notification"), for: .normal)
                print("setting alarm for watch is successful")
                
            }) { (_) in
                
                print("setting alarm for watch is failure")
            }
        }
    }
    
    func openPopUpAlertController() {
        if Defaults().has(Key<String>("AlertPopWindow")) {
            if let alertType = Defaults().get(for: Key<String>("AlertPopWindow")) {
                let popUpVC = SosAlertController()
                popUpVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                if alertType == "sos" {
                    popUpVC.alertType = "sos"
                } else {
                    popUpVC.alertType = "powerCut"
                }
                self.present(popUpVC, animated: true, completion: nil)
            }
        }
    }
    
    func requestToUpdate(first: String, second: String) {
        RCLocalAPIManager.shared.putUsersCarsData(deviceId: deviceId, first: first, second: second, success: { [weak self]hash in
            guard let weakself = self else { return }
            weakself.view.setNeedsDisplay()
        }) { [weak self] message in
            guard let _ = self else { return }
            print(message)
        }
    }
    
    func showTextInView(model: EditDevicesInfosModelData) {
        expiredVehicleDate = model.subscriptionExpiryDate ?? ""
    }
    
    @objc func doubleTapped(_ sender  : AnyObject) {
        self.navigationController?.pushViewController(AttentionVC(), animated: true)
    }
    
    func getDevices() {
        RCLocalAPIManager.shared.getDevices(success: { [weak self] hash in
            guard let weakSelf = self else { return }
            let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
            
            let devicessAll = RCGlobals.getExpiryFilteredList(data)
            
            weakSelf.devices = self?.checkExpiredOrNotDevices(checkArray: devicessAll)
            weakSelf.getPositions()
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.handleMarkerPlotting()
        }
    }
    
    func getPositions() {
        let park = ParkingViewController()
        park.syncParkingModeVehicle2()
        isParkingModeOn = UserDefaults.standard.bool(forKey: "isParkingModeOn")
        
        if isParkingModeOn == false {
            park.tabBarItem.selectedImage = UIImage(named: "parkingModeWhite")
        }
        else {
            park.tabBarItem.selectedImage = UIImage(named: "parking_icon")
        }
        RCLocalAPIManager.shared.getPositions(success: { [weak self] hash in
            guard let weakSelf = self else { return }
            weakSelf.positions = Defaults().get(for: Key<[TrackerPositionMapperModel]>("allPositions"))
            RCSocketManager.shared.startObserving()
            DispatchQueue.global(qos:.userInteractive).async {
                weakSelf.lastUpdateRequest()
                DispatchQueue.main.async {
                    weakSelf.refreshGoogleAddress()
                }
            }
            weakSelf.handleMarkerPlotting()
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.handleMarkerPlotting()
        }
        
    }
    
    // To show last update time left of ignition on/off icon
    func lastUpdateRequest(){
        let id =  Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel"))?.id
        if id != nil {
            RCLocalAPIManager.shared.lastActivationTime(with:id!, loadingMsg: "",success: { [weak self] hash in
                guard self != nil else {
                    return
                }
            }) { [weak self] message in
                guard let _ = self else {
                    return
                }
            }
        }
    }
    
    public func refreshGoogleAddress() {
        let expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as? [String] ?? [String]()
        
        for pos in positions! {
            if !expiredIdArray.contains(String(pos.deviceId!)) {
                let keyValue = "Position_" + "\(pos.deviceId ?? 0)"
                if let  devicePosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue)) {
                    
                    if let devLat = devicePosition.latitude, let devLng = devicePosition.longitude {
                        let cordinate = CLLocationCoordinate2D(latitude: devLat, longitude: devLng)
                        devPosCoordinateDic["\(devLat)\(devLng)"] = keyValue
                        updateGoogleAddress(cordinate: cordinate)
                    }
                }
            }
        }
    }
    
    public func updateGoogleAddress(cordinate: CLLocationCoordinate2D) {
        
        GMSGeocoder().reverseGeocodeCoordinate(cordinate) { (response, error) in
            guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else { return}
            let tempAddress = lines.joined(separator: " ")
            
            if let tempKeyValue = devPosCoordinateDic["\(Gaddress.coordinate.latitude)\(Gaddress.coordinate.longitude)"] {
                if let  tempDevPos = Defaults().get(for: Key<TrackerPositionMapperModel>(tempKeyValue)) {
                    tempDevPos.address = tempAddress
                    Defaults().set(tempDevPos, for: Key<TrackerPositionMapperModel>(tempKeyValue))
                    self.positions?.filter({$0.deviceId == tempDevPos.deviceId}).first?.address = tempAddress
                }
            }
        }
    }
    
    func didTapViewAllTrackersButton() -> Void {
        
    }
    
    @objc func changeMapTypeBtnAction(sender:UIButton){
        
        if sender.currentImage == #imageLiteral(resourceName: "Asset 67") {
            RCMapView.mapView.mapType = .hybrid
            mapHomeView.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 66"), for: .normal)
            mapHomeView.changeMapTypelbl.text = "Normal Map".toLocalize
            OptionButtonTapped()
        } else {
            RCMapView.mapView.mapType = .normal
            mapHomeView.changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for: .normal)
            mapHomeView.changeMapTypelbl.text = "Satellite Map".toLocalize
            OptionButtonTapped()
        }
    }
    
    @objc func showHidePOI(sender:UIButton){
        
        if sender.currentImage == #imageLiteral(resourceName: "ic_poi_hidden") {
            
            showAllPOIMarkers()
            mapHomeView.showPOIButton.setImage(#imageLiteral(resourceName: "ic_poi_visible"), for: .normal)
            mapHomeView.showPOILabel.text = "Hide POI".toLocalize
            OptionButtonTapped()
            
        } else {
            
            hideAllPOIMarkers()
            mapHomeView.showPOIButton.setImage(#imageLiteral(resourceName: "ic_poi_hidden"), for: .normal)
            mapHomeView.showPOILabel.text = "Show POI".toLocalize
            OptionButtonTapped()
            
        }
        
    }
    
    func showAllPOIMarkers () {
        if  let poidata = Defaults().get(for: Key<[POIInfoDataModel]> ("POI")) {
            poiMarkerList.removeAll()
            poiLabelMarkerList.removeAll()
            for poi in poidata {
                let coordinates = CLLocationCoordinate2D(latitude: Double(poi.lat ?? "0")!, longitude: Double(poi.lng ?? "0")!)
                let marker = GMSMarker(position: coordinates)
                
                marker.title = "POI_MARKER"
                marker.map = mapHomeView.rcMapView
                
                marker.icon = UIImage(named: "location")?.resizedImage(CGSize.init(width: 55, height: 55), interpolationQuality: .default)
                
                loadImageFromURL(poi, marker)
                
                poiMarkerList.append(marker)
                
                let poiLabelMarker:GMSMarker = addPOILabelMarker(coordinates, poi.title ?? "N/A")
                
                poiLabelMarkerList.append(poiLabelMarker)
                
            }
        }
    }
    
    func addPOILabelMarker(_ coordinates:CLLocationCoordinate2D, _ title:String) -> GMSMarker {
        let labelMarker = GMSMarker(position: coordinates)
        labelMarker.groundAnchor = CGPoint(x: 0.46, y: 4.3)
        labelMarker.isFlat = false
        labelMarker.isDraggable = false
        labelMarker.title = "MARKER"
        labelMarker.map = mapHomeView.rcMapView
        
        let lbl = UILabel()
        lbl.frame = CGRect(x: 0, y: 0, width: 80, height: 18)
        lbl.text = title
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.black
        lbl.layer.cornerRadius = 8
        lbl.alpha = 0.6
        lbl.textAlignment = .center
        lbl.baselineAdjustment = .alignCenters
        lbl.minimumScaleFactor = 0.2
        lbl.frame.size.width = lbl.intrinsicContentSize.width
        lbl.layer.masksToBounds = true
        labelMarker.iconView = lbl
        
        return labelMarker
    }
    
    
    
    func showAllMarkers(_ coordinates: CLLocationCoordinate2D , _ title: String) {
        
        let marker = GMSMarker(position: coordinates)
        marker.title = "MARKER"
        marker.map = mapHomeView.rcMapView
        
        
        MarkerList.append(marker)
        
        let LabelMarker:GMSMarker = addLabelMarkers(coordinates, title )
        
        LabelMarkerList.append(LabelMarker)
        
    }
    
    
    
    
    func addLabelMarkers(_ coordinates:CLLocationCoordinate2D, _ title:String) -> GMSMarker {
        let labelMarker = GMSMarker(position: coordinates)
        labelMarker.groundAnchor = CGPoint(x: 0.46, y: 4.3)
        labelMarker.isFlat = false
        labelMarker.isDraggable = false
        labelMarker.title = "MARKER"
        labelMarker.map = mapHomeView.rcMapView
        
        let lbl = UILabel()
        lbl.frame = CGRect(x: 0, y: 0, width: 80, height: 18)
        lbl.text = title
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.black
        lbl.layer.cornerRadius = 8
        lbl.alpha = 0.6
        lbl.textAlignment = .center
        lbl.baselineAdjustment = .alignCenters
        lbl.minimumScaleFactor = 0.2
        lbl.frame.size.width = lbl.intrinsicContentSize.width
        lbl.layer.masksToBounds = true
        labelMarker.iconView = lbl
        
        return labelMarker
    }
    
    func loadImageFromURL (_ poi:POIInfoDataModel, _ marker:GMSMarker) {
        guard let url = URL(string: poi.image ?? "") else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                
                let outsideImage = UIImage(named: "location")?.resizedImage(CGSize.init(width: 55, height: 55), interpolationQuality: .default)
                
                let markerIcon = self.drawPOIMarkerImage(image!,outsideImage!)
                
                marker.icon = markerIcon
            }
        }
    }
    
    func drawPOIMarkerImage(_ pp: UIImage,_ image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y - 2
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        
        return newImage
        
    }
    
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    func hideAllPOIMarkers () {
        for marker in poiMarkerList {
            marker.map = nil
        }
        for marker in poiLabelMarkerList {
            marker.map = nil
        }
    }
    
    @objc func addNewPOI(){
        let vc = AddPOIViewController()
        vc.buttonText = "ADD NEW"
        vc.isEdit = false
        vc.shouldShowMap = true
        let controller = UINavigationController(rootViewController: vc)
        controller.navigationBar.backgroundColor = .white
        self.present(controller, animated: false, completion: nil)
    }
    
    
    @objc func directionButtonAction(sender:UIButton){
        guard let latitute = selectedDeviceLatitute else {return }
        guard let longitude = selectedDeviceLongitute else {return}
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr&daddr=\(latitute),\(longitude)&directionsmode=driving")!,
                                      options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.open(URL(string:"https://www.google.com/maps/@\(latitute),\(longitude)")!,
                                      options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func OptionButtonTapped() -> Void {
        
        flag = !flag
        mapHomeView.trafficButton.isHidden = flag
        mapHomeView.trafficlabel.isHidden = flag
        mapHomeView.changeMapTypeBtn.isHidden = flag
        mapHomeView.changeMapTypelbl.isHidden = flag
        mapHomeView.showPOIButton.isHidden = flag
        mapHomeView.showPOILabel.isHidden = flag
        mapHomeView.nearbyVehicleButton.isHidden = flag
        mapHomeView.nearbyVehicleLabel.isHidden = flag
        
        mapHomeView.reachButton.isHidden = flag
        mapHomeView.reachLabel.isHidden = flag
        
        if !isSelectedDevice {
            mapHomeView.nearbyplaceButton.isHidden = flag
            mapHomeView.nearbyplaceLabel.isHidden = flag
            
            mapHomeView.nearbyVehicleButton.isHidden = flag
            mapHomeView.nearbyVehicleLabel.isHidden = flag
            
            mapHomeView.trailButton.isHidden = flag
            mapHomeView.trailLabel.isHidden = flag
            
        }
        mapHomeView.optionButton.transform = CGAffineTransform(rotationAngle: CGFloat(CGFloat.pi * 6/5))
        UIView.animate(withDuration: 0.3, animations: {
                        self.mapHomeView.optionButton.transform = .identity } )
        if flag {
            mapHomeView.optionButton.setImage(#imageLiteral(resourceName: "Asset 147-1"),for: .normal)
            
        } else {
            mapHomeView.optionButton.setImage(#imageLiteral(resourceName: "Asset 148-1"),for: .normal)
        }
    }
    
    @objc func nearbyVehicleTapped() {
        
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            
        }
        
        var distance = 0.0
        _ = 0
        var keyValueId : Int =  NSNumber(value: positions?[0].deviceId ?? 0).intValue//positions?[0].id ?? 0
        
        let lat = CLLocationDegrees(positions?[0].latitude ?? 0.0)
        let lon = CLLocationDegrees(positions?[0].longitude ?? 0.0)
        
        let Nextlocation = CLLocation(latitude: lat, longitude: lon)
        if currentLocation != nil {
            distance =  currentLocation.distance(from: Nextlocation)
            
            for position in positions ?? [TrackerPositionMapperModel]() {
                
                let lat = CLLocationDegrees(position.latitude ?? 0.0)
                let lon = CLLocationDegrees(position.longitude ?? 0.0)
                
                let Nextlocation = CLLocation(latitude: lat, longitude: lon)
                
                let distanceInMeters = currentLocation.distance(from: Nextlocation)
                if distanceInMeters <= distance {
                    distance = distanceInMeters
                    keyValueId =  NSNumber(value: position.deviceId ?? 0).intValue
                }
            }
            
        }
        let keyValue = "Device_" + "\(keyValueId)"
        let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        print("Lowest distance is with \(selDevice?.name ?? "nothing")")
        print("Lowest distance is \(distance)")
        
        let distanceFromCar = distance/1000
        
        let formatted = String(format: "%.0f", distanceFromCar)
        
        if let selectedDevice = selDevice {
            self.prompt("Nearest Vehicle", "Nearest Vehicle is: \(selectedDevice.name ?? "Unnamed Device"). You're \(formatted) kms away from it", "OK") { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func nearbyplacestapped(){
        OptionButtonTapped()
        nearbyplaceview = NearByPlacesView(frame: view.bounds)
        nearbyplaceview.backgroundColor = appDarkTheme
        view.addSubview(nearbyplaceview)
        nearbyplaceview.nearbyplaceTableView.tableFooterView = UIView()
        addnearbytableview()
        nearbyplaceview.backbutton.addTarget(self, action: #selector(backtappedplaces(sender:)), for: .touchUpInside)
    }
    
    func addnearbytableview() {
        
        nearbyplaceview.nearbyplaceTableView.register(NearByPlacesTableViewCell.self, forCellReuseIdentifier: "cell")
        nearbyplaceview.nearbyplaceTableView.delegate = self
        nearbyplaceview.nearbyplaceTableView.dataSource = self
        nearbyplaceview.nearbyplaceTableView.isScrollEnabled = true
    }
    
    @objc func backtappedplaces(sender:UIButton){
        isnearbyplaceButtonTapped = false
        nearbyplaceview.removeFromSuperview()
    }
    @objc func trafficButtonTapped() -> Void {
        if (RCMapView.mapView.isTrafficEnabled) {
            mapHomeView.trafficButton.setImage(#imageLiteral(resourceName: "trafficoff"), for:.normal)
            RCMapView.mapView.isTrafficEnabled = false
            OptionButtonTapped()
        } else {
            mapHomeView.trafficButton.setImage(#imageLiteral(resourceName: "trafficon"), for:.normal)
            RCMapView.mapView.isTrafficEnabled = true
            OptionButtonTapped()
        }
    }
    
    @objc func dailyButtonTapped() -> Void {
        if isPathButtonTapped {
            isPathButtonTapped = false
            if let path = polyLine {
            path.map = nil
            }
        }
        
      //  initDevicePosition(device: selectedDeviceId)
        if (!isDailyButtonTapped) {
            isDailyButtonTapped = true

            RCLocalAPIManager.shared.getSelDeviceDailyPath(with: bottomSheetDeviceId, success: { [weak self] hash in
                guard self != nil else {
                    return
                }
                var locations:[CLLocationCoordinate2D] = []
                for path in hash.data! {
                    let coordinate = CLLocation(latitude: Double((path.latitude) ?? "0")!, longitude: Double((path.longitude) ?? "0")! ).coordinate
                    locations.append(coordinate)
                }
                self?.getDeviceMarkersForDate(deviceId: "\(bottomSheetDeviceId)")
                self?.plot(.polyline, locations: locations)
                self?.pathSelectedId = bottomSheetDeviceId
                isDailyButtonTapped = true
                self?.closeBottomSheet()
            }) { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.makeToast("no data found")
                print("\(message)")
            }
        } else {
            setupSelectedPathData()
        }
    }
    @objc func pathButtonTapped() -> Void {
        if isDailyButtonTapped {
            isDailyButtonTapped = false
            if let path = polyLine {
            path.map = nil
            }
        }
        if (!isPathButtonTapped) {
            isPathButtonTapped = true
            RCLocalAPIManager.shared.getSelDevicePath(with: bottomSheetDeviceId, success: { [weak self] hash in
                guard self != nil else {
                    return
                }
                var locations:[CLLocationCoordinate2D] = []
                for path in hash.data! {
                    let coordinate = CLLocation(latitude: Double((path.latitude) ?? "0")!, longitude: Double((path.longitude) ?? "0")! ).coordinate
                    locations.append(coordinate)
                }
                
                let firstLocation = hash.data?.first
                let lastLocation = hash.data?.last
                
                self?.startTime = RCGlobals.getDateForWithoutConversionFromString(firstLocation?.servertime ?? "", format: "yyyy-MM-dd HH:mm:ss") as NSDate
                self?.endTime = RCGlobals.getDateForWithoutConversionFromString(lastLocation?.servertime ?? "", format: "yyyy-MM-dd HH:mm:ss") as NSDate
                
                self?.getDeviceMarkersForDate(deviceId: "\(bottomSheetDeviceId)")
                self?.plot(.polyline, locations: locations)
                self?.pathSelectedId = bottomSheetDeviceId
                isPathButtonTapped = true
                self?.closeBottomSheet()
            }) { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.makeToast("no data found")
            }
        }else{
            setupSelectedPathData()
        }
    }
    
    
    func plot(_ type: RCPlotType, locations: [CLLocationCoordinate2D]? = nil) -> Void {
        switch type {
        case .marker:
            markers.removeAll()
            RCMapView.clearMap()
            if markers.count > 0{
                fitMap()
            }
            
        case .polyline:
            let path = GMSMutablePath()
            if let array = locations {
            for item in array {
                path.add(item)
            }
            }
            polyLine = GMSPolyline(path: path)
            polyLine?.strokeWidth = 2
            if isPathButtonTapped {
                polyLine?.strokeColor = .red
            } else {
                polyLine?.strokeColor = .blue
            }
            polyLine?.map = RCMapView.mapView
            locationArray = locations!
            fitMap(locations!)
        }
        
    }
    
    func initDevicesPositions(vehicleType: Int = vehicleSelectedState.all.rawValue){
        Defaults().set(false, for: Key<Bool>("should_clear_map"))
        markerArrayList.removeAll()
        if clusterManager != nil {
            clusterManager.clearItems()
        }
        if selectedUserId != "0" {
            let filterDevices: [Int] = RCGlobals.getDeviceIdListForBranch(branchId: selectedUserId)
            
            positions = positions?.filter{ filterDevices.contains($0.deviceId!) }
            
        }
        
        markers.removeAll()
        if vehicleType != vehicleSelectedState.all.rawValue {
            RCMapView.clearMap()
        }
        locationArray.removeAll()
        drawMultipleGeofencesOnMap()
        let allPositions = positions
        
        if multipleselectionEnabled == true
        {
            
            positions = positions?.filter{ selectedDeviceIdArray.contains($0.deviceId!)}
            
        }
        else
        {
            positions = checkExpiredOrNotPositions(checkArray: allPositions)
            
        }
        if let positionsExist = positions {
            for item in positionsExist {
                
                let keyValue = "Device_" + "\(item.deviceId ?? 0)"
                let device = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
                
                let keyValuePos = "Position_" + "\(item.deviceId ?? 0)"
                let position = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
                
                
                if position?.longitude == nil || position?.longitude == nil {
                    continue
                }
                let location = CLLocationCoordinate2D(latitude: Double(position!.latitude ?? 0.0), longitude: Double(position!.longitude ?? 0.0))
                
                var isOffline:Bool = false
                var isInactive:Bool = false
                var isRunning:Bool = false
                
                if device?.lastUpdate == nil ||
                    Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) >= 86400 {
                    isOffline = true
                } else {
                    if Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) >= 600 && Date().timeIntervalSince(RCGlobals.getDateFor((device?.lastUpdate)!)) < 86400 {
                        isInactive = true
                    } else {
                        let ignition = position!.attributes?.ignition ?? false
                        if ignition == false {
                            isRunning = false
                        } else {
                            isRunning = true
                        }
                    }
                }
                let selectedDeviceIdArray:[Int] = Defaults().get(for: Key<[Int]>(defaultKeyNames.selectedDeviceList.rawValue)) ?? []
                if selectedDeviceIdArray.count > 1 {
                    if selectedDeviceIdArray.contains(position!.deviceId ?? 0) {
                        
                    } else {
                        continue
                    }
                } else {
                    if (vehicleType != vehicleSelectedState.all.rawValue) {
                        if (vehicleType == vehicleSelectedState.offline.rawValue && isOffline)
                            || (vehicleType == vehicleSelectedState.inactive.rawValue && isInactive && !isOffline)
                            || (vehicleType == vehicleSelectedState.ignitionOn.rawValue && isRunning && !isInactive && !isOffline)
                            || (vehicleType == vehicleSelectedState.ignitionOff.rawValue && !isRunning && !isInactive && !isOffline) {
                            
                        } else {
                            continue
                        }
                    }
                }
                
                locationArray.append(location)
                
                checkVehicleIdelTime(keyValue: keyValue,position:position)
                
                let markerBoth = RCMarker.dropMarker(atPoint: location, title: (device?.name) ?? "", snippet: "", rotationAngle: Double(position!.course ?? 0.0),device: device)
                
                markers.append(markerBoth)
                
                if markerSetting == true {
                    markerBoth.map = nil
                    let tempMarker = GMSMarker(position: markerBoth.position)
                    tempMarker.userData = markerBoth.userData
                    tempMarker.snippet = markerBoth.snippet
                    if isMarkerLabelShowed == true {
                        tempMarker.iconView = markerBoth.iconView
                        tempMarker.groundAnchor = CGPoint(x: 0.5, y: 0.7)
                    } else {
                        tempMarker.icon = markerBoth.icon
                    }
                    tempMarker.appearAnimation = .pop
                    tempMarker.rotation = markerBoth.rotation
                    markerArrayList.append(tempMarker)
                }
                
            } }
        
        if positions?.count ?? 0 > 0 {
            fitMap(locationArray)
        }
        
        if markerSetting == true {
            RCMapView.clearMap()
            clusterManager.clearItems()
            clusterManager.add(markerArrayList)
            clusterManager.cluster()
        } else {
            if clusterManager != nil {
                clusterManager.clearItems()
            }
        }
        
    }
    
    func initDevicePosition(device: Int) {
        Defaults().set(false, for: Key<Bool>("should_clear_map"))
        if clusterManager != nil {
            clusterManager.clearItems()
            clusterManager.cluster()
        }
        markers.removeAll()
        RCMapView.clearMap()
        locationArray.removeAll()
        markerArrayList.removeAll()
        
        let keyValue = "Device_" + "\(device)"
        let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        
        let keyValuePos = "Position_" + "\(device)"
        let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
        
        RCLocalAPIManager.shared.singleVehicleGeoFence(with: "deviceId", deviceId:device , success: { [weak self] hash in
            guard let weakSelf = self else {return}
            Defaults().set(hash, for: Key<[SingleVehicleGeoFence]>("[SingleVehicleGeoFence]"))
            weakSelf.checkTypeOfGeofence()
        }) { [weak self] message in
            guard let _ = self else {return}
        }
        
        if devPostition != nil {
            
            let location = CLLocationCoordinate2D(latitude: Double((devPostition?.latitude ?? 0.0) ), longitude: Double((devPostition?.longitude ?? 0.0) ))
            locationArray.append(location)
            
            checkVehicleIdelTime(keyValue: keyValue,position:devPostition)
            
            let markerBoth = RCMarker.dropMarker(atPoint: location, title: (selDevice?.name) ?? "", snippet: "", rotationAngle: Double(devPostition?.course ?? 0.0),device:selDevice)
            
            markers.append(markerBoth)
            
            fitMap(locationArray)
            
        }else {
           // UIApplication.shared.keyWindow?.makeToast("Position is not available for this device.".toLocalize, duration: 4.0, position: .bottom)
            initDevicesPositions(vehicleType: selectedVehicleType)
        }
        
    }
    
    func checkTypeOfGeofence(){
        let singleGeoFence =  Defaults().get(for: Key<[SingleVehicleGeoFence]>("[SingleVehicleGeoFence]")) ?? nil
        if singleGeoFence != nil {
            for geofenceToShow in singleGeoFence! {
                if geofenceToShow.area?.uppercased().range(of:"POLYGON") != nil {
                    let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area!)
                    var locations: [CLLocationCoordinate2D] = []
                    for i in stride(from: 0, to: coordinates.count, by: 2) {
                        locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                    }
                    if let stringColor = geofenceToShow.attributes?.areaColor {
                        let _ = RCPolygon.drawPolygon(points: locations, title: geofenceToShow.name!, color: self.hexStringToUIColor(hex: stringColor), map: RCMapView.mapView)
                    } else {
                        let _ = RCPolygon.drawPolygon(points: locations, title: geofenceToShow.name!, map: RCMapView.mapView)
                    }
                    
                    fitMap(locations)
                    
                } else if geofenceToShow.area?.uppercased().range(of:"CIRCLE") != nil {
                    let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area!)
                    let locations: CLLocation = CLLocation(latitude: Double(coordinates[0]) ?? 0.0, longitude: Double(coordinates[1]) ?? 0.0)
                    if let stringColor = geofenceToShow.attributes?.areaColor {
                        _ = RCCircle.drawCircleWithCenter(point:locations, radius:Double(coordinates[2]) ?? 0.0, title: geofenceToShow.name!,  color: self.hexStringToUIColor(hex: stringColor), map:(RCMapView.mapView))
                    } else {
                        _  = RCCircle.drawCircleWithCenter(point: locations, radius: Double(coordinates[2]) ?? 0.0, title: geofenceToShow.name!, map: (RCMapView.mapView))
                    }
                    fitMap([locations.coordinate])
                    
                } else if geofenceToShow.area?.uppercased().range(of:"LINESTRING") != nil {
                    let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area!)
                    var locations: [CLLocationCoordinate2D] = []
                    for i in stride(from: 0, to: coordinates.count, by: 2) {
                        locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i]) ?? 0.0, longitude: Double(coordinates[i+1]) ?? 0.0))
                    }
                    if let stringColor = geofenceToShow.attributes?.areaColor {
                        RCPolyLine().drawpolyLineFrom(points: locations, color: hexStringToUIColor(hex: stringColor), title: (geofenceToShow.name)!, map: RCMapView.mapView)
                    } else {
                        RCPolyLine().drawpolyLineFrom(points: locations, color: UIColor.red, title: (geofenceToShow.name)!, map: RCMapView.mapView)
                        
                    }
                    
                    fitMap(locations)
                }
            }
            
        }
    }
    
    // return seconds in double
    func convertDateInMilliseconds(date:Date) -> Double {
        let currentDate = date
        let since1970 = currentDate.timeIntervalSince1970
        return since1970*1000
    }
    func currentDateAsString()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        let result = formatter.string(from: date)
        return result
        
    }
    
    func checkVehicleIdelTime(keyValue:String,position:TrackerPositionMapperModel?){
        
        let deviceModel = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        
        if deviceModel != nil && position != nil {
            let igniton = (position?.attributes?.ignition) ?? false
            var speed:Float = 0.0
            if (igniton) {
                speed = roundf((position?.speed ?? 0) * 1.852)
            }
            if igniton && speed == 0.0 {
                if deviceModel?.vechileIdelTime == nil {
                    deviceModel?.vechileIdelTime = deviceModel?.lastUpdate
                    Defaults().set(deviceModel!, for: Key<TrackerDevicesMapperModel>(keyValue))
                }else{
                    let currentTimeSec = convertDateInMilliseconds(date:RCGlobals.getDateFor(currentDateAsString()))
                    
                    let vechileRestTimeSec = convertDateInMilliseconds(date: RCGlobals.getDateFor((deviceModel?.vechileIdelTime)!))
                    
                    let timeDifferences = (currentTimeSec - vechileRestTimeSec)
                    if timeDifferences > 60000 { // 60 secs
                        deviceModel?.showIdleIcon = true
                        Defaults().set(deviceModel!, for: Key<TrackerDevicesMapperModel>(keyValue))
                    } else{
                        deviceModel?.showIdleIcon = false
                        Defaults().set(deviceModel!, for: Key<TrackerDevicesMapperModel>(keyValue))
                    }
                }
            }else{
                deviceModel?.showIdleIcon = false
                deviceModel?.vechileIdelTime = nil
                Defaults().set(deviceModel!, for: Key<TrackerDevicesMapperModel>(keyValue))
            }
        }
    }
    func updateMarkerAddress(trackerPosition:TrackerPositionMapperModel){
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: trackerPosition.latitude ?? 0, longitude: trackerPosition.longitude ?? 0)
        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { (response, error) in
            guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else { return}
            let tempAddress = lines.joined(separator: " ")
            
            if let tempKeyValue = devPosCoordinateDic["\(Gaddress.coordinate.latitude)\(Gaddress.coordinate.longitude)"] {
                if let  tempDevPos = Defaults().get(for: Key<TrackerPositionMapperModel>(tempKeyValue)) {
                    tempDevPos.address = tempAddress
                    Defaults().set(tempDevPos, for: Key<TrackerPositionMapperModel>(tempKeyValue))
                    self.positions?.filter({$0.deviceId == tempDevPos.deviceId}).first?.address = tempAddress
                }
            }
            
            DispatchQueue.main.async {
                if bottomSheetDeviceId == (trackerPosition.deviceId ?? 0) {
                    
                    var pointOfInterestLocation: String = ""
                    let coords : CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    pointOfInterestLocation = self.getGeofencaNameContainingLocation(coords) ?? ""
                    
                    if pointOfInterestLocation != "" {
                        bottomSheet.locationLabel.text = pointOfInterestLocation
                        bottomSheetWatch.locationLabel.text = pointOfInterestLocation
                    } else {
                        bottomSheet.locationLabel.text = tempAddress
                        bottomSheetWatch.locationLabel.text = tempAddress
                    }
                }
            }
        }
    }
    func updateDevicePosition(position: TrackerPositionMapperModel) {
        
        if isPlayBackButtonTapped {
            return
        }
        let location = CLLocation(latitude: Double(position.latitude ?? 0.0 ), longitude: Double(position.longitude ?? 0.0))
        updateMarkerAddress(trackerPosition: position)
        if position.longitude != 0.0 && position.latitude != 0.0 {
            
            let keyValue = "Device_" + "\(position.deviceId ?? 0)"
            let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
            let deviceId:String = "\(position.deviceId!)"
            if markerSetting == true && isSelectedDevice {
                
                var clusterMarker: GMSMarker? = markerArrayList.first{ $0.snippet == deviceId }
                
                if clusterMarker != nil {
                    
                    checkVehicleIdelTime(keyValue: keyValue,position:position)
                    
                    let markersBoth = RCMarker.updateMarker(marker: clusterMarker! as! RCMarker, atPoint: CLLocationCoordinate2D(latitude: Double(position.latitude!), longitude: Double(position.longitude!)), title: (selDevice?.name)!, snippet: "", rotationAngle: Double(position.course!), device: selDevice)
                    
                    clusterMarker = markersBoth
                    
                    animateToNextCoordinate(with: clusterMarker!, toPosition: location, position: position, ofType: RCTrackerType(rawValue: selDevice?.category ?? "car") ?? RCTrackerType.Car)
                    
                    updateAddress(marker: clusterMarker!)
                    if isBottomSheetVisible && String(bottomSheetDeviceId) == (clusterMarker?.snippet) {
                        updateDataBottomSheet(trackerPosition: position, trackerDevice: selDevice!)
                    }
                    
                }
                
            } else {
                
                var marker: RCMarker? = markers.first{ $0.snippet ==  deviceId }
                
                if marker != nil {
                    
                    checkVehicleIdelTime(keyValue: keyValue,position:position)
                    
                    
                    let markersBoth = RCMarker.updateMarker(marker: marker!, atPoint: CLLocationCoordinate2D(latitude: Double(position.latitude!), longitude: Double(position.longitude!)), title: (selDevice?.name)!, snippet: "", rotationAngle: Double(position.course!), device: selDevice)
                    
                    marker = markersBoth
                    
                    animateToNextCoordinate(with: marker!, toPosition: location, position: position, ofType: RCTrackerType(rawValue: selDevice?.category ?? "car") ?? RCTrackerType.Car)
                    
                    updateAddress(marker: marker!)
                    if isBottomSheetVisible && bottomSheetDeviceId == (marker?.userData as! Int) {
                        updateDataBottomSheet(trackerPosition: position, trackerDevice: selDevice!)
                    }
                }
            }
        }
    }
    
    func updateDeviceOnly(device: TrackerDevicesMapperModel) {
        
        if device.lastUpdate != nil {
            let marker:RCMarker? = markers.filter{ $0.userData as? Int == device.id }.first
            if marker != nil {
                let keyValuePos = "Position_" + "\(device.id ?? 0)"
                let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
                
                if devPostition != nil {
                    //Anshul commented to fix 0 speed when vehicle is idle.
                    //                    if devPostition?.attributes?.ignition != nil && (devPostition?.attributes?.ignition)! {
                    //                        speed = roundf((devPostition?.speed ?? 0) * 1.852)
                    //                    }
                    
                    let keyValue = "Device_" + "\(devPostition?.deviceId ?? 0)"
                    checkVehicleIdelTime(keyValue: keyValue,position:devPostition)
                    
                }
                if isBottomSheetVisible && bottomSheetDeviceId == (marker?.userData as! Int) {
                    updateDataBottomSheet(trackerPosition: devPostition!, trackerDevice: device)
                }
            }
        }
    }
    
    
    func updateAddress(marker:GMSMarker) {
        if let selMarker = RCMapView.mapView.selectedMarker {
            if selMarker == marker {
                let cooridenate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(cooridenate) { (response, error) in
                    guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else { return }
                    let tempAddress = lines.joined(separator: " ")
                    
                    let keyValuePos = "Position_" + "\(marker.snippet!)"
                    let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
                    devPostition?.address = tempAddress
                }
            }
        }
    }
    
    fileprivate func fitMap(_ coordinates: [CLLocationCoordinate2D]? = nil) -> Void {
        if isPlayBackButtonTapped {
            return
        }
        var bounds: GMSCoordinateBounds!
        if let coordinate = markers.first?.position,let coordinate1 = markers.last?.position {
            bounds = GMSCoordinateBounds(coordinate:coordinate, coordinate:coordinate1)
            for marker in markers {
                bounds = bounds.includingCoordinate(marker.position)
            }
            var bottomPadding: CGFloat = 75
            if isBottomSheetVisible {
                bottomPadding = bottomSheetHeight
            }
            
            if selectedDeviceId != 0 && selectedDeviceId == (markers.first?.userData as! Int) {
                if bottomPadding == 75 {
                    bottomPadding = 0
                } else {
                    bottomPadding = bottomPadding - 75
                }
                
                var cameraPosition = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                                              longitude: coordinate.longitude,
                                                              zoom: 17,
                                                              bearing: markers.first?.rotation ?? 0.0, viewingAngle: RCMapView.mapView.camera.viewingAngle)
                
                if isMapMoved {
                    cameraPosition = GMSCameraPosition.camera(withLatitude: RCMapView.mapView.camera.target.latitude,
                                                              longitude: RCMapView.mapView.camera.target.longitude,
                                                              zoom: RCMapView.mapView.camera.zoom,
                                                              bearing: RCMapView.mapView.camera.bearing, viewingAngle: RCMapView.mapView.camera.viewingAngle)
                }
                
                RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0, bottomPadding, 0)
                RCMapView.mapView.animate(to: cameraPosition)
                
            } else {
                if !isMapMoved {
                    if let marker = destinationMarker {
                        bounds = bounds.includingCoordinate(marker.position)
                    }
                    let updateCamera = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(75, 75, bottomPadding, 75))
                    RCMapView.mapView.animate(with: updateCamera)
                }
            }
            
        }
    }
    
    private func animateToNextCoordinate(with marker: GMSMarker, toPosition positionTo: CLLocation, position: TrackerPositionMapperModel, ofType: RCTrackerType) {
        let coord: CLLocationCoordinate2D = positionTo.coordinate
        let previous: CLLocationCoordinate2D = marker.position
        let distance: CLLocationDistance = GMSGeometryDistance(previous, coord)
        if UIApplication.shared.applicationState != .background {
            // Use CATransaction to set a custom duration for this animation. By default, changes to the
            // position are already animated, but with a very short default duration. When the animation is
            // complete, trigger another animation steanimateToNextCoordinateLabelp.
//            if self.isMarkerLabelShowed || ofType == RCTrackerType.Personal || ofType == RCTrackerType.Train || ofType == RCTrackerType.Erickshaw {
//                marker.rotation = 0.0
//            } else {
//                let from = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
//                let course:Double = from.bearingToLocationDegrees(destinationLocation: positionTo)
//                if !course.isNaN && course != 0 {
//                    marker.rotation = course
//                }
//            }
            if self.isMarkerLabelShowed || ofType == RCTrackerType.Personal || ofType == RCTrackerType.Train || ofType == RCTrackerType.Erickshaw {
                marker.rotation = 0.0
            } else {
                marker.rotation = Double(position.course ?? 0.0)
            }
            
            CATransaction.begin()
            if selectedDeviceId == 0 {
                selectedDeviceId = bottomSheetDeviceId
            }
            
            CATransaction.setCompletionBlock({
                let location = CLLocation(latitude: Double((position.latitude) ?? 0.0), longitude: Double((position.longitude) ?? 0.0) )
                if position.deviceId == selectedDeviceId {
                    if isPathButtonTapped || isDailyButtonTapped {
                        var gmsPath = GMSMutablePath()
                        if polyLine == nil {

                            gmsPath.add(previous)
                        } else {

                            let path = polyLine?.path
                            if let path = path {
                                gmsPath = GMSMutablePath(path: path)
                            }
                            polyLine?.map = nil
                        }
                        gmsPath.add(location.coordinate)
                        polyLine? = GMSPolyline(path: gmsPath)
                        if isPathButtonTapped {
                            polyLine?.strokeColor = .red
                        }else {
                            polyLine?.strokeColor = .blue
                        }
                        polyLine?.strokeWidth = 2
                        polyLine?.map = RCMapView.mapView
                    } else if isTrailing {
                        
                        var trailLocationArray:[CLLocationCoordinate2D] = []
                        if (!trailingLocationDict.keys.contains(position.deviceId ?? 0)) {
                            trailLocationArray.append(previous)
                        }
                        trailLocationArray.append(location.coordinate)
                        trailingLocationDict[position.deviceId ?? 0] = trailLocationArray
                        self.drawTrailPolylineOnMap(deviceId: position.deviceId ?? 0,coordinate: location.coordinate)
                        
                    }
                }
                
                // MARK: handle else condtion for all vehicvles by checking position.deviceId in all dvices visible on map trackerpostinmappermodel

                
               
            })
            
            //calcute speed here
            CATransaction.setAnimationDuration((distance / 10))
            marker.position = coord
            if (!isMapMoved) {
                self.fitMap()
            }
            
            CATransaction.commit()
            
        }
        else {
            marker.position = coord
        }
    }
    private func drawTrailPolylineOnMap(deviceId: Int, coordinate: CLLocationCoordinate2D) {
        if let path : GMSMutablePath = trailingPolylineDict[deviceId] {
            let updatedPath: GMSMutablePath = RCPolyLine().addPolyLineAt(point: coordinate, path: path)
            trailingPolylineDict[deviceId] = updatedPath
        } else {
            let path : GMSMutablePath = RCPolyLine().drawReturnpolyLineFrom(points: trailingLocationDict[deviceId] ?? [])
            trailingPolylineDict[deviceId] = path
        }
    }
    
    private func getTripReports(deviceId: String) {
        let currentDate = RCGlobals.convertDateToString(date: Date(), format: "yyyy-MM-dd", toUTC: false)
        let apiStartDate = RCGlobals.convertISTToUTC(currentDate, "yyyy-MM-dd", "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let apiEndDate = RCGlobals.convertDateToString(date: Date(), format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toUTC: true)
        RCLocalAPIManager.shared.getTripsReport(with: deviceId, loadingMsg: "", startDate: apiStartDate, endDate: apiEndDate, success: { [weak self] hash in
            guard self != nil else {
                return
            }
            
            var data:[TripsReportModelData] = hash.data ?? []
            
            if data.count > 0 {
                data = data.sorted(by: { $0.start_time ?? "" > $1.start_time ?? "" })
                
                let tripData = data[0]
                
                self?.sheetData[sheetDataKeys.tripDistValue.rawValue] = "\((tripData.distance ?? 0.0).rounded(toPlaces: 2))km"
                self?.sheetData[sheetDataKeys.tripDurValue.rawValue] = tripData.duration ?? "0 H 0 M"
                
                bottomSheet.tripDetailsCollection.reloadData()
            }
            
        }) { message in
            print(message)
        }
    }
    
}

extension MapsViewController: RCSocketManagerPositionDelegate, RCSocketManagerDeviceDelegate, addEditAllVehicleDelegate{
    
    func viewAllVehiclesTapped() {
        isSelectedDevice = true
        isPathButtonTapped = false
        isDailyButtonTapped = false
        isMapMoved = false
        multipleselectionEnabled = false
        selectedDeviceIdArray.removeAll()
        selectedDeviceId = 0
        
    }
    
    func multipleSelectedDeviceId(deviceIds: [Int]) {
        multipleselectionEnabled = true
        isSelectedDevice = true
        isPathButtonTapped = false
        isDailyButtonTapped = false
        isMapMoved = false
        selectedDeviceId = 0
        selectedDeviceIdArray = deviceIds
        //drawMultipleGeofencesOnMap()
    }
    
    func selectedVehiclesTapped(deviceIds: [Int]) {
        isSelectedDevice = false
        isPathButtonTapped = false
        isDailyButtonTapped = false
        selectedDeviceId = deviceIds.first ?? 0
        
    }
    func specificVehicleTypeTapped(vehicleType: Int?) {
        isSelectedDevice = true
        isPathButtonTapped = false
        isDailyButtonTapped = false
        selectedDeviceId = 0
    }
    
    func callSingleGeoFenceApi(deviceId:Int) {
        RCLocalAPIManager.shared.singleVehicleGeoFence(with: "deviceId", deviceId:deviceId , success: { [weak self ] hash in
            guard let _ = self else {return}
        }){ [weak self] message in
            guard let _ = self else {return}
        }
        
    }
    
    func drawMultipleGeofencesOnMap() {
        let allGeofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel")) ?? []
        let selectedGeofence = Defaults().get(for: Key<[Int]>("selectedGeofence")) ?? []
        if selectedGeofence.count == 0 {
            return
        }
        var onlyEnabledGeofence = [GeofenceModel]()
        selectedGeofence.forEach { (i) in
            onlyEnabledGeofence.append(contentsOf: allGeofences.filter({$0.id == i}))
        }
        for geofenceToShow in onlyEnabledGeofence {
            if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i])!, longitude: Double(coordinates[i+1])!))
                }
                if let stringColor = geofenceToShow.attributes?.areaColor {
                    let _ = RCPolygon.drawPolygon(points: locations, title: geofenceToShow.name, color: hexStringToUIColor(hex: stringColor), map: RCMapView.mapView)
                } else {
                    let _ = RCPolygon.drawPolygon(points: locations, title: geofenceToShow.name, map: RCMapView.mapView)
                }
            } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let locations: CLLocation = CLLocation(latitude: Double(coordinates[0]) ?? 0.0, longitude: Double(coordinates[1]) ?? 0.0)
                if let stringColor = geofenceToShow.attributes?.areaColor {
                    _ = RCCircle.drawCircleWithCenter(point:locations, radius:Double(coordinates[2]) ?? 0.0, title: geofenceToShow.name, color: self.hexStringToUIColor(hex: stringColor), map:(RCMapView.mapView))
                } else {
                    _  = RCCircle.drawCircleWithCenter(point: locations, radius: Double(coordinates[2]) ?? 0.0, title: geofenceToShow.name, map: (RCMapView.mapView))
                }
            } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                var locations: [CLLocationCoordinate2D] = []
                for i in stride(from: 0, to: coordinates.count, by: 2) {
                    locations.append(CLLocationCoordinate2D(latitude: Double(coordinates[i]) ?? 0.0, longitude: Double(coordinates[i+1]) ?? 0.0))
                }
                if let stringColor = geofenceToShow.attributes?.areaColor {
                    RCPolyLine().drawpolyLineFrom(points: locations, color: hexStringToUIColor(hex: stringColor), title: (geofenceToShow.name) , map: RCMapView.mapView)
                } else {
                    RCPolyLine().drawpolyLineFrom(points: locations, color: UIColor.red,title: (geofenceToShow.name), map: RCMapView.mapView)
                }
            }
        }
    }
}

extension MapsViewController: GMSMapViewDelegate {
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        if  marker.title == "Image_Title" {
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
            view.backgroundColor = UIColor.black
            view.layer.cornerRadius = 8
            view.alpha = 0.6
            
            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
            lbl1.textColor = UIColor.white
            lbl1.textAlignment = .center
            lbl1.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            lbl1.adjustsFontForContentSizeCategory = true
            lbl1.adjustsFontSizeToFitWidth = true
            
            let lbl2 = UILabel(frame: CGRect.zero)
            lbl2.textColor = UIColor.white
            lbl2.textAlignment = .center
            lbl2.font = UIFont.systemFont(ofSize: 13, weight: .bold)
            lbl2.adjustsFontForContentSizeCategory = true
            lbl2.layer.cornerRadius = 4
            lbl2.layer.masksToBounds = true
            lbl2.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)
            
            if let jsonData = marker.snippet!.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
                    lbl1.text = markerModel.title
                    lbl2.text = "\(markerModel.imagePathList?.count ?? 0) photos"
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            view.addSubview(lbl1)
            view.addSubview(lbl2)
            
            lbl2.snp.makeConstraints{(make) in
                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
                make.centerX.equalToSuperview()
                make.width.equalTo(0.2 * kscreenwidth)
            }
            
            return view
        } else if marker.title == "Stop Location" {
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 120))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 2
            
            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 35))
            lbl1.textColor = UIColor.appGreen
            lbl1.textAlignment = .center
            lbl1.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            lbl1.numberOfLines = 2
            
            let lbl2 = UILabel(frame: CGRect.zero)
            lbl2.textColor = UIColor.darkGray
            lbl2.textAlignment = .center
            lbl2.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lbl2.numberOfLines = 4
            
            let time = marker.userData as! String
            
            lbl1.text = time
            
            var addressText: String = ""
            
            let geocoder = GMSGeocoder()
            geocoder.reverseGeocodeCoordinate(marker.position) { (response, error) in
                guard let address = response?.firstResult(), let lines = address.lines else { return }
                addressText = lines.joined(separator: " ")
                print(addressText)
                lbl2.text = addressText
            }
            
            view.addSubview(lbl1)
            view.addSubview(lbl2)
            
            lbl2.snp.makeConstraints{(make) in
                make.top.equalTo(lbl1.snp.bottom).offset(0.004 * kscreenheight)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalToSuperview().multipliedBy(0.6)
            }
            
            return view
            
            
        } else if marker.title == "POI_MARKER" {
            return nil
        }  else {
            if isMarkerLabelShowed == false {
                
                let lbl1 = UILabel()
                lbl1.frame = CGRect(x: 0, y: 0, width: 80, height: 18)
                lbl1.text = marker.title ?? ""
                lbl1.textColor = UIColor.white
                lbl1.backgroundColor = UIColor.black
                lbl1.layer.cornerRadius = 8
                lbl1.layer.masksToBounds = true
                lbl1.alpha = 0.6
                lbl1.textAlignment = .center
                lbl1.baselineAdjustment = .alignCenters
                lbl1.minimumScaleFactor = 0.2
                lbl1.frame.size.width = lbl1.intrinsicContentSize.width
                
                return lbl1
            } else {
                return nil
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if  marker.title == "Image_Title" {
            if let jsonData = marker.snippet!.data(using: .utf8)
            {
                let decoder = JSONDecoder()
                
                do {
                    let markerModel = try decoder.decode(MarkerFirebaseModel.self, from: jsonData)
                    Defaults().set(markerModel, for: Key<MarkerFirebaseModel> ("particularMarkerInfo"))
                    let markerphotoVC = MarkerPhotoViewController()
                    let controller = UINavigationController(rootViewController: markerphotoVC)
                    self.present(controller, animated: true, completion: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // marker tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // center the map on tapped marker
//        mapView.animate(toLocation: marker.position)
        // check if a cluster icon was tapped
        didTapMarker = true
        if ((marker.userData as? GMUCluster) != nil) {
            // zoom in on tapped cluster
            let cluster:GMUCluster = marker.userData as! GMUCluster
            
            let clusterItems = cluster.items
            
            var bounds: GMSCoordinateBounds!
            
            bounds = GMSCoordinateBounds()
            
            for item in clusterItems {
                bounds = bounds.includingCoordinate(item.position)
            }
                        
            RCMapView.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100.0 , left: 20.0 ,bottom: 100.0 ,right: 20.0)))
            NSLog("Did tap cluster")
            return true
        }
        NSLog("Did tap a normal marker")
        // for poi marker
        if marker.title == "MARKER" {
            return true
        }
        if marker.title == "Destination" {
            return false
        }
        if  marker.title == "Image_Title" {
            return false
        } else if marker.title == "POI_MARKER" {
            return true
        } else if marker.title == "Stop Location" {
            return false
        } else {
            if dateFrom == ""
            {
                sheetData = [:]
                selectedDeviceLatitute = marker.position.latitude
                selectedDeviceLongitute = marker.position.longitude
                let snippet:Int = Int(marker.snippet ?? "0")!
                bottomSheetDeviceId = snippet
                
                let keyValue = "Device_Watch"// + "\(trackerDevice.id!)"
                Defaults().set(bottomSheetDeviceId, for: Key<Int>(keyValue))
                if mapHomeView != nil {
                    mapHomeView.directionButton.isHidden = mapHomeView.isDirectionButtonHidden
                    mapHomeView.directionButton.frame = CGRect(x: mapHomeView.directionButton.frame.minX,
                                                               y: self.view.frame.size.height - bottomSheetHeight - mapHomeView.directionButton.frame.height,
                                                               width: mapHomeView.directionButton.frame.width,
                                                               height: mapHomeView.directionButton.frame.height)
                }

                let keyValuePos = "Position_" + "\(bottomSheetDeviceId)"
                let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
                checkForBottomSheet()
                
                if (devPostition?.attributes?.ignition ?? false) == true {
                    sheetData[sheetDataKeys.tripDistLabel.rawValue] = "Current Trip Dist."
                    sheetData[sheetDataKeys.tripDurLabel.rawValue] = "Trip Duration"
                    sheetData[sheetDataKeys.ignitionTimeLabel.rawValue] = "Ignition on since"
                } else {
                    sheetData[sheetDataKeys.tripDistLabel.rawValue] = "Last Trip Dist."
                    sheetData[sheetDataKeys.tripDurLabel.rawValue] = "Last Trip Time"
                    sheetData[sheetDataKeys.ignitionTimeLabel.rawValue] = "Ignition off since"
                }

                dataOnBottomSheet(deviceID: bottomSheetDeviceId, protocll: devPostition?.protocl ?? "")
                
                requestForExtraDataOnBottomSheet(deviceID: bottomSheetDeviceId) { (model) in
                    self.bottomSheetData = model
                    self.requestedDataOnBottomSheet(model: model)
                }
                
                getTripReports(deviceId: "\(bottomSheetDeviceId)")
                marker.tracksInfoWindowChanges = true

                let cooridenate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
                let coords : CLLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
                let geocoder = GMSGeocoder()
                geocoder.reverseGeocodeCoordinate(cooridenate) { (response, error) in
                    guard let Gaddress = response?.firstResult(), let lines = Gaddress.lines else { return }
                    let tempAddress = lines.joined(separator: " ")

                    var pointOfInterestLocation: String = ""

                    pointOfInterestLocation = self.getGeofencaNameContainingLocation(coords) ?? ""

                    if pointOfInterestLocation != "" {

                        bottomSheet.locationLabel.text = pointOfInterestLocation
                        bottomSheetWatch.locationLabel.text = pointOfInterestLocation

                    } else {
                        bottomSheet.locationLabel.text = tempAddress
                        bottomSheetWatch.locationLabel.text = tempAddress
                    }
                    let keyValuePos = "Position_" + "\(bottomSheetDeviceId)"

                    if let position = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos)) {
                        position.address = tempAddress
                        Defaults().set(position, for: Key<TrackerPositionMapperModel>(keyValuePos))
                    }
                }
                if pathSelectedId != bottomSheetDeviceId {
                    print("setup path called from didtap marker")
                    setupSelectedPathData()
                }
                openBottomSheet(protocoll: devPostition?.protocl ?? "")

                return isMarkerLabelShowed
            }else{
                return false
            }
        }
        
        
        
    }
    func setupSelectedPathData(){
        
        if isPathButtonTapped {
            isPathButtonTapped = false
            
        } else if isDailyButtonTapped {
            isDailyButtonTapped = false
        }
        if let path = polyLine {
            path.map = nil
        }
    }
    
    func getGeofencaNameContainingLocation(_ deviceLocation: CLLocation)  -> String? {
        let geofencesList:[GeofenceModel] = Defaults().get(for: Key<[GeofenceModel]>("geofenceWithSetDefaults")) ?? []
        var nameOfGeofence = ""
        
        for geofenceToShow in geofencesList {
            
            if geofenceToShow.area.uppercased().range(of:"POLYGON") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let gmsPath = GMSMutablePath()
                for i in 0...(coordinates.count - 1) {
                    var pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
                    let number = i % 2
                    if number == 0 {
                        pointLocation.latitude = Double(coordinates[i]) ?? 0
                    } else {
                        pointLocation.longitude = Double(coordinates[i]) ?? 0
                    }
                    gmsPath.add(pointLocation)
                }
                
                let deviceCoordinate = deviceLocation.coordinate
                
                if GMSGeometryContainsLocation(deviceCoordinate, gmsPath, true) {
                    nameOfGeofence = geofenceToShow.name
                }
            } else if geofenceToShow.area.uppercased().range(of:"CIRCLE") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let locations: CLLocation = CLLocation(latitude: Double(coordinates[0])!, longitude: Double(coordinates[1])!)
                
                let radius = Double(coordinates[2])!
                let center = locations
                
                let distanceFromCenter = deviceLocation.distance(from: center)
                
                if distanceFromCenter < radius {
                    
                    nameOfGeofence = geofenceToShow.name
                    // inside
                }
                
            } else if geofenceToShow.area.uppercased().range(of:"LINESTRING") != nil {
                let coordinates = RCGlobals.getStringMatchRegex(pattern: "\\d+.\\d+", str: geofenceToShow.area)
                let gmsPath = GMSMutablePath()
                for i in 0...(coordinates.count - 1) {
                    var pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
                    let number = i % 2
                    if number == 0 {
                        pointLocation.latitude = Double(coordinates[i]) ?? 0
                    } else {
                        pointLocation.longitude = Double(coordinates[i]) ?? 0
                    }
                    gmsPath.add(pointLocation)
                }
                
                let deviceCoordinate = deviceLocation.coordinate
                
                if GMSGeometryIsLocationOnPathTolerance(deviceCoordinate, gmsPath, true, 25) {
                    nameOfGeofence = geofenceToShow.name
                }
            }
            if !nameOfGeofence.isEmpty {
                break
            }
        }
        
        return nameOfGeofence
        
    }
    
    func requestedDataOnBottomSheet(model: DevicePopupDetailsModel) {
        let deviceId:String = model.data?.deviceId ?? "0"
        let keyValueDevicePos = "Position_" + "\(deviceId)"
        let trackerPosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValueDevicePos))
        
        let maxspeedInKmph = Double((model.data?.maxSpeed) ?? "0")! * 1.852
        let avgSpeedInKmph = (model.data?.averageSpeed ?? 0) * 1.852
        let tripDistance = model.data?.tripDistance?.rounded()
        let tripDurationString = RCGlobals.convertTime(miliseconds: (model.data?.tripDuration!)!)
        let tripDistanceString = RCGlobals.convertDistance(distance: tripDistance!)
        
        sheetData[sheetDataKeys.maxSpeedValue.rawValue] = "\(maxspeedInKmph.rounded())" + "kmph"
        sheetData[sheetDataKeys.avgSpeedValue.rawValue] = "\(avgSpeedInKmph.rounded())" + "kmph"
        sheetData[sheetDataKeys.stopCountValue.rawValue] = "\(model.data?.noOfStops ?? 0)"
        let idleTime:Int = model.data?.idleTime ?? 0
        let movingTime:Int = (model.data?.engineHours ?? 0) - idleTime
        sheetData[sheetDataKeys.idleTimeValue.rawValue] = RCGlobals.convertTimeSheet(miliseconds: idleTime)
        sheetData[sheetDataKeys.movingTimeValue.rawValue] = RCGlobals.convertTimeSheet(miliseconds: movingTime)
        
        if (trackerPosition?.attributes?.ignition ?? false) == true {
            sheetData[sheetDataKeys.tripDistValue.rawValue] = tripDistanceString
            sheetData[sheetDataKeys.tripDurValue.rawValue] = tripDurationString
        }
        
        maxspeed = "\(maxspeedInKmph.rounded())" + "kmph"
        noofstops = "\(model.data?.noOfStops ?? 0)"
        tripduration = tripDurationString
        tripdistance = tripDistanceString
        
        let lastUpdateModel =  Defaults().get(for: Key<LastActivationTimeModel>("LastActivationTimeModel"))?.data
        if lastUpdateModel != nil {
            for i in lastUpdateModel!{
                    if i.deviceId == String(deviceId) && i.type == ((trackerPosition?.attributes?.ignition ?? false) ? "ignitionOn" : "ignitionOff") {
                        if i.ignitionTime != nil {
//                            let lastUpdated = RCGlobals.newtimeAgoSinceDate( RCGlobals.getDefaultUTCDate(i.ignitionTime!) )
                            let lastUpdated:String = RCGlobals.convertUTCToIST(i.ignitionTime!, "yyyy-MM-dd HH:mm:ss", "dd-MM-yy hh:mma")
                            sheetData[sheetDataKeys.ignitionTimeValue.rawValue] = lastUpdated
                            ignitiontime = lastUpdated
                        }
                        break
                    }
            }
        }
        bottomSheet.tripDetailsCollection.reloadData()
    }
    
    func requestForExtraDataOnBottomSheet(deviceID: Int, success: @escaping(DevicePopupDetailsModel) ->Void) {
        let device = String(deviceID)
        let deviceDate = RCGlobals.getFormattedDate(date: Date(), format: "yyyy-MM-dd")
        RCLocalAPIManager.shared.getDevicesPopupDetails(deviceID: device, date: deviceDate, success: { [weak self] model in
            guard let _ = self else { return }
            success(model)
        }) { [weak self] message in
            guard let _ = self else { return }
            print(message)
        }
    }
    
    func dataOnBottomSheet(deviceID: Int, protocll: String) {
        
        let keyValueDevicePos = "Position_" + "\(deviceID)"
        let trackerPosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValueDevicePos))
        
        let keyValueDevice = "Device_" + "\(deviceID)"
        let trackerDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValueDevice))
        
        
        if protocll != watchProtocol {
            
            if let pos = trackerPosition {
                updateDataBottomSheet(trackerPosition: pos, trackerDevice: trackerDevice!)
            }
        } else {
            
            if let pos = trackerPosition {
                updateDataBottomSheetWatch(trackerPosition: pos, trackerDevice: trackerDevice!)
            }
            
        }
    }
    
    func fuelMeter(distance: Double) {
        var distanceImKm = distance
        if distanceImKm > 0.0 {
            distanceImKm = distanceImKm / 1000.0
            distanceImKm = distanceImKm.rounded(toPlaces: 1)
        }
        
        
        //MARK:- Dont remove code below
        
        //    var fuelData = Array(DBManager.shared.getResults(RealmObject: FuelModel.self)) as! [FuelModel]
        //    fuelData = fuelData.filter({$0.deviceId == bottomSheetDeviceId})
        //
        //    if let tempFuel = fuelData.first {
        //      if (distanceImKm - tempFuel.currentOdometer).rounded(toPlaces: 1) > 1.0 {
        //        print((distanceImKm - tempFuel.currentOdometer).rounded(toPlaces: 1), "kilometer")
        //        let fuelSpend = ((distanceImKm - tempFuel.currentOdometer) / tempFuel.milage).rounded(toPlaces: 1)
        //        print(fuelSpend, "fuel spend")
        //        let fuelRemaining = (tempFuel.currentFuel - fuelSpend).rounded(toPlaces: 1)
        //        print(fuelRemaining, "fuel remaning")
        //        NSLog("\(fuelRemaining)")
        //        if fuelRemaining < 0.0 {
        //          bottomSheet.fuelValueLabel.text = "0.0"
        //          try! Realm().write {
        //            tempFuel.currentFuel = 0.0
        //            tempFuel.currentOdometer = distanceImKm.rounded(toPlaces: 1)
        //          }
        //        } else {
        //          bottomSheet.fuelValueLabel.text = "\(fuelRemaining)"
        //          try! Realm().write {
        //            tempFuel.currentOdometer = distanceImKm.rounded(toPlaces: 1)
        //            tempFuel.currentFuel = fuelRemaining
        //          }
        //        }
        //      } else {
        //        bottomSheet.fuelValueLabel.text = "\(tempFuel.currentFuel)"
        //      }
        //    } else {
        //      bottomSheet.fuelValueLabel.text = "N/A"
        //      print("no data in array")
        //    }
    }
    
    func updateDataBottomSheet(trackerPosition: TrackerPositionMapperModel, trackerDevice: TrackerDevicesMapperModel) {
        var speed = 0.0
        if trackerPosition.attributes?.ignition != nil && (trackerPosition.attributes?.ignition)! {
            if let tempSpeed = trackerPosition.speed {
                speed = Double(roundf(tempSpeed * 1.852))
            }else{
                speed = 0
            }
        }
        let tempTotalDistance = trackerPosition.attributes?.totalDistance ?? 0.0
        let tempPrevOdometer : Double?
        tempPrevOdometer = Double(trackerDevice.attributes?.prevOdometer ?? 0)
        var totalDistance:Int = Int(round((tempTotalDistance - tempPrevOdometer! )/1000))
        if totalDistance < 0 {
            totalDistance = 0
        }
        
        //    let fuelData = realm.objects(FuelModelApiData.self).filter( { $0.device_id == "\(bottomSheetDeviceId)" }).sorted(by: { RCGlobals.getDateFrom($0.timestamp!) < RCGlobals.getDateFrom($1.timestamp!)}).first
        
        try! realm = Realm()
        
        
        if let fuel = trackerPosition.attributes?.fuel {
            bottomSheet.fuelValueLabel.text = "\(fuel.rounded(toPlaces: 1))"
        } else {
            let fuelData = realm.objects(FuelModelApiData.self)
            if fuelData.count != 0 {
                let fueldata1 = fuelData.filter({ $0.device_id == "\(bottomSheetDeviceId)" })
                
                let temp = fueldata1.sorted(by: { RCGlobals.getDateFromTwo($0.timestamp!) < RCGlobals.getDateFromTwo($1.timestamp!)})
                
                
                if let fuelDataY = temp.first {
                    
                    if let milage = fuelDataY.mileage {
                        
                        let milageDouble = Double(milage) ?? 0.0
                        let oldDistString : String = fuelDataY.total_distance ?? "0.0"
                        let oldDistance  = Double(oldDistString) ?? 0.0
                        let litresConsumed = ((tempTotalDistance / 1000) - oldDistance)/milageDouble
                        let litresFilled = Double(fuelDataY.fuel_filled) ?? 0.0
                        let litresLeft = litresFilled - litresConsumed
                        
                        if litresLeft > 0 {
                            bottomSheet.fuelValueLabel.text = "\(litresLeft.rounded(toPlaces: 1))"
                        } else {
                            bottomSheet.fuelValueLabel.text = "0"
                        }
                    } else {
                        bottomSheet.fuelValueLabel.text = "0"
                    }
                } else {
                    bottomSheet.fuelValueLabel.text = "0"
                }
            } else {
                bottomSheet.fuelValueLabel.text = "N/A"
            }
        }
        sheetData[sheetDataKeys.totalDistValue.rawValue] = "\(totalDistance) km"
        bottomSheet.tripDetailsCollection.reloadData()
        fuelMeter(distance: tempTotalDistance)
        totaldis = "\(totalDistance) km"
        bottomSheet.speedValueLabel.text = "\(speed)"
        //        checkForTemprature(trackerPosition: trackerPosition)
        //        checkForNetwork(trackerDevice: trackerDevice, isWatch: false)
        //        ignitionOnOffFunction(trackerDevices: trackerDevice, trackerPosition: trackerPosition)
        //        vehicleGeofenceFunction(trackerDevice: trackerDevice)
//                if let batteryLevel = trackerPosition.attributes?.batteryLevel {
//                    if batteryLevel > 1 {
//
//                       moreinfoController.moreinfoview.batImage.image = #imageLiteral(resourceName: "FullBattery")
//                       moreinfoController.moreinfoview.batStatusLabel.text = "\(batteryLevel)" + " %"
//                    } else if batteryLevel >= 0 && batteryLevel <= 1 {
//                        moreinfoController.moreinfoview.batImage.image = UIImage(named: "lowbattery")
//                    } else {
//                        moreinfoController.moreinfoview.batImage.image = #imageLiteral(resourceName: "noBatttery")
//                    }
//                } else {
//                    moreinfoController.moreinfoview.batImage.image = #imageLiteral(resourceName: "noBatttery")
//                }
        //        if alarmSetting != nil && type != nil {
        //            if let door = trackerPosition.attributes?.door {
        //                if type == "ac" {
        //                    if door {
        //                        moreinfoController.moreinfoview.acImage.image = #imageLiteral(resourceName: "ac_on")
        //                        moreinfoController.moreinfoview.acStatusLabel.text = "ON"
        //                    } else {
        //                        moreinfoController.moreinfoview.acImage.image = #imageLiteral(resourceName: "ac_off")
        //                        moreinfoController.moreinfoview.acStatusLabel.text = "OFF"
        //                    }
        //                } else if type == "door" {
        //                    if door {
        //                        moreinfoController.moreinfoview.doorImage.image = #imageLiteral(resourceName: "door_on")
        //                        moreinfoController.moreinfoview.doorStatusLabel.text = "OPEN"
        //                    } else {
        //                        moreinfoController.moreinfoview.doorImage.image = #imageLiteral(resourceName: "door_off")
        //                        moreinfoController.moreinfoview.doorStatusLabel.text = "CLOSED"
        //                    }
        //                }
        //            } else {
        //                moreinfoController.moreinfoview.acImage.image = #imageLiteral(resourceName: "ac_off")
        //                moreinfoController.moreinfoview.acStatusLabel.text = "OFF"
        //                moreinfoController.moreinfoview.doorImage.image = #imageLiteral(resourceName: "door_off")
        //                moreinfoController.moreinfoview.doorStatusLabel.text = "CLOSED"
        //            }
        //        }
        
        let isValidGPS:Bool = trackerPosition.valid ?? false
        
        if isValidGPS == true && RCGlobals.isGPSFixValid(device: trackerDevice, position: trackerPosition) {
            bottomSheet.gpsImage.image = #imageLiteral(resourceName: "gpsIcon")
        } else {
            bottomSheet.gpsImage.image = #imageLiteral(resourceName: "Layer 2-2")
        }
        
        if (trackerDevice.status ?? "offline") != "online" {
            bottomSheet.networkImage.image = #imageLiteral(resourceName: "netoff")
        } else {
            bottomSheet.networkImage.image = #imageLiteral(resourceName: "neton")
        }
        
        if let batteryLevel = trackerPosition.attributes?.batteryLevel {
            if batteryLevel > 1 {
                bottomSheet.powerImage.image = #imageLiteral(resourceName: "baton")
            } else if batteryLevel >= 0 && batteryLevel <= 1 {
                bottomSheet.powerImage.image = UIImage(named: "batoff")
            } else {
                bottomSheet.powerImage.image = #imageLiteral(resourceName: "lowbat")
            }
        } else {
            bottomSheet.powerImage.image = #imageLiteral(resourceName: "lowbat")
        }
        
        if let device = trackerDevice.lastUpdate {
            let lastUpdated = RCGlobals.newtimeAgoSinceDateWithoutSecond(RCGlobals.getDateFor(device)), lastupdateTime = RCGlobals.getFormattedDate(date: RCGlobals.getDateFor(device), format: "dd-MMM-yy hh:mm a")
            bottomSheet.lastUpdateLabel.text = "Last updated: " + lastUpdated + " ( \(lastupdateTime) )"
        }
        if let odometer = trackerPosition.attributes?.totalDistance {
            let reading = String(format: "%.0f", odometer / 1000)
            bottomSheet.odoValueLabel.text = reading
        }
        
    }
    
    func updateDataBottomSheetWatch(trackerPosition: TrackerPositionMapperModel, trackerDevice: TrackerDevicesMapperModel) {
        
        if let device = trackerDevice.lastUpdate {
            let lastUpdated = RCGlobals.newtimeAgoSinceDateWithoutSecond(RCGlobals.getDateFor(device)), lastupdateTime = RCGlobals.getFormattedDate(date: RCGlobals.getDateFor(device), format: "dd-MMM-yy hh:mm a")
            bottomSheetWatch.lastUpdateLabel.text = "Last updated: " + lastUpdated + " ( \(lastupdateTime) )"
            
        }
        
        if let attributes = trackerPosition.attributes {
            
            if let numberOfSteps = attributes.steps {
                
                bottomSheetWatch.statusScroll.stepscountLabel.text = "\(numberOfSteps)"
            }
            
        }
        checkForNetwork(trackerDevice: trackerDevice, isWatch: true)//is not to be commented
        if trackerDevice.status == "offline" {
            bottomSheetWatch.statusScroll.statusImage.image = #imageLiteral(resourceName: "removeicon")
        } else {
            bottomSheetWatch.statusScroll.statusImage.image = #imageLiteral(resourceName: "greenNotification")
        }
        bottomSheetWatch.statusScroll.workingStatusLabel.text = trackerDevice.status
        
        if let batteryLevel = trackerPosition.attributes?.batteryLevel {
            if batteryLevel > 1 {
                bottomSheetWatch.statusScroll.batteryImage.image = #imageLiteral(resourceName: "FullBattery")
            } else if batteryLevel >= 0 && batteryLevel <= 1 {
                bottomSheetWatch.statusScroll.batteryImage.image = UIImage(named: "lowbattery")
                
            } else {
                bottomSheetWatch.statusScroll.batteryImage.image = #imageLiteral(resourceName: "noBatttery")
            }
            bottomSheetWatch.statusScroll.batteryStatusLabel.text = "\(batteryLevel)" + " %"
        } else {
            bottomSheetWatch.statusScroll.batteryImage.image = #imageLiteral(resourceName: "noBatttery")
        }
    }
    
    
    func checkForTemprature(trackerPosition: TrackerPositionMapperModel?) {
        //        if let temperature = trackerPosition
    }
    
    func checkForNetwork(trackerDevice: TrackerDevicesMapperModel?, isWatch: Bool) {
        if let status = trackerDevice?.status {
            if !isWatch {
                
                print("not watch")
                
            } else {
                
                
                if status == "online" {
                    bottomSheetWatch.statusScroll.networkImage.image = #imageLiteral(resourceName: "Connected")
                    bottomSheetWatch.statusScroll.networkStatusLabel.text = "CONNECTED"
                } else {
                    bottomSheetWatch.statusScroll.networkImage.image = #imageLiteral(resourceName: "NotConnected")
                    bottomSheetWatch.statusScroll.networkStatusLabel.text = "DISCONNECTED"
                }
                
            }
            
        } else {
            
            if !isWatch {
                print("not watch")
                
            } else {
                
                bottomSheetWatch.statusScroll.networkImage.image = #imageLiteral(resourceName: "NotConnected")
                bottomSheetWatch.statusScroll.networkStatusLabel.text = "DISCONNECTED"
                
                
            }
        }
        
    }
    
    func openBottomSheet(protocoll: String) {
        
        if protocoll != watchProtocol {
            
            UIView.animate(withDuration: 0.3, animations: {
                isBottomSheetVisible = true
                if self.mapHomeView != nil {
                    self.mapHomeView.directionButton.isHidden = false
                }
                let Ycordinate = self.view.frame.size.height - bottomSheetHeight
                self.initialTouchPoint = CGPoint(x: 0, y: Ycordinate)
                bottomSheet.frame = CGRect(x: 0, y: Ycordinate, width: self.view.frame.size.width, height: bottomSheetHeight)
            }) { [weak self] finished in
                guard let weakself = self else { return }
                weakself.focusOnMarker()
            }
            
        } else  {
            
            UIView.animate(withDuration: 0.3, animations: {
                isBottomSheetVisibleWatch = true
                if self.mapHomeView != nil {
                    self.mapHomeView.directionButton.isHidden = false
                }
                let Ycordinate = self.view.frame.size.height - bottomSheetHeight
                self.initialTouchPoint = CGPoint(x: 0, y: Ycordinate)
                bottomSheetWatch.frame = CGRect(x: 0, y: Ycordinate, width: self.view.frame.size.width, height: bottomSheetHeight)
            }) { [weak self] finished in
                guard let weakself = self else { return }
                weakself.focusOnMarker()
            }
            
        }
        
    }
    
    func focusOnMarker() {
//        let keyValuePos = "Position_" + "\(bottomSheetDeviceId)"
//        let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
        
        var bottomPadding: CGFloat = 75
        
        if isBottomSheetVisible {
            bottomPadding = bottomSheetHeight
        }
        if isBottomSheetVisibleWatch {
            bottomPadding = bottomSheetHeight
        }
        
        if bottomPadding == 75 {
            bottomPadding = 0
        } else {
            bottomPadding = bottomPadding - 75
        }
        
//        var course:CLLocationDirection = 0
//
//        if !isMarkerLabelShowed {
//            course = CLLocationDirection(devPostition?.course ?? 0.0)
//        }
        
//        let cameraPosition = GMSCameraPosition.camera(withLatitude: devPostition?.latitude ?? 0,
//                                                      longitude: devPostition?.longitude ?? 0,
//                                                      zoom: RCMapView.mapView.camera.zoom,
//                                                      bearing: course, viewingAngle: RCMapView.mapView.camera.viewingAngle)
//
        RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0, bottomPadding, 0)
//        RCMapView.mapView.animate(to: cameraPosition)
    }
    func closeAllDatePickers(){
        if let picker = datePpicker{
            picker.isHidden = true
        }
        if let picker1 = datePppicker{
            picker1.isHidden = true
        }
        if let picker2 = datePpppicker{
            picker2.isHidden = true
        }
        toolBbar.isHidden = true
        toolBbbar.isHidden = true
        toolBbbbar.isHidden = true
    }
    
    func closeBottomSheetWatch() {
        closeAllDatePickers()
        RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0)
        if mapHomeView != nil {
            mapHomeView.directionButton.isHidden = true
        }
        UIView.animate(withDuration: 0.3, animations: {
            isBottomSheetVisibleWatch = false
            bottomSheetWatch.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.size.width, height: bottomSheetHeight)
        }) { [weak self] finished in
            guard let weakself = self else { return }
            weakself.fitMap()
        }
    }
    
    func closeBottomSheet() {
        closeAllDatePickers()
        RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0)
        if mapHomeView != nil {
            mapHomeView.directionButton.isHidden = true
        }
        UIView.animate(withDuration: 0.3, animations: {
            isBottomSheetVisible = false
            bottomSheet.frame = CGRect(x: 0, y: self.view.frame.maxY, width: self.view.frame.size.width, height: bottomSheetHeight)
        }) { [weak self] finished in
            guard let weakself = self else { return }
            weakself.fitMap()
        }
    }
    
    @objc func cameraBtnWatchModePressed(_ sender: UITapGestureRecognizer) {
        
        self.prompt("Camera", "Are you sure you want to click the image from watch ?", "Yes", "No", handler1: { (_) in
            
            let stringWatch = "Device_Watch"
            let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
            
            RCLocalAPIManager.shared.sendCommand(with: deviceId, command: "rcapture", success: { (response) in
                
                UIApplication.shared.keyWindow?.makeToast("Image Captured Successfully".toLocalize,
                                                          duration: 2.0, position: .bottom)
                
                
            }) { (_) in
                
                
                UIApplication.shared.keyWindow?.makeToast("Image Capture Failed".toLocalize,
                                                          duration: 2.0, position: .bottom)
                
            }
            
            
            
        }) { (_) in
            return
        }
        
        
    }
    
    @objc func callWatchBtnPressed(_ sender: UITapGestureRecognizer) {
        
        let stringWatch = "Device_Watch"
        let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        let keyValue = "Device_" + "\(deviceId)"
        let device = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        
        let numberOfMobileDigits = device?.phone?.count
        
        
        if numberOfMobileDigits ?? 0 <= 10 {
            
            self.prompt("call Watch", "Are you sure you want to call on watch?", "Yes", "No", handler1: { (_) in
                
                guard let deviceNumber = device else {self.prompt("Not a valid Device")
                    return
                }
                
                guard let watchNumber = deviceNumber.phone else { self.prompt("Watch Number not valid")
                    
                    return
                    
                }
                
                if let url = URL(string: "tel://\(watchNumber)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                
            }) { (_) in
                return
            }
        } else {
            
            UIApplication.shared.keyWindow?.makeToast("Calling Watch failed".toLocalize,
                                                      duration: 2.0, position: .bottom)
            
        }
        
    }
    
    
    
    @objc func openAlbumWatchPressed(_ sender: UITapGestureRecognizer) {
        
        self.prompt("Feature will be available soon")
        
        let stringWatch = "Device_Watch"
        _ = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
        
        
        let fcmToken = Defaults().get(for: Key<String>("RCFCMToken")) ?? ""
        
        var imageUrlCollection : [String] = []
        
        
        if let loginData = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data {
            if let username = loginData.email {
                let keychain = Keychain(service: "in.roadcast.bolt")
                let password: String = {
                    do {
                        return try keychain.getString("boltPassword") ?? ""
                    } catch {
                        return ""
                    }
                }()
                
                
                RCLocalAPIManager.shared.session(with: username, password: password, success: { (response) in
                    
                    let pageURL = "https://tracapi.roadcast.co.in/api/media/2802471952/"
                    
                    if let loginData = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data {
                        if loginData.email != nil {
                            let keychain = Keychain(service: "in.roadcast.bolt")
                            let _: String = {
                                do {
                                    return try keychain.getString("boltPassword") ?? ""
                                } catch {
                                    return ""
                                }
                            }()
                        }
                    }
                    
                    
                    let parameters: [String:Any] = ["email": username,
                                                    "password": password]
                    
                    let headers = [
                        "Authorization": fcmToken,
                    ]
                    
                    
                    Alamofire.request(pageURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate(contentType: ["application/x-www-form-urlencoded"]).response { (response) in
                        
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            do {
                                let html: String = utf8Text
                                let doc: Document = try SwiftSoup.parse(html)
                                
                                let elements: Elements = try  doc.select("a[href^=/api]") //doc.getAllElements()
                                for element in elements {
                                    let textInElement = try element.text()
                                    let htmlText = try element.outerHtml()
                                    print("\(textInElement): \(htmlText)")
                                    
                                    let s = htmlText
                                    
                                    let between = s.between("href=\"", "\">")
                                    print("betweeen=\(between ?? "")")
                                    imageUrlCollection.append(between ?? "")
                                    
                                    
                                }
                                
                                self.setImage(imageCollection: imageUrlCollection)
                                
                            } catch {}
                            
                        } else {
                            
                        }
                        
                    }
                    
                    
                    
                }) { (error) in
                    //do nothing
                }
            }}
        
        
    }
    
    func setImage(imageCollection: [String]) {
        
        let basicUrl = "https://tracapi.roadcast.co.in"
        
        let imageviewNew = UIImageView()
        
        var imageurl = ""
        
        if imageCollection.count != 0 {
            for i in 1...imageCollection.count - 1 {
                
                imageurl = basicUrl + imageCollection[i]
                
                imageviewNew.downloadedForWatch(from: imageurl, token: "123456")
                
            }
        }
        
    }
    
    @objc func updateWatchTImeWithMobileTimeBtnPressed(_ sender: UITapGestureRecognizer) {
        
        
        self.prompt("Update Time", "Are you sure you want update watch time with mobile Time ?", "Yes", "No", handler1: { (_) in
            
            let stringWatch = "Device_Watch"
            let deviceId = Defaults().get(for: Key<Int>(stringWatch)) ?? 0
            
            
            //TIME,17.41.00,DATE,2019.10.30
            
            let currentDate = Date()
            let time = RCGlobals.getFormattedTimeWatch(date: currentDate as Date as NSDate)
            let dateW = RCGlobals.getFormattedDataWatch(date: currentDate as Date as NSDate)
            print("time is \(time)")
            print("Date watch is \(dateW)") //dubto
            let timeDateString = "TIME,\(time),DATE,\(dateW)"
            RCLocalAPIManager.shared.sendCommand(with: deviceId, command: timeDateString, success: { (response) in
                
                UIApplication.shared.keyWindow?.makeToast("Time updated Successfully".toLocalize,
                                                          duration: 2.0, position: .bottom)
                
                
            }) { (_) in
                
                
                UIApplication.shared.keyWindow?.makeToast("Time updation Failed".toLocalize,
                                                          duration: 2.0, position: .bottom)
                
            }
            
            
            
            
        }) { (_) in
            return
        }
        
        
    }
    
    
    @objc func showFuelController(_ sender: UITapGestureRecognizer) {
        let page = EditFuelController()
        page.modalPresentationStyle = .custom
        self.present(page, animated: true, completion: nil)
    }
    
    func checkForBottomSheet() {
        
        if isBottomSheetVisible {
            closeBottomSheet()
        } else if isBottomSheetVisibleWatch {
            closeBottomSheetWatch()
        }
        RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapHomeView.directionButton.isHidden = !mapHomeView.isDirectionButtonHidden
        mapView.selectedMarker = nil
        checkForBottomSheet()
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        if let geofenceName = overlay.title {
            UIApplication.shared.keyWindow?.makeToast("Geofence name: " + geofenceName)
        }
        checkForBottomSheet()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (!didTapMarker) {
            isMapMoved = gesture
        }else {
            didTapMarker = false
        }
    }
    
    @objc func swipeGestureRecognizer(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            closeBottomSheet()
        }
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: bottomSheet.window)
        let Ycordinate = self.view.frame.size.height - bottomSheetHeight
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.closeBottomSheet()
                //                bottomSheet.frame = CGRect(x: 0, y: bottomSheet.frame.minY - initialTouchPoint.y, width: self.view.frame.size.width, height: bottomSheetHeight)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.closeBottomSheet()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    bottomSheet.frame = CGRect(x: 0, y: Ycordinate, width: self.view.frame.size.width, height: bottomSheetHeight)
                })
            }
        }
    }
    
    
}

extension UIViewController {
    func hexStringToUIColor(hex: String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension Date {
    
    public func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}

extension MapsViewController {
    
    
    //MARK:- Custom methods - expired subscription popup
    
    @objc func findExpiryDate(completion: @escaping (_ success: Bool) -> Void) {
        self.expiredDeviceIds.removeAll()
        RCLocalAPIManager.shared.getDevicesDetails(success: { [weak self] value in
            guard let weakself = self else { return }
            let temp = value.data?.filter( { $0.id == self?.deviceId } ).map({ $0 })
            
            let todayDate = Date()
            var expiredList:[ExpiryDataResponseModel] = []
            for i in 0...value.data!.count - 1 {
                
                if value.data![i].subscriptionExpiryDate != nil {
                    //if date is not nil
                    
                    let date2 = RCGlobals.getDateFromStringFormat2(value.data![i].subscriptionExpiryDate!)
                    
                    let dateDifference = abs(date2.days(from: todayDate))
                    
                    if date2 < todayDate {
                        let model = ExpiryDataResponseModel()
                        model.name = value.data![i].name
                        model.deviceid = value.data![i].id
                        model.uniqueid = value.data![i].uniqueId
                        model.subscriptionExpiryDate = value.data![i].subscriptionExpiryDate
                        expiredList.append(model)
                        self?.expiredVehicleRegistrationName.append(value.data![i].name ?? "")
                        self?.expiryDateArray.append(value.data![i].subscriptionExpiryDate ?? "")
                        self?.expiredVehicles.append(value.data![i].name ?? "")
                        if !(self?.expiredDeviceIds.contains(value.data![i].id ?? "") ?? false) {
                            self?.expiredDeviceIds.append(value.data![i].id ?? "")
                        }
                    
                    } else if (dateDifference < 7) && (date2 >= todayDate) {
                        //bout to expire in seven days
                        self?.expireInSevenDaysRegistrationName.append(value.data![i].name ?? "")
                        self?.expireInSevenDays.append(value.data![i].subscriptionExpiryDate!)
                    }
                }
            }
            Defaults().set(expiredList, for: Key<[ExpiryDataResponseModel]>("expired_vehicles"))
            Defaults().set(self?.expiredDeviceIds ?? [], for: Key<[String]>("expired_vehicles_id"))
            UserDefaults.standard.set(self?.expiredDeviceIds, forKey: "expiredDeviceIds")
            
            if (self?.expiredDeviceIds.count ?? 0) > 0 || (self?.expireInSevenDays.count ?? 0) > 0 {
                self?.expiryPopupSelection()
                Defaults().set(true, for: Key<Bool>("isPopUpPresented"))
                Defaults().set(true, for: Key<Bool>("isPopUpPresentedInMainController"))
            }
            
            if let CarData = temp?.first {
                weakself.showTextInView(model: CarData)
            }
            completion(true)
        }) { [weak self] message in
            guard self != nil else { return }
            print("\(message)")
        }
        
//        RCLocalAPIManager.shared.getExpiredVehicles(with:"", success: { (success) in
//            print("success in getting expired vehicles info")
//            let expiredList:[ExpiryDataResponseModel] = Defaults().get(for: Key<[ExpiryDataResponseModel]>("expired_vehicles")) ?? []
//            for item in expiredList {
//                self.expiredVehicleRegistrationName.append(item.name ?? "")
//                self.expiryDateArray.append(item.subscriptionExpiryDate ?? "")
//                self.expiredVehicles.append(item.name ?? "")
//                self.expiredDeviceIds.append(item.deviceid ?? "")
//            }
//            UserDefaults.standard.set(self.expiredDeviceIds, forKey: "expiredDeviceIds")
//            if expiredList.count > 0 {
//                self.expiryPopupSelection()
//                Defaults().set(true, for: Key<Bool>("isPopUpPresented"))
//                Defaults().set(true, for: Key<Bool>("isPopUpPresentedInMainController"))
//            }
//            completion(true)
//        }) { (failure) in
//            print("failure in getting expired vehicles info")
//        }
        
    }
    
    func presentExpiry(hideShowCross: Bool, expiredOrAboutToShowExpiry: [String], alert: String) {
        var expiredOrAboutToExpiry = expiredOrAboutToShowExpiry
        expiredOrAboutToExpiry = expiredOrAboutToExpiry.filter({ $0 != ""})
        if expiredOrAboutToExpiry.isEmpty{
            return
        }
        let joined = expiredOrAboutToExpiry.joined(separator: ", ")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            
            let popUpVC = SubscriptionExpired()
            popUpVC.vehicleNumberLabel.text = joined
            popUpVC.closeButton.isHidden = hideShowCross
            popUpVC.descriptionLabel.text = alert
            popUpVC.onCompletion = { _ in
            }
            
            popUpVC.modalTransitionStyle = .crossDissolve
            popUpVC.modalPresentationStyle = .custom
            popUpVC.view.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            
            
            
            print(expiredVehicleNumber)
            
            self.present(popUpVC, animated: true, completion: nil)
        }}
    
    
    func showExpiredSubscriptionDatePopup() {
        //if array is empty, repopulate
        if expiryDateArray.count == 0 && expiredVehicles.count == 0 {
            findExpiryDate { (success) -> Void in
                if success {
                    
                    // do second task if success
                    self.expiryPopupSelection()
                }
            }
        } else {
            //if populated just display
            self.expiryPopupSelection()
        }
        
        Defaults().set(true, for: Key<Bool>("isPopUpPresented"))
        Defaults().set(true, for: Key<Bool>("isPopUpPresentedInMainController"))
    }
    
    func expiryPopupSelection() {
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        let allDevices = RCGlobals.getExpiryFilteredList(data)
        let allDevicesCount = allDevices.count
        
        expireInSevenDays = expireInSevenDays.filter({ $0 != "0"})
        expiryDateArray = expiryDateArray.filter({ $0 != "0"})
        
        if (expiryDateArray.count != 0) {
            
            if (expiryDateArray.count == allDevicesCount) {
                
                //all devices expired
                
                presentExpiry(hideShowCross: true,
                              expiredOrAboutToShowExpiry: expiredVehicleRegistrationName,
                              alert: expiredAlert)
                
            }  else if expiryDateArray.count != 0 {
                
                presentExpiry(hideShowCross: false, expiredOrAboutToShowExpiry: expiredVehicleRegistrationName,
                              alert: expiredAlert)
            }
            
        } else if expireInSevenDays.count != 0 && allDevicesCount > expiryDateArray.count {
            
            // half of the devices expired, rest bout to expire in 7 days,  rest fine
            
            presentExpiry(hideShowCross: false,
                          expiredOrAboutToShowExpiry: expireInSevenDaysRegistrationName,
                          alert: expireInSevenAlert)
            
        } else if expireInSevenDays.count == allDevices.count {
            
            //all about to expire in seven days
            
            presentExpiry(hideShowCross: false,
                          expiredOrAboutToShowExpiry: expireInSevenDaysRegistrationName,
                          alert: expireInSevenAlert)
            
        }
    }
}

extension MapsViewController {
    // custom functions to check expired devices or not
    
    func checkExpiredOrNotDevices(checkArray: [TrackerDevicesMapperModel]?) -> [TrackerDevicesMapperModel] {
        let expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as? [String] ?? [String]()
        var notExpiredDevices: [TrackerDevicesMapperModel] = []
        
        for i in checkArray! {
            if !expiredIdArray.contains(String(i.id)) {
                notExpiredDevices.append(i)
            }
        }
        return notExpiredDevices
    }
    
    func checkExpiredOrNotPositions(checkArray: [TrackerPositionMapperModel]?) -> [TrackerPositionMapperModel] {
        let expiredIdArray = UserDefaults.standard.array(forKey: "expiredDeviceIds") as? [String] ?? [String]()
        var notExpiredDevices: [TrackerPositionMapperModel] = []
        
        for i in checkArray! {
            if !expiredIdArray.contains(String(i.deviceId!)) {
                notExpiredDevices.append(i)
            }
        }
        return notExpiredDevices
    }
}


extension MapsViewController:  UITextFieldDelegate {
    
    @objc func dateField(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.time
        datePickerView.locale = Locale(identifier: "en_US")
        sender.inputView = datePickerView
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels
            datePickerView.tintColor = .black
            datePickerView.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
    }
    func DoneButton(sender: UIButton) {
        //  bottomSheetWatch.timeLabel.text = timeFormatter.string(from: sender.date)
        bottomSheetWatch.timeLabel.resignFirstResponder()
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        bottomSheetWatch.timeLabel.text = timeFormatter.string(from: sender.date)
        print("time \(bottomSheetWatch.timeLabel.text ?? "")")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bottomSheetWatch.timeLabel {
            dateField(sender: textField)
        }
    }
    
    
}

extension MapsViewController: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nearbyitem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = nearbyplaceview.nearbyplaceTableView.dequeueReusableCell(withIdentifier: "cell") as! NearByPlacesTableViewCell
        order.iconImageView.image = nearbyimages[indexPath.row]
        order.iconitemnameLabel.text? = nearbyitem[indexPath.row]
        //order.hireitemnameLabel.text? = helpBarExp[indexPath.row]
        //order.textLabel?.numberOfLines = 2
        order.selectionStyle = .none
        
        return order
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90.0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = appDarkTheme
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = appDarkTheme
        
        
        
        let nearbyString = nearbyitemSearchList[indexPath.row].lowercased()
        let nearbyItemString = nearbyString.replacingOccurrences(of: " ", with: "")
        
        let keyValuePos = "Position_" + "\(selectedDeviceId)"
        let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
        
        if let position = devPostition {
            
            if let lat = position.latitude , let long = position.longitude {
                
                if #available(iOS 10, *) {
                    //\(nearbyItemString)&center=
                    
                    let lati = String(lat)
                    let longi = String(long)
                    
                    let urlString = URL(string: "comgooglemaps://?api=1&center=\(lati),\(longi)&q=\(nearbyItemString)")!
                    UIApplication.shared.open(urlString, options: [:], completionHandler: { (success) in
                        if success == false {
                            
                            let urlString = URL(string:"https://www.google.com/maps/search/?api=1&center=\(lati),\(longi)&query=\(nearbyItemString)")!
                            
                            UIApplication.shared.open(urlString)
                        }
                    })
                }
                else {
                    
                    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                        
                        let urlString = URL(string: "comgooglemaps://?q=\(String(describing: lat)),\(String(describing: long))&q=\(nearbyItemString)")!
                        
                        UIApplication.shared.openURL(urlString)
                        
                    } else {
                        
                        let urlString = URL(string:"https://www.google.com/maps/search/\(nearbyItemString)/@\(String(describing: lat)),\(String(describing: long))")!
                        
                        UIApplication.shared.openURL(urlString)
                        
                    }
                }
                
            } else {
                self.prompt("Device Location is Not Available")
            }
        } else {
            self.prompt("Device Location is Not Available")
        }
    }
    
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell1 = nearbyplaceview.nearbyplaceTableView.cellForRow(at: indexPath)
        cell1?.backgroundColor = appDarkTheme
    }
}
extension MapsViewController
{
    func getthedates()
    {
        let dateString: String = dateFrom
        let dateFormatter1: DateFormatter = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate: NSDate = dateFormatter1.date(from: dateString)! as NSDate
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        firstDateSelected = (dateFormatter1.string(from: yourDate as Date))
        
        let dateString1: String = timeTo
        let dateFormatter11: DateFormatter = DateFormatter()
        dateFormatter11.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate1: NSDate = dateFormatter11.date(from: dateString1)! as NSDate
        dateFormatter11.dateFormat = "yyyy-MM-dd"
        secondDateSelected = (dateFormatter1.string(from: yourDate1 as Date))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date123 = dateFormatter.date(from: firstDateSelected) ?? Date()//Get date in dateFrom
        let dateFormatters = DateFormatter()
        dateFormatters.dateFormat = "yyyy-MM-dd"
        let date223 = dateFormatters.date(from: secondDateSelected) ?? Date()//Get date in dateTo
        let differ = daysBetweenDates(startDate: date123, endDate: date223)
        
        for _ in 0...differ
        {
            let mdt = date123
            
            let date3 = mdt.toString(dateFormat: "yyyy-MM-dd")
            datearray.append(date3)
            date123 = Calendar.current.date(byAdding: .day, value: 1, to: mdt)!//Add 1 date of date
        }
    }
}
extension MapsViewController {
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(options[index])
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentCallDriver(title: String, message: String, options: [DriverInfoResponseModel], completion: @escaping (DriverInfoResponseModel) -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for option in options {
            let name:String = "\(option.name) (\(option.mobile))"
            alertController.addAction(UIAlertAction.init(title: name, style: .default, handler: { (action) in
                completion(option)
            }))
        }
        let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MapsViewController {
    
    @objc func backbuttontapped() {
        mapHomeView.rcMapView.clear()
        mapHomeView.backButton.isHidden = true
        mapHomeView.playbackStopCount.isHidden = true
        mapHomeView.searchButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        isPlayBackButtonTapped = false
        playbackview.isHidden = true
        handleMarkerPlotting()
        mapHomeView.optionButton.isHidden = false
        datearray.removeAll()
        dateCounter = 0
        dateFrom = ""
        timeTo = ""
        RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0,0,0)
    }
    
    //MARK:- Mycalender starts
    func setupalertactivity() {
        presentAlertWithTitle(title: "Open Calendar", message: "Please select one option",
                              options: "Single Date", "Ranged Date", "Cancel") { (option) in
            
            self.optionchoise = option
            
            switch(option) {
            case "Single Date":
                self.doDatePicker()
                break
            case "Ranged Date":
                self.doDatePicker()
                break
            case "Cancel":
                self.dismiss(animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
    //MARK:- Mycalender Ends
    
    @objc func setupPathChooser() {
        presentAlertWithTitle(title: "Path", message: "Please select one option",
                              options: "Ignition Path", "Daily Path", "Path Replay", "Cancel") { (option) in
            
            self.optionchoise = option
            
            switch(option) {
            case "Ignition Path":
                self.pathButtonTapped()
                break
            case "Daily Path":
                self.dailyButtonTapped()
                break
            case "Path Replay":
                self.playbackButtonTapped()
            case "Cancel":
                self.dismiss(animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }
    
    func doDatePicker(){
        // DatePicker
        self.datePpicker = UIDatePicker()//(frame:CGRect(x: 0, y: kscreenheight * 0.6, width: self.view.frame.size.width, height: 200))
        self.datePpicker?.backgroundColor = UIColor.white
        self.datePpicker?.datePickerMode = UIDatePickerMode.dateAndTime
        let now = Date()
        self.datePpicker.maximumDate = now;
        let modifiedDate = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        self.datePpicker.minimumDate = modifiedDate
        //datePicker.center = view.center
        view.addSubview(self.datePpicker)
        
        // ToolBar
        toolBbar = UIToolbar()//(frame: CGRect(x: 0, y: kscreenheight * 0.58, width: self.view.frame.size.width, height: 50))
        toolBbar.barStyle = .default
        toolBbar.backgroundColor = .black
        
        toolBbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBbar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        let name = UIBarButtonItem(title: "From Date", style: .plain, target: self, action: nil)
        toolBbar.setItems([cancelButton ,name, spaceButton, doneButton], animated: true)
        toolBbar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBbar)
        self.toolBbar.isHidden = false
        if #available(iOS 13.4, *) {
            datePpicker.preferredDatePickerStyle = .wheels
            datePpicker.tintColor = .black
            datePpicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        setPickerConstraints(datePicker: datePpicker, toolBar: toolBbar)
    }
    
    @objc func doneClick() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datePpicker.isHidden = true
        self.toolBbar.isHidden = true
        dateFrom = dateFormatter.string(from: datePpicker.date)
        
        
        dateFromInDate = dateFormatter.date(from: dateFrom) ?? Date()
        
        
        let yourDate: NSDate = dateFormatter.date(from: dateFrom)! as NSDate
        dateFormatter.dateFormat = "yyyy-MM-dd"
        firstDateSelected = (dateFormatter.string(from: yourDate as Date))
        
        dateFormatter.dateFormat = "HH:mm:ss"
        firstTimeSelected = (dateFormatter.string(from: yourDate as Date))
        
        
        
        doTimePicker()
    }
    
    @objc func cancelClick() {
        datePpicker.isHidden = true
        self.toolBbar.isHidden = true
        mapHomeView.optionButton.isHidden = false
    }
    @objc func hidePicker(){
        self.dateFrom = ""
        datePppicker.isHidden = true
        self.toolBbbar.isHidden = true
        mapHomeView.optionButton.isHidden = false
    }
    @objc func hideSingle(){
        self.dateFrom = ""
        datePpppicker.isHidden = true
        self.toolBbbbar.isHidden = true
        mapHomeView.optionButton.isHidden = false
    }
    
    func doTimePicker() {
        
        if optionchoise == "Single Date"
        {
            singleDate()
            
        }
        else{
            //            DatePicker
            self.datePppicker = UIDatePicker()//(frame:CGRect(x: 0, y: kscreenheight * 0.6, width: self.view.frame.size.width, height: 200))
            self.datePppicker?.backgroundColor = UIColor.white
            self.datePppicker?.datePickerMode = UIDatePickerMode.dateAndTime
            datePppicker.minimumDate = dateFromInDate
            let now = Date()
            self.datePpicker.maximumDate = now;
            //            let modifiedDate = Calendar.current.date(byAdding: .month, value: -2, to: now)!
            //            self.datePpicker.minimumDate = modifiedDate
            //datePppicker.maximumDate = Calendar.current.date(byAdding: .day, value: 8, to: sk)
            view.addSubview(self.datePppicker)
            // ToolBar
            toolBbbar = UIToolbar()//(frame: CGRect(x: 0, y: kscreenheight * 0.58, width: self.view.frame.size.width, height: 50))
            toolBbbar.barStyle = .default
            toolBbbar.backgroundColor = .black
            toolBbbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
            toolBbbar.sizeToFit()
            
            // Adding Button ToolBar
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let name = UIBarButtonItem(title: dateFrom , style: .plain, target: self, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hidePicker))
            toolBbbar.setItems([cancelButton, name,spaceButton, doneButton], animated: true)
            toolBbbar.isUserInteractionEnabled = true
            
            self.view.addSubview(toolBbbar)
            self.toolBbbar.isHidden = false
            if #available(iOS 13.4, *) {
                datePppicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
                datePppicker.tintColor = .black
                datePppicker.backgroundColor = .white
            } else {
                // Fallback on earlier versions
            }
            setPickerConstraints(datePicker: datePppicker, toolBar: toolBbbar)
        }
    }
    
    @objc func doneTimePick() {
        //OptionButtonTapped()
        //let dateFfformatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        datePppicker.isHidden = true
        self.toolBbbar.isHidden = true
        timeTo = dateFormatter.string(from: datePppicker.date)
        combinationOfDateAndTime = timeTo
        
        
        //let dateFormatterss = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeToInDate = dateFormatter.date(from: timeTo) ?? Date()
        
        let dateString: String = timeTo
        //let dateFormatter1: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let yourDate: NSDate = dateFormatter.date(from: dateString)! as NSDate
        dateFormatter.dateFormat = "HH:mm:ss"
        
        lastTimeSelected = (dateFormatter.string(from: yourDate as Date))
        
        if dateFrom != ""
        {
            //let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date1 = dateFormatter.date(from: dateFrom) ?? Date()//Get date in dateFrom
            //let dateFormatters = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date2 = dateFormatter.date(from: timeTo) ?? Date()//Get date in dateTo
            let diff = daysBetweenDates(startDate: date1, endDate: date2)
            
            
            if diff <= 0
            {
                dateFrom = ""
                self.prompt("ALERT", "Please select valid range", "OK") { (_) in
                    self.mapHomeView.optionButton.isHidden = false
                    self.setupalertactivity()
                }
                //                prompt("Please select some range")
                
            }
            else if diff <= 7
            {
                getthedates()
                playbringback()
                mapHomeView.backButton.isHidden = false
                mapHomeView.playbackStopCount.isHidden = false
                mapHomeView.searchButton.isHidden = true
            }
            else
            {   dateFrom = ""
                self.prompt("ALERT", "You have taken a range of more than 7 days", "OK") { (_) in
                    self.setupalertactivity()
                    self.mapHomeView.optionButton.isHidden = false
                }
                //                prompt("You have taken a range of more than 7 days")
                
            }
        }
    }
    
    func singleDate() {
        self.datePpppicker = UIDatePicker()//(frame:CGRect(x: 0, y: kscreenheight * 0.6, width: self.view.frame.size.width, height: 200))
        self.datePpppicker?.backgroundColor = UIColor.white
        self.datePpppicker?.datePickerMode = UIDatePickerMode.time
        view.addSubview(self.datePpppicker)
        // ToolBar
        toolBbbbar = UIToolbar()//(frame: CGRect(x: 0, y: kscreenheight * 0.58, width: self.view.frame.size.width, height: 50))
        toolBbbbar.barStyle = .default
        toolBbbbar.backgroundColor = .black
        toolBbbbar.tintColor = UIColor.white//UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBbbbar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneSingleDate))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let name = UIBarButtonItem(title: dateFrom , style: .plain, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(hideSingle))
        toolBbbbar.setItems([cancelButton, name,spaceButton, doneButton], animated: true)
        toolBbbbar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBbbbar)
        self.toolBbbbar.isHidden = false
        if #available(iOS 13.4, *) {
            datePpppicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            datePpppicker.tintColor = .black
            datePpppicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        setPickerConstraints(datePicker: datePpppicker, toolBar: toolBbbbar)
        
        
    }
    
    @objc func doneSingleDate() {
        
        RCMapView.clearMap()
        datePpppicker.isHidden = true
        self.toolBbbbar.isHidden = true
        
        //let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let datenew = dateFormatter.string(from: dateFromInDate)
        
        
        dateFormatter.dateFormat = "HH:mm:ss"
        lastTimeSelected = dateFormatter.string(from: datePpppicker.date)
        
        
        combinationOfDateAndTime = datenew + " " + lastTimeSelected
        
        timeTo = combinationOfDateAndTime
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeToInDate = dateFormatter.date(from: combinationOfDateAndTime) ?? Date()
        datearray.append(datenew)
        playbringback()
        mapHomeView.backButton.isHidden = false
        mapHomeView.playbackStopCount.isHidden = false
        mapHomeView.searchButton.isHidden = true
    }
}

//MARK:- PLAYBACK CHANGED
//MARK:- Viveks playback code

extension MapsViewController {
    //MARK:- Playback Button
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!//convert day to dates
    }
    
    func playbringback(){
        indexDevicePath = 0

       // initDevicePosition(device: selectedDeviceId)
        if(!isPlayBackButtonTapped)
        {
            playbackview = view.createAndAddSubView(view:"PlayBackView") as? PlayBackView
            playbackview?.snp.makeConstraints({ (make) in
                if #available(iOS 11.0, *) {
                    //make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-0.001 * kscreenheight)//changes to be done when run on iphone 11
                    make.bottom.equalToSuperview().offset(-0.002 * kscreenheight)
                } else {
                    make.bottom.equalToSuperview().offset(-0.001 * kscreenheight)
                }
                make.width.equalToSuperview()
                make.height.equalTo(0.1 * kscreenheight)
            })
            mapHomeView.directionButton.isHidden = true
            mapHomeView.optionButton.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            self.checkForBottomSheet()
            setUpMap()
            let keyValue = "Device_" + "\(bottomSheetDeviceId)"
            let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
            let selectedvehiclename = selDevice?.name ?? ""
            playbackview.vehiclenameLabel.text = selectedvehiclename
            
            var startTime: String = firstTimeSelected
            var endTime: String = lastTimeSelected
            if datearray.count > 1
            {
                if dateCounter == 0
                {
                    endTime = "23:59:59"
                } else if dateCounter == (datearray.count - 1)
                {
                    startTime = "00:00:00"
                } else {
                    startTime = "00:00:00"
                    endTime = "23:59:59"
                }
            }
            let fromDate = datearray[dateCounter] + " " + startTime
            let toDate = datearray[dateCounter] + " " + endTime
            completePlayBackPath.removeAll()
            StopsLocationArray.removeAll()
            StopsCoordinateArray.removeAll()
            ignitionOnOffLocationArray.removeAll()
            idleTimeDifferenceArray.removeAll()
            coordinateArray.removeAll()
            LocationArray.removeAll()
            idleIntervalArray.removeAll()
            gmsPath.removeAllCoordinates()
            let fromDateString = RCGlobals.convertISTToUTC(fromDate, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            
            let toDateString = RCGlobals.convertISTToUTC(toDate, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            getPlayBackRequest(selectedDeviceId: "\(bottomSheetDeviceId)", fromDate: fromDateString, toDate: toDateString)
        }
    }
    func getPlayBackRequest(selectedDeviceId:String , fromDate:String , toDate:String){
        RCLocalAPIManager.shared.getPlaybackRoute(with: selectedDeviceId, fromDate:  fromDate , toDate:  toDate ,duration: "1", success: { [weak self] hash in
            guard self != nil else {
                return
            }
            let data : [PlaybackReportModelData] = hash.data ?? []
            self?.completePlayBackPath.append(contentsOf: data)
            
            self?.checkPlaybackPathDate(selectedDeviceId)
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            indexDevicePath = indexDevicePath + 1
           //  weakSelf.prompt("No data found")
              print(message)
            weakSelf.checkPlaybackPathDate(selectedDeviceId)
        }
    }
    
    func checkPlaybackPathDate(_ selectedDeviceId: String) {
        dateCounter += 1
        
        if dateCounter < datearray.count {
            var startTime: String = firstTimeSelected
            var endTime: String = lastTimeSelected
            if datearray.count > 1
            {
                if dateCounter == 0
                {
                    endTime = "23:59:59"
                } else if dateCounter == (datearray.count - 1)
                {
                    startTime = "00:00:00"
                } else {
                    startTime = "00:00:00"
                    endTime = "23:59:59"
                }
            }
            let fromDateString = datearray[dateCounter] + " " + startTime
            let toDateString = datearray[dateCounter] + " " + endTime
            
            let fromDate = RCGlobals.convertISTToUTC(fromDateString, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            
            let toDate = RCGlobals.convertISTToUTC(toDateString, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss")
            
            getPlayBackRequest(selectedDeviceId: selectedDeviceId, fromDate: fromDate, toDate: toDate)
        } else{
            handlePlayBackPath(playBackData: completePlayBackPath)
        }
    }
    
    func handlePlayBackPath(playBackData:[PlaybackReportModelData]){
            if playBackData.count == 0 {
                self.prompt("", "No data found", "OK") { (_) in
                    self.backbuttontapped()
                }
                return
        }
        setupSelectedPathData()
        clearMap()
        isPlayBackButtonTapped = true
        indexDevicePath = indexDevicePath + 1
        var idleTime = "0"
        var prevLocation: CLLocation? = nil
        var isIgnitionOn = " "
        StopsLocationArray.removeAll()
        StopsCoordinateArray.removeAll()
        LocationArray.removeAll()
        coordinateArray.removeAll()
        dateCounter = 0
        totalDistance = 0
        
        var playbackBounds = GMSCoordinateBounds()
        
        mapHomeView.rcMapView.clear()
        for path in playBackData {
//            let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!)!, longitude: Double(path.longitude!)!), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? "0")!, speed: Double(path.speed ?? "0")!, timestamp: RCGlobals.getDateFromString(path.fixtime ))
            
            let  location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: Double(path.latitude!)!, longitude: Double(path.longitude!)!), altitude: 0.0, horizontalAccuracy: 0, verticalAccuracy: 0, course: Double(path.course ?? "0")!, speed: Double(path.speed ?? "0")!, timestamp: RCGlobals.getDateFromStringWithFormat(path.fixtime,  "yyyy-MM-dd HH:mm:ssZ" ))
            if prevLocation == nil {
                prevLocation = location
                idleTime = path.fixtime
                isIgnitionOn = path.ignition!
                continue
            }
            
            playbackBounds = playbackBounds.includingCoordinate(location.coordinate)
            
            if location.distance(from: prevLocation!) > 0 {
                let first =  RCGlobals.getDateFromStringWithFormat(idleTime,  "yyyy-MM-dd HH:mm:ssZ" )
                let second =  RCGlobals.getDateFromStringWithFormat(path.fixtime,  "yyyy-MM-dd HH:mm:ssZ" )
                
                let dif =   RCGlobals.getDateDiff(start: first, end:second)
                print(dif)
                let stopDuration:Int = Defaults().get(for: Key<Int>("stop_duration")) ?? 5
                if dif > ( stopDuration * 60 ) {
                    let intervalStart = RCGlobals.convertUTCToIST(idleTime, "yyyy-MM-dd HH:mm:ssZ", "MMM dd, yyyy '@' hh:mm a")
                    
                    let intervalEnd = RCGlobals.convertUTCToIST(path.fixtime , "yyyy-MM-dd HH:mm:ssZ", "MMM dd, yyyy '@' hh:mm a")
                    
                    idleIntervalArray.append("\(intervalStart) - \(intervalEnd)")
                    // update ignition
                    ignitionOnOffLocationArray.append(isIgnitionOn)
                    // append time diff
                    idleTimeDifferenceArray.append(dif)
                    // append location
                    StopsLocationArray.append(prevLocation!)
                    // append coordinate
                    StopsCoordinateArray.append(prevLocation!.coordinate)
                    
                }
                idleTime = path.fixtime
                self.directionCounter += 1
                if (self.directionCounter % 20) == 0 {
                    self.plotDirectionMarker(location:location)
                }
            }
            
            LocationArray.append(location)
            coordinateArray.append(location.coordinate)
            gmsPath.add(location.coordinate)
            prevLocation = location
        }
        //        if indexDevicePath == (datearray.count)-1 {
        if LocationArray.count > 0 {
            let totalDistance = GMSGeometryLength(gmsPath)
            playbackview.totalkmLabel.text = RCGlobals.convertDistance(distance: Double(totalDistance))
            playbackview.timeSlider.minimumValue = 0
            mapHomeView.playbackStopCount.isHidden = false
            mapHomeView.playbackStopCount.text = "No. of stops:\(self.StopsCoordinateArray.count)"
            let sliderMaxValue = Float(coordinateArray.count)
            playbackview.timeSlider.maximumValue =  (sliderMaxValue > 0) ? Float(sliderMaxValue - 1) : 0
            plotPathOnMap(points:(LocationArray), coordinateArray:self.coordinateArray)
            //                if let stopMarkers = self.StopsCoordinateArray {
            plotStopMarkersOnMap(coordinateArray: self.StopsCoordinateArray, diffArray: self.idleTimeDifferenceArray)
            //                }
            closeBottomSheet()
            closeBottomSheetWatch()
        }
        
        RCMapView.mapView.setMinZoom(1, maxZoom: 20)
        RCMapView.mapView.padding = UIEdgeInsetsMake(0, 0, playbackview.frame.size.height, 0)
        RCMapView.mapView.animate(with: GMSCameraUpdate.fit(playbackBounds, with: UIEdgeInsets(top: 70 , left: 10 ,bottom: 70 ,right: 10)))
        //        }
    }
    
    func plotDirectionMarker(location:CLLocation){
        let directionMarker = GMSMarker(position: location.coordinate)
        directionMarker.rotation = location.course
        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "direction-arrow")!, deg: 180)
        directionMarker.icon = img.resizedImage(CGSize(width: 15, height: 20), interpolationQuality: .default)
        directionMarker.map = mapHomeView.rcMapView
        directionMarker.groundAnchor = CGPointMake(0.5, 0.5)
        directionMarker.title = "Direction"
        directionMarkerArray.append(directionMarker)
    }
    
    func plottingMap(){
        let totalDistance = GMSGeometryLength(gmsPath)
        self.playbackview.totalkmLabel.text = RCGlobals.convertDistance(distance: Double(totalDistance))
        
        self.playbackview.timeSlider.minimumValue = 0
        let sliderMaxValue = Float(self.coordinateArray.count )
        self.playbackview.timeSlider.maximumValue =  (sliderMaxValue > 0) ? Float(sliderMaxValue - 1) : 0
        self.plotPathOnMap(points:(self.LocationArray), coordinateArray:self.coordinateArray)
        self.closeBottomSheet()
        self.closeBottomSheetWatch()
    }
    
    @objc func playbackButtonTapped() -> Void {
        
        selectdeviceid = String(bottomSheetDeviceId)
        
        LocationArray = []
        coordinateArray = []
//        mapHomeView.directionButton.isHidden = true
//        mapHomeView.optionButton.isHidden = true
//        initDevicePosition(device: selectedDeviceId)
        if dateFrom == ""
        {
            setupalertactivity()
        }
    }
    
    func setUpMap() -> Void {
        playbackview?.playRightButton.isHidden = true
        playbackview?.playLeftButton.addTarget(self, action:#selector(didTapReplayButton(sender:)), for:.touchUpInside)
        playbackview?.playRightButton.addTarget(self, action: #selector(didTapFastForwardButton(sender:)), for: .touchUpInside)
        playbackview?.timeSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    @objc func addPhotoTapped(){
        let keyValue = "Device_" + "\(bottomSheetDeviceId)"
        let device = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        let timeMillis = convertDateInMilliseconds(date: RCGlobals.getDateFor(device!.lastUpdate!))
        let currentMillis = RCGlobals.getCurrentMillis()
        let timeDifference = currentMillis - timeMillis
        
        if timeDifference < (5*60*1000) {
            Defaults().set(bottomSheetDeviceId, for: Key<Int> ("bottomSheetDeviceId"))
            let addphotoVC = AddPhotoViewController()//chnages done her
            let controller = UINavigationController(rootViewController: addphotoVC)
            self.present(controller, animated: true, completion: nil)
        } else {
            let message = "This feature is not available for devices with last update time older than 5 minutes."
            let alertController = UIAlertController(title: "Feature Unavailable".toLocalize, message: message, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @objc func didTapFastForwardButton(sender:UIButton) -> Void {
        
        replaySpeed = replaySpeed + 1
        
        
        if replaySpeed > 4
        {
            replaySpeed = 1
        }
        
        UIApplication.shared.keyWindow?.makeToast("Replay speed is ".toLocalize + "\(replaySpeed)x", duration: 1.0, position: .center)
        let speed = String(format: "%.0f", (replaySpeed))
        playbackview.replayspeed.text = speed + "x"
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        if coordinateArray.count == 0 {
            return
        }
        animateIndex = Int(sender.value)
        
        if animateIndex == 0 {
            totalDistance = 0
        }
        
        if pathMarker == nil{
            pathMarker = GMSMarker(position:gmsPath.coordinate(at:UInt(animateIndex)))
        }
        else
        {
            let gmsPathSlider = GMSMutablePath()
            for cordinate in self.coordinateArray[0...animateIndex] {
                gmsPathSlider.add(cordinate)
            }
            
            let markerLocation = self.LocationArray[animateIndex]
            let speed = RCGlobals.convertSpeedInt(speed: Float(markerLocation.speed))//changes l to L
            self.playbackview?.showSpeedLabel.text = speed
            self.pathMarker.position = markerLocation.coordinate
            let time = markerLocation.timestamp
            let date = RCGlobals.getFormattedDate(date: time as NSDate)
            playbackview.dateLabel.text = date
            let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
            playbackview.datecalenderLabel.text = timestring
            let currentDistance = GMSGeometryLength(gmsPathSlider)
            totalDistance = currentDistance
            playbackview.currentkmLabel.text = String(format: "%.2f", currentDistance/1000)
        }
    }
    
    @objc func didTapReplayButton(sender:UIButton) -> Void {
        if coordinateArray.count == 0 {
            return
        }
        
        let coordinates = GMSMutablePath()
        playbackview?.playRightButton.isHidden = false
        
        for coordinate in coordinateArray {
            coordinates.add(coordinate)
        }
        
        if sender.currentImage == #imageLiteral(resourceName: "singlePlayicon") {
            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            if pathMarker == nil{
                pathMarker = GMSMarker(position:coordinates.coordinate(at:UInt(animateIndex)))
                switch markerType {
                case 0:
                    if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
                        pathMarker.icon = image
                    } else {
                        pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
                    }
                    break
                    
                case 1:
                    if let image = (RCDataManager.get(objectforKey: "ActiveTruck") as? UIImage)?.resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default) {
                        pathMarker.icon = image
                    } else {
                        pathMarker.icon = #imageLiteral(resourceName: "truck-on").resizedImage(CGSize.init(width: 20, height: 43), interpolationQuality: .default)
                    }
                    break
                    
                case 2:
                    if let image = (RCDataManager.get(objectforKey: "ActiveBike") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
                        pathMarker.icon = image
                    } else {
                        pathMarker.icon = #imageLiteral(resourceName: "bikeon").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
                    }
                    
                    break
                    
                case 3,6,7,5,8:
                    pathMarker.icon = #imageLiteral(resourceName: "car-icon-2")
                    pathMarker.rotation = 0
                    break
                    
                default:
                    if let image = (RCDataManager.get(objectforKey: "ActiveCar") as? UIImage)?.resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default) {
                        pathMarker.icon = image
                    } else {
                        pathMarker.icon = #imageLiteral(resourceName: "car-icon-2").resizedImage(CGSize.init(width: 17, height: 37), interpolationQuality: .default)
                    }
                    break
                }
                let keyValue = "Device_" + "\(selectedDeviceId)"
                let selDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
                _ = selDevice?.name ?? ""
                
                
                pathMarker.title = selDevice?.name
                pathMarker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
                pathMarker.isFlat = true
                pathMarker.map = mapHomeView.rcMapView
                pathMarker.userData = CoordinatesCollection(path:coordinates)
            }else{
                coordinates.removeAllCoordinates()
                for (index, coordinate) in coordinateArray.enumerated() {
                    if index >= animateIndex {
                        coordinates.add(coordinate)
                        print(coordinate.latitude)
                    }
                }
                pathMarker.userData = CoordinatesCollection(path:coordinates)
                
                let gmsPathSlider = GMSMutablePath()
                for cordinate in self.coordinateArray[0...animateIndex] {
                    gmsPathSlider.add(cordinate)
                }
                
                totalDistance = GMSGeometryLength(gmsPathSlider)
                
            }
            animate(toNextCoordinate: pathMarker)
            
        }else{
            sender.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
            sender.imageView?.contentMode = .scaleAspectFit
            playbackview?.playRightButton.isHidden = false
            coordinates.removeAllCoordinates()
            for (index, coordinate) in coordinateArray.enumerated() {
                if index >= animateIndex {
                    coordinates.add(coordinate)
                }
            }
        }
    }
    
    func animate(toNextCoordinate marker: GMSMarker) {
        if animateIndex < coordinateArray.count {
            //            let coordinates: CoordinatesCollection? = marker.userData as? CoordinatesCollection
            let coord: CLLocationCoordinate2D? = coordinateArray[animateIndex]
            let previous: CLLocationCoordinate2D = marker.position
            let heading: CLLocationDirection = GMSGeometryHeading(previous, coord!)
            let distance: CLLocationDistance = GMSGeometryDistance(previous, coord!)
            totalDistance += distance
            
            CATransaction.begin()
            let animationSpeed:Double = 3 * (replaySpeed * 100)
            CATransaction.setAnimationDuration((distance / animationSpeed))
            // custom duration, 5km/sec
            
            if LocationArray.count > 0 {//changes l to L
                CATransaction.setCompletionBlock({() -> Void in
                    
                    let speed = RCGlobals.convertSpeedInt(speed: Float(self.LocationArray[self.animateIndex].speed))//changes l to L
                    self.playbackview?.showSpeedLabel.text = speed
                    self.playbackview.currentkmLabel.text =  String(format: "%.2f", totalDistance/1000) + " KM"
                    self.playbackview.timeSlider.value = Float(self.animateIndex)
                    let time = self.LocationArray[self.animateIndex].timestamp
                    print("time stamp  = \(time)")
//                    let date = RCGlobals.getFormattedDate(date: time as NSDate)
//                    let date = RCGlobals.convertUTCToIST(self.completePlayBackPath[self.animateIndex].fixtime, "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy")
//                    print("date string  = \(date)")
                    let date = RCGlobals.getFormattedDate(date: time as NSDate)
                    self.playbackview.dateLabel.text = date
                    //let timestring = RCGlobals.convertUTCToIST(self.completePlayBackPath[self.animateIndex].fixtime, "yyyy-MM-dd HH:mm:ss", "hh:mm a")
                    let timestring = RCGlobals.getFormattedTime(date: time as NSDate)
                    print("time string  = \(timestring)")
                    self.playbackview.datecalenderLabel.text = timestring
                    if self.coordinateArray.last?.latitude == coord?.latitude && self.coordinateArray.last?.longitude
                        == coord?.longitude {
                        marker.map = nil
                        if (self.playbackview?.playLeftButton.currentImage == #imageLiteral(resourceName: "pause")) {
                            totalDistance = 0
                            self.animateIndex = 0
                            self.playbackview?.showSpeedLabel.text = "0"
                            self.playbackview?.playRightButton.isHidden = false
                            self.playbackview?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
                            self.playbackview?.playLeftButton.imageView?.contentMode = .scaleAspectFit
                            self.pathMarker = nil
                        }
                        
                        
                    }
                    else {
                        
                        if self.playbackview?.playLeftButton.currentImage != #imageLiteral(resourceName: "singlePlayicon") {
                            //add a recursive call here to animate the markers
                            self.animateIndex = self.animateIndex + 1
                            self.animate(toNextCoordinate: marker)
                            
                        }
                    }
                })
            }else{
                self.prompt("Check your internet connection".toLocalize)
            }
            
            
            marker.position = coord!
            CATransaction.commit()
            // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
            if marker.isFlat {
                marker.rotation = heading
            }
        } else {
            self.playbackview?.showSpeedLabel.text = "0"
            self.playbackview?.playRightButton.isHidden = false
            self.playbackview?.playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
            self.playbackview?.playLeftButton.imageView?.contentMode = .scaleAspectFit
            totalDistance = GMSGeometryLength(gmsPath)
        }
        
    }
    
    func clearMap() -> Void {
        RCMapView.mapView.clear()
        RCMapView.mapView.delegate = self//changes
        RCMapView.clearMap()
    }
    
    
    func plotPathOnMap(points:[CLLocation],coordinateArray:[CLLocationCoordinate2D]) -> Void {
        RCPolyLine().drawpolyLineFrom(points: coordinateArray,color: UIColor.blue ,title: "", map: mapHomeView.rcMapView)      //playbackreturnview.pbMapView)
        startmarker = GMSMarker(position:coordinateArray.first!)
        startmarker.map = mapHomeView.rcMapView
        startmarker.icon = GMSMarker.markerImage(with:.green)
        startmarker.title = NSLocalizedString("Start Location", comment: "Start Location")
        
        endMarker = GMSMarker(position:coordinateArray.last!)
        endMarker.map = mapHomeView.rcMapView
        //endMarker.map = playbackreturnview.pbMapView
        endMarker.icon = GMSMarker.markerImage(with:.red)
        endMarker.title = NSLocalizedString("End Location", comment: "End Location")
        
    }
    
    func plotStopMarkersOnMap(coordinateArray:[CLLocationCoordinate2D] , diffArray:[Int]) -> Void {
        if coordinateArray.count == 0 {
            return
        }
        for index in 1...coordinateArray.count {
            let position = coordinateArray[index-1]
            let diff = diffArray[index-1]
            let stopMarker = GMSMarker(position: position)
            stopMarker.map = mapHomeView.rcMapView
            
            let timeDiff = RCGlobals.secondsToHoursMinutesSeconds(diff)
            
            let timeGapInHrs:Int = timeDiff.0
            let timeGapInMins:Int = timeDiff.1
            
            var hrString:String = ""
            var minString:String = ""
            
            if timeGapInHrs > 1 {
                hrString = "\(timeGapInHrs) Hr"
            } else {
                hrString = "\(timeGapInHrs) Hrs"
            }
            
            if timeGapInMins > 1 {
                minString = "\(timeGapInMins) min"
            } else {
                minString = "\(timeGapInMins) mins"
            }
            
            let idleTime = "\(hrString) \(minString)"
            
            let markerImage = RCGlobals.textToImage(text: idleTime, inImage: UIImage(named:"ic_idle_marker")!, atPoint: CGPoint(x: 15, y: 15))
            stopMarker.icon = markerImage.resizedImage(CGSize(width: 65, height: 51), interpolationQuality: .default)
            
            stopMarker.title = NSLocalizedString("Stop Location", comment: "Stop Location")
            stopMarker.tracksInfoWindowChanges = true
            stopMarker.snippet = ""
            let interval = idleIntervalArray[index-1]
            stopMarker.userData = interval
        }
        
    }
    
    func fitMapToBounds(coordinates:[CLLocationCoordinate2D]) -> Void {
        coordinateArray = coordinates
        DispatchQueue.main.async(execute: {() -> Void in
            var bounds = GMSCoordinateBounds(coordinate:coordinates.first!, coordinate:coordinates.last!)
            for marker in coordinates {
                bounds = bounds.includingCoordinate(marker)
            }
            let cameraUpdate = GMSCameraUpdate.fit(bounds, withPadding:20)
            self.mapHomeView.rcMapView.animate(with:cameraUpdate)
            
        })
    }
    
    public static func getStringMatchRegex (pattern: String, str: String) -> Array<String> {
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            let nsstr = str as NSString
            let all = NSRange(location: 0, length: nsstr.length)
            var matches : Array<String> = Array<String>()
            
            regex.enumerateMatches(in: str, options: [], range: all) {
                (result : NSTextCheckingResult!, _, _) in
                matches.append(nsstr.substring(with: result.range))
            }
            return matches
        }catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

extension MapsViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        orders = bottomSheet.tripDetailsCollection.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as? BottomViewCollectionViewCell
        
//        orders.subtitleLabel.text = subtitle[indexPath.row]
//        orders.subtitleLabel1.text = subtitle1[indexPath.row]
        if indexPath.row == 3
        {
            orders.subtitleLabel.text = sheetData[sheetDataKeys.tripDistLabel.rawValue] ?? "Last Trip dist"
            orders.subtitleLabel1.text = sheetData[sheetDataKeys.tripDurLabel.rawValue] ?? "Last Trip dur"
            orders.subtitleValue.text = sheetData[sheetDataKeys.tripDistValue.rawValue] ?? "0km"
            orders.subtitleValue1.text = sheetData[sheetDataKeys.tripDurValue.rawValue] ?? "0min"
            orders.subtitleLabel.textColor = UIColor(red: 200/255, green: 172/255, blue: 0/255, alpha: 1)
            orders.subtitleLabel1.textColor = UIColor(red: 200/255, green: 172/255, blue: 0/255, alpha: 1)
            
        }
        if indexPath.row == 0
        {
            orders.subtitleLabel1.text = "No. of stops"
            let label:String = sheetData[sheetDataKeys.ignitionTimeLabel.rawValue] ?? "Ignition off since"
            orders.subtitleLabel.text = label
            if label.lowercased().contains("on since") {
                orders.subtitleLabel.textColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)
            } else {
                orders.subtitleLabel.textColor = UIColor(red: 255/255, green: 68/255, blue: 68/255, alpha: 1)
            }
            orders.subtitleLabel1.textColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)
            let time:String = sheetData[sheetDataKeys.ignitionTimeValue.rawValue] ?? ""
            if  time.isEmpty {
                orders.subtitleValue.text = "--"
            } else {
                orders.subtitleValue.text = time
            }
            orders.subtitleValue1.text = sheetData[sheetDataKeys.stopCountValue.rawValue] ?? "0"
            
        }
        if indexPath.row == 1
        {
            orders.subtitleLabel.text = "Idle time"
            orders.subtitleLabel1.text = "Moving time"
            orders.subtitleLabel.textColor = UIColor(red: 201/255, green: 172/255, blue: 0/255, alpha: 1)
            orders.subtitleLabel1.textColor = UIColor(red: 48/255, green: 174/255, blue: 159/255, alpha: 1)
            orders.subtitleValue.text = sheetData[sheetDataKeys.idleTimeValue.rawValue] ?? "--"
            orders.subtitleValue1.text = sheetData[sheetDataKeys.movingTimeValue.rawValue] ?? "--"
        }
        if indexPath.row == 2
        {
            orders.subtitleLabel.text = "Max speed"
            orders.subtitleLabel1.text = "Total daily dist."
            orders.subtitleLabel.textColor = UIColor(red: 85/255, green: 156/255, blue: 244/255, alpha: 1)
            orders.subtitleLabel1.textColor = UIColor(red: 85/255, green: 156/255, blue: 244/255, alpha: 1)
            orders.subtitleValue.text = sheetData[sheetDataKeys.maxSpeedValue.rawValue] ?? "0kmph"
            orders.subtitleValue1.text = sheetData[sheetDataKeys.totalDistValue.rawValue] ?? "0km"
        }
        return orders
    }
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        self.pageControl.currentPage = indexPath.row
    //    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let value:Double = (Double(scrollView.contentOffset.x) / Double(scrollView.frame.width)).rounded(toPlaces: 0)
        pageControl.currentPage = Int(value)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BottomViewCollectionViewCell
        if (indexPath.row == 2) {
            let text:String = cell.subtitleLabel.text ?? "Max speed"
            if (text.lowercased().contains("max")) {
                cell.subtitleLabel.text = "Avg Speed"
                cell.subtitleValue.text = sheetData[sheetDataKeys.avgSpeedValue.rawValue] ?? "0kmph"
            } else {
                cell.subtitleLabel.text = "Max Speed"
                cell.subtitleValue.text = sheetData[sheetDataKeys.maxSpeedValue.rawValue] ?? "0kmph"
            }
        }
    }
    
}
extension String {
    func removing(charactersOf string: String) -> String {
        let characterSet = CharacterSet(charactersIn: string)
        let components = self.components(separatedBy: characterSet)
        return components.joined(separator: "")
    }
}
extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
extension Date {
    
    static func daysBetween(start: Date, end: Date) -> Int {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start)
        let date2 = calendar.startOfDay(for: end)
        
        let a = calendar.dateComponents([.day], from: date1, to: date2)
        return a.value(for: .day)!
        
    }
    
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

class MapClusterIconGenerator: GMUDefaultClusterIconGenerator {
    
    override func icon(forSize size: UInt) -> UIImage {
        let image = textToImage(drawText: String(size) as NSString,
                                inImage: UIImage(named: "ic_cluster_main")!.resizedImage(CGSize(width: 40, height: 40), interpolationQuality: .default),
                                font: UIFont.systemFont(ofSize: 12))
        return image
    }
    
    private func textToImage(drawText text: NSString, inImage image: UIImage, font: UIFont) -> UIImage {
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = UIColor.white
        let attributes=[
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: textStyle,
            NSAttributedStringKey.foregroundColor: textColor]
        
        // vertically center (depending on font)
        let textH = font.lineHeight
        let textY = (image.size.height-textH)/2
        let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textH)
        text.draw(in: textRect.integral, withAttributes: attributes)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

public extension CLLocation{

    func DegreesToRadians(_ degrees: Double ) -> Double {
        return degrees * M_PI / 180
    }

    func RadiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / M_PI
    }


    func bearingToLocationRadian(_ destinationLocation:CLLocation) -> Double {

        let lat1 = DegreesToRadians(self.coordinate.latitude)
        let lon1 = DegreesToRadians(self.coordinate.longitude)

        let lat2 = DegreesToRadians(destinationLocation.coordinate.latitude);
        let lon2 = DegreesToRadians(destinationLocation.coordinate.longitude);

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
        let radiansBearing = atan2(y, x)

        return radiansBearing
    }

    func bearingToLocationDegrees(destinationLocation:CLLocation) -> Double{
        return   RadiansToDegrees(bearingToLocationRadian(destinationLocation))
    }
}

extension MapsViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let coordinate:CLLocationCoordinate2D = place.coordinate
        let marker = GMSMarker(position: coordinate)
        marker.title = "Destination"
        marker.appearAnimation = .pop
        marker.icon = UIImage(named: "ic_flag")!.resizedImage(CGSize.init(width:  40, height:  21), interpolationQuality: .default)
        marker.isFlat = true
        destinationMarker = marker
        destinationMarker?.map = RCMapView.mapView
        fitMap()
        if selectedDeviceId != 0 {
            let keyValue:String = "Position_\(selectedDeviceId)"
            if let position = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValue)) {
                getDestPath(position,coordinate)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func getDestPath(_ position:TrackerPositionMapperModel,_ dest:CLLocationCoordinate2D) {
        let origin:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: position.latitude ?? 0.0, longitude: position.longitude ?? 0.0)
        RCLocalAPIManager.shared.getPathBtwnPoints(point1: dest, point2: origin, success: { array in
            let path = GMSMutablePath()
            var pathArray:[CLLocationCoordinate2D] = []
            for item in array {
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: item[1], longitude: item[0])
                pathArray.append(coordinate)
                path.add(coordinate)
            }
            if isPathButtonTapped || isDailyButtonTapped {
                polyLine = GMSPolyline(path: path)
                polyLine?.strokeColor = .black
                polyLine?.strokeWidth = 2
                polyLine?.map = RCMapView.mapView
                
            } else {
                isTrailing = true
                
                let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: position.latitude ?? 0.0, longitude: position.longitude ?? 0.0)
                trailingLocationDict[position.deviceId ?? 0] = pathArray
                self.drawTrailPolylineOnMap(deviceId: position.deviceId ?? 0,coordinate: location)
            }
            
            var bounds:GMSCoordinateBounds = GMSCoordinateBounds(path: path)
            let updateCamera = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(75, 75, 75, 75))
            RCMapView.mapView.animate(with: updateCamera)
                
            
        }, failure: { error in
            
        })
    }
    
}

//
//  LoadUnloadView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import GoogleMaps

class LoadUnloadViewController : UIViewController {
    
    var loadUnloadView:LoadUnloadView!
    var loadingType:Int = LoadingType.load.rawValue
    var deviceId:Int = 0
    var deviceName:String = ""
    var imagePicker:UIImagePickerController!
    var loadUnloadImage:UIImage?
    var progress: MBProgressHUD?
    let manager = CLLocationManager()
    var userLocation:CLLocation? = nil
    var imageName:String = ""
    var timer: Timer!
    var counterTime: Double = 0
    var titleNaviagtionBar:String?
    var isLocationReceived:Bool = false
    @objc func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceId = Defaults().get(for: Key<Int>(defaultKeyNames.currentLoadingDeviceId.rawValue)) ?? 0
        deviceName = Defaults().get(for: Key<String>(defaultKeyNames.currentLoadingDeviceName.rawValue)) ?? "N/A"
        setupViews()
        setNavigation()
        setConstraints()
        setActions()
        
        handleOldLoadingData()
        
        handleRunningTimer()
        
        enableDisableRadioButtons()
        
    }
    
    func handleOldLoadingData() {
        let loadUnloadId:String = RCGlobals.getLastLoadUnloadForToday(deviceId: "\(deviceId)")
        
        if loadUnloadId != "" {
            let loadUnloadList:[LoadUnloadPojo] = Defaults().get(for: Key<[LoadUnloadPojo]>(defaultKeyNames.savedLoadUnloadData.rawValue)) ?? []
            
            let loadUnloadData = loadUnloadList.filter {( $0.uniqueId == loadUnloadId )}.first
            
            if let data = loadUnloadData {
                var type = "Loading"
                if data.loadingType == "\(LoadingType.unload.rawValue)" {
                    type = "Unloading"
                }
                loadUnloadView.typeText.text = type
                loadUnloadView.startTimeText.text = RCGlobals.convertUTCToIST(data.startTimestamp ?? "", "yyyy-MM-dd HH:mm:ss", "HH:mm:ss")
                loadUnloadView.endTimeText.text = RCGlobals.convertUTCToIST(data.endTimestamp ?? "", "yyyy-MM-dd HH:mm:ss", "HH:mm:ss")
                let timeTakenValue:Double = Double(data.timeTaken ?? "0") ?? 0
                var timetaken:Int64 = Int64(timeTakenValue / 1000)
                let hours:Int = Int(timetaken / 3600)
                timetaken = Int64(timetaken - Int64(hours * 3600))
                let minutes:Int = Int(timetaken / 60)
                timetaken = Int64(timetaken - Int64(minutes * 60))
                let seconds:Int = Int(timetaken)
                
                let hrString = (hours < 10 ? "0":"") + "\(hours)"
                let minString = (minutes < 10 ? "0":"") + "\(minutes)"
                let secString = (seconds < 10 ? "0":"") + "\(seconds)"
                
                loadUnloadView.totalTimeText.text = "\(hrString):\(minString):\(secString)"
            }
        } else {
            print("do not show top view")
        }
    }
    
    func handleRunningTimer() {
        let isTimerRunning = Defaults().get(for: Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue)) ?? false
        if isTimerRunning {
            updateTime()
            loadingType = Defaults().get(for: Key<Int>(defaultKeyNames.loadUnloadType.rawValue)) ?? LoadingType.load.rawValue
            if loadingType == LoadingType.unload.rawValue {
                loadUnloadView.unloadRadioBtn.isSelected = true
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            let loadStartTime = Defaults().get(for: Key<Double>(defaultKeyNames.loadUnloadStartTime.rawValue)) ?? 0
            let date = Date(timeIntervalSince1970: loadStartTime / 1000)
            loadUnloadView.sTimeValue.text = RCGlobals.convertDateToString(date: date, format: "HH:mm:ss", toUTC: false)
            loadUnloadView.startTimeBtn.setTitle("Stop Timer", for: .normal)
        }
    }
    
    func enableDisableRadioButtons() {
        if let isTimerRunning = Defaults().get(for: Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue)) {
            if isTimerRunning {
                loadUnloadView.loadRadioBtn.isEnabled = false
                loadUnloadView.unloadRadioBtn.isEnabled = false
            } else {
                loadUnloadView.loadRadioBtn.isEnabled = true
                loadUnloadView.unloadRadioBtn.isEnabled = true
            }
        } else {
            loadUnloadView.loadRadioBtn.isEnabled = true
            loadUnloadView.unloadRadioBtn.isEnabled = true
        }
    }
    
    func setupViews()
    {
        loadUnloadView = LoadUnloadView()
        loadUnloadView.backgroundColor = appDarkTheme
        view.addSubview(loadUnloadView)
    }
    
    func setNavigation(){
        self.navigationItem.title = "(\(self.deviceName))"
        self.navigationController?.navigationBar.tintColor = appGreenTheme
    }
    func setConstraints(){
        loadUnloadView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
        }
    }
    func setActions(){
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        loadUnloadView.startTimeBtn.addTarget(self, action: #selector(startTimerTapped), for: .touchUpInside)
        loadUnloadView.loadRadioBtn.addTarget(self, action: #selector(loadUnloadTapped), for: .touchUpInside)
        loadUnloadView.unloadRadioBtn.addTarget(self, action: #selector(loadUnloadTapped), for: .touchUpInside)
    }
    
    @objc func loadUnloadTapped() {
        loadUnloadView.loadRadioBtn.isSelected = !loadUnloadView.loadRadioBtn.isSelected
        loadUnloadView.unloadRadioBtn.isSelected = !loadUnloadView.unloadRadioBtn.isSelected
        
        if loadUnloadView.unloadRadioBtn.isSelected {
            loadingType = LoadingType.unload.rawValue
        } else {
            loadingType = LoadingType.load.rawValue
        }
    }
    
    @objc func startTimerTapped () {
        isLocationReceived = false
        if loadUnloadView.unloadRadioBtn.isSelected {
            loadingType = LoadingType.unload.rawValue
        }
        if loadUnloadView.startTimeBtn.title(for: .normal) == "OK" {
            backTapped()
        } else {
            selectImage()
        }
    }
    
    @objc func updateTime () {
        let loadStartTime = Defaults().get(for: Key<Double>(defaultKeyNames.loadUnloadStartTime.rawValue)) ?? 0
        let currentTime = RCGlobals.getCurrentMillis()
        counterTime = currentTime - loadStartTime
        let date = Date(timeIntervalSince1970: counterTime / 1000)
        loadUnloadView.timerLabel.text = RCGlobals.convertDateToString(date: date, format: "HH:mm:ss", toUTC: true)
    }
    
    func showProgress(message:String) {
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = "".toLocalize
    }
    
    func hideProgress() {
        progress?.hide(true)
    }
    
}

extension LoadUnloadViewController {
    func selectImage() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.cameraDevice = .rear
        imagePicker.cameraCaptureMode = .photo
        imagePicker.showsCameraControls = true
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showTimerDialog () {
        
        let isTimerStarted:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue)) ?? false
        var title:String = "Start"
        
        if isTimerStarted {
            title = "Stop"
        }
        
        let alertController = UIAlertController(title: title.toLocalize, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: { alert -> Void in
            self.showProgress(message: "Fetching Location, Please wait...")
            self.manager.requestLocation()
        })
        
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        let editAction = UIAlertAction(title: "Edit", style: .destructive, handler: { alert -> Void in
            self.selectImage()
        })
        alertController.addAction(editAction)
        
        let imageView = UIImageView(frame: CGRect(x: 100, y: 50, width: 100, height: 100))
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = self.loadUnloadImage
        
        alertController.view.snp.makeConstraints{(make) in
            make.width.height.equalTo(300)
        }
        
        alertController.view.addSubview(imageView)
        present(alertController, animated: true, completion: nil)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        let currentSeconds = RCGlobals.getCurrentMillis()
        Defaults().set(currentSeconds, for: Key<Double>(defaultKeyNames.loadUnloadStartTime.rawValue))
        Defaults().set(true, for: Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue))
        Defaults().set(loadingType, for: Key<Int>(defaultKeyNames.loadUnloadType.rawValue))
        
        let startDate = Date(timeIntervalSince1970: currentSeconds / 1000)
        
        let loadUnloadData = LoadUnloadPojo()
        
        let uniqueId:String = UUID.init().uuidString
        
        Defaults().set(uniqueId, for: Key<String>(defaultKeyNames.currentLoadingId.rawValue))
        
        loadUnloadData.uniqueId = uniqueId
        loadUnloadData.deviceId = "\(deviceId)"
        loadUnloadData.startTimestamp = RCGlobals.convertDateToString(date: startDate, format: "yyyy-MM-dd HH:mm:ss", toUTC: true)
        loadUnloadData.startImg = self.imageName
        if let image = self.loadUnloadImage {
            loadUnloadData.startImgData = compressImage(image: image)
        }
        loadUnloadData.startLat = "\(userLocation?.coordinate.latitude ?? 0)"
        loadUnloadData.startLng = "\(userLocation?.coordinate.longitude ?? 0)"
        loadUnloadData.loadingType = "\(loadingType)"
        
        var loadUnloadArray: [LoadUnloadPojo] = Defaults().get(for: Key<[LoadUnloadPojo]>(defaultKeyNames.savedLoadUnloadData.rawValue)) ?? []
        
        loadUnloadArray.append(loadUnloadData)
        
        Defaults().set(loadUnloadArray, for: Key<[LoadUnloadPojo]>(defaultKeyNames.savedLoadUnloadData.rawValue))
        
        loadUnloadView.sTimeValue.text = RCGlobals.formatCurrentDate(format: "HH:mm:ss")
        loadUnloadView.startTimeBtn.setTitle("Stop Timer", for: .normal)
        enableDisableRadioButtons()
    }
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
        }
        let startTime:Double = Defaults().get(for: Key<Double>(defaultKeyNames.loadUnloadStartTime.rawValue)) ?? 0
        let endTimeMillis = startTime + counterTime
        let date = Date(timeIntervalSince1970: endTimeMillis / 1000)
        loadUnloadView.eTimeValue.text = RCGlobals.convertDateToString(date: date, format: "HH:mm:ss", toUTC: false)
        
        loadUnloadView.tTimeValue.text = loadUnloadView.timerLabel.text
        
        let currentLoadingId = Defaults().get(for: Key<String>(defaultKeyNames.currentLoadingId.rawValue))
        
        var loadUnloadArray: [LoadUnloadPojo] = Defaults().get(for: Key<[LoadUnloadPojo]>(defaultKeyNames.savedLoadUnloadData.rawValue)) ?? []
        
        let currentLoadData = loadUnloadArray.filter {( $0.uniqueId == currentLoadingId )}.first
        
        if let data = currentLoadData {
            loadUnloadArray = loadUnloadArray.filter {( $0.uniqueId != data.uniqueId)}
            data.endTimestamp = RCGlobals.convertDateToString(date: date, format: "yyyy-MM-dd HH:mm:ss", toUTC: true)
            data.endImg = self.imageName
            if let image = self.loadUnloadImage {
                data.endImgData = compressImage(image: image)
            }
            data.endLat = "\(userLocation?.coordinate.latitude ?? 0)"
            data.endLng = "\(userLocation?.coordinate.longitude ?? 0)"
            data.timeTaken = "\(Int64(counterTime))"
            loadUnloadArray.append(data)
            sendLoadUnload(data: data)
        }
        
        Defaults().set(loadUnloadArray, for: Key<[LoadUnloadPojo]>(defaultKeyNames.savedLoadUnloadData.rawValue))
        
        Defaults().clear(Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue))
        Defaults().clear(Key<Int>(defaultKeyNames.loadUnloadType.rawValue))
        Defaults().clear(Key<Double>(defaultKeyNames.loadUnloadStartTime.rawValue))
        Defaults().clear(Key<Int>(defaultKeyNames.currentLoadingDeviceId.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.currentLoadingDeviceName.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.currentLoadingId.rawValue))
        loadUnloadView.startTimeBtn.setTitle("OK", for: .normal)
        
        enableDisableRadioButtons()
    }
    
    func sendLoadUnload(data: LoadUnloadPojo) {
        let parameters:[String:Any] = ["unique_id":data.uniqueId, "device_id":data.deviceId,
                                       "start_timestamp":data.startTimestamp ?? "", "start_lat":data.startLat ?? "0",
                                       "start_lng":data.startLng ?? "0", "start_img":data.startImg ?? "",
                                       "end_timestamp":data.endTimestamp ?? "", "end_lat": data.endLat ?? "0",
                                       "end_lng": data.endLng ?? "0", "end_img":data.endImg ?? "",
                                       "time_taken": data.timeTaken ?? "0", "loading_type": data.loadingType ?? "1"]
        RCLocalAPIManager.shared.sendLoadUnloadData(with: parameters, success:  { hash in
            self.uploadFile(data:data)
        }) { message in
            UIApplication.shared.keyWindow?.makeToast("Request failed, Please try again.", duration: 1.0, position: .bottom)
        }
    }
    
    func uploadFile (data: LoadUnloadPojo) {
        uploadLoadUnloadImages(loadUnloadData: data, onCompletion: { message in
            if message == "Success" {
                UIApplication.shared.keyWindow?.makeToast("Data uploaded successfully.", duration: 1.0, position: .bottom)
            }
        }) { error in
            UIApplication.shared.keyWindow?.makeToast("Request failed, Please try again.", duration: 1.0, position: .bottom)
        }
    }
}

extension LoadUnloadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromImagePicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            self.loadUnloadImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
        self.showTimerDialog()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension LoadUnloadViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location = locations.first {
            if !self.isLocationReceived {
                self.isLocationReceived = true
                print("Found user's location: \(location)")
                self.userLocation = location
                self.hideProgress()
                let isTimerStarted:Bool = Defaults().get(for: Key<Bool>(defaultKeyNames.isLoadUnloadTimerRunning.rawValue)) ?? false
                let time = RCGlobals.formatCurrentDate(format: "yyyyMMdd_HHmm")
                if isTimerStarted {
                    if loadingType == LoadingType.load.rawValue {
                        imageName = "\(ImagePrefix.loadStopPrefix.rawValue)\(deviceId)_\(time).jpg"
                    } else {
                        imageName = "\(ImagePrefix.unloadStopPrefix.rawValue)\(deviceId)_\(time).jpg"
                    }
                    self.stopTimer()
                } else {
                    if loadingType == LoadingType.load.rawValue {
                        imageName = "\(ImagePrefix.loadStartPrefix.rawValue)\(deviceId)_\(time).jpg"
                    } else {
                        imageName = "\(ImagePrefix.unloadStartPrefix.rawValue)\(deviceId)_\(time).jpg"
                    }
                    self.startTimer()
                }
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


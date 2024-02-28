//
//  FAQView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import UIKit
import DefaultsKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper


class ParkingModeScheduleView : UIViewController{
    var scheduleView:ParkingScheduleView!
    var schedule : Bool?


    var daysSelected : [String] = []
    var park : DataClass?
    var status = "No value"
    var isSundayOn = true
    var isMondayOn = true
    var isTuesDayOn = true
    var isWednesdayOn = true
    var isThursdayOn = true
    var isFridayOn = true
    var isSaturdayOn = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        parking(deviceID: globalPark)
        
        setViews()
        setupConstraints()
        setActions()
        
        toolBarSetup()
        daysSelector()
    }
    func setViews(){
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.title = globalParkName
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        
        scheduleView = ParkingScheduleView()
        view.addSubview(scheduleView)
        
    }
    func setActions(){
        scheduleView.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        scheduleView.resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
        
        scheduleView.startTime.addTarget(self, action: #selector(startTimeChanged), for: .editingChanged)
        scheduleView.endTime.addTarget(self, action: #selector(endTimeChanged), for: .editingChanged)
        
        scheduleView.parkingModeToggle.addTarget(self, action: #selector(parkingModeToggleTapped(_: )), for: .allTouchEvents)
        
        if ((park?.parking_mode) != nil) {
            status = "ON"
            scheduleView.parkingModeToggle.setOn(true, animated: true)
            Defaults().set(true, for: Key<Bool> ("\(globalPark)"))
        } else {
            status = "OFF"
            scheduleView.parkingModeToggle.setOn(false, animated: true)
            Defaults().set(false, for: Key<Bool> ("\(globalPark)"))
        }
        
        
        if park?.parking_schedule_start_utc != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            var ddate = Date()
            _ = park?.parking_schedule_start_utc
            ddate = dateFormatter.date(from: (park?.parking_schedule_start_utc)!) ?? Date()
            dateFormatter.timeZone = TimeZone.current
            let gmt = dateFormatter.string(from: ddate)
            scheduleView.startTime.text = gmt//dateFormatter.string(from: ddate)
            
            
        } else {
            scheduleView.startTime.text = "00:00:00"
        }
        
        if park?.parking_schedule_end_utc != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            var ddate = Date()
            ddate = dateFormatter.date(from: park?.parking_schedule_end_utc ?? "00:00:00") ?? Date()
            dateFormatter.timeZone = TimeZone.current
            let gmt = dateFormatter.string(from: ddate)
            scheduleView.endTime.text = gmt
        } else {
            scheduleView.endTime.text = "00:00:00"
        }
        if let days = park?.parking_schedule_days{
            daysSelected = days
        }
    }
    
    func setupConstraints() {
        scheduleView.snp.makeConstraints{ (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    func parking(deviceID: Int) {
        let parkingScheduleData = Defaults().get(for: Key<[DataClass]>("parkingScheduler")) ?? []
        
        park = parkingScheduleData.filter {( $0.device_id == deviceID )}.first
        
    }
    
}
extension ParkingModeScheduleView {
    
    func daysSelector() {
        
        let SundayGesture = UITapGestureRecognizer(target: self, action: #selector(sudaysChecker(_:)) )
        SundayGesture.numberOfTapsRequired = 1
        scheduleView.sunday.addGestureRecognizer(SundayGesture)
        scheduleView.sunday.isUserInteractionEnabled = true
        
        let MondayGesture = UITapGestureRecognizer(target: self, action: #selector(modaysChecker(_:)))
        MondayGesture.numberOfTapsRequired = 1
        scheduleView.monday.addGestureRecognizer(MondayGesture)
        scheduleView.monday.isUserInteractionEnabled = true
        
        let tuesdayGesture = UITapGestureRecognizer(target: self, action:   #selector(tudaysChecker(_:)))
        tuesdayGesture.numberOfTapsRequired = 1
        scheduleView.tuesday.addGestureRecognizer(tuesdayGesture)
        scheduleView.tuesday.isUserInteractionEnabled = true
        
        let wednesdayGesture = UITapGestureRecognizer(target: self, action: #selector(wedaysChecker(_:)))
        wednesdayGesture.numberOfTapsRequired = 1
        scheduleView.wednesday.addGestureRecognizer(wednesdayGesture)
        scheduleView.wednesday.isUserInteractionEnabled = true
        
        let thursdayGesture = UITapGestureRecognizer(target: self, action: #selector(thdaysChecker(_:)))
        thursdayGesture.numberOfTapsRequired = 1
        scheduleView.thursday.addGestureRecognizer(thursdayGesture)
        scheduleView.thursday.isUserInteractionEnabled = true
        
        let fridayGesture = UITapGestureRecognizer(target: self, action: #selector(frdaysChecker(_:)))
        fridayGesture.numberOfTapsRequired = 1
        scheduleView.friday.addGestureRecognizer(fridayGesture)
        scheduleView.friday.isUserInteractionEnabled = true
        
        let saturdayGesture = UITapGestureRecognizer(target: self, action: #selector(sadaysChecker(_:)))
        saturdayGesture.numberOfTapsRequired = 1
        scheduleView.saturday.addGestureRecognizer(saturdayGesture)
        scheduleView.saturday.isUserInteractionEnabled = true
        
        
        for day in daysSelected {
            
            if day == "Sunday" {
                scheduleView.sunday.layer.borderColor = appGreenTheme.cgColor
            }
            
            if day == "Monday" {
                scheduleView.monday.layer.borderColor = UIColor.white.cgColor
            }
            
            if day == "Tuesday" {
                scheduleView.tuesday.layer.borderColor = UIColor.white.cgColor
            }
            
            if day == "Wednesday" {
                scheduleView.wednesday.layer.borderColor = UIColor.white.cgColor
            }
            
            if day == "Thursday" {
                scheduleView.thursday.layer.borderColor = UIColor.white.cgColor
            }
            
            if day == "Friday" {
                scheduleView.friday.layer.borderColor = UIColor.white.cgColor
            }
            
            if day == "Saturday" {
                scheduleView.saturday.layer.borderColor = UIColor.white.cgColor
            }
        }
        
    }
    
    @objc func saveButtonTapped(_ sender: Any) {
        scheduleView.saveButton.isEnabled = false
        scheduleView.saveButton.setTitleColor(.gray, for: .normal)
        print("save tapped")
        
        updateSchedule()
        
    }
    func updateSchedule(){
        
        var startDateString:String = scheduleView.startTime.text ?? "00:00:00"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH:mm:ss"
        var ddate = Date()
        ddate = dateFormatter.date(from: scheduleView.startTime.text!)!
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let gmt = dateFormatter.string(from: ddate)
        startDateString = gmt
        
        var endDateString:String = scheduleView.endTime.text ?? "00:00:00"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.dateFormat = "HH:mm:ss"
        var ddate2 = Date()
        ddate2 = dateFormatter2.date(from:scheduleView.endTime.text!)!
        dateFormatter2.timeZone = TimeZone(abbreviation: "UTC")
        let gmt2 = dateFormatter2.string(from: ddate2)
        endDateString = gmt2
        
        if scheduleView.parkingModeToggle.isOn {
            schedule = true
        }
        RCLocalAPIManager.shared.putParkingSchedule(deviceID: globalPark, isSchedulerOn: schedule ?? false, days: daysSelected, start_time: startDateString, end_time: endDateString, success:  { [weak self]hash in
            guard let weakself = self else { return }
            weakself.view.setNeedsDisplay()
            weakself.view.makeToast("Scheduler Successfully Saved")
            weakself.getParticularDeviceData()
            
            
        }) { [weak self] message in
            guard let weakself = self else { return }
            print(message)
            weakself.view.makeToast("Please try again later")
        }
    }
    @objc func parkingModeToggleTapped(_ sender: Any) {
        scheduleView.saveButton.isEnabled = true
        scheduleView.saveButton.setTitleColor( .white , for: .normal)
        
        if scheduleView.parkingModeToggle.isOn {
            schedule = true
            updateSchedule()
        }
        
        if scheduleView.parkingModeToggle.isOn == false {
            schedule = false
            updateSchedule()
            
        }
    }
    
    @objc func endTimeChanged(_ sender: Any) {
        scheduleView.saveButton.isEnabled = true
        scheduleView.saveButton.setTitleColor( .white , for: .normal)
    }
    
    @objc func startTimeChanged(_ sender: Any) {
        scheduleView.saveButton.isEnabled = true
        scheduleView.saveButton.setTitleColor( .white , for: .normal)
    }
    
    @objc func resetButtonTapped(_ sender: Any) {
        scheduleView.endTime.text = "00:00"
        scheduleView.startTime.text = "00:00"
        daysSelected.removeAll()
        scheduleView.sunday.layer.borderColor = appDarkTheme.cgColor
        scheduleView.monday.layer.borderColor = appDarkTheme.cgColor
        scheduleView.tuesday.layer.borderColor = appDarkTheme.cgColor
        scheduleView.wednesday.layer.borderColor = appDarkTheme.cgColor
        scheduleView.thursday.layer.borderColor = appDarkTheme.cgColor
        scheduleView.friday.layer.borderColor = appDarkTheme.cgColor
        scheduleView.saturday.layer.borderColor = appDarkTheme.cgColor
        daysSelector()
        print("save tapped")
        RCLocalAPIManager.shared.putParkingSchedule(deviceID: globalPark, isSchedulerOn: false, days: [""], start_time:  "18:30", end_time: "18:30", success:  { [weak self]hash in
            guard let weakself = self else { return }
            weakself.view.setNeedsDisplay()
            weakself.view.makeToast("Scheduler Successfully Saved")
            weakself.getParticularDeviceData()
            
        }) { [weak self] message in
            guard let weakself = self else { return }
            print(message)
            weakself.view.makeToast("Please try again later")
        }
        
    }
    
    fileprivate func getParticularDeviceData() {
        RCLocalAPIManager.shared.getParkingSchedule(deviceID: globalPark,loadingMessage: "Please wait...", success: { (park) in
            let eventsData: [DataClass] = park.data!
            var parkingScheduleData = Defaults().get(for: Key<[DataClass]>("parkingScheduler")) ?? []
            parkingScheduleData = parkingScheduleData.filter {( $0.device_id != globalPark )}
            parkingScheduleData.append(eventsData.first!)
            Defaults().set(parkingScheduleData, for: Key<[DataClass]>("parkingScheduler"))
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt(message)
        }
    }
    
    @objc func sudaysChecker(_ sender: Any) {
        
        if daysSelected.contains("Sunday") {
            scheduleView.sunday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Sunday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.sunday.layer.borderColor = appGreenTheme.cgColor
            daysSelected.append("Sunday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    @objc func modaysChecker(_ sender: Any) {
        
        
        if daysSelected.contains("Monday") {
            scheduleView.monday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Monday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.monday.layer.borderColor = UIColor.white.cgColor
            daysSelected.append("Monday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    @objc func tudaysChecker(_ sender: Any) {
        
        
        if daysSelected.contains("Tuesday") {
            scheduleView.tuesday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Tuesday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.tuesday.layer.borderColor = UIColor.white.cgColor
            daysSelected.append("Tuesday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    @objc func wedaysChecker(_ sender: Any) {
        
        
        if daysSelected.contains("Wednesday") {
            scheduleView.wednesday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Wednesday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.wednesday.layer.borderColor = UIColor.white.cgColor
            daysSelected.append("Wednesday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    @objc func thdaysChecker(_ sender: Any) {
        
        if daysSelected.contains("Thursday") {
            scheduleView.thursday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Thursday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.thursday.layer.borderColor = UIColor.white.cgColor
            daysSelected.append("Thursday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    @objc func frdaysChecker(_ sender: Any) {
        
        
        if daysSelected.contains("Friday") {
            scheduleView.friday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Friday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.friday.layer.borderColor = UIColor.white.cgColor
            daysSelected.append("Friday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    @objc func sadaysChecker(_ sender: Any) {
        
        if daysSelected.contains("Saturday") {
            scheduleView.saturday.layer.borderColor = appDarkTheme.cgColor
            daysSelected.removeObject(obj: "Saturday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }
            
        else {
            scheduleView.saturday.layer.borderColor = UIColor.white.cgColor
            daysSelected.append("Saturday")
            scheduleView.saveButton.isEnabled = true
            scheduleView.saveButton.setTitleColor( .white , for: .normal)
        }}
    
    func toolBarSetup() {
        scheduleView.toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTimePicker))
        scheduleView.toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
        
        scheduleView.toolbar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker2))
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTimePicker))
        scheduleView.toolbar2.setItems([doneButton2,spaceButton2,cancelButton2], animated: true)
    }
    
    @objc func doneTimePicker2(_ sender : Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        scheduleView.endTime.text = dateFormatter.string(from: scheduleView.endTimePicker.date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        print(scheduleView.endTime.text as Any)
        scheduleView.endTime.endEditing(true)
        scheduleView.saveButton.isEnabled = true
        scheduleView.saveButton.setTitleColor( .white , for: .normal)
        
    }
    
    @objc func doneTimePicker(_ sender : Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        scheduleView.startTime.text = dateFormatter.string(from: scheduleView.startTimePicker.date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        print(scheduleView.startTime.text!)
        scheduleView.startTime.endEditing(true)
        scheduleView.saveButton.isEnabled = true
        scheduleView.saveButton.setTitleColor( .white , for: .normal)
    }
    
    @objc func cancelTimePicker(_ sender: Any) {
        scheduleView.endTime.endEditing(true)
        scheduleView.startTime.endEditing(true)
    }
    
    @objc func backTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
        
    }
}

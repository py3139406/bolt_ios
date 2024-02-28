//
//  ParkingScheduleView.swift
//  Bolt
//
//  Created by Roadcast on 18/01/21.
//  Copyright © 2021 Arshad Ali. All rights reserved.
//
import UIKit

class ParkingScheduleView: UIView {
    
    var parkingModeToggle = UISwitch()
    var toggleButton = UISwitch()
    var resetButton = UIButton()
    var saveButton = UIButton()
    var isSchedulerOn = UILabel()
    let parkingStatusLabel = UILabel()
    var startTime = UITextField()
    var startTimePicker = UIDatePicker()
    var endTime = UITextField()
    var endTimePicker = UIDatePicker()
    let toolbar = UIToolbar()
    let toolbar2 = UIToolbar()
    var startLabel = UILabel()
    var endLabel = UILabel()
    var backGround = UIView()
    var sunday = UILabel()
    var monday = UILabel()
    var tuesday = UILabel()
    var wednesday = UILabel()
    var thursday = UILabel()
    var friday = UILabel()
    var saturday = UILabel()
    var parkingModeInfo = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addViews(){
        
        parkingModeInfo.text = "The Parking Mode Scheduler will automatically activate the parking mode on the selected days of the week and between the selected time interval. We recommend using the scheduler at night for added security."
        parkingModeInfo.textColor = .white
        parkingModeInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
        parkingModeInfo.numberOfLines = 7
        // parkingModeInfo.adjustsFontSizeToFitWidth = true
        parkingModeInfo.font = UIFont.systemFont(ofSize: 13)
        
        parkingModeToggle.contentMode = .scaleToFill
        
        parkingStatusLabel.textColor = .white
        parkingStatusLabel.textAlignment = .left
        parkingStatusLabel.text = "Parking Mode Scheduler"
        parkingStatusLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        backGround.backgroundColor = appDarkTheme
        
        endTime.textAlignment = .center
        endTime.layer.cornerRadius = 5
        endTime.layer.masksToBounds = true
        endTime.backgroundColor = UIColor(red: 221/255, green: 217/255, blue: 217/255, alpha:1)
        endTime.inputView = endTimePicker
        endTime.inputAccessoryView = toolbar2
        endTimePicker.datePickerMode = .time
        endTime.textColor = .black
        
        endTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        startTimePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        if #available(iOS 13.4, *) {
            endTimePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            startTimePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            endTimePicker.tintColor = .black
            endTimePicker.backgroundColor = .white
            startTimePicker.tintColor = .black
            startTimePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        
        startTime.textAlignment = .center
        startTime.layer.cornerRadius = 5
        startTime.layer.masksToBounds = true
        startTime.backgroundColor = UIColor(red: 221/255, green: 217/255, blue: 217/255, alpha:1)
        startTime.inputView = startTimePicker
        startTime.inputAccessoryView = toolbar
        startTimePicker.datePickerMode = .time
        startTime.textColor = .black
        
        startLabel.text = "START TIME"
        startLabel.font = UIFont.boldSystemFont(ofSize: 16)
        startLabel.textColor = .black
        startLabel.textAlignment = .center
        
        
        endLabel.text = "END TIME"
        endLabel.textColor = .black
        endLabel.font = UIFont.boldSystemFont(ofSize: 16)
        endLabel.textAlignment = .center
        
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor( .gray , for: .normal)
        saveButton.titleLabel?.textAlignment = .center
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        saveButton.layer.borderColor = appGreenTheme.cgColor
        saveButton.layer.borderWidth = 5
        saveButton.layer.cornerRadius = 15
        saveButton.backgroundColor = appGreenTheme
        saveButton.isEnabled = false
        
        
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.setTitle("RESET", for: .normal)
        resetButton.titleLabel?.textAlignment = .center
        resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        resetButton.layer.borderColor = appGreenTheme.cgColor
        resetButton.layer.borderWidth = 5
        resetButton.layer.cornerRadius = 15
        resetButton.backgroundColor = appGreenTheme
        
        
        sunday.text = "S"
        sunday.textColor = appGreenTheme
        sunday.layer.borderColor = appDarkTheme.cgColor
        sunday.layer.borderWidth = 3
        sunday.layer.cornerRadius = 20
        sunday.textAlignment = .center
        
        monday.text = "M"
        monday.textColor = .white
        monday.layer.borderColor = appDarkTheme.cgColor
        monday.layer.borderWidth = 3
        monday.layer.cornerRadius = 20
        monday.textAlignment = .center
        
        tuesday.text = "T"
        tuesday.textColor = .white
        tuesday.layer.borderColor = appDarkTheme.cgColor
        tuesday.layer.borderWidth = 3
        tuesday.layer.cornerRadius = 20
        tuesday.textAlignment = .center
        
        wednesday.text = "W"
        wednesday.textColor = .white
        wednesday.layer.borderColor = appDarkTheme.cgColor
        wednesday.layer.borderWidth = 3
        wednesday.layer.cornerRadius = 20
        wednesday.textAlignment = .center
        
        thursday.text = "Th"
        thursday.textColor = .white
        thursday.layer.borderColor = appDarkTheme.cgColor
        thursday.layer.borderWidth = 3
        thursday.layer.cornerRadius = 20
        thursday.textAlignment = .center
        
        friday.text = "F"
        friday.textColor = .white
        friday.layer.borderColor = appDarkTheme.cgColor
        friday.layer.borderWidth = 3
        friday.layer.cornerRadius = 20
        friday.textAlignment = .center
        
        saturday.text = "S"
        saturday.textColor = .white
        saturday.layer.borderColor = appDarkTheme.cgColor
        saturday.layer.borderWidth = 3
        saturday.layer.cornerRadius = 20
        saturday.textAlignment = .center
        
        addSubview(backGround)
        backGround.addSubview(parkingModeToggle)
        backGround.addSubview(parkingModeInfo)
        backGround.addSubview(sunday)
        backGround.addSubview(monday)
        backGround.addSubview(tuesday)
        backGround.addSubview(wednesday)
        backGround.addSubview(thursday)
        backGround.addSubview(friday)
        backGround.addSubview(saturday)
        addSubview(startLabel)
        addSubview(startTime)
        addSubview(endLabel)
        addSubview(endTime)
        addSubview(resetButton)
        addSubview(saveButton)
        backGround.addSubview(parkingStatusLabel)
    }
    func setConstraints(){
        backGround.snp.makeConstraints{ (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        parkingStatusLabel.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.top.equalToSuperview().offset(screensize.width * 0.02)
        }
        parkingModeToggle.snp.makeConstraints{ (make) in
            make.top.equalTo(parkingStatusLabel)
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.width.equalTo(50)//Superview().multipliedBy(0.1)
            make.height.equalTo(20) //Superview().multipliedBy(0.03)
        }
        parkingModeInfo.snp.makeConstraints{ (make) in
            // make.left.equalToSuperview().offset(UIScreen.main.bounds.width * 0.01)
            make.centerX.equalToSuperview()//.offset(UIScreen.main.bounds.width * -0.01)
            make.top.equalTo(parkingStatusLabel.snp.bottom).offset(screensize.height * 0.02)
            make.width.equalToSuperview().multipliedBy(0.96)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        sunday.snp.makeConstraints{(make) in
            make.top.equalTo(parkingModeInfo.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        monday.snp.makeConstraints{(make) in
            make.centerY.equalTo(sunday)
            make.left.equalTo(sunday.snp.right).offset(screensize.width * 0.03)
            make.size.equalTo(sunday)
        }
        tuesday.snp.makeConstraints{(make) in
            make.centerY.equalTo(monday)
            make.left.equalTo(monday.snp.right).offset(screensize.width * 0.03)
            make.size.equalTo(sunday)
        }
        wednesday.snp.makeConstraints{(make) in
            make.centerY.equalTo(tuesday)
            make.left.equalTo(tuesday.snp.right).offset(screensize.width * 0.03)
            make.size.equalTo(sunday)
        }
        thursday.snp.makeConstraints{(make) in
            make.centerY.equalTo(wednesday)
            make.left.equalTo(wednesday.snp.right).offset(screensize.width * 0.03)
            make.size.equalTo(sunday)
        }
        friday.snp.makeConstraints{(make) in
            make.centerY.equalTo(thursday)
            make.left.equalTo(thursday.snp.right).offset(screensize.width * 0.03)
            make.size.equalTo(sunday)
        }
        saturday.snp.makeConstraints{(make) in
            make.centerY.equalTo(friday)
            make.left.equalTo(friday.snp.right).offset(screensize.width * 0.03)
            make.size.equalTo(sunday)
        }
        startLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(backGround.snp.bottom).offset(screensize.height * 0.05)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(60)
        }
        startTime.snp.makeConstraints{ (make) in
            make.centerX.equalTo(startLabel)
            make.top.equalTo(startLabel.snp.bottom).offset(screensize.height * 0.05)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(60)
        }
        endLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(backGround.snp.bottom).offset(screensize.height * 0.05)
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(60)
        }
        endTime.snp.makeConstraints{ (make) in
            make.centerX.equalTo(endLabel)
            make.top.equalTo(endLabel.snp.bottom).offset(screensize.height * 0.05)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(60)
        }
        saveButton.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-screensize.height * 0.05)
            make.right.equalToSuperview().offset(-screensize.width * 0.1)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        resetButton.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-screensize.height * 0.05)
            make.left.equalToSuperview().offset(screensize.width * 0.1)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(70)
        }
        
    }
}

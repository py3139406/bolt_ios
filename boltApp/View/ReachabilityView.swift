//
//  ReachabilityView.swift
//  Bolt
//
//  Created by Roadcast on 19/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class ReachabilityView: UIView {
    // properites:
    var selectVehicleTitle:UILabel!
    var selectVehicleTextField:UILabel!
    var vehicleTextIcon:UIButton!
    var destTitle:UILabel!
    var saveBtn:UIButton!
    var newLocation:UILabel!
    var existGeo:UILabel!
    var newLocAddress:UILabel!
    var geofenceAddress:UILabel!
    var radiusField:UITextField!
    var kmLabel:UILabel!
    var mapView:RCMainMap!
    var dateTimeTitle:UILabel!
    var dateTimeField:UILabel!
    var getNotifiedTitle:UILabel!
    var emailIcon:UIImageView!
    var notifIcon:UIImageView!
    var emailLabel:UILabel!
    var notifLabel:UILabel!
    var screenSize = UIScreen.main.bounds.size
    var newLocBtn:RadioButton!
    var existGeoBtn:RadioButton!
    var emailBtn:RadioButton!
    var notifBtn:RadioButton!
    var scrollView:UIScrollView!
    var mapPin = UIImageView(image: UIImage(named: "ic_poi_loc"))
    // selecteVehicle drop down icon
    let imgIcon = UIImageView(image: UIImage(named: "down_arrow"))
    let dropIcon = UIImageView(image: UIImage(named: "down_arrow"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        
    }
    func setViews(){
        scrollView = UIScrollView()
        scrollView.backgroundColor =  .white
        scrollView.bounces = false
        addSubview(scrollView)
        
        selectVehicleTitle = UILabel()
        selectVehicleTitle.textColor = .black
        selectVehicleTitle.text = "Select Vehicle"
        selectVehicleTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        scrollView.addSubview(selectVehicleTitle)
        
        selectVehicleTextField = PaddingLabel()
        selectVehicleTextField.textColor = .black
        selectVehicleTextField.text = "Vehicle"
        selectVehicleTextField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        selectVehicleTextField.isUserInteractionEnabled = true
        selectVehicleTextField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        scrollView.addSubview(selectVehicleTextField)
        selectVehicleTextField.addSubview(dropIcon)
        
        destTitle = UILabel()
        destTitle.textColor = .black
        destTitle.text = "Destination"
        destTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        scrollView.addSubview(destTitle)
        
        newLocation = UILabel()
        newLocation.textColor = .black
        newLocation.text = "New Location"
        newLocation.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scrollView.addSubview(newLocation)
        
        existGeo = UILabel()
        existGeo.textColor = .black
        existGeo.text = "Existing Geofence"
        existGeo.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scrollView.addSubview(existGeo)
        
        newLocAddress = PaddingToLabel(withInsets: 0, 0, 10, 10)
        newLocAddress.isHidden = false
        newLocAddress.textColor = .black
        newLocAddress.text = "Search address."
        newLocAddress.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        newLocAddress.adjustsFontSizeToFitWidth = true
        newLocAddress.numberOfLines = 2
        scrollView.addSubview(newLocAddress)
        
        geofenceAddress = PaddingToLabel(withInsets: 5, 5, 10, 10)
        geofenceAddress.isHidden = true
        geofenceAddress.textColor = .black
        geofenceAddress.text = ""
        geofenceAddress.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        geofenceAddress.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        geofenceAddress.isUserInteractionEnabled = true
        scrollView.addSubview(geofenceAddress)
        geofenceAddress.addSubview(imgIcon)
        
        radiusField = UITextField()
        radiusField.textColor = .black
        radiusField.placeholder = "Radius"
        radiusField.isHidden = false
        radiusField.setLeftPaddingPoints(10)
        radiusField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
       
        radiusField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        scrollView.addSubview(radiusField)
        
        kmLabel = UILabel()
        kmLabel.textColor = .black
        kmLabel.isHidden = false
        kmLabel.text = "Km"
        kmLabel.isUserInteractionEnabled = false
        kmLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        addSubview(kmLabel)
        
        mapView = RCMainMap(frame: CGRect.zero)
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.addSubview(mapView)
        mapView.addSubview(mapPin)
        
        dateTimeTitle  = UILabel()
        dateTimeTitle.textColor = .black
        dateTimeTitle.text = "Date & Time"
        dateTimeTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scrollView.addSubview(dateTimeTitle)
        
        dateTimeField = PaddingToLabel(withInsets: 0, 0, 10, 10)
        dateTimeField.textColor = .black
        dateTimeField.text = "Select Date & Time"
        dateTimeField.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        dateTimeField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        scrollView.addSubview(dateTimeField)
        
        getNotifiedTitle  = UILabel()
        getNotifiedTitle.textColor = .black
        getNotifiedTitle.text = "Get notified by :"
        getNotifiedTitle.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scrollView.addSubview(getNotifiedTitle)
        
        emailIcon = UIImageView()
        emailIcon.image = #imageLiteral(resourceName: "Asset 50")
        emailIcon.contentMode = .scaleAspectFit
        scrollView.addSubview(emailIcon)
        
        notifIcon = UIImageView()
        notifIcon.image = #imageLiteral(resourceName: "Asset 49")
        notifIcon.contentMode = .scaleAspectFit
        scrollView.addSubview(notifIcon)
        
        emailLabel  = UILabel()
        emailLabel.textColor = .black
        emailLabel.text = "Email"
        emailLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scrollView.addSubview(emailLabel)
        
        notifLabel  = UILabel()
        notifLabel.textColor = .black
        notifLabel.text = "In-app notification"
        notifLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        scrollView.addSubview(notifLabel)
        
        newLocBtn = RadioButton(frame: CGRect.zero)
        newLocBtn.innerCircleCircleColor = appGreenTheme
        newLocBtn.outerCircleColor = appGreenTheme
        newLocBtn.innerCircleGap = 2
        newLocBtn.isSelected = true
        scrollView.addSubview(newLocBtn)
        
        existGeoBtn = RadioButton(frame: CGRect.zero)
        existGeoBtn.innerCircleCircleColor = appGreenTheme
        existGeoBtn.outerCircleColor = appGreenTheme
        newLocBtn.innerCircleGap = 2
        scrollView.addSubview(existGeoBtn)
        
        emailBtn = RadioButton(frame: CGRect.zero)
        emailBtn.innerCircleCircleColor = appGreenTheme
        emailBtn.outerCircleColor = appGreenTheme
        emailBtn.innerCircleGap = 2
        scrollView.addSubview(emailBtn)
        
        notifBtn = RadioButton(frame: CGRect.zero)
        notifBtn.innerCircleCircleColor = appGreenTheme
        notifBtn.outerCircleColor = appGreenTheme
        notifBtn.innerCircleGap = 2
        scrollView.addSubview(notifBtn)
        
        saveBtn = UIButton()
        saveBtn.setTitle("SAVE", for: .normal)
        saveBtn.backgroundColor = appGreenTheme
        addSubview(saveBtn)
    }
    func  setConstraints(){
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(saveBtn.snp.top)
        }
        selectVehicleTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screenSize.height * 0.01)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
        }
        selectVehicleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(selectVehicleTitle.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        destTitle.snp.makeConstraints { (make) in
            make.top.equalTo(selectVehicleTextField.snp.bottom).offset(screenSize.height * 0.01)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
        }
        newLocBtn.snp.makeConstraints { (make) in
            make.top.equalTo(destTitle.snp.bottom).offset(screenSize.height * 0.01)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
            make.size.equalTo(screenSize.height * 0.04)
        }
        newLocation.snp.makeConstraints { (make) in
            make.centerY.equalTo(newLocBtn)
            make.left.equalTo(newLocBtn.snp.right).offset(screenSize.width * 0.02)
        }
        existGeoBtn.snp.makeConstraints { (make) in
            make.top.equalTo(destTitle.snp.bottom).offset(screenSize.height * 0.01)
            make.left.equalTo(newLocation.snp.right).offset(screenSize.width * 0.08)
            make.size.equalTo(screenSize.height * 0.04)
        }
        
        existGeo.snp.makeConstraints { (make) in
            make.centerY.equalTo(existGeoBtn)
            make.left.equalTo(existGeoBtn.snp.right).offset(screenSize.width * 0.02)
        }
        newLocAddress.snp.makeConstraints { (make) in
            make.top.equalTo(newLocBtn.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        geofenceAddress.snp.makeConstraints { (make) in
            make.top.equalTo(newLocBtn.snp.bottom).offset(screenSize.height * 0.03)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        // inside location field
        imgIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        // inside vehicle feild
        dropIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        mapPin.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(13)
            make.height.equalTo(30)
        }
        radiusField.snp.makeConstraints { (make) in
            make.top.equalTo(newLocAddress.snp.bottom).offset(screenSize.height * 0.01)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        kmLabel.snp.makeConstraints { (make) in
            make.top.equalTo(newLocAddress.snp.bottom).offset(screenSize.height * 0.01)
            make.right.equalToSuperview().offset(-screenSize.width * 0.1)
           // make.width.equalToSuperview().multipliedBy(0.05)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(radiusField.snp.bottom).offset(screenSize.height * 0.01)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        dateTimeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom).offset(screenSize.height * 0.01)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
        }
        dateTimeField.snp.makeConstraints { (make) in
            make.top.equalTo(dateTimeTitle.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        getNotifiedTitle.snp.makeConstraints { (make) in
            make.top.equalTo(dateTimeField.snp.bottom).offset(screenSize.height * 0.02)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
        }
        emailIcon.snp.makeConstraints { (make) in
            make.top.equalTo(getNotifiedTitle.snp.bottom).offset(screenSize.height * 0.01)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
            make.size.equalTo(screenSize.height * 0.04)
        }
        emailBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailIcon)
            make.left.equalTo(emailIcon.snp.right).offset(screenSize.width * 0.03)
            make.size.equalTo(screenSize.height * 0.04)
//            make.width.equalToSuperview().multipliedBy(0.05)
//            make.height.equalToSuperview().multipliedBy(0.05)
        }
        emailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(emailBtn)
            make.left.equalTo(emailBtn.snp.right).offset(screenSize.width * 0.03)
        }
        notifIcon.snp.makeConstraints { (make) in
            make.top.equalTo(emailIcon.snp.bottom).offset(screenSize.height * 0.02)
            make.left.equalToSuperview().offset(screenSize.width * 0.05)
            make.size.equalTo(screenSize.height * 0.04)
             make.bottom.equalToSuperview().offset(-screenSize.width * 0.01)
        }
        notifBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(notifIcon)
            make.left.equalTo(notifIcon.snp.right).offset(screenSize.width * 0.03)
            make.size.equalTo(screenSize.height * 0.04)
//            make.width.equalToSuperview().multipliedBy(0.05)
//            make.height.equalToSuperview().multipliedBy(0.05)
            make.bottom.equalToSuperview().offset(-screenSize.width * 0.01)
        }
        notifLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(notifBtn)
            make.left.equalTo(notifBtn.snp.right).offset(screenSize.width * 0.03)
             make.bottom.equalToSuperview().offset(-screenSize.width * 0.01)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.06)
        }
        }
      
      required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

    }


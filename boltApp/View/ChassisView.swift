//
//  ChassisView.swift
//  Bolt
//
//  Created by Saanica Gupta on 17/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChassisView: UIView {
  //var fitterTextField:UITextField!
  var plateNumber:UITextField!
  var chassisNumber:UITextField!
  var vehicleBrand:UITextField!
  var vehicleModel :UITextField!
  
  var selectedvechileImageView: UIImageView!
  var okButton: UIButton!
  
  var vehicleTypeLabel: UILabel!
  var vehicleNameLabel: UILabel!
  var deviceMobileLabel: UILabel!
  var deviceImeiLabel: UILabel!
  var nameofFitterLabel: UILabel!
  var deviceAddedLabel: UILabel!
  
  var skipBtn: UIButton!
  
  let kscreenHeight = UIScreen.main.bounds.height
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
   // addPicker()
    addvechileImageView()
    addLabels()
    addTextFields()
    addButton()
    addConstraints()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addButton(){
    okButton = UIButton()
    okButton.backgroundColor =  appGreenTheme
    okButton.setImage(#imageLiteral(resourceName: "oklogo").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
    addSubview(okButton)
    
    skipBtn = UIButton()
    skipBtn.backgroundColor =  .clear
    skipBtn.setTitle("skip", for: .normal)
    skipBtn.setTitleColor(appGreenTheme, for: .normal)
    addSubview(skipBtn)
  }
  
  func addvechileImageView(){
    selectedvechileImageView = UIImageView()
    selectedvechileImageView.image = #imageLiteral(resourceName: "greencar")
    //addSubview(selectedvechileImageView)
  }
//  func addPicker(){
//    carPicker = UIPickerView(frame: CGRect.zero)
//    carPicker.selectRow(1, inComponent: 0, animated: false)
//    addSubview(carPicker)
//  }
//
  func addLabels(){
    vehicleTypeLabel = UILabel(frame: CGRect.zero)
    vehicleTypeLabel.text = "Great! Device Added"
    vehicleTypeLabel.adjustsFontSizeToFitWidth = true
    vehicleTypeLabel.layer.cornerRadius = 5
    vehicleTypeLabel.clipsToBounds = true
    vehicleTypeLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
    vehicleTypeLabel.textAlignment = .center
    vehicleTypeLabel.textColor = .white
    vehicleTypeLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 0.0)
    
    addSubview(vehicleTypeLabel)
    
    deviceAddedLabel = UILabel(frame: CGRect.zero)
    deviceAddedLabel.text = "Help us with a little more imformation about your vehicle."
    deviceAddedLabel.adjustsFontSizeToFitWidth = true
    deviceAddedLabel.layer.cornerRadius = 5
    deviceAddedLabel.clipsToBounds = true
    deviceAddedLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    deviceAddedLabel.textAlignment = .left
    deviceAddedLabel.numberOfLines = 2
    deviceAddedLabel.textColor =  appGreenTheme
    deviceAddedLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 0.0)
    
    addSubview(deviceAddedLabel)
    
    vehicleNameLabel = UILabel(frame: CGRect.zero)
    vehicleNameLabel.text = "  Vehicle Name"
    vehicleNameLabel.adjustsFontSizeToFitWidth = true
    vehicleNameLabel.layer.cornerRadius = 5
    vehicleNameLabel.clipsToBounds = true
    vehicleNameLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    vehicleNameLabel.textAlignment = .left
    vehicleNameLabel.textColor = .white
    vehicleNameLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 0.0)
    
    addSubview(vehicleNameLabel)
    
    deviceMobileLabel = UILabel(frame: CGRect.zero)
    deviceMobileLabel.text = "  Device Mobile Number"
    deviceMobileLabel.adjustsFontSizeToFitWidth = true
    deviceMobileLabel.layer.cornerRadius = 5
    deviceMobileLabel.clipsToBounds = true
    deviceMobileLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    deviceMobileLabel.textAlignment = .left
    deviceMobileLabel.textColor = .white
    deviceMobileLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 0.0)
    
    //addSubview(deviceMobileLabel)
    
    deviceImeiLabel = UILabel(frame: CGRect.zero)
    deviceImeiLabel.text = "  Device IMEI Number"
    deviceImeiLabel.adjustsFontSizeToFitWidth = true
    deviceImeiLabel.layer.cornerRadius = 5
    deviceImeiLabel.clipsToBounds = true
    deviceImeiLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    deviceImeiLabel.textAlignment = .left
    deviceImeiLabel.textColor = .white
    deviceImeiLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 0.0)
    
    // addSubview(deviceImeiLabel)
    
    nameofFitterLabel = UILabel(frame: CGRect.zero)
    nameofFitterLabel.text = "  Fitter Name"
    nameofFitterLabel.adjustsFontSizeToFitWidth = true
    nameofFitterLabel.layer.cornerRadius = 5
    nameofFitterLabel.clipsToBounds = true
    nameofFitterLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
    nameofFitterLabel.textAlignment = .left
    nameofFitterLabel.textColor = .white
    nameofFitterLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 0.0)
    
    // addSubview(nameofFitterLabel)
    
  }
  
  func addTextFields(){
    //        fitterTextField = UITextField(frame:CGRect.zero)
    //        fitterTextField.backgroundColor = .white
    //        fitterTextField.placeholder = "Name of fitter".toLocalize
    //        fitterTextField.contentHorizontalAlignment = .center
    //        fitterTextField.borderStyle = .line
    //        fitterTextField.setLeftPaddingPoints(20)
    //        fitterTextField.setRightPaddingPoints(20)
    //        //addSubview(fitterTextField)
    
    plateNumber = UITextField(frame:CGRect.zero)
    plateNumber.backgroundColor = .white
    plateNumber.borderStyle = .line
    plateNumber.placeholder = "Plate Number".toLocalize
    plateNumber.setLeftPaddingPoints(20)
    plateNumber.setRightPaddingPoints(20)
    addSubview(plateNumber)
    
    chassisNumber = UITextField(frame:CGRect.zero)
    chassisNumber.keyboardType = .numberPad
    chassisNumber.backgroundColor = .white
    chassisNumber.borderStyle = .line
    chassisNumber.placeholder = "Chassis Number".toLocalize
    chassisNumber.setLeftPaddingPoints(20)
    chassisNumber.setRightPaddingPoints(20)
    addSubview(chassisNumber)
    
    vehicleBrand = UITextField(frame:CGRect.zero)
    //vehicleBrand.keyboardType = .numberPad
    vehicleBrand.backgroundColor = .white
    vehicleBrand.borderStyle = .line
    vehicleBrand.placeholder = "Vehicle Brand".toLocalize
    vehicleBrand.setLeftPaddingPoints(20)
    vehicleBrand.setRightPaddingPoints(20)
    addSubview(vehicleBrand)
    
    vehicleModel = UITextField(frame:CGRect.zero)
      // vehicleModel.keyboardType = .numberPad
       vehicleModel.backgroundColor = .white
       vehicleModel.borderStyle = .line
       vehicleModel.placeholder = "Vehicle Model".toLocalize
       vehicleModel.setLeftPaddingPoints(20)
       vehicleModel.setRightPaddingPoints(20)
       addSubview(vehicleModel)
    
    
  }
  
  func addConstraints(){
    
    skipBtn.snp.makeConstraints { (make) in
 
         make.left.equalToSuperview().offset(20)
         make.width.equalTo(80)
         make.height.equalTo(40)
        make.top.equalToSuperview().offset(0.02 * kscreenHeight)
       }
       
    
    vehicleTypeLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      // make.left.equalToSuperview().offset(50)
      make.width.equalToSuperview().multipliedBy(0.95)
      make.height.equalToSuperview().multipliedBy(0.08)
      make.top.equalToSuperview().offset(0.08 * kscreenHeight)
    }
    
    deviceAddedLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      // make.left.equalToSuperview().offset(50)
      //make.width.equalToSuperview().multipliedBy(0.6)
      make.left.equalToSuperview().offset(20)
      make.height.equalToSuperview().multipliedBy(0.1)
      //make.top.equalToSuperview().offset(0.2 * kscreenHeight)
      make.top.equalTo(vehicleTypeLabel.snp.bottom).offset(10)
    }
    
//    carPicker.snp.makeConstraints { (make) in
//      // make.top.equalToSuperview().offset(100)
//       make.top.equalTo(deviceAddedLabel.snp.bottom).offset(10)
//      //            make.top.equalToSuperview().offset(60)
//      make.left.equalToSuperview().offset(50)
//      make.height.equalToSuperview().multipliedBy(0.15)
//      make.width.equalToSuperview().multipliedBy(0.40)
//    }
//
//    selectedvechileImageView.snp.makeConstraints { (make) in
//      make.centerY.equalTo(carPicker)
//      make.right.equalToSuperview().offset(-20)
//      make.height.equalToSuperview().multipliedBy(0.05)
//      make.width.equalToSuperview().multipliedBy(0.15)
//    }
//
    //        vehicleNameLabel.snp.makeConstraints { (make) in
    //            make.centerX.equalToSuperview()
    //            make.width.equalToSuperview().multipliedBy(0.90)
    //            make.height.equalToSuperview().multipliedBy(0.035)
    //            make.top.equalTo(carPicker.snp.bottom).offset(10)
    //        }
    plateNumber.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.90)
      make.height.equalToSuperview().multipliedBy(0.08)
      //make.top.equalTo(vehicleNameLabel.snp.bottom).offset(1)
      make.top.equalTo(deviceAddedLabel.snp.bottom).offset(10)
      
    }
    
    //        deviceMobileLabel.snp.makeConstraints { (make) in
    //            make.centerX.equalToSuperview()
    //            make.width.equalToSuperview().multipliedBy(0.90)
    //            make.height.equalToSuperview().multipliedBy(0.035)
    //            make.top.equalTo(vechileNameTextField.snp.bottom).offset(10)
    //        }
    chassisNumber.snp.makeConstraints { (make) in
      make.left.width.height.equalTo(plateNumber)
      make.height.equalToSuperview().multipliedBy(0.08)
      // make.top.equalTo(deviceMobileLabel.snp.bottom).offset(1)
      make.top.equalTo(plateNumber.snp.bottom).offset(10)
    }
    
    //        deviceImeiLabel.snp.makeConstraints { (make) in
    //            make.centerX.equalToSuperview()
    //            make.width.equalToSuperview().multipliedBy(0.90)
    //            make.height.equalToSuperview().multipliedBy(0.035)
    //            make.top.equalTo(deviceMobileNumber.snp.bottom).offset(10)
    //        }
    vehicleBrand.snp.makeConstraints { (make) in
      make.left.width.height.equalTo(chassisNumber)
      make.height.equalToSuperview().multipliedBy(0.08)
      //make.top.equalTo(deviceImeiLabel.snp.bottom).offset(1)
      make.top.equalTo(chassisNumber.snp.bottom).offset(10)
     // make.bottom.equalTo(okButton.snp.top).offset(-0.1 * kscreenHeight)
    }
    
    
    vehicleModel.snp.makeConstraints { (make) in
         make.left.width.height.equalTo(chassisNumber)
         make.height.equalToSuperview().multipliedBy(0.08)
         //make.top.equalTo(deviceImeiLabel.snp.bottom).offset(1)
         make.top.equalTo(vehicleBrand.snp.bottom).offset(10)
        // make.bottom.equalTo(okButton.snp.top).offset(-0.1 * kscreenHeight)
       }
//    carPicker.snp.makeConstraints { (make) in
//      // make.top.equalToSuperview().offset(100)
//       make.top.equalTo(vehicleBrand.snp.bottom).offset(10)
//      //            make.top.equalToSuperview().offset(60)
//      make.left.equalToSuperview().offset(50)
//      make.height.equalToSuperview().multipliedBy(0.15)
//      make.width.equalToSuperview().multipliedBy(0.40)
//    }
    
    //        nameofFitterLabel.snp.makeConstraints { (make) in
    //            make.centerX.equalToSuperview()
    //            make.width.equalToSuperview().multipliedBy(0.90)
    //            make.height.equalToSuperview().multipliedBy(0.035)
    //            make.top.equalTo(device_imeiNumberTextField.snp.bottom).offset(10)
    //        }
    //        fitterTextField.snp.makeConstraints { (make) in
    //            make.left.width.height.equalTo(device_imeiNumberTextField)
    //           make.height.equalToSuperview().multipliedBy(0.08)
    //           // make.top.equalTo(nameofFitterLabel.snp.bottom).offset(1)
    //          make.top.equalTo(device_imeiNumberTextField.snp.bottom).offset(10)
    //
    //        }
    
    
    okButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.09)
      make.bottom.equalToSuperview().offset(-40)
      
      //            if UIDevice().userInterfaceIdiom == .phone {
      //                switch UIScreen.main.nativeBounds.height {
      //                case 2436:
      //                    if #available(iOS 11.0, *) {
      //                        make.bottom.equalTo(self.safeAreaInsets.bottom).offset(-30)
      //                    } else {
      //                        // Fallback on earlier versions
      //                        make.bottom.equalTo(self).offset(-30)
      //                    }
      //                default:
      //                    make.bottom.equalToSuperview()
      //                }
      //            } else {
      //                make.bottom.equalToSuperview()
      //            }
    } 
  }
}



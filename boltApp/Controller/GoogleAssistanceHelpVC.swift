//
//  GoogleAssistanceHelpVC.swift
//  Bolt
//
//  Created by Vivek Kumar on 29/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class GoogleAssistanceHelpVC: UIViewController {
    var googleAssistanceHelpView: GoogleAssistanceHelpView!
    var devicesPicker: UIPickerView = UIPickerView()
    var allDevices: [TrackerDevicesMapperModel]!
    var selectedDeviceId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        allDevices = RCGlobals.getExpiryFilteredList(data)
        addView()
        addConstraints()
        setActions()
        
        if let email = Defaults().get(for: Key<String>("google_assistant_email")) {
            googleAssistanceHelpView.gmailIdTextField.text = email
        }
        
        if let deviceId = Defaults().get(for: Key<String>("default_device_id")) {
            for data in allDevices {
                let deviceIdString = "\(data.id ?? 0)"
                if  deviceIdString == deviceId {
                    googleAssistanceHelpView.selectVehicleTextField.text = data.name ?? ""
                    selectedDeviceId = data.id ?? 0
                }
            }
        }
        
    }
    func setActions(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        googleAssistanceHelpView.proceedButton.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
        let helpGuesture = UITapGestureRecognizer(target: self, action: #selector(helpGuesture(sender:)))
        helpGuesture.numberOfTouchesRequired = 1
        googleAssistanceHelpView.whoseViraImageView.addGestureRecognizer(helpGuesture)
        
    }
    @objc func helpGuesture(sender:UITapGestureRecognizer){
        self.navigationController?.pushViewController(WhatCanViraDoesVC(), animated: true)
    }
    func addView(){
        googleAssistanceHelpView = GoogleAssistanceHelpView(frame: CGRect.zero)
        googleAssistanceHelpView.backgroundColor = .white
        view.addSubview(googleAssistanceHelpView)
        
        googleAssistanceHelpView.selectVehicleTextField.delegate = self
        googleAssistanceHelpView.selectVehicleTextField.inputView = devicesPicker
        
        devicesPicker.showsSelectionIndicator = true
        devicesPicker.delegate = self
        devicesPicker.dataSource = self
        devicesPicker.tag = 1
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".toLocalize, style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let titleButton = UIBarButtonItem(title: "Select Vehicle".toLocalize, style:UIBarButtonItemStyle.plain, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([titleButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        googleAssistanceHelpView.selectVehicleTextField.inputAccessoryView = toolBar
    }
    @objc func donePicker(){
        if(googleAssistanceHelpView.selectVehicleTextField.text?.count == 0 && allDevices.count > 0) {
            selectedDeviceId = allDevices[0].id
            googleAssistanceHelpView.selectVehicleTextField.text = allDevices[0].name
        }
        googleAssistanceHelpView.selectVehicleTextField.endEditing(true)
    }
    func addConstraints(){
        googleAssistanceHelpView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
    }
    @objc func backTapped(){
         self.dismiss(animated: true, completion: nil)
    }
    @objc func nextTapped(_ sender: UIButton)
    {
        let emailId = googleAssistanceHelpView.gmailIdTextField.text!
        let selectedVehicle = googleAssistanceHelpView.selectVehicleTextField.text!
        
        if !emailId.isValidEmail() || selectedVehicle == ""{
            self.prompt("Please fill all fields")
        }    else {
            self.openToViRA()
        }
    }
    
    func openToViRA(){
        let emailId = googleAssistanceHelpView.gmailIdTextField.text ?? ""
        let defaultDeviceId = "\(selectedDeviceId ?? 0)"
        
        RCLocalAPIManager.shared.googleAssistent(googleAssistentEmailId: emailId, defaultDeviceId: defaultDeviceId, success: { (_) in
            //self.navigationController?.pushViewController(WhatCanViraDoesVC(), animated: true)
            Defaults().set(emailId, for: Key<String>("google_assistant_email"))
            Defaults().set(defaultDeviceId, for: Key<String>("default_device_id"))
            self.prompt("Success")
        }, failure: { (_) in
            self.prompt("failed")
        })
    }
}
extension String {
    func isValidEmail() -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
}
extension GoogleAssistanceHelpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        googleAssistanceHelpView.selectVehicleTextField.resignFirstResponder()
        return true
    }
}
extension GoogleAssistanceHelpVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if allDevices.count > 0 {
            return allDevices[row].name!
        } else {
            return nil
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        if allDevices.count > 0 {
            googleAssistanceHelpView.selectVehicleTextField.text = allDevices[row].name
            selectedDeviceId = allDevices[row].id
        } else {
            return
        }
    }
}


extension GoogleAssistanceHelpVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDevices.count
    }
    
}

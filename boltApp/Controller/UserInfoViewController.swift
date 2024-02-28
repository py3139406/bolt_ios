//
//  UserInfoViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class UserInfoViewController: UIViewController {
    var userInformationView:UserInformationView!
    var pickerData: PickerViewData!
    var carPicker:UIPickerView!
    var selectedVehicle: String!
    var counter:Int = 0
    var HUD:MBProgressHUD?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setActions()
    }
    private func setViews(){
        view.backgroundColor = appDarkTheme
        userInformationView = UserInformationView(frame: CGRect.zero)
        view.addSubview(userInformationView)
    }
    private func setConstraints(){
        userInformationView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    private func setActions(){
        pickerData = PickerViewData()
        selectedVehicle = pickerData.nameOfVechiles[0]

        carPicker = UIPickerView()
        carPicker.delegate = self
        carPicker.dataSource = self
        carPicker.selectRow(0, inComponent: 0, animated: false)
        userInformationView.okButton.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        userInformationView.imeiScanner.addTarget(self, action: #selector(scanDevice(_:)), for: .touchUpInside)
        userInformationView.imeiScanner.tag = 0
        userInformationView.activationScanner.tag = 1
        userInformationView.activationScanner.addTarget(self, action: #selector(scanDevice(_:)), for: .touchUpInside)
    }
    @objc func scanDevice(_ sender:UIButton){
        let vc =  AddScannerViewController()
        vc.imeiField = userInformationView.device_imeiNumberTextField
        vc.codeField = userInformationView.activationCode
        switch sender.tag  {
        case 0 :
            vc.optionType = "imeiScn"
        default:
            vc.optionType = "codeScn"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func okButtonAction() {
        let vehicleName = userInformationView.vechileNameTextField.text ?? ""
        let activationCode = userInformationView.activationCode.text ?? ""
        let deviceIMEI = userInformationView.device_imeiNumberTextField.text ?? ""
      
        
        if (vehicleName.isEmpty) || (activationCode.isEmpty) || (deviceIMEI.isEmpty)  {
            self.showalert("All fields are required".toLocalize)
        } else {

            showProgress(message: "Please wait...")
            RCLocalAPIManager.shared.addDevice(loadingMsg: "", deviceName: vehicleName, activationCode: activationCode, imeiNumber: deviceIMEI) { (taskid) in
                Defaults().set(taskid, for: Key<String>("device_task_id"))
                self.counter = 0
                self.getDeviceTaskId()
            } failure: { (message) in
                self.hideProgress()
                print(message)
                self.view.makeToast(message)
            }
    }
    }
    private func getDeviceTaskId(){
        let task_id =  Defaults().get(for: Key<String>("device_task_id")) ?? ""
        RCLocalAPIManager.shared.getDeviceRequest(loadingMsg: "", taskId: task_id) { (success) in
            self.counter += 1
            if let state = success["state"] as? String {
                if state == "PENDING"{
                    if self.counter < 10 {
                        Thread.sleep(forTimeInterval: 1)
                        self.getDeviceTaskId()
                    } else {
                        self.counter = 0
                        self.hideProgress()
                        self.prompt("Unable to confirm device add status.")
                    }
                }else {
                    self.counter = 0
                    self.hideProgress()
                    if let data = success["data"] as? [String: Any] {
                        if let status = data["status"] as? String {
                            if status == "success"{
                                self.prompt("", "Device added successfully", "OK") { (_) in
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                            }else{
                                self.prompt("", "\(data["message"] as? String ?? "")", "OK") { (_) in
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }

        } failure: { (message) in
            self.counter = 0
            self.hideProgress()
            self.prompt("Unable to confirm device add status.")
            print(message)
        }

    }
  
}

extension UserInfoViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData.nameOfVechiles[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:UIColor.black])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData.nameOfVechiles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
}

extension UserInfoViewController:UIPickerViewDataSource{
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.nameOfVechiles.count
    }
}

extension UserInfoViewController {
    
    func showProgress (message : String) {
        let topWindow = UIApplication.shared.keyWindow
        HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        HUD?.animationType = .fade
        HUD?.mode = .indeterminate
        HUD?.labelText = message
    }
    
    func hideProgress () {
        HUD?.hide(true)
    }
}


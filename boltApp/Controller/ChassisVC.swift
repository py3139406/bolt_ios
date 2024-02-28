//
//  ChassisVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 17/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class ChassisVC: UIViewController {
  
  var userInformationView: ChassisView!
  var carPicker: UIPickerView!
  var modelPicker: UIPickerView!
  var pickerData: PickerViewData!
  var selectedVehicle: String!
  
  private var carListjson = Dictionary<String, Array<String>>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = appDarkTheme
    userInformationView = ChassisView(frame: view.frame)
    view.addSubview(userInformationView)
    carPicker = UIPickerView(frame: CGRect.zero)
    modelPicker = UIPickerView(frame: CGRect.zero)
    carPicker.tag = 0
    modelPicker.tag = 1
    dataFormJSONFile()
    showPickerView()
    
    userInformationView.vehicleBrand.inputView = carPicker
    userInformationView.vehicleModel.inputView = modelPicker
    
    // pickerData = PickerViewData()
    //selectedVehicle = modelData[1]
    //carPicker.selectRow(1, inComponent: 0, animated: false)
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain,
                                                            target: self, action: #selector(backTapped))
    self.navigationItem.title = "Tracker Info".toLocalize
    userInformationView.okButton.addTarget(self, action: #selector(okButtonAction(sender:)), for: .touchUpInside)
    userInformationView.skipBtn.addTarget(self, action: #selector(skipPressed(sender:)), for: .touchUpInside)
    
    carPicker.delegate = self
    carPicker.dataSource = self
    
    modelPicker.delegate  = self
    modelPicker.dataSource = self
    
  }
  
  @objc func skipPressed(sender:UIButton) {
    
  
  self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
                   
    
    }
  
  private func dataFormJSONFile() {
    if let path = Bundle.main.path(forResource: "car_list", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let carList = jsonResult as! NSArray
        for car in carList {
          print(car)
          if let dictonary = car as? [String: Any] {
            if let brand = dictonary["brand"] as? String, let model = dictonary["models"] as? [String] {
              carListjson[brand] = model.sorted()
            }
          }
        }
      } catch {
        print("There was a error converting json")
      }
    }
    print(carListjson)
  }
  
  
  
  private func showPickerView() {
    
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerView))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPickerView))
    toolbar.setItems([doneButton, spaceButton, cancelButton], animated: true)
    
    userInformationView.vehicleBrand.inputAccessoryView = toolbar
    userInformationView.vehicleBrand.inputView = carPicker
    
    userInformationView.vehicleModel.inputAccessoryView = toolbar
    userInformationView.vehicleModel.inputView = modelPicker
    // vehicleDetailsView.modelTextfield.inputAccessoryView = toolbar
    // vehicleDetailsView.modelTextfield.inputView = modelpicker
  }
  
  @objc private func donePickerView() {
    if userInformationView.vehicleBrand.isEditing {
      let carBrand = Array(carListjson.keys)//.sorted()
      userInformationView.vehicleBrand.text = carBrand[carPicker.selectedRow(inComponent: 0)]
      
    } else {
      let carbrand = userInformationView.vehicleBrand.text!
      let carmodel = Array(carListjson[carbrand]!)
      userInformationView.vehicleModel.text = carmodel[modelPicker.selectedRow(inComponent: 0)]
      
    }
    
    self.view.endEditing(true)
  }
  
  @objc private func cancelPickerView() {
    self.view.endEditing(true)
  }
  
  @objc func backTapped() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func okButtonAction(sender:UIButton) {
    let vehicleName = userInformationView.plateNumber.text ?? ""
    let deviceMobileNo = userInformationView.chassisNumber.text ?? ""
    let deviceIMEI = userInformationView.vehicleBrand.text ?? ""
    let modelfi = userInformationView.vehicleModel.text ?? ""
    
    
    
    let brand = deviceIMEI.lowercased()
    let model = modelfi.lowercased()
    
    let deviceDetails: [String:Any] = ["plate_number":vehicleName, "chasis_number":deviceMobileNo,
                                       "vehicleBrand": brand, "vehicleModel": model]
    
    RCLocalAPIManager.shared.putUsersCarsData(deviceId: deviceId, first: "", second: "", deviceDetails: deviceDetails ,success: { [weak self]hash in
      guard let weakself = self else { return }
      
      OperationQueue.main.addOperation {
        
                       let closureHandler1 = { (action:UIAlertAction!) -> Void in
                        weakself.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
                       }
        //self.prompt("Details Successfully Updated",erro, handler1: closureHandler1)
        self?.prompt("Details Successfully Updated", "", "ok", handler1: closureHandler1)
                   }
      

      weakself.view.setNeedsDisplay()
      
    }) { [weak self] message in
      guard let _ = self else { return }
      
      self?.prompt("Details Failed to Update, Please try again later!")
      print(message)
      
    }
  }
}

extension ChassisVC: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    let array = Array(carListjson.keys)
    let newArray = array[row]

    if pickerView.tag == 0 {
      
      let titleData = newArray
      let color = UIColor.black//UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
      let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:color])
      return myTitle
      
    } else {
      let carbrand = userInformationView.vehicleBrand.text!
      let carmodel = Array(carListjson[carbrand]!)
      let brand = carmodel[row]
      let titleData = brand
      let color = UIColor.black//UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1)
      let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18),NSAttributedStringKey.foregroundColor:color])
      return myTitle
      
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
    // userInformationView.selectedvechileImageView.image = pickerData.vechilesImages[row]
    
    
    
    if pickerView.tag == 0 {
      let array = Array(carListjson.keys)
      let newArray = array[row]
      let titleData = newArray
      selectedVehicle = titleData
    } else {
      
      let carbrand = userInformationView.vehicleBrand.text!
      let carmodel = Array(carListjson[carbrand]!)
      let brand = carmodel[row]
      
      selectedVehicle = brand
    }
    
  }
  
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    var newArray = ""
    if pickerView.tag == 0 {
      let array = Array(carListjson.keys)
      newArray = array[row]
    } else {
      
      let carbrand = userInformationView.vehicleBrand.text!
      let carmodel = Array(carListjson[carbrand]!)
      newArray = carmodel[row]
      
    }
    return newArray
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 35
  }
}

extension ChassisVC : UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    if pickerView.tag == 1 &&  userInformationView.vehicleBrand.text == "" {
      self.view.endEditing(true)
      self.prompt("Select Vehicle Brand First")
    return 0
    } else {
       return 1
       }
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    var numberCount = 0
    
    
    if pickerView.tag == 0 {
      
      let array = Array(carListjson.keys)
      numberCount = array.count
      
    } else {
      
      let carbrand = userInformationView.vehicleBrand.text!
      let carmodel = Array(carListjson[carbrand]!)
      numberCount = carmodel.count
      
    }
   
    
    return numberCount
      
  }
  
}

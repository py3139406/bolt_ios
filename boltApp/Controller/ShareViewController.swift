//
//  ShareViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import SwiftMessages

var isViaShareChatBackPressed:Bool = false

class ShareViewController: UIViewController{
    
    var shareView:ShareView!
    var allDevices:[TrackerDevicesMapperModel]!
    lazy var devicesPicker: UIPickerView = UIPickerView()
    var overlayButton: UIButton!
    var selectedVehicleIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isAlreadyShared = Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? ""
        if isAlreadyShared != "" {
            
                self.present(LeaderShareViewController(), animated: true, completion: nil)
            
        }
          self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), style: .plain, target: self, action: #selector(backTapped))
        view.backgroundColor =  appDarkTheme
        shareView = ShareView(frame: view.frame)
        view.addSubview(shareView)
        shareView.vechileTextField.delegate = self
        shareView.shareButton.addTarget(self, action: #selector(shareButtonAction(sender:)), for: .touchUpInside)
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
        allDevices = RCGlobals.getExpiryFilteredList(data ?? [])
        
        allDevices = allDevices.filter{ $0.lastUpdate != nil }
        
        shareView.vechileTextField.inputView = devicesPicker
        
        setUpPickerViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let isAlreadyShared = Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? ""
        if isAlreadyShared != "" {
            if  isViaShareChatBackPressed {
                let tabBarController: UITabBarController = (shareView.window?.rootViewController as? UITabBarController)!
                tabBarController.selectedIndex = 0
                isViaShareChatBackPressed = false
            }else {
                self.present(LeaderShareViewController(), animated: true, completion: nil)
            }
        }
    }
    
    @objc func backTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpPickerViews() -> Void {
        devicesPicker.backgroundColor = appDarkTheme
        devicesPicker.tintColor = .white
        // Overlay view constraints setup
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayButton.alpha = 0
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: shareView) { shareView.addSubview(overlayButton) }
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        shareView.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: shareView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: shareView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: shareView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: shareView, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        
        devicesPicker.showsSelectionIndicator = true
        devicesPicker.delegate = self
        devicesPicker.dataSource = self
        devicesPicker.tag = 1
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.barTintColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1)
        toolBar.isTranslucent = true
//        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".toLocalize, style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let titleButton = UIBarButtonItem(title: "Cancel".toLocalize, style:UIBarButtonItemStyle.plain, target: self, action: #selector(cancelButtonDidTapped))
        titleButton.tintColor = .red
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([titleButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        shareView.vechileTextField.inputAccessoryView = toolBar
    }
    
    @IBAction func cancelButtonDidTapped(_ sender: AnyObject) {
        self.overlayButton.alpha = 0
        //        self.overlayButton.removeFromSuperview()
        shareView.vechileTextField.endEditing(true)
    }
    
    @objc func donePicker(){
        self.overlayButton.alpha = 0
        if(shareView.vechileTextField.text?.count == 0 && allDevices.count > 0) {
            selectedVehicleIndex = 0
            shareView.vechileTextField.text = allDevices[0].name
        }
        shareView.vechileTextField.endEditing(true)
    }
    
    @objc func shareButtonAction(sender: UIButton!){
        if selectedVehicleIndex != nil {
//            showalert( allDevices[selectedVehicleIndex].name! + " shared successfully.")
            
            self.prompt("Share Vehicle".toLocalize, "Are you sure?".toLocalize, "Yes".toLocalize, "No".toLocalize, handler1: {_ in
                    self.shareVehicleLocation()
                Defaults().set(self.allDevices[self.selectedVehicleIndex], for: Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
                }, handler2: {_ in
                    self.dismiss(animated: true, completion: nil)
                })
        }else {
            showalert("Please select vehicle first".toLocalize)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func randomString() -> String {
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< 5 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyHHmmss"
        let dateString: String = dateFormatter.string(from: Date())
        let randomPIN: String = "\(randomString)\(dateString)"
        
        return randomPIN
    }
    
    func shareVehicleLocation() {
        let randomPIN = randomString()
        
        let shareLink: [Any] = [NSLocalizedString("View ".toLocalize + allDevices[selectedVehicleIndex].name! + " location by opening this link \n".toLocalize, comment: "View my vehicle's location by opening this link".toLocalize)+" https://track.roadcast.co.in/share?id=\(String(describing: randomPIN))\n"+NSLocalizedString("Sent via: Bolt".toLocalize, comment: "Sent via: Bolt".toLocalize)]
        let shareVC = UIActivityViewController(activityItems:shareLink, applicationActivities: nil)
        shareVC.excludedActivityTypes = [.assignToContact,.print, .postToVimeo]
        present(shareVC, animated: true, completion:nil)

        let status2 = MessageView.viewFromNib(layout:.statusLine)
        status2.backgroundView.backgroundColor = UIColor(red: 120.0/255.0, green:171.0/255.0, blue: 70.0/255.0, alpha:1)
        status2.bodyLabel?.textColor = .white
        status2.configureContent(body: "Connected - " + allDevices[selectedVehicleIndex].name!)
        var status2Config = SwiftMessages.defaultConfig
      //status2Config.presentationStyle = .window(windowLevel: UIWindowLevelStatusBar)
        status2Config.duration = .forever
        status2Config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: status2Config, view: status2)
        
        Defaults().set(randomPIN, for: Key<String>("ShareVehicleRandomPin"))
        Defaults().set(allDevices[selectedVehicleIndex].name!, for: Key<String>("ShareVehicleName"))

        shareVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            self.present(LeaderShareViewController(), animated: true, completion: nil)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        shareView.vechileTextField.resignFirstResponder()
    }
  
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return allDevices[row].name!
//    }
    

}

extension ShareViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shareView.vechileTextField.resignFirstResponder()
        return true
    }
}

extension ShareViewController: UIPickerViewDelegate{
   
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = allDevices[row].name!
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVehicleIndex = row
        shareView.vechileTextField.text = allDevices[row].name
    }
}

extension ShareViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDevices.count
    }
}

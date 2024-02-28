//
//  ShareVC.swift
//  Bolt
//
//  Created by Roadcast on 05/11/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit
import SwiftMessages

class ShareVC: UIViewController {
    
    var segmentedController: UISegmentedControl!
    var multiView : MultiShareView!
    var shareWithChat :ShareWithChatView!
    var multipleShareDevices: [TrackerDevicesMapperModel] = []
    var allDevices: [TrackerDevicesMapperModel] = []
    lazy var devicesPicker: UIPickerView = UIPickerView()
    var selectedDevice:TrackerDevicesMapperModel?
    var isSearching:Bool = false
    var filteredDevices:[TrackerDevicesMapperModel] = []
    var device:TrackerDevicesMapperModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), style: .plain, target: self, action: #selector(backTapped))
        setViews()
        setConstraints()
        addDoneButtonOnKeyboard()
        setActions()
        setUpPickerViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let isAlreadyShared = Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? ""
        if isAlreadyShared != "" {
            let newVC = LeaderShareViewController()
            newVC.modalPresentationStyle = .custom
            self.present(newVC, animated: true, completion: nil)
        }
    }
    @objc func backTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    func setViews(){
        self.view.backgroundColor = appDarkTheme
        
        segmentedController = UISegmentedControl(items: ["MULTIPLE VEHICLES", "SHARE(WITH CHAT)"])
        segmentedController.selectedSegmentIndex = 0
        segmentedController.backgroundColor = .white
        if #available(iOS 13.0, *) {
            segmentedController.selectedSegmentTintColor = appGreenTheme
        } else {
            // Fallback on earlier versions
            segmentedController.tintColor = appGreenTheme
        }
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .disabled)
        
        segmentedController.layer.cornerRadius = 5
        segmentedController.layer.masksToBounds = true
        view.addSubview(segmentedController)
        
        multiView = MultiShareView(frame: CGRect.zero)
        view.addSubview(multiView)
        shareWithChat = ShareWithChatView(frame: CGRect.zero)
        view.addSubview(shareWithChat)
        multiView.isHidden = false
        shareWithChat.isHidden = true
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        multiView.searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        multiView.searchBar.endEditing(true)
    }
    private func setConstraints(){
        segmentedController.snp.makeConstraints{ (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(screensize.height * 0.05)
            } else {
                make.top.equalToSuperview().offset(screensize.height * 0.05)
            }
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalToSuperview()
        }
        multiView.snp.makeConstraints{ (make) in
            make.top.equalTo(segmentedController.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        shareWithChat.snp.makeConstraints{ (make) in
            make.top.equalTo(segmentedController.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
    }
    private func  setActions(){
        filterDevices()
        segmentedController.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        
        multiView.searchBar.delegate = self
         multiView.multiShareTable.register(MultiShareTableCell.self, forCellReuseIdentifier: TableCellIdentifiers.multipleShareTableCell.rawValue)
        multiView.multiShareTable.delegate = self
        multiView.multiShareTable.dataSource = self
        
        shareWithChat.vechileTextField.delegate = self
        shareWithChat.vechileTextField.inputView = devicesPicker
        shareWithChat.shareButton.addTarget(self, action: #selector(shareWithChatTapped), for: .touchUpInside)
    }
    
    func setUpPickerViews() -> Void {
        devicesPicker.backgroundColor = appDarkTheme
        devicesPicker.tintColor = .white
        
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
        
        shareWithChat.vechileTextField.inputAccessoryView = toolBar
    }
    
    @objc func cancelButtonDidTapped(_ sender: AnyObject) {
        shareWithChat.vechileTextField.endEditing(true)
    }
    
    @objc func donePicker(){
        if(shareWithChat.vechileTextField.text?.count == 0 && allDevices.count > 0) {
            shareWithChat.vechileTextField.text = allDevices[0].name
            selectedDevice = allDevices[0]
        }
        shareWithChat.vechileTextField.endEditing(true)
    }
    
    func filterDevices() {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
        let totalDevices = RCGlobals.getExpiryFilteredList(data ?? [])
        
        multipleShareDevices.removeAll()
        for item in totalDevices {
            if item.lastUpdate != nil {
                multipleShareDevices.append(item)
            }
        }
        
        allDevices.removeAll()
        for item in totalDevices {
            if item.lastUpdate != nil {
                allDevices.append(item)
            }
        }
        
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        let  selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            multiView.isHidden = false
            shareWithChat.isHidden = true
        } else {
            multiView.isHidden = true
            shareWithChat.isHidden = false
        }
    }
    @objc func shareWithChatTapped () {
        if let device = selectedDevice {
            self.prompt("Share Vehicle".toLocalize, "Are you sure?".toLocalize, "Yes".toLocalize, "No".toLocalize, handler1: {_ in
                Defaults().set(device, for: Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
                self.shareVehicleLocation(device: device)
            
            }, handler2: {_ in
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.prompt("Please select a vehicle first.")
        }
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
    
    func shareVehicleLocation(device: TrackerDevicesMapperModel) {
        let randomPIN = randomString()
        
        let shareLink: [Any] = [NSLocalizedString("View ".toLocalize + (device.name ?? "") + " location by opening this link \n".toLocalize, comment: "View my vehicle's location by opening this link".toLocalize)+RCRouter.singleShareURL+"\(String(describing: randomPIN))\n"+NSLocalizedString("Sent via: BOLT app".toLocalize, comment: "Sent via: BOLT app".toLocalize)]
        
        let shareVC = UIActivityViewController(activityItems:shareLink, applicationActivities: nil)
        shareVC.excludedActivityTypes = [.assignToContact,.print, .postToVimeo]
        // here is the changes for ipad -->
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popOver = shareVC.popoverPresentationController {
              popOver.sourceView = self.view
                popOver.sourceRect = CGRect(origin: CGPoint(x: 0,y: (screensize.height - 200)), size: CGSize(width: screensize.width, height: 200))
                popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }
            present(shareVC, animated: true, completion:nil)
        //<--
        let status2 = MessageView.viewFromNib(layout:.statusLine)
        status2.backgroundView.backgroundColor = UIColor(red: 120.0/255.0, green:171.0/255.0, blue: 70.0/255.0, alpha:1)
        status2.bodyLabel?.textColor = .white
        status2.configureContent(body: "Connected - " + (device.name ?? ""))
        var status2Config = SwiftMessages.defaultConfig
        status2Config.duration = .forever
        status2Config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: status2Config, view: status2)
        
        Defaults().set(randomPIN, for: Key<String>("ShareVehicleRandomPin"))
        Defaults().set((device.name ?? ""), for: Key<String>("ShareVehicleName"))
        
        shareVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            self.present(LeaderShareViewController(), animated: true, completion: nil)
        }
    }
}
extension ShareVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredDevices.count
        } else {
            return multipleShareDevices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.multipleShareTableCell.rawValue, for: indexPath) as! MultiShareTableCell
        if isSearching {
            device = filteredDevices[indexPath.row]
        } else {
            device = multipleShareDevices[indexPath.row]
        }
        
        cell.vehicleName.text = "\(device?.name ?? "")"
        cell.shareBtn.tag = device?.id ?? 0
        cell.selectionStyle = .none
        cell.shareBtn.addTarget(self, action: #selector(shareLocation(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            device = filteredDevices[indexPath.row]
        } else {
            device = multipleShareDevices[indexPath.row]
        }
        let page = ShareLocPopVC()
        page.deviceId = device?.id ?? 0
        page.modalPresentationStyle = .custom
        self.present(page, animated: true, completion: nil)
    }
    @objc func shareLocation(_ sender:UIButton){
        let page = ShareLocPopVC()
        page.deviceId = sender.tag
        page.modalPresentationStyle = .custom
        self.present(page, animated: true, completion: nil)
    }
    
    
}

extension ShareVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shareWithChat.vechileTextField.resignFirstResponder()
        return true
    }
}

extension ShareVC: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = allDevices[row].name!
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDevice = allDevices[row]
        shareWithChat.vechileTextField.text = allDevices[row].name
    }
}

extension ShareVC: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDevices.count
    }
}

extension ShareVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
    //    isSearching = true
        filteredDevices.removeAll()
        
        if searchText.count == 0 {
            filteredDevices = multipleShareDevices
        } else {
            filteredDevices = multipleShareDevices.filter( {
                if ($0.name?.localizedLowercase.contains(searchText.lowercased()))! {
                    return true
                } else {
                    return false
                }
            } )
        }
        if searchText != "" {
            isSearching = true
        }else {
            isSearching = false
        }
        
        multiView.multiShareTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isSearching = false
        filteredDevices.removeAll()
        multiView.multiShareTable.reloadData()
        searchBar.endEditing(true)
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

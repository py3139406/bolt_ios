//
//  RCImmobilizeViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import MessageUI
import KeychainAccess

class ImmobilizeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var immobilzeView = ImmobilizeView()
    var allDevices: [TrackerDevicesMapperModel]!
    lazy var onlineDevices = [TrackerDevicesMapperModel]()
    lazy var sentDevicesSuccess = [TrackerDevicesMapperModel]()
    lazy var currentImmobilizeDevices = [TrackerDevicesMapperModel]()
    lazy var filteredDevices = [TrackerDevicesMapperModel]()
    var selectedIndex: Int = 0
    var isSearching: Bool = false
    lazy var selectedCells = [IndexPath]()
    var commandType = "engineResume"
    var immobilizeFlagCheck = Defaults().get(for: Key<Bool>("ImmobilizePasswordSetting")) ?? false
    var deviceCounter:Int = 0
    var failedDevices:String = ""
    
    fileprivate func navigationBarButtons() {
        navigationItem.title = "Immoblize"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sync"), style: .plain, target: self, action: #selector(requestForSyncing))
    }
    
    fileprivate func initializeTheData() {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        allDevices = RCGlobals.getExpiryFilteredList(data)
        currentImmobilizeDevices = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices")) ?? []
        if(currentImmobilizeDevices.count > 0) {
            immobilzeView.immobilizeAllButton.image = #imageLiteral(resourceName: "immobilizeButton")
            immobilzeView.segmentedController.selectedSegmentIndex = 1
            selectedIndex = 1
            immobilzeView.immobilizeAllLabel.text = "Mobilize all vehicles"
        } else {
            immobilzeView.immobilizeAllLabel.text = "Immobilize all vehicles"
            immobilzeView.immobilizeAllButton.image = #imageLiteral(resourceName: "immobilizeGrey")
            immobilzeView.segmentedController.selectedSegmentIndex = 0
        }
    }
    
    fileprivate func viewsDelagateAndGestures() {
        immobilzeView.tableView.delegate = self
        immobilzeView.tableView.dataSource = self
        immobilzeView.searchBar.delegate = self
        immobilzeView.tableView.register(RCImmobilizeTableViewCell.self, forCellReuseIdentifier: "immobilize")
        immobilzeView.segmentedController.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        immobilzeView.immobilizeAllButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(immobilizeTaped(_:))))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImmobilizeView()
        setConstraints()
        viewsDelagateAndGestures()
        initializeTheData()
        navigationBarButtons()
        addDoneButtonOnKeyboard()
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        immobilzeView.searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        immobilzeView.searchBar.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.immobilizeSyncRequest(loading: "")
        for device in allDevices {
            if device.lastUpdate != nil {
                onlineDevices.append(device)
            }
        }
        currentImmobilizeDevices.forEach { (i) in
            onlineDevices = onlineDevices.filter( { $0.id != i.id } ).map( { $0 } )
        }
        immobilzeView.tableView.reloadData()
    }
    func setConstraints(){
        immobilzeView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
              make.edges.equalToSuperview()
            }
        }
    }
    
    func addImmobilizeView() -> Void {
        immobilzeView = ImmobilizeView(frame: CGRect.zero)
        view.addSubview(immobilzeView)
        view.backgroundColor = .white
        
        let blueToothGuesture = UITapGestureRecognizer(target: self, action: #selector(openBlueToothView(_:)))
        blueToothGuesture.numberOfTouchesRequired = 1
        immobilzeView.topView.addGestureRecognizer(blueToothGuesture)
    }
    @objc func openBlueToothView(_ sender: UITapGestureRecognizer){
        let vc = BlueToothViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: false, completion: nil)
    }
    @objc func moveToBluetoothImmobiliseScreenPressed () {
        
        //        print("pressed ble")
        //
        //          let vcBlE = BLEconnectVC()
        //
        //        let transition:CATransition = CATransition()
        //           transition.duration = 0.5
        //           transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //           transition.type = kCATransitionPush
        //           transition.subtype = kCATransitionFromBottom
        //           self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        //           self.navigationController?.pushViewController(vcBlE, animated: false)
    }
    @objc func immobilizeTaped(_ sender: UITapGestureRecognizer) {
        print("immobilize all vehicle")
        if self.immobilizeFlagCheck == true {
            let alertController = UIAlertController(title: "Are you sure?", message: "Attention! Pressing 'Yes' will immobilize all your vehicles.", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "******"
                textField.font = UIFont.systemFont(ofSize: 20)
                textField.textAlignment = .center
                textField.textColor = .black
                textField.isSecureTextEntry = true
            }
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                let alerttext =  alertController.textFields?.first?.text
                let keychain = Keychain(service: "in.roadcast.bolt")
                let password: String = {
                    do {
                        return try keychain.getString("boltPassword") ?? ""
                    } catch {
                        return ""
                    }
                }()
                if alerttext == password {
                    if self.selectedIndex == 0 {
                        self.immobilizeAllDevices()
                    } else {
                        self.mobilizeAllDevices()
                    }
                }
                else {
                    self.prompt("Please enter a valid password")
                }
            }
            ))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            
            if selectedIndex == 0 {
                immobilizeAllDevices()
            } else {
                mobilizeAllDevices()
            }
            
        }
    }
    
    func immobilizeAllDevices() {
        if onlineDevices.count > 0 {
            deviceCounter = 0
            failedDevices = ""
            handleImmobilizeAllDevices()
//            for (index, devices) in onlineDevices.enumerated() {
//                    requestForImmobilization(id: devices.id, commandType: "engineStop", row: index, selectedValue: selectedIndex) { (status) in
//                        print(status)
//                    }
//            }
//            self.immobilizeSyncRequest(loading: "")
//            self.immobilzeView.segmentedController.selectedSegmentIndex = 1
//            self.selectedIndex = 1
//            self.immobilzeView.tableView.reloadData()
        } else {
            prompt("There are no vehicles to immobilize")
        }
        //        }
    }
    
    func handleImmobilizeAllDevices() {
        if deviceCounter < onlineDevices.count {
            requestForImmobilization(id: onlineDevices[deviceCounter].id, commandType: "engineStop", row: deviceCounter, selectedValue: selectedIndex) { (status) in
                print(status)
                if !status {
                    self.failedDevices = self.failedDevices + "\(self.deviceCounter + 1):- \(self.onlineDevices[self.deviceCounter].name ?? ""),\n"
                }
                self.deviceCounter += 1
                self.handleImmobilizeAllDevices()
            }
        } else {
            self.deviceCounter = 0
            self.immobilizeSyncRequest(loading: "")
            self.immobilzeView.segmentedController.selectedSegmentIndex = 1
            self.selectedIndex = 1
            immobilzeView.immobilizeAllLabel.text = "Mobilize all vehicles"
            self.immobilzeView.tableView.reloadData()
            if !failedDevices.isEmpty {
                self.failedDevices = self.failedDevices.trimmingCharacters(in: .newlines)
                self.failedDevices = self.failedDevices.trimmingCharacters(in: .whitespaces)
                self.failedDevices.removeLast()
                self.prompt("Failed to immobilize following devices:-\n \(failedDevices)")
            }
        }
    }
    
    func mobilizeAllDevices() {
        if currentImmobilizeDevices.count > 0 {
//            for (index, devices) in currentImmobilizeDevices.enumerated() {
//                    requestForImmobilization(id: devices.id, commandType: "engineResume", row: index, selectedValue: selectedIndex) { (status) in
//                        print(status)
//                    }
//            }
//            self.immobilizeSyncRequest(loading: "")
//            //self.immobilzeView.tableView.reloadData()
//            self.immobilzeView.segmentedController.selectedSegmentIndex = 0
//            self.selectedIndex = 0
//            self.immobilzeView.tableView.reloadData()
            deviceCounter = 0
            failedDevices = ""
            handleMobilizeAllDevices()
        } else {
            prompt("There are no vehicles to mobilize")
        }
    }
    
    func handleMobilizeAllDevices() {
        if deviceCounter < currentImmobilizeDevices.count {
            requestForImmobilization(id: currentImmobilizeDevices[deviceCounter].id, commandType: "engineResume", row: deviceCounter, selectedValue: selectedIndex) { (status) in
                print(status)
                if !status {
                    self.failedDevices = self.failedDevices + "\(self.deviceCounter + 1):- \(self.currentImmobilizeDevices[self.deviceCounter].name ?? ""),\n"
                }
                self.deviceCounter += 1
                self.handleMobilizeAllDevices()
            }
        } else {
            self.deviceCounter = 0
            self.immobilizeSyncRequest(loading: "")
            self.immobilzeView.segmentedController.selectedSegmentIndex = 0
            self.selectedIndex = 0
            immobilzeView.immobilizeAllLabel.text = "Immobilize all vehicles"
            self.immobilzeView.tableView.reloadData()
            if !failedDevices.isEmpty {
                self.failedDevices = self.failedDevices.trimmingCharacters(in: .newlines)
                self.failedDevices = self.failedDevices.trimmingCharacters(in: .whitespaces)
                self.failedDevices.removeLast()
                self.prompt("Failed to mobilize following devices:-\n \(failedDevices)")
            }
        }
    }
    
    func updateDeviceStatus() {
        if sentDevicesSuccess.count > 0 && commandType == "engineStop" {
            Defaults().set(sentDevicesSuccess, for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices"))
            immobilzeView.immobilizeAllButton.image = #imageLiteral(resourceName: "immobilizeButton")
        }else {
            sentDevicesSuccess.removeAll()
            Defaults().set([], for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices"))
            immobilzeView.immobilizeAllButton.image = #imageLiteral(resourceName: "immobilizeGrey")
        }
        
        currentImmobilizeDevices = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices")) ?? []
        immobilzeView.tableView.reloadData()
        selectedCells.removeAll()
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func requestForSyncing() {
        immobilizeSyncRequest(loading: "Syncing...")
    }
    
    func immobilizeSyncRequest(loading:String){
        RCLocalAPIManager.shared.syncVehicleModes(loadingMsg:loading ,success: { [weak self] model in
            guard let weakself = self else { return }
            weakself.syncTheImmobilizedData(temp: (model.data?.owlMode)!)
        }) { [weak self] message in
            guard let weakself = self else { return }
            weakself.prompt(message)
            weakself.prompt("please try again")
            print("reason :\(message)")
        }
    }

    
    func syncTheImmobilizedData(temp: [String]) {
        currentImmobilizeDevices.removeAll()
        onlineDevices.removeAll()
        
        var immobilizedVehicle = [Int]()
        immobilizedVehicle = temp.map( { Int($0)! } )
        immobilizedVehicle.forEach( { (i) in
            if let device = allDevices.filter( { $0.id == i } ).first {
                currentImmobilizeDevices.append(device)
            }
        } )
        
        Defaults().set(currentImmobilizeDevices, for: Key<[TrackerDevicesMapperModel]> ("immobilizeDevices"))
        
        onlineDevices = allDevices
        currentImmobilizeDevices.forEach { (i) in
            onlineDevices = onlineDevices.filter( { $0.id != i.id } ).map( { $0 } )
        }
        
        immobilzeView.tableView.reloadData()
    }
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            immobilzeView.immobilizeAllLabel.text = "Immobilize all vehicles"
            isSearching = false
        } else {
            immobilzeView.immobilizeAllLabel.text = "Mobilize all vehicles"

            isSearching = false
        }
        immobilzeView.tableView.reloadData()
    }
    @objc func checkIfImmobilizePasswordEnable(_ sender:UIButton){
        print("cell tapped")
        if self.immobilizeFlagCheck == true {
            let alertController = UIAlertController(title: "Are you sure?", message: "Attention! Enabling immobilize mode will immobilize your vehicle", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "******"
                textField.font = UIFont.systemFont(ofSize: 20)
                textField.textAlignment = .center
                textField.textColor = .black
                textField.isSecureTextEntry = true
            }
            alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                let alerttext =  alertController.textFields?.first?.text
                let keychain = Keychain(service: "in.roadcast.bolt")
                let password: String = {
                    do {
                        return try keychain.getString("boltPassword") ?? ""
                    } catch {
                        return ""
                    }
                }()
                if alerttext == password {
                    self.actionToSingleDevice(sender)
                }
                else {
                    self.prompt("Please enter a valid password")
                }
            }
            ))
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            actionToSingleDevice(sender)
        }
    }
    @objc func actionToSingleDevice(_ sender: UIButton) {
        print(sender.tag)
        let index = IndexPath(row: sender.tag, section: 0)
        let cell = immobilzeView.tableView.cellForRow(at: index) as! RCImmobilizeTableViewCell
        
        if cell.actionButton.currentImage == #imageLiteral(resourceName: "newRedNotification") {
            var selectedDevice = self.onlineDevices[sender.tag]
            if isSearching {
                selectedDevice = self.filteredDevices[sender.tag]
            }
            prompt("Activate immobilize mode", "Are you sure you want to activate immobilize mode to this vehicle", "Yes", "No", handler1: { (_) in
                self.requestForImmobilization(id: selectedDevice.id, commandType: "engineStop", row: sender.tag, selectedValue: self.selectedIndex) { (value) in
                    self.immobilzeView.immobilizeAllLabel.text = "Immobilize all vehicles"
                    self.immobilzeView.segmentedController.selectedSegmentIndex = 1
                    self.selectedIndex = 1
                    self.immobilzeView.tableView.reloadData()
                    if value {
                        cell.actionButton.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
                    } else {
                        self.prompt("Unable to immobilize, due to weak internet.")
                    }
                }
            }, handler2: { (_) in return })
            
        } else {
            var selectedDevice = self.currentImmobilizeDevices[sender.tag]
            if isSearching {
                selectedDevice = self.filteredDevices[sender.tag]
            }
            prompt("Disable immobilize mode", "Are you sure you want to disable immobilize mode to this vehicle", "Yes", "No", handler1: { (_) in
                self.requestForImmobilization(id: selectedDevice.id, commandType: "engineResume", row: sender.tag, selectedValue: self.selectedIndex) { (value) in
                    self.immobilzeView.immobilizeAllLabel.text = "Mobilize all vehicles"
                    self.immobilzeView.segmentedController.selectedSegmentIndex = 0
                    self.selectedIndex = 0
                    self.immobilzeView.tableView.reloadData()
                    if value {
                        cell.actionButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    } else {
                        self.prompt("Unable to mobilize, due to weak internet.")
                        
                    }
                }
            }, handler2: { (_) in return })
        }
    }
    
    
    fileprivate func requestForImmobilization(id: Int, commandType: String, row: Int, selectedValue: Int, onCompletion: @escaping (Bool) -> Void) {
        RCLocalAPIManager.shared.owlModeOnOff(with: id, type: commandType, success: { [weak self] hash in
            guard let weakself = self else { return }
            if selectedValue == 0 {
                //                let index = IndexPath(row: row, section: 0)
                var selectedDeviceRow = weakself.onlineDevices[row]
                if weakself.isSearching {
                    selectedDeviceRow = weakself.filteredDevices[row]
                }
                weakself.currentImmobilizeDevices.append(selectedDeviceRow)
                Defaults().set(weakself.currentImmobilizeDevices, for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices"))
                if weakself.isSearching {
                    weakself.filteredDevices.remove(at: row)
                    weakself.onlineDevices = weakself.onlineDevices.filter { $0.id != id }
                }else {
                    weakself.onlineDevices.remove(at: row)
                }
                //                weakself.immobilzeView.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.left)
                weakself.immobilzeView.tableView.reloadData()
                onCompletion(true)
            } else {
                //                let index = IndexPath(row: row, section: 0)
                var selectedDeviceRow = weakself.currentImmobilizeDevices[row]
                if weakself.isSearching {
                    selectedDeviceRow = weakself.filteredDevices[row]
                }
                weakself.onlineDevices.append(selectedDeviceRow)
                if weakself.isSearching {
                    weakself.filteredDevices.remove(at: row)
                    weakself.currentImmobilizeDevices = weakself.currentImmobilizeDevices.filter { $0.id != id }
                }else {
                    weakself.currentImmobilizeDevices.remove(at: row)
                }
                Defaults().set(weakself.currentImmobilizeDevices, for: Key<[TrackerDevicesMapperModel]>("immobilizeDevices"))
                //                weakself.immobilzeView.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.left)
                weakself.immobilzeView.tableView.reloadData()
                onCompletion(true)
            }
        }) { [weak self] message in
            guard let weakSelf = self else { return }
            onCompletion(false)
//            weakSelf.prompt("please try again")
            print(message)
        }
    }
    @objc func backPressed() -> Void {
        self.dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredDevices.count
        } else {
            if selectedIndex == 1 {
                return currentImmobilizeDevices.count
            } else {
                return onlineDevices.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "immobilize", for: indexPath) as! RCImmobilizeTableViewCell
        cell.selectionStyle = .none
        cell.actionButton.tag = indexPath.row
        cell.actionButton.addTarget(self, action: #selector(checkIfImmobilizePasswordEnable(_:)), for: .touchUpInside)
        if isSearching {
            cell.label.text = filteredDevices[indexPath.row].name
        } else {
            if selectedIndex == 1 {
                cell.actionButton.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
                cell.label.text = currentImmobilizeDevices[indexPath.row].name
            } else {
                cell.actionButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                cell.label.text = onlineDevices[indexPath.row].name
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
}
extension ImmobilizeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredDevices.removeAll()
        if selectedIndex == 0 {
            if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                isSearching = false
            } else {
                isSearching = true
                filteredDevices = onlineDevices.filter({
                    $0.name?.lowercased().contains(searchText.lowercased()) ?? false
                })
            }
            
        }else {
            
            if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
                isSearching = false
            } else {
                isSearching = true
                filteredDevices = currentImmobilizeDevices.filter({
                    $0.name?.lowercased().contains(searchText.lowercased()) ?? false
                })
            }
        }
        immobilzeView.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        isSearching = false
        filteredDevices.removeAll()
        immobilzeView.tableView.reloadData()
        searchBar.endEditing(true)
    }
}

extension ImmobilizeViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func sendTextMessage(number: String, message: String) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = message
        messageVC.recipients = [number]
        messageVC.messageComposeDelegate = self
        
        self.present(messageVC, animated: true, completion: nil)
    }
}
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

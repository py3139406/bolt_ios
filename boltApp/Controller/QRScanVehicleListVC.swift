//
//  QRScanVehicleListVC.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class QRScanVehicleListVC: UIViewController {
    //MARK: properties
    let screenSize = UIScreen.main.bounds.size
    var vehicleTable:UITableView!
    var filtered:[TrackerDevicesMapperModel] = []
    var isSearching:Bool = false
    var addsearchBar:UISearchBar!
    var filteredData: [String]!
    var deviceList:[TrackerDevicesMapperModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        addNavigationBar()
        addScreenView()
        addConstraints()
        addDoneButtonOnKeyboard()
        addAction()
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()
        deviceList = RCGlobals.getExpiryFilteredList(data)
        
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        addsearchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        addsearchBar.endEditing(true)
    }
    
    func addAction(){
        vehicleTable.delegate = self
        vehicleTable.dataSource = self
        vehicleTable.register(MultiShareTableCell.self, forCellReuseIdentifier: "qr_device_cell")
        vehicleTable.reloadData()
    }
    
    func addScreenView(){
        
        vehicleTable = UITableView(frame: CGRect.zero)
        vehicleTable.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 59/255, alpha: 1)
        vehicleTable.bounces = false
        view.addSubview(vehicleTable)
        
        addsearchBar = UISearchBar()
        addsearchBar.placeholder = "Search Device"
        addsearchBar.barStyle = .default
        addsearchBar.barTintColor = .white
        addsearchBar.backgroundColor = .white
        addsearchBar.delegate = self
        view.addSubview(addsearchBar)
        
    }
    func addConstraints(){
        
        addsearchBar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                // Fallback on earlier versions
                make.top.equalToSuperview().offset(screenSize.height * 0.002)
            }
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(screenSize.height * 0.06)
        }
        vehicleTable.snp.makeConstraints { (make) in
            make.top.equalTo(addsearchBar.snp.bottom)
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
    }
    private func addNavigationBar() {
        self.navigationItem.title = "QRSCAN AND CALL"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        let textFont = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16, weight: .medium)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textFont
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        let myImage = UIImage(named: "scan_and_request_call")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: myImage?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal),style: .plain, target: nil, action: nil)
    }
    
    @objc  func backButtonTapped() {
       self.dismiss(animated: true, completion: nil)
    }
    
}
extension QRScanVehicleListVC:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearching) {
            return filtered.count
        } else {
            return deviceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qr_device_cell", for: indexPath) as! MultiShareTableCell
        
        if(isSearching) {
            cell.vehicleName.text = filtered[indexPath.row].name ?? ""
            cell.shareBtn.tag = indexPath.row
        } else {
            cell.vehicleName.text = deviceList[indexPath.row].name ?? ""
            cell.shareBtn.tag = indexPath.row
        }
        
        cell.selectionStyle = .none
        cell.shareBtn.setImage(UIImage(named: "backimg"), for: .normal)
        cell.shareBtn.addTarget(self, action: #selector(tapOnNextButton(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            moveToNextScreen(filtered[indexPath.row])
        } else {
            moveToNextScreen(deviceList[indexPath.row])
        }
    }
    
    @objc func tapOnNextButton(_ sender: UIButton) {
        let index = sender.tag
        if isSearching {
            moveToNextScreen(filtered[index])
        } else {
            moveToNextScreen(deviceList[index])
        }
    }
    
    func moveToNextScreen(_ device: TrackerDevicesMapperModel) {
        let vc = DeviceScanQRVC()
        vc.device = device
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension QRScanVehicleListVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filtered = deviceList.filter({
                ($0.name ?? "").lowercased().contains(searchText.trimmingCharacters(in: .whitespaces).lowercased())
            })
        }
        vehicleTable.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        addsearchBar.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addsearchBar.endEditing(true)
    }
}

//
//  EditVehicleInfoController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class LoadUnloadSelectVehicleViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var editVehicleInfo: LoadUnloadSelectVehicleView!
    private let cellIdentifier = "EditVehicle"
    private var isFilter = false
    private var allDevices = [TrackerDevicesMapperModel]()
    private var filterDevices = [TrackerDevicesMapperModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addNavigationBar()
        addConstraints()
        addActions()
        addDoneButtonOnKeyboard()
    }
    func addActions(){
        editVehicleInfo.searchBar.delegate = self
        editVehicleInfo.vehicleTable.delegate = self
        editVehicleInfo.vehicleTable.dataSource = self
        editVehicleInfo.vehicleTable.register(EditVehicleInfoCell.self, forCellReuseIdentifier: cellIdentifier)
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        allDevices = RCGlobals.getExpiryFilteredList(data)
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        editVehicleInfo.searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        editVehicleInfo.searchBar.endEditing(true)
    }
    func addConstraints(){
        editVehicleInfo.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    private func addViews() {
        editVehicleInfo = LoadUnloadSelectVehicleView(frame: CGRect.zero)
        view.addSubview(editVehicleInfo)
        view.backgroundColor = appDarkTheme
    }
    
    private func addNavigationBar() {
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        isFilter = false
        editVehicleInfo.vehicleTable.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterDevices = allDevices.filter( {
            if ($0.name?.localizedLowercase.contains(searchText.lowercased()))! {
                return true
            } else {
                return false
            }
        } )
        if searchBar.text != "" {
            isFilter = true
        } else {
            isFilter = false
        }
       
        editVehicleInfo.vehicleTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.08
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filterDevices.count
        } else {
            return allDevices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EditVehicleInfoCell
        cell.selectionStyle = .none
        if isFilter {
            cell.carLabel.text = filterDevices[indexPath.row].name
        } else {
            cell.carLabel.text = allDevices[indexPath.row].name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editDetails = LoadUnloadViewController()
        var deviceId:Int = 0
        var deviceName:String = "N/A"
        
        if isFilter {
            deviceId = filterDevices[indexPath.row].id ?? 0
            deviceName = filterDevices[indexPath.row].name ?? "N/A"
        } else {
            deviceId = allDevices[indexPath.row].id ?? 0
            deviceName = allDevices[indexPath.row].name ?? "N/A"
        }
        
        Defaults().set(deviceId, for: Key<Int>(defaultKeyNames.currentLoadingDeviceId.rawValue))
        Defaults().set(deviceName, for: Key<String>(defaultKeyNames.currentLoadingDeviceName.rawValue))
        
        let loadUnloadId:String = RCGlobals.getLastLoadUnloadForToday(deviceId: "\(deviceId)")
        if loadUnloadId != "" {
            isLastLoading = true
        } else {
            isLastLoading = false
        }
        editDetails.titleNaviagtionBar = deviceName
        self.navigationController?.pushViewController(editDetails, animated: true)
    }
    
}

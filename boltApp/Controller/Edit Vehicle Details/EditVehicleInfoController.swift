//
//  EditVehicleInfoController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class EditVehicleInfoController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var editVehicleInfo: EditVehicleInfoView!
    private let cellIdentifier = "EditVehicle"
    private var isFilter = false
    private var allDevices = [TrackerDevicesMapperModel]()
    private var filterDevices = [TrackerDevicesMapperModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setConstraints()
        addNavigationBar()
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
        
        editVehicleInfo.searchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        editVehicleInfo.searchBar.endEditing(true)
    }
    
    private func addViews() {
        editVehicleInfo = EditVehicleInfoView(frame: CGRect.zero)
        view.addSubview(editVehicleInfo)
        view.backgroundColor = appDarkTheme
        editVehicleInfo.searchBar.delegate = self
        editVehicleInfo.vehicleTable.delegate = self
        editVehicleInfo.vehicleTable.dataSource = self
        editVehicleInfo.vehicleTable.register(EditVehicleInfoCell.self, forCellReuseIdentifier: cellIdentifier)
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        allDevices = RCGlobals.getExpiryFilteredList(data)
        
        editVehicleInfo.addBtn.addTarget(self, action: #selector(addNewDevice), for: .touchUpInside)
        
    }
    
    @objc func addNewDevice(){
        self.navigationController?.pushViewController(UserInfoViewController(), animated: true)
    }
    
    func setConstraints(){
        editVehicleInfo.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func addNavigationBar() {
        self.navigationItem.title = "VEHICLE DETAILS"
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
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.setShowsCancelButton(true, animated: true)
//        isFilter = true
//        return true
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterDevices = allDevices.filter( {
            if ($0.name?.localizedLowercase.contains(searchText.lowercased()))! {
                return true
            } else {
                return false
            }
        } )
        if searchText != "" {
            isFilter = true
        }else {
        isFilter = false
        }
        print("did change")
        editVehicleInfo.vehicleTable.reloadData()
    }
    @objc func showVehicleDetails(_ sender:UIButton){
        if isFilter {
            let editDetails = EditVehicleDetailsController()
            editDetails.titleNaviagtionBar = filterDevices[sender.tag].name!
            editDetails.deviceId = String(filterDevices[sender.tag].id!)
            self.navigationController?.pushViewController(editDetails, animated: true)
        } else {
            let editDetails = EditVehicleDetailsController()
            editDetails.titleNaviagtionBar = allDevices[sender.tag].name!
            editDetails.deviceId = String(allDevices[sender.tag].id!)
            self.navigationController?.pushViewController(editDetails, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(showVehicleDetails(_:)), for: .touchUpInside)
        if isFilter {
            cell.carLabel.text = filterDevices[indexPath.row].name
        } else {
            cell.carLabel.text = allDevices[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFilter {
            let editDetails = EditVehicleDetailsController()
            editDetails.titleNaviagtionBar = filterDevices[indexPath.row].name!
            editDetails.deviceId = String(filterDevices[indexPath.row].id!)
            self.navigationController?.pushViewController(editDetails, animated: true)
        } else {
            let editDetails = EditVehicleDetailsController()
            editDetails.titleNaviagtionBar = allDevices[indexPath.row].name!
            editDetails.deviceId = String(allDevices[indexPath.row].id!)
            self.navigationController?.pushViewController(editDetails, animated: true)
        }
    }
    
}

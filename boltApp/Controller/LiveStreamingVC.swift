//
//  LiveStreamingVC.swift
//  Bolt
//
//  Created by Roadcast on 14/08/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class LiveStreamingVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var editVehicleInfo: EditVehicleInfoView!
    private let cellIdentifier = "EditVehicle"
    private var isFilter = false
    private var allDevices = [TrackerDevicesMapperModel]()
    private var filterDevices = [TrackerDevicesMapperModel]()
    var isSelectedStreamingOption  = false
    
    var devices : [TrackerDevicesMapperModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.backgroundColor = .white
        addViews()
        addNavigationBar()
        offStreaming()
        editVehicleInfo.addBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        
        allDevices = RCGlobals.getExpiryFilteredList(data)
        
        let positionsDevices = Defaults().get(for: Key<[TrackerPositionMapperModel]>("allPositions"))!
        
        
        // devices = allDevices
        for i in positionsDevices {
            let deviceProtocol = ["jc".lowercased() , "boltcam".lowercased()]
            if (i.protocl?.contains(deviceProtocol[0]))! || (i.protocl?.contains(deviceProtocol[1]))! {
                
                print("i is \(i.deviceId!)")
                
                
                for j in allDevices {
                    
                    if j.id! == i.deviceId! {
                        
                        devices.append(j)
                    }
                    
                }
                
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        offStreaming()
    }
    
    func offStreaming() {
        
        if let streamingDeviceId = Defaults().get(for: Key<Int>("streamingDeviceId")) {
            
            let status:String = Defaults().get(for: Key<String>(defaultKeyNames.streamingCamera.rawValue)) ?? streamCamera.inside.rawValue
            
            let parameters:[String:Any] = RCGlobals.getStreamingData(deviceId: streamingDeviceId, camera: status, streamState: streamStatus.stop.rawValue)
            
            RCLocalAPIManager.shared.liveStreaming(loadingMsg: "Loading", deviceID: streamingDeviceId, parameters: parameters, success: { (success) in
                
                print("device streaming stopped")
                
            }) { (err ) in
                
                print("device streaming not stopped")
                
            }
        }
    }
    
    private func addViews() {
        editVehicleInfo = EditVehicleInfoView(frame: CGRect.zero)
        view.addSubview(editVehicleInfo)
        view.backgroundColor = appDarkTheme
        editVehicleInfo.searchBar.delegate = self
        editVehicleInfo.vehicleTable.delegate = self
        editVehicleInfo.vehicleTable.dataSource = self
        editVehicleInfo.vehicleTable.register(EditVehicleInfoCell.self, forCellReuseIdentifier: cellIdentifier)
        setConstraints()
        
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
        self.navigationItem.title = "LIVE STREAMING"
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
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        isFilter = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            isFilter = false
        } else {
            filterDevices = devices.filter( {
                if ($0.name?.localizedLowercase.contains(searchText.lowercased()))! {
                    return true
                } else {
                    return false
                }
            } )
            isFilter = true
        }
        editVehicleInfo.vehicleTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return filterDevices.count
        } else {
            return devices.count
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EditVehicleInfoCell
        cell.selectionStyle = .none
        if isFilter {
            cell.carLabel.text = filterDevices[indexPath.row].name
        } else {
            cell.carLabel.text = devices[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var name: String = ""
        var deviceId: Int = 0
        var imeiNumber = "0"
        
        if self.isFilter {
            
            name = self.filterDevices[indexPath.row].name!
            deviceId = self.filterDevices[indexPath.row].id ?? 0
            imeiNumber = self.filterDevices[indexPath.row].uniqueId!
            
        } else {
            
            name = self.devices[indexPath.row].name!
            deviceId = self.devices[indexPath.row].id ?? 0
            imeiNumber = self.devices[indexPath.row].uniqueId!
        }
        
        self.prompt("", "Select which camera to show", "IN", "OUT", thirdButtoneText: "CANCEL", handler1: { (in) in
            let streamingVC = LiveStreamingShowVC()
            streamingVC.lsDevicename = name
            streamingVC.lsDevicedeviceId = deviceId
            streamingVC.lsDeviceimeiNumber = imeiNumber
            streamingVC.isBoltCam = RCGlobals.isDeviceBoltCam(deviceId: deviceId)
            self.requestForLiveStreaming(status: streamCamera.inside.rawValue, dId: deviceId, state: streamStatus.start.rawValue,streamingVC:streamingVC)
            
        }) { (out) in
            let streamingVC = LiveStreamingShowVC()
            streamingVC.lsDevicename = name
            streamingVC.lsDevicedeviceId = deviceId
            streamingVC.lsDeviceimeiNumber = imeiNumber
            streamingVC.isBoltCam = RCGlobals.isDeviceBoltCam(deviceId: deviceId)
            self.requestForLiveStreaming(status: streamCamera.outside.rawValue, dId: deviceId, state: streamStatus.start.rawValue,streamingVC:streamingVC)
            
        }
        
    }
    func requestForLiveStreaming(status:String , dId:Int,state:Int,streamingVC:LiveStreamingShowVC){
        let parameters:[String:Any] = RCGlobals.getStreamingData(deviceId: dId, camera: status, streamState: state)
        RCLocalAPIManager.shared.liveStreaming(loadingMsg:"Loading...",deviceID: dId, parameters: parameters, success: {
            
            (success) in
            
            print("success")
            
            Defaults().set(status, for: Key<String>(defaultKeyNames.streamingCamera.rawValue))
            
            self.navigationController?.pushViewController(streamingVC, animated: true)
            
        }, failure: { (failure) in
            
            self.prompt(failure)
        })
    }
    
}

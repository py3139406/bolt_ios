//
//  GeoViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit



class GeoViewController: UIViewController{
    
    var geoImages = [#imageLiteral(resourceName: "circle"),#imageLiteral(resourceName: "square"),#imageLiteral(resourceName: "polyline"),#imageLiteral(resourceName: "square"),#imageLiteral(resourceName: "polyline")]
    var segmentZeroView: GeofenceSegmentGeofenceView!
    var segmentOneView: GeofenceSegmentVehicleView!
    var geoObj: GeoFenceView!
    var allGeofences: [GeofenceModel] = []
    var devicesGeofences: [GeofenceModel] = []
    lazy var devicesPicker = UIPickerView()
    var overlayButton: UIButton!
    var allDevices:[TrackerDevicesMapperModel]!
    var selectedVehicleIndex:Int!
    var selectedSegmentIndex:Int = 0
    var isShowDevicesGeofence:Bool = false
    let reuseIdentifier = "geoCellId"
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setActions()
        
        allDevices = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("allDevices"))
        getGeofences(msg: "getting geofences..")
        setUpPickerViews()
        
        // Do any additional setup after loading the view.
    }
    func setConstraints(){
        geoObj.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        segmentZeroView.snp.makeConstraints { (make) in
            make.top.equalTo(geoObj.snp.bottom).offset(10)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        segmentOneView.snp.makeConstraints { (make) in
            make.top.equalTo(geoObj.snp.bottom).offset(10)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    func setViews(){
        view.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "globeBlack").resizedImage(CGSize.init(width: 25.0, height: 25.0), interpolationQuality: .default), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.title = "Geofence"
        
        geoObj = GeoFenceView()
        segmentZeroView = GeofenceSegmentGeofenceView()
        segmentOneView = GeofenceSegmentVehicleView()
        //  geoObj.viewBysegment.addSubview(segmentZeroView)
        view.addSubview(geoObj)
        view.addSubview(segmentZeroView)
        view.addSubview(segmentOneView)
        segmentZeroView.isHidden = false
        segmentOneView.isHidden = true
    }
    func setActions(){
        geoObj.segmentedController.addTarget(self, action: #selector((segmentTapped)), for: .valueChanged)
        // self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        segmentZeroView.geoTableView.register(GeoFenceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        segmentOneView.myTableView.register(GeoFenceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        segmentZeroView.geoTableView.dataSource = self
        segmentZeroView.geoTableView.delegate = self
        segmentZeroView.geoTableView.allowsSelection = true
        
        segmentOneView.myTableView.dataSource = self
        segmentOneView.myTableView.delegate = self
        segmentOneView.myTableView.allowsSelection = true
        segmentOneView.myTableView.allowsMultipleSelection = true
        
        segmentZeroView.addButton.addTarget(self, action: #selector(addGeofence), for: .touchUpInside)
        segmentOneView.selectVehicleLabel.inputView = devicesPicker
        
        segmentOneView.searchButton.addTarget(self, action: #selector(searchButtonTap), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.overlayButton.removeFromSuperview()
    }
    @objc func selectVehicle(){
        self.overlayButton.alpha = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        getGeofences(msg: "")
    }
    
    @objc func searchButtonTap(){
        devicesGeofences = []
        if (segmentOneView.selectVehicleLabel.text?.isEmpty)! {
            self.showalert("Please select vehicle".toLocalize)
        }else{
            self.getDevicesGeofences()
        }
    }
    
    func getDevicesGeofences() {
        RCLocalAPIManager.shared.getGeofences(loadingMsg: "fetching geofences...", with: "deviceId", id: allDevices[selectedVehicleIndex].id!, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.isShowDevicesGeofence = true
            weakSelf.devicesGeofences = hash
            
            weakSelf.showGeofences()
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt(message)
        }
    }
    
    @objc func cancelButtonDidTapped(_ sender: AnyObject) {
        self.overlayButton.alpha = 0
        //        self.overlayButton.removeFromSuperview()
        segmentOneView.selectVehicleLabel.endEditing(true)
    }
    
    @objc func donePicker(){
        self.overlayButton.alpha = 0
        if(segmentOneView.selectVehicleLabel.text?.count == 0 && allDevices.count > 0) {
            selectedVehicleIndex = 0
            segmentOneView.selectVehicleLabel.text = allDevices[0].name
        }
        segmentOneView.selectVehicleLabel.endEditing(true)
        isShowDevicesGeofence = false
        segmentOneView.myTableView.reloadData()
    }
    
    @objc func addGeofence(){
        self.navigationController?.pushViewController(GeoFenceMapViewController(), animated: true)
    }
    
    @objc func segmentTapped(sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        //        Defaults().set([], for: Key<[GeofenceModel]>("allUserGeofenceModel"))
        allGeofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel")) ?? []
        
        switch sender.selectedSegmentIndex {
        case 0:
            //            geoObj.viewBysegment.subviews.forEach({ $0.removeFromSuperview() })
            //            geoObj.viewBysegment.addSubview(segmentZeroView)
            segmentZeroView.isHidden = false
            segmentOneView.isHidden = true
            getGeofences(msg: "")
        case 1:
            //            geoObj.viewBysegment.subviews.forEach({ $0.removeFromSuperview() })
            //            geoObj.viewBysegment.addSubview(segmentOneView)
            segmentZeroView.isHidden = true
            segmentOneView.isHidden = false
            segmentOneView.myTableView.reloadData()
            
        default:
            print("ERROR")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpPickerViews() -> Void {
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped(_:)), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: segmentOneView) { segmentOneView.addSubview(overlayButton) }
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        segmentOneView.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: segmentOneView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: segmentOneView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: segmentOneView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: segmentOneView, attribute: .trailing, multiplier: 1, constant: 0)
        ]
        )
        
        
        devicesPicker.showsSelectionIndicator = true
        devicesPicker.delegate = self
        devicesPicker.dataSource = self
        devicesPicker.tag = 1
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done".toLocalize, style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        let titleButton = UIBarButtonItem(title: "Select Vehicle".toLocalize, style:UIBarButtonItem.Style.plain, target: nil, action: nil)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([titleButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        segmentOneView.selectVehicleLabel.inputAccessoryView = toolBar
    }
    
    func getGeofences(msg:String) {
        let id = Int(Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0")
        RCLocalAPIManager.shared.getGeofences(loadingMsg: msg, with: "userId", id: id!, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            Defaults().set(hash, for: Key<[GeofenceModel]>("allUserGeofenceModel"))
            weakSelf.showGeofences()
            
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt(message)
        }
    }
    
    func showGeofences() {
        allGeofences = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel")) ?? []
        segmentZeroView.geoTableView.reloadData()
        segmentOneView.myTableView.reloadData()
    }
    
    func getGeoImageType(type: String) -> UIImage {
        
        let type = type.lowercased()
        var geoImageType = #imageLiteral(resourceName: "circle")
        
        switch type {
        case "circle":
            geoImageType = #imageLiteral(resourceName: "circle").resizedImage(CGSize.init(width: 22, height: 22), interpolationQuality: .default)
            
        case "polyline":
            geoImageType = #imageLiteral(resourceName: "polyline").resizedImage(CGSize.init(width: 26, height: 22), interpolationQuality: .default)
            
        case "polygon":
            geoImageType = #imageLiteral(resourceName: "square").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default)
            
        default:
            geoImageType = #imageLiteral(resourceName: "circle").resizedImage(CGSize.init(width: 22, height: 22), interpolationQuality: .default)
            
        }
        return geoImageType
    }
    
    func linkGeofence(geoFenceId: Int) {
        RCLocalAPIManager.shared.linkGeofence(with: allDevices[selectedVehicleIndex].id!, geofenceId: geoFenceId, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.getDevicesGeofences()
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt(message)
        }
    }
    
    func unlinkGeofence(geoFenceId: Int) {
        RCLocalAPIManager.shared.unlinkGeofence(with: allDevices[selectedVehicleIndex].id!, geofenceId: geoFenceId, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.getDevicesGeofences()
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt(message)
        }
    }
    
}

extension GeoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentIndex == 0 {
            return allGeofences.count
        }else {
            if isShowDevicesGeofence {
                return allGeofences.count
            }else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let customView = UIView()
        customView.backgroundColor = .clear
        segmentZeroView.geoCell.selectedBackgroundView =  customView
        segmentOneView.geoCell.selectedBackgroundView =  customView
        
        if allGeofences.count > 0 {
            if selectedSegmentIndex == 0 && tableView == segmentZeroView.geoTableView {
                segmentZeroView.geoCell = tableView.dequeueReusableCell(withIdentifier: segmentZeroView.reuseIdentifier, for: indexPath) as? GeoFenceTableViewCell
                segmentZeroView.geoCell.geoFenceLabel.text = allGeofences[indexPath.row].name
                segmentZeroView.geoCell.geoFenceLabel.textColor = appGreenTheme
                segmentZeroView.geoCell.geoFenceLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                
                segmentZeroView.geoCell.geoFenceImageView.image = getGeoImageType(type: allGeofences[indexPath.row].attributes?.type ?? "circle")
                return  segmentZeroView.geoCell
            }else if tableView == segmentOneView.myTableView {
                segmentOneView.geoCell = tableView.dequeueReusableCell(withIdentifier: segmentOneView.reuseIdentifier, for: indexPath) as? GeoFenceTableViewCell
                segmentOneView.geoCell.geoFenceLabel.text = allGeofences[indexPath.row].name
                segmentOneView.geoCell.geoFenceLabel.textColor = appGreenTheme
                segmentOneView.geoCell.geoFenceLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
                segmentOneView.geoCell.centerImageView.image = getGeoImageType(type: allGeofences[indexPath.row].attributes?.type ?? "circle")
                
                if devicesGeofences.count > 0 && devicesGeofences.contains(where: { $0.id == allGeofences[indexPath.row].id }) {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    segmentOneView.geoCell.geoFenceImageView.image = #imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 45, height: 23), interpolationQuality: .default)
                }else {
                    segmentOneView.geoCell.geoFenceImageView.image = #imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 45, height: 23), interpolationQuality: .default)
                }
                
                return  segmentOneView.geoCell
            }
        }
        return UITableViewCell()
//        else {
//            if selectedSegmentIndex == 0 {
//                return tableView.dequeueReusableCell(withIdentifier: segmentZeroView.reuseIdentifier, for: indexPath) as! GeoFenceTableViewCell
//            }else {
//                return tableView.dequeueReusableCell(withIdentifier: segmentOneView.reuseIdentifier, for: indexPath) as! GeoFenceTableViewCell
//            }
//        }
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedSegmentIndex == 0 {
            //   let nav = GeoMapViewOnlyController()
            let nav = GeoFenceMapViewController()
            nav.geofenceToShow = allGeofences[indexPath.row]
            self.navigationController?.pushViewController(nav, animated: true)
        }else {
            guard let numberOfRowsSelected = tableView.indexPathsForSelectedRows?.count  else { return }
            
            
            if numberOfRowsSelected <= 5 {
                self.linkGeofence(geoFenceId: allGeofences[indexPath.row].id)
            }else{
                UIApplication.shared.keyWindow?.makeToast("No more than five geofences are allowed on a single device.", duration: 2.0, position: .bottom)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if selectedSegmentIndex != 0 {
            self.unlinkGeofence(geoFenceId: allGeofences[indexPath.row].id)
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RCLocalAPIManager.shared.deleteGeofence(with: allGeofences[indexPath.row].id, success: { [weak self] hash in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.allGeofences.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UIApplication.shared.keyWindow?.makeToast("Geofence deleted successfully".toLocalize, duration: 2.0, position: .bottom)
                
            }) { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                if message == MyError.noDataFoundError.localizedDescription {
                    weakSelf.allGeofences.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    UIApplication.shared.keyWindow?.makeToast("Geofence deleted successfully".toLocalize, duration: 2.0, position: .bottom)
                }else{
                    weakSelf.prompt(message)
                }
            }
            
        }
    }
}


extension GeoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDevices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allDevices[row].name!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVehicleIndex = row
        segmentOneView.selectVehicleLabel.text = allDevices[row].name
    }
    
}

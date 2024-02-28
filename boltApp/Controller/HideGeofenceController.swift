
//
//  HideGeofenceController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class HideGeofenceController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var showHideGeofence: ShowHideGeofenceView!
    var showOrHideOption: Bool = true
    var geofencesArray = [GeofenceModel]()
    private let cellIdentifier = "Geofence"
    var selectedGeofence = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewsAndButtons()
        addNavigationBar()
        showAllGeofences()
    }
    
    private func addViewsAndButtons() {
        showHideGeofence = ShowHideGeofenceView()
        view.backgroundColor = .white
        view.addSubview(showHideGeofence)
        setConstraints()
        showHideGeofence.selectButton.addTarget(self, action: #selector(selectTheGeofences(_:)), for: .touchUpInside)
        showHideGeofence.geofenceTable.register(ShowHideGeofenceCell.self, forCellReuseIdentifier: cellIdentifier)
        showHideGeofence.geofenceTable.delegate = self
        showHideGeofence.geofenceTable.dataSource = self
    }
    private func setConstraints(){
        showHideGeofence.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }

    private func addNavigationBar() {
        self.navigationItem.title = "Show/Hide Geofence"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func showAllGeofences() {
        geofencesArray = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel")) ?? []
        selectedGeofenceForTable()
        if geofencesArray.count > 0 {
            let id = Int(Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0")
            RCLocalAPIManager.shared.getGeofences(loadingMsg: "", with: "userId", id: id!, success: { [weak self] hash in
                guard let weakSelf = self else { return }
                Defaults().set(hash, for: Key<[GeofenceModel]>("allUserGeofenceModel"))
                weakSelf.geofencesArray = Defaults().get(for: Key<[GeofenceModel]>("allUserGeofenceModel"))!
                weakSelf.showHideGeofence.geofenceTable.reloadData()
            }) { [weak self] message in
                guard self != nil else { return }
               // weakSelf.prompt("failed to getting geofence")
                print("\(message)")
            }
        } else {
           showHideGeofence.geofenceTable.reloadData()
        }
    }

    
    private func selectedGeofenceForTable() {
        selectedGeofence = Defaults().get(for: Key<[Int]>("selectedGeofence")) ?? []
        if selectedGeofence.count > 0 {
            showHideGeofence.selectAllLabel.text = "Deselect All"
            showHideGeofence.selectButton.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
        } else {
            showHideGeofence.selectAllLabel.text = "Select All"
            showHideGeofence.selectButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
            Defaults().set(true, for: Key<Bool>("should_clear_map"))
        }
    }
    
    @objc private func selectTheGeofences(_ sender: UIButton) {
        selectedGeofence = Defaults().get(for: Key<[Int]>("selectedGeofence")) ?? []
        if selectedGeofence.count == 0 {
            selectedGeofence.removeAll()
            geofencesArray.forEach { (i) in
                selectedGeofence.append(i.id)
            }
        } else {
            selectedGeofence.removeAll()
        }
        Defaults().set(selectedGeofence, for: Key<[Int]>("selectedGeofence"))
        showHideGeofence.geofenceTable.reloadData()
        selectedGeofenceForTable()
    }
    @objc private func enableGeofence(_ sender: UIButton) {
        selectedGeofence = Defaults().get(for: Key<[Int]>("selectedGeofence")) ?? []
        let cell = showHideGeofence.geofenceTable.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! ShowHideGeofenceCell
        let id:Int = geofencesArray[sender.tag].id
        if selectedGeofence.contains(id) {
            cell.onOffButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
            selectedGeofence = selectedGeofence.filter({ $0 != id })
        } else {
            cell.onOffButton.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
            selectedGeofence.append(id)
        }
        Defaults().set(selectedGeofence, for: Key<[Int]>("selectedGeofence"))
        selectedGeofenceForTable()
    }
    
    func getGeoImageType(type: String) -> UIImage {
        
        let type = type.lowercased()
        var geoImageType = #imageLiteral(resourceName: "circle")
        
        switch type {
        case "circle":
            geoImageType = #imageLiteral(resourceName: "latestCircle").resizedImage(CGSize.init(width: 22, height: 22), interpolationQuality: .default)
        case "polyline":
            geoImageType = #imageLiteral(resourceName: "polylineLatest").resizedImage(CGSize.init(width: 26, height: 12), interpolationQuality: .default)
        case "polygon":
            geoImageType = #imageLiteral(resourceName: "latestSquare").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default)
        default:
            geoImageType = #imageLiteral(resourceName: "latestCircle").resizedImage(CGSize.init(width: 22, height: 22), interpolationQuality: .default)
        }
        return geoImageType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geofencesArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ShowHideGeofenceCell
        cell.onOffButton.tag = indexPath.row
        setCellButtonImage(cell: cell, indexPath: indexPath, id: geofencesArray[indexPath.row].id)
        cell.onOffButton.addTarget(self, action: #selector(enableGeofence(_:)), for: .touchUpInside)
        cell.geofenceImage.image = getGeoImageType(type: geofencesArray[indexPath.row].area)
        cell.geofenceName.text = geofencesArray[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    private func setCellButtonImage(cell: ShowHideGeofenceCell, indexPath: IndexPath, id: Int) {
        if selectedGeofence.contains(id) {
            cell.onOffButton.setImage(#imageLiteral(resourceName: "onlineNotificationicon"), for: .normal)
        } else {
            cell.onOffButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
        }
    }
    
}

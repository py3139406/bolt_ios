//
//  FilterController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import UserNotifications
import DefaultsKit

class FilterController: UIViewController {
    
    var filter: FilterView!
    var alertTypeTitle:UILabel!
    var multiSelectBtn:UIButton!
    var tblFooterView:UIView!
    var myArray:[String] = []
    var alertName = ["ignitionOn", "ignitionOff","geofenceEnter", "geofenceExit","overspeed", "powerCut", "vibration",
    "lowBattery","others"]
    var alertImgName = ["greenNotification", "removeicon","geofenceicon", "geofenceicon","overspeed", "powercut", "vibration",
    "lowbattery","plus-3"]
    var selectedArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myArray = Defaults().get(for: Key<[String]>("filterSelectedOptions")) ?? []
        addViews()
        addConstraints()
        addActions()
        
        if myArray.count == 0 {
            multiSelectBtn.setTitle("CLEAR ALL", for: .normal)
        } else {
            multiSelectBtn.setTitle("SHOW ALL", for: .normal)
        }
    }
    func addConstraints(){
        filter.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
        alertTypeTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        multiSelectBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(alertTypeTitle)
            make.size.equalTo(alertTypeTitle)
        }
    }
    func addActions(){
        filter.filterTabel.register(NotificationFilterTableViewCell.self, forCellReuseIdentifier: "filterCell")
        filter.filterTabel.delegate = self
        filter.filterTabel.dataSource = self
        multiSelectBtn.addTarget(self,action: #selector(showClearAllTapped), for: .touchUpInside)
    }
    fileprivate func addViews() {
        filter = FilterView(frame: CGRect.zero)
        view.addSubview(filter)
        
        tblFooterView = UIView()
        tblFooterView.backgroundColor = .gray
        multiSelectBtn = UIButton()
        multiSelectBtn.setTitle("CLEAR ALL", for: .normal)
        multiSelectBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
        multiSelectBtn.titleLabel?.textAlignment = .center
        multiSelectBtn.backgroundColor = .gray
        multiSelectBtn.setTitleColor(.black, for: .normal)
        tblFooterView.addSubview(multiSelectBtn)
        
        alertTypeTitle = PaddingLabel()
        alertTypeTitle.text = "ALERT TYPE"
        alertTypeTitle.font = UIFont.boldSystemFont(ofSize: 11)
        alertTypeTitle.adjustsFontSizeToFitWidth = true
        alertTypeTitle.backgroundColor = .gray
        alertTypeTitle.textAlignment = .center
        alertTypeTitle.isUserInteractionEnabled = true
        tblFooterView.addSubview(alertTypeTitle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  checkAvailabilityAndAddFilter()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dissmissFilter()
    }
    
    @objc func showClearAllTapped(){
//       let isSelect = Defaults().get(for: Key<Bool>("isSelected")) ?? false
        if myArray.count > 0 {
            myArray.removeAll()
            multiSelectBtn.setTitle("CLEAR ALL", for: .normal)
        } else {
            multiSelectBtn.setTitle("SHOW ALL", for: .normal)
            myArray = ["ignitionOn", "ignitionOff","geofenceEnter", "geofenceExit","overspeed", "powerCut", "vibration",
                       "lowBattery","others"]
        }
        
        filter.filterTabel.reloadData()
        let userData: [String: Array<String>] = ["myArray": myArray]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filter"), object: nil, userInfo: userData)
    }
    func dissmissFilter() {
        Defaults().clear(Key<[String]>("filterSelectedOptions"))
        print("total selected : \(myArray.count)")
        dismissNoew()
        
    }
    func dismissNoew() {
        let userData: [String: Array<String>] = ["myArray": myArray]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filter"), object: nil, userInfo: userData)
        dismiss(animated: true, completion: nil)
    }
    
    
}
extension FilterController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        alertName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! NotificationFilterTableViewCell
        cell.textLabel?.text = alertName[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.imageView?.image = UIImage(named: alertImgName[indexPath.row])?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        switch alertName[indexPath.row] {
        case "ignitionOn":
            cell.selectionBtn.tag = notificationFilter.ignitionOn.rawValue
            if myArray.contains("ignitionOn") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "ignitionOff":
            cell.selectionBtn.tag = notificationFilter.ignitionOff.rawValue
            if myArray.contains("ignitionOff") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "geofenceEnter":
            cell.selectionBtn.tag = notificationFilter.geofenceEnter.rawValue
            if myArray.contains("geofenceEnter") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "geofenceExit":
            cell.selectionBtn.tag = notificationFilter.geofenceExit.rawValue
            if myArray.contains("geofenceExit") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "overspeed":
            cell.selectionBtn.tag = notificationFilter.overspeed.rawValue
            if myArray.contains("overspeed") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "powerCut":
            cell.selectionBtn.tag = notificationFilter.powerCut.rawValue
            if myArray.contains("powerCut") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "vibration":
            cell.selectionBtn.tag = notificationFilter.vibration.rawValue
            if myArray.contains("vibration") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "lowBattery":
            cell.selectionBtn.tag = notificationFilter.lowBattery.rawValue
            if myArray.contains("lowBattery") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        case "others":
            cell.selectionBtn.tag = notificationFilter.others.rawValue
            if myArray.contains("others") {
                cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
                cell.backgroundColor = .black
                cell.textLabel?.textColor = .white
            } else {
                cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
            }
            break
        default:
            break
        }
        
        cell.selectionBtn.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height * 0.1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tblFooterView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    @objc func filterTapped (_ sender: UIButton) {
        switch sender.tag {
        case notificationFilter.ignitionOn.rawValue:
            if self.myArray.contains("ignitionOn") {
                myArray.removeObject(obj: "ignitionOn")
            } else {
                myArray.append("ignitionOn")
            }
            break
        case notificationFilter.ignitionOff.rawValue:
            if self.myArray.contains("ignitionOff") {
                myArray.removeObject(obj: "ignitionOff")
            } else {
                myArray.append("ignitionOff")
            }
            break
        case notificationFilter.geofenceEnter.rawValue:
            if self.myArray.contains("geofenceEnter") {
                myArray.removeObject(obj: "geofenceEnter")
            } else {
                myArray.append("geofenceEnter")
            }
            break
        case notificationFilter.geofenceExit.rawValue:
            if self.myArray.contains("geofenceExit") {
                myArray.removeObject(obj: "geofenceExit")
            } else {
                myArray.append("geofenceExit")
            }
            break
        case notificationFilter.overspeed.rawValue:
            if self.myArray.contains("overspeed") {
                myArray.removeObject(obj: "overspeed")
            } else {
                myArray.append("overspeed")
            }
            break
        case notificationFilter.powerCut.rawValue:
            if self.myArray.contains("powerCut") {
                myArray.removeObject(obj: "powerCut")
            } else {
                myArray.append("powerCut")
            }
            break
        case notificationFilter.vibration.rawValue:
            if self.myArray.contains("vibration") {
                myArray.removeObject(obj: "vibration")
            } else {
                myArray.append("vibration")
            }
            break
        case notificationFilter.lowBattery.rawValue:
            if self.myArray.contains("lowBattery") {
                myArray.removeObject(obj: "lowBattery")
            } else {
                myArray.append("lowBattery")
            }
            break
        case notificationFilter.others.rawValue:
            if self.myArray.contains("others") {
                myArray.removeObject(obj: "others")
            } else {
                myArray.append("others")
            }
            break
        default:
            print("Do nothing")
        }

        if myArray.count == 0 {
            multiSelectBtn.setTitle("CLEAR ALL", for: .normal)
        } else {
            multiSelectBtn.setTitle("SHOW ALL", for: .normal)
        }
        
        filter.filterTabel.reloadData()
        let userData: [String: Array<String>] = ["myArray": myArray]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "filter"), object: nil, userInfo: userData)
    }
    
}

//
//  NotificationFilterViewController.swift
//  Bolt
//
//  Created by Vivek Kumar on 20/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class NotificationFilterViewController: UIViewController {
    var notificationfilterView: NotificationFilterView!
    var menuArray = ["Notification Type".toLocalize, "Ignition On".toLocalize, "Ignition Off".toLocalize, "Geo-fence Enter".toLocalize,
                     "Geo-fence Exit".toLocalize ,"Device Over-speed".toLocalize,"Power-Cut",
                     "Power Restored".toLocalize ,"Vibration".toLocalize, "SOS".toLocalize, "SHOCK" , "Low Battery","Tow","Ac/Door On","Ac/Door Off"]
    var order:  FilterTableViewCell!
    // var dictionary:[String:String] = [:]
    var cell = "cell"
    var allNotif:FilterResponseModelData?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFunction()
        view.backgroundColor = .white
        notificationfilterView = NotificationFilterView(frame: CGRect.zero)
        notificationfilterView.backgroundColor = .white
        notificationfilterView.notificationFilterTable.delegate = self
        notificationfilterView.notificationFilterTable.dataSource = self
        notificationfilterView.notificationFilterTable.register(FilterTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(notificationfilterView)
        setConstraints()
        getNotificationFilter()
    }
    func navigationBarFunction() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "bell").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Notification Filter"
    }
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    func setConstraints(){
        notificationfilterView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    func getNotificationFilter() {
        RCLocalAPIManager.shared.getnotificationAlert(with: "Please wait...", success:  { (success) in
            self.allNotif = success
            self.notificationfilterView.notificationFilterTable.reloadData()
            print("done")
        }) { (failure) in
            print("failure")
        }
    }
    func postNotificationFilter(key:String,value:Bool) {
        let param:[String:Bool] = [key:value]
        RCLocalAPIManager.shared.postNotificationAlert(with: param, loadingMsg: "updating...") { success in
            print(success)
            self.getNotificationFilter()
        } failure: { failure in
            print(failure)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NotificationFilterViewController: UITableViewDataSource ,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        order = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FilterTableViewCell
        order.selectionStyle = .none
        order.leftText.text = menuArray[indexPath.row]
        order.isUserInteractionEnabled = true
        
        order.notificationButton.addTarget(self, action: #selector(NotifOnOffTapped(_:)), for: .touchUpInside)
        
        switch menuArray[indexPath.row] {
        case "Notification Type":
            order.notificationButton.isHidden = true
        case "Ignition On":
            order.notificationButton.isHidden = false
            order.notificationButton.tag = indexPath.row
            if allNotif?.notify_ignitionOn ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Ignition Off":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_ignitionOff ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Geo-fence Enter":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_geofenceEnter ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Geo-fence Exit":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_geofenceExit ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Device Over-speed":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_overspeed ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Power-Cut":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_powerCut ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Power Restored":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_powerRestored ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Vibration":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_vibration ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "SOS":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_sos ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "SHOCK":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_shock ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Low Battery":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_lowBattery ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Tow":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_tow ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Ac/Door On":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_powerOn ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        case "Ac/Door Off":
            order.notificationButton.tag = indexPath.row
            order.notificationButton.isHidden = false
            if allNotif?.notify_powerOff ?? false {
                order.notificationButton.setImage(#imageLiteral(resourceName: "green notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            } else {
                order.notificationButton.setImage(#imageLiteral(resourceName: "red notification").resizedImage(CGSize.init(width: 40, height: 20), interpolationQuality: .default), for: .normal)
            }
        default:
            print("nan")
        }
        return order
    }
    @objc func NotifOnOffTapped(_ sender:UIButton){
        switch menuArray[sender.tag] {
        case "Ignition On":
            if allNotif?.notify_ignitionOn ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_ignitionOn.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_ignitionOn.rawValue, value: true)
            }
            
        case "Ignition Off":
            if allNotif?.notify_ignitionOff ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_ignitionOff.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_ignitionOff.rawValue, value: true)
            }
            
        case "Geo-fence Enter":
            if allNotif?.notify_geofenceEnter ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_geofenceEnter.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_geofenceEnter.rawValue, value: true)
            }
            
        case "Geo-fence Exit":
            if allNotif?.notify_geofenceExit ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_geofenceExit.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_geofenceExit.rawValue, value: true)
            }
            
        case "Device Over-speed":
            if allNotif?.notify_overspeed ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_overspeed.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_overspeed.rawValue, value: true)
            }
            
        case "Power-Cut":
            if allNotif?.notify_powerCut ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_powerCut.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_powerCut.rawValue, value: true)
            }
            
        case "Power Restored":
            if allNotif?.notify_powerRestored ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_powerRestored.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_powerRestored.rawValue, value: true)
            }
            
        case "Vibration":
            if allNotif?.notify_vibration ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_vibration.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_vibration.rawValue, value: true)
            }
            
        case "SOS":
            if allNotif?.notify_sos ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_sos.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_sos.rawValue, value: true)
            }
            
        case "SHOCK":
            if allNotif?.notify_shock ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_shock.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_shock.rawValue, value: true)
            }
            
        case "Low Battery":
            if allNotif?.notify_lowBattery ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_lowBattery.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_lowBattery.rawValue, value: true)
            }
        case "Tow":
            if allNotif?.notify_tow ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_tow.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_tow.rawValue, value: true)
            }
        case "Ac/Door On":
            if allNotif?.notify_powerOn ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_powerOn.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_powerOn.rawValue, value: true)
            }
        case "Ac/Door Off":
            if allNotif?.notify_powerOff ?? false {
                postNotificationFilter(key: NotifTypeKeys.notify_powerOff.rawValue, value: false)
            }else {
                postNotificationFilter(key: NotifTypeKeys.notify_powerOff.rawValue, value: true)
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.contentSize.height / CGFloat(menuArray.count)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
}



//
//  BlueToothViewController.swift
//  Bolt
//
//  Created by Roadcast on 05/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import CoreBluetooth
import BlueCapKit

class BlueToothViewController: UIViewController {
    // Properties
    var bleView = BLEView()
    var peripheral: Peripheral?
    var peripheralsList: [Peripheral] = []
    var count = 0
    var stateChange: FutureStream<ManagerState>?
    var Alertview:UIView!
    var  progress : MBProgressHUD?

    // delegate method
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addnavigation()
        addViews()
        addConstraints()
        addActions()
        
        stateChange = Singletons.manager.whenStateChanges()
        
        stateChange?.onSuccess { state in
            switch state {
            case .poweredOn:
                self.bleView.activateSwitch.isOn = true
                self.bleView.scanButton.isUserInteractionEnabled = true
                self.bleView.scanButton.alpha = 1
                 self.bleView.scanButton.setTitle("Start Scanning", for: .normal)
                break
            case .poweredOff:
                Singletons.manager.disconnectAllPeripherals()
                self.peripheralsList = []
                self.bleView.periferalTableView.reloadData()
                self.bleView.activateSwitch.isOn = false
                 self.bleView.scanButton.alpha = 0.5
                self.bleView.scanButton.setTitle("Start Scanning", for: .normal)
                self.count = 0
                self.prompt("Please turn on Bluetooth")
                break
            case .unauthorized:
                self.bleView.activateSwitch.isOn = false
                 self.bleView.scanButton.alpha = 0.5
                break
            case .resetting:
                self.bleView.activateSwitch.isOn = false
                 self.bleView.scanButton.alpha = 0.5
                break
            case .unknown:
                self.bleView.activateSwitch.isOn = false
                 self.bleView.scanButton.alpha = 0.5
                break
            case .unsupported:
                self.prompt("Unsupported")
                self.bleView.activateSwitch.isOn = false
                 self.bleView.scanButton.alpha = 0.5
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Singletons.manager.peripherals.count > 0 {
            Singletons.manager.disconnectAllPeripherals()
            Singletons.manager.removeAllPeripherals()
        }
    }
    // add action func
    func addActions(){
        bleView.activateSwitch.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .touchUpInside)
        bleView.scanButton.addTarget(self, action: #selector(startScanning), for: .touchUpInside)
        
    }
    // objc funcs
    @objc func startScanning(){
        if bleView.activateSwitch.isOn {
            if count == 0 {
                bleView.bleIndicator.startAnimating()
                self.count += 1
                scanning()
                self.bleView.scanButton.setTitle("Stop Scanning", for: .normal)
            }
            else {
                 bleView.bleIndicator.stopAnimating()
                Singletons.manager.stopScanning()
                self.peripheralsList = []
                self.bleView.periferalTableView.reloadData()
                self.bleView.scanButton.setTitle("Start Scanning", for: .normal)
                self.count -= 1
            }
        }
        else{
            bleView.scanButton.isUserInteractionEnabled = false
             self.bleView.scanButton.alpha = 0.5
            //self.prompt("\(Singletons.manager.state)")
        }
    }
    @objc func switchValueDidChange(sender:UISwitch!) {
        if  bleView.activateSwitch.isOn && Singletons.manager.state == .poweredOn {
        self.bleView.scanButton.alpha = 1
        self.bleView.scanButton.isUserInteractionEnabled = true
        self.bleView.scanButton.setTitle("Start Scanning", for: .normal)
            
        } else if !bleView.activateSwitch.isOn && Singletons.manager.state == .poweredOn {
            self.prompt("ALERT", "Are you sure", "YES", "NO", handler1: { (handler) in
                self.startScanning()
                self.bleView.bleIndicator.stopAnimating()
                self.bleView.activateSwitch.isOn = false
                self.bleView.scanButton.alpha = 0.5
                self.bleView.scanButton.isUserInteractionEnabled = false
            }) { (handler) in
                self.bleView.activateSwitch.isOn = true
                 self.bleView.scanButton.alpha = 1
                self.bleView.scanButton.isUserInteractionEnabled = true
            }
            
        }
        else {
                self.bleView.activateSwitch.isOn = false
                self.bleView.scanButton.isUserInteractionEnabled = false
             self.bleView.scanButton.alpha = 0.5
                UIApplication.shared.keyWindow?.makeToast("Please turn on bluetooth", duration: 2.0, position: .bottom, style: .none)
        }
        
    }
    // add views func
    func addViews(){
        view.addSubview(bleView)
        
        bleView.periferalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "deviceCell")
        bleView.periferalTableView.delegate = self
        bleView.periferalTableView.dataSource = self
        
    }
    // add constraints func
    func addConstraints(){
        bleView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
        }
        
    }
    // add nav func
    func addnavigation(){
        navigationItem.title = "Immobilize"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
    }
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
        Singletons.manager.reset()
    }
    // scanning
        func scanning(){
        let managerBLE = Singletons.manager.startScanning(forServiceUUIDs: nil , capacity: 50, options: nil)
     
            managerBLE.onSuccess { Peripheral in
                self.peripheral = Peripheral
                if self.peripheral?.name != "Unknown"{
                    self.peripheralsList.append(self.peripheral!)
                }
                self.bleView.periferalTableView.reloadData()
            }
            
            managerBLE.onFailure { error in
                switch error {
                case AppError.unknown:
                    break
                case AppError.unsupported:
                    break
                case AppError.resetting:
                    break
                case AppError.unauthorized:
                    break
                default:
                    break
                }
            }
            print(Singletons.manager.state)
        }
}
//  controller extensions
extension BlueToothViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath)
        cell.textLabel?.text = peripheralsList[indexPath.row].name
        cell.textLabel?.textColor = .black
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Singletons.manager.stopScanning()
        bleView.bleIndicator.stopAnimating()
        let vc = BLEActivateViewController()
        self.peripheral = self.peripheralsList[indexPath.row]
        vc.selectedPeripheral = self.peripheral
        
        self.peripheralsList = []
        self.bleView.periferalTableView.reloadData()
        self.bleView.scanButton.setTitle("Start Scanning", for: .normal)
        self.count -= 1
        

        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: false,completion: nil)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
extension BlueToothViewController: BleDelegate {
    func showAlert() {
        self.view.alpha = 0.5
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = "Updating, Please wait...".toLocalize
        Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }
    @objc func dismissAlert(){
         self.progress?.hide(true)
        self.view.isUserInteractionEnabled = true
       
    }
}

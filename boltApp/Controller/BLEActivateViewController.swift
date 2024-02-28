//
//  BLEActivateViewController.swift
//  Bolt
//
//  Created by Roadcast on 06/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import BlueCapKit
import CoreBluetooth
import DefaultsKit
protocol  BleDelegate {
    func showAlert()
}
class BLEActivateViewController: UIViewController {
    // Properties
    var bleActivateView = BLEActivateView()
    let serviceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    let dataUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    let enabledUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    var accelerometerDataCharacteristic: Characteristic?
    var accelerometerEnabledCharacteristic: Characteristic?
    var BleVC = BlueToothViewController()
    var deviceName : String = ""
    var selectedPeripheral: Peripheral!
    var checkImei:Bool = false
    var isConnected:Bool = false
    var isAuthorised:Bool = false
    var bleIndicateView:BLEIndicatorView!
    var Bledelegate:BleDelegate?
    var temp = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addnavigation()
        addViews()
        addConstarints()
        setActions()
        activated()
        self.Bledelegate = BleVC
    }
    // addviews
    func addViews(){
        view.addSubview(bleActivateView)
        bleActivateView.peripheralLabel.text = selectedPeripheral.name
        
        bleIndicateView = BLEIndicatorView()
        self.bleIndicateView.isUserInteractionEnabled = false
        self.view.addSubview(bleIndicateView)
        UIView.animate(withDuration: 0.2) {
               self.bleIndicateView.isHidden = true
        }
        
        
    }
    // addconstraints
    func addConstarints(){
        bleActivateView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
        }
        bleIndicateView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
                make.edges.equalToSuperview()
            }
        }
    
    }
    // set actions
    func setActions(){
        bleActivateView.activedSwitch.addTarget(self, action:#selector(activatedToggle(_:)), for: .touchUpInside)
    }
    //objective functions
    @objc func activatedToggle(_ sender:UISwitch){
        if isConnected  && checkImei  && isAuthorised {
            if bleActivateView.activedSwitch.isOn{
                print("immobilizing")
                writeEnabled(value: "464D4258AAAAAAAA002E000200010EA8")
            } else{
                print("mobilize")
                writeEnabled(value: "464D4258AAAAAAAA002E00020000CE69")
            }
        } else {
      self.bleActivateView.activedSwitch.isOn = false
      self.prompt("Sorry you are not authorised")
        }
        
    }

    // activated function
    func activated(){

        print("activated called")
        UIView.animate(withDuration: 0.2) {
               self.bleIndicateView.isHidden = false
        }
        self.view.isUserInteractionEnabled = false
        let dataUpdateFuture = self.selectedPeripheral?.connect(connectionTimeout: 10.0).flatMap { [unowned self] () -> Future<Void> in
            guard let peripheral = self.selectedPeripheral else {
                throw AppError.unauthorized
            }
            return peripheral.discoverServices([self.serviceUUID])
        }.flatMap { [unowned self] () -> Future<Void> in
            guard let peripheral = self.selectedPeripheral else {
                throw AppError.unlikelyFailure
            }
            guard let service = peripheral.services(withUUID: self.serviceUUID)?.first else {
                throw AppError.serviceNotFound
            }
            return service.discoverCharacteristics([self.dataUUID, self.enabledUUID])
        }.flatMap { [unowned self] () -> Future<Void> in
            guard let peripheral = self.selectedPeripheral, let service = peripheral.services(withUUID: self.serviceUUID)?.first else {
                throw AppError.serviceNotFound
            }
            guard let dataCharacteristic = service.characteristics(withUUID: self.dataUUID)?.first else {
                throw AppError.characteristicNotFound
            }
            guard let enabledCharacteristic = service.characteristics(withUUID: self.enabledUUID)?.first else {
                throw AppError.characteristicNotFound
            }
            self.accelerometerDataCharacteristic = dataCharacteristic
            self.accelerometerEnabledCharacteristic = enabledCharacteristic
            guard let accelerometerEnabledCharacteristic = self.accelerometerEnabledCharacteristic else {
                throw AppError.characteristicNotFound
            }
            return accelerometerEnabledCharacteristic.startNotifying()
        }.flatMap { [unowned self] () -> FutureStream<Data?> in
            guard let accelerometerEnabledCharacteristic = self.accelerometerEnabledCharacteristic else {
                throw AppError.characteristicNotFound
            }
            //            TODO Connection success
            print("imei checking")
            self.writeEnabled(value: "464D4258AAAAAAAA0038000203013DE1")
            return accelerometerEnabledCharacteristic.receiveNotificationUpdates(capacity: 10)
        }
        dataUpdateFuture?.onSuccess { [unowned self] data in
            self.temp = 1
            self.view.isUserInteractionEnabled = true
            self.bleIndicateView.removeFromSuperview()
            self.isConnected = true
            self.bleActivateView.connectedImg.image = #imageLiteral(resourceName: "imobilizesmallicon")
            self.checkImeiDOUTStatus(responseBytes: data!)
            
            print("\(self.selectedPeripheral.name) connected")
            print("name =\(self.selectedPeripheral.name)")
            print("RSSI =\(self.selectedPeripheral.RSSI)")
            print("State =\(self.selectedPeripheral.state)")
            print("Identifier =\(self.selectedPeripheral.identifier)")
            
            if self.checkImei == true {
                self.isAuthorised = true
                self.bleActivateView.imeiCheckedImg.image = #imageLiteral(resourceName: "imobilizesmallicon")
                self.bleActivateView.authImg.image = #imageLiteral(resourceName: "imobilizesmallicon")
            }
        }
        dataUpdateFuture?.onFailure { error in
            self.temp = 0
            switch error {
            case PeripheralError.disconnected:
                self.view.isUserInteractionEnabled = true
                self.bleIndicateView.removeFromSuperview()
                self.prompt("ALERT", "Disconnected", "OK") { (handle) in
                    self.dismiss(animated: true, completion: nil)
                }
                break
            case PeripheralError.forcedDisconnect:
                self.view.isUserInteractionEnabled = true
                self.bleIndicateView.removeFromSuperview()
                self.prompt("ALERT", "Forced Disconnect", "OK") { (handle) in
                self.dismiss(animated: true, completion: nil)
                }
                break
            case PeripheralError.connectionTimeout:
                self.view.isUserInteractionEnabled = true
                 //self.bleIndicateView.removeFromSuperview()
                UIView.animate(withDuration: 0.2) {
                       self.bleIndicateView.isHidden = true
                }
                self.prompt("ALERT", "Connection Timeout!", "RETRY", "BACK", handler1: { (handle) in
                    self.selectedPeripheral.reconnect()
                    UIView.animate(withDuration: 0.2) {
                           self.bleIndicateView.isHidden = false
                    }
                    self.view.isUserInteractionEnabled = false
                   // self.view.addSubview(self.bleIndicateView)
                    
                }) { (handle) in
                    self.dismiss(animated: true, completion: nil)
                }
                break
            default:
                self.deActivated()
                break
            }
        }
    }

    // deactivated func
    func deActivated(){
        print("deactivate called")
        guard let peripheral = self.selectedPeripheral else {
             return
         }
        
        peripheral.disconnect()
        peripheral.terminate()
        if Singletons.manager.isScanning {
            Singletons.manager.stopScanning()
        }
        if Singletons.manager.peripherals.count > 0 {
            Singletons.manager.disconnectAllPeripherals()
            Singletons.manager.removeAllPeripherals()
        }
        
        
       self.selectedPeripheral = nil
        
    }
    // write enabled func
    func writeEnabled(value: String) {
        if let accelerometerDataCharacteristic = accelerometerDataCharacteristic {
            let writeFuture = accelerometerDataCharacteristic.write(data: value.dataFromHexString(), timeout:10.0)
            writeFuture.onSuccess { [unowned self] _ in
               print("successful")
            }
            writeFuture.onFailure { [unowned self] error in
                self.prompt("Failed")
            }
        }
    }
    
    func checkImeiDOUTStatus(responseBytes: Data) {
        print("check imei dout status")
//        if let responseBytes = self.stringToBytes(response) {
            let protocolString = String(format: "%02x", responseBytes[9])
            if  protocolString == "3b" {
                if responseBytes.count > 23 {
    //                IMEI
                    var imei = ""
                    for (index, responseByte) in responseBytes.enumerated() {
                        if index > 15 && index < 31 {
                            imei = imei + String(format: "%c", responseByte)
                        }
                    }
                    print("imei" + imei)
                    if let imeis = Defaults().get(for: Key<[String]>("imeiNumbers")) {
                        if (imeis.contains(imei)) {
                            self.checkImei = true
                            self.showalert("IMEI matches.".toLocalize)
                            print("imei matched")
//                            TODO Call again write with 464D4258AAAAAAAA00380002C40E09F3
                            self.writeEnabled(value: "464D4258AAAAAAAA00380002C40E09F3")
                        } else {
                            self.showalert("IMEI not matches.".toLocalize)
                            print("imei not match")
                        }
                    }
                } else {
    //                DOUT status
                    print("status" + String(format: "%c", responseBytes[15]))
                    if responseBytes[15] == 1 {
                        self.bleActivateView.activedSwitch.isOn = true
                    } else {
                        self.bleActivateView.activedSwitch.isOn = false
                    }
                }
            }
//        }
    }
    
    // nav func
    func addnavigation(){
        navigationItem.title = "Immobilize"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
    }
    // dismiss func
    @objc func backTapped() {
        deActivated()
        if temp == 0 {
        self.dismiss(animated: true, completion: nil)
        } else{
            self.dismiss(animated: true) {
                 self.Bledelegate?.showAlert()
            }
        }

    }
    func toPairsOfChars(pairs: [String], string: String) -> [String] {
        if string.count == 0 {
            return pairs
        }
        var pairsMod = pairs
        pairsMod.append(String(string.prefix(2)))
        return toPairsOfChars(pairs: pairsMod, string: String(string.dropFirst(2)))
    }

    func stringToBytes(_ string: String) -> [UInt8]? {
        // omit error checking: remove '0x', make sure even, valid chars
        let pairs = toPairsOfChars(pairs: [], string: string)
        return pairs.map { UInt8($0, radix: 16)! }
    }
    
    
    
}

public enum AppError : Error {
    case dataCharactertisticNotFound
    case enabledCharactertisticNotFound
    case updateCharactertisticNotFound
    case serviceNotFound
    case invalidState
    case resetting
    case poweredOff
    case unknown
    case unauthorized
    case unsupported
    case unlikelyFailure
    case characteristicNotFound
}

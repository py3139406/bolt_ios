//
//  BLEconnectVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 21/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

//import UIKit
////import BlueCapKit
//import CoreBluetooth
//import Foundation
//import DefaultsKit
//
//
//class BLEconnectVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    private var myTableView: UITableView!
//    var bluetoothStateView = UIView()
//    var bluettoothLabel = UILabel()
//    var bluetoothBtn = UIButton()
//    
//    var availableDevicesView = UIView()
//    var availableDevLabel = UILabel()
//    var scanbtn = UIButton()
//    
//    let kScreenHeight = UIScreen.main.bounds.height
//    let kScreenWidth = UIScreen.main.bounds.width
//    
//    var isMyPeripheralConected = false
//    
//    var manager : CBCentralManager!
//    var myBluetoothPeripheral = [CBPeripheral]()
//    var myCharacteristic : CBCharacteristic!
//    var peripheralNames = [String]()
////    var txCharacteristic: Characteristic?//CBCharacteristic? = nil
//    var rxCharacteristic: CBCharacteristic? = nil
//    var readCharacteristic: CBCharacteristic? = nil
//    var valueName: String?
//    
//    //let accelerometerService = MutableService(profile:ConfiguredServiceProfile<Config: ServiceConfigurable>())
//    
//    let DEVICE_INFO_SERVICE_UUID  = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
//    let SERIAL_NUMBER_CHARACTERISTIC_UUID = CBUUID(string:"6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
//    let NOTIFY_CHARACTERISTIC_UUID = CBUUID(string:"6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
//    let CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUID = CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb")
//    
//    var selectedBLEDevice: CBPeripheral? = nil
//    
////    let blueManager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "us.gnos.BlueCap.central-manager-documentation" as NSString])
//    
//    public enum AppError : Error {
//        case invalidState
//        case resetting
//        case poweredOff
//        case unknown
//        case unlikely
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setUIComponents()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        
//        if let peripheral = selectedBLEDevice {
//            manager.cancelPeripheralConnection(peripheral)
//        }
//    }
//    
//    //MARK:- UI Methods
//    func setUIComponents() {
//        
//        myTableView = UITableView(frame: CGRect.zero)
//        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
//        myTableView.dataSource = self
//        myTableView.delegate = self
//        self.view.addSubview(myTableView)
//        
//        
//        bluettoothLabel.text = "Bluetooth"
//        bluettoothLabel.textColor = .white
//        bluettoothLabel.font = bluettoothLabel.font.withSize(25)
//        
//        bluetoothBtn.setImage( UIImage(named: "newRedNotification"), for: .normal)
//        bluetoothStateView.backgroundColor = .black
//        
//        availableDevLabel.text = "Available Devices"
//        availableDevLabel.textColor = appGreenTheme
//        availableDevLabel.font = availableDevLabel.font.withSize(25)
//        availableDevicesView.backgroundColor = .white
//        
//        scanbtn.setTitle("Scan", for: .normal)
//        scanbtn.setTitleColor(appGreenTheme, for: .normal)
//        
//        self.view.addSubview(bluetoothStateView)
//        self.view.addSubview(availableDevicesView)
//        bluetoothStateView.addSubview(bluettoothLabel)
//        bluetoothStateView.addSubview(bluetoothBtn)
//        availableDevicesView.addSubview(availableDevLabel)
//        availableDevicesView.addSubview(scanbtn)
//        
//        bluetoothBtn.addTarget(self, action: #selector(switchOnBluetooth), for: .touchUpInside)
//        
//        scanbtn.addTarget(self, action: #selector(scanDevices), for: .touchUpInside)
//        
//        setConstraints()
//        
//        
//    }
//    
//    func setConstraints() {
//        
//        bluettoothLabel.snp.makeConstraints { (make) in
//            
//            make.left.equalToSuperview().offset(30)
//            make.centerY.equalTo(bluetoothBtn)
//            make.width.equalTo(250)
//            
//        }
//        
//        bluetoothBtn.snp.makeConstraints { (make) in
//            
//            make.height.equalTo(0.25 * kScreenWidth)
//            make.width.equalTo(0.15 * kScreenWidth)
//            make.right.equalToSuperview().offset(-20)
//            make.centerY.equalToSuperview()
//            make.left.equalTo(bluettoothLabel.snp.right).offset(30)
//        }
//        
//        myTableView.snp.makeConstraints { (make) in
//            
//            make.top.equalTo(availableDevicesView.snp.bottom).offset(20)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//        
//        bluetoothStateView.snp.makeConstraints { (make) in
//            
//            make.top.equalToSuperview().offset(40)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(70)
//            
//        }
//        
//        availableDevicesView.snp.makeConstraints { (make) in
//            
//            make.top.equalTo(bluetoothStateView.snp.bottom)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(70)
//            
//        }
//        
//        
//        availableDevLabel.snp.makeConstraints { (make) in
//            
//            make.left.equalToSuperview().offset(30)
//            make.centerY.equalTo(scanbtn)
//            make.width.equalTo(250)
//            
//        }
//        
//        scanbtn.snp.makeConstraints { (make) in
//            
//            make.height.equalTo(0.25 * kScreenWidth)
//            make.width.equalTo(0.2 * kScreenWidth)
//            make.right.equalToSuperview().offset(-20)
//            make.centerY.equalToSuperview()
//            make.left.equalTo(bluettoothLabel.snp.right).offset(30)
//            
//        }
//    }
//    
//    @objc func scanDevices() {
//        
//        UIApplication.shared.keyWindow?.makeToast("Scanning for Devices", duration: 1, position: .bottom)
//        
//        manager = CBCentralManager()
//
//        manager = CBCentralManager(delegate: self, queue: nil, options:nil)
////        manager = CBCentralManager(delegate: self, queue: nil)
//        
//        peripheralNames = []
//        myBluetoothPeripheral = []
//        myTableView.reloadData()
//        
//    }
//    
//    @objc func switchOnBluetooth() {
//        
//        if bluetoothBtn.currentImage == UIImage(named: "newRedNotification") {
//            self.prompt("Please switch on the Bluetooth from settings in order to use it for mobilising and immobilising devices via Bluetooth.")
//        } else  {
//            self.prompt("Please switch off the Bluetooth from settings in order to stop using it.")
//        }
//        let dataToSend: Data = "464D4258AAAAAAAA0038000203013DE1".dataFromHexString()
//        self.selectedBLEDevice?.writeValue(dataToSend, for: self.readCharacteristic!, type: .withResponse)
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        //let indexPath = NSIndexPath(forRow: tag, inSection: 0)
//        //let cell = tableView.cellForRow(at: indexPath) as! gpsSettingsCustomCell!
//        //print(cell?.cellLabel.text ?? "")
//        
////        self.myBluetoothPeripheral[indexPath.row].delegate = self
//        // myownBluetoothPeripheral = self.myBluetoothPeripheral[indexPath.row]
//        
//        self.manager.stopScan()                          //stop scanning for peripherals
//        self.manager.connect(myBluetoothPeripheral[indexPath.row], options: nil)
//        
//        myTableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return peripheralNames.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = BLEDeviceCustomCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60),
//                                       title: "Hello")
//        cell.cellLabel.text = peripheralNames[indexPath.row]
//        cell.cellLabel2.text = "Bluetooth Device"
//        return cell
//        
//    }
//}
//
//extension BLEconnectVC: CBCentralManagerDelegate {
//    
//    
//    //MARK:- Bluetooth Delegate Methods
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        
//        //check
//        var msg = ""
//        
//        switch central.state {
//            
//        case .poweredOff:
//            bluetoothBtn.setImage( UIImage(named: "newRedNotification"), for: .normal)
//            msg = "Bluetooth is Off"
//        case .poweredOn:
//            msg = "Bluetooth is On"
//            self.manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
//            bluetoothBtn.setImage(UIImage(named: "onlineNotificationicon"), for: .normal)
//        case .unsupported:
//            msg = "Not Supported"
//        case .unauthorized:
//            msg = "Not Authorized"
//        default:
//            msg = "😔"
//        }
//        
//        print("STATE: " + msg)
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        
//        if !myBluetoothPeripheral.contains(peripheral) {
//            
//            if peripheral.name != nil {
//                
//                peripheralNames.append(peripheral.name ?? "Unknown Device")
//                print(peripheral)
//                self.myBluetoothPeripheral.append(peripheral)
//                print(peripheralNames)
//                
//            }
//            
//            myTableView.reloadData()
//            
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        
//        UIApplication.shared.keyWindow?.makeToast("Connected To \(peripheral.name ?? "unknown Device")", duration: 1, position: .bottom)
//        
//        //check
//        isMyPeripheralConected = true //when connected change to true
//        peripheral.delegate = self
//        peripheral.discoverServices(nil)
//        
//        let imeiNumberArray =  Defaults().get(for: Key<[String]>("imeiNumbers"))
//        print("imei Number Array is as followed: \(imeiNumberArray!)")
//        
//        print("connected to device = \(peripheral.name ?? "unknown")")
//        selectedBLEDevice = peripheral
//        
//    }
//    
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        
//        //check
//        UIApplication.shared.keyWindow?.makeToast("Failed to Connect", duration: 1, position: .bottom)
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
//        //check
//        isMyPeripheralConected = false//and to falso when disconnected
//        selectedBLEDevice = nil
//        UIApplication.shared.keyWindow?.makeToast("Peripheral Disconnected", duration: 1, position: .bottom)
//    }
//}
//    
//extension BLEconnectVC: CBPeripheralDelegate {
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        //check
//        if let services = peripheral.services {
//            for service in services {
//                print("Discovered service: \(service)")
//
//                if service.uuid.uuidString.lowercased() == DEVICE_INFO_SERVICE_UUID.lowercased() {
//                    peripheral.discoverCharacteristics(nil, for: service)
//                }
//            }
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("--------------------------------------------")
//        print("peripheral:\(peripheral) and service:\(service)")
//        
//        if (error != nil) {
//            print("error: \(error?.localizedDescription ?? "")")
//            return
//        }
//        
//        guard let characteristics = service.characteristics else { return }
//        ""
//        for characteristic in characteristics {
//            peripheral.setNotifyValue(true, for: characteristic)
//            peripheral.readValue(for: characteristic)
//            
//            print("Characteristic UUID: \(characteristic.uuid)")
//            print("Characteristic isNotifying: \(characteristic.properties.contains(.notify))")
//            print("Characteristic properties: \(characteristic.properties)")
//            print("Characteristic descriptors: \(characteristic.descriptors)")
//            print("Characteristic value: \(characteristic.value)")
//            
//            if characteristic.uuid == NOTIFY_CHARACTERISTIC_UUID {
////                peripheral.discoverDescriptors(for: characteristic)
//                rxCharacteristic = characteristic
//                print("Characteristic isNotifying: \(characteristic.properties.contains(.notify))")
//                print("\(characteristic.uuid): properties contains .notify characterstic")
//                
//            } else if characteristic.uuid == CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUID {
//                // txCharacteristic = characteristic
//                print("\(characteristic.uuid): properties contains .notify update characterstic")
//            } else if characteristic.uuid == SERIAL_NUMBER_CHARACTERISTIC_UUID {
//                self.readCharacteristic = characteristic
//                print("\(characteristic.uuid): properties contains .serial number characterstic")
//            } else {
//                print("\(characteristic.uuid): properties contains no characterstic")
//            }
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        
//        guard let descriptors = characteristic.descriptors else {return}
//        print("discovered discriptor")
//
//        for descr in descriptors {
//            print(selectedBLEDevice?.readValue(for: descr))
////            let bytes:[UInt8] = [0x00, 0x00]
////            let data = Data(bytes: bytes)
////            peripheral.writeValue(data, for: descr)
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//        switch descriptor.uuid.uuidString {
//        case CBUUIDCharacteristicExtendedPropertiesString:
//            guard let properties = descriptor.value as? NSNumber else {
//                break
//            }
//            print("  Extended properties: \(properties)")
//        case CBUUIDCharacteristicUserDescriptionString:
//            guard let description = descriptor.value as? NSString else {
//                break
//            }
//            print("  User description: \(description)")
//        case CBUUIDClientCharacteristicConfigurationString:
//            guard let clientConfig = descriptor.value as? NSNumber else {
//                break
//            }
//            print("  Client configuration: \(clientConfig)")
//        case CBUUIDServerCharacteristicConfigurationString:
//            guard let serverConfig = descriptor.value as? NSNumber else {
//                break
//            }
//            print("  Server configuration: \(serverConfig)")
//        case CBUUIDCharacteristicFormatString:
//            guard let format = descriptor.value as? NSData else {
//                break
//            }
//            print("  Format: \(format)")
//        case CBUUIDCharacteristicAggregateFormatString:
//            print("  Aggregate Format: (is not documented)")
//        default:
//            break
//            
//            let dataToSend: Data = "464D4258AAAAAAAA002E00020000CE69".data(using: String.Encoding.utf8)!
//            print(peripheral.writeValue(dataToSend, for: descriptor))
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        print(peripheral)
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        
//        if (error != nil) {
//            print("error: \(error?.localizedDescription)")
//            return
//        }
//        print(characteristic.uuid.uuidString, characteristic.value)
//        switch characteristic.uuid {
//        case NOTIFY_CHARACTERISTIC_UUID:
//            print(characteristic.value ?? "no notify value")
//            
//        case SERIAL_NUMBER_CHARACTERISTIC_UUID:
//            print(characteristic.value ?? "no serial value")
//            
//        case CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUID:
//            print(characteristic.value ?? "no updateNotif value")
//            
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//        print(peripheral, characteristic)
//        if ((error) != nil) {
//            print("Error changing notification state \(error?.localizedDescription)")
//        }
//        else {
//            print("Notification began on: \(characteristic)")
//        }
//
//    }
//    
//}
//
//public extension String {
//    
//    var floatValue : Float {
//        return (self as NSString).floatValue
//    }
//    
//    func dataFromHexString() -> Data {
//        var bytes = [UInt8]()
//        for i in 0..<(count/2) {
//            let range = index(self.startIndex, offsetBy: 2*i)..<index(self.startIndex, offsetBy: 2*i+2)
//            let stringBytes = self[range]
//            let byte = strtol((stringBytes as NSString).utf8String, nil, 16)
//            bytes.append(UInt8(byte))
//        }
//        return Data(bytes: UnsafePointer<UInt8>(bytes), count:bytes.count)
//    }
//    
//}

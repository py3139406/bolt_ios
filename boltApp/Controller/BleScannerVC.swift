//
//  BleScannerVC.swift
//  Bolt
//
//  Created by Roadcast on 31/12/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

//import UIKit
//import CoreLocation
//import CoreBluetooth
//import SnapKit
//import DefaultsKit
//
//class BleScannerVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate {
//    
//    private var myTableView: UITableView!
//    var bluetoothStateView = UIView()
//    var bluettoothLabel = UILabel()
//    var bluetoothBtn = UIButton()
//    
//    
//    var availableDevicesView = UIView()
//    var availableDevLabel = UILabel()
//    var scanbtn = UIButton()
//    
//    let kScreenHeight = UIScreen.main.bounds.height
//    let kScreenWidth = UIScreen.main.bounds.width
//    
//    
//    
//    var isMyPeripheralConected = false
//    
//    var manager : CBCentralManager!
//    var myBluetoothPeripheral = [CBPeripheral]()
//    var myCharacteristic : CBCharacteristic!
//    var peripheralNames = [String]()
//    var txCharacteristic: CBCharacteristic? = nil
//    var rxCharacteristic: CBCharacteristic? = nil
//    
//    //    public String DEVICE_INFO_SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
//    //    public String SERIAL_NUMBER_CHARACTERISTIC_UUID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
//    //    public String NOTIFY_CHARACTERISTIC_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
//    
//    let DEVICE_INFO_SERVICE_UUID  = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
//    
//    let SERIAL_NUMBER_CHARACTERISTIC_UUID = CBUUID(string:"6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
//    let SERIAL_NUMBER_CHARACTERISTIC_UUIDCheck = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
//    let NOTIFY_CHARACTERISTIC_UUID = CBUUID(string:"6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
//    let NOTIFY_CHARACTERISTIC_UUIDcheck = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
//  
//  
// // str = "464D4258AAAAAAAA0038000203013DE1"; imei
//  //"464D4258AAAAAAAA00380002C40E09F3"; dout
//  //str = "464D4258AAAAAAAA002E00020000CE69"; immobilize
//  //str = "464D4258AAAAAAAA002E000200010EA8";
//  
//    var deviceCharact : CBCharacteristic!
//  
//  
////6E400003-B5A3-F393-E0A9-E50E24DCCA9
//    
//    let CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUID =
//        CBUUID(string: "00002902-0000-1000-8000-00805f9b34fb")
//  
//  let CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUIDcheck = "00002902-0000-1000-8000-00805f9b34fb"
//    
//    var selectedBLEDevice: CBPeripheral? = nil
//    var arrayReadWriteChar = [CBCharacteristic]()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        
//        self.view.backgroundColor = .white
//        //self.selectedBLEDevice = nil
//      //  manager.cancelPeripheralConnection(myBluetoothPeripheral[0])
//        manager = CBCentralManager(delegate: self, queue: nil)
//        if selectedBLEDevice != nil {
//            manager.cancelPeripheralConnection(selectedBLEDevice!)
//        }
//        
//        setUIComponents()
//        
//        
//    }
//
//  
//  override func viewWillDisappear(_ animated: Bool) {
//    
//    if let peripheral = selectedBLEDevice {
//    manager.cancelPeripheralConnection(peripheral)
//    }
//    
//  }
//    
//    //MARK:- UI Methods
//    
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
//    
//    @objc func scanDevices() {
//        
//        UIApplication.shared.keyWindow?.makeToast("Scanning for Devices", duration: 1, position: .bottom)
//        
//        manager = CBCentralManager(delegate: self, queue: nil)
//
//        peripheralNames = []
//        myBluetoothPeripheral = []
//        myTableView.reloadData()
//        
//    }
//    
//    @objc func switchOnBluetooth() {
//        
//        // writeValue()
//        
//        if bluetoothBtn.currentImage == UIImage(named: "newRedNotification") {
//            self.prompt("Please switch on the Bluetooth from settings in order to use it for mobilising and immobilising devices via Bluetooth.")
//            
//        } else  {
//            
//            self.prompt("Please switch off the Bluetooth from settings in order to stop using it.")
//        }
//    }
//    
//    
//    //MARK:- Bluetooth Delegate Methods
//    
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        
//      //check
//        
//        var msg = ""
//        
//        switch central.state {
//            
//        case .poweredOff:
//            
//            bluetoothBtn.setImage( UIImage(named: "newRedNotification"), for: .normal)
//            msg = "Bluetooth is Off"
//            
//        case .poweredOn:
//            msg = "Bluetooth is On"
//            self.manager.scanForPeripherals(withServices: nil, options: nil)
//            bluetoothBtn.setImage(UIImage(named: "onlineNotificationicon"), for: .normal)
//            
//        case .unsupported:
//            msg = "Not Supported"
//          
//        default:
//            msg = "😔"
//            
//        }
//        
//        print("STATE: " + msg)
//        
//    }
//    
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
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
//           UIApplication.shared.keyWindow?.makeToast("Failed to Connect", duration: 1, position: .bottom)
//    }
//    
//    func centralManager(_ central: CBCentralManager,
//                        didDisconnectPeripheral peripheral: CBPeripheral,
//                        error: Error?) {
//        //check
//        isMyPeripheralConected = false//and to falso when disconnected
//        selectedBLEDevice = nil
//         UIApplication.shared.keyWindow?.makeToast("Peripheral Disconnected", duration: 1, position: .bottom)
//    }
//    
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        //check
//        if let services = peripheral.services {
//            for service in services {
//                
//                if service.uuid.uuidString.lowercased() == DEVICE_INFO_SERVICE_UUID.lowercased() {
//                    
////                    print("ble device service found")
////                  guard let characterstics = service.characteristics else {return}
////
////                  for character in characterstics {
////
////                    if character.uuid.uuidString.lowercased() == SERIAL_NUMBER_CHARACTERISTIC_UUIDCheck.lowercased() {
////                      print("Serial Number Characterstic found")
////                      deviceCharact = character
////                    }
////                    if character.uuid.uuidString.lowercased() == NOTIFY_CHARACTERISTIC_UUIDcheck.lowercased() {
////                      print("NOTIFY_CHARACTERISTIC_UUID Characterstic found")
////                      peripheral.setNotifyValue(true, for: character)
////                      for descriptor in character.descriptors! {
////                        if descriptor.uuid.uuidString.lowercased() == CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUIDcheck.lowercased() {
////
////                        }
////                      }
////                      let dataToSend: Data = "464D4258AAAAAAAA0038000203013DE1".data(using: String.Encoding.utf8)!
////                      print(peripheral.writeValue(dataToSend, for: deviceCharact, type: .withResponse))
////
////                    }
////                  }
//                    
//                   peripheral.discoverCharacteristics([SERIAL_NUMBER_CHARACTERISTIC_UUID, NOTIFY_CHARACTERISTIC_UUID], for: service)
//                    
//                }
//            }
//  
//        }
//        
//    }
//    
//    
//    
//    func peripheral(_ peripheral: CBPeripheral,
//                    didDiscoverCharacteristicsFor service: CBService,
//                    error: Error?) {
//        
//        
//      
//       // print("Imei is \(peripheral.description)")
//      
//      print("--------------------------------------------")
//              print("peripheral:\(peripheral) and service:\(service)")
//              
//        
//        guard let characteristics = service.characteristics else { return }
//      
//      for characteristic in characteristics {
//        
////         let properties = characteristic.properties.rawValue
////        let isWritable = (properties & \ CBCharacteristicProperties.write.rawValue) != 0;
////        let isWritableNoResponse = (properties & \ CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0;
////        let isReadable = (properties & \
////        CBCharacteristicProperties.read.rawValue) != 0;
////        let isNotifiable = (properties & \
////        CBCharacteristicProperties.notify.rawValue) != 0;
//        
//        print("Characteristic UUID: \(characteristic.uuid)")
//        print("Characteristic isNotifying: \(characteristic.isNotifying)")
//        print("Characteristic properties: \(characteristic.properties)")
//        print("Characteristic descriptors: \(characteristic.descriptors)")
//        print("Characteristic value: \(characteristic.value)")
//            
//        if characteristic.uuid == NOTIFY_CHARACTERISTIC_UUID {
//         
//           rxCharacteristic = characteristic
//
//          print("\(characteristic.uuid): properties contains .notify characterstic")
//             peripheral.discoverDescriptors(for: characteristic)
//            
//        } else if characteristic.uuid == CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUID {
//            
//            txCharacteristic = characteristic
//          print("\(characteristic.uuid): properties contains .notify update characterstic")
//    
//            
//        } else if characteristic.uuid == SERIAL_NUMBER_CHARACTERISTIC_UUID {
//            
//            
//            print("\(characteristic.uuid): properties contains .serial number characterstic")
//            peripheral.discoverDescriptors(for: characteristic)
//
//        } else {
//            
//            print("\(characteristic.uuid): properties contains no characterstic")
//            
//            }
//        }
//      
//   
//      
////      let commandToGetImei = "464D4258AAAAAAAA0038000203013DE1"
////
////      let writeFuture = selectedBLEDevice.writeValue(commandToGetImei.data(using: .utf8)!, for: rxCharacteristic!)
////        writeFuture?.onSuccess(completion: { (_) in
////            print("write succes")
////        })
////        writeFuture?.onFailure(completion: { (e) in
////            print("write failed")
////        })
//      
//      //            let dataToSend: Data = "464D4258AAAAAAAA0038000203013DE1".data(using: String.Encoding.utf8)!
//      //            selectedBLEDevice?.setNotifyValue(true, for: NOTIFY_CHARACTERISTIC_UUID)
//      //            selectedBLEDevice?.readValue(for: NOTIFY_CHARACTERISTIC_UUID)
//      //            self.writeLEDValueToChar(withCharacteristic: NOTIFY_CHARACTERISTIC_UUID, withValue: dataToSend)
//      
////      let toSend = stringToUInt8Array(command: commandToGetImei)
////      let cmd = Data(toSend)
////      let data = String(format: "%@%@",commandToGetImei,hexTimeForChar)
////
////      guard let valueString = data.data(using: String.Encoding.utf8)  else {return}
////
////      selectedBLEDevice?.writeValue(valueString, for: txCharacteristic ?? rxCharacteristic!, type: .withResponse)
//
//    }
//  
//  func stringToUInt8Array(command: String) -> [UInt8] {
//
//      let str:String = command
//      let strToUInt8:[UInt8] = [UInt8](str.utf8)
//     
//      print(strToUInt8)
//    
//    return strToUInt8
//    
//  }
//    
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        
//        guard let descriptors = characteristic.descriptors else {return}
//      
//      print("discovered discriptor")
//        
//        for descr in descriptors {
//          print(selectedBLEDevice?.readValue(for: descr))
//          //selectedBLEDevice?.setnotif
//          }
//      
//    }
//    
//    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
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
//            
//            
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
//        let dataToSend: Data = "464D4258AAAAAAAA002E00020000CE69".data(using: String.Encoding.utf8)!
//        print(peripheral.writeValue(dataToSend, for: descriptor))
//        }
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        
//        print(peripheral)
//        
//    }
//    
//    private func writeLEDValueToChar( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
//
//        // Check if it has the write property
//        if selectedBLEDevice != nil {
//
//            self.selectedBLEDevice?.writeValue(value, for: characteristic, type: .withResponse)
//
//        }
//
//    }
//    
//    func peripheral(_ peripheral: CBPeripheral,
//                    didUpdateValueFor characteristic: CBCharacteristic,
//                    error: Error?) {
//        
//        // let readValue = characteristic.value
//        
//        switch characteristic.uuid {
//            case NOTIFY_CHARACTERISTIC_UUID:
//                  print(characteristic.value ?? "no notify value")
//            
//        case SERIAL_NUMBER_CHARACTERISTIC_UUID:
//            print(characteristic.value ?? "no serial value")
//            
//            
//        case CHARACTERISTIC_UPDATE_NOTIFICATION_DESCRIPTOR_UUID:
//            print(characteristic.value ?? "no updateNotif value")
//            
//                  
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
//      
//      
//        
////        if let error1 = error{
////
////            print(error1)
////        }
////        else{
////
////            let value = [UInt8](characteristic.value!)
////
////            print(value)
////
////
////            print(value[0])
////        }
//        
//        //  print("Response from BLE Device: \(readValue)")
//        
//    }
//  
// 
//    
//    //if you want to send an string you can use this function.
//    func writeValue() {
//
//        if isMyPeripheralConected {
//
//            let dataToSend: Data = "464D4258AAAAAAAA0038000203013DE1".data(using: String.Encoding.utf8)!
//
//            print(dataToSend)
//
////            let command:[UInt8] = [0x01]
////
////            let sendData:Data = Data(command)
//
//
//            selectedBLEDevice?.writeValue(dataToSend, for: txCharacteristic!, type: .withResponse)
//
//            //check if myPeripheral is connected to send data
//
//            //let dataToSend: Data = "Hello World!".data(using: String.Encoding.utf8)!
//
//            //myBluetoothPeripheral.writeValue(dataToSend, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)    //Writing the data to the peripheral
//
//        } else {
//            print("Not connected")
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        //let indexPath = NSIndexPath(forRow: tag, inSection: 0)
//        //let cell = tableView.cellForRow(at: indexPath) as! gpsSettingsCustomCell!
//        //print(cell?.cellLabel.text ?? "")
//        
//        self.myBluetoothPeripheral[indexPath.row].delegate = self
//        
//        manager.stopScan()                          //stop scanning for peripherals
//        manager.connect(myBluetoothPeripheral[indexPath.row], options: nil)
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
//class BLEDeviceCustomCell: UITableViewCell {
//    //var cellButton: UIButton!
//    var cellLabel: UILabel!
//    var cellLabel2: UILabel!
//    
//    init(frame: CGRect, title: String) {
//        super.init(style: .default, reuseIdentifier: "cell")
//        //super.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
//        
//        cellLabel = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width, height: 20))
//        cellLabel.font = UIFont(name: "Titillium-Regular", size: 14.0)
//        //cellLabel= UILabel(frame: CGRectMake(self.frame.width - 100, 10, 100.0, 40))
//        cellLabel.textColor = UIColor.black
//        //cellLabel.font = //set font here
//        
//        cellLabel2 = UILabel(frame: CGRect(x: 10, y: 30, width: self.frame.width, height: 20))
//        cellLabel2.font = UIFont(name: "Titillium-Regular", size: 14.0)
//        cellLabel2.textColor = UIColor.gray
//        //cellButton = UIButton(frame: CGRectMake(5, 5, 50, 30))
//        //cellButton.setTitle(title, forState: UIControlState.Normal)
//        
//        addSubview(cellLabel)
//        addSubview(cellLabel2)
//        //addSubview(cellButton)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//}
//





//import CoreBluetooth
//
//let batteryServiceCBUUID = CBUUID(string: "FFB0")
//let batteryServiceRequestCBUUID = CBUUID(string: "FFB1")
//let batteryServiceRequestCBUUID2 = CBUUID(string: "FFB2")
//
// class ChargingViewController: UIViewController , CBPeripheralDelegate
// ,CBCentralManagerDelegate {
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
// centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
// }
// func centralManagerDidUpdateState(_ central: CBCentralManager) {
//
//    switch central.state {
//    case .unknown:
//        print("central.state is .unknown")
//    case .resetting:
//        print("central.state is .resetting")
//    case .unsupported:
//        print("central.state is .unsupported")
//    case .unauthorised:
//        print("central.state is .unauthorised")
//    case .poweredOff:
//        print("central.state is .poweredOff")
//    case .poweredOn:
//
//
//        centralManager.scanForPeripherals(withServices: [batteryServiceCBUUID])
//
//        print("central.state is .poweredOn")
//    @unknown default:
//        fatalError()
//    }
//
//    print("state: \(central.state)")
//
// }
// func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
// advertisementData: [String : Any], rssi RSSI: NSNumber) {
//
//    print(peripheral)
//    batteryServicePeripheral = peripheral
//    batteryServicePeripheral.delegate = self
//    centralManager.stopScan()
//    centralManager.connect(batteryServicePeripheral)
//
// }
//  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//
//    print("Connected=======>\(String(describing: batteryServicePeripheral))")
//    batteryServicePeripheral.delegate = self
//    batteryServicePeripheral.discoverServices([batteryServiceCBUUID])
//
//}
//
//func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral,
// error: Error?) {
//
//    print("Fail To Connect=======>\(String(describing: error))")
//}
//
//
//func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral:
//CBPeripheral, error: Error?) {
//
//    if error == nil {
//
//        print("Disconnected========>\(peripheral)")
//    }else {
//
//        print("Disconnected========>\(String(describing: error))")
//    }
// }
//// MARK: -  CBPeripheral Delegate Methods
//
//func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//
//    guard let services = peripheral.services else { return }
//
//    for service in services {
//
//        print("SPAKA:PERIPHERALSERVICES============>\(service)")
//        peripheral.discoverCharacteristics(nil, for: service)
//
//    }
//
//}
//
//func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//
//    if let characteristics = service.characteristics {
//        //else { return }
//
//        for characteristic in characteristics {
//
//            print(characteristic)
//
//
//            if characteristic.uuid == batteryServiceCBUUID {
//
//               peripheral.setNotifyValue(true, for: characteristic)
//
//            }
//
//            if characteristic.uuid == batteryServiceRequestCBUUID2 {
//
//                batteryCharacteristics = characteristic
//
//
//                let str1 = "55e100"
//                let data = String(format: "%@%@",str1,hexTimeForChar)
//
//                guard let valueString = data.data(using: String.Encoding.utf8)  else
//    {return}
//
//
//
//                peripheral.writeValue(valueString, for: characteristic , type:
//        CBCharacteristicWriteType.withoutResponse)
//                print("Value String===>\(valueString.debugDescription)")
//                peripheral.setNotifyValue(true, for: characteristic)
//
//            }
//
//        }
//    }
//    peripheral.discoverDescriptors(for: batteryCharacteristics)
//}
//
//
//func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//
//    if error == nil {
//        print("Message sent=======>\(String(describing: characteristic.value))")
//    }else{
//
//        print("Message Not sent=======>\(String(describing: error))")
//    }
//
//
//
//
//}
//
//func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic:
//CBCharacteristic, error: Error?) {
//
//    if error == nil {
//        print("SPAKA : IS NOTIFYING UPDATED STATE ======>\(characteristic.isNotifying)")
//        print("SPAKA : UPDATED DESCRIPTION ======>\(String(describing:
// characteristic.description))")
//
//
//    }else{
//        print("SPAKA : ERRORUPDATEDNOTIFICATION\(String(describing: error))")
//    }
//
//
//}
//
//
//func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//
//    print("SPAKA: UPDATED VALUE RECEIVED========>\(String(describing: characteristic.value))")
//    print("characteristic UUID: \(characteristic.uuid), value: \(characteristic.value)")
//
//    guard let str = characteristic.value else { return  }
//
//    if let string = String(bytes: str, encoding: .utf8) {
//        print("SPAKA==========>:::\(string)")
//    } else {
//        print("not a valid UTF-8 sequence")
//    }
//
//
//
//}
//
//func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//
//    guard let desc = batteryCharacteristics.descriptors else { return }
//
//
//    for des in desc {
//
//        print("BEGIN:SPAKA DESCRIPTOR========>\(des)")
//        discoveredDescriptor = des
//
//        print("Descriptor Present Value and uuid: \(des.uuid), value: \(String(describing: des.value))")
//        peripheral.readValue(for: discoveredDescriptor)
//
//
//    }
//
//
//}
//
//func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
//    if let error = error {
//        print("Failed… error: \(error)")
//        return
//    }
//
//    print("Descriptor Write Value uuid: \(descriptor.uuid), value: \(String(describing: descriptor.value))")
//}
//
//func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
//
//    if let error = error {
//        print("Failed… error: \(error)")
//        return
//    }
//
//    print("Descriptor Updated Value uuid: \(descriptor.uuid), value: \(String(describing: descriptor.value))")
//
//}
//}

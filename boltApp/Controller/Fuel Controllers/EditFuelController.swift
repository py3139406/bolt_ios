//
//  EditFuelController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import RealmSwift
import Firebase
//import ImagePicker

class EditFuelController: UIViewController {
    
    lazy var imagePicker = UIImagePickerController()
    var fuelView:FuelHistoryView!
    var realm: Realm!
    var list = ["Cash" ,"Credit Card","Debit Card","Online Wallet"]
    var isTappedPaymentMethod  = false
    var fuelPaymentTye = "cash"
    var attachFileName = ""
     var imagePickerController:UIImagePickerController!
    var uploadImage:Data?
    var HUD:MBProgressHUD?
    override func viewDidLoad() {
        super.viewDidLoad()
        try! realm = Realm()
        view.backgroundColor = .clear
        addViews()
        addConstraints()
        setActions()
        showFuelData()
    }
    func setActions(){
        fuelView.dropDownBtn.addTarget(self, action: #selector(showPaymentList), for: .touchUpInside)
        fuelView.petrolButton.addTarget(self, action: #selector(petrolDieselSwitchFunction(_:)), for: .touchUpInside)
        fuelView.dieselButton.addTarget(self, action: #selector(petrolDieselSwitchFunction(_:)), for: .touchUpInside)
        fuelView.attachBillBtn.addTarget(self, action: #selector(attachBillBtnTapped(_:)), for: .touchUpInside)
        fuelView.pricePerLitreTextField.addTarget(self, action: #selector(gettingTotalFuel(_:)), for: .allEditingEvents)
        fuelView.totalAmountTextField.addTarget(self, action: #selector(gettingTotalFuel(_:)), for: .allEditingEvents)
        fuelView.doneButton.addTarget(self, action: #selector(dismissthisView(_:)), for: .touchUpInside)
        fuelView.historyButton.addTarget(self, action: #selector(showHistory(_:)), for: .touchUpInside)
        fuelView.table.register(UITableViewCell.self, forCellReuseIdentifier: "list")
        fuelView.table.delegate = self
        fuelView.table.dataSource = self
    }
    @objc func showHistory(_ sender:UIButton){
        let page = FuelHistoryController()
        page.modalPresentationStyle = .custom
        self.present(page, animated: true, completion: nil)
    }
    @objc func showPaymentList(){
        if fuelView.table.isHidden {
            fuelView.table.isHidden = false
        } else {
            fuelView.table.isHidden = true
        }
    }
    func addViews() {
        fuelView = FuelHistoryView()
        fuelView.layer.cornerRadius = 10
        fuelView.layer.masksToBounds = true
        view.addSubview(fuelView)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != fuelView  && touch?.view != fuelView.paymentMethodTextField{
            self.dismiss(animated: true, completion: nil)
        } else {
            fuelView.table.isHidden = true
        }
    }
    
    @objc func attachBillBtnTapped(_ sender: UIButton){

        let alertController = UIAlertController(title: "Add Document!".toLocalize, message: "", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Take Photo".toLocalize, style: .default, handler:{_ in
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.cameraDevice = .rear
            self.imagePickerController.cameraCaptureMode = .photo
            self.imagePickerController.showsCameraControls = true
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.modalPresentationStyle = .overCurrentContext
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        let gallery = UIAlertAction(title: "Gallery".toLocalize, style: .default, handler: {_ in
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .savedPhotosAlbum
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.modalPresentationStyle = .overCurrentContext
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
        
    }
    @objc func gettingTotalFuel(_ sender: UIButton){
            let pricePerLit = Double(fuelView.pricePerLitreTextField.text!) ?? 0
            let totalAmount = Double(fuelView.totalAmountTextField.text!) ?? 0
        if pricePerLit != 0 {
            fuelView.totalFilledLabel.text = "\(Double(round(10 * (totalAmount / pricePerLit))/10)) L"
        } else {
            fuelView.totalFilledLabel.text = "0 L"
        }
    }

    
    @objc fileprivate func dismissthisView(_ sender: UIButton) {
        if !(fuelView.vehicleMilageTextField.text ?? "").isEmpty && !(fuelView.totalAmountTextField.text ?? "").isEmpty &&
            !(fuelView.paymentMethodTextField.text ?? "").isEmpty &&
            !(fuelView.pricePerLitreTextField.text ?? "").isEmpty{
            saveFuelDataToRealm()
            NotificationCenter.default.post(name: NSNotification.Name.init("close"), object: nil)
        } else {
            prompt("Please fill all the fields")
        }
    }
    
    @objc fileprivate func petrolDieselSwitchFunction(_ sender: RadioButton) {
        fuelView.dieselButton.isSelected = !fuelView.dieselButton.isSelected
        fuelView.petrolButton.isSelected = !fuelView.petrolButton.isSelected
    }
    
    fileprivate func showFuelData() {
        let fuelData = realm.objects(FuelModelApiData.self).filter("device_id ==%@", "\(bottomSheetDeviceId)")
        if fuelData.last?.fuel_type == "petrol" {
            fuelView.petrolButton.isSelected = true
            fuelView.dieselButton.isSelected = false
        } else {
            fuelView.petrolButton.isSelected = false
            fuelView.dieselButton.isSelected = true
        }
        if let lastamount = fuelData.last?.fuel_filled {
            
            let lastAmountDecimal  = Double(lastamount) ?? 0.0
            let doubleStr = String(format: "%.1f", ceil(lastAmountDecimal*1000)/1000)
            fuelView.lastFilledLabel.text = doubleStr + "L"
            
        }
        
        
        if let lastamount = fuelData.last?.amount {
            
            fuelView.lastFilledLabel.text = "INR" + lastamount
        }
        
        if let oldPricePerLitre = fuelData.last?.price_per_litre {
            
            fuelView.pricePerLitreTextField.text = oldPricePerLitre
        }
        
        
        if let lastDate = fuelData.last?.timestamp {
            fuelView.lastFillDateHeading.text = RCGlobals.getStringDateFromString(lastDate)
            
        }
        
    }
    
    fileprivate func odometerReading() -> Double {
        let keyValueDevicePos = "Position_" + "\(bottomSheetDeviceId)"
        let trackerPosition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValueDevicePos))
        var tempTotalDistance = trackerPosition?.attributes?.totalDistance ?? 0.0
        if tempTotalDistance > 0.0 {
            tempTotalDistance = tempTotalDistance / 1000.0
            tempTotalDistance = tempTotalDistance.rounded(toPlaces: 1)
        }
        return tempTotalDistance
    }
    
    
    
    fileprivate func saveFuelDataToRealm() {
        
        let fueltype = { () -> String in
            if fuelView.petrolButton.isSelected {
                return "petrol"
            } else {
                return "diesel"
            } }()
        var totalFilled = 0.0
        if let fuel = fuelView.totalAmountTextField.text {
            let fuelDouble = Double(fuel)!
            let priceDouble = Double(fuelView.pricePerLitreTextField.text!)!
            totalFilled = (fuelDouble / priceDouble)
        }
        guard let fuelAmount = Double(fuelView.totalAmountTextField.text!),  let price = Double(fuelView.pricePerLitreTextField.text!), let milage = Double(fuelView.vehicleMilageTextField.text!) else {
            return
        }
        let totalDistance = odometerReading()
        let currentdate = Date()
        let _ = RCGlobals.getFormattedHistory(date: currentdate as NSDate)
        let timestamp = NSDate().timeIntervalSince1970
        attachFileName = "FUEL_\(bottomSheetDeviceId)_\(timestamp).jpeg"
        showProgress(message: "Please wait...")
        if let image = uploadImage {
            sendImageToServer(imageData: image, onCompletion: { fileURL in
                RCLocalAPIManager.shared.postFuelDetails(deviceID: bottomSheetDeviceId, totalDistance: "\(totalDistance)",
                                                         paymentType: self.fuelPaymentTye, imageName: fileURL, amount: "\(fuelAmount)", priceLitre: "\(price)",
                                                         fuelFilled: "\(totalFilled)", fuelType: fueltype, milage: "\(milage)", success: { (_) in
                    self.fuelView.totalAmountTextField.text = ""
                    self.fuelView.totalFilledLabel.text = ""
                    
                    self.prompt("Details saved successfully.")
                    self.hideProgress()
                    
                }) { (error) in
                    self.hideProgress()
                    self.prompt(error)
                }
            }, onFail: { error in
                self.hideProgress()
                self.prompt(error)
            })
        } else {
            RCLocalAPIManager.shared.postFuelDetails(deviceID: bottomSheetDeviceId, totalDistance: "\(totalDistance)",
                                                     paymentType: fuelPaymentTye, imageName: attachFileName, amount: "\(fuelAmount)", priceLitre: "\(price)",
                                                     fuelFilled: "\(totalFilled)", fuelType: fueltype, milage: "\(milage)", success: { (_) in
                    self.fuelView.totalAmountTextField.text = ""
                    self.fuelView.totalFilledLabel.text = ""
                    
                    self.prompt("Details saved successfully.")
                    self.hideProgress()
            }) { (error) in
                self.hideProgress()
                self.prompt(error)
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func addConstraints() {
        fuelView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }
}

extension UIView {
    private static let lineDashPattern: [NSNumber] = [2, 2]
    private static let lineDashWidth: CGFloat = 1.0
    
    func makeDashedBorderLine() {
        let path = CGMutablePath()
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = UIView.lineDashWidth
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineDashPattern = UIView.lineDashPattern
        path.addLines(between: [CGPoint(x: bounds.minX, y: bounds.height/2),
                                CGPoint(x: bounds.maxX, y: bounds.height/2)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}


extension EditFuelController {
    
    func showProgress(message:String) {
        let topWindow = UIApplication.shared.keyWindow
        HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        HUD?.animationType = .fade
        HUD?.mode = .indeterminate
        HUD?.labelText = message
    }
    
    func hideProgress() {
        HUD?.hide(true)
    }
    
    func sendImageToServer(imageData: Data, onCompletion: @escaping (String) -> Void, onFail: @escaping (String) -> Void ) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let markerRef = storageRef.child("FUEL/\(attachFileName)")
        _ = markerRef.putData(imageData, metadata: metadata) {
            (metadata, error) in
            guard metadata != nil else {
                onFail("Image upload failed")
                // Uh-oh, an error occurred!
                return
            }
            markerRef.downloadURL {
                (url, error) in
                guard let downloadURL = url
                    else {
                    onFail("Image upload failed")
                    return
                }
                onCompletion(downloadURL.absoluteString)
            }
        }
    }
    
}

extension EditFuelController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =   tableView.cellForRow(at: indexPath)
        fuelView.paymentMethodTextField.text =   cell?.textLabel?.text
        fuelView.table.isHidden = true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
extension EditFuelController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        var selectedImageFromImagePicker: UIImage?

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }

        if let selectedImage = selectedImageFromImagePicker {
            // add img where you want to use
            let imageData = compressImage(image: selectedImage)
            uploadImage = imageData
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

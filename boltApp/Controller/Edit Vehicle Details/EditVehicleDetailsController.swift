//
//  EditVehicleDetailsController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
//import ImagePicker
import SafariServices
import MobileCoreServices

var expiredVehicleDate = ""
var expiredVehicleNumber = ""

class EditVehicleDetailsController: UIViewController {

    var taxdate = String()
    fileprivate var vehicleDetailsView: EditVehicleDetailsView!
    var titleNaviagtionBar: String = ""
    var deviceId: String = ""
    fileprivate var vehicleData: EditDevicesInfosModelData!
    lazy var datePicker = UIDatePicker()
    lazy var polutionPicker = UIDatePicker()
    lazy var fitnessPicker = UIDatePicker()
    lazy var nationalPicker = UIDatePicker()
    lazy var fiveYearsPicker = UIDatePicker()
    lazy var taxPicker = UIDatePicker()
    lazy var brandpicker = UIPickerView()
    lazy var modelpicker = UIPickerView()
    lazy var imagePicker = UIImagePickerController()
    lazy var textfeildNo = 0
    private var carListjson = Dictionary<String, Array<String>>()
    let rest = RestManager()
    
    override func viewWillAppear(_ animated: Bool) {
        // infilateDataOnView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infilateDataOnView()
        addNavigationBar()
        addViewsAndButtons()
        setConstraints()
        delegateFunctions()
        dataFormJSONFile()
        showPickerView()
        showTimePicker()
    }
    func setConstraints(){
        vehicleDetailsView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }

    private func addViewsAndButtons() {
        vehicleDetailsView = EditVehicleDetailsView(frame: CGRect.zero)
        view.backgroundColor = appDarkTheme
        view.addSubview(vehicleDetailsView)
        brandpicker.tag = 0
        modelpicker.tag = 1
        datePicker.tag = 0
        polutionPicker.tag = 1
        vehicleDetailsView.registrationCeritificateLabel.tag = 0
        vehicleDetailsView.pollutionImageLabel.tag = 1
        vehicleDetailsView.insuranceImageLabel.tag = 2
        vehicleDetailsView.fitnessImageLabel.tag = 3
        vehicleDetailsView.nationalPermitExpiryImageLabel.tag = 4
        vehicleDetailsView.fiveYearsPermitExpiryImageLabel.tag = 5
        vehicleDetailsView.taxExpiryImageLabel.tag = 6
        vehicleDetailsView.vehicleNumberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeVehicleNumber(_:))))
        vehicleDetailsView.registrationCeritificateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.pollutionImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.fitnessImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.nationalPermitExpiryImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.fiveYearsPermitExpiryImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.taxExpiryImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.insuranceImageLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageShowingFunction(_:))))
        vehicleDetailsView.docImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullScreenImage(_:))))
        vehicleDetailsView.editButton.addTarget(self, action: #selector(editImageOrPDFFunction), for: .touchUpInside)
        vehicleDetailsView.dismissButton.addTarget(self, action: #selector(dismissImageView), for: .touchUpInside)
        
        vehicleDetailsView.extendSubscriptionButton.addTarget(self, action: #selector(renewSubscriptionButtonFunc), for: .touchUpInside)
        
    }
    
    @objc func renewSubscriptionButtonFunc(){
//        print("Extend subscription tapped")
//        let alertView = UIAlertController(title: "Extend Subscription", message: "This featue will be available soon", preferredStyle: UIAlertController.Style.alert)
//        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alertView, animated: true, completion: nil)
        
//        let tag = "Inbox"
//        let message = "I want to renew my subscription for " + (vehicleData.name ?? "") + "."
//        let freshchatMessage = FreshchatMessage.init(message: message, andTag: tag)
//        Freshchat.sharedInstance().send(freshchatMessage)
//        Freshchat.sharedInstance().showConversations(self)
        
        let vc = SubscriptiomMainVC()
        
        var deviceIdArray:[String] = []
        
        deviceIdArray.append(vehicleData.id ?? "")
        
        if (RCGlobals.isAISDevice(deviceId: Int(vehicleData.id ?? "0") ?? 0)) {
            vc.selectedAISDeviceArray = deviceIdArray
        } else {
            vc.selectedNormalDeviceArray = deviceIdArray
        }
        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated: false, completion: nil)
        
    }
    
    private func delegateFunctions() {
        brandpicker.dataSource = self
        brandpicker.delegate = self
        modelpicker.dataSource = self
        modelpicker.delegate = self
      //  imagePicker.delegate = self
    }
    
    private func dataFormJSONFile() {
        if let path = Bundle.main.path(forResource: "car_list", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let carList = jsonResult as! NSArray
                for car in carList {
                    print(car)
                    if let dictonary = car as? [String: Any] {
                        if let brand = dictonary["brand"] as? String, let model = dictonary["models"] as? [String] {
                            carListjson[brand] = model.sorted()
                        }
                    }
                }
            } catch {
                print("There was a error converting json")
            }
        }
        print(carListjson)
    }
    
    
    private func showTimePicker() {
        datePicker.datePickerMode = .date
        polutionPicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        polutionPicker.minimumDate = Date()
        fitnessPicker.datePickerMode = .date
        fitnessPicker.minimumDate = Date()
        nationalPicker.datePickerMode = .date
        nationalPicker.minimumDate = Date()
        fiveYearsPicker.datePickerMode = .date
        fiveYearsPicker.minimumDate = Date()
        taxPicker.datePickerMode = .date
        taxPicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            polutionPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            fitnessPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            nationalPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            fiveYearsPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            taxPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
            datePicker.tintColor = .black
            datePicker.backgroundColor = .white
            polutionPicker.tintColor = .black
            polutionPicker.backgroundColor = .white
            fitnessPicker.tintColor = .black
            fitnessPicker.backgroundColor = .white
            nationalPicker.tintColor = .black
            nationalPicker.backgroundColor = .white
            fiveYearsPicker.tintColor = .black
            fiveYearsPicker.backgroundColor = .white
            taxPicker.tintColor = .black
            taxPicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        
        
        //Mark: ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelTimePicker))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: true)
        
        vehicleDetailsView.insuranceExpiryDateLabel.inputAccessoryView = toolbar
        vehicleDetailsView.insuranceExpiryDateLabel.inputView = datePicker
        
        vehicleDetailsView.pollutionExpiryDateLabel.inputAccessoryView = toolbar
        vehicleDetailsView.pollutionExpiryDateLabel.inputView = polutionPicker
        
        vehicleDetailsView.fitnessExpiryDateLabel.inputAccessoryView = toolbar
        vehicleDetailsView.fitnessExpiryDateLabel.inputView = fitnessPicker
        
        vehicleDetailsView.nationalPermitExpiryDateLabel.inputAccessoryView = toolbar
        vehicleDetailsView.nationalPermitExpiryDateLabel.inputView = nationalPicker
        
        vehicleDetailsView.fiveYearsPermitExpiryDateLabel.inputAccessoryView = toolbar
        vehicleDetailsView.fiveYearsPermitExpiryDateLabel.inputView = fiveYearsPicker
        
        vehicleDetailsView.taxExpiryDateLabel.inputAccessoryView = toolbar
        vehicleDetailsView.taxExpiryDateLabel.inputView = taxPicker
    }
    
    @objc private func doneTimePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd"
        if vehicleDetailsView.insuranceExpiryDateLabel.isEditing {
            vehicleDetailsView.insuranceExpiryDateLabel.text = checkAndFormatDate(dateString: formatter.string(from: datePicker.date), informat: "yyyy-MM-dd")
            requestToUpdate(first: "insuranceExpiryDate", second: formatter.string(from: datePicker.date))
        } else if vehicleDetailsView.pollutionExpiryDateLabel.isEditing {
            vehicleDetailsView.pollutionExpiryDateLabel.text = checkAndFormatDate(dateString: formatter.string(from: polutionPicker.date), informat: "yyyy-MM-dd")
            requestToUpdate(first: "pollutionExpiryDate", second: formatter.string(from: polutionPicker.date))
        } else if vehicleDetailsView.fitnessExpiryDateLabel.isEditing {
            vehicleDetailsView.fitnessExpiryDateLabel.text = checkAndFormatDate(dateString: formatter.string(from: fitnessPicker.date), informat: "yyyy-MM-dd")
            requestToUpdate(first: "fitness_expiry_date", second: formatter.string(from: fitnessPicker.date))
        } else if vehicleDetailsView.nationalPermitExpiryDateLabel.isEditing {
            vehicleDetailsView.nationalPermitExpiryDateLabel.text = checkAndFormatDate(dateString: formatter.string(from: nationalPicker.date), informat: "yyyy-MM-dd")
            requestToUpdate(first: "national_permit_expiry", second: formatter.string(from: nationalPicker.date))
        } else if vehicleDetailsView.fiveYearsPermitExpiryDateLabel.isEditing {
            vehicleDetailsView.fiveYearsPermitExpiryDateLabel.text = checkAndFormatDate(dateString: formatter.string(from: fiveYearsPicker.date), informat: "yyyy-MM-dd")
            requestToUpdate(first: "five_year_permit_expiry", second: formatter.string(from: fiveYearsPicker.date))
        } else if vehicleDetailsView.taxExpiryDateLabel.isEditing {
            vehicleDetailsView.taxExpiryDateLabel.text = checkAndFormatDate(dateString: formatter.string(from: taxPicker.date), informat: "yyyy-MM-dd")
            requestToUpdate(first: "token_tax_expiry", second: formatter.string(from: taxPicker.date))
            taxdate = vehicleDetailsView.taxExpiryDateLabel.text ?? "N/A"
            UserDefaults.standard.set(taxdate, forKey: "taxdate")
        }
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker() {
        self.view.endEditing(true)
    }
    
    private func addNavigationBar() {
        self.navigationItem.title = titleNaviagtionBar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc private func dismissImageView() {
        vehicleDetailsView.imagePopupView.isHidden = true
    }
    
    @objc private func editImageOrPDFFunction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { [weak self] action in
            guard let weakself = self else { return }
            weakself.openImagePicker()
        }))
        alert.addAction(UIAlertAction(title: "PDF", style: .default, handler: { [weak self] action in
            guard let weakself = self else { return }
            weakself.openDocuments()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
     func infilateDataOnView() {
        RCLocalAPIManager.shared.getDevicesDetails(success: { [weak self] value in
            guard let weakself = self else { return }
            let temp = value.data?.filter( { $0.id == self?.deviceId } ).map({ $0 })
            if let CarData = temp?.first {
                weakself.vehicleData = CarData
                weakself.showTextInView(model: CarData)
            }
            
        }) { [weak self] message in
            guard let weakself = self else { return }
            weakself.prompt(message)
        }
    }
    
    @objc func changeVehicleNumber(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Change vehicle number".toLocalize , message: nil , preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = self.vehicleDetailsView.vehicleNumberLabel.text ?? "Enter your vehicle number"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let vehicleName = alert.textFields?.first?.text {
            self.requestToUpdate(first: "vehicleRegistrationNumber", second: vehicleName)
                self.vehicleDetailsView.vehicleNumberLabel.text = alert.textFields?.first?.text
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func checkAndFormatDate(dateString: String?, informat: String = "yyyy-MM-dd", outformat: String = "dd-MMM-yyyy") -> String{
        if let date = dateString {
            return RCGlobals.getStringDateFromString(date, informat: informat, outformat: outformat)
        }
        return "N/A"
    }
    
    private func showTextInView(model: EditDevicesInfosModelData) {
        vehicleDetailsView.vehicleNumberLabel.text = model.vehicleRegistrationNumber ?? "N/A"
        vehicleDetailsView.vehicleNumberLabel.underline()
        vehicleDetailsView.dateLabel.text = checkAndFormatDate(dateString: model.dateAdded, informat: "yyyy-MM-dd HH:mm:ss")
        vehicleDetailsView.insuranceExpiryDateLabel.text = checkAndFormatDate(dateString: model.insuranceExpiryDate)
        vehicleDetailsView.insuranceExpiryDateLabel.underline()
        vehicleDetailsView.pollutionExpiryDateLabel.text = checkAndFormatDate(dateString: model.pollutionExpiryDate)
        vehicleDetailsView.pollutionExpiryDateLabel.underline()
        vehicleDetailsView.brandTextfield.text = model.vehicleBrand
        vehicleDetailsView.modelTextfield.text = model.vehicleModel
        vehicleDetailsView.fitnessExpiryDateLabel.text = checkAndFormatDate(dateString: model.fitnessExpiryDate)
        vehicleDetailsView.fitnessExpiryDateLabel.underline()
        vehicleDetailsView.nationalPermitExpiryDateLabel.text = checkAndFormatDate(dateString: model.nationalPermitExpiry)
        vehicleDetailsView.nationalPermitExpiryDateLabel.underline()
        vehicleDetailsView.fiveYearsPermitExpiryDateLabel.text = checkAndFormatDate(dateString: model.fiveYearPermitExpiry)
        vehicleDetailsView.fiveYearsPermitExpiryDateLabel.underline()
        vehicleDetailsView.taxExpiryDateLabel.text = checkAndFormatDate(dateString: model.taxExpiry)
        vehicleDetailsView.taxExpiryDateLabel.underline()
        vehicleDetailsView.subscriptionDateLabel.text = model.subscriptionExpiryDate ?? "N/A"
        let x = model.subscriptionExpiryDate ?? ""
        expiredVehicleDate = "\(RCGlobals.getDateFrom(x))"
        expiredVehicleNumber = model.vehicleRegistrationNumber ?? "NA"
        
        if (model.pollutionCertificateUpload) == nil {
            vehicleDetailsView.pollutionImageLabel.text = "Add Image"
            vehicleDetailsView.pollutionImageLabel.underline()
            
        } else if (model.pollutionCertificateUpload) != nil
        {   vehicleDetailsView.pollutionImageLabel.text = "View Image"
            vehicleDetailsView.pollutionImageLabel.underline()
        }
        if (model.insuranceUpload) == nil {
            vehicleDetailsView.insuranceImageLabel.text = "Add Image"
            vehicleDetailsView.insuranceImageLabel.underline()
        } else {
            vehicleDetailsView.insuranceImageLabel.text = "View Image"
            vehicleDetailsView.insuranceImageLabel.underline()
        }
        //#sani
        if (model.carRcCopy) == nil {
            vehicleDetailsView.registrationCeritificateLabel.text = "Add Image"
            vehicleDetailsView.registrationCeritificateLabel.underline()
        } else {
            vehicleDetailsView.registrationCeritificateLabel.text = "View Image"
            vehicleDetailsView.registrationCeritificateLabel.underline()
        }
        if (model.fitnessUploadUrl) == nil {
            vehicleDetailsView.fitnessImageLabel.text = "Add Image"
            vehicleDetailsView.fitnessImageLabel.underline()
        } else {
            vehicleDetailsView.fitnessImageLabel.text = "View Image"
            vehicleDetailsView.fitnessImageLabel.underline()
        }
        if model.nationalPermitUpload == nil {
            vehicleDetailsView.nationalPermitExpiryImageLabel.text = "Add Image"
            vehicleDetailsView.nationalPermitExpiryImageLabel.underline()
        } else {
            vehicleDetailsView.nationalPermitExpiryImageLabel.text = "View Image"
            vehicleDetailsView.nationalPermitExpiryImageLabel.underline()
        }
        if model.fiveYearPermitUpload == nil {
            vehicleDetailsView.fiveYearsPermitExpiryImageLabel.text = "Add Image"
            vehicleDetailsView.fiveYearsPermitExpiryImageLabel.underline()
        } else {
            vehicleDetailsView.fiveYearsPermitExpiryImageLabel.text = "View Image"
            vehicleDetailsView.fiveYearsPermitExpiryImageLabel.underline()
        }
        if model.taxUpload == nil {
            vehicleDetailsView.taxExpiryImageLabel.text = "Add Image"
            vehicleDetailsView.taxExpiryImageLabel.underline()
        } else {
            vehicleDetailsView.taxExpiryImageLabel.text = "View Image"
            vehicleDetailsView.taxExpiryImageLabel.underline()
        }
    }
    
    
    @objc private func imageShowingFunction(_ sender: UITapGestureRecognizer) {
        if vehicleData != nil {
        switch sender.view?.tag {
        case 0:
            textfeildNo = 0
            
            if (vehicleData.registrationCertificateUrl) == nil && (vehicleData.carRcCopy == nil) {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        case 1:
            textfeildNo = 1
            if (vehicleData.pollutionCertificateUpload) == nil {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        case 2:
            textfeildNo = 2
            if (vehicleData.insuranceUpload) == nil {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        case 3:
            textfeildNo = 3
            if (vehicleData.fitnessUploadUrl) == nil {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        case 4:
            textfeildNo = 4
            if (vehicleData.nationalPermitUpload) == nil {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        case 5:
            textfeildNo = 5
            if (vehicleData.fiveYearPermitUpload) == nil {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        case 6:
            textfeildNo = 6
            if (vehicleData.taxUpload) == nil {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "cross")
                editImageOrPDFFunction()
            } else {
                vehicleDetailsView.imagePopupView.isHidden = false
                showImageThumbnail()
            }
        default:
            break
            } }
    }
    
    func showImageThumbnail() {
        switch textfeildNo {
        case 0:
            if vehicleData.carRcCopy != nil  {
                if !(vehicleData.carRcCopy?.contains("pdf"))! {
                    //#sani
                    thumbnail(url: vehicleData.carRcCopy!)
                } else {
                    vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
                }
            } else if vehicleData.registrationCertificateUrl != nil {
            if !(vehicleData.registrationCertificateUrl?.contains("pdf"))! {
                //#sani
               thumbnail(url: vehicleData.registrationCertificateUrl!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
            }
        case 1:
            if !(vehicleData.pollutionCertificateUpload?.contains("pdf"))! {
                thumbnail(url: vehicleData.pollutionCertificateUpload!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
        case 2:
            if !(vehicleData.insuranceUpload?.contains("pdf"))! {
                thumbnail(url: vehicleData.insuranceUpload!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
        case 3:
            if !(vehicleData.fitnessUploadUrl?.contains("pdf"))! {
                thumbnail(url: vehicleData.fitnessUploadUrl!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
        case 4:
            if !(vehicleData.nationalPermitUpload?.contains("pdf"))! {
                thumbnail(url: vehicleData.nationalPermitUpload!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
        case 5:
            if !(vehicleData.fiveYearPermitUpload?.contains("pdf"))! {
                thumbnail(url: vehicleData.fiveYearPermitUpload!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
        case 6:
            if !(vehicleData.taxUpload?.contains("pdf"))! {
                thumbnail(url: vehicleData.taxUpload!)
            } else {
                vehicleDetailsView.docImage.image = #imageLiteral(resourceName: "pdf")
            }
        default:
            break
        }
    }
    
    func thumbnail(url: String) {
        
       vehicleDetailsView.docImage.downloaded(from: "https://track.roadcast.co.in/" + url, contentMode: .scaleAspectFit)
    }
    
    func requestToUpdate(first: String, second: String) {
        RCLocalAPIManager.shared.putUsersCarsData(deviceId: deviceId, first: first, second: second, success: { [weak self]hash in
            guard let weakself = self else { return }
            weakself.infilateDataOnView()
            weakself.view.setNeedsDisplay()
        }) { [weak self] message in
            guard let _ = self else { return }
            print(message)
        }
    }
    
    @objc private func showFullScreenImage(_ sender: UITapGestureRecognizer) {
        if textfeildNo == 0 {
            if !(vehicleData.carRcCopy ?? "").isEmpty {
               openSafari(url: vehicleData.carRcCopy!)
            }
        } else if textfeildNo == 1 {
            if !(vehicleData.pollutionCertificateUpload ?? "").isEmpty {
                openSafari(url: vehicleData.pollutionCertificateUpload!)
            }
        } else if textfeildNo == 2 {
            if !(vehicleData.insuranceUpload ?? "").isEmpty {
                openSafari(url: vehicleData.insuranceUpload!)
            }
        } else if textfeildNo == 3 {
            if !(vehicleData.fitnessUploadUrl ?? "").isEmpty {
                openSafari(url: vehicleData.fitnessUploadUrl!)
            }
        } else if textfeildNo == 4 {
            if !(vehicleData.nationalPermitUpload ?? "").isEmpty {
                openSafari(url: vehicleData.nationalPermitUpload!)
            }
        } else if textfeildNo == 5 {
            if !(vehicleData.fiveYearPermitUpload ?? "").isEmpty {
                openSafari(url: vehicleData.fiveYearPermitUpload!)
            }
        } else if textfeildNo == 6 {
            if !(vehicleData.taxUpload ?? "").isEmpty {
                openSafari(url: vehicleData.taxUpload!)
            }
        }
    }
    
    
    @objc private func openDocuments() {
        
        let types: [String] = [kUTTypePDF as String]
        let importMenu = UIDocumentPickerViewController(documentTypes: types, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
       // self.prompt("Feature comming soon")
    }
    
     public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
                  guard let myURL = urls.first else {
                       return
                  }

                                 
                                  sendToServer(fileUrl: myURL)

                  print("import result : \(myURL)")
        }
    
    
    func sendToServer(fileUrl: URL) {
        
        
//        let pdfFileInfo = RestManager.FileInfo(withFileURL: fileUrl, filename: "samplePDF.pdf", name: "uploadedFile", mimetype: "application/pdf")
//
//        rest.httpBodyParameters.add(value: "saanica testing1 😀 ", forKey: "name")
//        rest.httpBodyParameters.add(value: "saanica@test2.yahoo.com", forKey: "email")
//        rest.httpBodyParameters.add(value: "9999999999", forKey: "phone")
//        rest.httpBodyParameters.add(value: "female", forKey: "gender")
//        rest.httpBodyParameters.add(value: "10", forKey: "age")
//
        
          
         //upload(files: [pdfFileInfo], toURL: URL(string: "http://45.115.177.99:8084/api/insurance"))
        
        
    }
    
 
    
    


    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
            documentPicker.delegate = self
        if #available(iOS 11.0, *) {
            documentPicker.allowsMultipleSelection = false
        } else {
            
            // Fallback on earlier versions
        }
            present(documentPicker, animated: true, completion: nil)
        }


    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                print("view was cancelled")
                dismiss(animated: true, completion: nil)
        }

}
extension EditVehicleDetailsController: UIPickerViewDelegate, UIPickerViewDataSource, UIDocumentPickerDelegate, UIDocumentMenuDelegate {
   
    private func showPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePickerView))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelPickerView))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: true)

            vehicleDetailsView.brandTextfield.inputAccessoryView = toolbar
            vehicleDetailsView.brandTextfield.inputView = brandpicker
            vehicleDetailsView.modelTextfield.inputAccessoryView = toolbar
            vehicleDetailsView.modelTextfield.inputView = modelpicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var value = 0
        if pickerView.tag == 0 {
            value = carListjson.count
        } else {
             let carbrand = vehicleDetailsView.brandTextfield.text
            if (carbrand?.isEmpty)! {
                value = 0
            } else {
                let array = Array(carListjson[carbrand!]!)
                value = array.count
            }
        }
        return value
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var newArray = ""
        if pickerView.tag == 0 {
            let array = Array(carListjson.keys)
            newArray = array[row]
        } else {
            if let carbrand = vehicleDetailsView.brandTextfield.text {
                let array = Array(carListjson[carbrand]!)
                newArray = array[row]
            }
        }
        return newArray
    }
    
    @objc private func donePickerView() {
        if vehicleDetailsView.brandTextfield.isEditing {
            let carBrand = Array(carListjson.keys)//.sorted()
            vehicleDetailsView.brandTextfield.text = carBrand[brandpicker.selectedRow(inComponent: 0)]
            requestToUpdate(first: "vehicleBrand", second: carBrand[brandpicker.selectedRow(inComponent: 0)])
        } else {
            let carbrand = vehicleDetailsView.brandTextfield.text!
            let carmodel = Array(carListjson[carbrand]!)
            vehicleDetailsView.modelTextfield.text = carmodel[modelpicker.selectedRow(inComponent: 0)]
            requestToUpdate(first: "vehicleModel", second: carmodel[modelpicker.selectedRow(inComponent: 0)])
        }
        self.view.endEditing(true)
    }
    
    @objc private func cancelPickerView() {
      self.view.endEditing(true)
    }
    
}

extension EditVehicleDetailsController {
    
    func openCameraGalleryChooser() {
        let alert = UIAlertController(title: "Choose source", message: "Select a source", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default){ action in
            
            self.imagePicker = UIImagePickerController()
                print("Button capture")
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default){ action in
            
            self.imagePicker = UIImagePickerController()
                print("Button capture")
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc private func openImagePicker() {
    //    imagePicker.imageLimit = 1
        openCameraGalleryChooser()
//        present(imagePicker, animated: true, completion: nil)
    }
    
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        dismissImageView()
//        dismiss(animated: true, completion: nil)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        let uploadImage = images.first!
//        let imageData = compressImage(image: uploadImage)
//        sendImageToServer(imageData: imageData)
//        dismissImageView()
//        dismiss(animated: true, completion: nil)
//    }
//
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        dismissImageView()
//        dismiss(animated: true, completion: nil)
//    }
    
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
    
//    func deleteOldFile(filename: String){
//         let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
//        let fileNameToDelete = filename
//        var filePath = "/user_docs/user_"+userID+"/"
//
//        // Find documents directory on device
//        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
//
//        if dirs.count > 0 {
//            let dir = dirs[0] //documents directory
//            filePath = dir.appendingFormat("/" + fileNameToDelete)
//            print("Local path = \(filePath)")
//
//        } else {
//            print("Could not find local directory to store file")
//            return
//        }
//
//
//        do {
//            let fileManager = FileManager.default
//
//            // Check if file exists
//            if fileManager.fileExists(atPath: filePath) {
//                // Delete file
//                try fileManager.removeItem(atPath: filePath)
//                print(filePath)
//            } else {
//                print("File does not exist")
//            }
//
//        }
//        catch let error as NSError {
//            print("An error took place: \(error)")
//        }
//
//    }
//
    func sendImageToServer(imageData: Data) {
       // let urloo = getDocumentsDirectory()
       // self.vehicleData = nil
        var filename = ""
        if textfeildNo == 0 {
            filename = "RC_\(deviceId).jpeg"
        } else if textfeildNo == 1 {
            filename = "POLLUTION_\(deviceId).jpeg"
        } else if textfeildNo == 2 {
            filename = "INSURANCE_\(deviceId).jpeg"
        } else if textfeildNo == 3 {
            filename = "FITNESS_\(deviceId).jpeg"
        } else if textfeildNo == 4 {
            filename = "NATIONAL_\(deviceId).jpeg"
        } else if textfeildNo == 5 {
            filename = "5YEAR_\(deviceId).jpeg"
        } else if textfeildNo == 6 {
            filename = "TOKEN_\(deviceId).jpeg"
        }
        
        let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        requestWith(imageData: imageData, fileName: filename, parameters: [ "userId" : userID ], onCompletion: { [weak self] message in
            guard let weakself = self else { return }
            if  message == "Success" {
            if weakself.textfeildNo == 0 {
                weakself.vehicleDetailsView.registrationCeritificateLabel.text = "View Image"
                weakself.vehicleDetailsView.registrationCeritificateLabel.underline()
                weakself.vehicleData.registrationCertificateUrl = "/user_docs/user_"+userID+"/"+filename
                
            } else if weakself.textfeildNo == 1 {
                weakself.vehicleDetailsView.pollutionImageLabel.text = "View Image"
                weakself.vehicleDetailsView.pollutionImageLabel.underline()
                weakself.vehicleData.pollutionCertificateUpload = "/user_docs/user_"+userID+"/"+filename
            } else if weakself.textfeildNo == 2 {
                weakself.vehicleDetailsView.insuranceImageLabel.text = "View Image"
                weakself.vehicleDetailsView.insuranceImageLabel.underline()
                weakself.vehicleData.insuranceUpload = "/user_docs/user_"+userID+"/"+filename
            } else if weakself.textfeildNo == 3 {
                weakself.vehicleDetailsView.fitnessImageLabel.text = "View Image"
                weakself.vehicleDetailsView.fitnessImageLabel.underline()
                weakself.vehicleData.fitnessUploadUrl = "/user_docs/user_"+userID+"/"+filename
            } else if weakself.textfeildNo == 4 {
                weakself.vehicleDetailsView.nationalPermitExpiryImageLabel.text = "View Image"
                weakself.vehicleDetailsView.nationalPermitExpiryImageLabel.underline()
                weakself.vehicleData.nationalPermitUpload = "/user_docs/user_"+userID+"/"+filename
            } else if weakself.textfeildNo == 5 {
                weakself.vehicleDetailsView.fiveYearsPermitExpiryImageLabel.text = "View Image"
                weakself.vehicleDetailsView.fiveYearsPermitExpiryImageLabel.underline()
                weakself.vehicleData.fiveYearPermitUpload = "/user_docs/user_"+userID+"/"+filename
            } else if weakself.textfeildNo == 6 {
                weakself.vehicleDetailsView.taxExpiryImageLabel.text = "View Image"
                weakself.vehicleDetailsView.taxExpiryImageLabel.underline()
                weakself.vehicleData.taxUpload = "/user_docs/user_"+userID+"/"+filename
            }
            
            weakself.prompt(message)
          //  weakself.vehicleData = nil
            self?.infilateDataOnView()
            self?.view.setNeedsDisplay()
            self?.view.setNeedsLayout()
            }
        }) { [weak self] error in
            guard let weakself = self else { return }
            weakself.prompt((error?.localizedDescription)!)
        }
    }
}

extension EditVehicleDetailsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromImagePicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
//            self.isImageChanged = true
//            self.newImage = selectedImage
//            self.addPOIScroolView.imageSelectImageView.image = selectedImage
            let imageData = compressImage(image: selectedImage)
            sendImageToServer(imageData: imageData)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension EditVehicleDetailsController: SFSafariViewControllerDelegate {
    
    @objc private func openSafari(url: String) {
        dismissImageView()
        if let safariUrl = URL(string: "https://track.roadcast.co.in/" + url) {
                let vc = SFSafariViewController(url: safariUrl, entersReaderIfAvailable: true)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}



//
//  SubscriptiomMainVC.swift
//  Bolt
//
//  Created by Vivek Kumar on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import Razorpay
import DefaultsKit

class SubscriptiomMainVC: UIViewController {

    let cell = "cell"
    var subscriptionview: SubscriptionView!
    var allDevices = [TrackerDevicesMapperModel]()

    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var isSelectedSubVC = false

    var selectedNormalDeviceArray = [String]()

    var selectedAISDeviceArray = [String]()

    var totalAmount = 0.0

    var deviceData : EditDevicesInfosModel?
    var expiryObjectArray = [EditDevicesInfosModelData]()

    var searching: Bool = false
    var filtered:[TrackerDevicesMapperModel]!
    var filteredData = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationBar()
        

        subscriptionview = SubscriptionView(frame: CGRect.zero)
       // subscriptionview.deviceCount = allDevices.count
        subscriptionview.backgroundColor = .white
        view.addSubview(subscriptionview)

        addConst()

        subscriptionview.subscriptionTableView.tableFooterView = UIView()

        addnearbytableview()
        listInitialize()
        getAboutToExpireCount()

        subscriptionview.informationButton.addTarget(self,
                                                     action: #selector(transfer),
                                                     for: .touchUpInside)

        subscriptionview.amountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transfer)))


        subscriptionview.proceedtopaymentButton.addTarget(self,
                                                          action: #selector(proceedToPaymentTapped),
                                                          for: .touchUpInside)
        self.view.backgroundColor = .black
        self.subscriptionview.backgroundColor = .black
        //    self.subscriptionview.subscriptionscrollview.subscriptionTableView.backgroundColor = .black
        subscriptionview.searchvehicleBar.delegate = self
        addDoneButtonOnKeyboard()
    }
    
    func listInitialize() {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? [TrackerDevicesMapperModel]()

        let filteredList = RCGlobals.getExpiryFilteredList(data)

        allDevices = addExpiredVehiclesIfNotExist(filteredList)

        for i in 0..<allDevices.count {
            filteredData.append(allDevices[i].name ?? "")
        }


        deviceData = Defaults().get(for: Key<EditDevicesInfosModel>("EditDevicesInfosModel"))

        for exp in deviceData?.data ?? [EditDevicesInfosModelData]() {
            expiryObjectArray.append(exp)
        }

        let expiredList:[ExpiryDataResponseModel] = Defaults().get(for: Key<[ExpiryDataResponseModel]>("expired_vehicles")) ?? []

        for expired in expiredList {
            let model = EditDevicesInfosModelData()
            model.id = expired.deviceid ?? "0"
            model.name = expired.name ?? "N/A"
            model.subscriptionExpiryDate = expired.subscriptionExpiryDate ?? ""
            model.uniqueId = expired.uniqueid ?? ""
            expiryObjectArray.append(model)
        }
        
        subscriptionview.selectedDeviceCount = selectedNormalDeviceArray.count + selectedAISDeviceArray.count
        subscriptionview.selectedLabel.text = "\(selectedNormalDeviceArray.count + selectedAISDeviceArray.count) selected"
        subscriptionview.amountLabel.text = "\(totalAmount)"
        subscriptionview.subscriptionTableView.reloadData()
    }

    func getAboutToExpireCount () {
        var aboutToExpire:Int = 0
        let currentDate = Date()
        for item in expiryObjectArray {
            let expiryDateString = item.subscriptionExpiryDate ?? ""
            let expirydate = RCGlobals.getDateFromStringFormat2(expiryDateString)
            let daysLeft = expirydate.days(from: currentDate)
            if daysLeft < 30 {
                aboutToExpire += 1
            }
        }

        if aboutToExpire < 2 {
            subscriptionview.expiresubscriptionLabel.text = "Your \(aboutToExpire) subscription are about to expire"
        } else {
            subscriptionview.expiresubscriptionLabel.text = "Your \(aboutToExpire) subscription are about to expire"
        }

    }


    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        totalAmount = 0.0
        selectedNormalDeviceArray = []
        selectedAISDeviceArray = []
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        totalAmount = 0.0
        selectedNormalDeviceArray = []
        selectedAISDeviceArray = []
        getDeviceData()
    }
    
    fileprivate func getDeviceData() {
        RCLocalAPIManager.shared.getDevicesDetails("Please wait...", success: { [weak self] value in
            guard let weakself = self else { return }
            weakself.listInitialize()
            
        }) { [weak self] message in
            guard let weakself = self else { return }
            weakself.prompt(message)
        }
    }

    private func addExpiredVehiclesIfNotExist(_ data : [TrackerDevicesMapperModel]) -> [TrackerDevicesMapperModel] {
        var updatedList:[TrackerDevicesMapperModel] = data

        let expiredList:[ExpiryDataResponseModel] = Defaults().get(for: Key<[ExpiryDataResponseModel]>("expired_vehicles")) ?? []

        for expired in expiredList {
            let model = TrackerDevicesMapperModel()
            model.id = Int(expired.deviceid ?? "0")
            model.name = expired.name ?? "N/A"
            model.uniqueId = expired.uniqueid ?? ""
            let keyValue = "Device_" + (expired.deviceid ?? "0")
            Defaults().set(model, for: Key<TrackerDevicesMapperModel>(keyValue))
            updatedList.append(model)
        }

        return updatedList
    }

    func setupUI(){

    }

    private func addNavigationBar() {
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.title = "Subscriptions"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "subscription").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    }

    @objc private func backButtonTapped() {
         self.dismiss(animated: true, completion: nil)
    }

    func addConst(){
        subscriptionview.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
    }

    @objc func proceedToPaymentTapped() {

        let moneyInPaise = totalAmount * 100
        print("Total Payment to be paid is \(moneyInPaise)")

        let controller = BuySubscriptionVC()

        var deviceIdArray:[String] = []

        deviceIdArray.append(contentsOf: selectedNormalDeviceArray)
        deviceIdArray.append(contentsOf: selectedAISDeviceArray)

        //totalAmount
        if deviceIdArray.count == 0{
            self.view.makeToast("Please select atleast one")
            return
        }



        RCLocalAPIManager.shared.getRazorPayOrderID(with: deviceIdArray,
                                                    value: moneyInPaise, success: { (model) in

                                                        let orderId = model.data
                                                        print("order of current id is \(orderId!)")
            controller.orderId = orderId?.razorpayOrder ?? ""
                                                        controller.orderAmount = Int(moneyInPaise)
                                                        controller.isSubscription = true

                                                        print("amount actual is \(moneyInPaise)")

                                                        self.navigationController?.pushViewController(controller,animated: true)

        }) { (failure) in
            self.prompt("Unable to initiate payment.")
            print("order id fetch failed")

        }
    }

    func addnearbytableview(){
        subscriptionview.subscriptionTableView.register(SubscriptionTabeViewCell.self, forCellReuseIdentifier: "cell")
        //    subscriptionview.subscriptionscrollview.subscriptionTableView.backgroundColor = .black

        subscriptionview.subscriptionTableView.delegate = self
        subscriptionview.subscriptionTableView.dataSource = self
        subscriptionview.subscriptionTableView.isScrollEnabled = true
    }

    @objc func transfer(){
        let vc = SubscriptionDetailVC()
        if selectedAISDeviceArray.count != 0 || selectedNormalDeviceArray.count != 0 {
            vc.aisDeviceArr = selectedAISDeviceArray
            vc.normalDeviceArr = selectedNormalDeviceArray
            self.present(vc, animated: true, completion: nil)

        }else{
            self.view.makeToast("Please select At-least one device")
        }

    }

    @objc func subsbacktapped(_ sender: UIButton){

        self.navigationController?.popViewController(animated: true)
    }

}

extension SubscriptiomMainVC: UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filtered.count
        } else {
            return allDevices.count
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var device = allDevices[indexPath.row]
        if  searching {
            device = filtered[indexPath.row]
        }


        let expiryObject = expiryObjectArray.filter { (

            $0.id == "\(device.id!)"

            )}.first


        let order =  subscriptionview.subscriptionTableView.dequeueReusableCell(withIdentifier: "cell") as! SubscriptionTabeViewCell
        order.selectionStyle = .none
        order.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
        if searching {
            order.vehiclenameLabel!.text = filtered[indexPath.row].name
        }
        else {
            order.vehiclenameLabel!.text = allDevices[indexPath.row].name
        }
        let expiryDateString = expiryObject?.subscriptionExpiryDate ?? ""
        let expirydate = RCGlobals.getDateFromStringFormat2(expiryDateString)
        let currentDate = Date()
        let daysLeft = expirydate.days(from: currentDate)

        if daysLeft < 30 {
            if daysLeft < 0 {
                order.dayleftLabel.text? = "Expired"
            } else {
                order.dayleftLabel.text? = "\(daysLeft) days left"
            }
            order.alertimageview.image =  #imageLiteral(resourceName: "Asset 99")
        } else {
            order.dayleftLabel.text? = "\(daysLeft) days left"
            order.alertimageview.image =  #imageLiteral(resourceName: "Asset 100")
        }
        
        order.vehiclenameLabel.textColor = .white
        order.dayleftLabel.textColor = .white

        if selectedNormalDeviceArray.contains("\(device.id!)") || selectedAISDeviceArray.contains("\(device.id!)") {
            order.radioButton.isSelected = true
            order.radioButton.innerCircleCircleColor = appGreenTheme
        } else {
            order.radioButton.innerCircleCircleColor = .white
            order.radioButton.isSelected = false
        }

//        if !selectedNormalDeviceArray.contains("\(device.id!)") {
//            order.radioButton.innerCircleCircleColor = .white
//            order.radioButton.isSelected = false
//        } else {
//            order.radioButton.isSelected = true
//            order.radioButton.innerCircleCircleColor = appGreenTheme
//        }

        order.radioButton.addTarget(self, action: #selector(setRadioButton(sender:)),
                                    for: .touchUpInside)
        order.radioButton.tag = indexPath.row
        //  order.selectionStyle = .none
        // order.backgroundColor = .black

        return order
    }


    @objc func setRadioButton(sender: RadioButton) {

        var deviceid = allDevices[sender.tag].id!
        if  searching {
            deviceid = filtered[sender.tag].id!
        }
        let amountForDevice = getDeviceTypeAmount(deviceId: deviceid)
        let amountInDoublePerDevice = Double(amountForDevice)
        print("Amount for tracker is \(amountForDevice)")

        if sender.isSelected == false {
            if RCGlobals.isAISDevice(deviceId: deviceid) {
                selectedAISDeviceArray.append("\(deviceid)")
            } else {
                selectedNormalDeviceArray.append("\(deviceid)")
            }
            sender.isSelected = true
            sender.innerCircleCircleColor = appGreenTheme
            totalAmount = totalAmount + amountInDoublePerDevice
        } else {
            if let index = selectedNormalDeviceArray.index(of: "\(deviceid)") {
                selectedNormalDeviceArray.remove(at: index)
            }
            if let index = selectedAISDeviceArray.index(of: "\(deviceid)") {
                selectedAISDeviceArray.remove(at: index)
            }
            sender.isSelected = false
            sender.innerCircleCircleColor = .white
            totalAmount = totalAmount - amountInDoublePerDevice
        }

        subscriptionview.selectedDeviceCount = selectedNormalDeviceArray.count + selectedAISDeviceArray.count
        subscriptionview.selectedLabel.text = "\(selectedNormalDeviceArray.count + selectedAISDeviceArray.count) selected"
        subscriptionview.amountLabel.text = "\(totalAmount)"
        subscriptionview.subscriptionTableView.reloadData()
        self.subscriptionview.layoutIfNeeded()

    }

    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        subscriptionview.searchvehicleBar.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction(){
        subscriptionview.searchvehicleBar.endEditing(true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60.0)
    }
}

extension SubscriptiomMainVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            searching = false
            searchBar.returnKeyType = .done
        } else {
            searching = true
            filtered = allDevices.filter({ (text) -> Bool in
                let tmp: NSString = text.name! as NSString
                let range = tmp.range(of: searchText, options: .caseInsensitive)
                return range.location != NSNotFound
            })
        }
        subscriptionview.subscriptionTableView.reloadData()
    }

}


//
//  PaymentHistoryVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 02/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import DefaultsKit


class PaymentHisoryVC: UIViewController {
  
    var paymenthistoryview: PaymentHistoryView!
    var appDarkTheme = UIColor(red: 38/255, green: 39/255, blue: 58/255, alpha: 1.0)
    var subscriptionType : [String] = [] 
    var datePayment: [String] = []
    
    var inrnumber: [Double] = []
       let cell = "cell"
  var paymentObjects = [PaymentHistoryResponseModelData]()
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      addNavigationBar()
            loader()
        addConstraints()
        getPaymentHistory()
       
    }
    
    fileprivate func getPaymentHistory () {
        RCLocalAPIManager.shared.getPaymentHistory(success: { success in
            self.paymentObjects = success
            self.populateTableView()
        }, failure: { error in
            
        })
    }
 
  
    func loader(){
        paymenthistoryview = PaymentHistoryView(frame: CGRect.zero)
                paymenthistoryview.backgroundColor = .white
                view.addSubview(paymenthistoryview)
                paymenthistoryview.paymenthistoryTableView.tableFooterView = UIView()
               addpaymenthistorytable()
//               paymenthistoryview.backbutton.addTarget(self, action: #selector(transfer(_:)), for: .touchUpInside)
      
                
    }
   func  addConstraints(){
    paymenthistoryview.snp.makeConstraints { (make) in
        if #available(iOS 11.0, *) {
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        } else {
            make.edges.equalToSuperview()
            // Fallback on earlier versions
        }
    }
    }
  
  private func addNavigationBar() {
//      let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
//      self.navigationItem.leftBarButtonItem = leftButton
    self.navigationItem.title = "Payment History"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "subscription").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
      self.navigationController?.navigationBar.backgroundColor = .white
      
  }
    @objc private func backButtonTapped() {
      //  self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
  func populateTableView() {
    paymentObjects = paymentObjects.filter({$0.app_name == appname})
    paymentObjects = paymentObjects.filter({$0.status == "captured"}) 
      paymentObjects = paymentObjects.sorted(by:{ ($0.createdOn ?? "") > ($1.createdOn ?? "") })
    //.filter( { $0.device_id == "\(bottomSheetDeviceId)" })
    
    for i in paymentObjects {
      
      subscriptionType.append(i.type ?? "")
        inrnumber.append(i.amount ?? 0.0)
       datePayment.append(i.createdOn ?? "")
      
    }
    paymenthistoryview.paymenthistoryTableView.reloadData()
  }
  
    func addpaymenthistorytable(){
      
            paymenthistoryview.paymenthistoryTableView.register(PaymentHistoryTableViewCell.self, forCellReuseIdentifier: "cell")
            paymenthistoryview.paymenthistoryTableView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
           paymenthistoryview.paymenthistoryTableView.delegate = self
           paymenthistoryview.paymenthistoryTableView.dataSource = self
            paymenthistoryview.paymenthistoryTableView.isScrollEnabled = true
       }
  
//       @objc func transfer(_ sender: UIButton){
//
//           self.navigationController?.popViewController(animated: true)
//       }
}



extension PaymentHisoryVC: UITableViewDelegate , UITableViewDataSource{
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order =  paymenthistoryview.paymenthistoryTableView.dequeueReusableCell(withIdentifier: "cell") as! PaymentHistoryTableViewCell
      
      let paymentObject = paymentObjects[indexPath.row]
      let deviceId = paymentObject.createdOn ?? ""
      
      if deviceId != ""  {
      let keyValue = "Device_" + "\(deviceId)"
        if let trackerDevice = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue)) {
           order.vehiclenumber.text? = "(\(trackerDevice.name ?? ""))"
        }
      }
//        as? [String : String])?["Type"]
        order.subscriptionLabel.text? = subscriptionType[indexPath.row]
      
        order.dateLabel.text? = RCGlobals.convertUTCToIST(datePayment[indexPath.row], "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ", "dd MMM, yyyy '@' hh:mm a")
      
        let amount = inrnumber[indexPath.row]
        let amountDouble = Double(amount)
        let amountRupees = amountDouble/100.0
        order.inrLabel.text? = "INR " + "\(amountRupees)"
        
        order.vehiclenumber.textColor = .white
        order.subscriptionLabel.textColor = .white
        order.dateLabel?.textColor = appGreenTheme
        order.inrLabel.textColor = .white
        order.selectionStyle = .none
        order.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
        return order
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110.0)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = appDarkTheme
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell1 = paymenthistoryview.paymenthistoryTableView.cellForRow(at: indexPath)
        cell1?.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
    }
}

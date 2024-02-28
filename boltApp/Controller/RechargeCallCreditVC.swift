//
//  RechargeCallCreditVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 03/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import DefaultsKit

class RechargeCallCreditVC: UIViewController {
  var rechargecallcreditview: RechargeCallCreditView!
  var counter: Int =  100
  var plusone:String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigation()
    rechargecallcreditview = RechargeCallCreditView(frame: CGRect.zero)
    rechargecallcreditview.backgroundColor = .white
    view.addSubview(rechargecallcreditview)
    setconstraints()
    rechargecallcreditview.callcreditamountLabel.text = String(counter)
     let callCredits = Defaults().get(for: Key<String>("CallCredits")) ?? "0"
    rechargecallcreditview.availablecreditLabel.text = "Available credits : " + callCredits
    
    rechargecallcreditview.proceedButton.addTarget(self,
                                                   action: #selector(proceedPaymentButtonTapped),
                                                   for: .touchUpInside)
    
//    rechargecallcreditview.backbutton.addTarget(self,
//                                                action: #selector(backtapped(_:)),
//                                                for: .touchUpInside)
    
    rechargecallcreditview.plusButton.addTarget(self,
                                                action: #selector(incr(_:)),
                                                for: .touchUpInside)
    
    rechargecallcreditview.minusButton.addTarget(self,
                                                 action: #selector(decr(_:)),
                                                 for: .touchUpInside)
    
    rechargecallcreditview.knowmoreButton.addTarget(self,
                                                    action: #selector(knowMoreBtnTapped),
                                                    for: .touchUpInside)
  }
    func setNavigation(){
        self.navigationItem.title = "Recharge Call Credits"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
//        if #available(iOS 11.0, *) {
//            self.navigationItem.largeTitleDisplayMode = .always
//        } else {
//            // Fallback on earlier versions
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "dashicon3").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
    }
    func setconstraints(){
        rechargecallcreditview.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
    }
  
  @objc func knowMoreBtnTapped() {
    
    let controller = SafetyKnowledgeVC()
    self.navigationController?.pushViewController(controller, animated: true)
    
  }
  
  @objc func proceedPaymentButtonTapped() {
    let money = rechargecallcreditview.callcreditamountLabel.text ?? "100"
    let moneyInt = Int(money) ?? 100
    let moneyInPaise = moneyInt * 100
    let moenyDouble = Double(moneyInPaise)
    
    let controller = BuySubscriptionVC()
    
    RCLocalAPIManager.shared.getRazorPayOrderID(with: [], value: moenyDouble, type: "CALLCREDITS",
                                                success: { (model) in
      let orderId = model.data
      print("order of current id is \(orderId!)")
      controller.orderId = orderId?.razorpayOrder ?? ""
      controller.orderAmount = Int(moneyInPaise)
      controller.isSubscription = false
        
        print("amount actual is \(moneyInPaise)")
      
      self.navigationController?.pushViewController(controller,animated: true)
    }) { (failure) in
      
      print(failure)
    }
  }
  
  @objc func incr(_ sender: UIButton){
   
      counter = counter + 1
     rechargecallcreditview.inrLabel.text = "INR" + String(counter)
     rechargecallcreditview.callcreditamountLabel.text = String(counter)
    
  }
  
  @objc func decr(_ sender: UIButton){
    
    if rechargecallcreditview.callcreditamountLabel.text == "100" {
       UIApplication.shared.keyWindow?.makeToast("Minimum credits that can be bought are 100".toLocalize, duration: 2.0, position: .bottom)
    } else {
      counter = counter - 1
      rechargecallcreditview.inrLabel.text = "INR" + String(counter)
      rechargecallcreditview.callcreditamountLabel.text = String(counter)
    }
  }
  
  @objc func backTapped(){
      self.navigationController?.popViewController(animated: true)
  }
//  @objc func backtapped(_ sender: UIButton){
//
//    self.navigationController?.popViewController(animated: true)
//  }
 
}

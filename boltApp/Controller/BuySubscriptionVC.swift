//
//  BuySubscriptionVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import Razorpay
import DefaultsKit

class BuySubscriptionVC: UIViewController, RazorpayPaymentCompletionProtocolWithData {
    
    typealias Razorpay = RazorpayCheckout
    var razorpay: Razorpay!
    var orderId = ""
    var orderAmount = 0
    var isSubscription:Bool = true
    var progress: MBProgressHUD?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        addNavigationBar()
        self.view.backgroundColor = .white
        razorpay = Razorpay.initWithKey("rzp_live_xgXO6nVpI33DBj", andDelegateWithData: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.showPaymentForm()
    }
    
    
    
    internal func showPaymentForm(){
        
        
        let username  = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.name ?? " "
        let emailId = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.attributes?.email ?? " "
        
        let options: [String:Any] = [
            "amount": "\(orderAmount)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": isSubscription ? "Subscription Charges" : "Call Credit Charges",
            "order_id": orderId,
            "name": "Roadcast Tech Sol.",
            "prefill": [
                "name": "\(username)",
                "email": "\(emailId)"
            ],
            "theme": [
                "color": "#30AE9F"
            ]
        ]
        
        
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
            if razorpay != nil {
                razorpay.open(options, displayController: topController)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.razorpay = nil
        orderId = ""
        orderAmount = 0
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func addNavigationBar() {
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //"image": "https://url-to-image.png"
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        
        UIApplication.shared.keyWindow?.makeToast("Payment Failed.",duration: 2.0, position: .bottom)
        self.navigationController?.popViewController(animated: true)
        //self.razorpay = nil
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        verifyPaymentOnServer(response: response)
        //self.razorpay = nil
    }
    
    
    func verifyPaymentOnServer (response: [AnyHashable : Any]?) {
        
        
        if let responseReceived = response {
            
            let paymentId = responseReceived["razorpay_payment_id"] as! String
            let orderId = responseReceived["razorpay_order_id"] as! String
            let paymentSignature = responseReceived["razorpay_signature"] as! String
            
            
            RCLocalAPIManager.shared.verifyRazorPayPayment(orderID: orderId, paymentId: paymentId, signature: paymentSignature, success: { (success) in
                
                UIApplication.shared.keyWindow?.makeToast("Purchase successful.",duration: 2.0, position: .bottom)
                if !self.isSubscription {
                    self.callCalledCreditsApi()
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }) { (failure ) in
                
                UIApplication.shared.keyWindow?.makeToast("Purchase verification failed.",duration: 2.0, position: .bottom)
                self.dismiss(animated: true, completion: nil)
            }
            
        } else {
            
            UIApplication.shared.keyWindow?.makeToast(isSubscription ? "Subscription purchase verification failed." : "Credits purchase verification failed.",duration: 2.0, position: .bottom)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func callCalledCreditsApi() {
        showProgress()
        RCLocalAPIManager.shared.getUserConfig(success: { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.hideProgress()
            weakSelf.navigationController?.popViewController(animated: true)
        }, failure: { [weak self] error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.hideProgress()
            weakSelf.navigationController?.popViewController(animated: true)
        })
    }
    
    func showProgress() {
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = "Fetching latest data, Please wait...".toLocalize
    }
    
    func hideProgress() {
        progress?.hide(true)
    }
    
    //  override func viewWillDisappear(_ animated: Bool) {
    //       self.razorpay = nil
    //  }
}

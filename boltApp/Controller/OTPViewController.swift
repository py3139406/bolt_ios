//
//  OTPViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import SkyFloatingLabelTextField
import Hero

class OTPViewController: UIViewController,UITextFieldDelegate {
    var otpView:OTPView!
    var second = 60
    var timer: Timer!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appDarkTheme
        otpView = OTPView(frame: view.bounds)
        view.addSubview(otpView)
        otpView.firstTextField.delegate=self
        otpView.secondTextField.delegate=self
        otpView.thirdTextField.delegate=self
        otpView.fourthTextField.delegate=self
        otpView.sendOtpButton.addTarget(self, action: #selector(sendOTPButtonAction(sender:)), for: .touchUpInside)
        otpView.resendOtpButton.addTarget(self, action: #selector(resendButtonAction(sender:)), for: .touchUpInside)
        otpView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        // calling timer
        
        createTimer()
        
        
         otpView.firstTextField.tag = 1
         otpView.secondTextField.tag = 2
         otpView.thirdTextField.tag = 3
         otpView.fourthTextField.tag = 4
        
        otpView.firstTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
        
        otpView.secondTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
        
        otpView.thirdTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
        
        otpView.fourthTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
    }
    @objc func backTapped(){
        Hero.shared.animationEnded(true)
        let navController = SignUpViewController()
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .right)
        self.hero.replaceViewController(with: navController)

    }
    
    @objc func checkTextField(sender:SkyFloatingLabelTextField){
        let textCount = sender.text?.count
        let tagId = sender.tag
        if (textCount == 1) {
            switch tagId{
            case 1:
               otpView.secondTextField .becomeFirstResponder()
            case 2:
               otpView.thirdTextField .becomeFirstResponder()
            case 3:
                otpView.fourthTextField.becomeFirstResponder()
            case 4:
                otpView.fourthTextField.resignFirstResponder()
            default:
                break
            }
        }else{
            otpView.firstTextField.text = ""
            otpView.secondTextField.text = ""
            otpView.thirdTextField.text = ""
            otpView.fourthTextField.text = ""
        }
    }

    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatelabel), userInfo: nil, repeats: true)
    }
    
    @objc func updatelabel(){
        second -= 1
        if second < 10 {
            otpView.counterLabel.text = "0:0\(second)"
        }else{
             otpView.counterLabel.text = "0:\(second)"
        }
        if second == 0 {
            timer.invalidate()
            otpView.counterLabel.isHidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        otpView.firstTextField.resignFirstResponder()
        otpView.secondTextField.resignFirstResponder()
        otpView.thirdTextField.resignFirstResponder()
        otpView.fourthTextField.resignFirstResponder()
        
    }
    
    func checkOTP() {
        guard let otp1 = otpView.firstTextField.text else{return }
        guard let otp2 = otpView.secondTextField.text else{return }
        guard let otp3 = otpView.thirdTextField.text else{return }
        guard let otp4 = otpView.fourthTextField.text else{return }
        
        if(otp1.count == 0) || (otp2.count == 0) || (otp3.count == 0) || (otp4.count == 0){
            self.showalert("Enter OTP to register account".toLocalize)
        }else {
            
            RCLocalAPIManager.shared.verifyOTP(otp: otp1+otp2+otp3+otp4) { _ in
                self.prompt("Thank You", "You can now login using your id and password".toLocalize, "ok".toLocalize, handler1:{_ in
                    self.view.window?.rootViewController = LoginViewController()
                })
            } failure: { _ in
                self.showalert("OTP does not match. Please try again.".toLocalize)
            }
            
        }
    }
    
    @objc func sendOTPButtonAction(sender:UIButton){
        checkOTP()
    }
    
    @objc func resendButtonAction(sender:UIButton){
        if (second > 0)
        {
            UIApplication.shared.keyWindow?.makeToast("Please wait for OTP..".toLocalize, duration: 2.0, position: .bottom)
        }else{
            let countryCode:String = Defaults().get(for: Key<String>("signUpCountryCode")) ?? ""
            let signupUsername:String = Defaults().get(for: Key<String>("signUpUserName")) ?? ""
            
            RCLocalAPIManager.shared.getOTP(username: signupUsername) { [weak self] hash in
                
                guard let weakSelf = self else {
                    return
                }
                weakSelf.prompt("OTP resent.")
            } failure: { [weak self] _ in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.prompt("User already exist, try logging in.")
            }
            
        }

    }
    
}

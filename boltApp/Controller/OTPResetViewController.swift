//
//  OTPResetViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import SkyFloatingLabelTextField

class OTPResetViewController: UIViewController {

    var otpResetView:OTPResetView!
    var second = 60
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =   appDarkTheme
        otpResetView = OTPResetView(frame: view.bounds)
        view.addSubview(otpResetView)
        otpResetView.firstTextField.delegate=self
        otpResetView.secondTextField.delegate=self
        otpResetView.thirdTextField.delegate=self
        otpResetView.fourthTextField.delegate=self
        otpResetView.sendOtpButton.addTarget(self, action: #selector(sendOTPButtonAction(sender:)), for: .touchUpInside)
        otpResetView.resendOtpButton.addTarget(self, action: #selector(resendButtonAction(sender:)), for: .touchUpInside)
        otpResetView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        createTimer()
        
        otpResetView.firstTextField.tag = 1
        otpResetView.secondTextField.tag = 2
        otpResetView.thirdTextField.tag = 3
        otpResetView.fourthTextField.tag = 4
        
        otpResetView.firstTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
        otpResetView.secondTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
        otpResetView.thirdTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
        otpResetView.fourthTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: UIControlEvents.editingChanged)
    }
    @objc func backTapped(){
        let navController = ForgetPasswordViewController()
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .right)
        self.hero.replaceViewController(with: navController)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func checkTextField(sender:SkyFloatingLabelTextField){
        let textCount = sender.text?.count
        let tagId = sender.tag
        if (textCount == 1) {
            switch tagId{
            case 1:
                otpResetView.secondTextField .becomeFirstResponder()
            case 2:
                otpResetView.thirdTextField .becomeFirstResponder()
            case 3:
                otpResetView.fourthTextField.becomeFirstResponder()
            case 4:
                otpResetView.fourthTextField.resignFirstResponder()
            default:
                break
            }
        }else{
            otpResetView.firstTextField.text = ""
            otpResetView.secondTextField.text = ""
            otpResetView.thirdTextField.text = ""
            otpResetView.fourthTextField.text = ""
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        otpResetView.firstTextField.resignFirstResponder()
        otpResetView.secondTextField.resignFirstResponder()
        otpResetView.thirdTextField.resignFirstResponder()
        otpResetView.fourthTextField.resignFirstResponder()
        
    }
    
    func createTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatelabel), userInfo: nil, repeats: true)
    }
    
    @objc func updatelabel(){
        second -= 1
        if second < 10 {
            otpResetView.counterLabel.text = "0:0\(second)"
        }else{
            otpResetView.counterLabel.text = "0:\(second)"
        }
        if second == 0 {
            timer.invalidate()
            otpResetView.counterLabel.isHidden = true
        }
    }
    
   

    
    
    func checkOTP() -> Bool {
        var returnVal = false
        guard let otp1 = otpResetView.firstTextField.text else{return returnVal}
        guard let otp2 = otpResetView.secondTextField.text else{return returnVal}
        guard let otp3 = otpResetView.thirdTextField.text else{return returnVal}
        guard let otp4 = otpResetView.fourthTextField.text else{return returnVal}

        if(otp1.count == 0) || (otp2.count == 0) || (otp3.count == 0) || (otp4.count == 0){
            self.showalert("Enter OTP to reset password".toLocalize)
        }else {
//            let otpDetails = Defaults().get(for: Key<CheckUserModel>("CheckUserModel"))
            let otp = Defaults().get(for: Key<String>("RESETOTP"))
            if ( otp1+otp2+otp3+otp4 == otp) {
                returnVal = true
            }else{
                self.showalert("OTP does not match. Please try again.".toLocalize)
                returnVal = false
            }

        }
        return returnVal
    }
    
  @objc func resendButtonAction(sender:UIButton){
    
        if (second > 0)
        {
            UIApplication.shared.keyWindow?.makeToast("Please wait for OTP..".toLocalize, duration: 2.0, position: .bottom)
        }else {
            let countryCode = Defaults().get(for: Key<String>("signUpCountryCode"))
            let signupUsername = Defaults().get(for: Key<String>("signUpUserName"))
            RCLocalAPIManager.shared.sendOTP(with: countryCode!, usernName: signupUsername!, success: { [weak self] hash in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.createTimer()
                weakSelf.showalert("OTP resend successfully.".toLocalize)
            }) { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.prompt("please try again")
                print(message)
            }
        }
        
    }
    
   @objc  func sendOTPButtonAction(sender:UIButton){
        if checkOTP() {
            let navController = ResetPasswordViewController()
            navController.isHeroEnabled = true
            navController.heroModalAnimationType = .zoomSlide(direction: .left)
            self.hero.replaceViewController(with: navController)
        }
    }
}

extension OTPResetViewController:UITextFieldDelegate{
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}
    



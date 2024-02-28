//
//  ForgetPasswordViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import Hero

class ForgetPasswordViewController: UIViewController {

    var forgetPasswordView: ForgetPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = appDarkTheme
        forgetPasswordView = ForgetPasswordView(frame: view.bounds)
        view.backgroundColor =  appDarkTheme
        view.addSubview(forgetPasswordView)
        forgetPasswordView.okButton.addTarget(self, action: #selector(okButonAction(sender:)), for: .touchUpInside)
        forgetPasswordView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        forgetPasswordView.countryCodeTextField.delegate = self
        forgetPasswordView.mobileNumberTextFiled.delegate = self
    }
    
    @objc func backTapped(){
        let navController = LoginViewController()
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .right)
        self.hero.replaceViewController(with: navController)
    }
    
    @objc func okButonAction(sender:UIButton){
        
        if let mobileNumber = forgetPasswordView.mobileNumberTextFiled.text {
            if mobileNumber.count < 4 {
                self.showalert("Enter mobile number".toLocalize)
            }else {
                
                RCLocalAPIManager.shared.forgetPassword(with: mobileNumber,success: { [weak self] hash in
                    guard let weakSelf = self else {
                        return
                    }
                    let userId:String = hash.data?.userId ?? ""
                    let otp:String = hash.data?.oTP ?? ""
                    Defaults().set(self?.forgetPasswordView.countryCodeTextField.text ?? "91", for: Key<String>("signUpCountryCode"))
                    Defaults().set(mobileNumber, for: Key<String>("signUpUserName"))
                    Defaults().set(userId, for: Key<String>("ForgetUserID"))
                    Defaults().set(otp, for: Key<String>("RESETOTP"))
                    Hero.shared.animationEnded(true)
                    let navController = OTPResetViewController()
                    navController.isHeroEnabled = true
                    navController.heroModalAnimationType = .zoomSlide(direction: .left)
                    weakSelf.hero.replaceViewController(with: navController)
        
                }) { [weak self] message in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.prompt("please try again")
                    print(message)
                }
        
                
//                RCLocalAPIManager.shared.sendOTP(with: forgetPasswordView.countryCodeTextField.text ?? "91", usernName: mobileNumber, success: { [weak self] hash in
//                    guard let weakSelf = self else {
//                        return
//                    }
//                    Defaults().set(self?.forgetPasswordView.countryCodeTextField.text ?? "91", for: Key<String>("signUpCountryCode"))
//                    Defaults().set(mobileNumber, for: Key<String>("signUpUserName"))
//
//                    self?.present((OTPResetViewController()), animated: true, completion: nil)
//                }) { [weak self] message in
//                    guard let weakSelf = self else {
//                        return
//                    }
//                    weakSelf.prompt(message)
//                }
                
            }
        }else {
            self.showalert("Enter mobile number".toLocalize)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ForgetPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        forgetPasswordView.countryCodeTextField.resignFirstResponder()
        forgetPasswordView.mobileNumberTextFiled.resignFirstResponder()
        return true
    }
}

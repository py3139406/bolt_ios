//
//  SignUpViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import MICountryPicker
import Hero

class SignUpViewController: UIViewController{

    var signUpView: SignUpView!
    var picker = MICountryPicker()
    lazy var loginViewController = LoginViewController()
    
    lazy var hellowViewController = HelloViewController()
    lazy var otpViewController = OTPViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
//        UIApplication.shared.statusBarStyle = .default
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor.white
        
        view.backgroundColor = appDarkTheme
        signUpView = SignUpView(frame: view.bounds)
        view.addSubview(signUpView)
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonAction(sender:)), for: .touchUpInside)
        signUpView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        let codeButton = UITapGestureRecognizer(target: self, action: #selector(Code(_:)) )
        codeButton.numberOfTouchesRequired = 1
        signUpView.code.addGestureRecognizer(codeButton)
        
        //delegate
        signUpView.passwordTextField.delegate = self
        signUpView.userTextField.delegate = self
        signUpView.conformTextFiled.delegate = self
        picker.delegate = self
        picker.showCallingCodes = true
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @objc func Code(_ sender: UITapGestureRecognizer){
       navigationController?.pushViewController(picker, animated: true)
     }

    
    @objc func backTapped(){
        Hero.shared.animationEnded(true)
        let navController = loginViewController
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .right)
        self.hero_replaceViewController(with: navController)

    }
    
    
    func checkPassword() -> Bool {
        var returnVal = false
        guard let password = signUpView.passwordTextField.text else{return returnVal}
        guard let confirmpassword = signUpView.conformTextFiled.text else{return returnVal}
        guard let username = signUpView.userTextField.text else{return returnVal}
        
        if(password.count == 0) && (username.count == 0){
            self.showalert("Enter Username and password".toLocalize)
        }else if (password.count == 0) && (username.count != 0){
            self.showalert("Enter password".toLocalize)
        }else if (password.count != 0) && (username.count == 0){
            self.showalert("Enter user name".toLocalize)
        }else if (password.count != 0) && (password.count <= 5){
            self.showalert("Password must be greater than 5 characters".toLocalize)
        }else if (confirmpassword != password){
            self.showalert("Password and confirm password does not match".toLocalize)
        }else {
            returnVal = true
        }
        
        return returnVal
    }
    
    
    @objc func signUpButtonAction(sender:UIButton){
        
        if checkPassword() {
          
            if let newUserName = signUpView.userTextField.text,
                let password = signUpView.passwordTextField.text,
                let confirmPassword = signUpView.conformTextFiled.text {
                
                RCLocalAPIManager.shared.getOTP(username: newUserName) { [weak self] hash in
                    
                    guard let weakSelf = self else {
                        return
                    }
                    
                    Defaults().set(weakSelf.signUpView.code.text ?? "91", for: Key<String>("signUpCountryCode"))
                    Defaults().set(newUserName, for: Key<String>("signUpUserName"))
                    Defaults().set(password, for: Key<String>("signupPassword"))
                    
                    let navController =  TermsAndConditionsViewController()
                    navController.isHeroEnabled = true
                    navController.heroModalAnimationType = .zoomSlide(direction: .left)
                    weakSelf.hero.replaceViewController(with: navController)
                    
                    
                } failure: { [weak self] _ in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.prompt("User already exist, try logging in.")
                }
                
            } else {
                prompt("Fill all fields".toLocalize)
            }
        }

        func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        signUpView.userTextField.resignFirstResponder()
        signUpView.passwordTextField.resignFirstResponder()
        signUpView.conformTextFiled.resignFirstResponder()
    }
        
    }
 
}

extension SignUpViewController:UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        signUpView.userTextField.resignFirstResponder()
        signUpView.passwordTextField.resignFirstResponder()
        signUpView.conformTextFiled.resignFirstResponder()
        return true
    }
}

extension SignUpViewController:MICountryPickerDelegate{
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
        
    }

    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        signUpView.code.text = dialCode
        navigationController?.popToViewController(self, animated: true)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
     }
}

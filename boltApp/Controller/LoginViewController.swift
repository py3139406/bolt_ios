//
//  LoginViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import DefaultsKit
import SkyFloatingLabelTextField
import KeychainAccess
import Firebase
import FirebaseStorage


class LoginViewController: UIViewController {
    var loginView: LoginView!
    lazy var viewController = ViewController()
    lazy var splashController = SplashAnimationVC()
    lazy var signUpViewController = SignUpViewController()
    lazy var forgetPasswordViewController = ForgetPasswordViewController()
    var isPwdVisible = false
    // to show and hide badge on parking mode
    var isParkingBadgeVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appDarkTheme
        RCGlobals.clearAnimationDate()
        Defaults().clear(Key<Data>(defaultKeyNames.animationData.rawValue))
        downloadAnimation()
        loginView = LoginView(frame:CGRect.zero)
        view.addSubview(loginView)
        setConstraints()
        loginView.loginButton.addTarget(self, action: #selector(loginButtonAction(sender:)), for: .touchUpInside)
        loginView.forgetPasswordButton.addTarget(self, action: #selector(forgetButtonAction(sender:)), for: .touchUpInside)
        loginView.signUpButton.addTarget(self, action: #selector(signUpAction(sender:)), for: .touchUpInside)
        loginView.eyeButton.addTarget(self, action: #selector(passwordVisibilitySetup(sender:)), for: .touchUpInside)
        let login_model =   Defaults().get(for: Key<loginInfoModel>("loginInfoModel")) ?? nil
        if login_model != nil {
            let defaultDeviceId = (login_model?.data?.user?.default_device_id ?? "")
            let googleAssistantEmail = (login_model?.data?.user?.google_assistant_email ?? "abd@gmail.com")
            UserDefaults.standard.set(defaultDeviceId, forKey: "default_device_id")
            UserDefaults.standard.set(googleAssistantEmail, forKey: "google_assistant_email")
        }
    }
    
    func downloadAnimation() {
        let storage = Storage.storage()
        
        let httpsReference = storage.reference().child("AnimationFiles").child("splash_animation.gif")
        
        // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
        httpsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let imageData = data {
                    Defaults().set(imageData, for: Key<Data>(defaultKeyNames.animationData.rawValue))
                }
            }
        }
    }
    private   func setConstraints(){
        loginView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @objc func passwordVisibilitySetup(sender:UIButton){
        if !isPwdVisible {
            loginView.passwordTextField.isSecureTextEntry = false
            loginView.eyeButton.setImage(UIImage(named: "psvisible"), for: .normal)
            isPwdVisible = true
        } else {
            loginView.passwordTextField.isSecureTextEntry = true
            loginView.eyeButton.setImage(UIImage(named: "psinvisible"), for: .normal)
            isPwdVisible = false
        }
    }
    
    func checkPassword() -> Bool {
        var returnVal = false
        guard let password = loginView.passwordTextField.text else{ return returnVal }
        guard let username = loginView.userTextFiled.text else{ return returnVal }
        
        if(password.count == 0) && (username.count == 0){
            self.showalert("Enter password and User name".toLocalize)
        }else if (password.count == 0) && (username.count != 0){
            self.showalert("Enter password".toLocalize)
        }else if (password.count != 0) && (username.count == 0){
            self.showalert("Enter user name".toLocalize)
        }else if (password.count != 0) && (password.count <= 5){
            self.showalert("password must be greater than 5 characters".toLocalize)
        }
        else {
            returnVal = true
        }
        
        return returnVal
    }
    
    @objc func loginButtonAction(sender: UIButton!){
        
        if checkPassword() {
            if let userName = loginView.userTextFiled.text, let password = loginView.passwordTextField.text {
                RCLocalAPIManager.shared.login(loadingMsg: "Verifying..", with: userName, password: password, isLogin: true, success: { [weak self] hash in
                    guard let weakSelf = self else {
                        return
                    }
                    
                    UserDefaults.standard.set(userName, forKey: "userName")
                    UserDefaults.standard.set(password, forKey: "userPassword")
                    Defaults().clear(Key<[String]>("filterSelectedOptions"))
                    weakSelf.setLoginAuthSession(username: userName, password: password)
                    weakSelf.getSession(username: userName, password: password)
                    Defaults().set(true, for: Key<Bool>("isParkingBadgeVisible"))
                    
                }) { [weak self] message in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.prompt("login credentials are invalid")
                }
            } else {
                prompt("Fill all fields")
            }
        }
    }
    
    
    func setLoginAuthSession(username: String, password: String) {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let token = "Basic \(base64LoginString)"
        
        //        Defaults().set(token, for: Key<String>("LoginAuthSession"))
        
        let keychain = Keychain(service: "in.roadcast.bolt")
        do {
            try keychain.set(password, key: "boltPassword")
            try keychain.set(token, key: "boltToken")
        }
        catch let error {
            print(error)
        }
        
    }
    
    func getSession(username: String, password: String) {
        RCLocalAPIManager.shared.session(with: username, password: password, success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            weakSelf.tokenRequest()
            
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("Unable to login, please try again")
        }
    }
    
    func tokenRequest() {
        RCLocalAPIManager.shared.getJWTToken(loadingMsg: "") { (success) in
            print(success)
            self.getUserConfig()
        } failure: {  [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("Unable to login, please try again")
        }
    }
    
    fileprivate func getUserConfig() {
        RCLocalAPIManager.shared.getUserConfig(success: { [weak self] response in
            guard let weakSelf = self else {
                return
            }
            weakSelf.callLoginInfoApi()
        }, failure: { [weak self] error in
            guard let weakSelf = self else {
                return
            }
            weakSelf.callLoginInfoApi()
        })
    }
    
    fileprivate func getFuelDetails() {
        RCLocalAPIManager.shared.gettingFuelDetails(success: { (success) in
            print("success in getting details")
        }) { (error) in
            print("failure in fuel")
        }
    }
    
    func callLoginInfoApi(){
        let id =  Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel"))?.id
        RCLocalAPIManager.shared.loginInfo(with: id!,success: { [weak self] hash in
            guard let weakSelf = self else {
                return
            }
            Defaults().set(true, for: Key<Bool>("isLoggedIn"))
            weakSelf.getFuelDetails()
            weakSelf.getNotifAlert()
            
        }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("User not added properly, Please contact admin")
        }
    }
    func getNotifAlert(){
        RCLocalAPIManager.shared.getnotificationAlert(with: "Please wait...", success:  { (success) in
            self.loginView.window?.rootViewController = self.splashController
            print("done")
        }) { (failure) in
            self.loginView.window?.rootViewController = self.splashController
        }
    }
    
    @objc func signUpAction(sender: UIButton!){
        
        let navController =  signUpViewController // Creating a navigation controller with resultController at the root of the navigation stack.
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .left)
        self.hero.replaceViewController(with: navController)
        
    }
    
    @objc  func forgetButtonAction(sender:UIButton!){
        
        let navController =  forgetPasswordViewController// Creating a navigation controller with                             let navController =  OTPViewController() // Creating a navigation controller with resultController at the root of the navigation stack.
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .left)
        self.hero.replaceViewController(with: navController)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        loginView.userTextFiled.resignFirstResponder()
        loginView.passwordTextField.resignFirstResponder()
    }
    
}


//
//  ResetPasswordViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class ResetPasswordViewController: UIViewController {
    
    var resetPasswordView:ResetPasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetPasswordView = ResetPasswordView(frame: view.bounds)
        view.backgroundColor = appDarkTheme
        view.addSubview(resetPasswordView)
        resetPasswordView.confirmPasswordButton.addTarget(self, action: #selector(confirmButtonAction(sender:)), for: .touchUpInside)
        resetPasswordView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    @objc func backTapped(){
        let navController = ForgetPasswordViewController()
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .right)
        self.hero_replaceViewController(with: navController)

    }
    
    @objc func confirmButtonAction(sender:UIButton){
        let password = resetPasswordView.password_TextField.text
        let confirmpassword = resetPasswordView.conform_TextFiled.text
        _ = Defaults().get(for: Key<String>("signUpCountryCode"))
        _ = Defaults().get(for: Key<String>("signUpUserName"))
        let userId = Defaults().get(for: Key<String>("ForgetUserID"))
        
        if(password?.count != 0) && (confirmpassword?.count != 0)  && ( password == confirmpassword ) {
            RCLocalAPIManager.shared.resetPassword(with: userId!, password: password!,
                                                   success: { [weak self] hash in
                                                    guard self != nil else {
                                                        return
                                                    }
                                                    self?.prompt("Reset Password".toLocalize, "Your password has been reset. Please login using your id and new password".toLocalize, "ok".toLocalize, handler1:{_ in
                                                        self?.view.window?.rootViewController = LoginViewController()
                                                    })
                                                    
                                                   }) { [weak self] message in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.prompt("please try again")
                print(message)
            }
        }else{
            showalert("Password and confirm password does not match.".toLocalize)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

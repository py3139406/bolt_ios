//
//  HelloViewController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class HelloViewController: UIViewController{
    var helloView : HelloView!
    override func viewDidLoad() {
        super.viewDidLoad()
        helloView = HelloView(frame: CGRect.zero)
        view.backgroundColor =  appDarkTheme
        view.addSubview(helloView)
        setConstraints()
        helloView.okButton.addTarget(self, action: #selector(okButtonAction(sender:)), for: .touchUpInside)
        helloView.userNameTextFiled.delegate=self
        helloView.emailIdTextField.delegate=self
        helloView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside) 
    }
    func setConstraints(){
        helloView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func backTapped(){
        let navController =  TermsAndConditionsViewController() // Creating a navigation controller with resultController at the root of the navigation stack.
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .left)
        self.hero.replaceViewController(with: navController)
    }
    
    @objc func okButtonAction(sender: UIButton!){
        
        guard let fname = helloView.userNameTextFiled.text else{return}
        guard let email = helloView.emailIdTextField.text else{return}
        if(fname.count == 0) || (email.count == 0) {
            self.showalert("Please fill all details".toLocalize)
            return
        }
        
        let userName = Defaults().get(for: Key<String>("signUpUserName"))
        let password = Defaults().get(for: Key<String>("signupPassword"))
        RCLocalAPIManager.shared.register(with: userName!, password: password!, fname: fname, lname: "",email: email, companyName: "ROADCAST", countryCode: "91", activate: true,
                                          success: { [weak self] hash in
                                            guard self != nil else {
                                                return
                                            }
                                            self?.prompt("Thank You", "You can login using you id and password".toLocalize, "ok".toLocalize, handler1:{_ in
                                                self?.view.window?.rootViewController = LoginViewController()
                                            })
                                          }) { [weak self] message in
            guard let weakSelf = self else {
                return
            }
            weakSelf.prompt("", "something is wrong".toLocalize, "ok".toLocalize, handler1:{_ in
                self?.view.window?.rootViewController = LoginViewController()
            })
            print(message)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        helloView.userNameTextFiled.resignFirstResponder()
        helloView.emailIdTextField.resignFirstResponder()
    }
}

extension HelloViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        helloView.userNameTextFiled.resignFirstResponder()
        helloView.emailIdTextField.resignFirstResponder()
        return true
    }
}

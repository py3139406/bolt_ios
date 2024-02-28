//
//  LoginView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField


class LoginView: UIView {
//    var profileImageView : UIImageView!
    
    var tempImageview: UIImageView!
    var userTextFiled: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var forgetPasswordButton: UIButton!
    var signUpButton: UIButton!
    var userimageView: UIImageView!
    var passwordimageView: UIImageView!
    var topLabel: UILabel!
    var buttomLabel: UILabel!
    var passwordContainerView:UIView!
    var userNameContainerView:UIView!
    var eyeButton:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        userContainer()
        passwordContainer ()
        addButton()
        addLabel()
        addTextFiled()
        addimageView()
        addBottomView()
        addConstraints()
    }
   
    func userContainer(){
        userNameContainerView = UIView(frame: CGRect.zero)
        userNameContainerView.backgroundColor = .white
        addSubview(userNameContainerView)
    }
    func passwordContainer (){
        passwordContainerView = UIView(frame: CGRect.zero)
        passwordContainerView.backgroundColor = .white
        addSubview(passwordContainerView)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
        super.init(coder: aDecoder)
        fatalError("Error".toLocalize)
    }
    func addLabel(){
        topLabel = UILabel()
        topLabel.text = "Login".toLocalize
        topLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        topLabel.adjustsFontSizeToFitWidth = true
        addSubview(topLabel)
        
    }
    
    func userImageViewContainer(){
        userNameContainerView = UIView(frame: CGRect.zero)
        userNameContainerView.backgroundColor = .blue
        addSubview(userNameContainerView)
    }
    func passwordImageViewContainer (){
        passwordContainerView = UIView(frame: CGRect.zero)
        passwordContainerView.backgroundColor = .white
        addSubview(passwordContainerView)
    }
    func addimageView() {
        userimageView = UIImageView()
        userimageView.backgroundColor = appDarkTheme
        userimageView.image = #imageLiteral(resourceName: "user-1").resizedImage(CGSize.init(width: 25, height: 30), interpolationQuality: .default)
        userimageView.contentMode = .center

        addSubview(userimageView)
        
        passwordimageView = UIImageView()
        passwordimageView.backgroundColor = appDarkTheme
        passwordimageView.image = #imageLiteral(resourceName: "thumb-1").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        passwordimageView.contentMode = .center
        addSubview(passwordimageView)

    }
    
   
    func addTextFiled(){
        userTextFiled = UITextField(frame:CGRect.zero)
        userTextFiled.backgroundColor = .white
        userTextFiled.placeholder = "UserName".toLocalize
        userNameContainerView.addSubview(userTextFiled)
        
        passwordTextField = UITextField(frame:CGRect.zero)
        passwordTextField.placeholder = "Password".toLocalize
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordContainerView.addSubview(passwordTextField)
    }
    
    func addButton(){
        loginButton = UIButton()
        loginButton.backgroundColor =  appGreenTheme
        loginButton.setImage(#imageLiteral(resourceName: "RightarrowWhite").resizedImage(CGSize(width:25,height:18), interpolationQuality: .default), for: .normal)
        addSubview(loginButton)
        
        forgetPasswordButton = UIButton()
        let title = NSMutableAttributedString(string:"Forgot Password?".toLocalize)
        title.addAttribute(NSAttributedStringKey.underlineStyle, value:NSUnderlineStyle.styleSingle.rawValue,range:NSMakeRange(0,title.length))
        title.addAttribute(NSAttributedStringKey.foregroundColor, value:appGreenTheme, range:NSMakeRange(0,title.length))
        title.addAttribute(NSAttributedStringKey.font, value:UIFont.systemFont(ofSize: 15, weight: .regular) , range:NSMakeRange(0,title.length))
        forgetPasswordButton.setAttributedTitle(title, for: .normal)
        self.addSubview(forgetPasswordButton)
        
        eyeButton = UIButton()
        eyeButton.setImage(UIImage(named: "psinvisible"), for: .normal)
        passwordContainerView.addSubview(eyeButton)
    }
    
    func addBottomView(){
        buttomLabel = UILabel()
        buttomLabel.backgroundColor = appDarkTheme
        addSubview(buttomLabel)
        
        signUpButton = UIButton()
        signUpButton.backgroundColor = .clear
        signUpButton.layer.borderColor = appGreenTheme.cgColor
        signUpButton.setTitle("NEW USER? SIGN UP".toLocalize, for: .normal)
        signUpButton.setTitleColor(appGreenTheme, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        signUpButton.layer.cornerRadius = 7.0
        signUpButton.layer.borderWidth = 2
        self.addSubview(signUpButton)
    }

    func addConstraints(){
        eyeButton.snp.makeConstraints { (make) in
            make.right.equalTo(passwordContainerView.snp.right).offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(25)
        }
        topLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            if #available(iOS 11, *){
                make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(160)
            }else{
                make.top.equalTo(self).offset(160)
            }
            
            make.height.equalTo(self).multipliedBy(0.075)
            make.width.equalTo(self).multipliedBy(0.6)
        }
        
        userimageView.snp.makeConstraints { (make) in
            make.left.equalTo(topLabel.snp.left)
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.height.equalTo(self).multipliedBy(0.08)
            make.width.equalTo(self).multipliedBy(0.15)

        }
        userNameContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(userimageView.snp.right)
            make.top.equalTo(userimageView.snp.top)
            make.height.equalTo(userimageView.snp.height)
            make.right.equalTo(self).offset(-20)
        }
        
        passwordimageView.snp.makeConstraints { (make) in
            make.top.equalTo(userimageView.snp.bottom).offset(10)
            make.left.equalTo(userimageView.snp.left)
            make.height.width.equalTo(userimageView)
        }
        
        passwordContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(passwordimageView.snp.right)
            make.top.equalTo(passwordimageView.snp.top)
            make.height.equalTo(passwordimageView.snp.height)
            make.right.equalTo(self).offset(-20)
        }
        userTextFiled.snp.makeConstraints { (make) in
             make.left.equalToSuperview().offset(20)
             make.centerY.equalToSuperview()
             make.right.equalToSuperview().offset(-10)
        }
        passwordTextField.snp.makeConstraints { (make) in
             make.left.equalTo(passwordContainerView).offset(20)
             make.centerY.equalTo(passwordContainerView)
             make.right.equalToSuperview().offset(-100)
        }
    
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(passwordimageView.snp.left)
            make.right.equalTo(passwordContainerView.snp.right)
            make.top.equalTo(passwordContainerView.snp.bottom).offset(20)
            make.height.equalTo(self).multipliedBy(0.08)
        }
    
        buttomLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(self).offset(-0.001 * kscreenheight)
            make.height.equalTo(self).multipliedBy(0.18)
        }
        
        forgetPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(loginButton)
            make.width.equalTo(loginButton).multipliedBy(0.55)
            make.top.equalTo(buttomLabel.snp.top).multipliedBy(0.90)
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.center.equalTo(buttomLabel)
            make.height.equalTo(self).multipliedBy(0.04)
            make.width.equalTo(175)
        }
        
    }
        
}

    



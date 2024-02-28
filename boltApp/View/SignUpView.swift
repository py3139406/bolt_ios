//
//  SignUpView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class SignUpView: UIView {
    
    var signUpLabel: UILabel!
    var userimageView: UIImageView!
    var userTextField: UITextField!
    var passwordimageView: UIImageView!
    var passwordTextField: UITextField!
    var conformimageView: UIImageView!
    var conformTextFiled: UITextField!
    var signUpButton: UIButton!
    var code: UILabel!
    var navBarView: UIView!
    var navBack: UIButton!

    override init(frame: CGRect) {
      super.init(frame: frame)
        userContainer()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        super.init(coder: aDecoder)
      super.init(coder: aDecoder)
        fatalError("Error".toLocalize)
        
    }
    
    func userContainer(){
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControl.State.normal)
        addSubview(navBack)
        
        signUpLabel = UILabel()
        signUpLabel.text = "Sign up".toLocalize
        signUpLabel.textColor = .white
        signUpLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        signUpLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 35)
        addSubview(signUpLabel)
        
        code = UILabel(frame:CGRect.zero)
        code.backgroundColor = .white
        code.textAlignment = .center
        code.adjustsFontSizeToFitWidth = true
        code.textColor = .black
        code.layer.cornerRadius = 10
        code.layer.masksToBounds = true
        code.isUserInteractionEnabled = true
        code.text = "91"
        addSubview(code)
        
        userTextField = UITextField(frame:CGRect.zero)
        userTextField.keyboardType = .alphabet
        userTextField.autocorrectionType = .no
        userTextField.backgroundColor = .white
        userTextField.textColor = .black
        userTextField.placeholder = "Mobile Number".toLocalize
        addSubview(userTextField)
        userTextField.layer.cornerRadius = 10
        userTextField.setLeftPaddingPoints(10)
        userTextField.clipsToBounds = true
        
        passwordTextField = UITextField(frame:CGRect.zero)
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "Password".toLocalize
        passwordTextField.keyboardType = .alphabet
        passwordTextField.autocorrectionType = .no
        passwordTextField.textColor = .black
        addSubview(passwordTextField)
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.setLeftPaddingPoints(10)
        passwordTextField.clipsToBounds = true
        
        conformTextFiled = UITextField(frame:CGRect.zero)
        conformTextFiled.placeholder = "Confirm Password".toLocalize
        conformTextFiled.backgroundColor = .white
        conformTextFiled.keyboardType = .alphabet
        conformTextFiled.autocorrectionType = .no
        conformTextFiled.textColor = .black
        addSubview(conformTextFiled)
        conformTextFiled.layer.cornerRadius = 10
        conformTextFiled.setLeftPaddingPoints(10)
        conformTextFiled.clipsToBounds = true
        
        userimageView = UIImageView()
        userimageView.backgroundColor = appGreenTheme
        userimageView.image = #imageLiteral(resourceName: "user-1").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        userimageView.contentMode = .center
        userimageView.layer.cornerRadius = 20
        userimageView.clipsToBounds = true
        addSubview(userimageView)
        
        passwordimageView = UIImageView()
        passwordimageView.backgroundColor = appGreenTheme
        passwordimageView.image = #imageLiteral(resourceName: "thumb-1").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        passwordimageView.contentMode = .center
        passwordimageView.layer.cornerRadius = 20
        passwordimageView.clipsToBounds = true
        addSubview(passwordimageView)
        
        conformimageView = UIImageView()
        conformimageView.backgroundColor = appGreenTheme
        conformimageView.image = #imageLiteral(resourceName: "thumb-1").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        conformimageView.contentMode = .center
        conformimageView.layer.cornerRadius = 20
        conformimageView.clipsToBounds = true
        addSubview( conformimageView)
        
        signUpButton = UIButton()
        signUpButton.backgroundColor =  appGreenTheme
        signUpButton.setImage(#imageLiteral(resourceName: "RightarrowWhite").resizedImage(CGSize.init(width: 33, height: 20), interpolationQuality: .default), for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.cornerRadius = 20
        signUpButton.clipsToBounds = true
        addSubview(signUpButton)
    }
    func addConstraints(){
        
        navBarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        navBack.snp.makeConstraints { (make) in
            make.top.height.equalTo(navBarView)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(30)
        }
        
        signUpLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.top.equalToSuperview().offset(150)
        }
        
        userimageView.snp.makeConstraints { (make) in
            make.top.equalTo(signUpLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.15)
            
        }
        userTextField.snp.makeConstraints { (make) in
            make.left.equalTo(code.snp.right).offset(10)
            make.top.equalTo(userimageView.snp.top)
            make.height.equalTo(userimageView.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        code.snp.makeConstraints { (make) in
            make.left.equalTo(userimageView.snp.right).offset(20)
            make.top.equalTo(userimageView.snp.top)
            make.height.equalTo(userimageView.snp.height)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        passwordimageView.snp.makeConstraints { (make) in
            make.top.equalTo(userimageView.snp.bottom).offset(40)
            make.left.equalTo(userimageView.snp.left)
            make.height.width.equalTo(userimageView)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(passwordimageView.snp.right).offset(20)
            make.top.equalTo(passwordimageView.snp.top)
            make.height.equalTo(passwordimageView.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        
        conformimageView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordimageView.snp.bottom).offset(10)
            make.left.equalTo(passwordimageView.snp.left)
            make.height.width.equalTo(passwordimageView)
        }
        conformTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(conformimageView.snp.right).offset(20)
            make.top.equalTo(conformimageView.snp.top)
            make.height.equalTo(conformimageView.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        signUpButton.snp.makeConstraints { (make) in
            make.left.equalTo(conformimageView.snp.left)
            make.top.equalTo(conformTextFiled.snp.bottom).offset(40)
            make.right.equalTo(conformTextFiled.snp.right)
            make.height.equalTo(conformTextFiled.snp.height)
            
        }
       
        
    }
    
    
    
}

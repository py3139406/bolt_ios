//
//  ResetPasswordView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class ResetPasswordView: UIView {
    var resetTitleLabel: UILabel!
    var passwordimage_View: UIImageView!
    var password_TextField: SkyFloatingLabelTextField!
    var conform_imageView: UIImageView!
    var conform_TextFiled: SkyFloatingLabelTextField!
    var confirmPasswordButton: UIButton!
    var password_ContainerView:UIView!
    var confirm_PasswordContainer:UIView!
    var navBarView: UIView!
    var navBack: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton()
        passwordContainer ()
        confirmContainer()
        addLabel()
        addTextField()
        addimageView()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        super.init(coder: aDecoder)
        super.init(coder: aDecoder)
        fatalError("Error")
        
    }
  
    func confirmContainer(){
        confirm_PasswordContainer = UIView(frame: CGRect.zero)
        confirm_PasswordContainer.backgroundColor = .white
        addSubview(confirm_PasswordContainer)
    }
    func passwordContainer (){
        password_ContainerView = UIView(frame: CGRect.zero)
        password_ContainerView.backgroundColor = .white
        addSubview(password_ContainerView)
    }
    
    
    
    func addLabel(){
        resetTitleLabel = UILabel()
        resetTitleLabel.text = "Reset Password".toLocalize
        resetTitleLabel.textColor = .white
        resetTitleLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        addSubview(resetTitleLabel)
        
    }
    
    
    func addTextField(){
        
        password_TextField = SkyFloatingLabelTextField(frame:CGRect.zero)
        password_TextField.placeholder = "Password".toLocalize
        password_TextField.title = ""
        password_TextField.backgroundColor = .white
        password_TextField.selectedLineColor = .white
        password_TextField.lineColor = .white
        password_TextField.isSecureTextEntry = true
        password_ContainerView.addSubview(password_TextField)
        
        
        conform_TextFiled = SkyFloatingLabelTextField(frame:CGRect.zero)
        conform_TextFiled.backgroundColor = .white
        conform_TextFiled.placeholder = "Confirm Password".toLocalize
        conform_TextFiled.title = ""
        conform_TextFiled.selectedLineColor = .white
        conform_TextFiled.lineColor = .white
        conform_TextFiled.isSecureTextEntry = true
        confirm_PasswordContainer.addSubview(conform_TextFiled)
    }
    
    func addimageView(){
       
        passwordimage_View = UIImageView()
        passwordimage_View.backgroundColor = appGreenTheme
        passwordimage_View.image = #imageLiteral(resourceName: "thumb-1").resizedImage(CGSize.init(width: 35, height: 35), interpolationQuality: .default)
        passwordimage_View.contentMode = .center
        addSubview(passwordimage_View)
        
        conform_imageView = UIImageView()
        conform_imageView.backgroundColor = appGreenTheme
        conform_imageView.image = #imageLiteral(resourceName: "thumb-1").resizedImage(CGSize.init(width: 35, height: 35), interpolationQuality: .default)
        conform_imageView.contentMode = .center
        addSubview( conform_imageView)
        
        
    }
    func addButton(){
        confirmPasswordButton =  UIButton(frame: CGRect.zero)
        confirmPasswordButton.backgroundColor = appGreenTheme
        confirmPasswordButton.setImage(#imageLiteral(resourceName: "RightarrowWhite").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
        addSubview(confirmPasswordButton)
        
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControlState.normal)
        addSubview(navBack)
        
        
    }
    
    func addConstraints(){
        navBarView.snp.makeConstraints { (make) in
            if #available(iOS 11, *){
               make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            }else{
               make.top.equalToSuperview()
            }
            
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        navBack.snp.makeConstraints { (make) in
            make.top.height.equalTo(navBarView)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(30)
        }
        resetTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(screensize.height * 0.2)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.80)
           }
        
        passwordimage_View.snp.makeConstraints { (make) in
            make.top.equalTo(resetTitleLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.18)
        }
        
        password_ContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(passwordimage_View.snp.right)
            make.top.equalTo(passwordimage_View.snp.top)
            make.height.equalTo(passwordimage_View.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        
        password_TextField.snp.makeConstraints { (make) in
            make.width.equalTo(password_ContainerView).multipliedBy(0.7)
            make.top.equalTo(password_ContainerView.snp.top)
            make.height.equalTo(password_ContainerView).multipliedBy(0.7)
            make.left.equalTo(password_ContainerView.snp.left).offset(20)
        }
        
        conform_imageView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordimage_View.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.18)
        }
        confirm_PasswordContainer.snp.makeConstraints { (make) in
            make.left.equalTo(conform_imageView.snp.right)
            make.top.equalTo(conform_imageView.snp.top)
            make.height.equalTo(conform_imageView.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        
        conform_TextFiled.snp.makeConstraints { (make) in
            make.width.equalTo(confirm_PasswordContainer).multipliedBy(0.7)
            make.top.equalTo(confirm_PasswordContainer.snp.top)
            make.height.equalTo(confirm_PasswordContainer).multipliedBy(0.7)
            make.left.equalTo(confirm_PasswordContainer.snp.left).offset(20)
        }
        
        confirmPasswordButton.snp.makeConstraints { (make) in
            make.left.equalTo(conform_imageView.snp.left)
            make.height.equalTo(conform_imageView.snp.height)
            make.top.equalTo(conform_imageView.snp.bottom).offset(20)
            make.right.equalTo(confirm_PasswordContainer.snp.right)
            
        }
       
        
    }
    

}

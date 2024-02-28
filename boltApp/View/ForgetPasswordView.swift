//
//  ForgetPasswordView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

var tag = 0

class ForgetPasswordView: UIView {

    var titleLabel: UILabel!
    var messageTextView: UITextView!
    var mobileNumberTextFiled: SkyFloatingLabelTextField!
    var okButton:UIButton!
    var countryCodeTextField: SkyFloatingLabelTextField!
    var navBarView: UIView!
    var navBack: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        addTextView()
        addTextFields()
        addOkButton()
        addContrainsts()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func addLabel(){
        
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControlState.normal)
        addSubview(navBack)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = " Forgot Password".toLocalize
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        addSubview(titleLabel)
    }
    
    func addTextView(){
        messageTextView = UITextView(frame: CGRect.zero)
        messageTextView.text = "Enter the mobile number you registered with Bolt and we'll send you OTP to get you back online".toLocalize
        messageTextView.textColor =  appGreenTheme
        messageTextView.textContainer.maximumNumberOfLines  = 0
        messageTextView.font = UIFont.systemFont(ofSize: 15)
        messageTextView.backgroundColor = .clear
        messageTextView.isScrollEnabled = false
        messageTextView.isEditable = false
        addSubview(messageTextView)
        
     
    }
    
    func addTextFields(){
        countryCodeTextField = SkyFloatingLabelTextField(frame:CGRect.zero)
        countryCodeTextField.keyboardType = .numberPad
        countryCodeTextField.title = ""
        countryCodeTextField.textAlignment = .center
        countryCodeTextField.selectedLineColor = .white
        countryCodeTextField.lineColor = .white
        countryCodeTextField.textColor = UIColor.white
        countryCodeTextField.placeholder = "91"
        countryCodeTextField.text = "91"
        addSubview(countryCodeTextField)
        
        mobileNumberTextFiled = SkyFloatingLabelTextField(frame: CGRect.zero)
        mobileNumberTextFiled.placeholder = "Enter mobile number".toLocalize
        mobileNumberTextFiled.title = ""
        mobileNumberTextFiled.keyboardType = .numberPad
        mobileNumberTextFiled.font = UIFont.systemFont(ofSize: 15)
        mobileNumberTextFiled.textAlignment = .center
        mobileNumberTextFiled.textColor = UIColor.white
        mobileNumberTextFiled.lineColor = UIColor.white
        mobileNumberTextFiled.selectedLineColor = UIColor.white
        addSubview(mobileNumberTextFiled)
    }
    
    func addOkButton(){
        okButton =  UIButton(frame: CGRect.zero)
        okButton.backgroundColor = appGreenTheme
        okButton.setImage(#imageLiteral(resourceName: "RightarrowWhite").resizedImage(CGSize(width:25,height:18), interpolationQuality: .default), for: .normal)
        
        okButton.layer.cornerRadius = 5
        addSubview(okButton)
    }
    
    func addContrainsts(){
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
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(screensize.height * 0.15)
            make.height.equalTo(self).multipliedBy(0.075)
            make.width.equalTo(self).multipliedBy(0.8)
        }
        
        messageTextView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        
        countryCodeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(messageTextView.snp.left).offset(5)
            make.top.equalTo(messageTextView.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.08)
            make.height.equalToSuperview().multipliedBy(0.10)
        }
        
        mobileNumberTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(countryCodeTextField.snp.right).offset(10)
            make.top.equalTo(countryCodeTextField.snp.top)
            make.height.equalTo(countryCodeTextField.snp.height)
            make.width.equalToSuperview().multipliedBy(0.70)
        }
        
        okButton.snp.makeConstraints { (make) in
           // make.centerX.equalToSuperview()
            make.left.equalTo(countryCodeTextField)
            make.right.equalTo(mobileNumberTextFiled)
            make.top.equalTo(mobileNumberTextFiled.snp.bottom).offset(50)
            //make.width.equalTo(mobileNumberTextFiled)
            make.height.equalToSuperview().multipliedBy(0.08)
           
        }

        
        
        
    }
}

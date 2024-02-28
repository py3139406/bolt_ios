//
//  OTPResetView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class OTPResetView: UIView {

    var topLabel: UILabel!
    var messageTv:UITextView!
    var firstTextField:SkyFloatingLabelTextField!
    var secondTextField:SkyFloatingLabelTextField!
    var thirdTextField:SkyFloatingLabelTextField!
    var fourthTextField:SkyFloatingLabelTextField!
    var stackView : UIStackView!
    var resendOtpButton: UIButton!
    var sendOtpButton: UIButton!
    var counterLabel: UILabel!
    var navBarView: UIView!
    var navBack: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        addMessageTextView()
        addButton()
        addStackView()
        addconstranst()
    }
    
    func addStackView(){
        addTextField()
        stackView = UIStackView(arrangedSubviews: [firstTextField,secondTextField,thirdTextField,fourthTextField])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        addSubview(stackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        super.init(coder: aDecoder)
        super.init(coder: aDecoder)
        fatalError("Error")
    }
    
    func addLabel(){
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControlState.normal)
        addSubview(navBack)
        
        topLabel = UILabel(frame: CGRect.zero)
        topLabel.text = "Enter OTP".toLocalize
        topLabel.textColor = .white
        topLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        addSubview(topLabel)
        
        counterLabel = UILabel(frame: CGRect.zero)
        counterLabel.textColor = .white
        counterLabel.font = UIFont.systemFont(ofSize: 30)
        addSubview(counterLabel)
        
    }
    func addMessageTextView(){
        messageTv = UITextView(frame: CGRect.zero)
        messageTv.text = "Please enter the OTP you just received,to reset your password".toLocalize
        messageTv.textColor =  appGreenTheme
        messageTv.textContainer.maximumNumberOfLines  = 0
        messageTv.font = UIFont.systemFont(ofSize: 15)
        messageTv.backgroundColor = .clear
        messageTv.isScrollEnabled = false
        messageTv.isEditable = false
        addSubview(messageTv)
    }
    
    func  addTextField(){
        firstTextField = SkyFloatingLabelTextField.createOtpTF()
        addSubview(firstTextField)
        
        secondTextField = SkyFloatingLabelTextField.createOtpTF()
        addSubview(secondTextField)
        
        thirdTextField = SkyFloatingLabelTextField.createOtpTF()
        addSubview(thirdTextField)
        
        fourthTextField = SkyFloatingLabelTextField.createOtpTF()
        addSubview(fourthTextField)
    }
    
    func addButton(){
        sendOtpButton = UIButton()
        sendOtpButton.backgroundColor =  appGreenTheme
        sendOtpButton.setImage(#imageLiteral(resourceName: "RightarrowWhite").resizedImage(CGSize.init(width: 35, height: 20), interpolationQuality: .default), for: .normal)
        sendOtpButton.layer.cornerRadius = 5
        addSubview(sendOtpButton)
        
        resendOtpButton = UIButton()
        let title = NSMutableAttributedString(string:NSLocalizedString("Didn\'t received? Send Again".toLocalize, comment:"send otp again".toLocalize))
        
        title.addAttribute(NSAttributedStringKey.foregroundColor, value: appGreenTheme, range:NSMakeRange(0,title.length))
        title.addAttribute(NSAttributedStringKey.font, value:UIFont.boldSystemFont(ofSize: 17) , range:NSMakeRange(0,title.length))
        resendOtpButton.setAttributedTitle(title, for: .normal)
        self.addSubview(resendOtpButton)
    }
    func addconstranst(){
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
        topLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(screensize.height * 0.2)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        messageTv.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(messageTv.snp.left)
            make.top.equalTo(messageTv.snp.bottom).offset(40)
            make.right.equalTo(messageTv.snp.right).offset(-30)
            make.height.equalToSuperview().multipliedBy(0.10)
            
        }
        
        counterLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        
        resendOtpButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(stackView)
            make.top.equalTo(counterLabel.snp.bottom).offset(6)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        
        sendOtpButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(stackView)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        
    }
}





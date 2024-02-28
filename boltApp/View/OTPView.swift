//
//  OTPView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class OTPView: UIView {
    var topLabel: RCLabel!
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
         addButton()
         addStackView()
         addconstranst()
    }
    
    func addStackView(){
        
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControlState.normal)
        addSubview(navBack)
        
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
        fatalError("Error".toLocalize)
    }
    
    func addLabel(){
        topLabel = RCLabel(frame: CGRect.zero)
        topLabel.text = "Enter OTP".toLocalize
        topLabel.textColor = .white
        topLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        topLabel.adjustsFontSizeToFitWidth = true
        addSubview(topLabel)
        
        counterLabel = UILabel(frame: CGRect.zero)
        counterLabel.textColor = .white
        counterLabel.font = UIFont.systemFont(ofSize: 30)
        addSubview(counterLabel)
        
        
        
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
        sendOtpButton.setImage(#imageLiteral(resourceName: "RightarrowWhite").resizedImage(CGSize.init(width: 25, height: 18), interpolationQuality: .default), for: .normal)
        addSubview(sendOtpButton)
        
        resendOtpButton = UIButton()
        let title = NSMutableAttributedString(string:NSLocalizedString("Didn\'t received? Send Again".toLocalize, comment:"send otp again".toLocalize))
        title.addAttribute(NSAttributedStringKey.underlineStyle, value:NSUnderlineStyle.styleSingle.rawValue,range:NSMakeRange(0,title.length))
        title.addAttribute(NSAttributedStringKey.foregroundColor, value:appGreenTheme, range:NSMakeRange(0,title.length))
        title.addAttribute(NSAttributedStringKey.font, value:UIFont.systemFont(ofSize: 15, weight: .light)  , range:NSMakeRange(0,title.length))
        resendOtpButton.setAttributedTitle(title, for: .normal)
        resendOtpButton.isUserInteractionEnabled = true
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
            make.top.equalToSuperview().offset(200)
            make.height.equalToSuperview().multipliedBy(0.10)
            
        }

        stackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(topLabel.snp.bottom).offset(30)
            make.height.equalToSuperview().multipliedBy(0.08)
            
        }
        
        counterLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.20)
        }

        resendOtpButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(stackView)
            make.top.equalTo(counterLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        
        sendOtpButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
            if #available(iOS 11, *){
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin).offset(-0.05 * kscreenheight)
            }else{
               make.bottom.equalToSuperview().offset(-0.05 * kscreenheight)
            }
           
        }
        
        
    }
}


extension SkyFloatingLabelTextField{
    static func createOtpTF()->SkyFloatingLabelTextField{
        let textFiled = SkyFloatingLabelTextField(frame: CGRect.zero)
        textFiled.title = ""
        textFiled.placeholder = "*"
        textFiled.font = UIFont.systemFont(ofSize: 15)
        textFiled.textAlignment = .center
        textFiled.keyboardType = .numberPad
        textFiled.textColor = UIColor.white
        textFiled.lineColor = UIColor.white
        textFiled.selectedLineColor = UIColor.white
        return textFiled
    }
    
}



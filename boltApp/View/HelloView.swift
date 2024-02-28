//
//  HelloView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class HelloView: UIView{
    var topLabel: UILabel!
    var subHeadingLabel: UILabel!
    var userNameTextFiled: SkyFloatingLabelTextField!
    var emailIdTextField: SkyFloatingLabelTextField!
    var okButton: UIButton!
    var userimageView: UIImageView!
    var emailIdimageView: UIImageView!
    var emailViewContainerView:UIView!
    var userNameContainerView:UIView!
    var navBarView: UIView!
    var navBack: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        userContainer()
        passwordContainer ()
        addTextFiled()
        addButton()
        addimageView()
        addConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        //        super.init(coder: aDecoder)
        super.init(coder: aDecoder)
        fatalError("Error")
        
    }
    func userContainer(){
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControlState.normal)
        addSubview(navBack)
        
        userNameContainerView = UIView(frame: CGRect.zero)
        userNameContainerView.backgroundColor = .white
        addSubview(userNameContainerView)
    }
    func passwordContainer (){
        emailViewContainerView = UIView(frame: CGRect.zero)
        emailViewContainerView.backgroundColor = .white
        addSubview(emailViewContainerView)
    }
    func addLabel(){
        topLabel = UILabel()
        topLabel.text = "Hello".toLocalize
        topLabel.textColor = .white
        topLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        addSubview(topLabel)
        
        subHeadingLabel = UILabel()
        subHeadingLabel.text = "Thank you for buying Bolt for your vehicle.Help us to know you better.Please enter your name & mail id below.".toLocalize
        subHeadingLabel.numberOfLines = 0
        subHeadingLabel.adjustsFontSizeToFitWidth = true
        subHeadingLabel.textColor = .white
        addSubview(subHeadingLabel)
        
    }
    
    func addimageView(){
        userimageView = UIImageView()
        userimageView.contentMode = .center
        userimageView.backgroundColor = appGreenTheme
        userimageView.image = #imageLiteral(resourceName: "user-1").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        addSubview(userimageView)
        emailIdimageView = UIImageView()
        emailIdimageView.contentMode = .center
        emailIdimageView.backgroundColor = appGreenTheme
       emailIdimageView.image = #imageLiteral(resourceName: "user").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
       addSubview(emailIdimageView)
        
    }
    
    func addTextFiled(){
        userNameTextFiled = SkyFloatingLabelTextField(frame:CGRect.zero)
        userNameTextFiled.backgroundColor = .white
        userNameTextFiled.selectedLineColor = .white
        userNameTextFiled.title = ""
        userNameTextFiled.autocorrectionType = .no
        userNameTextFiled.lineColor = .white
        userNameTextFiled.attributedPlaceholder = NSAttributedString(attributedString: NSAttributedString(string: "Full Name".toLocalize))
       
        addSubview(userNameTextFiled)
        emailIdTextField = SkyFloatingLabelTextField(frame:CGRect.zero)
        emailIdTextField.selectedLineColor = .white
        emailIdTextField.title = ""
        emailIdTextField.lineColor = .white
        emailIdTextField.autocorrectionType = .no
        emailIdTextField.backgroundColor = .white
        emailIdTextField.keyboardType = .emailAddress
        emailIdTextField.attributedPlaceholder = NSAttributedString(attributedString: NSAttributedString(string: "Email ID".toLocalize))
        addSubview(emailIdTextField)
       
    }
    
    func addButton(){
        okButton = UIButton()
        okButton.backgroundColor =  appGreenTheme
        okButton.setImage(#imageLiteral(resourceName: "oklogo").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        addSubview(okButton)
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
        
        topLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.2)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.08)
            
        }
        subHeadingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topLabel.snp.left)
            make.right.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.13)
            make.top.equalTo(topLabel.snp.bottom)
        }
        
        userimageView.snp.makeConstraints { (make) in
            make.top.equalTo(subHeadingLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.075)
            make.width.equalToSuperview().multipliedBy(0.15)
            
        }
        userNameContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(userimageView.snp.right)
            make.top.equalTo(userimageView.snp.top)
            make.height.equalTo(userimageView.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        
        userNameTextFiled.snp.makeConstraints { (make) in
            make.left.equalTo(userNameContainerView.snp.left).offset(20)
            make.top.equalTo(userNameContainerView.snp.top)
            make.height.equalTo(userNameContainerView.snp.height).multipliedBy(0.9)
            make.width.equalTo(userNameContainerView.snp.width).multipliedBy(0.9)
        }
        
        emailIdimageView.snp.makeConstraints { (make) in
            make.top.equalTo(userimageView.snp.bottom).offset(10)
            make.left.equalTo(userimageView.snp.left)
            make.height.width.equalTo(userimageView)
        }
        
        emailViewContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(emailIdimageView.snp.right)
            make.top.equalTo(emailIdimageView.snp.top)
            make.height.equalTo(emailIdimageView.snp.height)
            make.right.equalToSuperview().offset(-20)
        }
        
        emailIdTextField.snp.makeConstraints { (make) in
            make.left.equalTo(emailViewContainerView.snp.left).offset(20)
            make.top.equalTo(emailViewContainerView.snp.top)
            make.height.equalTo(emailViewContainerView.snp.height).multipliedBy(0.9)
            make.width.equalTo(emailViewContainerView.snp.width).multipliedBy(0.9)
        }
        
        okButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview()
        }
      
    }

   
    
  
}

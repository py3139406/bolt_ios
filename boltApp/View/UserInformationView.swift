//
//  UserInformationView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class UserInformationView: UIView {
    var vechileNameTextField:UITextField!
    var device_imeiNumberTextField:UITextField!
    var imeiScanner:UIButton!
    var activationCode:UITextField!
    var activationScanner:UIButton!
    var okButton: UIButton!
    var TitleLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate  func addViews(){
        TitleLbl = UILabel(frame: CGRect.zero)
        TitleLbl.text = "Add Device"
        TitleLbl.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 25)
        TitleLbl.textColor = .white
        addSubview(TitleLbl)
        
        vechileNameTextField = UITextField(frame:CGRect.zero)
        vechileNameTextField.backgroundColor = .white
        vechileNameTextField.borderStyle = .line
        vechileNameTextField.placeholder = "Device name".toLocalize
        vechileNameTextField.font = UIFont.systemFont(ofSize: 15)
        vechileNameTextField.autocorrectionType = .no
        vechileNameTextField.setLeftPaddingPoints(20)
        vechileNameTextField.setRightPaddingPoints(10)
        addSubview(vechileNameTextField)
        
        device_imeiNumberTextField = UITextField(frame:CGRect.zero)
        device_imeiNumberTextField.backgroundColor = .white
        device_imeiNumberTextField.borderStyle = .line
        device_imeiNumberTextField.placeholder = "Device IMEI Number".toLocalize
        device_imeiNumberTextField.font = UIFont.systemFont(ofSize: 15)
        device_imeiNumberTextField.setLeftPaddingPoints(20)
        device_imeiNumberTextField.setRightPaddingPoints(10)
        addSubview(device_imeiNumberTextField)
        
        imeiScanner = UIButton()
        imeiScanner.backgroundColor =  appGreenTheme
        imeiScanner.setImage(UIImage(named: "scanner")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        addSubview(imeiScanner)
        
        activationCode = UITextField(frame:CGRect.zero)
        activationCode.backgroundColor = .white
        activationCode.borderStyle = .line
        activationCode.placeholder = "Activation Code".toLocalize
        activationCode.font = UIFont.systemFont(ofSize: 15)
        activationCode.setLeftPaddingPoints(20)
        activationCode.setRightPaddingPoints(10)
        addSubview(activationCode)
        
        activationScanner = UIButton()
        activationScanner.backgroundColor =  appGreenTheme
        activationScanner.setImage(UIImage(named: "scanner")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        addSubview(activationScanner)
        
        okButton = UIButton()
        okButton.backgroundColor =  appGreenTheme
        okButton.setTitle("PROCEED", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        okButton.titleLabel?.textAlignment = .center
        addSubview(okButton)
        
    }
    
    
    func addConstraints(){
        TitleLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.2 * screenSize.height)
            make.left.equalToSuperview().offset(screensize.width  * 0.05)
        }
        
        vechileNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(TitleLbl.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        device_imeiNumberTextField.snp.makeConstraints { (make) in
            make.left.equalTo(vechileNameTextField)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.top.equalTo(vechileNameTextField.snp.bottom).offset(10)
        }
        imeiScanner.snp.makeConstraints { (make) in
            make.centerY.equalTo(device_imeiNumberTextField)
            make.width.equalToSuperview().multipliedBy(0.18)
            make.height.equalTo(device_imeiNumberTextField)
            make.left.equalTo(device_imeiNumberTextField.snp.right).offset(screensize.width * 0.01)
        }
        activationCode.snp.makeConstraints { (make) in
            make.left.equalTo(vechileNameTextField)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.top.equalTo(device_imeiNumberTextField.snp.bottom).offset(10)
        }
        activationScanner.snp.makeConstraints { (make) in
            make.centerY.equalTo(activationCode)
            make.width.equalToSuperview().multipliedBy(0.18)
            make.height.equalTo(device_imeiNumberTextField)
            make.left.equalTo(activationCode.snp.right).offset(screensize.width * 0.01)
        }
        okButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        
        
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

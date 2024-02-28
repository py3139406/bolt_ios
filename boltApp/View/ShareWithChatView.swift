//
//  ShareWithChatView.swift
//  Bolt
//
//  Created by Roadcast on 05/11/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class ShareWithChatView: UIView {
    
    var vechicleImageView: UIImageView!
    var vechileTextField: UITextField!
    var shareButton: UIButton!
    var VechileNameContainerView:UIView!
    var dropIcon: UIImageView!
    var selectVehicleBtn:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstrainsts()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }
    
    private func addViews(){
        VechileNameContainerView = UIView(frame: CGRect.zero)
        VechileNameContainerView.backgroundColor = .white
        VechileNameContainerView.layer.cornerRadius = 5
        addSubview(VechileNameContainerView)
        
        vechileTextField = UITextField()
        vechileTextField.placeholder = "Select your Vehicle".toLocalize
        vechileTextField.attributedPlaceholder = NSAttributedString(string: "Select your Vehicle",
        attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        vechileTextField.backgroundColor = .clear
        vechileTextField.textColor = .black
        VechileNameContainerView.addSubview(vechileTextField)
        
        vechicleImageView = UIImageView()
        vechicleImageView.backgroundColor = .white
        vechicleImageView.image = #imageLiteral(resourceName: "LoadUnload").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        vechicleImageView.contentMode = .center
        VechileNameContainerView.addSubview(vechicleImageView)
        
        dropIcon = UIImageView()
        dropIcon.backgroundColor = .white
        dropIcon.image = #imageLiteral(resourceName: "menu").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        dropIcon.contentMode = .center
        VechileNameContainerView.addSubview(dropIcon)
        
        shareButton = UIButton()
        shareButton.backgroundColor = appGreenTheme
        shareButton.layer.cornerRadius = 5
        shareButton.layer.masksToBounds = true
        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        addSubview(shareButton)
    }
    func addConstrainsts(){
        vechicleImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(25)
            make.centerY.equalToSuperview()
        }
        VechileNameContainerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        vechileTextField.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        dropIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
        }
        shareButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(VechileNameContainerView.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
    }
    
}


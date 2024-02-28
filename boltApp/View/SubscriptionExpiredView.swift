//
//  SubscriptionExpiredView.swift
//  Bolt
//
//  Created by Vishesh on 5/16/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//


import Foundation
import Foundation
import UIKit
import SnapKit

class SubscriptionExpired : UIViewController {
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    var expiredImageView = UIImageView()
    var oopsLabel = UILabel()
    var descriptionLabel = UILabel()
    var vehicleNumberLabel = UILabel()
    var helpLabel = UILabel()
    var lowerBack = UIView()
    var liveChatButton = UIButton()
    var closeButton = UIButton()
    var containerView = UIView()
    var onCompletion: ((_ success: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .green
        
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.white
        containerView.backgroundColor = UIColor.white
        self.view.addSubview(containerView)
        
        lowerBack.backgroundColor = appDarkTheme
        self.containerView.addSubview(lowerBack)
        
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "closeButtonSubscriptionExpired"), for: .normal)
        self.containerView.addSubview(closeButton)
        
        expiredImageView.image = UIImage(named: "subscriptionExpiredIcon")
        expiredImageView.backgroundColor = .white
        self.containerView.addSubview(expiredImageView)
        
        oopsLabel.text = "OOPS"
        oopsLabel.font = UIFont.boldSystemFont(ofSize: 30)
        oopsLabel.textColor = .black
        oopsLabel.backgroundColor = .clear
        oopsLabel.textAlignment = .center
        self.containerView.addSubview(oopsLabel)
        
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .red
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        self.containerView.addSubview(descriptionLabel)
        
        vehicleNumberLabel.backgroundColor = .clear
        vehicleNumberLabel.numberOfLines = 0
        vehicleNumberLabel.textColor = .red
        vehicleNumberLabel.textAlignment = .center
        vehicleNumberLabel.font = UIFont.boldSystemFont(ofSize: 25)
        vehicleNumberLabel.adjustsFontSizeToFitWidth = true
        // vehicleNumberLabel.text = expiredVehicleNumber
        self.containerView.addSubview(vehicleNumberLabel)
        
        helpLabel.textAlignment = .center
        helpLabel.textColor = .white
        helpLabel.numberOfLines = 0
        helpLabel.text = "Let us help you Re-Activate your Subscription"
        self.containerView.addSubview(helpLabel)
        
        liveChatButton.setImage(UIImage(named: "liveChatButtonIcon"), for: .normal)
        liveChatButton.addTarget(self, action: #selector(liveChatButtonTapped(_:)), for: .touchUpInside)
        self.containerView.addSubview(liveChatButton)
        
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { (make) in
            
            make.top.right.left.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.05)
            make.left.equalTo(UIScreen.main.bounds.width * 0.85)
            make.width.equalTo(UIScreen.main.bounds.width * 0.1)
            make.height.equalTo(UIScreen.main.bounds.width * 0.1)
        }
        
        expiredImageView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.08)
            // make.height.equalTo(UIScreen.main.bounds.height * 0.4)
            make.size.equalTo(UIScreen.main.bounds.height * 0.15)
        }
        oopsLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(expiredImageView.snp.bottom).offset(height * 0.0075)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(height * 0.05)
        }
        descriptionLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(oopsLabel.snp.bottom).offset(height * 0.003)
            make.left.equalToSuperview().multipliedBy(0.1)
            //  make.width.equalToSuperview().multipliedBy(0.8)
            // make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalToSuperview()
        }
        vehicleNumberLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(height * 0.35)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        lowerBack.snp.makeConstraints{ (make) in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(vehicleNumberLabel.snp.bottom).offset(10)
        }
        helpLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(lowerBack.snp.top).offset(height * 0.03)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            
        }
        liveChatButton.snp.makeConstraints{ (make) in
            make.top.equalTo(helpLabel.snp.bottom).offset(height * 0.05)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    
}

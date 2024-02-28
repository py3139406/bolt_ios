//
//  BLEActivateView.swift
//  Bolt
//
//  Created by Roadcast on 07/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class BLEActivateView: UIView {

    var connectedImg = UIImageView()
    var imeiCheckedImg = UIImageView()
    var authImg = UIImageView()
    var connectedLabel = UILabel()
    var imeiLabel = UILabel()
    var authLabel = UILabel()
    var line = UIView()
    var peripheralLabel  = UILabel()
    var customView = UIView()
    var activatedLabel = UILabel()
    var activedSwitch = UISwitch()
   // var retryButton = UIButton()
    let screenSize = UIScreen.main.bounds.size
    override init(frame: CGRect) {
       super.init(frame: frame)
  addViews()
  addConstarints()
     }
    func addViews(){
        connectedImg.image = #imageLiteral(resourceName: "ignoff")
        addSubview(connectedImg)
        
        imeiCheckedImg.image = #imageLiteral(resourceName: "ignoff")
        addSubview(imeiCheckedImg)
        
        authImg.image = #imageLiteral(resourceName: "ignoff")
       addSubview(authImg)
        
        connectedLabel.text = "Connected"
        connectedLabel.textColor = .black
        connectedLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        connectedLabel.sizeToFit()
        addSubview(connectedLabel)
        
        imeiLabel.text = "Imei Checked"
        imeiLabel.textColor = .black
        imeiLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        imeiLabel.sizeToFit()
       addSubview(imeiLabel)
        
        authLabel.text = "Authorisation successful"
        authLabel.textColor = .black
        authLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        authLabel.sizeToFit()
        addSubview(authLabel)
        
        line.backgroundColor = .black
        addSubview(line)
        
        peripheralLabel.textColor = .black
        peripheralLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        peripheralLabel.sizeToFit()
        addSubview(peripheralLabel)
        
        customView.backgroundColor = .black
        addSubview(customView)
        
        activatedLabel.text = "Activated"
        activatedLabel.textColor = .white
        activatedLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        activatedLabel.sizeToFit()
        customView.addSubview(activatedLabel)
        
        activedSwitch.onImage = #imageLiteral(resourceName: "onlineNotificationicon")
        activedSwitch.offImage = #imageLiteral(resourceName: "newRedNotification")
        activedSwitch.setOn(false, animated: false)
        customView.addSubview(activedSwitch)
        
//        retryButton.setTitle("RETRY", for: .normal)
//        retryButton.setTitleColor(.white, for: .normal)
//        retryButton.backgroundColor = .appGreen
//        retryButton.titleLabel?.textAlignment = .center
//        retryButton.contentMode = .scaleAspectFit
//        retryButton.isUserInteractionEnabled = false
//        customView.addSubview(retryButton)
        
        
    }
    func addConstarints(){
        connectedImg.snp.makeConstraints { (make) in

            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(25)
        }
        connectedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(connectedImg.snp.top).offset(2)
            make.left.equalTo(connectedImg.snp.right).offset(20)
            make.width.equalToSuperview()
        }
        imeiCheckedImg.snp.makeConstraints { (make) in
            make.top.equalTo(connectedImg.snp.bottom).offset(screenSize.height * 0.05)
            make.left.equalTo(connectedImg)
            make.size.equalTo(connectedImg)
        }
        imeiLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imeiCheckedImg).offset(2)
            make.left.equalTo(connectedLabel)
            make.width.equalToSuperview()
        }
        authImg.snp.makeConstraints { (make) in
            make.top.equalTo(imeiCheckedImg.snp.bottom).offset(screenSize.height * 0.05)
            make.left.equalTo(connectedImg)
            make.size.equalTo(connectedImg)
        }
        authLabel.snp.makeConstraints { (make) in
            make.top.equalTo(authImg).offset(2)
            make.left.equalTo(connectedLabel)
            make.width.equalToSuperview()
        }
        line.snp.makeConstraints { (make) in
            make.top.equalTo(authLabel.snp.bottom).offset(screenSize.height * 0.05)
            make.width.equalToSuperview()
            make.height.equalTo(screenSize.height * 0.001)
        }
        peripheralLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(screenSize.height * 0.03)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview()
        }
        customView.snp.makeConstraints { (make) in
            make.top.equalTo(peripheralLabel.snp.bottom).offset(screenSize.height * 0.03)
            make.width.equalToSuperview()
            make.height.equalTo(screenSize.height * 0.06)
        }
        activatedLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        activedSwitch.snp.makeConstraints { (make) in
            //  make.top.equalTo(activatedLabel)
            make.right.equalToSuperview().inset(screenSize.width * 0.05)
            //make.height.equalTo(screenSize.height * 0.002)
            //  make.width.equalTo(screenSize.width * 0.04)
            make.top.bottom.equalTo(activatedLabel)
        }
//        retryButton.snp.makeConstraints { (make) in
//            make.top.equalTo(customView.snp.bottom).offset(screenSize.height * 0.03)
//            make.width.equalToSuperview()
//            make.height.equalTo(screenSize.height * 0.06)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

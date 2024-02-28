//
//  BLEView.swift
//  Bolt
//
//  Created by Roadcast on 07/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class BLEView: UIView {
    var btView = UIView()
    var btLabel = UILabel()
    var activateSwitch = UISwitch()
    var seperator = UIView()
    var seperator2 = UIView()
    var scanBgView = UIView()
    var availableDeviceLabel = UILabel()
    var scanButton = UIButton()
    var periferalTableView = UITableView()
    var screenSize = UIScreen.main.bounds.size
    var bleIndicator: UIActivityIndicatorView!
    override init(frame: CGRect) {
       super.init(frame: frame)
       //function call here
        addViews()
        addConstraints()

     }
        func addViews(){
            btView.backgroundColor = UIColor.white
            addSubview(btView)
            
            btLabel.text = "Bluetooth"
            btLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            btLabel.textColor = .black
            btView.addSubview(btLabel)
            
            activateSwitch.onImage = #imageLiteral(resourceName: "onlineNotificationicon")
            activateSwitch.offImage = #imageLiteral(resourceName: "newRedNotification")
            activateSwitch.isUserInteractionEnabled = true
            // activateSwitch.isOn = true
            activateSwitch.setOn(false, animated: false)
            btView.addSubview(activateSwitch)
            
            seperator.backgroundColor = .darkGray
            addSubview(seperator)
            
            seperator2.backgroundColor = .darkGray
            addSubview(seperator2)
            
            scanBgView .backgroundColor = .white
            addSubview(scanBgView)
            
            availableDeviceLabel.text = "Available Devices"
            availableDeviceLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            availableDeviceLabel.textColor = .appGreen
            scanBgView.addSubview(availableDeviceLabel)
            
            scanButton.setTitle("SCAN", for: .normal)
            scanButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            scanButton.setTitleColor(.white, for: .normal)
            scanButton.backgroundColor = .appGreen
            scanButton.contentMode = .scaleAspectFit
            scanButton.layer.cornerRadius = 5.0
            scanButton.clipsToBounds = true
    //        scanButton.alpha = 0
            scanButton.isUserInteractionEnabled = false
            scanBgView.addSubview(scanButton)
            
            periferalTableView.backgroundColor = UIColor.white
           // periferalTableView.register(UITableViewCell.self, forCellReuseIdentifier: "deviceCell")
           // periferalTableView.delegate = self
           // periferalTableView.dataSource = self
            periferalTableView.bounces = false
           addSubview(periferalTableView)
            
            bleIndicator =  UIActivityIndicatorView()
            bleIndicator.activityIndicatorViewStyle = .gray
            bleIndicator.hidesWhenStopped = true
            scanBgView.addSubview(bleIndicator)
            
        }
        func addConstraints(){
            seperator2.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(1)
            }
            btView.snp.makeConstraints { (make) in

                    // Fallback on earlier versions
                make.top.equalTo(seperator2.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(screenSize.height * 0.09)
            }
            btLabel.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.left.equalToSuperview().offset(20)
            }
            activateSwitch.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(btLabel)//.offset(screenSize.height * 0.02)
                make.right.equalToSuperview().offset(-20)
                //            make.height.equalTo(btLabel)
                //            make.width.equalTo(screenSize.width * 0.15)
                //make.bottom.equalToSuperview().offset(-screenSize.height * 0.02)
            }
            seperator.snp.makeConstraints { (make) in
                make.top.equalTo(btView.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(1)
            }
            scanBgView.snp.makeConstraints { (make) in
                make.top.equalTo(seperator.snp.bottom)
                make.width.equalToSuperview()
                make.height.equalTo(screenSize.height * 0.07)
            }
            availableDeviceLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(10)
                make.width.equalToSuperview().multipliedBy(0.45)
            }
            bleIndicator.snp.makeConstraints { (make) in
                make.centerY.equalTo(availableDeviceLabel)
                make.left.equalTo(availableDeviceLabel.snp.right)
            }
            scanButton.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(screenSize.height * 0.01)
                make.right.equalToSuperview().offset(-screenSize.width * 0.03)
                make.width.equalTo(screenSize.width * 0.25)
                // make.height.equalTo(screenSize.height * 0.04)
                make.bottom.equalToSuperview().offset(-screenSize.height * 0.01)
            }
            periferalTableView.snp.makeConstraints { (make) in
                make.top.equalTo(scanBgView.snp.bottom)
                make.width.equalToSuperview()
                    make.bottom.equalToSuperview().inset(20)
                
            }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

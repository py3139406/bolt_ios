//
//  VoiceCallView.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit

class VoiceCallView: UIView {
    var labelNewBooking: UILabel!
    var labelTimer: UILabel!
    var logo: UIImageView!
    
    var downloadView: UIView!
    var downloadLabel: UILabel!
    
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        addConstraints()
        self.backgroundColor = UIColor(red: 230/255, green: 255/255, blue: 247/255, alpha: 1.0)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error".toLocalize)
    }
    func addUIElements() {
        
        labelNewBooking = UILabel(frame: CGRect.zero)
        labelNewBooking.text = ""
        labelNewBooking.textAlignment = .center
        labelNewBooking.numberOfLines = 3
        labelNewBooking.lineBreakMode = .byWordWrapping
        labelNewBooking.textColor = .black
        labelNewBooking.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addSubview(labelNewBooking)
        
        labelTimer = UILabel(frame: CGRect.zero)
        labelTimer.text = "00:00:00"
        labelTimer.textAlignment = .center
        labelTimer.numberOfLines = 3
        labelTimer.lineBreakMode = .byWordWrapping
        labelTimer.textColor = .black
        labelTimer.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addSubview(labelTimer)
        
        logo = UIImageView(frame: CGRect.zero)
        logo.image = UIImage(named: "ic_call_car")!.resizedImage(CGSize.init(width: 120, height: 120), interpolationQuality: .default)
        logo.contentMode = .scaleAspectFit
        addSubview(logo)
        
        downloadView = UIView()
        downloadView.isUserInteractionEnabled = true
        downloadView.backgroundColor = appGreenTheme
        downloadView.layer.cornerRadius = 10
        downloadView.layer.masksToBounds = true
        addSubview(downloadView)
        
        downloadLabel = UILabel()
        downloadLabel.text = "LEAVE"
        downloadLabel.textColor = .white
        downloadView.addSubview(downloadLabel)
    }
    func addConstraints() {
        
        logo.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(kScreenWidth * 0.3)
            make.centerX.equalToSuperview()
        }
        
        downloadView.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        
        downloadLabel.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
        }
        
        labelNewBooking.snp.makeConstraints { (make) in
            make.top.equalTo(logo.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        labelTimer.snp.makeConstraints { (make) in
            make.top.equalTo(labelNewBooking.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
    }
}

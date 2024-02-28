//
//  DeviceQRScanView.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit

class DeviceQRScanView: UIView {
    var labelNewBooking: UILabel!
    var logo: UIImageView!
    var qrImageView: UIImageView!
    
    var downloadView: UIView!
    var downloadLabel: UILabel!
    var downloadButton: UIButton!
    
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
        labelNewBooking.text = "If you think vehicle is parked wrong scan this QR Code to notify"
        labelNewBooking.textAlignment = .center
        labelNewBooking.numberOfLines = 3
        labelNewBooking.lineBreakMode = .byWordWrapping
        labelNewBooking.textColor = .black
        labelNewBooking.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addSubview(labelNewBooking)
        
        logo = UIImageView(frame: CGRect.zero)
        logo.image = UIImage(named: "ic_bolt_logo")!.resizedImage(CGSize.init(width: 120, height: 72), interpolationQuality: .default)
        logo.contentMode = .scaleAspectFit
        addSubview(logo)
        
        qrImageView = UIImageView(frame: CGRect.zero)
//        qrImageView.image = UIImage(named: "ic_bolt_logo")!.resizedImage(CGSize.init(width: 100, height: 100), interpolationQuality: .default)
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.backgroundColor = .white
        addSubview(qrImageView)
        
        downloadView = UIView()
        downloadView.isUserInteractionEnabled = true
        downloadView.backgroundColor = appGreenTheme
        downloadView.layer.cornerRadius = 10
        downloadView.layer.masksToBounds = true
        addSubview(downloadView)
        
        downloadButton = UIButton()
        downloadButton.backgroundColor = .clear
        if let myImage = UIImage(named: "download-1") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            downloadButton.setImage(tintableImage , for: .normal)
        }
        downloadButton.tintColor = UIColor.white
        downloadButton.contentMode = .scaleAspectFit
        downloadView.addSubview(downloadButton)
        
        downloadLabel = UILabel()
        downloadLabel.text = "Download Qr"
        downloadLabel.textColor = .white
        downloadView.addSubview(downloadLabel)
    }
    func addConstraints() {
        
        logo.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(kScreenWidth * 0.3)
            make.centerX.equalToSuperview()
        }
        qrImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(150)
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(50)
        }
        
        downloadView.snp.makeConstraints{(make) in
        
            make.bottom.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(170)
        }
        
        downloadButton.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(25)
            make.width.equalTo(30)
        }
        downloadLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(downloadButton.snp.left).offset(-10)
        }
        labelNewBooking.snp.makeConstraints { (make) in
            make.top.equalTo(qrImageView.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
    }
}

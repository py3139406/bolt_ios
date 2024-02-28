//
//  BottomSheetWatchCell.swift
//  Bolt
//
//  Created by Roadcast on 04/12/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class BottomSheetWatchCell: UIScrollView {
    var darkView: UIView!
    var ignitionLabel: UILabel!
    var ignitionImage: UIImageView!
    var ignitionStatusLabel: UILabel!
    
    var networkLabel: UILabel!
    var networkImage: UIImageView!
    var networkStatusLabel: UILabel!
    
    var geoLabel: UILabel!
    var geoImage: UIImageView!
    var geoStatusLabel: UILabel!
    
    var immoLabel: UILabel!
    var immoImage: UIImageView!
    var immoStatusLabel: UILabel!
    
    var watchUpdateImage: UIImageView!
    var watchUpdateStatusLabel: UILabel!
    
  
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        ignitionImage.layer.cornerRadius = (self.frame.height*0.4)/2
        networkImage.layer.cornerRadius = (self.frame.height*0.4)/2
        geoImage.layer.cornerRadius = (self.frame.height*0.4)/2
        immoImage.layer.cornerRadius = (self.frame.height*0.4)/2
        watchUpdateImage.layer.cornerRadius = (self.frame.height*0.4)/2
//        doorImage.layer.cornerRadius = (self.frame.height*0.4)/2
//        acImage.layer.cornerRadius = (self.frame.height*0.4)/2
//        chargingImage.layer.cornerRadius = (self.frame.height*0.4)/2
//        tempImage.layer.cornerRadius = (self.frame.height*0.4)/2
//        batImage.layer.cornerRadius = (self.frame.height*0.4)/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
        darkView = UIView(frame: CGRect.zero)
        darkView.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 41/255, alpha: 1)
        addSubview(darkView)
        
//        ignitionLabel = UILabel.init(frame: CGRect.zero)
//        ignitionLabel.backgroundColor = .clear
//        ignitionLabel.text = "Ignition"
//        ignitionLabel.font = UIFont.systemFont(ofSize: 11)
//        ignitionLabel.textColor = .white
//        ignitionLabel.textAlignment = .center
//        addSubview(ignitionLabel)
        
        ignitionImage = UIImageView()
        ignitionImage.contentMode = .scaleAspectFit
        ignitionImage.clipsToBounds = true
        ignitionImage.image = #imageLiteral(resourceName: "Asset 125 (1)")
        ignitionImage.isUserInteractionEnabled = true
        addSubview(ignitionImage)
        
        ignitionStatusLabel = UILabel.init(frame: CGRect.zero)
        ignitionStatusLabel.backgroundColor = .clear
        ignitionStatusLabel.font = UIFont.systemFont(ofSize: 11)
        ignitionStatusLabel.textColor = .white
        ignitionStatusLabel.textAlignment = .center
        ignitionStatusLabel.text = "Camera"
        addSubview(ignitionStatusLabel)
        
        
//        networkLabel = UILabel.init(frame: CGRect.zero)
//        networkLabel.backgroundColor = .clear
//        networkLabel.text = "Network"
//        networkLabel.font = UIFont.systemFont(ofSize: 11)
//        networkLabel.textColor = .white
//        networkLabel.textAlignment = .center
//        addSubview(networkLabel)
        
        networkImage = UIImageView()
        networkImage.contentMode = .scaleAspectFit
        networkImage.clipsToBounds = true
        networkImage.isUserInteractionEnabled = true
        networkImage.image = #imageLiteral(resourceName: "Asset 126")
        addSubview(networkImage)
        
        networkStatusLabel = UILabel.init(frame: CGRect.zero)
        networkStatusLabel.isUserInteractionEnabled = true
        networkStatusLabel.backgroundColor = .clear
        networkStatusLabel.textColor = .white
        networkStatusLabel.textAlignment = .center
        networkStatusLabel.adjustsFontSizeToFitWidth = true
        networkStatusLabel.font = UIFont.systemFont(ofSize: 11)
        networkStatusLabel.text = "Album"
        addSubview(networkStatusLabel)
        
//        geoLabel = UILabel.init(frame: CGRect.zero)
//        geoLabel.backgroundColor = .clear
//        geoLabel.text = "Geofence"
//        geoLabel.textColor = .white
//        geoLabel.font = UIFont.systemFont(ofSize: 11)
//        geoLabel.textAlignment = .center
//        addSubview(geoLabel)
        
        geoImage = UIImageView()
        geoImage.contentMode = .scaleAspectFit
        geoImage.clipsToBounds = true
        geoImage.isUserInteractionEnabled = true
        geoImage.image = #imageLiteral(resourceName: "Asset 127")
        addSubview(geoImage)
        
        geoStatusLabel = UILabel.init(frame: CGRect.zero)
        geoStatusLabel.backgroundColor = .clear
        geoStatusLabel.textColor = .white
        geoStatusLabel.isUserInteractionEnabled = true
        geoStatusLabel.font = UIFont.systemFont(ofSize: 11)
        geoStatusLabel.textAlignment = .center
        geoStatusLabel.text = "Call watch"
        addSubview(geoStatusLabel)
        
//        immoLabel = UILabel.init(frame: CGRect.zero)
//        immoLabel.backgroundColor = .clear
//        immoLabel.text = "Immobilizer"
//        immoLabel.font = UIFont.systemFont(ofSize: 11)
//        immoLabel.textColor = .white
//        immoLabel.textAlignment = .center
//        addSubview(immoLabel)
        
        immoImage = UIImageView()
        immoImage.contentMode = .scaleAspectFit
        immoImage.isUserInteractionEnabled = true
        immoImage.clipsToBounds = true
        immoImage.image = #imageLiteral(resourceName: "Asset 128")
        addSubview(immoImage)
        
        immoStatusLabel = UILabel.init(frame: CGRect.zero)
        immoStatusLabel.backgroundColor = .clear
        immoStatusLabel.textColor = .white
        immoStatusLabel.isUserInteractionEnabled = true
        immoStatusLabel.font = UIFont.systemFont(ofSize: 11)
        immoStatusLabel.textAlignment = .center
        immoStatusLabel.text = "Phonebook"
        addSubview(immoStatusLabel)
        
//        parkingLabel = UILabel.init(frame: CGRect.zero)
//        parkingLabel.backgroundColor = .clear
//        parkingLabel.text = "Parking"
//        parkingLabel.font = UIFont.systemFont(ofSize: 11)
//        parkingLabel.textColor = .white
//        parkingLabel.textAlignment = .center
//        addSubview(parkingLabel)
        
        watchUpdateImage = UIImageView()
        watchUpdateImage.contentMode = .scaleAspectFit
        watchUpdateImage.clipsToBounds = true
        watchUpdateImage.isUserInteractionEnabled = true
        watchUpdateImage.image = #imageLiteral(resourceName: "Asset 129")
        watchUpdateImage.isUserInteractionEnabled = true
        addSubview(watchUpdateImage)
        
        watchUpdateStatusLabel = UILabel.init(frame: CGRect.zero)
        watchUpdateStatusLabel.backgroundColor = .clear
        watchUpdateStatusLabel.textColor = .white
        watchUpdateStatusLabel.font = UIFont.systemFont(ofSize: 11)
        watchUpdateStatusLabel.textAlignment = .center
        watchUpdateStatusLabel.text = "Update time"
        watchUpdateStatusLabel.isUserInteractionEnabled = true
        addSubview(watchUpdateStatusLabel)
        }
    
    func addConstraints() -> Void {
        
        ignitionImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
//        darkView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(0.2 * kscreenheight)
//            
//        }
        
        ignitionStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ignitionImage.snp.bottom).offset(2)
            make.centerX.equalTo(ignitionImage)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        networkImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(ignitionImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        networkStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(networkImage.snp.bottom).offset(2)
            make.centerX.equalTo(networkImage)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        geoImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(networkImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        geoStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(geoImage.snp.bottom).offset(2)
            make.centerX.equalTo(geoImage)
           make.width.equalToSuperview().dividedBy(5)
           make.height.equalToSuperview().multipliedBy(0.4)

        }
        
        immoImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(geoImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        immoStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(immoImage.snp.bottom).offset(2)
            make.centerX.equalTo(immoImage)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)

        }
        
        watchUpdateImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(immoImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        watchUpdateStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(watchUpdateImage.snp.bottom).offset(2)
            make.centerX.equalTo(watchUpdateImage)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)

        }
        }
        
        
    }
    
    


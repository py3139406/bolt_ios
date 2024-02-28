//
//  MoreInfoViewSecondScrollView.swift
//  Bolt
//
//  Created by Vivek Kumar on 30/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class MoreInfoViewSecondScrollView: UIScrollView {

    var parkingLabel: UILabel!
       var parkingImage: UIImageView!
       var parkingStatusLabel: UILabel!
       
       var doorLabel: UILabel!
       var doorImage: UIImageView!
       var doorStatusLabel: UILabel!
       
       var acLabel: UILabel!
       var acImage: UIImageView!
       var acStatusLabel: UILabel!
       
       var chargingLabel: UILabel!
       var chargingImage: UIImageView!
       var chargingStatusLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        parkingImage.layer.cornerRadius = (self.frame.height*0.4)/2
        doorImage.layer.cornerRadius = (self.frame.height*0.4)/2
        acImage.layer.cornerRadius = (self.frame.height*0.4)/2
        chargingImage.layer.cornerRadius = (self.frame.height*0.4)/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
       
        parkingLabel = UILabel.init(frame: CGRect.zero)
        parkingLabel.backgroundColor = .clear
        parkingLabel.text = "Parking"
        parkingLabel.font = UIFont.systemFont(ofSize: 11)
        parkingLabel.textColor = .white
        parkingLabel.textColor =  UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        parkingLabel.textAlignment = .center
        addSubview(parkingLabel)
        
        parkingImage = UIImageView()
        parkingImage.contentMode = .scaleAspectFit
        parkingImage.clipsToBounds = true
        parkingImage.image = #imageLiteral(resourceName: "Asset 18")
        addSubview(parkingImage)
        
        parkingStatusLabel = UILabel.init(frame: CGRect.zero)
        parkingStatusLabel.backgroundColor = .clear
        parkingStatusLabel.textColor = .white
        parkingStatusLabel.font = UIFont.systemFont(ofSize: 11)
        parkingStatusLabel.textAlignment = .center
        parkingStatusLabel.text = "OFF"
        addSubview(parkingStatusLabel)
        
        doorLabel = UILabel.init(frame: CGRect.zero)
        doorLabel.backgroundColor = .clear
        doorLabel.text = "Door"
        doorLabel.font = UIFont.systemFont(ofSize: 11)
        doorLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        doorLabel.textAlignment = .center
        addSubview(doorLabel)
        
        doorImage = UIImageView()
        doorImage.contentMode = .scaleAspectFit
        doorImage.clipsToBounds = true
        doorImage.image = #imageLiteral(resourceName: "dooroff")
        addSubview(doorImage)
        
        doorStatusLabel = UILabel.init(frame: CGRect.zero)
        doorStatusLabel.backgroundColor = .clear
        doorStatusLabel.textColor = .white
        doorStatusLabel.font = UIFont.systemFont(ofSize: 11)
        doorStatusLabel.textAlignment = .center
        doorStatusLabel.text = "CLOSED"
        addSubview(doorStatusLabel)
        
        acLabel = UILabel.init(frame: CGRect.zero)
        acLabel.backgroundColor = .clear
        acLabel.text = "A/C"
        acLabel.font = UIFont.systemFont(ofSize: 11)
        acLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        acLabel.textAlignment = .center
        addSubview(acLabel)
        
        acImage = UIImageView()
        acImage.contentMode = .scaleAspectFit
        acImage.clipsToBounds = true
        acImage.image = #imageLiteral(resourceName: "acoff")
        addSubview(acImage)
        
        acStatusLabel = UILabel.init(frame: CGRect.zero)
        acStatusLabel.backgroundColor = .clear
        acStatusLabel.textColor = .white
        acStatusLabel.font = UIFont.systemFont(ofSize: 11)
        acStatusLabel.textAlignment = .center
        acStatusLabel.text = "OFF"
        addSubview(acStatusLabel)
       
        chargingLabel = UILabel.init(frame: CGRect.zero)
        chargingLabel.backgroundColor = .clear
        chargingLabel.text = "Charging"
        chargingLabel.font = UIFont.systemFont(ofSize: 11)
        chargingLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        chargingLabel.textAlignment = .center
        addSubview(chargingLabel)
        
        chargingImage = UIImageView()
        chargingImage.contentMode = .scaleAspectFit
        chargingImage.clipsToBounds = true
        chargingImage.image = #imageLiteral(resourceName: "Charging")
        addSubview(chargingImage)
        
        chargingStatusLabel = UILabel.init(frame: CGRect.zero)
        chargingStatusLabel.backgroundColor = .clear
        chargingStatusLabel.font = UIFont.systemFont(ofSize: 11)
        chargingStatusLabel.textColor = .white
        chargingStatusLabel.textAlignment = .center
        chargingStatusLabel.text = "ON"
        addSubview(chargingStatusLabel)
        
       
    }
    
    func addConstraints() -> Void {
        parkingImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
                       make.left.equalToSuperview()
                       make.width.equalToSuperview().dividedBy(4)
                       make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        parkingLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(parkingImage.snp.top).offset(-2)
                       make.width.equalToSuperview().dividedBy(4)
                       make.height.equalToSuperview().multipliedBy(0.3)
                       make.centerX.equalTo(parkingImage)
        }
        
        parkingStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(parkingImage.snp.bottom).offset(2)
            make.centerX.equalTo(parkingImage)
            make.height.width.equalTo(parkingLabel)
        }
        
        doorImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(parkingImage.snp.right)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        doorLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(doorImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(doorImage)
        }
        
        doorStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(doorImage.snp.bottom).offset(2)
            make.centerX.equalTo(doorImage)
            make.height.width.equalTo(doorLabel)
        }
        
        acImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(doorImage.snp.right)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        acLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(acImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(acImage)
        }
        
        acStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(acImage.snp.bottom).offset(2)
            make.centerX.equalTo(acImage)
            make.height.width.equalTo(acLabel)
        }
        
        chargingImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(acImage.snp.right)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        chargingLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(chargingImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(chargingImage)
        }
        
        chargingStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(chargingImage.snp.bottom).offset(2)
            make.centerX.equalTo(chargingImage)
            make.height.width.equalTo(chargingLabel)
        }
    }
    

}

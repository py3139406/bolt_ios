//
//  BottomSheetCollectionViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class BottomSheetViewCell: UIScrollView {
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
    
    var tempLabel: UILabel!
    var tempImage: UIImageView!
    var tempStatusLabel: UILabel!
    
    var batLabel: UILabel!
    var batImage: UIImageView!
    var batStatusLabel: UILabel!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        ignitionImage.layer.cornerRadius = (self.frame.height*0.4)/2
        networkImage.layer.cornerRadius = (self.frame.height*0.4)/2
        geoImage.layer.cornerRadius = (self.frame.height*0.4)/2
        immoImage.layer.cornerRadius = (self.frame.height*0.4)/2
        parkingImage.layer.cornerRadius = (self.frame.height*0.4)/2
        doorImage.layer.cornerRadius = (self.frame.height*0.4)/2
        acImage.layer.cornerRadius = (self.frame.height*0.4)/2
        chargingImage.layer.cornerRadius = (self.frame.height*0.4)/2
        tempImage.layer.cornerRadius = (self.frame.height*0.4)/2
        batImage.layer.cornerRadius = (self.frame.height*0.4)/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
        darkView = UIView(frame: CGRect.zero)
        darkView.backgroundColor = .black//UIColor(red: 29/255, green: 28/255, blue: 41/255, alpha: 1)
        addSubview(darkView)
        
        ignitionLabel = UILabel.init(frame: CGRect.zero)
        ignitionLabel.backgroundColor = .clear
        ignitionLabel.text = "Ignition"
        ignitionLabel.font = UIFont.systemFont(ofSize: 11)
        ignitionLabel.textColor = .white
        ignitionLabel.textAlignment = .center
        addSubview(ignitionLabel)
        
        ignitionImage = UIImageView()
        ignitionImage.contentMode = .scaleAspectFit
        ignitionImage.clipsToBounds = true
        ignitionImage.image = #imageLiteral(resourceName: "removeicon")
        addSubview(ignitionImage)
        
        ignitionStatusLabel = UILabel.init(frame: CGRect.zero)
        ignitionStatusLabel.backgroundColor = .clear
        ignitionStatusLabel.font = UIFont.systemFont(ofSize: 11)
        ignitionStatusLabel.textColor = .white
        ignitionStatusLabel.textAlignment = .center
        ignitionStatusLabel.text = "Camera"
        addSubview(ignitionStatusLabel)
        
        
        networkLabel = UILabel.init(frame: CGRect.zero)
        networkLabel.backgroundColor = .clear
        networkLabel.text = "Network"
        networkLabel.font = UIFont.systemFont(ofSize: 11)
        networkLabel.textColor = .white
        networkLabel.textAlignment = .center
        addSubview(networkLabel)
        
        networkImage = UIImageView()
        networkImage.contentMode = .scaleAspectFit
        networkImage.clipsToBounds = true
        networkImage.image = #imageLiteral(resourceName: "NotConnected")
        addSubview(networkImage)
        
        networkStatusLabel = UILabel.init(frame: CGRect.zero)
        networkStatusLabel.backgroundColor = .clear
        networkStatusLabel.textColor = .white
        networkStatusLabel.textAlignment = .center
        networkStatusLabel.adjustsFontSizeToFitWidth = true
        networkStatusLabel.font = UIFont.systemFont(ofSize: 11)
        networkStatusLabel.text = "DISCONNECTED"
        addSubview(networkStatusLabel)
        
        geoLabel = UILabel.init(frame: CGRect.zero)
        geoLabel.backgroundColor = .clear
        geoLabel.text = "Geofence"
        geoLabel.textColor = .white
        geoLabel.font = UIFont.systemFont(ofSize: 11)
        geoLabel.textAlignment = .center
        addSubview(geoLabel)
        
        geoImage = UIImageView()
        geoImage.contentMode = .scaleAspectFit
        geoImage.clipsToBounds = true
        geoImage.image = #imageLiteral(resourceName: "ac_on")
        addSubview(geoImage)
        
        geoStatusLabel = UILabel.init(frame: CGRect.zero)
        geoStatusLabel.backgroundColor = .clear
        geoStatusLabel.textColor = .white
        geoStatusLabel.font = UIFont.systemFont(ofSize: 11)
        geoStatusLabel.textAlignment = .center
        geoStatusLabel.text = "OUTSIDE"
        addSubview(geoStatusLabel)
        
        immoLabel = UILabel.init(frame: CGRect.zero)
        immoLabel.backgroundColor = .clear
        immoLabel.text = "Immobilizer"
        immoLabel.font = UIFont.systemFont(ofSize: 11)
        immoLabel.textColor = .white
        immoLabel.textAlignment = .center
        addSubview(immoLabel)
        
        immoImage = UIImageView()
        immoImage.contentMode = .scaleAspectFit
        immoImage.clipsToBounds = true
        immoImage.image = #imageLiteral(resourceName: "immobilizeGrey")
        addSubview(immoImage)
        
        immoStatusLabel = UILabel.init(frame: CGRect.zero)
        immoStatusLabel.backgroundColor = .clear
        immoStatusLabel.textColor = .white
        immoStatusLabel.font = UIFont.systemFont(ofSize: 11)
        immoStatusLabel.textAlignment = .center
        immoStatusLabel.text = "OFF"
        addSubview(immoStatusLabel)
        
        parkingLabel = UILabel.init(frame: CGRect.zero)
        parkingLabel.backgroundColor = .clear
        parkingLabel.text = "Parking"
        parkingLabel.font = UIFont.systemFont(ofSize: 11)
        parkingLabel.textColor = .white
        parkingLabel.textAlignment = .center
        addSubview(parkingLabel)
        
        parkingImage = UIImageView()
        parkingImage.contentMode = .scaleAspectFit
        parkingImage.clipsToBounds = true
        parkingImage.image = #imageLiteral(resourceName: "ac_on")
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
        doorLabel.textColor = .white
        doorLabel.textAlignment = .center
        addSubview(doorLabel)
        
        doorImage = UIImageView()
        doorImage.contentMode = .scaleAspectFit
        doorImage.clipsToBounds = true
        doorImage.image = #imageLiteral(resourceName: "door_off")
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
        acLabel.textColor = .white
        acLabel.textAlignment = .center
        addSubview(acLabel)
        
        acImage = UIImageView()
        acImage.contentMode = .scaleAspectFit
        acImage.clipsToBounds = true
        acImage.image = #imageLiteral(resourceName: "ac_off")
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
        chargingLabel.textColor = .white
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
        
        tempLabel = UILabel.init(frame: CGRect.zero)
        tempLabel.backgroundColor = .clear
        tempLabel.text = "Temperature"
        tempLabel.font = UIFont.systemFont(ofSize: 11)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        addSubview(tempLabel)
        
        tempImage = UIImageView()
        tempImage.contentMode = .scaleAspectFit
        tempImage.clipsToBounds = true
        tempImage.image = #imageLiteral(resourceName: "temperature")
        addSubview(tempImage)
        
        tempStatusLabel = UILabel.init(frame: CGRect.zero)
        tempStatusLabel.backgroundColor = .clear
        tempStatusLabel.textColor = .white
        tempStatusLabel.font = UIFont.systemFont(ofSize: 11)
        tempStatusLabel.textAlignment = .center
        tempStatusLabel.text = "N/A"
        addSubview(tempStatusLabel)
        
        
        batLabel = UILabel.init(frame: CGRect.zero)
        batLabel.backgroundColor = .clear
        batLabel.text = "Battery"
        batLabel.font = UIFont.systemFont(ofSize: 11)
        batLabel.textColor = .white
        batLabel.textAlignment = .center
        addSubview(batLabel)
        
        batImage = UIImageView()
        batImage.contentMode = .scaleAspectFit
        batImage.clipsToBounds = true
        batImage.image = #imageLiteral(resourceName: "powercut")
        addSubview(batImage)
        
        batStatusLabel = UILabel.init(frame: CGRect.zero)
        batStatusLabel.backgroundColor = .clear
        batStatusLabel.textColor = .white
        batStatusLabel.font = UIFont.systemFont(ofSize: 11)
        batStatusLabel.textAlignment = .center
        batStatusLabel.text = "N/A"
        addSubview(batStatusLabel)
    }
    
    func addConstraints() -> Void {
        
        ignitionImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        darkView.snp.makeConstraints { (make) in
            make.bottom.equalTo(ignitionImage.snp.top).offset(-5)
            make.width.equalToSuperview().multipliedBy(3)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
        ignitionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(ignitionImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(ignitionImage)
        }

        ignitionStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ignitionImage.snp.bottom).offset(2)
            make.centerX.equalTo(ignitionImage)
            make.height.width.equalTo(ignitionLabel)
        }
        
        networkImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(ignitionImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        networkLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(networkImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(networkImage)
        }
        
        networkStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(networkImage.snp.bottom).offset(2)
            make.centerX.equalTo(networkImage)
            make.height.width.equalTo(networkLabel)
        }
        
        geoImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(networkImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        geoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(geoImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(geoImage)
        }
        
        geoStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(geoImage.snp.bottom).offset(2)
            make.centerX.equalTo(geoImage)
            make.height.width.equalTo(geoLabel)
        }
        
        immoImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(geoImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        immoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(immoImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(immoImage)
        }
        
        immoStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(immoImage.snp.bottom).offset(2)
            make.centerX.equalTo(immoImage)
            make.height.width.equalTo(immoLabel)
        }
        
        parkingImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(immoImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        parkingLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(parkingImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
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
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        doorLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(doorImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
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
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        acLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(acImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
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
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        chargingLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(chargingImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(chargingImage)
        }
        
        chargingStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(chargingImage.snp.bottom).offset(2)
            make.centerX.equalTo(chargingImage)
            make.height.width.equalTo(chargingLabel)
        }
        
        tempImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(chargingImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        tempLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tempImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(tempImage)
        }
        
        tempStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tempImage.snp.bottom).offset(2)
            make.centerX.equalTo(tempImage)
            make.height.width.equalTo(tempLabel)
        }
        
        batImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(tempImage.snp.right)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        batLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(batImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(batImage)
        }
        
        batStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(batImage.snp.bottom).offset(2)
            make.centerX.equalTo(batImage)
            make.height.width.equalTo(batLabel)
        }
        
        
    }
    
    
}

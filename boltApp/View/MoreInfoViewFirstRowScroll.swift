//
//  MoreInfoViewFirstRowScroll.swift
//  Bolt
//
//  Created by Vivek Kumar on 30/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class MoreInfoViewFirstRowScroll: UIScrollView {
 
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        ignitionImage.layer.cornerRadius = (self.frame.height*0.4)/2
        networkImage.layer.cornerRadius = (self.frame.height*0.4)/2
        geoImage.layer.cornerRadius = (self.frame.height*0.4)/2
        immoImage.layer.cornerRadius = (self.frame.height*0.4)/2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
        
        
        ignitionLabel = UILabel.init(frame: CGRect.zero)
        ignitionLabel.backgroundColor = .clear
        ignitionLabel.text = "Ignition"
        ignitionLabel.font = UIFont.systemFont(ofSize: 11)
        ignitionLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        ignitionLabel.textAlignment = .center
        addSubview(ignitionLabel)
        
        ignitionImage = UIImageView()
        ignitionImage.contentMode = .scaleAspectFit
        ignitionImage.clipsToBounds = true
        ignitionImage.image = #imageLiteral(resourceName: "ignoff")
        addSubview(ignitionImage)
        
        ignitionStatusLabel = UILabel.init(frame: CGRect.zero)
        ignitionStatusLabel.backgroundColor = .clear
        ignitionStatusLabel.font = UIFont.systemFont(ofSize: 11)
        ignitionStatusLabel.textColor = .white
        ignitionStatusLabel.textAlignment = .center
        ignitionStatusLabel.text = "OFF"
        addSubview(ignitionStatusLabel)
        
        
        networkLabel = UILabel.init(frame: CGRect.zero)
        networkLabel.backgroundColor = .clear
        networkLabel.text = "Network"
        networkLabel.font = UIFont.systemFont(ofSize: 11)
        networkLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        networkLabel.textAlignment = .center
        addSubview(networkLabel)
        
        networkImage = UIImageView()
        networkImage.contentMode = .scaleAspectFit
        networkImage.clipsToBounds = true
        networkImage.image = #imageLiteral(resourceName: "netoff")
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
        geoLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        geoLabel.font = UIFont.systemFont(ofSize: 11)
        geoLabel.textAlignment = .center
        addSubview(geoLabel)
        
        geoImage = UIImageView()
        geoImage.contentMode = .scaleAspectFit
        geoImage.clipsToBounds = true
        geoImage.image = #imageLiteral(resourceName: "geoout")
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
        immoLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
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
        
        
    }
    
    func addConstraints() -> Void {
        
        ignitionImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        ignitionLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(ignitionImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
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
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        networkLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(networkImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
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
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        geoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(geoImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
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
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        immoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(immoImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(immoImage)
        }
        
        immoStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(immoImage.snp.bottom).offset(2)
            make.centerX.equalTo(immoImage)
            make.height.width.equalTo(immoLabel)
        }
        
        
        
    }
    
    
}

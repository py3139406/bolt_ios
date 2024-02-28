//
//  BottomSheetStatusViewCell.swift
//  Bolt
//
//  Created by Roadcast on 09/12/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class BottomSheetStatusViewCell: UIScrollView {
    
      var darkView: UIView!
    
      var stepsLabel: UILabel!
      var stepsImage: UIImageView!
      var stepscountLabel: UILabel!
      
      var statusLabel: UILabel!
      var statusImage: UIImageView!
      var workingStatusLabel: UILabel!
      
      var geoLabel: UILabel!
      var geoImage: UIImageView!
      var geoStatusLabel: UILabel!
      
      var networkLabel: UILabel!
      var networkImage: UIImageView!
      var networkStatusLabel: UILabel!
      
      var batteryLabel: UILabel!
      var batteryImage: UIImageView!
      var batteryStatusLabel: UILabel!
      
      
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          addViews()
          addConstraints()
          stepsImage.layer.cornerRadius = (self.frame.height*0.4)/2
          statusImage.layer.cornerRadius = (self.frame.height*0.4)/2
          geoImage.layer.cornerRadius = (self.frame.height*0.4)/2
          networkImage.layer.cornerRadius = (self.frame.height*0.4)/2
          batteryImage.layer.cornerRadius = (self.frame.height*0.4)/2
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      func addViews() -> Void {
          darkView = UIView(frame: CGRect.zero)
          darkView.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 41/255, alpha: 1)
        addSubview(darkView)
          
          stepsLabel = UILabel.init(frame: CGRect.zero)
          stepsLabel.backgroundColor = .clear
          stepsLabel.text = "Steps"
          stepsLabel.font = UIFont.systemFont(ofSize: 11)
          stepsLabel.textColor = .white
          stepsLabel.textAlignment = .center
        addSubview(stepsLabel)
          
          stepsImage = UIImageView()
          stepsImage.contentMode = .scaleAspectFit
          stepsImage.clipsToBounds = true
          stepsImage.image = #imageLiteral(resourceName: "Asset 130")
        addSubview(stepsImage)
          
          stepscountLabel = UILabel.init(frame: CGRect.zero)
          stepscountLabel.backgroundColor = .clear
          stepscountLabel.font = UIFont.systemFont(ofSize: 11)
          stepscountLabel.textColor = .white
          stepscountLabel.textAlignment = .center
          stepscountLabel.text = "0"
        addSubview(stepscountLabel)
          
          
          statusLabel = UILabel.init(frame: CGRect.zero)
          statusLabel.backgroundColor = .clear
          statusLabel.text = "Status"
          statusLabel.font = UIFont.systemFont(ofSize: 11)
          statusLabel.textColor = .white
          statusLabel.textAlignment = .center
        addSubview(statusLabel)
          
          statusImage = UIImageView()
          statusImage.contentMode = .scaleAspectFit
          statusImage.clipsToBounds = true
          statusImage.image = #imageLiteral(resourceName: "greenNotification")
        addSubview(statusImage)
          
          workingStatusLabel = UILabel.init(frame: CGRect.zero)
          workingStatusLabel.backgroundColor = .clear
          workingStatusLabel.textColor = .white
          workingStatusLabel.textAlignment = .center
          workingStatusLabel.adjustsFontSizeToFitWidth = true
          workingStatusLabel.font = UIFont.systemFont(ofSize: 11)
          workingStatusLabel.text = "ONLINE"
        addSubview(workingStatusLabel)
          
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
          geoStatusLabel.text = "IN"
        addSubview(geoStatusLabel)
          
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
          networkImage.image = #imageLiteral(resourceName: "geofenceicon")
      addSubview(networkImage)
          
          networkStatusLabel = UILabel.init(frame: CGRect.zero)
          networkStatusLabel.backgroundColor = .clear
          networkStatusLabel.textColor = .white
          networkStatusLabel.font = UIFont.systemFont(ofSize: 11)
          networkStatusLabel.textAlignment = .center
          networkStatusLabel.text = "CONNECTED"
        addSubview(networkStatusLabel)
          
                   
          batteryLabel = UILabel.init(frame: CGRect.zero)
          batteryLabel.backgroundColor = .clear
          batteryLabel.text = "Battery"
          batteryLabel.font = UIFont.systemFont(ofSize: 11)
          batteryLabel.textColor = .white
          batteryLabel.textAlignment = .center
        addSubview(batteryLabel)
          
          batteryImage = UIImageView()
          batteryImage.contentMode = .scaleAspectFit
          batteryImage.clipsToBounds = true
          batteryImage.image = #imageLiteral(resourceName: "FullBattery")
        addSubview(batteryImage)
          
          batteryStatusLabel = UILabel.init(frame: CGRect.zero)
          batteryStatusLabel.backgroundColor = .clear
          batteryStatusLabel.textColor = .white
          batteryStatusLabel.font = UIFont.systemFont(ofSize: 11)
          batteryStatusLabel.textAlignment = .center
          batteryStatusLabel.text = "100%"
        addSubview(batteryStatusLabel)
      }
      
      func addConstraints() -> Void {
          
          stepsImage.snp.makeConstraints { (make) in
              make.centerY.equalToSuperview()
              make.left.equalToSuperview()
              make.width.equalToSuperview().dividedBy(5)
              make.height.equalToSuperview().multipliedBy(0.4)
          }
          
          darkView.snp.makeConstraints { (make) in
              make.bottom.equalTo(stepsImage.snp.top).offset(-5)
              make.width.equalToSuperview()
              make.top.equalToSuperview()
              make.centerX.equalToSuperview()
              
          }
          
          stepsLabel.snp.makeConstraints { (make) in
              make.bottom.equalTo(stepsImage.snp.top).offset(-2)
              make.width.equalToSuperview().dividedBy(5)
              make.height.equalToSuperview().multipliedBy(0.3)
              make.centerX.equalTo(stepsImage)
          }

          stepscountLabel.snp.makeConstraints { (make) in
              make.top.equalTo(stepsImage.snp.bottom).offset(2)
              make.centerX.equalTo(stepsImage)
              make.height.width.equalTo(stepsLabel)
          }
          
          statusImage.snp.makeConstraints { (make) in
              make.centerY.equalToSuperview()
              make.left.equalTo(stepsImage.snp.right)
              make.width.equalToSuperview().dividedBy(5)
              make.height.equalToSuperview().multipliedBy(0.4)
          }
          
          statusLabel.snp.makeConstraints { (make) in
              make.bottom.equalTo(statusImage.snp.top).offset(-2)
              make.width.equalToSuperview().dividedBy(5)
              make.height.equalToSuperview().multipliedBy(0.3)
              make.centerX.equalTo(statusImage)
          }
          
          workingStatusLabel.snp.makeConstraints { (make) in
              make.top.equalTo(statusImage.snp.bottom).offset(2)
              make.centerX.equalTo(statusImage)
              make.height.width.equalTo(statusLabel)
          }
          
          geoImage.snp.makeConstraints { (make) in
              make.centerY.equalToSuperview()
              make.left.equalTo(statusImage.snp.right)
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
          
          networkImage.snp.makeConstraints { (make) in
              make.centerY.equalToSuperview()
              make.left.equalTo(geoImage.snp.right)
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
          
          
          batteryImage.snp.makeConstraints { (make) in
              make.centerY.equalToSuperview()
              make.left.equalTo(networkImage.snp.right)
              make.width.equalToSuperview().dividedBy(5)
              make.height.equalToSuperview().multipliedBy(0.4)
          }
          
          batteryLabel.snp.makeConstraints { (make) in
              make.bottom.equalTo(batteryImage.snp.top).offset(-2)
              make.width.equalToSuperview().dividedBy(5)
              make.height.equalToSuperview().multipliedBy(0.3)
              make.centerX.equalTo(batteryImage)
          }
          
          batteryStatusLabel.snp.makeConstraints { (make) in
              make.top.equalTo(batteryImage.snp.bottom).offset(2)
              make.centerX.equalTo(batteryImage)
              make.height.width.equalTo(batteryLabel)
          }
          
          
      }
      
      
  }


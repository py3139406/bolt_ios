//
//  TrackerDetailsView.swift
//  Bolt
//
//  Created by Arshad Ali on 15/12/17.
//  Copyright © 2017 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class TrackerDetailsView: UIView {

    var topLabel: UILabel!
    var trackerName: UILabel!
    var lastUpdatedLabel: UILabel!
    var speedLabel: UILabel!
    var addressLabel: UILabel!
    
    var showTrackerName: UILabel!
    var showLastUpdatLabel: UILabel!
    var showSpeedLabel: UILabel!
    var showAddressLabel: UILabel!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        addConstrants()
        
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addLabel(){
        
        // titles on label
        topLabel = UILabel(frame: CGRect.zero)
        topLabel.backgroundColor =  UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        topLabel.textColor = .white
        topLabel.text = "TRACKER DETAILS"
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        addSubview(topLabel)
        
        trackerName = UILabel(frame: CGRect.zero)
        trackerName.textColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        trackerName.text = "Tracker name"
        trackerName.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        addSubview(trackerName)
        
        lastUpdatedLabel = UILabel(frame: CGRect.zero)
        lastUpdatedLabel.textColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        lastUpdatedLabel.text = "Last Updated"
        lastUpdatedLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        addSubview(lastUpdatedLabel)
        
        speedLabel = UILabel(frame: CGRect.zero)
        speedLabel.textColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        speedLabel.text = "Speed"
        speedLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        addSubview(speedLabel)
        
        addressLabel = UILabel(frame: CGRect.zero)
        addressLabel.textColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        addressLabel.text = "Address"
         addressLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        addSubview(addressLabel)
        
        //label with dynamic text
        
        showTrackerName = UILabel(frame: CGRect.zero)
        showTrackerName.textColor = .black
        showTrackerName.text = "Creta 4112"
        showTrackerName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        addSubview(showTrackerName)
        
        showLastUpdatLabel = UILabel(frame: CGRect.zero)
        showLastUpdatLabel.textColor = .black
        showLastUpdatLabel.text = "15-12-2017 05:55 pm"
        showLastUpdatLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        addSubview(showLastUpdatLabel)
        
        showSpeedLabel = UILabel(frame: CGRect.zero)
        showSpeedLabel.textColor = .black
        showSpeedLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        showSpeedLabel.text = "0 kmph"
        addSubview(showSpeedLabel)
        
        showAddressLabel = UILabel(frame: CGRect.zero)
        showAddressLabel.textColor = .black
        showAddressLabel.text = "13-14,Yamuna Path,Patel Nagar Greejgarh Vihar Colony,Bais Godam,Jaipur,Rajasthan 302006,India,null,null"
        showAddressLabel.numberOfLines = 0
        showAddressLabel.adjustsFontSizeToFitWidth = true
        showAddressLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        addSubview(showAddressLabel)
        
    }
    
    func addConstrants(){
        topLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        trackerName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(topLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.70)
        }
        
        showTrackerName.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(trackerName.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.90)
        }
        
        lastUpdatedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(showTrackerName.snp.bottom).offset(8)
            make.height.equalTo(trackerName)
            make.width.equalTo(trackerName)
        }
        
        showLastUpdatLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(lastUpdatedLabel.snp.bottom).offset(5)
            make.height.width.equalTo(showTrackerName)
        }
        
        speedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(showLastUpdatLabel.snp.bottom).offset(8)
            make.height.width.equalTo(trackerName)
            
        }
        
        showSpeedLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(speedLabel.snp.bottom).offset(5)
            make.height.width.equalTo(showTrackerName)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(showSpeedLabel.snp.bottom).offset(8)
            make.height.width.equalTo(trackerName)
            
        }
        
        showAddressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(trackerName)
            make.top.equalTo(addressLabel.snp.bottom)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
    }
}

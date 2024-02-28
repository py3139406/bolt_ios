//
//  BottomSheetWatch.swift
//  Bolt
//
//  Created by Roadcast on 04/12/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class BottomSheetWatchView: UIView {

    var newfeatureScroll: BottomSheetWatchCell!
    var statusScroll : BottomSheetStatusViewCell!
    var locationView: UIView!
    var locationImage: UIImageView!
    var locationLabel: UILabel!
    var back: UIView!
    var tripD: DetailedLabel!
    var tripDuration: DetailedLabel!
    var numberofStops: DetailedLabel!
    var idleTime: DetailedLabel!
    var maxSpeed: DetailedLabel!
    var totalDistance: DetailedLabel!
    
    var odoLableHeader: UILabel!
    var odoImage: UIImageView!
    var odoValueLabel: UILabel!
    var odoValueUnit: UILabel!
    
    var speedLableHeader: UILabel!
    var speedImage: UIImageView!
    var speedValueLabel: UILabel!
    var speedValueUnit: UILabel!
    
    var fuelLableHeader: UILabel!
    var fuelImage: UIImageView!
    var fuelValueLabel: UILabel!
    var fuelValueUnit: UILabel!
    
    var lineView: UIView!
    var line1View: UIView!
    var line2View: UIView!
    var darkView: UIView!
    var lastUpdateLabel: UILabel!
    
    var setalarmView : UIView!
    var setalarmLabel : UILabel!
    var setalarmImage: UIImageView!
    var timeLabel: UITextField!
    var timeButton : UIButton!
    
    var realtimecaremodeView : UIView!
    var realtimecaremodeLabel: UILabel!
    var realtimecaremodeImage: UIImageView!
    var realtimeenableLabel: UILabel!
    var realtimeButton: UIButton!
    
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        backgroundColor = .black//UIColor(red: 40/255, green: 38/255, blue: 57/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        newfeatureScroll = BottomSheetWatchCell(frame: CGRect.zero)
        newfeatureScroll.setContentOffset(
            CGPoint(x: 0,y: -self.newfeatureScroll.contentInset.top),
            animated: true)
        //newfeatureScroll.backgroundColor = appDarkTheme
        newfeatureScroll.alwaysBounceHorizontal = false
        newfeatureScroll.contentMode = .right
        newfeatureScroll.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 0.2)
        newfeatureScroll.showsHorizontalScrollIndicator = false
        addSubview(newfeatureScroll)
        

        lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = .white
        addSubview(lineView)
        
        line1View = UIView(frame: CGRect.zero)
        line1View.backgroundColor = .clear
        addSubview(line1View)
        
        line2View = UIView(frame: CGRect.zero)
        line2View.backgroundColor = .white
        addSubview(line2View)
        
        darkView = UIView(frame: CGRect.zero)
        darkView.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 41/255, alpha: 1)
        addSubview(darkView)
        
        setalarmView = UIView(frame: CGRect.zero)
        setalarmView.backgroundColor = .black//UIColor(red: 37/255, green: 38/255, blue: 56/255, alpha: 1)
        addSubview(setalarmView)
        
        setalarmImage = UIImageView(frame: CGRect.zero)
        setalarmImage.image = UIImage(named: "Alarm")
        setalarmView.addSubview(setalarmImage)
        
        setalarmLabel = UILabel(frame: CGRect.zero)
        setalarmLabel.text = "SET ALARM"
        setalarmLabel.textColor = .white
        setalarmLabel.font = UIFont.systemFont(ofSize: 14)
        setalarmView.addSubview(setalarmLabel)
        
        timeLabel = UITextField(frame: CGRect.zero)
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
       
        timeLabel.text = "\(hour):\(minutes)"
        timeLabel.textColor = .white
        setalarmView.addSubview(timeLabel)
        
        timeButton = UIButton(frame: CGRect.zero)
        timeButton.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
        setalarmView.addSubview(timeButton)
        
        
        
        realtimecaremodeView = UIView(frame: CGRect.zero)
        realtimecaremodeView.backgroundColor = .black//UIColor(red: 37/255, green: 38/255, blue: 56/255, alpha: 1)
        addSubview(realtimecaremodeView)
               
        realtimecaremodeImage = UIImageView(frame: CGRect.zero)
        realtimecaremodeImage.image = UIImage(named: "CareMode")
        realtimecaremodeView.addSubview(realtimecaremodeImage)
        
               
        realtimecaremodeLabel = UILabel(frame: CGRect.zero)
        realtimecaremodeLabel.text = "REAL-TIME CARE MODE"
        realtimecaremodeLabel.textColor = .white
        realtimecaremodeLabel.font = UIFont.systemFont(ofSize: 12)
        realtimecaremodeLabel.adjustsFontSizeToFitWidth = true
        realtimecaremodeView.addSubview(realtimecaremodeLabel)
               
        realtimeenableLabel = UILabel(frame: CGRect.zero)
        realtimeenableLabel.text = "ENABLED"
        //realtimeenableLabel.font = UIFont.systemFont(ofSize: 15)
        realtimeenableLabel.textColor = .white
        realtimecaremodeView.addSubview(realtimeenableLabel)
               
        realtimeButton = UIButton(frame: CGRect.zero)
        realtimeButton.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
        realtimeButton.isUserInteractionEnabled = true
        realtimecaremodeView.addSubview(realtimeButton)
        
        statusScroll = BottomSheetStatusViewCell(frame: CGRect.zero)
               statusScroll.setContentOffset(
                   CGPoint(x: 0,y: -self.statusScroll.contentInset.top),
                   animated: true)
        statusScroll.backgroundColor = .black//UIColor(red: 40/255, green: 38/255, blue: 57/255, alpha: 1)
               statusScroll.alwaysBounceHorizontal = false
               statusScroll.contentMode = .right
               statusScroll.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 0.2)
               statusScroll.showsHorizontalScrollIndicator = false
               addSubview(statusScroll)
        
        
        locationView = UIView(frame: CGRect.zero)
        locationView.backgroundColor = .black//UIColor(red: 40/255, green: 38/255, blue: 57/255, alpha: 1)
        addSubview(locationView)
        
        locationImage = UIImageView(frame: CGRect.zero)
        locationImage.image = #imageLiteral(resourceName: "mapWhite")
        locationImage.backgroundColor = .clear
        locationImage.contentMode = .scaleAspectFit
        locationView.addSubview(locationImage)

        locationLabel = UILabel(frame: CGRect.zero)
        locationLabel.text = "Address not available"
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.numberOfLines = 3
        locationLabel.textAlignment = .left
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.font = UIFont.boldSystemFont(ofSize: 12)
        locationLabel.textColor = .white
        locationView.addSubview(locationLabel)
            
        lastUpdateLabel = UILabel(frame: CGRect.zero)
        lastUpdateLabel.text = "Last update: 0 Mins ago"
        lastUpdateLabel.textColor = .white
        lastUpdateLabel.textAlignment = .center
        lastUpdateLabel.backgroundColor = .clear
        lastUpdateLabel.font = UIFont.italicSystemFont(ofSize: 10)
        darkView.addSubview(lastUpdateLabel)
        
        
        
        
//        back = UIView(frame: CGRect.zero)
//        back.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 41/255, alpha: 1)
//        addSubview(back)
//
       
        
    }
    
    func addConstraints() -> Void {
        newfeatureScroll.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
        }
        
        setalarmView.snp.makeConstraints { (make) in
            make.top.equalTo(newfeatureScroll.snp.bottom)
            make.width.equalTo(0.495 * kscreenwidth)
            make.height.equalTo(0.14 * kscreenheight)
            make.left.equalToSuperview()
        }
        setalarmImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.014 * kscreenheight)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.07 * kscreenwidth)
            make.height.equalTo(0.04 * kscreenheight)
        }
        setalarmLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setalarmImage.snp.bottom).offset(0.005 * kscreenheight)
            make.centerX.equalToSuperview()
//            make.width.equalTo(0.04 * kscreenwidth)
//            make.height.equalTo(0.04 * kscreenheight)
        }
        
        
         timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(setalarmLabel.snp.bottom).offset(0.011 * kscreenheight)
            make.left.equalToSuperview().offset(0.04 * kscreenwidth)
        //            make.width.equalTo(0.04 * kscreenwidth)
        //            make.height.equalTo(0.04 * kscreenheight)
                }
        timeButton.snp.makeConstraints{(make) in
            make.top.equalTo(setalarmLabel.snp.bottom).offset(0.011 * kscreenheight)
            make.height.equalTo(0.03 * kscreenheight)
            make.width.equalTo(0.1 * kscreenwidth)
            make.left.equalTo(timeLabel.snp.right).offset(0.1 * kscreenwidth)
        }
        
        
       realtimecaremodeView.snp.makeConstraints { (make) in
                   make.top.equalTo(newfeatureScroll.snp.bottom)
                   make.width.equalTo(0.5 * kscreenwidth)
                   make.height.equalTo(0.14 * kscreenheight)
                   make.right.equalToSuperview()
               }
               realtimecaremodeImage.snp.makeConstraints { (make) in
                   make.top.equalToSuperview().offset(0.014 * kscreenheight)
                   make.centerX.equalToSuperview()
                   make.width.equalTo(0.07 * kscreenwidth)
                   make.height.equalTo(0.04 * kscreenheight)
               }
               realtimecaremodeLabel.snp.makeConstraints { (make) in
                   make.top.equalTo(realtimecaremodeImage.snp.bottom).offset(0.005 * kscreenheight)
                   make.centerX.equalToSuperview()
                   make.width.equalTo(0.4 * kscreenwidth)
       //            make.width.equalTo(0.04 * kscreenwidth)
       //            make.height.equalTo(0.04 * kscreenheight)
               }
               
               
                realtimeenableLabel.snp.makeConstraints { (make) in
                   make.top.equalTo(realtimecaremodeLabel.snp.bottom).offset(0.012 * kscreenheight)
                   make.left.equalToSuperview().offset(0.04 * kscreenwidth)
               //            make.width.equalTo(0.04 * kscreenwidth)
               //            make.height.equalTo(0.04 * kscreenheight)
                       }
               realtimeButton.snp.makeConstraints{(make) in
                   make.top.equalTo(realtimecaremodeLabel.snp.bottom).offset(0.012 * kscreenheight)
                   make.height.equalTo(0.03 * kscreenheight)
                   make.width.equalTo(0.1 * kscreenwidth)
                   make.left.equalTo(realtimeenableLabel.snp.right).offset(0.1 * kscreenwidth)
               }
        
        line1View.snp.makeConstraints { (make) in
            make.top.equalTo(realtimecaremodeView.snp.bottom).offset(2)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.001)
            make.centerX.equalToSuperview()
        }
        statusScroll.snp.makeConstraints { (make) in
            make.top.equalTo(line1View.snp.bottom).offset(0.001 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
        }
        
        
        locationView.snp.makeConstraints{(make) in
            make.top.equalTo(statusScroll.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.13)
        }
        
        
        locationImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.025 * kscreenheight)
            make.left.equalToSuperview().offset(15)
           make.width.equalTo(0.07 * kscreenwidth)
           make.height.equalTo(0.04 * kscreenheight)
        }
        locationLabel.snp.makeConstraints { (make) in
             make.top.equalToSuperview().offset(0.027 * kscreenheight)
            make.left.equalTo(locationImage.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
           // make.height.equalToSuperview().multipliedBy(0.1)
            
        }
        
        darkView.snp.makeConstraints { (make) in
            make.top.equalTo(locationView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.07)
            make.centerX.equalToSuperview()
        }
        
        lastUpdateLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
            make.centerX.equalTo(darkView.snp.centerX)
            //make.top.equalTo(locationImage.snp.bottom)
        }
        
        
        
    }
    
}

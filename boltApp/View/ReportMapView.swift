//
//  ReportMapView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class ReportMapView: UIView {
    
   // var containerView:UIView?
    var mapView:RCMainMap!
    var changeMapTypeBtn: UIButton!
    var changeMapTypelbl: UILabel!
    var optionButton: UIButton!
    var stopsBtn: UIButton!
    var stopslbl: UILabel!
    var directionBtn: UIButton!
    var directionlbl: UILabel!
    // speedview:-
    var replayspeed:UILabel!
    var speedsMeterView: UIView!
    var speedoMeterImageView: UIImageView!
    var speedoMeterLabel: UILabel!
    var showSpeedLabel: UILabel!
    var playLeftButton: UIButton!
    var playRightButton : UIButton!
    // status labels:-
    var upperView: UIView!
    var vehiclenameLabel: UILabel!
    var currentLabel: UILabel!
    var currentkmLabel: UILabel!
    var dateLabel: UILabel!
    var datecalenderLabel : UILabel!
    
    var speed:String = ""
    var lineview:UIView!
    var timeSlider: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        addSpeedoMeterView()
        addupperview()
        addOptionButton()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addOptionButton() {
        optionButton =  UIButton(frame: CGRect.zero)
        optionButton.layer.cornerRadius = 27.5
        optionButton.showsTouchWhenHighlighted = true
        optionButton.layer.shadowColor = UIColor.black.cgColor
        optionButton.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        optionButton.layer.shadowRadius = 1.0
        optionButton.layer.shadowOpacity = 0.6
        optionButton.setImage(#imageLiteral(resourceName: "Asset 147-1"), for:.normal)
        addSubview(optionButton)
        
        changeMapTypeBtn =  UIButton(frame: CGRect.zero)
        changeMapTypeBtn.showsTouchWhenHighlighted = true
        changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for:.normal)
        changeMapTypeBtn.isHidden = true
        addSubview(changeMapTypeBtn)
        
        changeMapTypelbl = RCLabel(frame: CGRect.zero)
        changeMapTypelbl.text = "Satellite Map".toLocalize
        changeMapTypelbl.adjustsFontSizeToFitWidth = true
        changeMapTypelbl.textAlignment = .center
        changeMapTypelbl.layer.cornerRadius = 5.0
        changeMapTypelbl.backgroundColor = blackLabelColor
        changeMapTypelbl.textColor = .white
        changeMapTypelbl.isHidden = true
        addSubview(changeMapTypelbl)
        
        stopsBtn =  UIButton(frame: CGRect.zero)
        stopsBtn.showsTouchWhenHighlighted = true
        stopsBtn.setImage(#imageLiteral(resourceName: "Asset 94"), for:.normal)
        stopsBtn.isHidden = true
        addSubview(stopsBtn)
        
        stopslbl = RCLabel(frame: CGRect.zero)
        stopslbl.text = "Hide Stops".toLocalize
        stopslbl.adjustsFontSizeToFitWidth = true
        stopslbl.textAlignment = .center
        stopslbl.layer.cornerRadius = 5.0
        stopslbl.backgroundColor = blackLabelColor
        stopslbl.textColor = .white
        stopslbl.isHidden = true
        addSubview(stopslbl)
        
        directionBtn =  UIButton(frame: CGRect.zero)
        directionBtn.showsTouchWhenHighlighted = true
        directionBtn.setImage(#imageLiteral(resourceName: "Asset 93"), for:.normal)
        directionBtn.isHidden = true
        addSubview(directionBtn)
        
        directionlbl = RCLabel(frame: CGRect.zero)
        directionlbl.text = "Hide Directions".toLocalize
        directionlbl.adjustsFontSizeToFitWidth = true
        directionlbl.textAlignment = .center
        directionlbl.layer.cornerRadius = 5.0
        directionlbl.backgroundColor = blackLabelColor
        directionlbl.textColor = .white
        directionlbl.isHidden = true
        addSubview(directionlbl)
        
        
    }
    
    func addViews() -> Void {
        mapView = RCMainMap(frame: CGRect.zero)
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 5)
        addSubview(mapView)
        
        
    }
    func addSpeedoMeterView(){
      speedsMeterView = UIView(frame:CGRect.zero)
      speedsMeterView.backgroundColor = appDarkTheme
      speedsMeterView.layer.borderColor = appGreenTheme.cgColor
      addSubview(speedsMeterView)
      
      replayspeed = UILabel(frame: CGRect.zero)
      replayspeed.text = "1x"
      replayspeed.textColor = .white
      replayspeed.font = UIFont.systemFont(ofSize: 18.0)
      speedsMeterView.addSubview(replayspeed)
      
      
      speedoMeterImageView = UIImageView(frame: CGRect.zero)
      speedoMeterImageView.image = #imageLiteral(resourceName: "1").resizedImage(CGSize(width: 40, height: 40), interpolationQuality: .default)
      speedsMeterView.addSubview(speedoMeterImageView)
      
      showSpeedLabel = UILabel(frame: CGRect.zero)
      showSpeedLabel.backgroundColor = .clear
      showSpeedLabel.text = "0"
      showSpeedLabel.textAlignment = .center
      showSpeedLabel.font = UIFont.boldSystemFont(ofSize: 18)
      showSpeedLabel.textColor = .white
      speedsMeterView.addSubview(showSpeedLabel)
      
      playLeftButton = UIButton(frame: CGRect.zero)
      playLeftButton.setImage(#imageLiteral(resourceName: "singlePlayicon"), for: .normal)
      playLeftButton.isUserInteractionEnabled = true
      playLeftButton.imageView?.contentMode = .scaleAspectFit
      speedsMeterView.addSubview(playLeftButton)
      
      
      playRightButton = UIButton(frame: CGRect.zero)
      playRightButton.setImage(UIImage(named: "speedoright"), for: .normal)
      playRightButton.isUserInteractionEnabled = true
      playRightButton.imageView?.contentMode = .scaleAspectFit
      speedsMeterView.addSubview(playRightButton)
      
      timeSlider = UISlider(frame: CGRect.zero)
      timeSlider.minimumValue = 0
      timeSlider.isContinuous = true
      timeSlider.setThumbImage(UIImage(named: "arrow3")?.resizedImage(CGSize.init(width: 15.0, height: 15.0), interpolationQuality: .default), for: .normal)
      
      timeSlider.tintColor = appGreenTheme
      speedsMeterView.addSubview(timeSlider)
    }
    func addupperview(){
      upperView = UIView(frame: CGRect.zero)
      upperView.backgroundColor = UIColor.black
      addSubview(upperView)
      
      vehiclenameLabel = UILabel(frame: CGRect.zero)
     // vehiclenameLabel.text = "dhjsdsjsh"
      vehiclenameLabel.numberOfLines = 3
      vehiclenameLabel.font = UIFont.systemFont(ofSize: 15.0)
      vehiclenameLabel.adjustsFontSizeToFitWidth = true
      vehiclenameLabel.textColor = .white
      upperView.addSubview(vehiclenameLabel)
      
      
      currentLabel = UILabel(frame: CGRect.zero)
      currentLabel.text = "CURRENT"
      currentLabel.adjustsFontSizeToFitWidth = true
      currentLabel.textColor = .white
      upperView.addSubview(currentLabel)
      
      currentkmLabel = UILabel(frame: CGRect.zero)
      currentkmLabel.text = "0.0KM"
      currentkmLabel.numberOfLines = 2
      currentkmLabel.font = UIFont.systemFont(ofSize: 13.0)
      currentkmLabel.textAlignment = .center
      currentkmLabel.textColor = .white
      upperView.addSubview(currentkmLabel)
      
      dateLabel = UILabel(frame: CGRect.zero)
      dateLabel.text = ""
      dateLabel.adjustsFontSizeToFitWidth = true
      dateLabel.textColor = appGreenTheme
      upperView.addSubview(dateLabel)
      
      datecalenderLabel = UILabel(frame: CGRect.zero)
      datecalenderLabel.text = ""
      datecalenderLabel.font = UIFont.systemFont(ofSize: 14.0)
      datecalenderLabel.adjustsFontSizeToFitWidth = true
      datecalenderLabel.textColor = .white
      upperView.addSubview(datecalenderLabel)
      
      lineview = UIView(frame: CGRect.zero)
      lineview.backgroundColor = appGreenTheme
      upperView.addSubview(lineview)
    }
    
    
    func addConstraints() -> Void {
        mapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(upperView.snp.top)
        }
        speedsMeterView.snp.makeConstraints { (make) in
            make.width.equalTo(kscreenwidth)
            make.height.equalTo(0.1 * kscreenheight)
            make.bottom.equalToSuperview()
        }
        
        replayspeed.snp.makeConstraints { (make) in
            make.right.equalTo(-0.06 * kscreenwidth)
            make.centerY.equalToSuperview()
        }
        
        speedoMeterImageView.snp.makeConstraints { (make) in
            make.left.equalTo(0.05 * kscreenwidth)
            make.centerY.equalToSuperview()
        }
        
        
        playLeftButton.snp.makeConstraints { (make) in
            make.right.equalTo(playRightButton.snp.left).offset(-0.04 * kscreenwidth)
            make.centerY.equalToSuperview()
            make.width.equalTo(0.1 * kscreenwidth)
            make.height.equalTo(0.1 * kscreenheight)
        }
        
        playRightButton.snp.makeConstraints { (make) in
            make.right.equalTo(replayspeed.snp.left).offset(-0.04 * kscreenwidth)
            make.centerY.equalToSuperview()
            make.width.equalTo(0.1 * kscreenwidth)
            make.height.equalTo(0.1 * kscreenheight)
            
        }
        
        showSpeedLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(speedoMeterImageView)
            make.centerY.equalTo(speedoMeterImageView)
            make.width.equalTo(speedoMeterImageView).multipliedBy(0.55)
            make.height.equalTo(speedoMeterImageView).multipliedBy(0.55)
        }
        
        timeSlider.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(0.3 * kscreenwidth)
            make.height.equalTo(0.03 * kscreenheight)
            make.left.equalTo(speedoMeterImageView.snp.right).offset(0.04 * kscreenwidth)
        }
        
        upperView.snp.makeConstraints{(make)in
            make.bottom.equalTo(speedsMeterView.snp.top).offset(-kscreenheight * 0.000)
            make.width.equalToSuperview()
            make.height.equalTo(0.10 * kscreenheight)
        }
        vehiclenameLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(0.03 * kscreenwidth)
            make.width.equalTo(0.22 * kscreenwidth)
        }
        currentLabel.snp.makeConstraints{(make) in
            make.top.equalTo(0.007 * kscreenheight)
            make.right.equalTo(lineview.snp.left).offset(-0.05 * kscreenwidth)
            make.width.equalTo(0.17 * kscreenwidth)
        }
        currentkmLabel.snp.makeConstraints{(make) in
            make.top.equalTo(currentLabel.snp.bottom).offset(0.007 * kscreenheight)
            make.right.equalTo(lineview.snp.left).offset(-0.05 * kscreenwidth)
            make.width.equalTo(0.185 * kscreenwidth)
        }
        lineview.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()//.offset(-0.005 * kscreenheight)
            make.height.equalTo(0.03 * kscreenheight)
            make.right.equalTo(dateLabel.snp.left).offset(-0.05 * kscreenwidth)
            make.width.equalTo(1)
        }
        
        dateLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(0.006 * kscreenheight)
            make.right.equalTo(-0.033 * kscreenwidth)
            make.width.equalTo(0.21 * kscreenwidth)
        }
        datecalenderLabel.snp.makeConstraints{(make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(0.007 * kscreenheight)
            make.right.equalTo(-0.065 * kscreenwidth)
            // make.width.equalTo(0.15 * kscreenwidth)
        }
        // Option buttons :-
        optionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalTo(mapView).offset(-90)
            make.height.width.equalTo(55)
        }
        changeMapTypeBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(optionButton)
            make.bottom.equalTo(optionButton.snp.top).offset(-10)
            make.right.equalTo(optionButton)
            make.size.equalTo(optionButton)
        }
        changeMapTypelbl.snp.makeConstraints { (make) in
            make.right.equalTo(changeMapTypeBtn.snp.left).offset(-5)
            make.centerY.equalTo(changeMapTypeBtn)
            make.height.equalToSuperview().multipliedBy(0.04)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        directionBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(changeMapTypeBtn)
            make.bottom.equalTo(changeMapTypeBtn.snp.top).offset(-10)
            make.right.equalTo(changeMapTypeBtn)
            make.size.equalTo(changeMapTypeBtn)
        }
        directionlbl.snp.makeConstraints { (make) in
            make.right.equalTo(directionBtn.snp.left).offset(-5)
            make.centerY.equalTo(directionBtn)
            make.size.equalTo(changeMapTypelbl)
        }
        stopsBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(directionBtn)
            make.bottom.equalTo(directionBtn.snp.top).offset(-10)
            make.right.equalTo(directionBtn)
            make.size.equalTo(changeMapTypeBtn)
        }
        stopslbl.snp.makeConstraints { (make) in
            make.right.equalTo(stopsBtn.snp.left).offset(-5)
            make.centerY.equalTo(stopsBtn)
            make.size.equalTo(changeMapTypelbl)
        }
        
    }
    
}



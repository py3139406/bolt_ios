//
//  PlayBackView.swift
//  Bolt
//
//  Created by Saanica Gupta on 06/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class PlayBackView: UIView {
  
  weak var containerView:UIView?
    var replayspeed:UILabel!
  var speedsMeterView: UIView!
  var speedoMeterImageView: UIImageView!
  var speedoMeterLabel: UILabel!
  var showSpeedLabel: UILabel!
  var playLeftButton: UIButton!
  var playRightButton : UIButton!
  var upperView: UIView!
  var vehiclenameLabel: UILabel!
  var totalLabel: UILabel!
  var totalkmLabel: UILabel!
  var currentLabel: UILabel!
  var currentkmLabel: UILabel!
  var dateLabel: UILabel!
  var datecalenderLabel : UILabel!
  var kscreenheight = UIScreen.main.bounds.height
  var kscreenwidth = UIScreen.main.bounds.width
    var speed:String = ""
    var lineview:UIView!
    var line1view: UIView!
    var timeSlider: UISlider!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSpeedoMeterView()
    addupperview()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //       func addViews() -> Void {
  //           containerView = create(subView:"UIView") as? UIView
  ////
  ////
  //       }
  
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
  
  func addupperview()
  {
    upperView = UIView(frame: CGRect.zero)
    upperView.backgroundColor = UIColor.black
    addSubview(upperView)
    
    vehiclenameLabel = UILabel(frame: CGRect.zero)
    vehiclenameLabel.text = "dhjsdsjsh"
    vehiclenameLabel.numberOfLines = 3
    vehiclenameLabel.font = UIFont.systemFont(ofSize: 15.0)
    vehiclenameLabel.adjustsFontSizeToFitWidth = true
    vehiclenameLabel.textColor = .white
    upperView.addSubview(vehiclenameLabel)
    
    totalLabel = UILabel(frame: CGRect.zero)
    totalLabel.text = "TOTAL"
    totalLabel.font = UIFont.systemFont(ofSize: 15.0)
    totalLabel.adjustsFontSizeToFitWidth = true
    totalLabel.textColor = appGreenTheme
    upperView.addSubview(totalLabel)
    
    totalkmLabel = UILabel(frame: CGRect.zero)
    totalkmLabel.text = "0.0KM"
    totalkmLabel.font = UIFont.systemFont(ofSize: 12.0)
    totalkmLabel.numberOfLines = 2
    totalkmLabel.textAlignment = .center
    //totalkmLabel.adjustsFontSizeToFitWidth = true
    totalkmLabel.textColor = .white
    upperView.addSubview(totalkmLabel)
    
    currentLabel = UILabel(frame: CGRect.zero)
    currentLabel.text = "CURRENT"
    currentLabel.adjustsFontSizeToFitWidth = true
    currentLabel.font = UIFont.systemFont(ofSize: 15.0)
    currentLabel.textColor = .white
    upperView.addSubview(currentLabel)
    
    currentkmLabel = UILabel(frame: CGRect.zero)
    currentkmLabel.text = "0.0KM"
    currentkmLabel.numberOfLines = 2
    currentkmLabel.font = UIFont.systemFont(ofSize: 13.0)
    currentkmLabel.textAlignment = .center
    //currentkmLabel.adjustsFontSizeToFitWidth = true
    currentkmLabel.textColor = .white
    upperView.addSubview(currentkmLabel)
    
    dateLabel = UILabel(frame: CGRect.zero)
    dateLabel.text = ""
    dateLabel.font = UIFont.systemFont(ofSize: 15.0)
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
    lineview.backgroundColor = .cyan
    upperView.addSubview(lineview)
    line1view = UIView(frame: CGRect.zero)
    line1view.backgroundColor = .cyan
    upperView.addSubview(line1view)
    
    
  }
  
  
  
  func addConstraints() -> Void {
    
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
        //make.width.equalTo(0.05 * kscreenwidth)
        make.left.equalTo(0.03 * kscreenwidth)
        make.width.equalTo(0.22 * kscreenwidth)
    }
    totalLabel.snp.makeConstraints{(make) in
        make.top.equalTo(0.01 * kscreenheight)
        make.right.equalTo(currentLabel.snp.left).offset(-0.05 * kscreenwidth)
        //make.width.equalTo(0.13 * kscreenwidth)
    }
    totalkmLabel.snp.makeConstraints{(make) in
        make.top.equalTo(totalLabel.snp.bottom).offset(0.007 * kscreenheight)
        make.left.equalTo(vehiclenameLabel.snp.right).offset(0.11 * kscreenwidth)
        make.width.equalTo(0.16 * kscreenwidth)
    }
    line1view.snp.makeConstraints{(make) in
        make.top.equalTo(totalLabel.snp.bottom).offset(0.007 * kscreenheight)
        make.left.equalTo(totalLabel.snp.right).offset(0.018 * kscreenwidth)
        make.height.equalTo(0.03 * kscreenheight)
        make.width.equalTo(0.001 * kscreenwidth)
    }
    currentLabel.snp.makeConstraints{(make) in
        make.top.equalTo(0.01 * kscreenheight)
        make.right.equalTo(dateLabel.snp.left).offset(-0.032 * kscreenwidth)
        make.width.equalTo(0.17 * kscreenwidth)
    }
    currentkmLabel.snp.makeConstraints{(make) in
        make.top.equalTo(currentLabel.snp.bottom).offset(0.007 * kscreenheight)
        //                    make.left.equalTo(totalkmLabel.snp.right).offset(0.005 * kscreenwidth)
        make.right.equalTo(dateLabel.snp.left).offset(-0.037 * kscreenwidth)
        make.width.equalTo(0.185 * kscreenwidth)
    }
    lineview.snp.makeConstraints{(make) in
        make.top.equalTo(currentLabel.snp.bottom).offset(0.007 * kscreenheight)
        make.height.equalTo(0.03 * kscreenheight)
        make.left.equalTo(currentLabel.snp.right).offset(0.008 * kscreenwidth)
        make.width.equalTo(0.001 * kscreenwidth)
    }
    
    dateLabel.snp.makeConstraints{ (make) in
        make.top.equalTo(0.01 * kscreenheight)
        make.right.equalTo(-0.033 * kscreenwidth)
        make.width.equalTo(0.21 * kscreenwidth)
    }
    datecalenderLabel.snp.makeConstraints{(make) in
        make.top.equalTo(dateLabel.snp.bottom).offset(0.007 * kscreenheight)
        make.centerX.equalTo(dateLabel)
//        make.right.equalTo(-0.065 * kscreenwidth)
        // make.width.equalTo(0.15 * kscreenwidth)
    }
    
    }
    
}


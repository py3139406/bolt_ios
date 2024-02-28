//
//  LoadUnloadView.swift
//  Bolt
//
//  Created by Roadcast on 11/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

var isLastLoading = true
class LoadUnloadView: UIView {
    // Mark:properties
    var topView:UIView!
    var loadUnloadTitle:UILabel!
    var loadUnloadImg:UIImageView!
    //:- last loading details
    var lastLoadingBg:UIView!
    var lastLoadingTitle:UILabel!
    var typeLbl:UILabel!
    var startTimeLbl:UILabel!
    var endTimeLbl:UILabel!
    var totalTimeLbl:UILabel!
    var hTitleStackView:UIStackView!
    var typeText:UILabel!
    var startTimeText:UILabel!
    var endTimeText:UILabel!
    var totalTimeText:UILabel!
    var hTextStackview:UIStackView!
    var vLastLoadingStackView:UIStackView!
    //:- bottom timers
    var bottomBg:UIView!
    var sTimeTitle:UILabel!
    var eTimeTitle:UILabel!
    var tTimeTitle:UILabel!
    var sTimeValue:UILabel!
    var eTimeValue:UILabel!
    var tTimeValue:UILabel!
    var hTitleStack:UIStackView!
    var hValueStack:UIStackView!
    var vStack:UIStackView!
  //  :- others
    var loadRadioBtn:RadioButton!
    var loadRadioLbl:UILabel!
    var unloadRadioBtn:RadioButton!
    var unloadRadioLbl:UILabel!
    var startTimeBtn:UIButton!
    var timer:Timer!
    var lineView:UIView!
    var timerLabel:UILabel!
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      addview()
      addconstraints()
      
    }
    func  addview(){
        //: top view
        topView = UIView()
        topView.backgroundColor = .white
        addSubview(topView)
        
        loadUnloadTitle = UILabel()
        loadUnloadTitle.text = "Load/Unload Timer"
        loadUnloadTitle.textColor = .black
        loadUnloadTitle.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        topView.addSubview(loadUnloadTitle)
        
        loadUnloadImg = UIImageView()
        loadUnloadImg.image = UIImage(named: "loadUnload-1")
        loadUnloadImg.contentMode = .scaleAspectFit
        topView.addSubview(loadUnloadImg)
        
        //:- last loading view
        lastLoadingBg = UIView()
        lastLoadingBg.backgroundColor = .white
        lastLoadingBg.layer.cornerRadius = 5
        addSubview(lastLoadingBg)
        
        lastLoadingTitle = UILabel()
        lastLoadingTitle.text = "Last loading details"
        lastLoadingTitle.textColor = appGreenTheme
        lastLoadingTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        lastLoadingTitle.textAlignment = .center
        
        typeLbl = PaddingLabel()
        typeLbl.text = "TYPE"
        typeLbl.textColor = .white
        typeLbl.allowsDefaultTighteningForTruncation = true
        typeLbl.adjustsFontSizeToFitWidth = true
        typeLbl.textAlignment = .center
        typeLbl.backgroundColor = appGreenTheme
        typeLbl.layer.cornerRadius = 5
        typeLbl.layer.masksToBounds = true
        
        startTimeLbl = PaddingLabel()
        startTimeLbl.text = "START TIME"
        startTimeLbl.textColor = .white
        startTimeLbl.allowsDefaultTighteningForTruncation = true
        startTimeLbl.adjustsFontSizeToFitWidth = true
        startTimeLbl.textAlignment = .center
        startTimeLbl.backgroundColor = appGreenTheme
        startTimeLbl.layer.cornerRadius = 5
        startTimeLbl.layer.masksToBounds = true
        
        endTimeLbl = PaddingLabel()
        endTimeLbl.text = "END TIME"
        endTimeLbl.textColor = .white
        endTimeLbl.allowsDefaultTighteningForTruncation = true
        endTimeLbl.adjustsFontSizeToFitWidth = true
        endTimeLbl.textAlignment = .center
        endTimeLbl.backgroundColor = appGreenTheme
        endTimeLbl.layer.cornerRadius = 5
        endTimeLbl.layer.masksToBounds = true
        
        totalTimeLbl = PaddingLabel()
        totalTimeLbl.text = "TOTAL TIME"
        totalTimeLbl.textColor = .white
        totalTimeLbl.allowsDefaultTighteningForTruncation = true
        totalTimeLbl.adjustsFontSizeToFitWidth = true
        totalTimeLbl.textAlignment = .center
        totalTimeLbl.backgroundColor = appGreenTheme
        totalTimeLbl.layer.cornerRadius = 5
        totalTimeLbl.layer.masksToBounds = true
        
        hTitleStackView = UIStackView(arrangedSubviews: [typeLbl,startTimeLbl,endTimeLbl,totalTimeLbl])
        hTitleStackView.alignment = .center
        hTitleStackView.axis = .horizontal
        hTitleStackView.distribution = .equalSpacing
        
        typeText = PaddingLabel()
        typeText.text = "Loading"
        typeText.textColor = .black
        typeText.adjustsFontSizeToFitWidth = true
        typeText.textAlignment = .center
        
        startTimeText = PaddingLabel()
        startTimeText.text = "12:67:90"
        startTimeText.textColor = .black
        startTimeText.adjustsFontSizeToFitWidth = true
        startTimeText.textAlignment = .center
        
        endTimeText = PaddingLabel()
        endTimeText.text = "12:45:87"
        endTimeText.textColor = .black
        endTimeText.adjustsFontSizeToFitWidth = true
        endTimeText.textAlignment = .center
        
        totalTimeText = PaddingLabel()
        totalTimeText.text = "45:98:09"
        totalTimeText.textColor = .black
        totalTimeText.adjustsFontSizeToFitWidth = true
        totalTimeText.textAlignment = .center
        
        hTextStackview = UIStackView(arrangedSubviews: [typeText,startTimeText,endTimeText,totalTimeText])
        hTextStackview.alignment = .center
        hTextStackview.axis = .horizontal
        hTextStackview.distribution = .equalSpacing
        
        vLastLoadingStackView = UIStackView(arrangedSubviews: [lastLoadingTitle,hTitleStackView,hTextStackview])
        vLastLoadingStackView.alignment = .center
        vLastLoadingStackView.distribution = .equalSpacing
        vLastLoadingStackView.axis = .vertical
        lastLoadingBg.addSubview(vLastLoadingStackView)
        
        //:bottom timers view
        bottomBg = UIView()
        bottomBg.backgroundColor = .white
        bottomBg.layer.cornerRadius = 5
        addSubview(bottomBg)
        
        sTimeTitle = PaddingLabel()
        sTimeTitle.text = "START TIME"
        sTimeTitle.textColor = .white
        sTimeTitle.allowsDefaultTighteningForTruncation = true
        sTimeTitle.adjustsFontSizeToFitWidth = true
        sTimeTitle.textAlignment = .center
        sTimeTitle.backgroundColor = appGreenTheme
        sTimeTitle.layer.cornerRadius = 5
        sTimeTitle.layer.masksToBounds = true
        
        eTimeTitle = PaddingLabel()
        eTimeTitle.text = "END TIME"
        eTimeTitle.textColor = .white
        eTimeTitle.allowsDefaultTighteningForTruncation = true
        eTimeTitle.adjustsFontSizeToFitWidth = true
        eTimeTitle.textAlignment = .center
        eTimeTitle.backgroundColor = appGreenTheme
        eTimeTitle.layer.cornerRadius = 5
        eTimeTitle.layer.masksToBounds = true
        
        tTimeTitle = PaddingLabel()
        tTimeTitle.text = "TOTAL TIME"
        tTimeTitle.textColor = .white
        tTimeTitle.allowsDefaultTighteningForTruncation = true
        tTimeTitle.adjustsFontSizeToFitWidth = true
        tTimeTitle.textAlignment = .center
        tTimeTitle.backgroundColor = appGreenTheme
        tTimeTitle.layer.cornerRadius = 5
        tTimeTitle.layer.masksToBounds = true
        
        hTitleStack = UIStackView(arrangedSubviews: [sTimeTitle,eTimeTitle,tTimeTitle])
        hTitleStack.alignment = .center
        hTitleStack.axis = .horizontal
        hTitleStack.distribution = .equalSpacing
        
        sTimeValue = PaddingLabel()
        sTimeValue.text = "00:00:00"
        sTimeValue.textColor = .black
        sTimeValue.adjustsFontSizeToFitWidth = true
        sTimeValue.textAlignment = .center
        
        eTimeValue = PaddingLabel()
        eTimeValue.text = "00:00:00"
        eTimeValue.textColor = .black
        eTimeValue.adjustsFontSizeToFitWidth = true
        eTimeValue.textAlignment = .center
        
        tTimeValue = PaddingLabel()
        tTimeValue.text = "00:00:00"
        tTimeValue.textColor = .black
        tTimeValue.adjustsFontSizeToFitWidth = true
        tTimeValue.textAlignment = .center
        
        hValueStack = UIStackView(arrangedSubviews: [sTimeValue,eTimeValue,tTimeValue])
        hValueStack.alignment = .center
        hValueStack.axis = .horizontal
        hValueStack.distribution = .equalSpacing
        
        vStack = UIStackView(arrangedSubviews: [hTitleStack,hValueStack])
        vStack.alignment = .center
        vStack.distribution = .equalSpacing
        vStack.axis = .vertical
        bottomBg.addSubview(vStack)
        
        //:- others view
        loadRadioBtn = RadioButton(frame: CGRect.zero)
        loadRadioBtn.innerCircleCircleColor = appGreenTheme
        loadRadioBtn.outerCircleColor = appGreenTheme
        loadRadioBtn.innerCircleGap = 2
        loadRadioBtn.isSelected = true
        addSubview(loadRadioBtn)
        
        unloadRadioBtn = RadioButton(frame: CGRect.zero)
        unloadRadioBtn.innerCircleCircleColor = appGreenTheme
        unloadRadioBtn.outerCircleColor = appGreenTheme
        unloadRadioBtn.innerCircleGap = 2
        addSubview(unloadRadioBtn)
        
        loadRadioLbl = UILabel()
        loadRadioLbl.text = "Load"
        loadRadioLbl.textColor = .white
        loadRadioLbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        loadRadioLbl.textAlignment = .center
        addSubview(loadRadioLbl)
        
        unloadRadioLbl = UILabel()
        unloadRadioLbl.text = "Unload"
        unloadRadioLbl.textColor = .white
        unloadRadioLbl.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        unloadRadioLbl.textAlignment = .center
        addSubview(unloadRadioLbl)
        
        lineView = UIView()
        lineView.backgroundColor = .black
        addSubview(lineView)
        
        startTimeBtn = UIButton()
        startTimeBtn.setTitle("START TIMER", for: .normal)
        startTimeBtn.setTitleColor(.white, for: .normal)
        startTimeBtn.backgroundColor = .red
        startTimeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        addSubview(startTimeBtn)
        
        timerLabel = UILabel()
        timerLabel.text = "00:00:00"
        timerLabel.textColor = .white
        timerLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        timerLabel.textAlignment = .center
        addSubview(timerLabel)
    }
    func  addconstraints(){
        
        //:top view layout
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        loadUnloadTitle.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(screensize.width * 0.05)
        }
        loadUnloadImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-screensize.width * 0.1)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        if isLastLoading {
             addLastLoadingConstraints()
        }
        loadRadioBtn.snp.makeConstraints { (make) in
            if isLastLoading {
                 make.top.equalTo(lastLoadingBg.snp.bottom).offset(screensize.height * 0.02)
            } else {
                make.top.equalTo(topView.snp.bottom).offset(screensize.width * 0.02)
            }
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.06)
            make.height.equalToSuperview().multipliedBy(0.04)
        }
        loadRadioLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(loadRadioBtn)
            make.left.equalTo(loadRadioBtn.snp.right).offset(screensize.width * 0.02)
        }
        unloadRadioBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(loadRadioBtn)
            make.left.equalTo(loadRadioLbl.snp.right).offset(screensize.width * 0.2)
            make.size.equalTo(loadRadioBtn)
        }
        unloadRadioLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(unloadRadioBtn)
            make.left.equalTo(unloadRadioBtn.snp.right).offset(screensize.width * 0.02)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(loadRadioBtn.snp.bottom).offset(screensize.height * 0.02)
            make.width.equalToSuperview()
            make.height.equalTo(2)
        }
        timerLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        //: bottom timer view layout
        bottomBg.snp.makeConstraints { (make) in
            make.bottom.equalTo(startTimeBtn.snp.top).offset(-screensize.height * 0.1)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
        vStack.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        hTitleStack.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        hValueStack.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        sTimeTitle.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        eTimeTitle.snp.makeConstraints { (make) in
            make.size.equalTo(sTimeTitle)
        }
        tTimeTitle.snp.makeConstraints { (make) in
            make.size.equalTo(sTimeTitle)
        }
        sTimeValue.snp.makeConstraints { (make) in
             make.width.equalToSuperview().multipliedBy(0.27)
        }
        eTimeValue.snp.makeConstraints { (make) in
            make.size.equalTo(sTimeValue)
        }
        tTimeValue.snp.makeConstraints { (make) in
            make.size.equalTo(sTimeValue)
        }
        //: start btn
        startTimeBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview()
        }
    }
    func addLastLoadingConstraints(){
        lastLoadingBg.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(screensize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        vLastLoadingStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.95)
        }
        hTitleStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        hTextStackview.snp.makeConstraints { (make) in
            make.size.equalTo(hTitleStackView)
        }
        lastLoadingTitle.snp.makeConstraints { (make) in
            make.size.equalTo(hTitleStackView)
        }
        typeLbl.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.23)
        }
        startTimeLbl.snp.makeConstraints { (make) in
            make.size.equalTo(typeLbl)
        }
        endTimeLbl.snp.makeConstraints { (make) in
            make.size.equalTo(typeLbl)
        }
        totalTimeLbl.snp.makeConstraints { (make) in
            make.size.equalTo(typeLbl)
        }
        typeText.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        startTimeText.snp.makeConstraints { (make) in
            make.size.equalTo(typeText)
        }
        endTimeText.snp.makeConstraints { (make) in
            make.size.equalTo(typeText)
        }
        totalTimeText.snp.makeConstraints { (make) in
            make.size.equalTo(typeText)
        }
    }
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

}

//
//  RechargeCallCreditView.swift
//  Bolt
//
//  Created by Saanica Gupta on 03/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RechargeCallCreditView: UIView {
    
    var appDarkTheme = UIColor(red: 38/255, green: 39/255, blue: 58/255, alpha: 1.0)
    var appGreenTheme = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
    var creditvalueView: UIView!
    var creditvalueLabel: UILabel!
    var callcreditLabel: UILabel!
    var validtyLabel: UILabel!
    var availablecreditView: UIView!
    var availablecreditLabel: UILabel!
    var minusButton: UIButton!
    var callcreditamountLabel: UILabel!
    var plusButton: UIButton!
    var inrLabel: UILabel!
    var knowmoreButton: UIButton!
    var proceedButton:UIButton!
    
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addallinone()
        addConstrainsts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func addallinone(){
 
        creditvalueView = UIView(frame: CGRect.zero)
        creditvalueView.backgroundColor = .black
        addSubview(creditvalueView)
        
        creditvalueLabel = UILabel(frame: CGRect.zero)
        creditvalueLabel.text = "CREDIT VALUE"
        creditvalueLabel.textColor = appGreenTheme
        creditvalueLabel.font = UIFont.systemFont(ofSize: 25.0)
        creditvalueView.addSubview(creditvalueLabel)
        
        callcreditLabel = UILabel(frame: CGRect.zero)
        callcreditLabel.text = "1 Call alert = 1 credits"
        callcreditLabel.textColor = .white
        callcreditLabel.font = UIFont.systemFont(ofSize: 20.0)
        creditvalueView.addSubview(callcreditLabel)
        
        validtyLabel = UILabel(frame: CGRect.zero)
        validtyLabel.textColor = .white
        validtyLabel.font = UIFont.systemFont(ofSize: 20.0)
        validtyLabel.text = "Lifetime validty. Each credit costs INR 1."
        creditvalueView.addSubview(validtyLabel)
        
        availablecreditView = UIView(frame: CGRect.zero)
        availablecreditView.backgroundColor = appDarkTheme
        addSubview(availablecreditView)
        
        availablecreditLabel = UILabel(frame: CGRect.zero)
        availablecreditLabel.text = "Available credits : 0"
        availablecreditLabel.textColor = .white
        availablecreditLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        availablecreditView.addSubview(availablecreditLabel)
        
        minusButton = UIButton(frame: CGRect.zero)
        minusButton.setImage(#imageLiteral(resourceName: "Asset 152.jpg"), for: .normal)
        minusButton.contentMode = .scaleAspectFit
        minusButton.layer.cornerRadius = 20
        minusButton.layer.masksToBounds = true
        availablecreditView.addSubview(minusButton)
        
        callcreditamountLabel = UILabel(frame: CGRect.zero)
        callcreditamountLabel.text = "100"
        callcreditamountLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        callcreditamountLabel.textColor = .white
        availablecreditView.addSubview(callcreditamountLabel)
        
        plusButton = UIButton(frame: CGRect.zero)
        plusButton.setImage(#imageLiteral(resourceName: "Asset 151.jpg"), for: .normal)
        plusButton.contentMode = .scaleAspectFit
        plusButton.layer.cornerRadius = 20
        plusButton.layer.masksToBounds = true
        availablecreditView.addSubview(plusButton)
        
        inrLabel = UILabel(frame: CGRect.zero)
        inrLabel.text = "INR100"
        inrLabel.textColor = .white
        inrLabel.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        availablecreditView.addSubview(inrLabel)
        
        knowmoreButton = UIButton(frame: CGRect.zero)
        knowmoreButton.setTitle("KNOW MORE", for: .normal)
        knowmoreButton.setTitleColor(UIColor.white, for: .normal)
        knowmoreButton.backgroundColor = appGreenTheme
        knowmoreButton.layer.cornerRadius = 5
        knowmoreButton.layer.masksToBounds = true
        knowmoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        availablecreditView.addSubview(knowmoreButton)
        
        proceedButton = UIButton(frame: CGRect.zero)
        proceedButton.setTitle("PROCEED TO PAYMENT", for: .normal)
        proceedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        proceedButton.setTitleColor(UIColor.white, for: .normal)
        proceedButton.backgroundColor = appGreenTheme
        addSubview(proceedButton)
    }
    
    func addConstrainsts(){
        creditvalueView.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.18 * kscreenheight)
        }
        creditvalueLabel.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(0.02 * kscreenheight)
        }
        callcreditLabel.snp.makeConstraints{(make) in
        make.top.equalTo(creditvalueLabel.snp.bottom).offset(0.01 * kscreenheight)
        //make.top.equalTo(availablecreditLabel.snp.bottom).offset(0.05 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        validtyLabel.snp.makeConstraints{(make) in
            make.top.equalTo(callcreditLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-0.02 * kscreenheight)
        }
        availablecreditView.snp.makeConstraints{(make) in
            make.top.equalTo(creditvalueView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(0.65 * kscreenheight)
        }
        availablecreditLabel.snp.makeConstraints{(make) in
            make.top.equalTo(0.04 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        minusButton.snp.makeConstraints{(make) in
            make.top.equalTo(availablecreditLabel.snp.bottom).offset(0.05 * kscreenheight)
            //make.left.equalTo(0.27 * kscreenwidth)
            make.right.equalTo(callcreditamountLabel.snp.left).offset(-10)
            make.height.width.equalTo(35)
        }
        callcreditamountLabel.snp.makeConstraints{(make) in
            make.top.equalTo(availablecreditLabel.snp.bottom).offset(0.054 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        plusButton.snp.makeConstraints{(make) in
            make.top.equalTo(availablecreditLabel.snp.bottom).offset(0.05 * kscreenheight)
           // make.right.equalTo(-0.26 * kscreenwidth)
            make.left.equalTo(callcreditamountLabel.snp.right).offset(10)
            make.height.width.equalTo(35)
        }
        inrLabel.snp.makeConstraints{(make) in
            make.top.equalTo(plusButton.snp.bottom).offset(0.05 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        knowmoreButton.snp.makeConstraints{(make) in
            make.top.equalTo(inrLabel.snp.bottom).offset(0.05 * kscreenheight)
            make.centerX.equalToSuperview()
            make.width.equalTo(0.45 * kscreenwidth)
            make.height.equalTo(0.05 * kscreenheight)
        }
      
        proceedButton.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(kscreenheight * 0.08)
        }
    }
}

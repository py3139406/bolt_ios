//
//  SafetyFeatureView.swift
//  Bolt
//
//  Created by Saanica Gupta on 04/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit

class SecurityFeatureView: UIView {

    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var appDarkTheme = UIColor(red: 38/255, green: 39/255, blue: 58/255, alpha: 1.0)
    var appGreenTheme = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
    
    var callalertView: UIView!
    var callalertImageView: UIImageView!
    var callalertLabel: UILabel!
    var devicetamperLabel: UILabel!
    var callalertdescLabel: UILabel!
    
    var easycreditsandreceivecallView: UIView!
    var easycreditsLabel: UILabel!
    var apprechargeLabel: UILabel!
    var easycreditsdescLabel: UILabel!
    var easycreditsImageView: UIImageView!
    
    var recievecallLabel: UILabel!
    var cardangerLabel: UILabel!
    var recievecalldescLabel: UILabel!
    var recievevcallImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       //call function here
        makeview()
        addconstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func makeview()
    {
        callalertView = UIView(frame: CGRect.zero)
        callalertView.backgroundColor = appDarkTheme
        addSubview(callalertView)
        
        callalertImageView = UIImageView(frame: CGRect.zero)
        callalertImageView.image = UIImage(named: "call_alert")
        callalertImageView.contentMode = .scaleAspectFit
        callalertImageView.layer.cornerRadius = 25
        callalertImageView.layer.masksToBounds = true
        callalertView.addSubview(callalertImageView)
        
        callalertLabel = UILabel(frame: CGRect.zero)
        callalertLabel.text = "Call Alerts"
        callalertLabel.textColor = appGreenTheme
        callalertLabel.font = UIFont.systemFont(ofSize: 32.0)
        callalertView.addSubview(callalertLabel)
        
        devicetamperLabel = UILabel(frame: CGRect.zero)
        devicetamperLabel.text = "When device is tampered"
        devicetamperLabel.textColor = .white
        devicetamperLabel.font = UIFont.systemFont(ofSize: 20.0)
        callalertView.addSubview(devicetamperLabel)
        
        callalertdescLabel = UILabel(frame: CGRect.zero)
        callalertdescLabel.textColor = .white
        callalertdescLabel.numberOfLines = 2
        callalertdescLabel.textAlignment = .center
        callalertdescLabel.text = "Get instant call alerts when someone tampers whith your car tracker."
        callalertView.addSubview(callalertdescLabel)
        
        easycreditsandreceivecallView = UIView(frame: CGRect.zero)
        easycreditsandreceivecallView.backgroundColor = appDarkTheme
        addSubview(easycreditsandreceivecallView)
        
        easycreditsImageView = UIImageView(frame: CGRect.zero)
        easycreditsImageView.image = UIImage(named: "easy_credit")
        easycreditsImageView.contentMode = .scaleAspectFit
        easycreditsImageView.layer.cornerRadius = 30
        easycreditsImageView.layer.masksToBounds = true
        easycreditsandreceivecallView.addSubview(easycreditsImageView)
        
        easycreditsLabel = UILabel(frame: CGRect.zero)
        easycreditsLabel.text = "Easy credits"
        easycreditsLabel.textColor = appGreenTheme
        easycreditsLabel.font = UIFont.systemFont(ofSize: 25.0)
        easycreditsandreceivecallView.addSubview(easycreditsLabel)
        
        apprechargeLabel = UILabel(frame: CGRect.zero)
        apprechargeLabel.text = "With in app recharge feature"
        apprechargeLabel.textColor = .white
        apprechargeLabel.font = UIFont.systemFont(ofSize: 19.0)
        apprechargeLabel.numberOfLines = 2
        easycreditsandreceivecallView.addSubview(apprechargeLabel)
        
        easycreditsdescLabel = UILabel(frame: CGRect.zero)
        easycreditsdescLabel.textColor = .white
        easycreditsdescLabel.numberOfLines = 5
        easycreditsdescLabel.text = "Easily add credits with our In app recharge feature, 1 credit will be deducted per call,we are providing userwith 25 free credits"
        easycreditsandreceivecallView.addSubview(easycreditsdescLabel)
        
        recievevcallImageView = UIImageView(frame: CGRect.zero)
        recievevcallImageView.image = UIImage(named: "Receive_a_call")
        recievevcallImageView.contentMode = .scaleAspectFit
        recievevcallImageView.layer.cornerRadius = 25
        recievevcallImageView.layer.masksToBounds = true
        easycreditsandreceivecallView.addSubview(recievevcallImageView)
        
        recievecallLabel = UILabel(frame: CGRect.zero)
        recievecallLabel.text = "Receive a call"
        recievecallLabel.textColor = appGreenTheme
        recievecallLabel.font = UIFont.systemFont(ofSize: 25.0)
        easycreditsandreceivecallView.addSubview(recievecallLabel)
        
        cardangerLabel = UILabel(frame: CGRect.zero)
        cardangerLabel.text = "When your car is in danger"
        cardangerLabel.textColor = .white
        cardangerLabel.font = UIFont.systemFont(ofSize: 19.0)
        easycreditsandreceivecallView.addSubview(cardangerLabel)
        
        recievecalldescLabel = UILabel(frame: CGRect.zero)
        recievecalldescLabel.textColor = .white
        recievecalldescLabel.text = "Even If your mobile does not have an active internet connection, you will get a cal alert, when your vehicle is in parking mode."
        recievecalldescLabel.numberOfLines = 5
        easycreditsandreceivecallView.addSubview(recievecalldescLabel)
        
        
    }
    func addconstraints()
    {
        callalertView.snp.makeConstraints{(make) in
                if #available(iOS 11, *){
                    make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
                } else {
                    make.top.equalToSuperview().offset(70)
                }
                make.width.equalToSuperview()
                make.height.equalTo(kscreenheight * 0.3)
            }
        callalertImageView.snp.makeConstraints{(make) in
            make.top.equalTo(0.04 * kscreenheight)
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        callalertLabel.snp.makeConstraints{(make) in
            make.top.equalTo(callalertImageView.snp.bottom).offset(0.006 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        devicetamperLabel.snp.makeConstraints{(make) in
            make.top.equalTo(callalertLabel.snp.bottom).offset(0.006 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        callalertdescLabel.snp.makeConstraints{(make) in
            make.top.equalTo(devicetamperLabel.snp.bottom).offset(0.006 * kscreenheight)
            make.width.equalTo(0.95 * kscreenwidth)
            make.centerX.equalToSuperview()
        }
        easycreditsandreceivecallView.snp.makeConstraints{(make) in
            make.top.equalTo(callalertView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(0.6 * kscreenheight)
        }
        easycreditsImageView.snp.makeConstraints{(make) in
            make.top.equalTo(0.13 * kscreenheight)
            make.left.equalTo(0.04 * kscreenwidth)
             make.width.height.equalTo(60)
        }
        
        easycreditsLabel.snp.makeConstraints{(make) in
            make.top.equalTo(0.03 * kscreenheight)
            //make.centerX.equalToSuperview()
             make.left.equalTo(easycreditsImageView.snp.right).offset(0.1 * kscreenwidth)
        }
        apprechargeLabel.snp.makeConstraints{(make) in
            make.top.equalTo(easycreditsLabel.snp.bottom).offset(0.008 * kscreenheight)
             make.left.equalTo(easycreditsImageView.snp.right).offset(0.1 * kscreenwidth)
            make.width.equalTo(0.65 * kscreenwidth)
        }
        easycreditsdescLabel.snp.makeConstraints{(make) in
            make.top.equalTo(apprechargeLabel.snp.bottom).offset(0.008 * kscreenheight)
           make.left.equalTo(easycreditsImageView.snp.right).offset(0.1 * kscreenwidth)
            make.width.equalTo(0.65 * kscreenwidth)
        }
        
        
        
        
        recievevcallImageView.snp.makeConstraints{(make) in
            make.top.equalTo(easycreditsdescLabel.snp.bottom).offset(0.1 * kscreenheight)
                   make.right.equalTo(-0.05 * kscreenwidth)
                    make.width.height.equalTo(50)
               }
               
               recievecallLabel.snp.makeConstraints{(make) in
                make.top.equalTo(easycreditsdescLabel.snp.bottom).offset(0.03 * kscreenheight)
                   //make.centerX.equalToSuperview()
                    make.right.equalTo(recievevcallImageView.snp.left).offset(-0.13 * kscreenwidth)
               }
               cardangerLabel.snp.makeConstraints{(make) in
                   make.top.equalTo(recievecallLabel.snp.bottom).offset(0.008 * kscreenheight)
                    make.right.equalTo(recievevcallImageView.snp.left).offset(-0.06 * kscreenwidth)
                   make.width.equalTo(0.65 * kscreenwidth)
               }
               recievecalldescLabel.snp.makeConstraints{(make) in
                   make.top.equalTo(cardangerLabel.snp.bottom).offset(0.008 * kscreenheight)
                  make.right.equalTo(recievevcallImageView.snp.left).offset(-0.06 * kscreenwidth)
                   make.width.equalTo(0.65 * kscreenwidth)
               }
   
    }

}

//
//  MoreInfoView.swift
//  Bolt
//
//  Created by Vivek Kumar on 12/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
class MoreInfoView: UIView {
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var moreinfoLabel: UILabel!
    var crossButton: UIButton!
    var moreinfofirstrow: MoreInfoViewFirstRowScroll!
    var moreinfosecondrow: MoreInfoViewSecondScrollView!
    var moreinfothirdrow: MoreInfoViewThirdScrollView!
    //MARK:- Variables
   
    var lineview: UIView!
    var lineview1: UIView!
    var lineview2: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        backgroundColor = appDarkTheme
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addViews() -> Void {
        
        moreinfoLabel = UILabel(frame: CGRect.zero)
        moreinfoLabel.text = "MORE INFO"
        moreinfoLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        moreinfoLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        addSubview(moreinfoLabel)
        
        crossButton = UIButton(frame: CGRect.zero)
        //crossButton.setImage(UIImage(named: "closeButtonSubscriptionExpired"), for: .normal)
        if let myImage = UIImage(named: "closeButtonSubscriptionExpired") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            crossButton.setImage(tintableImage , for: .normal)
        }
        crossButton.tintColor =  UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        crossButton.contentMode = .scaleAspectFit
        addSubview(crossButton)
        
        lineview = UIView(frame: CGRect.zero)
        lineview.backgroundColor = .black
        addSubview(lineview)
        
        
        moreinfofirstrow = MoreInfoViewFirstRowScroll(frame: CGRect.zero)
        moreinfofirstrow.setContentOffset(
            CGPoint(x: 0,y: -self.moreinfofirstrow.contentInset.top),
            animated: true)
        moreinfofirstrow.backgroundColor = .clear
        moreinfofirstrow.alwaysBounceHorizontal = false
        moreinfofirstrow.isScrollEnabled = false
        moreinfofirstrow.contentMode = .right
        moreinfofirstrow.contentSize = CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.2)
        moreinfofirstrow.showsHorizontalScrollIndicator = false
        addSubview(moreinfofirstrow)
        
        moreinfosecondrow = MoreInfoViewSecondScrollView(frame: CGRect.zero)
        moreinfosecondrow.setContentOffset(
            CGPoint(x: 0,y: -self.moreinfosecondrow.contentInset.top),
            animated: true)
        moreinfosecondrow.backgroundColor = .clear
        moreinfosecondrow.alwaysBounceHorizontal = false
        moreinfosecondrow.isScrollEnabled = false
        moreinfosecondrow.contentMode = .right
        moreinfosecondrow.contentSize = CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.2)
        moreinfosecondrow.showsHorizontalScrollIndicator = false
        addSubview(moreinfosecondrow)
        
        moreinfothirdrow = MoreInfoViewThirdScrollView(frame: CGRect.zero)
        moreinfothirdrow.setContentOffset(
            CGPoint(x: 0,y: -self.moreinfothirdrow.contentInset.top),
            animated: true)
        moreinfothirdrow.backgroundColor = .clear
        moreinfothirdrow.alwaysBounceHorizontal = false
        moreinfothirdrow.isScrollEnabled = false
        moreinfothirdrow.contentMode = .right
        moreinfothirdrow.contentSize = CGSize(width: self.frame.width * 0.8, height: self.frame.height * 0.2)
        moreinfothirdrow.showsHorizontalScrollIndicator = false
        addSubview(moreinfothirdrow)
        
        lineview1 = UIView(frame: CGRect.zero)
        lineview1.backgroundColor = .black
        addSubview(lineview1)
        
        lineview2 = UIView(frame: CGRect.zero)
        lineview2.backgroundColor = .black
        addSubview(lineview2)
    }
    func addConstraints() {
        moreinfoLabel.snp.makeConstraints{(make) in
            make.top.equalTo(0.015 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        crossButton.snp.makeConstraints{(make) in
            make.top.equalTo(0.01 * kscreenheight)
            make.right.equalTo(-0.02 * kscreenwidth)
            make.width.height.equalTo(0.06 * kscreenwidth)
        }
        lineview.snp.makeConstraints{(make) in
            make.top.equalTo(crossButton.snp.bottom).offset(0.015 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalTo(0.001 * kscreenheight)
        }
        
        moreinfofirstrow.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom).offset(0.008 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            
        }
        
        lineview1.snp.makeConstraints{(make) in
            make.top.equalTo(moreinfofirstrow.snp.bottom).offset(0.02 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalTo(0.001 * kscreenheight)
        }
        
        moreinfosecondrow.snp.makeConstraints { (make) in
            make.top.equalTo(lineview1.snp.bottom).offset(0.008 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            
        }
        lineview2.snp.makeConstraints{(make) in
            make.top.equalTo(moreinfosecondrow.snp.bottom).offset(0.02 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalTo(0.001 * kscreenheight)
        }
        
        moreinfothirdrow.snp.makeConstraints { (make) in
            make.top.equalTo(lineview2.snp.bottom).offset(0.008 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            
        }
        
    }
}

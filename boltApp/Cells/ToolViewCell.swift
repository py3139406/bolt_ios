////
////  ToolViewCell.swift
////  boltApp
////
////  Created by Arshad Ali on 01/12/17.
////  Copyright © 2017 Arshad Ali. All rights reserved.
////

import UIKit
import SnapKit

class ToolViewCell: UICollectionViewCell {
    
    var img:UIImageView!
    var bgView:UIView!
    var label:UILabel!
    var toolsLabelBgColor = UIColor(red: 0.15, green: 0.15, blue: 0.23, alpha: 1.0)
    // for voice assist
    var voiceLabel:UILabel!
    var voiceImg:UIImageView!
    var newIcon:UIImageView!
    var googleImg:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setViews(){
        bgView = UIView()
        bgView.backgroundColor = .white
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 5
        bgView.clipsToBounds = true
        addSubview(bgView)
        
        img = UIImageView()
        img.contentMode = .scaleAspectFit
        bgView.addSubview(img)
        
        label = PaddingLabel()
        label.backgroundColor = toolsLabelBgColor
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.frame.size.width = label.intrinsicContentSize.width
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.textAlignment = .center
        bgView.addSubview(label)
        
        //voice assist
        voiceImg = UIImageView()
        voiceImg.isHidden = true
        voiceImg.contentMode = .scaleAspectFit
        bgView.addSubview(voiceImg)
        
        voiceLabel = PaddingLabel()
        voiceLabel.backgroundColor = toolsLabelBgColor
        voiceLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        voiceLabel.textColor = .white
        voiceLabel.frame.size.width = voiceLabel.intrinsicContentSize.width
        voiceLabel.layer.cornerRadius = 3
        voiceLabel.layer.masksToBounds = true
        voiceLabel.textAlignment = .center
        voiceLabel.isHidden = true
        bgView.addSubview(voiceLabel)
        
        newIcon = UIImageView()
        newIcon.isHidden = true
        newIcon.contentMode = .scaleAspectFit
        bgView.addSubview(newIcon)
        
        googleImg = UIImageView()
        googleImg.isHidden = true
        googleImg.contentMode = .scaleAspectFit
        bgView.addSubview(googleImg)
    }
    
    func addConstraints(){
        bgView.snp.makeConstraints{ (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()//.multipliedBy(0.95)
            make.height.equalToSuperview()//.multipliedBy(0.95)
        }
        img.snp.makeConstraints{ (make) in
            //make.top.equalToSuperview().offset(screensize.height * 0.02)
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        label.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-screensize.height * 0.02)
            make.height.equalToSuperview().multipliedBy(0.13)
    }
        // for voice assist
            voiceImg.snp.makeConstraints{ (make) in
              //  make.top.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(screensize.height * 0.02)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.25)
                make.height.equalToSuperview().multipliedBy(0.25)
            }
            newIcon.snp.makeConstraints{ (make) in
                make.top.equalToSuperview().offset(screensize.height * 0.005)
                make.right.equalToSuperview().offset(-screensize.width * 0.02)
                make.width.equalToSuperview().multipliedBy(0.15)
                make.height.equalToSuperview().multipliedBy(0.3)
        }
            voiceLabel.snp.makeConstraints{ (make) in
                make.top.equalTo(voiceImg.snp.bottom).offset(screensize.height * 0.02)
                make.center.equalToSuperview()
               // make.bottom.equalToSuperview().offset(-10)
                make.height.equalToSuperview().multipliedBy(0.13)
        }
        googleImg.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-screensize.height * 0.02)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
}
}


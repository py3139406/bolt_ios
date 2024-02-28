//
//  ShareLocPopView.swift
//  Bolt
//
//  Created by Roadcast on 05/11/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class ShareLocPopView: UIView {
    
    var liveBtn:RadioButton!
    var currentBtn:RadioButton!
    var liveLbl:UILabel!
    var currentLbl:UILabel!
    var titleLabel:UILabel!
    var textLabel:UILabel!
    var textField:UITextField!
    var cancelBtn:UIButton!
    var shareBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func    addViews(){
        
        liveBtn = RadioButton(frame: CGRect.zero)
        liveBtn.innerCircleCircleColor = appGreenTheme
        liveBtn.outerCircleColor = appGreenTheme
        liveBtn.innerCircleGap = 2
        liveBtn.isSelected = true
        addSubview(liveBtn)
        
        currentBtn = RadioButton(frame: CGRect.zero)
        currentBtn.innerCircleCircleColor = appGreenTheme
        currentBtn.outerCircleColor = appGreenTheme
        currentBtn.innerCircleGap = 2
        currentBtn.isSelected = false
        addSubview(currentBtn)
        
        liveLbl  = UILabel()
        liveLbl.textColor = .black
        liveLbl.text = "Live"
        liveLbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        addSubview(liveLbl)
        
        currentLbl  = UILabel()
        currentLbl.textColor = .black
        currentLbl.text = "Current"
        currentLbl.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        addSubview(currentLbl)
        
        titleLabel  = UILabel()
        titleLabel.textColor = .black
        titleLabel.text = "Share Shanky Testing"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        
        textLabel  = UILabel()
        textLabel.textColor = .black
        textLabel.text = "Please enter time for live location sharing of vehicle."
        textLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textLabel.numberOfLines = 2
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        textField = UITextField()
        textField.placeholder = "Enter hours"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.textColor = .black
        addSubview(textField)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("CANCEL", for: .normal)
        cancelBtn.setTitleColor(appGreenTheme, for: .normal)
        cancelBtn.backgroundColor = .white
        cancelBtn.layer.borderWidth = 0.5
        cancelBtn.layer.borderColor = UIColor.lightGray.cgColor
        addSubview(cancelBtn)
        
        shareBtn = UIButton()
        shareBtn.setTitle("SHARE", for: .normal)
        shareBtn.setTitleColor(appGreenTheme, for: .normal)
        shareBtn.backgroundColor = .white
        shareBtn.layer.borderWidth = 0.5
        shareBtn.layer.borderColor = UIColor.lightGray.cgColor
        addSubview(shareBtn)
        
    }
    private func addConstraints(){
        liveBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.size.equalTo(screensize.width * 0.05)
        }
        liveLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(liveBtn)
            make.left.equalTo(liveBtn.snp.right).offset(screensize.width * 0.01)
        }
        currentBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(liveBtn)
            make.left.equalTo(liveLbl.snp.right).offset(screensize.width * 0.1)
            make.size.equalTo(liveBtn)
        }
        currentLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(currentBtn)
            make.left.equalTo(currentBtn.snp.right).offset(screensize.width * 0.01)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(liveBtn.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
        }
        textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
        }
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(textLabel.snp.bottom).offset(screensize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            //make.height.equalToSuperview().multipliedBy(0.2)
            make.bottom.equalToSuperview()
        }
        shareBtn.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(screensize.height * 0.02)
            make.right.equalToSuperview()
            make.size.equalTo(cancelBtn)
            make.bottom.equalToSuperview()
        }
    }
}

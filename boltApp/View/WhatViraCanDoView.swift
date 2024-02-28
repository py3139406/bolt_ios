//
//  WhatViraCanDoView.swift
//  Bolt
//
//  Created by Vivek Kumar on 29/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class WhatViraCanDoView: UIView {
    
    var tryitopenLabel : UILabel!
    var talktoviraLabel : UILabel!
    var assistImageView : UIImageView!
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var headLabel: UILabel!
    var lineView: UIView!
    var CustomTableview: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //function call here
        addview()
        addconstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addview(){
        assistImageView = UIImageView(frame: CGRect.zero)
        assistImageView.image = UIImage(named: "assist")
        assistImageView.contentMode = .scaleAspectFill
        addSubview(assistImageView)
        
        tryitopenLabel = UILabel(frame: CGRect.zero)
        tryitopenLabel.text = "Try it! Open your Google Assistant & just say"
        tryitopenLabel.font = UIFont.systemFont(ofSize: 14.0)
        tryitopenLabel.textColor = .systemBlue
        addSubview(tryitopenLabel)
        
        talktoviraLabel = UILabel(frame: CGRect.zero)
        talktoviraLabel.textColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0)//131
        talktoviraLabel.text = "\"Talk to Roadcast Bolt\""
        addSubview(talktoviraLabel)
        
        headLabel = UILabel(frame: CGRect.zero)
        headLabel.text = "Here is what Roadcast Bolt can do for you"
        headLabel.textColor = appGreenTheme
        headLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headLabel.adjustsFontSizeToFitWidth = true
        addSubview(headLabel)
        
        lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = .lightGray
        addSubview(lineView)
        
        CustomTableview = UITableView(frame: CGRect.zero)
        CustomTableview.backgroundColor = .white
        CustomTableview.separatorColor = UIColor.lightGray
        CustomTableview.separatorStyle = .singleLine
        CustomTableview.bounces = false
        addSubview(CustomTableview)
        
        
    }
    func addconstraints(){
        assistImageView.snp.makeConstraints{(make) in
            make.top.equalTo(tryitopenLabel.snp.bottom)//.offset(screensize.height * 0.01)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        tryitopenLabel.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(screensize.height * 0.02)
            
        }
        talktoviraLabel.snp.makeConstraints{(make) in
            make.bottom.equalTo(assistImageView.snp.bottom).offset(-0.13 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        CustomTableview.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(0.01 * kscreenheight)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        headLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.80)
            make.top.equalTo(assistImageView.snp.bottom).offset(0.02 * kscreenheight)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(headLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.001)
        }
    }
}

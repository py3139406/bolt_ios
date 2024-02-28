//
//  BottomViewCollectionViewCell.swift
//  Bolt
//
//  Created by Vivek Kumar on 13/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class BottomViewCollectionViewCell: UICollectionViewCell {
    
    var fullview: UIView!
    var subtitleLabel: UILabel!
    var subtitleValue: UILabel!
    var lineview: UIView!
    var subtitleLabel1: UILabel!
    var subtitleValue1: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.views()
        self.addconstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func views(){
        
        subtitleLabel = UILabel(frame: CGRect.zero)
        subtitleLabel.text = ""
        subtitleLabel.font = UIFont.systemFont(ofSize: 10.0)
        subtitleLabel.textColor = UIColor(red: 96/255, green: 116/255, blue: 229/255, alpha: 1.0)
        contentView.addSubview(subtitleLabel)
        
        subtitleValue = UILabel(frame: CGRect.zero)
        subtitleValue.text = ""
        subtitleValue.font = UIFont.systemFont(ofSize: 13.0)
        subtitleValue.textColor = .white
        contentView.addSubview(subtitleValue)
        
        lineview = UIView(frame: CGRect.zero)
        lineview.backgroundColor = .white
        contentView.addSubview(lineview)
        
        subtitleLabel1 = UILabel(frame: CGRect.zero)
        subtitleLabel1.text = ""
        subtitleLabel1.font = UIFont.systemFont(ofSize: 10.0)
        subtitleLabel1.textColor = UIColor(red: 96/255, green: 116/255, blue: 229/255, alpha: 1.0)
        contentView.addSubview(subtitleLabel1)
        
        subtitleValue1 = UILabel(frame: CGRect.zero)
        subtitleValue1.text = ""
        subtitleValue1.font = UIFont.systemFont(ofSize: 13.0)
        subtitleValue1.textColor = .white
        contentView.addSubview(subtitleValue1)
    }
    func addconstraints(){
        
        subtitleLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.02 * kscreenheight)
            make.left.equalToSuperview().offset(0.1 * kscreenwidth)
        }
        subtitleValue.snp.makeConstraints{(make) in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(0.02 * kscreenheight)
            make.centerX.equalTo(subtitleLabel)
        }
        lineview.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(0.06 * kscreenheight)
            make.width.equalTo(0.002 * kscreenwidth)
        }
        subtitleLabel1.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.02 * kscreenheight)
            make.right.equalToSuperview().offset(-0.1 * kscreenwidth)
        }
        subtitleValue1.snp.makeConstraints{(make) in
            make.top.equalTo(subtitleLabel1.snp.bottom).offset(0.02 * kscreenheight)
            make.centerX.equalTo(subtitleLabel1)
        }
    }
    
    
    
    
}

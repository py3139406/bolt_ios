//
//  ViraTableViewCell.swift
//  Bolt
//
//  Created by Vivek Kumar on 29/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class ViraTableViewCell: UITableViewCell {

    var titleLabel: UILabel!
        var subtitleLabel: UILabel!
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.views()
            self.addconstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func views()
        {     titleLabel = UILabel()
            subtitleLabel = UILabel()
            titleLabel.text = ""
            titleLabel.textColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1.0)
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            subtitleLabel.textColor = .black
            subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            subtitleLabel.text = ""
            contentView.addSubview(subtitleLabel)
            contentView.addSubview(titleLabel)
        }
        func addconstraints()
        {
            titleLabel.snp.makeConstraints{(make) in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(10)
            }
            
            subtitleLabel.snp.makeConstraints{(make) in
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                
            }
        }
    }

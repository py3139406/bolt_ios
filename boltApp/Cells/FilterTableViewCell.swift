//
//  FilterTableViewCell.swift
//  Bolt
//
//  Created by Vivek Kumar on 20/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
         var leftText: RCLabel!
        var notificationButton: UIButton!
        

        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
            
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style , reuseIdentifier: reuseIdentifier)
            self.backgroundColor =  UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
            addTextView()
            addConstraints()
        }
        
        func addTextView(){
            leftText = RCLabel(frame: CGRect.zero)
            leftText.textColor = .white
            leftText.tintAdjustmentMode = .automatic
            leftText.backgroundColor = .clear
            leftText.font = UIFont.systemFont(ofSize: 16)
            contentView.addSubview(leftText)
            
            notificationButton = UIButton()
            notificationButton.setTitleColor(appGreenTheme, for: .normal)
            notificationButton.isHidden = true
            contentView.addSubview(notificationButton)
            
            
        }
        
        func addConstraints(){
            leftText.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(25)
                make.centerY.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.55)
            }
            notificationButton.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(leftText)
                make.centerY.equalToSuperview()
            }
            
        }
        
    }

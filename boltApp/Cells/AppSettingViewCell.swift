//
//  AppSettingViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class AppSettingViewCell: UITableViewCell {

    var leftText: RCLabel!
    var notificationButton: UIButton!
    var rightContent: UIView!
    var languageLabel: UILabel!
    var midBtn:UIButton!
    
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
        leftText.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(leftText)
        
        notificationButton = UIButton()
        notificationButton.setTitleColor(appGreenTheme, for: .normal)
        notificationButton.isHidden = true
        notificationButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(notificationButton)
        
        midBtn = UIButton()
        midBtn.setTitleColor(appGreenTheme, for: .normal)
        midBtn.isHidden = true
        midBtn.titleLabel?.numberOfLines = 2
        midBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(midBtn)
        
        languageLabel = UILabel()
        languageLabel.text = "English"
        languageLabel.isHidden = true
        languageLabel.textColor = appGreenTheme
        languageLabel.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(languageLabel)
        
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
        midBtn.snp.makeConstraints { (make) in
            make.right.equalTo(notificationButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(notificationButton)
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        languageLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(leftText)
            make.centerY.equalToSuperview()
        }
        
    }
    
}

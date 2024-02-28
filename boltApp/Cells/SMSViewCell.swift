//
//  SMSViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class SMSViewCell: UITableViewCell {

    var leftIcon: UIImageView!
    var menuText: RCLabel!
    var configToggle: UIButton!
    
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
        addImage()
        addTextView()
        addConfigButton()
        addConstraints()
    }
    
    func addImage(){
        leftIcon = UIImageView()
        leftIcon.backgroundColor = .clear
        leftIcon.contentMode = .center
        contentView.addSubview(leftIcon)
    }
    
    func addTextView(){
        menuText = RCLabel(frame: CGRect.zero)
        menuText.textColor = .white
        menuText.text = "Reboot Tracker"
        menuText.tintAdjustmentMode = .automatic
        menuText.backgroundColor = .clear
        menuText.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(menuText)
    }
    
    func addConfigButton () {
        configToggle = UIButton()
        configToggle.isHidden = true
        configToggle.setImage(#imageLiteral(resourceName: "red notification"), for: .normal)
        contentView.addSubview(configToggle)
    }
    
    func addConstraints(){
        leftIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.55)
            
        }
        menuText.snp.makeConstraints { (make) in
            make.left.equalTo(leftIcon.snp.right).offset(15)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        
        configToggle.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(leftIcon)
        }
    }

}

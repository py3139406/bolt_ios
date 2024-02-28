//
//  ProfileTableViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    var titleLabel: RCLabel!
    var inputButton: UIButton!
    var line: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellSetUp()
        addConstrains()
        self.backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func cellSetUp(){
        titleLabel = RCLabel(frame: CGRect.zero)
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize+2, weight: .regular)
        contentView.addSubview(titleLabel)
        
        inputButton = UIButton(frame: CGRect.zero)
        inputButton.setTitleColor(appGreenTheme, for: .normal)
        inputButton.contentHorizontalAlignment = .right
        inputButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize+2, weight: .regular)
        contentView.addSubview(inputButton)
        
    }
    
    func addConstrains(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            
        }
        
        inputButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(2)
            make.top.height.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-15)
        }
       
        
    }
   

}

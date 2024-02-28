//
//  ParkingTableViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ParkingTableViewCell: UITableViewCell {
    var nameLabel: UILabel!
    var iconImageView: UIButton!
    var timerImageView: UIButton!
    
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
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textColor = appGreenTheme
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        contentView.addSubview(nameLabel)
        
        iconImageView = UIButton(frame: CGRect.zero)
       // iconImageView.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
        contentView.addSubview(iconImageView)
        
        timerImageView = UIButton(frame: CGRect.zero)
        contentView.addSubview(timerImageView)
    }
    
    func addConstrains(){
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.70)
            
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(timerImageView.snp.left).offset(-10)
            make.width.equalTo(self).multipliedBy(0.1)
            make.height.equalTo(self).multipliedBy(0.5)
            make.centerY.equalTo(self)
        }
        
        timerImageView.snp.makeConstraints{ (make) in
            make.right.equalTo(self).offset(-20)
            make.size.equalTo(20)
//            make.width.equalTo(self).multipliedBy(0.045)
//            make.height.equalTo(iconImageView)       //(timerImageView.snp.width)
            make.centerY.equalTo(self)
        }
        
    }
}

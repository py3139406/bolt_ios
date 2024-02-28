//
//  AddEditCellTableViewCell.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import DefaultsKit

class AddEditCellTableViewCell: UITableViewCell {

    var vechileNameLabel: UILabel!
    var lastUpdated: UILabel!
    var iconImageView: UIImageView!
    var ignitionUpdateTime: UILabel!
    var line: UIView!
    var addressLabel: UILabel!
   // var vehicleRunningStatus: String!
    //let username = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
        addConstrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpCell() {
        vechileNameLabel = UILabel(frame:CGRect.zero)
        vechileNameLabel.textColor = .white
        vechileNameLabel.numberOfLines = 1
        vechileNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        //vechileNameLabel.adjustsFontSizeToFitWidth = true
       // vechileNameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        contentView.addSubview(vechileNameLabel)
        
        lastUpdated = UILabel(frame: CGRect.zero)
        lastUpdated.textColor = .white
        lastUpdated.textAlignment = .right
        lastUpdated.adjustsFontSizeToFitWidth = true
        //lastUpdated.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        lastUpdated.font = UIFont.italicSystemFont(ofSize: UIFont.smallSystemFontSize)
        lastUpdated.text = "Location Updated:"
        contentView.addSubview(lastUpdated)

        addressLabel = UILabel()
        addressLabel.text = "N/A"
        addressLabel.numberOfLines = 3
        //addressLabel.frame.size.width = addressLabel.intrinsicContentSize.width
        addressLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
       // addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.textColor = .white
        contentView.addSubview(addressLabel)
        
        iconImageView = UIImageView(frame: CGRect.zero)
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        ignitionUpdateTime = UILabel(frame: CGRect.zero)
        ignitionUpdateTime.textColor = .white
        ignitionUpdateTime.font = UIFont.preferredFont(forTextStyle: .caption2)
        ignitionUpdateTime.textAlignment = .center
        ignitionUpdateTime.layer.cornerRadius = 8
        ignitionUpdateTime.layer.borderWidth = 1.5
        contentView.addSubview(ignitionUpdateTime)
        
        line = UIView()
        contentView.addSubview(line)
        
    }
    
    func addConstrains() {

        vechileNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
           // make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.50)
        }
        
        
        iconImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.065)
            make.height.equalToSuperview().multipliedBy(0.40)
            make.top.equalTo(lastUpdated.snp.bottom).offset(10)
        }
        
        ignitionUpdateTime.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.right.equalTo(iconImageView.snp.left).offset(-8)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vechileNameLabel.snp.bottom).offset(10)
            make.left.equalTo(vechileNameLabel.snp.left)
            make.bottom.equalToSuperview().offset(-5)
            make.right.equalTo(ignitionUpdateTime.snp.left).offset(-10)
        }
        lastUpdated.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
           // make.height.equalToSuperview().multipliedBy(0.30)
            make.width.equalToSuperview().multipliedBy(0.30)
        }

        line.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.left.equalTo(ignitionUpdateTime.snp.right)
            make.right.equalTo(iconImageView.snp.left)
            make.height.equalTo(2)
        }

    }

}

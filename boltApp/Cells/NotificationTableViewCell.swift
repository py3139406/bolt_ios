//
//  NotificationTableViewCell.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    var label: UILabel!
    var iconImage: UIImageView!
    var timeLabel: UILabel!
    var addressPlace: UILabel!
    
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
        addTemplates()
        addConstraints()
        
    }
    
    func addTemplates() -> Void {
        label = UILabel.init(frame: CGRect.zero)
        label.textColor = .white
        label.numberOfLines = 3
        label.lineBreakMode = .byClipping
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        contentView.addSubview(label)
        
        timeLabel = UILabel.init(frame: CGRect.zero)
        timeLabel.textColor = .white
        timeLabel.numberOfLines = 0
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.textAlignment = .right
        timeLabel.text = "N/A"
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        contentView.addSubview(timeLabel)
        
        iconImage = UIImageView(frame: CGRect.zero)
        iconImage.contentMode = .scaleAspectFit
        iconImage.backgroundColor = .clear
        contentView.addSubview(iconImage)
        
        addressPlace = UILabel.init(frame: CGRect.zero)
        addressPlace.textColor = .white
        addressPlace.numberOfLines = 3
        addressPlace.font = .italicSystemFont(ofSize: 11)
        addressPlace.text = "here will be  address place shown in list ftfh fvjmyhvh thc  h   yhgchfgv htchchh ftdfmhjmhj ffuyfjyfjym fyc htdhtym chtdhtc hfmvhg hjvjhmvj "
        contentView.addSubview(addressPlace)
        
    }
    
    func addConstraints() -> Void {
        iconImage.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.07)
            make.height.equalToSuperview().multipliedBy(0.35)
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
        }
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImage.snp.centerY)//equalTo(iconImage)//.offset(8)
            make.left.equalTo(iconImage.snp.right).offset(20)
            make.width.equalToSuperview().multipliedBy(0.58)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconImage.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(label.snp.right).offset(5)
        }
        
        addressPlace.snp.makeConstraints {(make) in
            make.top.equalTo(iconImage.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-2)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

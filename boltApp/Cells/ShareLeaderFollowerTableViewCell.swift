//
//  ShareLeaderFollowerTableViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class ShareLeaderFollowerTableViewCell: UITableViewCell {
    
    var label: UILabel!
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
        label = UILabel.init(frame: CGRect.zero)
        label.textColor = .white
        label.backgroundColor =  UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
        contentView.addSubview(label)
        addConstraints()
        
    }
    
    
    func addConstraints() -> Void {
        label.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.65)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

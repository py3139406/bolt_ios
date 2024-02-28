//
//  RCImmobilizeTableViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class RCImmobilizeTableViewCell: UITableViewCell {

    
    var label: RCLabel!
    var actionButton: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addLabel()
        self.backgroundColor = .white
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel() -> Void {
        label = RCLabel(frame: CGRect.zero)
        label.textColor = UIColor(red: 46/255, green: 174/255, blue: 160/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        contentView.addSubview(label)
        
        actionButton = UIButton()
        actionButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
        contentView.addSubview(actionButton)
        
    }
    
    func addConstraints() -> Void {
        label.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.55)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerY.equalToSuperview()
        }
        actionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerY.equalToSuperview()
        }
    }
    

}

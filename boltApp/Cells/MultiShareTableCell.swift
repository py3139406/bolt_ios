//
//  MultiShareTableCell.swift
//  Bolt
//
//  Created by Roadcast on 05/11/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class MultiShareTableCell: UITableViewCell {
    
    var vehicleName:UILabel!
    var shareBtn:UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.backgroundColor = appDarkTheme
        addViews()
        setConstraints()
    }
    private func addViews(){
        vehicleName = UILabel(frame: CGRect.zero)
        vehicleName.textColor = .white
        vehicleName.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        contentView.addSubview(vehicleName)
        
        shareBtn = UIButton(frame: CGRect.zero)
        shareBtn.setImage(UIImage(named: "sharebuttonicon")!, for: .normal)
        shareBtn.transform = CGAffineTransform(rotationAngle: .pi)
        contentView.addSubview(shareBtn)
    }
    private func setConstraints(){
        vehicleName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.70)
        }
        shareBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.05)
            make.centerY.equalToSuperview()
        }
    }
}

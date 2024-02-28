//
//  FuelHistoryCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class FuelHistoryCell: UITableViewCell {

    var dateLabel: UILabel!
    var priceLabel: UILabel!
    var fillLabel: UILabel!
    var totalLabel: UILabel!
    var imageBtn: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        
        imageBtn = UIButton(frame: CGRect.zero)
        imageBtn.contentMode = .scaleAspectFit
        imageBtn.setImage(UIImage(named: "information"), for: .normal)
        contentView.addSubview(imageBtn)
        
        dateLabel = UILabel()
        //dateLabel.text = "2018-01-01"
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        priceLabel = UILabel()
      //  priceLabel.text = "70"
        priceLabel.adjustsFontForContentSizeCategory = true
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.textAlignment = .center
        contentView.addSubview(priceLabel)
        
        fillLabel = UILabel()
      //  fillLabel.text = "5"
        fillLabel.adjustsFontForContentSizeCategory = true
        fillLabel.adjustsFontSizeToFitWidth = true
        fillLabel.textAlignment = .center
        contentView.addSubview(fillLabel)
        
        totalLabel = UILabel()
       // totalLabel.text = "70"
        totalLabel.numberOfLines = 2
        totalLabel.adjustsFontForContentSizeCategory = true
        totalLabel.adjustsFontSizeToFitWidth = true
        totalLabel.textAlignment = .center
        contentView.addSubview(totalLabel)
        
    }
    
    func addConstraints() {
        dateLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.width.equalToSuperview().dividedBy(4.5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(dateLabel.snp.right)
            make.width.equalToSuperview().dividedBy(4.5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        fillLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(priceLabel.snp.right)
            make.width.equalToSuperview().dividedBy(4.5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        totalLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fillLabel)
            make.left.equalTo(fillLabel.snp.right)
             make.width.equalToSuperview().dividedBy(4.5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
      imageBtn.snp.makeConstraints { (make) in
        make.right.equalToSuperview().offset(-10)
        make.centerY.equalToSuperview()
        make.size.equalTo(20)
      }
    }

}

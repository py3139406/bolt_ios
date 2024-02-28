//
//  GeoFenceTableViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class GeoFenceTableViewCell: UITableViewCell {
    
    var geoFenceLabel: UILabel!
    var centerImageView: UIImageView!
    var geoFenceImageView: UIImageView!
   
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
        geoFenceLabel = UILabel(frame: CGRect.zero)
        geoFenceLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(geoFenceLabel)
        
        geoFenceImageView = UIImageView(frame: CGRect.zero)
        geoFenceImageView.contentMode = .center
        contentView.addSubview(geoFenceImageView)
        
        centerImageView = UIImageView(frame: CGRect.zero)
        centerImageView.contentMode = .center
        contentView.addSubview(centerImageView)
        
    }
    
    func addConstrains(){
        geoFenceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(13)
            make.centerY.equalTo(self)
            make.height.equalToSuperview().multipliedBy(0.45)
            make.width.equalToSuperview().multipliedBy(0.55)
            
        }
    
        geoFenceImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalToSuperview().multipliedBy(0.45)
            make.centerY.equalTo(self)
        }
        
        centerImageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.15)
            make.height.equalToSuperview().multipliedBy(0.45)
           // make.centerX.equalToSuperview()
            make.left.equalTo(geoFenceLabel.snp.right)
            make.centerY.equalToSuperview()
            
        }
    }
}

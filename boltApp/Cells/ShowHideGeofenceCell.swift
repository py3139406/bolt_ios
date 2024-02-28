//
//  ShowHideGeofenceCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ShowHideGeofenceCell: UITableViewCell {

    var geofenceName: UILabel!
    var geofenceImage: UIImageView!
    var onOffButton: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        addConstraints()
        self.backgroundColor = appDarkTheme
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        geofenceName = UILabel()
        geofenceName.text = "geofence name"
        geofenceName.textColor = .white
        geofenceName.adjustsFontSizeToFitWidth = true
        contentView.addSubview(geofenceName)
        
        geofenceImage = UIImageView()
        geofenceImage.contentMode = .scaleAspectFit
        contentView.addSubview(geofenceImage)
        
        onOffButton = UIButton()
        onOffButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
        contentView.addSubview(onOffButton)
    }
    
    private func addConstraints() {
        geofenceName.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        onOffButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        geofenceImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(onOffButton.snp.left).offset(-15)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }

}

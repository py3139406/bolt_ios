//
//  ShowHideGeofenceView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ShowHideGeofenceView: UIView {
    
    var selectAllLabel: UILabel!
    var selectButton: UIButton!
    var geofenceTable: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        selectAllLabel = UILabel()
        selectAllLabel.text = "Select All"
        selectAllLabel.textColor = .black
        selectAllLabel.adjustsFontSizeToFitWidth = true
        addSubview(selectAllLabel)
        
        selectButton = UIButton()
        selectButton.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
        addSubview(selectButton)
        
        geofenceTable = UITableView()
        geofenceTable.separatorColor = .black
        geofenceTable.separatorStyle = .singleLine
        geofenceTable.backgroundColor = appDarkTheme
        addSubview(geofenceTable)
    }
    
    private func addConstraint() {
        selectAllLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(self.frame.size.height * 0.1)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        selectButton.snp.makeConstraints { (make) in
            make.top.equalTo(selectAllLabel)
            make.right.equalToSuperview().offset(-15)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        geofenceTable.snp.makeConstraints { (make) in
            make.top.equalTo(selectAllLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

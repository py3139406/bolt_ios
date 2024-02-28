//
//  GeofenceSegmentGeofenceView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class GeofenceSegmentGeofenceView: UIView {

    var addButton: UIButton!
    var geoCell: GeoFenceTableViewCell!
    let reuseIdentifier = "geoCellId"
    var geoTableView:UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
        addButton = UIButton()
        addButton.backgroundColor = appGreenTheme
        addButton.setImage(#imageLiteral(resourceName: "addicon").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        addSubview(addButton)
        
        geoTableView  = UITableView(frame: CGRect.zero)
        geoTableView.separatorStyle = .singleLine
        geoTableView.separatorColor = .black
        geoTableView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        geoTableView.isScrollEnabled = true
        geoTableView.isUserInteractionEnabled = true
       
        // To uplift last row of table from buttom
        geoTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        
        geoCell = GeoFenceTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        geoTableView.register(GeoFenceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        geoTableView.rowHeight = 50.0
        geoTableView.bounces = false
        addSubview(geoTableView)
    
    }
    
    func addConstraints() -> Void {
        addButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.06)
            make.centerX.equalToSuperview()
        }
        
        geoTableView.snp.makeConstraints { (make) in
            make.top.equalTo(addButton.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
    

}

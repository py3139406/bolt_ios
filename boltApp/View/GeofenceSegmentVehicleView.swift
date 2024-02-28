//
//  GeofenceSegmentVehicleView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class GeofenceSegmentVehicleView: UIView {
    
    
    var searchButton: UIButton!
    var myTableView: UITableView!
    var image: UIImageView!
    var selectVehicleLabel: UITextField!
    var geoCell: GeoFenceTableViewCell!
    let reuseIdentifier = "geoVehicleCellId"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
        searchButton = UIButton()
        searchButton.showsTouchWhenHighlighted = true
        searchButton.backgroundColor = appGreenTheme
        searchButton.setImage(#imageLiteral(resourceName: "searchWhite").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        addSubview(searchButton)
        
        myTableView  = UITableView(frame: CGRect.zero)
        myTableView.separatorStyle = .singleLine
        myTableView.separatorColor = .black
     //   myTableView.backgroundColor = .white
        myTableView.separatorColor = .black
        myTableView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        
        myTableView.isScrollEnabled = true
        myTableView.isUserInteractionEnabled = true
        
        // To uplift last row of table from buttom
        myTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        
        geoCell = GeoFenceTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        myTableView.register(GeoFenceTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        myTableView.rowHeight = 60.0
        addSubview(myTableView)
        
        image = UIImageView(frame: CGRect.zero)
        image.image = #imageLiteral(resourceName: "car-wheel").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        image.backgroundColor = appDarkTheme
        image.contentMode = .center
        addSubview(image)
        
        selectVehicleLabel = UITextField(frame: CGRect.zero)
        selectVehicleLabel.backgroundColor = .white
        selectVehicleLabel.font = UIFont.systemFont(ofSize: 15)
        selectVehicleLabel.placeholder = "Select Vehicle".toLocalize
      
        selectVehicleLabel.leftView = UIView(frame: CGRect(x:0, y:0, width:15, height:self.selectVehicleLabel.frame.height))
        selectVehicleLabel.leftViewMode = UITextFieldViewMode.always
        selectVehicleLabel.allowsEditingTextAttributes = false
        addSubview(selectVehicleLabel)
    }
    
    func addConstraints() -> Void {
        
        image.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.height.width.equalTo(50)
            make.top.equalTo(self)
        }
        
        selectVehicleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(image.snp.right)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(image)
            make.top.equalTo(image)
        }
        searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(selectVehicleLabel.snp.bottom).offset(10)
            make.left.equalTo(image)
            make.right.equalTo(selectVehicleLabel.snp.right)
            make.height.equalTo(selectVehicleLabel)
            
        }
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchButton.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    
    
    
}


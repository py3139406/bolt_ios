//
//  EditVehicleInfoView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class EditVehicleInfoView: UIView {

    var searchBar: UISearchBar!
    var vehicleTable: UITableView!
    var addBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = appDarkTheme
        addElements()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addElements() {
        searchBar = UISearchBar()
        searchBar.barStyle = .blackOpaque
        searchBar.barTintColor = .white
        searchBar.placeholder = "Search Vehicle"
        searchBar.tintColor = appDarkTheme
//        searchBar.textColor = .black
        addSubview(searchBar)
        
        vehicleTable = UITableView()
        vehicleTable.backgroundColor = appDarkTheme
        vehicleTable.separatorColor = .black
        vehicleTable.separatorStyle = .singleLine
        vehicleTable.bounces = false
        addSubview(vehicleTable)
        
        addBtn =  UIButton(frame: CGRect.zero)
        addBtn.layer.cornerRadius = 27.5
        addBtn.showsTouchWhenHighlighted = true
        addBtn.layer.shadowColor = UIColor.black.cgColor
        addBtn.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        addBtn.layer.shadowRadius = 1.0
        addBtn.layer.shadowOpacity = 0.6
        addBtn.setImage(UIImage(named: "Asset 147-1"), for:.normal)
        addSubview(addBtn)
    }
    
    private func addConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        vehicleTable.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        addBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.05)
            make.size.equalTo(55)
        }
    }
    
}

//
//  EditVehicleInfoView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class LoadUnloadSelectVehicleView: UIView {
    
    var searchBar: UISearchBar!
    var vehicleTable: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addElements()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addElements() {
        searchBar = UISearchBar()
        searchBar.barStyle = .black
        searchBar.barTintColor = appDarkTheme
        searchBar.placeholder = "Search Vehicle"
        searchBar.tintColor = .white
        addSubview(searchBar)
        
        vehicleTable = UITableView()
        vehicleTable.backgroundColor = appDarkTheme
        vehicleTable.separatorColor = .black
        vehicleTable.bounces = false
        vehicleTable.separatorStyle = .singleLine
        addSubview(vehicleTable)
    }
    
    private func addConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        vehicleTable.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

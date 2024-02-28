//
//  TempCustomTableView.swift
//  Bolt
//
//  Created by Roadcast on 28/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class TempCustomTableView: UIView {
    var selectLbl:UILabel!
    var searchBar:UISearchBar!
    var selectAllBtn:UIButton!
    var deselectBtn:UIButton!
    var submitBtn:UIButton!
    var headView:UIView!
    var footView:UIView!
    var alertTable:UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addViews(){
        alertTable = UITableView()
        alertTable.backgroundColor = .clear
        alertTable.separatorStyle = .singleLineEtched
        alertTable.separatorColor = .lightGray
        alertTable.showsVerticalScrollIndicator = false
        alertTable.bounces = false
        alertTable.layer.cornerRadius = 5
        alertTable.layer.masksToBounds = true
        addSubview(alertTable)
        
        //v tableHeader
        headView = UIView()
        headView.backgroundColor = .white
        
        selectLbl = UILabel()
        selectLbl.text = "Select Vehicles"
        selectLbl.backgroundColor = appGreenTheme
        selectLbl.textAlignment = .center
        selectLbl.textColor = .white
        headView.addSubview(selectLbl)
        
        searchBar = UISearchBar()
        searchBar.barStyle = .blackTranslucent
        searchBar.barTintColor = .lightGray
        searchBar.placeholder = "Search"
        searchBar.layer.borderColor = appGreenTheme.cgColor
        searchBar.layer.borderWidth = 2
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.textColor = .black
            searchBar.searchTextField.backgroundColor = .lightGray
        } else {
            // Fallback on earlier versions
        }
        
        headView.addSubview(searchBar)
        
        selectAllBtn = UIButton()
        selectAllBtn.setTitle("Select all", for: .normal)
        selectAllBtn.setTitleColor(.black, for: .normal)
        selectAllBtn.backgroundColor = .white
        selectAllBtn.layer.borderWidth = 1
        selectAllBtn.layer.borderColor = UIColor.lightGray.cgColor
        headView.addSubview(selectAllBtn)
        
        deselectBtn = UIButton()
        deselectBtn.setTitle("Deselect all", for: .normal)
        deselectBtn.setTitleColor(.black, for: .normal)
        deselectBtn.backgroundColor = .white
        deselectBtn.layer.borderWidth = 1
        deselectBtn.layer.borderColor = UIColor.lightGray.cgColor
        headView.addSubview(deselectBtn)
        
        // footer View
        footView = UIView()
        footView.backgroundColor = .white
        
        submitBtn = UIButton()
        submitBtn.setTitle("SUBMIT", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.backgroundColor = appGreenTheme
        footView.addSubview(submitBtn)
    }
    private func addConstraints(){
        alertTable.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        selectLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(selectLbl.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        selectAllBtn.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(60)
        }
        deselectBtn.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.left.equalTo(selectAllBtn.snp.right)
            make.height.equalTo(selectAllBtn)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}

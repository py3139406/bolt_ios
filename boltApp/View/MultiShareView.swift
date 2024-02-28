//
//  MultiShareView.swift
//  Bolt
//
//  Created by Roadcast on 05/11/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class MultiShareView: UIView {
    var searchBar:UISearchBar!
    var multiShareTable:UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
        
    }
    private func addViews(){
        searchBar = UISearchBar(frame: CGRect.zero)
        searchBar.searchBarStyle = .minimal
       // searchBar.textColor = .white
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 5
        searchBar.placeholder = "Search Vehicle".toLocalize
        addSubview(searchBar)
        
        multiShareTable  = UITableView(frame: CGRect.zero)
        multiShareTable.backgroundColor = .white
        multiShareTable.separatorColor = UIColor.black
        multiShareTable.separatorStyle = .singleLine
        multiShareTable.bounces = false
        addSubview(multiShareTable)
    }
    private func addConstraints(){
        searchBar.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.top.equalToSuperview().offset(5)
            make.height.equalToSuperview().multipliedBy(0.06)
        }
        multiShareTable.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(screensize.height * 0.02)
            make.bottom.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

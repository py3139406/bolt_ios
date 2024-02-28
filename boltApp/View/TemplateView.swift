//
//  TemplateView.swift
//  Bolt
//
//  Created by Roadcast on 22/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class TemplateView: UIView {
    var tempTitle:UILabel!
  //  var searchBar:UISearchBar!
    var tempTable:UITableView!
    var plusBtn:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        addConstraints()
    }
    func addViews(){
        tempTitle = UILabel()
        tempTitle.text = "Templates"
        tempTitle.font = UIFont.boldSystemFont(ofSize: 20)
        tempTitle.textColor = .black
        addSubview(tempTitle)
//
//        searchBar = UISearchBar()
//        searchBar.barStyle = .blackTranslucent
//        searchBar.barTintColor = .lightGray
//        searchBar.placeholder = "Search"
//        searchBar.layer.cornerRadius = 5
//        searchBar.layer.masksToBounds = true
//        if #available(iOS 13.0, *) {
//            searchBar.searchTextField.textColor = .black
//            searchBar.searchTextField.backgroundColor = .lightGray
//        } else {
//            // Fallback on earlier versions
//        }
//
//        addSubview(searchBar)
        
        tempTable = UITableView()
        tempTable.backgroundColor = .white
        tempTable.separatorStyle = .none
        tempTable.bounces = false
        addSubview(tempTable)
        
        plusBtn = UIButton()
        plusBtn.setImage(UIImage(named:"addicon")?.resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        plusBtn.backgroundColor = appGreenTheme
        plusBtn.layer.cornerRadius = 30
        plusBtn.layer.masksToBounds = true
        addSubview(plusBtn)
        
    }
    func addConstraints(){
        tempTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()//.offset(screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.height.equalToSuperview().multipliedBy(0.06)
        }
//        searchBar.snp.makeConstraints { (make) in
//            make.centerY.equalTo(tempTitle)
//            make.right.equalToSuperview().offset(-screensize.width * 0.05)
//            make.width.equalToSuperview().multipliedBy(0.6)
//            make.height.equalToSuperview().multipliedBy(0.07)
//        }
        tempTable.snp.makeConstraints { (make) in
            make.top.equalTo(tempTitle.snp.bottom).offset(screensize.height * 0.01)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        plusBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-screensize.height * 0.03)
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
            make.size.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

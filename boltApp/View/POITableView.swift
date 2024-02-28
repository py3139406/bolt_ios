//
//  POIView.swift
//  Bolt
//
//  Created by Roadcast on 01/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit


class POITableView: UIView {
  
  var poiLabel : UILabel!
  var searchBar : UISearchBar!
  var poiTableView : UITableView!
  var kscreenheight = UIScreen.main.bounds.height
  var kscreenwidth = UIScreen.main.bounds.width
  var coverView: UIView!
  var viewData: UIView!
  let ScreenWidth = UIScreen.main.bounds.width
  let ScreenHeight = UIScreen.main.bounds.height

  override init(frame: CGRect) {
    super.init(frame: frame)
    //function call here
   
    addview()
    addconstraints()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addview() {
    
    coverView = UIView(frame: CGRect.zero)
    self.coverView.backgroundColor =  UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
     addSubview(coverView)
    
    viewData = UIView(frame: CGRect.zero)
    coverView.addSubview(viewData)
    
    poiLabel = UILabel(frame: CGRect.zero)
    poiLabel.text = "Select POI"
    poiLabel.backgroundColor = appGreenTheme
    poiLabel.font = UIFont.systemFont(ofSize: 24.0)
    poiLabel.textColor = .white
    poiLabel.textAlignment = .center
    viewData.addSubview(poiLabel)
    
    searchBar = UISearchBar(frame: CGRect.zero)
   searchBar.placeholder = "Search POI"
      viewData.addSubview(searchBar)
    
    poiTableView = UITableView(frame: CGRect.zero)
    poiTableView.showsVerticalScrollIndicator = false
    poiTableView.separatorStyle = .singleLine
    poiTableView.separatorColor = .black
    poiTableView.backgroundColor =  UIColor(red: 29/255, green: 28/255, blue: 42/255, alpha: 1.0)
    poiTableView.sectionIndexColor = .black
      viewData.addSubview(poiTableView)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

      //self.coverView.isHidden = true
     self.isHidden = true
    self.endEditing(true)
  }
  
  
  func addconstraints(){
    
    coverView.snp.makeConstraints { (make) in
      
      if #available(iOS 11.0, *) {
        
        make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(200)
        make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(-20)
        make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
        make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
           } else {

        make.bottom.top.left.right.equalToSuperview()//.offset//(-40)
             
           }
    }
    
    viewData.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(ScreenHeight * 0.05)
        make.left.equalToSuperview().offset(ScreenWidth * 0.15)
      make.width.equalTo(0.7 * ScreenWidth)
      make.height.equalTo(0.8 * ScreenHeight)
    }
    
    poiLabel.snp.makeConstraints{(make) in
      make.top.equalToSuperview()//.//offset(0.001 * kscreenheight)
      make.width.equalToSuperview()
      make.height.equalTo(0.08 * kscreenheight)
      
    }
    
    searchBar.snp.makeConstraints{(make) in
      make.top.equalTo(poiLabel.snp.bottom)//.offset(0.03 * kscreenheight)
      make.width.equalToSuperview()
      make.height.equalTo(0.06 * kscreenheight)
    }
    
    poiTableView.snp.makeConstraints{(make) in
      make.top.equalTo(searchBar.snp.bottom)//.offset(0.05 * kscreenheight)
      make.width.equalToSuperview()
      make.height.equalTo(0.5 * kscreenheight)
      
    }
  }
}


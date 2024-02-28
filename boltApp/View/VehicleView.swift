//
//  VehicleView.swift
//  Bolt
//
//  Created by Saanica Gupta on 31/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class VehicleView: UIView {
  
  var selectvehicleLabel : UILabel!
  var resultautoSearchController : UISearchBar!
  var vehicleTableView : UITableView!
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
    self.coverView.backgroundColor =   UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
     addSubview(coverView)
    
    viewData = UIView(frame: CGRect.zero)
    viewData.layer.cornerRadius = 10
    viewData.layer.masksToBounds = true
    viewData.backgroundColor = .white
    coverView.addSubview(viewData)
    
    selectvehicleLabel = UILabel(frame: CGRect.zero)
    selectvehicleLabel.text = "Select Vehicle"
    selectvehicleLabel.backgroundColor = appGreenTheme
    //selectvehicleLabel.adjustsFontSizeToFitWidth = true
    selectvehicleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    selectvehicleLabel.textColor = .white
    selectvehicleLabel.textAlignment = .center
      viewData.addSubview(selectvehicleLabel)
    
    resultautoSearchController = UISearchBar(frame: CGRect.zero)
    resultautoSearchController.autocorrectionType = .default
    resultautoSearchController.enablesReturnKeyAutomatically = true
    resultautoSearchController.contentMode = .scaleAspectFill
    resultautoSearchController.layer.cornerRadius = 0
    resultautoSearchController.layer.borderWidth = 2
    resultautoSearchController.layer.borderColor = UIColor.appGreen.cgColor
    viewData.addSubview(resultautoSearchController)
    
    vehicleTableView = UITableView(frame: CGRect.zero)
    vehicleTableView.showsVerticalScrollIndicator = false
    vehicleTableView.backgroundColor =  UIColor(red: 29/255, green: 28/255, blue: 42/255, alpha: 1.0)
    vehicleTableView.sectionIndexColor = .black
    vehicleTableView.separatorColor = .gray
     vehicleTableView.separatorStyle = .singleLineEtched
    vehicleTableView.bounces = false
      viewData.addSubview(vehicleTableView)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

      //self.coverView.isHidden = true
     self.isHidden = true
    self.endEditing(true)
  }
  
  
  func addconstraints(){
    
    coverView.snp.makeConstraints { (make) in
        make.edges.equalToSuperview()
    }
    viewData.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.width.equalTo(0.7 * ScreenWidth)
      make.height.equalTo(0.7 * ScreenHeight)
    }
    
    selectvehicleLabel.snp.makeConstraints{(make) in
      make.top.equalToSuperview()//.//offset(0.001 * kscreenheight)
      make.width.equalToSuperview()
     make.height.equalToSuperview().multipliedBy(0.1)
    }
    
    resultautoSearchController.snp.makeConstraints{(make) in
      make.top.equalTo(selectvehicleLabel.snp.bottom).offset(5)
        make.width.equalToSuperview().multipliedBy(0.9)
        make.centerX.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.08)
    }
    
    vehicleTableView.snp.makeConstraints{(make) in
      make.top.equalTo(resultautoSearchController.snp.bottom).offset(5)
      make.width.equalToSuperview()
     // make.height.equalTo(0.5 * kscreenheight)
        make.bottom.equalToSuperview()
      
    }
  }
}

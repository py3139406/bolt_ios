//
//  SubscriptionView.swift
//  Bolt
//
//  Created by Vivek Kumar on 30/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class SubscriptionView: UIView {
  var selectamountView: UIView!
  var selectedLabel: UILabel!
  var totalLabel: UILabel!
  var amountLabel: UILabel!
  var informationButton: UIButton!
  var proceedtopaymentButton: UIButton!
  var kscreenheight = UIScreen.main.bounds.height
  var kscreenwidth = UIScreen.main.bounds.width
  var selectedDeviceCount = 0
    
    var bgView: UIView!
   var renewalLabel: UILabel!
   var renewalinfoLabel: UILabel!
   var expiresubscriptionLabel : UILabel!
   var subscriptionamount: UILabel!
   var searchvehicleBar: UISearchBar!
   var subscriptionTableView: UITableView!
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addview()
    addconstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addview(){
    
    bgView = UIView(frame: CGRect.zero)
    bgView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
    addSubview(bgView)
    
    renewalLabel = UILabel(frame: CGRect.zero)
    renewalLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    renewalLabel.textColor = appGreenTheme
    renewalLabel.text = "RENEWAL"
    addSubview(renewalLabel)
    
    renewalinfoLabel = UILabel(frame: CGRect.zero)
    renewalinfoLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    renewalinfoLabel.text = "Renew your subscription & enjoy uninterrupted services for the next 365 days"
    renewalinfoLabel.textColor = .white
    renewalinfoLabel.numberOfLines = 2
    addSubview(renewalinfoLabel)
    
    expiresubscriptionLabel = UILabel(frame: CGRect.zero)
    expiresubscriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    //expiresubscriptionLabel.text = "Your \(deviceCount) are about to expire"
    expiresubscriptionLabel.textColor = .white
    bgView.addSubview(expiresubscriptionLabel)
    
    searchvehicleBar = UISearchBar(frame: CGRect.zero)
    searchvehicleBar.layer.cornerRadius = 10
    searchvehicleBar.layer.masksToBounds = true
    searchvehicleBar.placeholder = "Search Vehicle"
   // searchvehicleBar.searchBarStyle = .minimal
    searchvehicleBar.backgroundColor = .white
    bgView.addSubview(searchvehicleBar)
    
    
    subscriptionTableView = UITableView(frame: CGRect.zero)
    subscriptionTableView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
    subscriptionTableView.isScrollEnabled = true
    subscriptionTableView.separatorStyle = .singleLine
    subscriptionTableView.separatorColor = .black
    subscriptionTableView.bounces = false
    addSubview(subscriptionTableView)
    
    
    
    selectamountView = UIView(frame: CGRect.zero)
    selectamountView.backgroundColor = .black
    selectamountView.isUserInteractionEnabled = true
    addSubview(selectamountView)
    
    selectedLabel = UILabel(frame: CGRect.zero)
    selectedLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    selectedLabel.textColor = .white
    selectedLabel.text = "\(selectedDeviceCount) selected"
    selectamountView.addSubview(selectedLabel)
    
    totalLabel = UILabel(frame: CGRect.zero)
    totalLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    totalLabel.text = "Total :"
    totalLabel.textColor = .white
    selectamountView.addSubview(totalLabel)
    
    amountLabel = UILabel(frame: CGRect.zero)
    amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    amountLabel.text = "INR 0"
    amountLabel.adjustsFontSizeToFitWidth = true
    amountLabel.isUserInteractionEnabled = true
    amountLabel.textColor = .white
    selectamountView.addSubview(amountLabel)
    
    informationButton = UIButton(frame: CGRect.zero)
    informationButton.setImage(UIImage(named: "Artboard 36"), for: .normal)
    informationButton.contentMode = .scaleAspectFit
    informationButton.isUserInteractionEnabled = true
    selectamountView.addSubview(informationButton)
    
    proceedtopaymentButton = UIButton(frame: CGRect.zero)
    proceedtopaymentButton.backgroundColor = appGreenTheme
    proceedtopaymentButton.setTitle("PROCEED TO PAYMENT", for: .normal)
    proceedtopaymentButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    addSubview(proceedtopaymentButton)
  }
  
  func addconstraints(){
    
    renewalLabel.snp.makeConstraints{(make) in
        make.top.equalToSuperview().offset(10)
        make.left.equalToSuperview().offset(20)
    }
    
    renewalinfoLabel.snp.makeConstraints{(make) in
      make.top.equalTo(renewalLabel.snp.bottom).offset(0.012 * kscreenheight)
      make.width.equalToSuperview().multipliedBy(0.85)
      make.left.equalTo(renewalLabel)
    }
    bgView.snp.makeConstraints { (make) in
        make.top.equalTo(renewalinfoLabel.snp.bottom).offset(12)
        make.width.equalToSuperview()
        make.height.equalToSuperview().multipliedBy(0.15)
    }
    
    expiresubscriptionLabel.snp.makeConstraints{(make) in
        make.top.equalToSuperview().offset(10)
        make.left.equalToSuperview().offset(20)
        make.height.equalToSuperview().multipliedBy(0.3)
    }
    
    searchvehicleBar.snp.makeConstraints{(make) in
        make.top.equalTo(expiresubscriptionLabel.snp.bottom).offset(10)
        make.width.equalToSuperview().multipliedBy(0.9)
        make.centerX.equalToSuperview()
        make.height.equalToSuperview().multipliedBy(0.5)
    }
    
    subscriptionTableView.snp.makeConstraints{(make) in
      make.top.equalTo(bgView.snp.bottom)
      make.width.equalToSuperview()
      make.bottom.equalTo(selectamountView.snp.top)
    }
    
    selectamountView.snp.makeConstraints{(make) in
      make.width.equalToSuperview()
      make.height.equalTo(0.08 * kscreenheight)
      make.bottom.equalTo(proceedtopaymentButton.snp.top)
    }
    
    selectedLabel.snp.makeConstraints{(make) in
      make.centerY.equalToSuperview()
      make.left.equalTo(0.04 * kscreenwidth)
    }
    
    totalLabel.snp.makeConstraints{(make) in
      make.centerY.equalToSuperview()
     // make.left.equalTo(selectedLabel.snp.right).offset(0.35 * kscreenwidth)
        make.right.equalTo(amountLabel.snp.left).offset(-2)
    }
    
    amountLabel.snp.makeConstraints{(make) in
      make.centerY.equalToSuperview()
      //make.left.equalTo(totalLabel.snp.right).offset(0.005 * kscreenwidth)
      //make.width.equalTo(0.4 * kscreenwidth)
      make.right.equalTo(informationButton.snp.left).offset(-0.02 * kscreenwidth)
    }
    
    informationButton.snp.makeConstraints{(make) in
      make.centerY.equalToSuperview()
      make.height.equalTo(20) //0.035 * kscreenheight
      make.width.equalTo(20) //0.052 * kscreenwidth
      make.right.equalTo(-10) //-0.04 * kscreenwidth
    }
    
    proceedtopaymentButton.snp.makeConstraints{(make) in
      make.bottom.equalToSuperview()//.offset(-0.02 * kscreenheight)
      make.width.equalToSuperview()
      make.height.equalTo(0.06 * kscreenheight)
    }
  }
}


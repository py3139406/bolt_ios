//
//  NearByPlacesView.swift
//  Bolt
//
//  Created by Saanica Gupta on 24/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class NearByPlacesView: UIView {
  
  var topView: UIView!
  var nearbyplaceLabel: UILabel!
  var nearbyplaceImageView: UIImageView!
  var nearbyplaceTableView: UITableView!
  var backbutton: UIButton!
  var kscreenheight = UIScreen.main.bounds.height
  var kscreenwidth = UIScreen.main.bounds.width
  // to show background color black when view appers on screen
  //    var navBar:UINavigationBar!

  override init(frame: CGRect) {
    super.init(frame: frame)
    addallinone()
    addConstrainsts()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addallinone(){
    
    topView = UIView(frame: CGRect.zero)
    topView.backgroundColor = .white
    addSubview(topView)
    
    nearbyplaceLabel = UILabel(frame: CGRect.zero)
    nearbyplaceLabel.text = "Nearby Places".toLocalize
    nearbyplaceLabel.textColor = .black
    nearbyplaceLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
    topView.addSubview(nearbyplaceLabel)
    
    nearbyplaceImageView = UIImageView()
    nearbyplaceImageView.image = #imageLiteral(resourceName: "Nearby")
    nearbyplaceImageView.contentMode = .scaleAspectFit
    topView.addSubview(nearbyplaceImageView)
    
    backbutton = UIButton(frame: CGRect.zero)
    
    backbutton.setImage(#imageLiteral(resourceName: "backimg.png"), for: .normal)
    backbutton.contentMode = .scaleAspectFit
    topView.addSubview(backbutton)
    
    nearbyplaceTableView = UITableView()
    nearbyplaceTableView.separatorStyle = .none
    nearbyplaceTableView.separatorColor = .black
    nearbyplaceTableView.backgroundColor =  appDarkTheme
    nearbyplaceTableView.sectionIndexColor = .black
    addSubview(nearbyplaceTableView)
  }
  
  func addConstrainsts(){
    
    topView.snp.makeConstraints { (make) in
      //make.top.equalToSuperview().offset(70)
      if #available(iOS 11, *){
        make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
      } else {
        make.top.equalToSuperview().offset(70)
      }
      //make.centerX.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(kscreenheight * 0.08)
    }
    
    nearbyplaceImageView.snp.makeConstraints { (make) in
      //make.top.equalTo(userSelection.snp.bottom).offset(10)
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().offset(-15)
      make.width.equalTo(0.1 * kscreenwidth)
      make.height.equalTo(0.08 * kscreenheight)
    }
    nearbyplaceLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    backbutton.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(15)
      make.height.equalTo(23)
      make.width.equalTo(20)
    }
    
    nearbyplaceTableView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.right.equalToSuperview()
      make.top.equalTo(topView.snp.bottom).offset(1)
      make.height.equalTo(0.8 * kscreenheight)
      // make.bottom.equalToSuperview()
    }
  }
}

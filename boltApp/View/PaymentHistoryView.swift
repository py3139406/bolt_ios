//
//  PaymentHistoryView.swift
//  Bolt
//
//  Created by Saanica Gupta on 02/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PaymentHistoryView: UIView {
    
    var appDarkTheme = UIColor(red: 38/255, green: 39/255, blue: 58/255, alpha: 1.0)
    
//    var topView: UIView!
//    var paymenthistoryLabel: UILabel!
//    var paymenthistoryImageView: UIImageView!
    var paymenthistoryTableView: UITableView!
  //  var backbutton: UIButton!
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
    
    
    
    func addallinone()
    {
//        topView = UIView(frame: CGRect.zero)
//        topView.backgroundColor = .white
//        addSubview(topView)
//
//        paymenthistoryLabel = UILabel(frame: CGRect.zero)
//        paymenthistoryLabel.textColor = .black
//        paymenthistoryLabel.text = " Payment History"
//        paymenthistoryLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
//        topView.addSubview(paymenthistoryLabel)
//
//        paymenthistoryImageView = UIImageView()
//        paymenthistoryImageView.image = #imageLiteral(resourceName: "002-smartphone.png")
//        paymenthistoryImageView.contentMode = .scaleAspectFit
//        topView.addSubview(paymenthistoryImageView)
        
//        backbutton = UIButton(frame: CGRect.zero)
//        backbutton.setImage(UIImage(named: "back"), for: .normal)
//        backbutton.contentMode = .scaleAspectFit
//        topView.addSubview(backbutton)
        
        
        paymenthistoryTableView = UITableView()
        paymenthistoryTableView.separatorStyle = .singleLine
        paymenthistoryTableView.separatorColor = .black
       // paymenthistoryTableView.backgroundColor = appDarkTheme
      //  paymenthistoryTableView.sectionIndexColor = .black
        addSubview(paymenthistoryTableView)
    }
    
    func addConstrainsts(){
//
//        topView.snp.makeConstraints { (make) in
//            //make.top.equalToSuperview().offset(70)
//            if #available(iOS 11, *){
//                make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
//            } else {
//                make.top.equalToSuperview().offset(70)
//            }
//            //make.centerX.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(kscreenheight * 0.08)
//        }
//
//        paymenthistoryImageView.snp.makeConstraints { (make) in
//            //make.top.equalTo(userSelection.snp.bottom).offset(10)
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().offset(-15)
//            make.width.equalTo(0.1 * kscreenwidth)
//            make.height.equalTo(0.08 * kscreenheight)
//        }
//        paymenthistoryLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//
//        }
        
        
//        backbutton.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(15)
//            make.height.equalTo(23)
//            make.width.equalTo(20)
//        }
        
        paymenthistoryTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.top.equalTo(topView.snp.bottom).offset(1)
//            make.height.equalTo(0.8 * kscreenheight)
            // make.bottom.equalToSuperview()
        }
    }
}


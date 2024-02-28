//
//  NotificationView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class NotificationView: UIView {
    var headerView: UIView!
   // var filterLabel: UILabel!
  //  var filterView: UIView!
    var headerLabel: UILabel!
    var vehicleTextField: UITextField!
    var filterButton: UIButton!
    var myTableView: UITableView!
    var customCell: NotificationTableViewCell!
    var segmentView:UIView!
    var segmentControl:UISegmentedControl!
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTableView()
        addconstrants()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addTableView() {
        segmentView = UIView(frame: CGRect.zero)
        segmentView.backgroundColor =  .black
        addSubview(segmentView)

        vehicleTextField = UITextField()
        vehicleTextField.borderStyle = .roundedRect
        vehicleTextField.attributedPlaceholder = NSAttributedString(string: "Select Vehicle".toLocalize,
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        vehicleTextField.textAlignment = .center
        vehicleTextField.clearButtonMode = .whileEditing
        //vehicleTextField.text = "All vehicles"
        vehicleTextField.textColor = .black
        segmentView.addSubview(vehicleTextField)

        
        headerView = UIView(frame: CGRect.zero)
        headerView.backgroundColor = .white
        addSubview(headerView)
        
        headerLabel = UILabel.init(frame: CGRect.zero)
        headerLabel.text = "Notifications".toLocalize
        headerLabel.textColor = .black
        headerLabel.font = UIFont.systemFont(ofSize: 30, weight: .thin)
        headerView.addSubview(headerLabel)
        
        
        
//        filterView = UIView(frame: CGRect.zero)
//        filterView.backgroundColor = .white
//        filterView.layer.cornerRadius = 2
//        filterView.layer.masksToBounds = true
//        headerView.addSubview(filterView)
        
        
        myTableView  = UITableView(frame: CGRect.zero)
        myTableView.separatorStyle = .singleLine
        myTableView.backgroundColor = appDarkTheme
        myTableView.isScrollEnabled = true
        myTableView.allowsSelection = false
        myTableView.separatorColor = .black
        myTableView.showsVerticalScrollIndicator = true
        myTableView.separatorStyle = .singleLine
        customCell = NotificationTableViewCell(style: .default, reuseIdentifier: "notification")
        myTableView.rowHeight = 70.0
        addSubview(myTableView)
        
//        filterLabel = UILabel(frame: CGRect.zero)
//        filterLabel.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
//        filterLabel.text = "Filter"
//        filterLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
//        filterLabel.textColor = .black
//        filterLabel.textAlignment = .center
//        filterView.addSubview(filterLabel)
        //
        filterButton = UIButton()
//        if let myImage = UIImage(named: "funnel") {
//            myImage.resizedImage(CGSize(width: 10, height: 10), interpolationQuality: .default)
//            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
//            filterButton.setImage(tintableImage , for: .normal)
//        }
        filterButton.setImage(UIImage(named: "Filter@72x"), for: .normal)
        filterButton.contentMode = .scaleToFill
       // filterButton.backgroundColor = .white
        filterButton.addShadow()
        headerView.addSubview(filterButton)
        
        segmentControl = UISegmentedControl(items: ["NOTIFICATIONS", "ANNOUNCEMENTS"])
        segmentControl.backgroundColor = .white
        segmentControl.selectedSegmentIndex = 0
        segmentControl.tintColor = appGreenTheme
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = appGreenTheme
        } else {
            // Fallback on earlier versions
            segmentControl.tintColor = appGreenTheme
        }
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: appGreenTheme], for: .disabled)
        segmentControl.layer.cornerRadius = 5
        segmentControl.layer.masksToBounds = true

        segmentView.addSubview(segmentControl)
    }
    
    func addconstrants(){
        
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.10 * kscreenheight)

            
        }
        headerLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(0.06 * kscreenwidth)
        }
        filterButton.snp.makeConstraints{(make) in
           // make.left.equalTo(headerLabel.snp.right).offset(0.14 * kscreenwidth)
            make.right.equalToSuperview().offset(-0.06 * kscreenwidth)
//            make.height.equalToSuperview().multipliedBy(0.25)
            make.centerY.equalToSuperview()
//            make.width.equalTo(0.20 * kscreenwidth)
            make.width.equalTo(86)
             make.height.equalTo(30)
        }
//        filterButton.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()//.offset(0.00 * kscreenwidth)
//            make.height.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.4)
//        }
//        filterLabel.snp.makeConstraints{(make) in
//            make.left.equalTo(filterButton.snp.right)//.offset(0.0 * kscreenwidth)
//            make.centerY.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.6)
//            make.height.equalToSuperview()
//        }
        segmentView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)//.offset(1)
            make.width.equalToSuperview()
            make.height.equalTo(0.15 * kscreenheight)
        }
        segmentControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        vehicleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(segmentControl.snp.bottom).offset(0.02 * kscreenheight)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentView.snp.bottom)//.offset(0.01 * kscreenheight)
            make.left.width.equalToSuperview()
            make.bottom.equalToSuperview()

        }
    }
    
    
}

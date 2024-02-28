//
//  ImmobilizeView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited


import UIKit
import SnapKit

class ImmobilizeView: UIView {
  
   var bluetoothLabel: UILabel!
  var bluetoothImg: UIImageView!
  var newIconImg:UIImageView!
  var topView:UIView!
  var segmentedController: UISegmentedControl!
  var searchBar: UISearchBar!
   var textfieldBackgroundView: UIView!
  var immobilizeAllLabel: UILabel!
  var immobilizeAllButton: UIImageView!
   var tableView: UITableView!
  //  weak var selectVehicleLabel: UILabel!
   var tableCell: RCImmobilizeTableViewCell!
  var immobiliseBluetoothView: UIView!
  var immobiliseBluetoothBtn: UIButton!
  var immobilizeLabel: UILabel!
    let screenSize = UIScreen.main.bounds.size
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addviews()
    addConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    func addviews(){
        
        textfieldBackgroundView = UIView()
        textfieldBackgroundView.backgroundColor = appDarkTheme
        textfieldBackgroundView.contentMode = .scaleAspectFit
        textfieldBackgroundView.isUserInteractionEnabled = true
        addSubview(textfieldBackgroundView)
        
        segmentedController = UISegmentedControl(items: ["MOBILIZED", "IMMOBILIZED"])
        segmentedController.selectedSegmentIndex = 0
        segmentedController.backgroundColor = .white
        if #available(iOS 13.0, *) {
            segmentedController.selectedSegmentTintColor = appGreenTheme
        } else {
            // Fallback on earlier versions
            segmentedController.tintColor = appGreenTheme
        }
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: appGreenTheme], for: .disabled)

        segmentedController.layer.cornerRadius = 5
        segmentedController.layer.masksToBounds = true
        textfieldBackgroundView.addSubview(segmentedController)
        
        searchBar = UISearchBar()
        searchBar.placeholder = "search vehicle"
//        searchBar.textColor = appGreenTheme
        searchBar.barTintColor = .white
        searchBar.tintColor = .black
        //searchBar.contentMode = .scaleToFill
        textfieldBackgroundView.addSubview(searchBar)
        
        immobilizeAllLabel = UILabel()
        immobilizeAllLabel.text = "Immobilize all vehicles"
        immobilizeAllLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        immobilizeAllLabel.textColor = appGreenTheme
        textfieldBackgroundView.addSubview(immobilizeAllLabel)
        
        immobilizeAllButton = UIImageView()
        immobilizeAllButton.image = UIImage(named: "Asset 53")
        immobilizeAllButton.contentMode = .scaleAspectFit
        immobilizeAllButton.backgroundColor = appDarkTheme
        immobilizeAllButton.isUserInteractionEnabled = true
        textfieldBackgroundView.addSubview(immobilizeAllButton)
        
        topView = UIView()
        topView.backgroundColor = .white
        topView.isUserInteractionEnabled = true
        addSubview(topView)
        
        bluetoothLabel = UILabel()
        bluetoothLabel.text = "Mobilize/immobilize via. Bluetooth".toLocalize
        bluetoothLabel.numberOfLines = 2
        bluetoothLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        topView.addSubview(bluetoothLabel)
        
        bluetoothImg = UIImageView()
        bluetoothImg.image = UIImage(named: "blue")
        bluetoothImg.contentMode = .scaleAspectFit
        topView.addSubview(bluetoothImg)
        
        newIconImg = UIImageView()
        newIconImg.image = #imageLiteral(resourceName: "new label")
        newIconImg.contentMode = .scaleAspectFit
        topView.addSubview(newIconImg)
        
        tableView = UITableView.init(frame: CGRect.zero)
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.rowHeight = 40
        tableView.bounces = false
        tableView.separatorColor = UIColor(red: 238/255, green: 239/255, blue: 240/255, alpha: 1)
        tableView.separatorStyle = .singleLineEtched
        addSubview(tableView)
    }

  func addConstraints() ->  Void{
    topView.snp.makeConstraints { (make) in
      if #available(iOS 11, *){
        make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
      }else{
        make.top.equalToSuperview().offset(70)
      }
      make.width.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.08)
    }
     bluetoothImg.snp.makeConstraints { (make) in
       // make.top.equalToSuperview()
        make.left.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
        make.width.equalToSuperview().multipliedBy(0.1)
        make.height.equalToSuperview().multipliedBy(0.6)
    }
     newIconImg.snp.makeConstraints { (make) in
        make.top.equalToSuperview()
        make.right.equalToSuperview()
        make.width.equalToSuperview().multipliedBy(0.15)
        make.height.equalToSuperview().multipliedBy(0.95)
    }
     bluetoothLabel.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(5)
        make.left.equalTo(bluetoothImg.snp.right).offset(5)
        make.centerY.equalToSuperview()
    }

    segmentedController.snp.makeConstraints { (make) in
        make.top.equalToSuperview().offset(screenSize.height * 0.01)
      make.centerX.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.20)
      make.width.equalToSuperview().multipliedBy(0.95)
    }
    
    textfieldBackgroundView.snp.makeConstraints { (make) in
      make.width.equalToSuperview()
      make.top.equalTo(topView.snp.bottom)
      make.height.equalToSuperview().multipliedBy(0.25)
      make.centerX.equalToSuperview()
    }
    
    searchBar.snp.makeConstraints { (make) in
        make.top.equalTo(segmentedController.snp.bottom).offset(screenSize.height * 0.02)
      make.centerX.equalToSuperview()
        make.width.equalToSuperview().multipliedBy(0.95)
      make.height.equalToSuperview().multipliedBy(0.21)
    }
    
    immobilizeAllLabel.snp.makeConstraints { (make) in
     // make.top.equalTo(searchBar.snp.bottom).offset(10)
      make.left.equalToSuperview().offset(20)
      make.width.equalToSuperview().offset(-20)
      make.bottom.equalToSuperview().offset(-screenSize.height * 0.03)
    }
    
    immobilizeAllButton.snp.makeConstraints { (make) in
     // make.centerY.equalTo(immobilizeAllLabel)
     // make.height.equalToSuperview().multipliedBy(0.2)
        make.right.equalToSuperview().offset(-30)
        make.bottom.equalToSuperview().offset(-screenSize.height * 0.03)
        make.size.equalTo(30)
      //make.width.equalTo(immobilizeAllButton.snp.height)
    }
    
    tableView.snp.makeConstraints { (make) in
      make.width.equalToSuperview()
      make.top.equalTo(textfieldBackgroundView.snp.bottom)
      make.bottom.equalToSuperview().offset(-10)
      make.centerX.equalToSuperview()
    }
  }
  
}



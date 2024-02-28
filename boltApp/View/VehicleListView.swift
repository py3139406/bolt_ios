//
//  VehicleListView.swift
//  Bolt
//
//  Created by Roadcast on 05/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class VehicleListView: UIView {
    var userListView:UIView!
    var listLbl:UILabel!
    var listImg:UIImageView!
    var bgView:UIView!
    var hStackView:UIStackView!
    var vStackView:UIStackView!
    var ignitionOnView:UIView!
    var ignitionOnLabel:UILabel!
    var ignitionOnImg:UIImageView!
    
    var ignitionOffView:UIView!
    var ignitionOffLabel:UILabel!
    var ignitionOffImg:UIImageView!
    
    var inactiveView:UIView!
    var inactiveLabel:UILabel!
    var inactiveImg:UIImageView!
    
    var offlineView:UIView!
    var offlineLabel:UILabel!
    var offlineImg:UIImageView!
    
    var searchBar:UITextField!
    var viewAllBtn:UIButton!
    
    var vehicleTable:UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViews(){
        userListView = UIView()
        userListView.backgroundColor = .white
        addSubview(userListView)
        
        listLbl = UILabel()
        listLbl.textColor = appGreenTheme
        listLbl.adjustsFontSizeToFitWidth = true
        listLbl.textAlignment = .center
        userListView.addSubview(listLbl)
        
        listImg = UIImageView()
        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "backimg")!, deg: -90)
        listImg.image  = img
        listImg.contentMode = .scaleAspectFill
        userListView.addSubview(listImg)
        
        ignitionOnView = UIView()
        ignitionOnView.backgroundColor = .black
        ignitionOnView.layer.cornerRadius = screensize.height * 0.02
        ignitionOnView.layer.masksToBounds = true
        // bgView.addSubview(ignitionOnView)
        
        ignitionOnLabel = UILabel()
        ignitionOnLabel.textColor = .white
        ignitionOnLabel.text = "0"
        ignitionOnLabel.adjustsFontForContentSizeCategory = true
        ignitionOnLabel.textAlignment = .right
        ignitionOnLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        ignitionOnView.addSubview(ignitionOnLabel)
        
        ignitionOnImg = UIImageView()
        ignitionOnImg.image = UIImage(named: "ignitionOn")
        ignitionOnImg.contentMode = .scaleAspectFit
        ignitionOnView.addSubview(ignitionOnImg)
        
        ignitionOffView = UIView()
        ignitionOffView.backgroundColor = .black
        ignitionOffView.layer.cornerRadius = screensize.height * 0.02
        ignitionOffView.layer.masksToBounds = true
        // bgView.addSubview(ignitionOffView)
        
        ignitionOffLabel = UILabel()
        ignitionOffLabel.textColor = .white
        ignitionOffLabel.text = "0"
        ignitionOffLabel.adjustsFontForContentSizeCategory = true
        ignitionOffLabel.textAlignment = .right
        ignitionOffLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        ignitionOffView.addSubview(ignitionOffLabel)
        
        ignitionOffImg = UIImageView()
        ignitionOffImg.image = #imageLiteral(resourceName: "Asset 69")
        ignitionOffImg.contentMode = .scaleAspectFit
        ignitionOffView.addSubview(ignitionOffImg)
        
        inactiveView = UIView()
        inactiveView.backgroundColor = .black
        inactiveView.layer.cornerRadius = screensize.height * 0.02
        inactiveView.layer.masksToBounds = true
        // bgView.addSubview(inactiveView)
        
        inactiveLabel = UILabel()
        inactiveLabel.textColor = .white
        inactiveLabel.text = "0"
        inactiveLabel.adjustsFontForContentSizeCategory = true
        inactiveLabel.textAlignment = .right
        inactiveLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        inactiveView.addSubview(inactiveLabel)
        
        inactiveImg = UIImageView()
        inactiveImg.image = UIImage(named: "inactive")
        inactiveImg.contentMode = .scaleAspectFit
        inactiveView.addSubview(inactiveImg)
        
        offlineView = UIView()
        offlineView.backgroundColor = .black
        offlineView.layer.cornerRadius = screensize.height * 0.02
        offlineView.layer.masksToBounds = true
        //bgView.addSubview(offlineView)
        
        offlineLabel = UILabel()
        offlineLabel.textColor = .white
        offlineLabel.text = "0"
        offlineLabel.adjustsFontForContentSizeCategory = true
        offlineLabel.textAlignment = .right
        offlineLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        offlineView.addSubview(offlineLabel)
        
        offlineImg = UIImageView()
        offlineImg.image = UIImage(named: "offline")
        offlineImg.contentMode = .scaleAspectFit
        offlineView.addSubview(offlineImg)
        
        searchBar = UITextField()
        searchBar.setLeftPaddingPoints(20)
        searchBar.backgroundColor = .white
        searchBar.textColor = .black
        searchBar.layer.cornerRadius = 5
        searchBar.placeholder = "Search Vehicles"
        searchBar.layer.masksToBounds = true
        // bgView.addSubview(searchBar)
        
        viewAllBtn = UIButton()
        viewAllBtn.backgroundColor = appGreenTheme
        viewAllBtn.layer.cornerRadius = 5
        viewAllBtn.layer.masksToBounds = true
        viewAllBtn.setTitle("VIEW ALL VEHICLES (0)", for: .normal)
        viewAllBtn.setTitleColor(.white, for: .normal)
        viewAllBtn.titleLabel?.textAlignment = .center
        viewAllBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        viewAllBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        //bgView.addSubview(viewAllBtn)
        
        hStackView = UIStackView()
        hStackView.alignment = .center
        hStackView.axis = .horizontal
        hStackView.distribution = .equalSpacing
        hStackView.addArrangedSubview(ignitionOnView)
        hStackView.addArrangedSubview(ignitionOffView)
        hStackView.addArrangedSubview(inactiveView)
        hStackView.addArrangedSubview(offlineView)
        
        vStackView = UIStackView()
        vStackView.alignment = .center
        vStackView.axis = .vertical
        vStackView.spacing = 20
        vStackView.distribution = .equalSpacing
        vStackView.addArrangedSubview(hStackView)
        vStackView.addArrangedSubview(searchBar)
        vStackView.addArrangedSubview(viewAllBtn)
        
        bgView = UIView()
        bgView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1)
        addSubview(bgView)
        bgView.addSubview(vStackView)
        
        vehicleTable = UITableView()
        vehicleTable.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        vehicleTable.separatorStyle = .none
        addSubview(vehicleTable)
        
    }
    func setConstraints(){
        userListView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        listImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        listLbl.snp.makeConstraints { (make) in
            make.left.equalTo(listImg.snp.right).offset(10)
            make.right.equalToSuperview().offset(-55)
            make.height.equalToSuperview()
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(userListView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        vStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.01)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-screensize.height * 0.02)
        }
        hStackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        ignitionOnView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.22)
            make.height.equalToSuperview()//.multipliedBy(0.18)
        }
        ignitionOnImg.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.01)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        ignitionOnLabel.snp.makeConstraints { (make) in
            make.right.equalTo(ignitionOnView.snp.centerX)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        ignitionOffView.snp.makeConstraints { (make) in
            make.size.equalTo(ignitionOnView)
        }
        ignitionOffImg.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.01)
            make.centerY.equalToSuperview()
            make.size.equalTo(ignitionOnImg)
        }
        ignitionOffLabel.snp.makeConstraints { (make) in
            make.right.equalTo(ignitionOffView.snp.centerX)
            make.centerY.equalToSuperview()
        }
        inactiveView.snp.makeConstraints { (make) in
            make.size.equalTo(ignitionOnView)
        }
        inactiveImg.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.01)
            make.centerY.equalToSuperview()
            make.size.equalTo(ignitionOnImg)
        }
        inactiveLabel.snp.makeConstraints { (make) in
            make.right.equalTo(inactiveView.snp.centerX)
            make.centerY.equalToSuperview()
        }
        offlineView.snp.makeConstraints { (make) in
            make.size.equalTo(ignitionOnView)
        }
        offlineImg.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.01)
            make.centerY.equalToSuperview()
            make.size.equalTo(ignitionOnImg)
        }
        offlineLabel.snp.makeConstraints { (make) in
            make.right.equalTo(offlineView.snp.centerX)
            make.centerY.equalToSuperview()
        }
        searchBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        viewAllBtn.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.22)
        }
        vehicleTable.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

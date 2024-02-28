//
//  AppSettingView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class AppSettingView: UIView {

//    var appSettingLabel: UILabel!
//    var settingImage: UIImageView!
    var settingMenuView: UITableView!
    var settingMenu: AppSettingViewCell!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTableView()
        addConstriants()
    }
    
    func addTableView(){
        settingMenuView = UITableView()
        settingMenuView.separatorStyle = .singleLineEtched
        settingMenuView.separatorColor = .black
//        settingMenuView.separatorStyle = .none
//        settingMenuView.separatorColor = .blue
        settingMenuView.backgroundColor =  UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
        settingMenuView.sectionIndexColor = .black
        settingMenuView.allowsSelection = true
        settingMenuView.bounces = false
        addSubview(settingMenuView)
    }
    
    
    func addConstriants(){

        settingMenuView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
//            make.top.equalToSuperview()
//            make.bottom.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }
}

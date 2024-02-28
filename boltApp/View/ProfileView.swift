//
//  ProfileView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ProfileView: UIView {
    
    var topViewContainer:UIView!
    var topTitle:UILabel!
    var profileimv: UIImageView!
    var profileTableView:UITableView!
    var deleteAccountBtn: UIButton!
    

    override init(frame: CGRect) {
       super.init(frame: frame)
        self.backgroundColor = appDarkTheme
        setUpView()
        addConstaraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }
    
    func setUpView() {
        topViewContainer = UIView(frame: CGRect.zero)
        topViewContainer.backgroundColor = .white
        addSubview(topViewContainer)
        
        topTitle = UILabel(frame: CGRect.zero)
        topTitle.text = "Profile".toLocalize
        topTitle.textColor = .black
        topTitle.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        topTitle.adjustsFontSizeToFitWidth = true
        topViewContainer.addSubview(topTitle)
        
        profileimv = UIImageView(frame: CGRect.zero)
        profileimv.contentMode = .center
        profileimv.image = #imageLiteral(resourceName: "profilepic")
        topViewContainer.addSubview(profileimv)
        
        profileTableView  = UITableView(frame: CGRect.zero)
        profileTableView.separatorStyle = .singleLineEtched
        profileTableView.separatorColor = .black 
        profileTableView.layer.backgroundColor = UIColor.clear.cgColor
        profileTableView.backgroundColor = appDarkTheme
        profileTableView.bounces = false
        addSubview(profileTableView)
        
        deleteAccountBtn = UIButton(frame: CGRect.zero)
        deleteAccountBtn.setTitle("DELETE ACCOUNT", for: .normal)
        deleteAccountBtn.setTitleColor(.white, for: .normal)
        deleteAccountBtn.backgroundColor = appGreenTheme
        deleteAccountBtn.layer.masksToBounds = true
        deleteAccountBtn.layer.cornerRadius = 4
        addSubview(deleteAccountBtn)
    }
    
    func addConstaraints() {
        topViewContainer.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            if #available(iOS 11, *){
                make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            }else{
                make.top.equalTo(self).offset(60)
            }
            make.height.equalTo(self).multipliedBy(0.10)
            make.width.equalTo(self)
        }
        
        topTitle.snp.makeConstraints { (make) in
            make.left.equalTo(topViewContainer).offset(30)
            make.centerY.equalTo(topViewContainer)
            make.height.equalToSuperview().multipliedBy(0.6)
            
        }
        profileimv.snp.makeConstraints { (make) in
            make.centerY.equalTo(topTitle)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(topTitle)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        deleteAccountBtn.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(45)
            make.width.equalTo(250)
        }
        
        profileTableView.snp.makeConstraints { (make) in
        make.left.right.equalToSuperview()
        make.top.equalTo(topViewContainer.snp.bottom)
        make.bottom.equalTo(deleteAccountBtn.snp.top)
        }
    }
}

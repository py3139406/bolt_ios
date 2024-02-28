//
//  SMSCommandView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class SMSCommandView: UIView {

    var smsLabel: RCLabel!
    var smsImage: UIImageView!
    var configurationTableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addlabel()
        addImage()
        addTableView()
        addConstraints()
    }
    
    func addlabel(){
        smsLabel = RCLabel(frame: CGRect.zero)
        smsLabel.text = "Configuration".toLocalize
        smsLabel.textColor = .black
        smsLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        smsLabel.adjustsFontSizeToFitWidth = true
        addSubview(smsLabel)
    }
    
    func addImage(){
        smsImage = UIImageView()
        smsImage.image = #imageLiteral(resourceName: "SMS command").resizedImage(CGSize.init(width: 35, height: 35), interpolationQuality: .default)
        smsImage.contentMode = .scaleAspectFit
        addSubview(smsImage)
    }
    
    func addTableView(){
        configurationTableView = UITableView()
        configurationTableView.separatorStyle = .singleLine
        configurationTableView.separatorColor = .black
        configurationTableView.backgroundColor =  UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        configurationTableView.sectionIndexColor = .black
        configurationTableView.allowsSelection = true
        configurationTableView.bounces = false
        addSubview(configurationTableView)
    }
    
    func addConstraints(){
        smsLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *){
                make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
            }else{
                make.top.equalToSuperview().offset(70)
            }
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        smsImage.snp.makeConstraints { (make) in
            make.top.equalTo(smsLabel)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(smsLabel)
        }
        configurationTableView.snp.makeConstraints { (make) in
            make.top.equalTo(smsLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}

//
//  NewReportTableViewCell.swift
//  Bolt
//
//  Created by Roadcast on 19/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class NewReportTableViewCell: UITableViewCell {
    var vehicleName:UILabel!
    var statusTitle:UILabel!
    var statusText:UILabel!
    var leftBgView:UIView!
    var rightBgView:UIView!
    var createdTitle:UILabel!
    var createdText:UILabel!
    var reachTitle:UILabel!
    var reachText:UILabel!
    var destAddTitle:UILabel!
    var destAddText:UILabel!
    var radiusTitle:UILabel!
    var radiusText:UILabel!
    var mapView:RCMainMap!
    override func awakeFromNib() {
         super.awakeFromNib()
     }
     
     override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         //call function here
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor =  UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        setViews()
        setConstraints()
        
         
     }
    func setViews(){
        vehicleName = UILabel()
        vehicleName.textColor = appGreenTheme
        vehicleName.text = "Fortuner"
        vehicleName.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(vehicleName)
        
        statusTitle = UILabel()
        statusTitle.textColor = appGreenTheme
        statusTitle.text = "Status :"
        statusTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(statusTitle)
        
        statusText = UILabel()
        statusText.textColor = .black
        statusText.text = "not reached"
        statusText.font = UIFont.systemFont(ofSize: 14, weight: .light)
        contentView.addSubview(statusText)
        
        
        mapView = RCMainMap(frame: CGRect.zero)
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mapView.settings.myLocationButton = false
        mapView.settings.compassButton = false
        mapView.isUserInteractionEnabled = false
        contentView.addSubview(mapView)
        
        leftBgView = UIView()
        leftBgView.backgroundColor = .white
        leftBgView.layer.cornerRadius = 5
        leftBgView.layer.masksToBounds = true
        contentView.addSubview(leftBgView)
        
        rightBgView = UIView()
        rightBgView.backgroundColor = .white
        rightBgView.layer.cornerRadius = 5
        rightBgView.layer.masksToBounds = true
        contentView.addSubview(rightBgView)
        
        createdTitle = UILabel()
        createdTitle.textColor = appGreenTheme
        createdTitle.text = "Created on"
        createdTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        leftBgView.addSubview(createdTitle)
        
        reachTitle = UILabel()
        reachTitle.textColor = appGreenTheme
        reachTitle.text = "Reach by"
        reachTitle.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        rightBgView.addSubview(reachTitle)
        
        createdText = UILabel()
        createdText.textColor = .black
        createdText.text = "12-08-2020 @ 08:00 PM"
        createdText.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        leftBgView.addSubview(createdText)
        
        reachText = UILabel()
        reachText.textColor = .black
        reachText.text = "12-08-2020 @ 08:00 PM"
        reachText.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        rightBgView.addSubview(reachText)
        
        destAddTitle = UILabel()
        destAddTitle.textColor = appGreenTheme
        destAddTitle.text = "Destination Address"
        destAddTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(destAddTitle)
        
        radiusTitle = UILabel()
        radiusTitle.textColor = appGreenTheme
        radiusTitle.text = "Radius :"
        radiusTitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(radiusTitle)
        
        destAddText = UILabel()
        destAddText.textColor = .gray
        destAddText.text = "lod dgmas gdlgms gdls gldgsl gdl ,hs, y,stg sz,ys ,mgkdhkgkz,sagasdgsd ,fxhfdh,hrfhj,rudud"
        destAddText.numberOfLines = 3
        destAddText.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        contentView.addSubview(destAddText)
        
        radiusText = UILabel()
        radiusText.textColor = .black
        radiusText.text = "12 km"
        radiusText.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        contentView.addSubview(radiusText)
    }
    func setConstraints(){
        let viewSize = self.bounds.size
        vehicleName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(viewSize.height * 0.10)
            make.left.equalToSuperview().offset(viewSize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        statusText.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(viewSize.height * 0.10)
            make.right.equalToSuperview().offset(-viewSize.width * 0.05)
          //  make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        statusTitle.snp.makeConstraints { (make) in
            make.top.equalTo(statusText)
            make.right.equalTo(statusText.snp.left).offset(-viewSize.width * 0.01)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleName.snp.bottom).offset(viewSize.height * 0.10)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        leftBgView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom).offset(viewSize.height * 0.15)
            make.left.equalToSuperview().offset(viewSize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        rightBgView.snp.makeConstraints { (make) in
            make.top.equalTo(leftBgView)
            make.right.equalToSuperview().offset(-viewSize.width * 0.05)
            make.width.height.equalTo(leftBgView)
        }
        createdTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(leftBgView.snp.centerY).offset(-viewSize.height * 0.05)
            make.centerX.equalToSuperview()
        }
        reachTitle.snp.makeConstraints { (make) in
            make.bottom.equalTo(rightBgView.snp.centerY).offset(-viewSize.height * 0.05)
            make.centerX.equalToSuperview()
        }
        createdText.snp.makeConstraints { (make) in
            make.top.equalTo(createdTitle.snp.bottom).offset(viewSize.height * 0.10)
            make.centerX.equalToSuperview()
        }
        reachText.snp.makeConstraints { (make) in
            make.top.equalTo(reachTitle.snp.bottom).offset(viewSize.height * 0.10)
            make.centerX.equalToSuperview()
        }
        destAddTitle.snp.makeConstraints { (make) in
            make.top.equalTo(leftBgView.snp.bottom).offset(viewSize.height * 0.10)
            make.left.equalToSuperview().offset(viewSize.width * 0.05)
        }
        radiusText.snp.makeConstraints { (make) in
            make.top.equalTo(rightBgView.snp.bottom).offset(viewSize.height * 0.10)
            make.right.equalToSuperview().offset(-viewSize.width * 0.05)
           // make.width.equalToSuperview().multipliedBy(0.15)
            
        }
        radiusTitle.snp.makeConstraints { (make) in
           make.top.equalTo(rightBgView.snp.bottom).offset(viewSize.height * 0.10)
            make.right.equalTo(radiusText.snp.left).offset(-viewSize.width * 0.05)
        }
        destAddText.snp.makeConstraints { (make) in
            make.top.equalTo(destAddTitle.snp.bottom).offset(viewSize.height * 0.20)
            make.left.equalToSuperview().offset(viewSize.width * 0.05)
            make.right.equalToSuperview().offset(-viewSize.width * 0.05)
        }
        
    }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
        self.selectedBackgroundView = .none
        self.selectionStyle = .none
     }

}

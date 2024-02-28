//
//  VehicleListTableViewCell.swift
//  Bolt
//
//  Created by Roadcast on 05/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
class VehicleListTableViewCell: UITableViewCell {
    var containerView:UIView!
    var vehicleNameLabel:UILabel!
    var addressLabel:UILabel!
    var lastUpdateTitle:UILabel!
    //var lastUpdateData:UILabel!
    var totalDistTitle:UILabel!
    //var totalDistData:UILabel!
    var currSpeedTitle:UILabel!
    //  var currSpeedData:UILabel!
    var greenLine1:UIView!
    var greenLine2:UIView!
    var blackLine:UIView!
    var markerImg:UIImageView!
    var markerIgnitionTimeLbl:UILabel!
    var gpsImg:UIImageView!
    var networkImg:UIImageView!
    var gpsLabel:UILabel!
    var networkLabel:UILabel!
    var odoTitle:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        setViews()
        setConstraints()
    }
    func setViews(){
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.addShadow()
        contentView.addSubview(containerView)
        
        vehicleNameLabel = UILabel()
        vehicleNameLabel.textColor = appGreenTheme
        vehicleNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        vehicleNameLabel.numberOfLines = 2
        containerView.addSubview(vehicleNameLabel)
        
        addressLabel = UILabel()
        addressLabel.textColor = .black
        addressLabel.text = "N/A"
        addressLabel.textAlignment = .left
        //addressLabel.showsHorizontalScrollIndicator = false
        addressLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        addressLabel.numberOfLines = 4
       // addressLabel.isScrollEnabled = false
       // addressLabel.showsVerticalScrollIndicator = false
        //addressLabel.isUserInteractionEnabled = false
        addressLabel.frame.size = addressLabel.intrinsicContentSize
        containerView.addSubview(addressLabel)
        
        lastUpdateTitle = UILabel()
        lastUpdateTitle.textColor = .gray
        lastUpdateTitle.text = "Last Updated : N/A"
        lastUpdateTitle.textAlignment = .center
        lastUpdateTitle.font = UIFont.italicSystemFont(ofSize: 13)
        lastUpdateTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(lastUpdateTitle)
        
        odoTitle = UILabel()
        odoTitle.textColor = UIColor(red: 57/255, green: 81/255, blue: 151/255, alpha: 1)
        odoTitle.text = "ODOM : 0 km"
        odoTitle.textAlignment = .left
        odoTitle.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        odoTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(odoTitle)
        
        totalDistTitle = UILabel()
        totalDistTitle.textColor = appGreenTheme
        totalDistTitle.text = "TOTAL DIST: 0 km"
        totalDistTitle.textAlignment = .center
        totalDistTitle.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        totalDistTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(totalDistTitle)
        
        
        currSpeedTitle = UILabel()
        currSpeedTitle.textColor = UIColor(red: 174/255, green: 161/255, blue: 56/255, alpha: 1)
        currSpeedTitle.text = "CURR.SPD: 0 KMPH"
        currSpeedTitle.textAlignment = .center
        currSpeedTitle.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        currSpeedTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(currSpeedTitle)
        
        greenLine1 = UIView()
        greenLine1.backgroundColor = appGreenTheme
        containerView.addSubview(greenLine1)
        
        greenLine2 = UIView()
        greenLine2.backgroundColor = appGreenTheme
        containerView.addSubview(greenLine2)
        blackLine = UIView()
        blackLine.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        containerView.addSubview(blackLine)
        
        // bottom horizontal stack
        markerImg = UIImageView()
        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "car-icon-2")!, deg: -90)
        markerImg.image = img.resizedImage(CGSize(width: 30, height: 20), interpolationQuality: .default)
        markerImg.contentMode = .scaleAspectFit
        containerView.addSubview(markerImg)
        
        gpsImg = UIImageView()
      //  gpsImg.image = UIImage(named: "gpsIcon")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default)
        gpsImg.contentMode = .scaleAspectFit
        containerView.addSubview(gpsImg)
        
        networkImg = UIImageView()
      //  networkImg.image = UIImage(named: "network")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default)
        networkImg.contentMode = .scaleAspectFit
        containerView.addSubview(networkImg)
        
        markerIgnitionTimeLbl = UILabel()
        markerIgnitionTimeLbl.textColor = .black
        markerIgnitionTimeLbl.text = "2459 Mins"
        markerIgnitionTimeLbl.textAlignment = .center
        markerIgnitionTimeLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        containerView.addSubview(markerIgnitionTimeLbl)
        
        gpsLabel = UILabel()
        gpsLabel.textColor = .black
        gpsLabel.text = "GPS"
        gpsLabel.textAlignment = .center
        gpsLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        containerView.addSubview(gpsLabel)
        
        networkLabel = UILabel()
        networkLabel.textColor = .black
        networkLabel.text = "Network"
        networkLabel.textAlignment = .center
        networkLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        containerView.addSubview(networkLabel)
        
    }
    func setConstraints(){
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.005)
            make.left.equalToSuperview().offset(screensize.width * 0.02)
            make.right.equalToSuperview().offset(-screensize.width * 0.02)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.005)
        }
        vehicleNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        lastUpdateTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(vehicleNameLabel)
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
            make.width.equalToSuperview().multipliedBy(0.30)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleNameLabel.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
        }
        odoTitle.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.width.equalTo(screensize.width * 0.25)
        }
        greenLine1.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(screensize.height * 0.01)
            make.height.equalTo(odoTitle)
            make.width.equalTo(1)
            make.left.equalTo(odoTitle.snp.right).offset(screensize.width * 0.02)
        }
        totalDistTitle.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalTo(greenLine1.snp.right).offset(screensize.width * 0.02)
            make.width.equalTo(screensize.width * 0.28)
        }
        greenLine2.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(screensize.height * 0.01)
            make.height.equalTo(odoTitle)
            make.width.equalTo(1)
            make.left.equalTo(totalDistTitle.snp.right).offset(screensize.width * 0.02)
        }
        currSpeedTitle.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom).offset(screensize.height * 0.01)
            make.right.equalToSuperview().offset(-screensize.width * 0.02)
            make.width.equalTo(screensize.width * 0.28)
        }
        blackLine.snp.makeConstraints { (make) in
            make.top.equalTo(odoTitle.snp.bottom).offset(screensize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(1)
        }
        markerImg.snp.makeConstraints { (make) in
            make.top.equalTo(blackLine.snp.bottom).offset(screensize.height * 0.01)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.width.equalTo(screensize.width * 0.07)
            make.height.equalTo(screensize.height * 0.04)
        }
        markerIgnitionTimeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(markerImg.snp.right).offset(screensize.width * 0.02)
            make.centerY.equalTo(markerImg)
        }
        gpsImg.snp.makeConstraints { (make) in
            make.top.equalTo(blackLine.snp.bottom).offset(screensize.height * 0.01)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.01)
            make.centerX.equalToSuperview().offset(-screensize.width * 0.05)
            make.width.equalTo(screensize.width * 0.06)
            make.height.equalTo(screensize.height * 0.04)
        }
        gpsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gpsImg.snp.right).offset(screensize.width * 0.02)
            make.centerY.equalTo(gpsImg)
        }
        networkImg.snp.makeConstraints { (make) in
            make.right.equalTo(networkLabel.snp.left).offset(-screensize.width * 0.02)
            make.top.equalTo(blackLine.snp.bottom).offset(screensize.height * 0.01)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.01)
            make.width.equalTo(screensize.width * 0.06)
            make.height.equalTo(screensize.height * 0.04)
        }
        networkLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
            make.centerY.equalTo(networkImg)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


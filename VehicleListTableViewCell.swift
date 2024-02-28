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
    var addressLabel:UITextView!
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
        addSubview(containerView)
        
        vehicleNameLabel = UILabel()
        vehicleNameLabel.textColor = appGreenTheme
        vehicleNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        vehicleNameLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(vehicleNameLabel)
        
        addressLabel = UITextView()
        addressLabel.textColor = .black
        addressLabel.text = "salimart bhagh new delgi gdfklad gldfs bldfs 110035 sdfgsa neqw delfimcdfgs. hkhhmjkhk jlj jljl, "
        addressLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        addressLabel.isScrollEnabled = false
        addressLabel.showsVerticalScrollIndicator = false
        addressLabel.isUserInteractionEnabled = false
        addressLabel.sizeToFit()
        containerView.addSubview(addressLabel)
        
        lastUpdateTitle = UILabel()
        lastUpdateTitle.textColor = .gray
        lastUpdateTitle.text = "Last Updated : 120 Mins ago"
        lastUpdateTitle.textAlignment = .center
        lastUpdateTitle.font = UIFont.italicSystemFont(ofSize: 12)
        lastUpdateTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(lastUpdateTitle)
        
        odoTitle = UILabel()
        odoTitle.textColor = UIColor(red: 57/255, green: 81/255, blue: 151/255, alpha: 1)
        odoTitle.text = "ODOM : 120000"
        odoTitle.textAlignment = .center
        odoTitle.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        odoTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(odoTitle)
        
        totalDistTitle = UILabel()
        totalDistTitle.textColor = appGreenTheme
        totalDistTitle.text = "TOTAL DIST: 24.5 km"
        totalDistTitle.textAlignment = .center
        totalDistTitle.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        totalDistTitle.adjustsFontSizeToFitWidth = true
        containerView.addSubview(totalDistTitle)
        
        
        currSpeedTitle = UILabel()
        currSpeedTitle.textColor = UIColor(red: 174/255, green: 161/255, blue: 56/255, alpha: 1)
        currSpeedTitle.text = "CURR.SPD: 245 KMPH"
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
        blackLine.backgroundColor = .gray
        containerView.addSubview(blackLine)
        
        // bottom horizontal stack
        markerImg = UIImageView()
        let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "car-icon-2")!, deg: -90)
        markerImg.image = img.resizedImage(CGSize(width: 30, height: 20), interpolationQuality: .default)
        markerImg.contentMode = .scaleAspectFit
        containerView.addSubview(markerImg)
        
        gpsImg = UIImageView()
        gpsImg.image = UIImage(named: "gpsIcon")
        gpsImg.contentMode = .scaleAspectFill
        containerView.addSubview(gpsImg)
        
        networkImg = UIImageView()
        networkImg.image = UIImage(named: "network")
        networkImg.contentMode = .scaleAspectFill
        containerView.addSubview(networkImg)
        
        markerIgnitionTimeLbl = UILabel()
        markerIgnitionTimeLbl.textColor = .black
        markerIgnitionTimeLbl.text = "2459 Mins"
        markerIgnitionTimeLbl.textAlignment = .center
        markerIgnitionTimeLbl.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        containerView.addSubview(markerIgnitionTimeLbl)
        
        gpsLabel = UILabel()
        gpsLabel.textColor = .black
        gpsLabel.text = "GPS"
        gpsLabel.textAlignment = .center
        gpsLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        containerView.addSubview(gpsLabel)
        
        networkLabel = UILabel()
        networkLabel.textColor = .black
        networkLabel.text = "Network"
        networkLabel.textAlignment = .center
        networkLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        containerView.addSubview(networkLabel)
        
    }
    func setConstraints(){
        containerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.02)
            make.right.equalToSuperview().offset(-screensize.width * 0.02)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.02)
        }
        vehicleNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        lastUpdateTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(vehicleNameLabel)
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleNameLabel.snp.bottom)//.offset(10)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
        }
        odoTitle.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)//.offset(10)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.width.equalTo(screensize.width * 0.25)
        }
        greenLine1.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)//.offset(10)
            make.height.equalTo(odoTitle)
            make.width.equalTo(2)
            make.left.equalTo(odoTitle.snp.right).offset(screensize.width * 0.02)
        }
        totalDistTitle.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)//.offset(10)
            make.left.equalTo(greenLine1.snp.right).offset(screensize.width * 0.02)
            make.width.equalTo(screensize.width * 0.28)
        }
        greenLine2.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)//.offset(10)
            make.height.equalTo(odoTitle)
            make.width.equalTo(2)
            make.left.equalTo(totalDistTitle.snp.right).offset(screensize.width * 0.02)
        }
        currSpeedTitle.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)
            make.right.equalToSuperview().offset(-screensize.width * 0.02)
            make.width.equalTo(screensize.width * 0.28)
        }
        blackLine.snp.makeConstraints { (make) in
            make.top.equalTo(odoTitle.snp.bottom).offset(screensize.height * 0.02)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalTo(1.5)
        }
        markerImg.snp.makeConstraints { (make) in
            make.top.equalTo(blackLine.snp.bottom).offset(screensize.height * 0.01)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.01)
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.width.equalTo(screensize.width * 0.06)
            make.height.equalTo(screensize.height * 0.08)
        }
        markerIgnitionTimeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(markerImg.snp.right).offset(screensize.width * 0.02)
            make.centerY.equalTo(markerImg)
        }
        gpsImg.snp.makeConstraints { (make) in
            make.top.equalTo(blackLine.snp.bottom).offset(screensize.height * 0.01)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.01)
            make.centerX.equalToSuperview().offset(-screensize.width * 0.05)
            make.width.equalTo(screensize.width * 0.02)
            make.height.equalTo(screensize.height * 0.03)
        }
        gpsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(gpsImg.snp.right).offset(screensize.width * 0.02)
            make.centerY.equalTo(gpsImg)
        }
        networkImg.snp.makeConstraints { (make) in
            make.right.equalTo(networkLabel.snp.left).offset(-screensize.width * 0.02)
            make.top.equalTo(blackLine.snp.bottom).offset(screensize.height * 0.01)
            make.bottom.equalToSuperview().offset(-screensize.height * 0.01)
            make.width.equalTo(screensize.width * 0.02)
            make.height.equalTo(screensize.height * 0.03)
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


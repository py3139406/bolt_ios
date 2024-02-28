//
//  NewReportView.swift
//  Bolt
//
//  Created by Roadcast on 19/08/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class NewReportView: UIScrollView {
 // properites:
    var bgView:UIView!
    var userSelection: UILabel!
    var userBtn:UIButton!
    var dateLabel:UITextField!
    var selectVehicleLabel:UITextField!
    var reportTypeLabel:UITextField!
    var searchBtn:UIButton!
    var newReportTableView:UITableView!
    var screenSize = UIScreen.main.bounds.size
    let image = UIImageView(image: UIImage(named: "down_arrow"))
    var otherreports: UILabel!
    var othrBtn: UIButton!
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .black
    setViews()
    setConstraints()
    
  }
    func setViews(){
        // view
        
         bgView = UIView()
        bgView.backgroundColor =  UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        addSubview(bgView)
        // label
        userSelection = UILabel()
        userSelection.backgroundColor = .white
        userSelection.textColor = .black
        userSelection.layer.cornerRadius = 2
        userSelection.layer.masksToBounds = true
        userSelection.textAlignment = .center
        userSelection.isUserInteractionEnabled = true
        userSelection.text = "USERS"
        userSelection.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        bgView.addSubview(userSelection)
        
        userBtn = UIButton()
        userBtn.backgroundColor = .black
        userBtn.setImage(UIImage(named: "backimg"), for: .normal)
        userBtn.contentMode = .center
        userSelection.addSubview(userBtn)
        
        dateLabel = UITextField()
        dateLabel.setLeftPaddingPoints(10)
        dateLabel.backgroundColor = .white
        dateLabel.textColor = .black
        dateLabel.layer.cornerRadius = 2
        dateLabel.layer.masksToBounds = true
        dateLabel.attributedPlaceholder = NSAttributedString(string: "Select date",
        attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
       // dateLabel.setupRightImageView(imageName:  "down_arrow", xAxis: 10, yAxis: 10, w: 20, h: 20)
        bgView.addSubview(dateLabel)
        
        otherreports = UILabel()
            otherreports.backgroundColor = .white
            otherreports.textColor = .black
            otherreports.layer.cornerRadius = 2
            otherreports.layer.masksToBounds = true
            otherreports.textAlignment = .center
            otherreports.isUserInteractionEnabled = true
            otherreports.text = "Other reports"
            otherreports.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            bgView.addSubview(otherreports)
        othrBtn = UIButton()
       // othrBtn.backgroundColor = appGreenTheme
        othrBtn.setImage(UIImage(named: "righticon-1"), for: .normal)
        othrBtn.contentMode = .center
        otherreports.addSubview(othrBtn)
        
        selectVehicleLabel = UITextField()
        selectVehicleLabel.setLeftPaddingPoints(10)
        selectVehicleLabel.backgroundColor = .white
        selectVehicleLabel.textColor = .black
        selectVehicleLabel.layer.cornerRadius = 2
        selectVehicleLabel.layer.masksToBounds = true
        selectVehicleLabel.attributedPlaceholder = NSAttributedString(string: "Demo",
        attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        selectVehicleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        selectVehicleLabel.setupRightImageView(imageName:  "down", xAxis: 10, yAxis: 10, w: 20, h: 20)
        bgView.addSubview(selectVehicleLabel)
        
        reportTypeLabel = UITextField()
        reportTypeLabel.setLeftPaddingPoints(10)
        reportTypeLabel.backgroundColor = .white
        reportTypeLabel.textColor = .black
        reportTypeLabel.layer.cornerRadius = 2
        reportTypeLabel.layer.masksToBounds = true
        reportTypeLabel.text = SelectedReportType.trips.rawValue
        reportTypeLabel.attributedPlaceholder = NSAttributedString(string: "Select Report Type",
        attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        reportTypeLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        reportTypeLabel.setupRightImageView(imageName:  "down_arrow", xAxis: 10, yAxis: 10, w: 20, h: 20)
        bgView.addSubview(reportTypeLabel)
        
        searchBtn = UIButton()
        searchBtn.setImage(UIImage(named: "Artboard 59")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        searchBtn.backgroundColor = appGreenTheme
        searchBtn.layer.cornerRadius = 2
        searchBtn.layer.masksToBounds = true
        bgView.addSubview(searchBtn)
        
        newReportTableView = UITableView(frame: CGRect.zero, style: .grouped)
        newReportTableView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        newReportTableView.showsVerticalScrollIndicator = false
        newReportTableView.bounces = false
        newReportTableView.isScrollEnabled = true
        newReportTableView.backgroundView?.addSubview(bgView)
        newReportTableView.separatorStyle = .none
        newReportTableView.shouldRestoreScrollViewContentOffset = true
        addSubview(newReportTableView)
        
    }
    func  setConstraints(){
        // view
                bgView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview()
                    make.width.equalToSuperview()
                    make.height.equalToSuperview().multipliedBy(0.35)
                }
        // label
        
        otherreports.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screenSize.height * 0.02)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.13)
        }
        othrBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.90)
            make.width.equalToSuperview().multipliedBy(0.12)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(otherreports.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(otherreports)
        }
        selectVehicleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(otherreports)
        }
        reportTypeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(selectVehicleLabel.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(otherreports)
        }
        searchBtn.snp.makeConstraints { (make) in
            make.top.equalTo(reportTypeLabel.snp.bottom).offset(screenSize.height * 0.01)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(otherreports)
        }
        newReportTableView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom)//.offset(screenSize.height * 0.03)
            make.width.equalToSuperview()//.multipliedBy(0.9)
             make.height.equalToSuperview().multipliedBy(0.65)
           // make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()//.offset(-screenSize.height * 0.01)
        }
    }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
extension UITextField {

    //MARK:- Set Image on the right of text fields

    func setupRightImageView(imageName:String , xAxis:Int ,yAxis:Int , w:Int , h:Int){
    let imageView = UIImageView(frame: CGRect(x: xAxis, y: yAxis, width: w, height: h))
    imageView.image = UIImage(named: imageName)
    let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
    imageContainerView.addSubview(imageView)
    rightView = imageContainerView
    rightViewMode = .always
    self.tintColor = .lightGray
}
}

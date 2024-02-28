//
//  ParkingView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ParkingView: UIView {
    
    var topLabel: UILabel!
    var topIcon: UIButton!
    var topView: UIView!
    var vechileImageView: UIImageView!
    var selectVechileLabel: UILabel!
    var parkingtableView:UITableView!
    var imageContainer: UIView!
    var infoButton : UIButton!
    var syncVehicleModeButton: UIButton!
    var searchBar:UISearchBar!
    var lineView: UIView!
   // var lightImg:UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpView()
        setConstrainst()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }
        func addSearchaBar(){
            searchBar = UISearchBar(frame: CGRect.zero)
            searchBar.searchBarStyle = .minimal
            searchBar.backgroundColor = .white
            searchBar.placeholder = "Search Vehicle".toLocalize //vehicle
            addSubview(searchBar)
        }
    func setUpView(){
        topView = UIView(frame: CGRect.zero)
        topView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        addSubview(topView)
            
        topLabel = UILabel(frame: CGRect.zero)
        topLabel.backgroundColor =  UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        topLabel.text = "Parking Mode".toLocalize
        topLabel.textColor = .black
        topLabel.font = UIFont.systemFont(ofSize: 30, weight: .thin)
        topLabel.adjustsFontSizeToFitWidth = true
        topView.addSubview(topLabel)
        
        topIcon = UIButton(frame: CGRect.zero)
        topIcon.setImage(#imageLiteral(resourceName: "parkingModeonTabBar"), for: .normal)
        topIcon.isUserInteractionEnabled = false
        topView.addSubview(topIcon)
        
        imageContainer = UIView(frame: CGRect.zero)
        imageContainer.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        addSubview(imageContainer)
        
        vechileImageView = UIImageView(frame: CGRect.zero)
        vechileImageView.contentMode = .scaleToFill
        vechileImageView.image = #imageLiteral(resourceName: "parkingVechileImage")
        imageContainer.addSubview(vechileImageView)
        
//        lightImg = UIImageView(frame: CGRect.zero)
//        lightImg.contentMode = .scaleToFill
//        lightImg.image = #imageLiteral(resourceName: "ic_lights_on.png")
//        imageContainer.addSubview(lightImg)
        
        selectVechileLabel = UILabel(frame: CGRect.zero)
        selectVechileLabel.backgroundColor = appGreenTheme
        selectVechileLabel.text = " Select vehicles & turn on parking mode ".toLocalize
        selectVechileLabel.textAlignment = .center
        selectVechileLabel.textColor = .white
        selectVechileLabel.layer.cornerRadius = 5
        selectVechileLabel.clipsToBounds = true
        selectVechileLabel.font = UIFont.italicSystemFont(ofSize: 15)
        selectVechileLabel.adjustsFontSizeToFitWidth = true
        imageContainer.addSubview(selectVechileLabel)
       
        parkingtableView  = UITableView(frame: CGRect.zero)
        parkingtableView.layer.backgroundColor = UIColor.clear.cgColor
        parkingtableView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        parkingtableView.separatorColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        parkingtableView.separatorStyle = .singleLine
        parkingtableView.bounces = false
        addSubview(parkingtableView)
        
        infoButton = UIButton(frame: CGRect.zero)
        infoButton.setImage(#imageLiteral(resourceName: "more"), for: .normal)
        addSubview(infoButton)
        
        lineView = UIView()
        lineView.backgroundColor = appGreenTheme
        addSubview(lineView)
        
        syncVehicleModeButton = UIButton(frame: CGRect.zero)
        syncVehicleModeButton.setImage(#imageLiteral(resourceName: "sync"), for: .normal)
        addSubview(syncVehicleModeButton)
         addSearchaBar()
    }
    
    func setConstrainst(){
        topView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            if #available(iOS 11, *){
                make.top.equalTo(safeAreaLayoutGuide.snp.top)
            }else{
                make.top.equalTo(self).offset(20)
            }
            make.height.equalTo(self).multipliedBy(0.10)
            make.width.equalTo(self)
        }
        topLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topView).offset(20)
            make.centerY.equalTo(topView)
        }
        topIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(topLabel)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(topLabel)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        imageContainer.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        vechileImageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.95)
            make.top.equalTo(imageContainer.snp.top).offset(screensize.height * 0.02)
            make.height.equalTo(imageContainer).multipliedBy(0.6)
            make.centerX.equalToSuperview()
        }
        infoButton.snp.makeConstraints { (make) in
            make.left.equalTo(imageContainer).offset(10)
            make.top.equalTo(imageContainer).offset(screensize.height * 0.2)
            make.height.equalTo(imageContainer).multipliedBy(0.15)
            make.width.equalTo(imageContainer).multipliedBy(0.15)
        }
        syncVehicleModeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(infoButton)//.offset(screensize.height * 0.2)
            make.right.equalTo(imageContainer).offset(-10)
            make.height.equalTo(imageContainer).multipliedBy(0.20)
            make.width.equalTo(imageContainer).multipliedBy(0.12)
        }
        selectVechileLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(vechileImageView.snp.bottom).offset(kscreenheight * 0.05)
           // make.height.equalToSuperview().multipliedBy(0.07)
           // make.width.equalToSuperview().multipliedBy(0.6)
        }
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(imageContainer)//.offset(kscreenheight * 0.01)
            make.height.equalToSuperview().multipliedBy(0.002)
            make.width.equalToSuperview()
        }
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(kscreenheight * 0.012)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
               }
        parkingtableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(kscreenheight * 0.012)
            make.bottom.equalToSuperview()//.offset(-height)
        }
    }
}

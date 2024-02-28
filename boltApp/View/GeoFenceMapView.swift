//
//  GeoFenceMapView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import GooglePlaces
import GoogleMaps


class GeoFenceMapView: UIView {
    
    var searchButton:UIButton!
    var circleButton:UIButton!
    var polygonButton: UIButton!
    var polylineButton: UIButton!
    var cancelButton: UIButton!
    var satelliteBtn: UIButton!
    var submitButton: UIButton!
    var circleLabel : UILabel!
    var polygonLabel: UILabel!
    var polylineLabel: UILabel!
    var mapView: RCMainMap!
    var slider:UISlider!
    var navBar: UINavigationBar!

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        addMapView()
        addButton()
        addlabel()
        addSlider()
        addNavBar()
        addConstrainsts()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNavBar(){
        navBar = UINavigationBar(frame: CGRect.zero)
        navBar.backgroundColor = .white
        addSubview(navBar)
    }
    
    func addMapView(){
//        let map = RCMapView.mapView
        mapView = RCMainMap(frame: UIScreen.main.bounds)
        addSubview(mapView)
    
        
    }

    
    
    func addlabel(){
        circleLabel = UILabel(frame: CGRect.zero)
        circleLabel.text = "Circle".toLocalize
        circleLabel.textColor = .white
        circleLabel.backgroundColor = blackLabelColor
        circleLabel.textAlignment = .center
        circleLabel.isHidden = true
        addSubview(circleLabel)
        
        polygonLabel = UILabel(frame: CGRect.zero)
        polygonLabel.text = "Polygon".toLocalize
        polygonLabel.textColor = .white
        polygonLabel.backgroundColor = blackLabelColor
        polygonLabel.textAlignment = .center
        polygonLabel.isHidden = true
        addSubview(polygonLabel)
        
        polylineLabel = UILabel(frame: CGRect.zero)
        polylineLabel.text = "Polyline".toLocalize
        polylineLabel.textColor = .white
        polylineLabel.backgroundColor = blackLabelColor
        polylineLabel.textAlignment = .center
        polylineLabel.isHidden = true
        addSubview(polylineLabel)
        
    }
    
    func addButton(){
        searchButton = UIButton(frame: CGRect.zero)
        searchButton.backgroundColor =  appGreenTheme
        searchButton.setImage(#imageLiteral(resourceName: "searchWhite").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default),for: .normal)
        searchButton.layer.cornerRadius = 25
        addSubview(searchButton)
        
        
        cancelButton = UIButton(frame: CGRect.zero)
        cancelButton.layer.cornerRadius = 25
        cancelButton.backgroundColor = .white
        cancelButton.setImage(#imageLiteral(resourceName: "plus").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        
        addSubview(cancelButton)
        
        satelliteBtn = UIButton(frame: CGRect.zero)
        satelliteBtn.layer.cornerRadius = 25
        satelliteBtn.backgroundColor = .white
        satelliteBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for: .normal)
               
               addSubview(satelliteBtn)
        
    //satelliteBtn
        
        
        circleButton = UIButton(frame: CGRect.zero)
        circleButton.layer.cornerRadius = 25
        circleButton.backgroundColor = geoFenceBlueColor
        circleButton.setImage(#imageLiteral(resourceName: "circle").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        circleButton.isHidden  = true
        addSubview(circleButton)
    
        polygonButton = UIButton(frame: CGRect.zero)
        polygonButton.layer.cornerRadius = 25
        polygonButton.backgroundColor = geoFenceBlueColor
        polygonButton.setImage(#imageLiteral(resourceName: "square").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default), for: .normal)
        polygonButton.isHidden = true
        addSubview(polygonButton)
        
        polylineButton = UIButton(frame: CGRect.zero)
        polylineButton.layer.cornerRadius = 25
        polylineButton.backgroundColor = geoFenceBlueColor
        polylineButton.setImage(#imageLiteral(resourceName: "polyline").resizedImage(CGSize.init(width: 25, height: 15), interpolationQuality: .default), for: .normal)
        polylineButton.isHidden = true
        addSubview(polylineButton)
      
        submitButton = UIButton(frame:CGRect.zero)
        submitButton.backgroundColor =  appGreenTheme
        submitButton.setTitle("SUBMIT".toLocalize, for: .normal)
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addSubview(submitButton)
    }
    
    func addSlider() -> Void {
        slider = UISlider()
        slider.backgroundColor = .clear
        slider.minimumValue = 5.0
        slider.maximumValue = 500.0
        slider.isContinuous = true
        slider.value = 5.0
        let transformation = CGAffineTransform(rotationAngle:-(.pi/2))
        slider.transform = transformation
        addSubview(slider)
        bringSubview(toFront:slider)
    }
    
    func addConstrainsts(){
//
//        navBar.snp.makeConstraints { (make) in
//            make.left.equalToSuperview()
//
//            if #available(iOS 11.0, *) {
//                    make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
//                    make.height.equalToSuperview().multipliedBy(0.04)
//                } else {
//                     make.top.equalToSuperview().offset(20)
//                     make.height.equalToSuperview().multipliedBy(0.07)
//                }
//            make.right.equalToSuperview()
//           
//        }
       
        mapView.snp.makeConstraints { (make) in
             make.left.equalToSuperview()
             make.top.equalToSuperview()
             make.right.equalToSuperview()
             make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
//             make.bottom.equalTo(submitButton.snp.top)
            
        }
        searchButton.snp.makeConstraints { (make) in
            make.left.equalTo(mapView).offset(35)
            make.top.equalTo(mapView).offset(40)
            make.height.width.equalTo(50)
        }
        
        polylineButton.snp.makeConstraints { (make) in
            make.left.equalTo(satelliteBtn.snp.left)
            make.bottom.equalTo(cancelButton.snp.top).offset(-20)
            make.height.width.equalTo(searchButton)
           
        }
        polylineLabel.snp.makeConstraints { (make) in
            make.right.equalTo(polylineButton.snp.left).offset(-20)
            make.centerY.equalTo(polylineButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        
        polygonButton.snp.makeConstraints { (make) in
            make.left.equalTo(cancelButton.snp.left)
            make.bottom.equalTo(polylineButton.snp.top).offset(-20)
            make.height.width.equalTo(searchButton)
        }
        
        polygonLabel.snp.makeConstraints { (make) in
            make.right.equalTo(polygonButton.snp.left).offset(-20)
            make.centerY.equalTo(polygonButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        circleButton.snp.makeConstraints { (make) in
            make.left.equalTo(cancelButton.snp.left)
            make.bottom.equalTo(polygonButton.snp.top).offset(-20)
            make.height.width.equalTo(searchButton)
        }
        
        circleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(circleButton.snp.left).offset(-20)
            make.centerY.equalTo(circleButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        cancelButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(satelliteBtn.snp.top).offset(-25)
            make.height.width.equalTo(searchButton)
            
        }
        
        satelliteBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(submitButton.snp.top).offset(-35)
            make.height.width.equalTo(searchButton)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalToSuperview().multipliedBy(0.07)
         //   make.bottom.equalToSuperview().offset(-10)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin).offset(-50)
            } else {
                // Fallback on earlier versions
                make.bottom.equalTo(self).offset(-20)
            }
        }
        
        slider.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(-70)
            make.height.equalTo(self).multipliedBy(0.1)
            make.width.equalTo(self).multipliedBy(0.6)
        }
    }
    

}

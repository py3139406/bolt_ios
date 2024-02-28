//
//  AddGeoFenceView.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class AddGeoFenceView: UIView {
    
    var newGeoFenceButton:UIButton!
    var saveButton:UIButton!
    var slider:UISlider!
    
    weak var containerView:UIView?
    var geoFenceMapView:RCMainMap!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addViews()
        addButtons()
        addSlider()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() -> Void {
        containerView = create(subView:"UIView") as? UIView
      geoFenceMapView = RCMainMap(frame: CGRect.zero)
        containerView?.addSubview(geoFenceMapView)
    }
    
    func addButtons() -> Void {
        saveButton = UIButton()
        saveButton.setTitleColor(.white, for:.normal)
        saveButton.setTitle(NSLocalizedString("SAVE", comment:"save"), for:.normal)
        saveButton.backgroundColor = UIColor(red: 249.0/255.0, green: 53.0/255.0, blue: 55.0/255.0, alpha: 1)
        addSubview(saveButton)
        
        newGeoFenceButton = UIButton()
        newGeoFenceButton.setTitleColor(.white, for:.normal)
        newGeoFenceButton.titleLabel?.font = UIFont.systemFont(ofSize:12)
        newGeoFenceButton.setTitle(NSLocalizedString("NEW GEOFENCE", comment:"new geofence"), for:.normal)
        newGeoFenceButton.backgroundColor = UIColor(red: 249.0/255.0, green: 53.0/255.0, blue: 55.0/255.0, alpha: 1)
        addSubview(newGeoFenceButton)
        bringSubview(toFront:newGeoFenceButton)
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
        slider.isHidden = false
        addSubview(slider)
        bringSubview(toFront:slider)
    }
    
    func addConstraints() -> Void {
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.1)
            make.width.equalTo(self)
        }
        
        containerView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self)
            make.bottom.equalTo(saveButton.snp.top)
            make.width.equalTo(self)
        })
        geoFenceMapView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView!)
        }
        
        newGeoFenceButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(geoFenceMapView).offset(25)
            make.width.equalTo(geoFenceMapView).multipliedBy(0.4)
            make.height.equalTo(30)
        }
        
        slider.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(-70)
            make.height.equalTo(self).multipliedBy(0.1)
            make.width.equalTo(self).multipliedBy(0.6)
        }
    }
    
}




//
//  MapView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import GooglePlaces
import GoogleMaps

class MapView: UIView {
    
    var trafficButton: UIButton!
    var trafficlabel: UILabel!
    var showPOIButton:UIButton!
    var showPOILabel:UILabel!
    
    var changeMapTypeBtn: UIButton!
    var changeMapTypelbl: UILabel!
    var reachButton:UIButton!
    var reachLabel:UILabel!
    
    var optionButton: UIButton!
    
    var directionButton:UIButton!
    var isDirectionButtonHidden = false
    var rcMapView: RCMapView!
    
    var nearbyplaceButton : UIButton!
    var nearbyplaceLabel : UILabel!
    
    var nearbyVehicleButton : UIButton!
    var nearbyVehicleLabel : UILabel!
    
    var backButton : UIButton!
    var searchButton : UIButton!
    
    var trailButton: UIButton!
    var trailLabel: UILabel!
    var playbackStopCount: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addViews(){
        rcMapView = RCMapView.mapView
        addSubview(rcMapView)
        
        searchButton = UIButton(frame: CGRect.zero)
        searchButton.setImage(UIImage(named: "ic_search"), for: .normal)
        searchButton.contentMode = .scaleAspectFit
        rcMapView.addSubview(searchButton)
        
        
        backButton = UIButton(frame: CGRect.zero)
        backButton.setImage(UIImage(named: "backarrow"), for: .normal)
        backButton.contentMode = .scaleAspectFit
        backButton.isUserInteractionEnabled = true
        backButton.isHidden = true
        rcMapView.addSubview(backButton)
        
        playbackStopCount = UILabel(frame: CGRect.zero)
        playbackStopCount.text = "No. of stops: "
        playbackStopCount.textColor = appGreenTheme
        playbackStopCount.backgroundColor = appDarkTheme
        playbackStopCount.layer.cornerRadius = 6
        playbackStopCount.layer.masksToBounds = true
        playbackStopCount.textAlignment = .center
        playbackStopCount.isHidden = true
        playbackStopCount.font = UIFont.italicSystemFont(ofSize: 13)
        rcMapView.addSubview(playbackStopCount)
        
        directionButton =  UIButton(frame: CGRect.zero)
        directionButton.showsTouchWhenHighlighted = true
        directionButton.backgroundColor = .white
        directionButton.setImage(#imageLiteral(resourceName: "direction"), for:.normal)
        addSubview(directionButton)
        
        nearbyplaceButton =  UIButton(frame: CGRect.zero)
        nearbyplaceButton.showsTouchWhenHighlighted = true
        nearbyplaceButton.isHidden = true
        addSubview(nearbyplaceButton)
        
        nearbyplaceLabel = RCLabel(frame: CGRect.zero)
        nearbyplaceLabel.text = "Nearby Places".toLocalize
        nearbyplaceLabel.layer.cornerRadius = 5.0
        nearbyplaceLabel.adjustsFontSizeToFitWidth = true
        nearbyplaceLabel.textAlignment = .center
        nearbyplaceLabel.backgroundColor = blackLabelColor
        nearbyplaceLabel.textColor = .white
        nearbyplaceLabel.isHidden = true
        addSubview(nearbyplaceLabel)
        
        nearbyVehicleButton =  UIButton(frame: CGRect.zero)
        nearbyVehicleButton.showsTouchWhenHighlighted = true
    //nearbyplaceButton.setImage(#imageLiteral(resourceName: "Nearby"), for:.normal)
        nearbyVehicleButton.isHidden = true
        addSubview(nearbyVehicleButton)
        
        nearbyVehicleLabel = RCLabel(frame: CGRect.zero)
        nearbyVehicleLabel.text = "Nearby Vehicle".toLocalize
        nearbyVehicleLabel.layer.cornerRadius = 5.0
        nearbyVehicleLabel.adjustsFontSizeToFitWidth = true
        nearbyVehicleLabel.textAlignment = .center
        nearbyVehicleLabel.backgroundColor = blackLabelColor
        nearbyVehicleLabel.textColor = .white
        nearbyVehicleLabel.isHidden = true
        addSubview(nearbyVehicleLabel)
        
        trafficButton =  UIButton(frame: CGRect.zero)
        trafficButton.showsTouchWhenHighlighted = true
        trafficButton.setImage(#imageLiteral(resourceName: "trafficoff"), for:.normal)
        if #available(iOS 11.0, *) {
            trafficButton.isSpringLoaded = true
        }
        trafficButton.isHidden = true
        addSubview(trafficButton)
        
        trafficlabel = RCLabel(frame: CGRect.zero)
        trafficlabel.text = "Traffic".toLocalize
        trafficlabel.textAlignment = .center
        trafficlabel.layer.cornerRadius = 5.0
        trafficlabel.backgroundColor = blackLabelColor
        trafficlabel.textColor = .white
        trafficlabel.isHidden = true
        addSubview(trafficlabel)
        
        // chnage map type
        changeMapTypeBtn =  UIButton(frame: CGRect.zero)
        changeMapTypeBtn.showsTouchWhenHighlighted = true
        changeMapTypeBtn.setImage(#imageLiteral(resourceName: "Asset 67"), for:.normal)
        changeMapTypeBtn.isHidden = true
        addSubview(changeMapTypeBtn)
        
        changeMapTypelbl = RCLabel(frame: CGRect.zero)
        changeMapTypelbl.text = "Satellite Map".toLocalize
        changeMapTypelbl.adjustsFontSizeToFitWidth = true
        changeMapTypelbl.textAlignment = .center
        changeMapTypelbl.layer.cornerRadius = 5.0
        changeMapTypelbl.backgroundColor = blackLabelColor
        changeMapTypelbl.textColor = .white
        changeMapTypelbl.isHidden = true
        addSubview(changeMapTypelbl)
        
        // chnage map type
        showPOIButton =  UIButton(frame: CGRect.zero)
        showPOIButton.showsTouchWhenHighlighted = true
        showPOIButton.setImage(#imageLiteral(resourceName: "ic_poi_hidden"), for:.normal)
        showPOIButton.isHidden = true
        addSubview(showPOIButton)
        
        showPOILabel = RCLabel(frame: CGRect.zero)
        showPOILabel.text = "Show POI".toLocalize
        showPOILabel.adjustsFontSizeToFitWidth = true
        showPOILabel.textAlignment = .center
        showPOILabel.layer.cornerRadius = 5.0
        showPOILabel.backgroundColor = blackLabelColor
        showPOILabel.textColor = .white
        showPOILabel.isHidden = true
        addSubview(showPOILabel)
        
        // chnage map type
        //        addPOIButton =  UIButton(frame: CGRect.zero)
        //        addPOIButton.showsTouchWhenHighlighted = true
        //        addPOIButton.setImage(#imageLiteral(resourceName: "ic_add_poi"), for:.normal)
        //        addPOIButton.isHidden = true
        //        addSubview(addPOIButton)
        //
        //        addPOILabel = RCLabel(frame: CGRect.zero)
        //        addPOILabel.text = "Add POI".toLocalize
        //        addPOILabel.adjustsFontSizeToFitWidth = true
        //        addPOILabel.textAlignment = .center
        //        addPOILabel.layer.cornerRadius = 5.0
        //        addPOILabel.backgroundColor = blackLabelColor
        //        addPOILabel.textColor = .white
        //        addPOILabel.isHidden = true
        //        addSubview(addPOILabel)
        
        // reachability view
        reachButton =  UIButton(frame: CGRect.zero)
        reachButton.setImage(#imageLiteral(resourceName: "Asset 2-2.png"), for:.normal)
        reachButton.isHidden = true
        addSubview(reachButton)
        
        reachLabel = RCLabel(frame: CGRect.zero)
        reachLabel.text = "Reachabilty".toLocalize
        reachLabel.adjustsFontSizeToFitWidth = true
        reachLabel.textAlignment = .center
        reachLabel.layer.cornerRadius = 5.0
        reachLabel.backgroundColor = blackLabelColor
        reachLabel.textColor = .white
        reachLabel.isHidden = true
        addSubview(reachLabel)
        
        optionButton =  UIButton(frame: CGRect.zero)
        //optionButton.backgroundColor = .white
        optionButton.layer.cornerRadius = 27.5
        optionButton.showsTouchWhenHighlighted = true
        optionButton.layer.shadowColor = UIColor.black.cgColor
        optionButton.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
        optionButton.layer.shadowRadius = 1.0
        optionButton.layer.shadowOpacity = 0.6
        optionButton.setImage(#imageLiteral(resourceName: "Asset 147-1"), for:.normal)
        addSubview(optionButton)
        
        // trail
        trailButton =  UIButton(frame: CGRect.zero)
        trailButton.showsTouchWhenHighlighted = true
        trailButton.setImage(#imageLiteral(resourceName: "trail_copy"), for:.normal)
        trailButton.isHidden = true
        addSubview(trailButton)
        
        trailLabel = RCLabel(frame: CGRect.zero)
        trailLabel.text = "Show Trail".toLocalize
        trailLabel.adjustsFontSizeToFitWidth = true
        trailLabel.textAlignment = .center
        trailLabel.layer.cornerRadius = 5.0
        trailLabel.backgroundColor = blackLabelColor
        trailLabel.textColor = .white
        trailLabel.isHidden = true
        addSubview(trailLabel)
    }
    
    
    func addConstraints() -> Void {
        rcMapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
       
        optionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-80)
            } else {
                make.bottom.equalToSuperview().offset(-150)
                
            }
            make.height.width.equalTo(55)
        }
        searchButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(55)
            make.width.height.equalTo(50)
            
        }
        
        showPOIButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(reachButton)
            make.bottom.equalTo(reachButton.snp.top).offset(-10)
            make.right.equalTo(reachButton)
            make.width.height.equalTo(55)
        }
        showPOILabel.snp.makeConstraints { (make) in
            make.right.equalTo(showPOIButton.snp.left).offset(-10)
            make.centerY.equalTo(showPOIButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
        }
        reachButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(optionButton)
            make.bottom.equalTo(optionButton.snp.top).offset(-10)
            make.right.equalTo(optionButton)
            make.width.height.equalTo(55)
        }
        reachLabel.snp.makeConstraints { (make) in
            make.right.equalTo(reachButton.snp.left).offset(-10)
            make.centerY.equalTo(reachButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
        }
        changeMapTypeBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(showPOIButton)
            make.bottom.equalTo(showPOIButton.snp.top).offset(-10)
            make.right.equalTo(showPOIButton)
            make.width.height.equalTo(55)
        }
        changeMapTypelbl.snp.makeConstraints { (make) in
            make.right.equalTo(changeMapTypeBtn.snp.left).offset(-10)
            make.centerY.equalTo(changeMapTypeBtn)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
        }
        
        trafficButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(changeMapTypeBtn)
            make.bottom.equalTo(changeMapTypeBtn.snp.top).offset(-10)
            make.right.equalTo(changeMapTypeBtn)
            make.width.height.equalTo(55)
        }
        trafficlabel.snp.makeConstraints { (make) in
            make.right.equalTo(trafficButton.snp.left).offset(-10)
            make.centerY.equalTo(trafficButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
        }
        
        nearbyplaceButton.snp.makeConstraints { (make) in
            make.right.equalTo(nearbyVehicleButton)
            make.centerX.equalTo(nearbyVehicleButton)
            make.bottom.equalTo(nearbyVehicleButton.snp.top).offset(-10)
            make.width.height.equalTo(55)
        }
        
        nearbyplaceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(nearbyplaceButton.snp.left).offset(-10)
            make.centerY.equalTo(nearbyplaceButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
            
        }
        
        nearbyVehicleButton.snp.makeConstraints { (make) in
            make.right.equalTo(trafficButton)
            make.centerX.equalTo(trafficButton)
            make.bottom.equalTo(trafficButton.snp.top).offset(-10)
            make.width.height.equalTo(55)
        }
        
        nearbyVehicleLabel.snp.makeConstraints { (make) in
            make.right.equalTo(nearbyVehicleButton.snp.left).offset(-10)
            make.centerY.equalTo(nearbyVehicleButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
            
        }
        directionButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(optionButton.snp.bottom).offset(-5)
            make.height.width.equalTo(40)
        }
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(40)
            make.height.equalTo(25)
            make.width.equalTo(22)
            
        }
        playbackStopCount.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-0.23 * kscreenheight)
            make.height.equalTo(25)
            make.width.equalTo(120)
            
        }
        trailButton.snp.makeConstraints { (make) in
            make.right.equalTo(nearbyplaceButton)
            make.centerX.equalTo(nearbyplaceButton)
            make.bottom.equalTo(nearbyplaceButton.snp.top).offset(-10)
            make.width.height.equalTo(55)
        }
        
        trailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(trailButton.snp.left).offset(-10)
            make.centerY.equalTo(trailButton)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
            
        }
        
    }
    
    
}

//
//  geofenceTableView.swift
//  Bolt
//
//  Created by Saanica Gupta on 31/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit

class geofenceTableView: UIView {
    var insideGeofenceLabel : UILabel!
    var dismissLabel : UILabel!
    var geofenceTableView : UITableView!
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    var coverView: UIView!
    var viewData: UIView!
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addview()
        addconstraints()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addview() {
        coverView = UIView(frame: CGRect.zero)
        self.coverView.backgroundColor =  UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        addSubview(coverView)
        
        viewData = UIView(frame: CGRect.zero)
        viewData.layer.cornerRadius = 5
        viewData.layer.masksToBounds = true
        coverView.addSubview(viewData)
        
        insideGeofenceLabel = UILabel(frame: CGRect.zero)
        insideGeofenceLabel.text = "Inside geofence"
        insideGeofenceLabel.backgroundColor = appGreenTheme
        insideGeofenceLabel.font = UIFont.systemFont(ofSize: 20)
        insideGeofenceLabel.textColor = .white
        insideGeofenceLabel.textAlignment = .center
        viewData.addSubview(insideGeofenceLabel)
        
        
        dismissLabel = UILabel(frame: CGRect.zero)
        dismissLabel.text = "DISMISS"
        dismissLabel.backgroundColor = appGreenTheme
        dismissLabel.font = UIFont.systemFont(ofSize: 20)
        dismissLabel.textColor = .white
        dismissLabel.textAlignment = .center
        viewData.addSubview(dismissLabel)
        
        
        geofenceTableView = UITableView(frame: CGRect.zero)
        geofenceTableView.showsVerticalScrollIndicator = false
        geofenceTableView.separatorStyle = .singleLineEtched
        geofenceTableView.separatorColor = .black
        geofenceTableView.backgroundColor =  .white
        // geofenceTableView.sectionIndexColor = .black
        geofenceTableView.bounces = false
        viewData.addSubview(geofenceTableView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isHidden = true
    }
    func addconstraints(){
        
        coverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        viewData.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(0.6 * ScreenWidth)
            make.height.equalTo(0.5 * ScreenHeight)
        }
        
        insideGeofenceLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(0.06 * kscreenheight)
            
        }
        geofenceTableView.snp.makeConstraints{(make) in
            make.top.equalTo(insideGeofenceLabel.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalTo(dismissLabel.snp.top)
        }
        dismissLabel.snp.makeConstraints{(make) in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.06 * kscreenheight)
            
        }
    }
}


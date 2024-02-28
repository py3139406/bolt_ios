//
//  GeoFenceView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//



import UIKit

class GeoFenceView: UIView {
    
    let items = ["Geofence".toLocalize, "Devices".toLocalize]
    var headerLabel: RCLabel!
    var headerImage: UIImageView!
    var segmentedController: UISegmentedControl!
   // var viewBysegment: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSegmentView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSegmentView() -> Void {
        segmentedController = UISegmentedControl(items: items)
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        if #available(iOS 13.0, *) {
            segmentedController.selectedSegmentTintColor = appGreenTheme
        } else {
            // Fallback on earlier versions
            segmentedController.tintColor = appGreenTheme
        }
        segmentedController.selectedSegmentIndex = 0
        segmentedController.layer.cornerRadius = 10.0  // Don't let background bleed
        segmentedController.backgroundColor = UIColor.white
        segmentedController.tintColor = appGreenTheme
        addSubview(segmentedController)
    }
    func addConstraints() -> Void {
        segmentedController.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
    
}

//
//  FollowerShareView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class FollowerShareView: UIView {
    
    var segmentedController: UISegmentedControl!
    var closeButton: UIButton!
    var backButton: UIButton!
    var items = ["CHAT","MAP"]
    var navBar: UINavigationBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addButton()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButton() {
        backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "back-white").resizedImage(CGSize.init(width: 17, height: 17), interpolationQuality: .default), for: .normal)
        backButton.setTitle(" Back", for: .normal)
//        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = appGreenTheme
        backButton.layer.cornerRadius = 5
        addSubview(backButton)
        
        closeButton = UIButton(type: .custom)
        closeButton.setTitle("Close X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = appGreenTheme
        closeButton.layer.cornerRadius = 5
        addSubview(closeButton)
    }
    
    
    func addViews() -> Void {
        segmentedController = UISegmentedControl(items: items)
        segmentedController.selectedSegmentIndex = 1
        segmentedController.backgroundColor = .white
        if #available(iOS 13.0, *) {
            segmentedController.selectedSegmentTintColor = appGreenTheme
        } else {
            // Fallback on earlier versions
            segmentedController.tintColor = appGreenTheme
        }
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedController.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: appGreenTheme], for: .normal)

        segmentedController.layer.cornerRadius = 5
        segmentedController.layer.masksToBounds = true
        addSubview(segmentedController)
    }
    
    func addConstraints() -> Void {
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.top.equalToSuperview().offset(20)
        }
        closeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.top.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        segmentedController.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }

}

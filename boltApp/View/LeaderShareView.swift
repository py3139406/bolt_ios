//
//  LeaderShareView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class LeaderShareView: UIView {
    var segmentedController: UISegmentedControl!
    var closeButton: UIButton!
    var backButton: UIButton!
    var items = ["CHAT".toLocalize,"FOLLOWERS".toLocalize]
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
        backButton.setImage(#imageLiteral(resourceName: "back-white").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        backButton.setTitle("Back", for: .normal)
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
        segmentedController.selectedSegmentIndex = 0
        segmentedController.backgroundColor = UIColor.white
        if #available(iOS 13.0, *) {
            segmentedController.selectedSegmentTintColor = appGreenTheme
        } else {
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
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton)
            make.size.equalTo(backButton)
            make.right.equalToSuperview().offset(-20)
        }
        
        segmentedController.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}

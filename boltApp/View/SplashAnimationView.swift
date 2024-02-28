//
//  SplashAnimationView.swift
//  Bolt
//
//  Created by Vishal Jain on 08/08/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
import Gifu

class SplashAnimationView: UIView {
    var closeButton:UIButton = UIButton(frame: CGRect.zero)
    var animationView:GIFImageView = GIFImageView(frame: CGRect.zero)
    
    let kScreenWidth = UIScreen.main.bounds.width
    let kScreenHeight = UIScreen.main.bounds.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addUIElements()
        addConstraints()
        self.backgroundColor = UIColor(red: 230/255, green: 255/255, blue: 247/255, alpha: 1.0)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error".toLocalize)
    }
    func addUIElements() {
        
        animationView.contentMode = .scaleToFill
        addSubview(animationView)
        
        closeButton.backgroundColor = .clear
        closeButton.setImage(UIImage(named: "closeButtonSubscriptionExpired"), for: .normal)
        addSubview(closeButton)
    }
    func addConstraints() {
        
        closeButton.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height * 0.02)
            make.right.equalToSuperview().offset(-UIScreen.main.bounds.height * 0.02)
            make.width.equalTo(UIScreen.main.bounds.width * 0.1)
            make.height.equalTo(UIScreen.main.bounds.width * 0.1)
        }
        
        animationView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        
    }
}

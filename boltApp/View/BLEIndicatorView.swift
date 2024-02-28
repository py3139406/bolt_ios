//
//  BLEIndicatorView.swift
//  Bolt
//
//  Created by Roadcast on 09/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class BLEIndicatorView: UIView {
    var indicator = UIActivityIndicatorView()
    var loadingLabel = UILabel()
    override init(frame:CGRect){
        super.init(frame:frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.isOpaque = true
        addview()
        addConstraints()
        
    }
    func addview(){
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.backgroundColor = UIColor(white: 1, alpha: 0.5)
        indicator.layer.cornerRadius = 5
        indicator.clipsToBounds = true
        indicator.color = .black
        indicator.contentMode = .scaleAspectFit
        indicator.startAnimating()
        addSubview(indicator)
        
        loadingLabel = UILabel(frame: CGRect.zero)
        loadingLabel.text = "Connecting..."
        loadingLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        loadingLabel.textColor = .black
        loadingLabel.textAlignment = .center
        addSubview(loadingLabel)
    }
    func addConstraints(){
        indicator.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height/3)
            make.width.equalToSuperview()//.multipliedBy(0.80)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        loadingLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

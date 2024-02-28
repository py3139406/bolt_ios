//
//  PopUp.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class PopUp: UIView {
    
    var containerView : UIView!
    var imageView:UIImageView!
    var headingLabel: UILabel!  // Parking Mode
    var dismissBtn: UIButton!
    var firstLabel : UILabel!  // When you turn on
    var imageInLabel:UIImageView!  // parking on image
    var lastTextView: UILabel! // the parking mode ......
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
        addContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   

    func createView(){
        containerView = UIView(frame: CGRect.zero)
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.image = #imageLiteral(resourceName: "parking_icon")
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        headingLabel = RCLabel(frame: CGRect.zero)
        headingLabel.textColor = .black
        headingLabel.text = "Parking Mode".toLocalize
        headingLabel.textAlignment = .center
        headingLabel.adjustsFontSizeToFitWidth = true
        headingLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        containerView.addSubview(headingLabel)
        
        firstLabel = UILabel(frame:CGRect.zero)
        firstLabel.text = " When you turn on".toLocalize
        firstLabel.textAlignment = .left
        firstLabel.sizeToFit()
        firstLabel.adjustsFontForContentSizeCategory = true
        firstLabel.adjustsFontSizeToFitWidth = true
        firstLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize+4, weight: .regular)
        containerView.addSubview(firstLabel)
        
    
        imageInLabel = UIImageView(frame: CGRect.zero)
        imageInLabel.contentMode = .scaleAspectFit
        imageInLabel.image = #imageLiteral(resourceName: "green notification")
        containerView.addSubview(imageInLabel)
        
        lastTextView = UILabel(frame:CGRect.zero)
        lastTextView.text = "the parking mode, your vehicle will go into \"High Alert\" mode. An alarm will generate if anyone tries to use your vehicle.".toLocalize
        lastTextView.numberOfLines = 0
        lastTextView.textAlignment = .center
        lastTextView.sizeToFit()
        lastTextView.adjustsFontForContentSizeCategory = true
        lastTextView.adjustsFontSizeToFitWidth = true
        lastTextView.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize+4, weight: .regular)
        containerView.addSubview(lastTextView)
        
        dismissBtn = UIButton(frame: CGRect.zero)
        dismissBtn.setTitle("DISMISS".toLocalize, for: .normal)
        dismissBtn.setTitleColor(.white, for: .normal)
        dismissBtn.backgroundColor = appGreenTheme
        dismissBtn.layer.cornerRadius = 5
        dismissBtn.clipsToBounds = true
        containerView.addSubview(dismissBtn)
        
    }
    
    func addContraints(){
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(self).multipliedBy(0.5)
            make.width.equalTo(self).multipliedBy(0.8)
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalToSuperview().multipliedBy(0.20)
        }
        
        headingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.12)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        firstLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(headingLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalToSuperview().multipliedBy(0.55)
        }
        
        imageInLabel.snp.makeConstraints { (make) in
            make.left.equalTo(firstLabel.snp.right)
            make.top.equalTo(firstLabel)
            make.height.equalTo(firstLabel)
            make.width.equalToSuperview().multipliedBy(0.10)
        }
        
        lastTextView.snp.makeConstraints { (make) in
            make.left.equalTo(firstLabel)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(firstLabel.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        dismissBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.12)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}

//
//  SosView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class SosView: UIView {

  var containerView : UIView!
  var imageView: UIImageView!
  var headingLabel: UILabel!  // Parking Mode
  var dismissBtn: UIButton!
  var firstLabel : UILabel!  // When you turn on
  var lastTextView: UILabel! // the parking mode ......
        
    override init(frame: CGRect) {
            super.init(frame: frame)
            createView()
            addContraints()
        }
        
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        
    func createView() {
     containerView = UIView(frame: CGRect.zero)
     containerView.backgroundColor = .white
     containerView.layer.cornerRadius = 5
     containerView.clipsToBounds = true
     addSubview(containerView)
     
     imageView = UIImageView(frame: CGRect.zero)
     imageView.image = #imageLiteral(resourceName: "sosImage")
     imageView.contentMode = .scaleAspectFit
     containerView.addSubview(imageView)
     
     headingLabel = RCLabel(frame: CGRect.zero)
     headingLabel.textColor = .black
     headingLabel.text = "Help! SOS Alert".toLocalize
     headingLabel.textAlignment = .center
     headingLabel.adjustsFontSizeToFitWidth = true
     headingLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
     containerView.addSubview(headingLabel)
     
     firstLabel = UILabel(frame:CGRect.zero)
     firstLabel.text = " SOS button in vehicle ".toLocalize
     firstLabel.textAlignment = .left
     firstLabel.sizeToFit()
     firstLabel.numberOfLines = 0
     firstLabel.textAlignment = .center
     firstLabel.adjustsFontForContentSizeCategory = true
     firstLabel.adjustsFontSizeToFitWidth = true
     firstLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize+4, weight: .regular)
     containerView.addSubview(firstLabel)
     
//     lastTextView = UILabel(frame:CGRect.zero)
//     lastTextView.text = "has been pressed. Immediate attention required".toLocalize
//     lastTextView.numberOfLines = 0
//     lastTextView.textAlignment = .center
//     lastTextView.sizeToFit()
//     lastTextView.adjustsFontForContentSizeCategory = true
//     lastTextView.adjustsFontSizeToFitWidth = true
//     lastTextView.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize+4, weight: .regular)
//     containerView.addSubview(lastTextView)
     
     dismissBtn = UIButton(frame: CGRect.zero)
     dismissBtn.setTitle("DISMISS".toLocalize, for: .normal)
     dismissBtn.setTitleColor(.white, for: .normal)
     dismissBtn.backgroundColor = appGreenTheme
     dismissBtn.layer.cornerRadius = 5
     dismissBtn.clipsToBounds = true
     containerView.addSubview(dismissBtn)
            
        }
        
        func addContraints() {
       containerView.snp.makeConstraints { (make) in
           make.center.equalToSuperview()
           make.height.equalTo(self).multipliedBy(0.5)
           make.width.equalTo(self).multipliedBy(0.85)
       }
       imageView.snp.makeConstraints { (make) in
           make.centerX.equalToSuperview()
           make.top.equalToSuperview().offset(20)
           make.height.equalToSuperview().multipliedBy(0.4)
           make.width.equalToSuperview().multipliedBy(0.4)
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
           make.height.equalToSuperview().multipliedBy(0.1)
           make.right.equalToSuperview().offset(-20)
       }
       
//       lastTextView.snp.makeConstraints { (make) in
//           make.left.equalTo(firstLabel)
//           make.right.equalToSuperview().offset(-20)
//           make.top.equalTo(firstLabel.snp.bottom)
//           make.height.equalToSuperview().multipliedBy(0.3)
//       }
       
       dismissBtn.snp.makeConstraints { (make) in
           make.bottom.equalToSuperview().offset(-20)
           make.centerX.equalToSuperview()
           make.height.equalToSuperview().multipliedBy(0.12)
           make.width.equalToSuperview().multipliedBy(0.7)
       }
        }
}

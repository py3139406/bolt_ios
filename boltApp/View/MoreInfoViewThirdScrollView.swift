//
//  MoreInfoViewThirdScrollView.swift
//  Bolt
//
//  Created by Vivek Kumar on 30/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class MoreInfoViewThirdScrollView: UIScrollView {

    var tempLabel: UILabel!
    var tempImage: UIImageView!
    var tempStatusLabel: UILabel!
    
    var batLabel: UILabel!
    var batImage: UIImageView!
    var batStatusLabel: UILabel!
    
    var extBatLabel: UILabel!
    var extBatImage: UIImageView!
    var extBatStatusLabel: UILabel!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           addViews()
           addConstraints()
           tempImage.layer.cornerRadius = (self.frame.height*0.4)/2
           batImage.layer.cornerRadius = (self.frame.height*0.4)/2
           extBatImage.layer.cornerRadius = (self.frame.height*0.4)/2
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func addViews() -> Void {
        
        tempLabel = UILabel.init(frame: CGRect.zero)
        tempLabel.backgroundColor = .clear
        tempLabel.text = "Temperature"
        tempLabel.font = UIFont.systemFont(ofSize: 11)
        tempLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        tempLabel.textAlignment = .center
        addSubview(tempLabel)
        
        tempImage = UIImageView()
        tempImage.contentMode = .scaleAspectFit
        tempImage.clipsToBounds = true
        tempImage.image = #imageLiteral(resourceName: "temperature")
        addSubview(tempImage)
        
        tempStatusLabel = UILabel.init(frame: CGRect.zero)
        tempStatusLabel.backgroundColor = .clear
        tempStatusLabel.textColor = .white
        tempStatusLabel.font = UIFont.systemFont(ofSize: 11)
        tempStatusLabel.textAlignment = .center
        tempStatusLabel.text = "N/A"
        addSubview(tempStatusLabel)
        
        
        batLabel = UILabel.init(frame: CGRect.zero)
        batLabel.backgroundColor = .clear
        batLabel.text = "Battery"
        batLabel.font = UIFont.systemFont(ofSize: 11)
        batLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        batLabel.textAlignment = .center
        addSubview(batLabel)
        
        batImage = UIImageView()
        batImage.contentMode = .scaleAspectFit
        batImage.clipsToBounds = true
        batImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
        addSubview(batImage)
        
        batStatusLabel = UILabel.init(frame: CGRect.zero)
        batStatusLabel.backgroundColor = .clear
        batStatusLabel.textColor = .white
        batStatusLabel.font = UIFont.systemFont(ofSize: 11)
        batStatusLabel.textAlignment = .center
        batStatusLabel.text = "N/A"
        addSubview(batStatusLabel)
        
        
        extBatLabel = UILabel.init(frame: CGRect.zero)
        extBatLabel.backgroundColor = .clear
        extBatLabel.text = "Ext Battery"
        extBatLabel.font = UIFont.systemFont(ofSize: 11)
        extBatLabel.textColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        extBatLabel.textAlignment = .center
        addSubview(extBatLabel)
        
        extBatImage = UIImageView()
        extBatImage.contentMode = .scaleAspectFit
        extBatImage.clipsToBounds = true
        extBatImage.image = #imageLiteral(resourceName: "Layer 2 (9)")
        addSubview(extBatImage)
        
        extBatStatusLabel = UILabel.init(frame: CGRect.zero)
        extBatStatusLabel.backgroundColor = .clear
        extBatStatusLabel.textColor = .white
        extBatStatusLabel.font = UIFont.systemFont(ofSize: 11)
        extBatStatusLabel.textAlignment = .center
        extBatStatusLabel.text = "N/A"
        addSubview(extBatStatusLabel)
    }
    
    func addConstraints() -> Void {
        
        tempImage.snp.makeConstraints { (make) in
           make.centerY.equalToSuperview()
           make.left.equalToSuperview()
           make.width.equalToSuperview().dividedBy(4)
           make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        tempLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(tempImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(tempImage)
        }
        
        tempStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(tempImage.snp.bottom).offset(2)
            make.centerX.equalTo(tempImage)
            make.height.width.equalTo(tempLabel)
        }
        
        batImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(tempImage.snp.right)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        batLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(batImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(batImage)
        }
        
        batStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(batImage.snp.bottom).offset(2)
            make.centerX.equalTo(batImage)
            make.height.width.equalTo(batLabel)
        }
        
        extBatImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(batImage.snp.right)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        extBatLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(extBatImage.snp.top).offset(-2)
            make.width.equalToSuperview().dividedBy(4)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalTo(extBatImage)
        }
        
        extBatStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(extBatImage.snp.bottom).offset(2)
            make.centerX.equalTo(extBatImage)
            make.height.width.equalTo(extBatLabel)
        }
        
        
    }
    

}

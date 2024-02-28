//
//  ShareView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class ShareView: UIView {

    var topLabel: UILabel!
    var vechicleImageView: UIImageView!
    var vechileTextField: SkyFloatingLabelTextField!
    var shareButton: UIButton!
    var VechileNameContainerView:UIView!
    var arrow_ImageView:UIImageView!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        userContainer()
        addButton()
        addimageView()
        addTextField()
        addConstrainsts()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }
    
    func userContainer(){
        VechileNameContainerView = UIView(frame: CGRect.zero)
        VechileNameContainerView.backgroundColor = .white
        addSubview(VechileNameContainerView)
    }

    func addLabel(){
        topLabel = UILabel()
        topLabel.text = "Share Location".toLocalize
        topLabel.textColor = .white
        topLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        topLabel.adjustsFontSizeToFitWidth = true
        addSubview(topLabel)
    }
    func addimageView(){
        vechicleImageView = UIImageView()
        vechicleImageView.backgroundColor = appGreenTheme
        vechicleImageView.image = #imageLiteral(resourceName: "wheel").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        vechicleImageView.contentMode = .center
        addSubview(vechicleImageView)
        
        arrow_ImageView = UIImageView()
        arrow_ImageView.backgroundColor = .clear
        arrow_ImageView.image = #imageLiteral(resourceName: "sharebuttonicon").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        arrow_ImageView.contentMode = .center
        shareButton.addSubview(arrow_ImageView)
        
    }
    
    func addTextField(){
        vechileTextField = SkyFloatingLabelTextField()
        vechileTextField.placeholder = "Select your Vehicle".toLocalize
        vechileTextField.backgroundColor = .white
        vechileTextField.title = ""
        vechileTextField.selectedLineColor = .white
        vechileTextField.lineColor = .white
        addSubview(vechileTextField)
    }
  
    func addButton(){
        shareButton = UIButton()
        shareButton.backgroundColor = appGreenTheme
        shareButton.layer.cornerRadius = 2.5
        addSubview(shareButton)
    }

 
    func addConstrainsts(){
        topLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.90)
            make.height.equalToSuperview().multipliedBy(0.08)
            if #available(iOS 11, *){
                make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(180)
            }else{
                make.top.equalToSuperview().offset(180)
            }
            
            
        }
        
        vechicleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.15)
            
        }
        VechileNameContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(vechicleImageView.snp.right)
            make.top.equalTo(vechicleImageView.snp.top)
            make.height.equalTo(vechicleImageView.snp.height)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        vechileTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VechileNameContainerView.snp.left).offset(20)
            make.bottom.equalTo(VechileNameContainerView.snp.bottom).offset(-12)
            make.top.equalTo(VechileNameContainerView.snp.top)
            make.right.equalTo(VechileNameContainerView.snp.right)

        }
        arrow_ImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(shareButton)
            make.centerY.equalTo(shareButton)
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalToSuperview().multipliedBy(0.08)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.left.equalTo(vechicleImageView.snp.left)
            make.right.equalTo(VechileNameContainerView.snp.right)
            make.top.equalTo(VechileNameContainerView.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
    }

}

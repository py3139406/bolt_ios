//
//  ActivateDevicesView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class ActivateDevicesView: UIView {

    var activelabel: UILabel!
    var detailtextLabel: UILabel!
    var activateButton:UIButton!
    var arrowImageView:UIImageView!
    var firstCheckBox:Checkbox!
    var secondCheckBox:Checkbox!
    var thirdCheckBox:Checkbox!
    var firstCheckBoxtitle:UILabel!
    var secondCheckBoxtitle:UILabel!
    var thirdCheckBoxtitle:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton()
        addLabel()
        addimageView()
        addCheckBox()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
      
        super.init(coder: aDecoder)
        fatalError("Error")
    }
    
    func addCheckBox(){
        firstCheckBox = Checkbox(frame: CGRect.zero)
        firstCheckBox.checkedBorderColor = .black
        firstCheckBox.uncheckedBorderColor = .black
        firstCheckBox.borderStyle = .circle
        firstCheckBox.layer.cornerRadius = 5
        firstCheckBox.checkmarkColor = .black
        firstCheckBox.checkmarkStyle = .tick
        addSubview(firstCheckBox)
        
        secondCheckBox = Checkbox(frame: CGRect.zero)
        secondCheckBox.checkedBorderColor = .black
        secondCheckBox.uncheckedBorderColor = .black
        secondCheckBox.borderStyle = .circle
        secondCheckBox.checkmarkColor = .black
        secondCheckBox.checkmarkStyle = .tick
        addSubview(secondCheckBox)
        
        thirdCheckBox = Checkbox(frame: CGRect.zero)
        thirdCheckBox.checkedBorderColor = .black
        thirdCheckBox.uncheckedBorderColor = .black
        thirdCheckBox.borderStyle = .circle
        thirdCheckBox.checkmarkColor = .black
        thirdCheckBox.checkmarkStyle = .tick
        addSubview(thirdCheckBox)
        
    }
    func addLabel(){
        let checkBoxTitleColor = appGreenTheme
        
        activelabel = UILabel()
        activelabel.text = "Activate Devices".toLocalize
        activelabel.textColor = .white
        activelabel.font = UIFont.systemFont(ofSize: 33)
        addSubview(activelabel)
        
        detailtextLabel = UILabel()
        detailtextLabel.text = "Before activating tracker make sure following checks are done.".toLocalize
        detailtextLabel.numberOfLines = 0
        detailtextLabel.textColor = .white
        addSubview(detailtextLabel)
        
        firstCheckBoxtitle = UILabel()
        firstCheckBoxtitle.text = "Insert Sim Card".toLocalize
        firstCheckBoxtitle.textColor = checkBoxTitleColor
        firstCheckBoxtitle.layer.cornerRadius = 10
        firstCheckBoxtitle.font = UIFont.systemFont(ofSize: 20)
        addSubview(firstCheckBoxtitle)
        
        secondCheckBoxtitle = UILabel()
        secondCheckBoxtitle.text = "Switch On Tracker".toLocalize
        secondCheckBoxtitle.textColor = checkBoxTitleColor
        secondCheckBoxtitle.font = UIFont.systemFont(ofSize: 20)
        addSubview(secondCheckBoxtitle)
        
        thirdCheckBoxtitle = UILabel()
        thirdCheckBoxtitle.text = "Wait Till Lights Get Stable".toLocalize
        thirdCheckBoxtitle.textColor = checkBoxTitleColor
        thirdCheckBoxtitle.font = UIFont.systemFont(ofSize: 20)
        addSubview(thirdCheckBoxtitle)
        
    }
    
    func addimageView(){
      
        arrowImageView = UIImageView()
        arrowImageView.backgroundColor = .clear
        arrowImageView.image = #imageLiteral(resourceName: "RightarrowWhite")
        addSubview(arrowImageView)
    }
    
    
    func addButton(){
        activateButton = UIButton()
        activateButton.backgroundColor =  appGreenTheme
        addSubview(activateButton)
        
       
    }
    
    func addConstraints(){
        activelabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.top.equalToSuperview().offset(100)
        }
        
        detailtextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(activelabel.snp.left)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.top.equalTo(activelabel.snp.bottom).offset(10)
        }
        
        firstCheckBox.snp.makeConstraints { (make) in
            make.left.equalTo(detailtextLabel.snp.left)
            make.top.equalTo(detailtextLabel.snp.bottom).offset(30)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.10)
        }
        
        
        secondCheckBox.snp.makeConstraints { (make) in
           make.height.width.left.equalTo(firstCheckBox)
           make.top.equalTo(firstCheckBox.snp.bottom).offset(40)
        }
        
        thirdCheckBox.snp.makeConstraints { (make) in
            make.height.left.width.equalTo(firstCheckBox)
            make.top.equalTo(secondCheckBox.snp.bottom).offset(40)
        }
        
        firstCheckBoxtitle.snp.makeConstraints { (make) in
            make.left.equalTo(firstCheckBox.snp.right).offset(20)
            make.top.equalTo(firstCheckBox.snp.top)
            make.height.equalTo(firstCheckBox.snp.height)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
        
        secondCheckBoxtitle.snp.makeConstraints { (make) in
            make.top.equalTo(secondCheckBox.snp.top)
            make.left.height.width.equalTo(firstCheckBoxtitle)
        
        }
        
        thirdCheckBoxtitle.snp.makeConstraints { (make) in
            make.top.equalTo(thirdCheckBox.snp.top)
            make.left.height.width.equalTo(firstCheckBoxtitle)
            
        }
     
        activateButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.10)
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(activateButton)
            make.centerY.equalTo(activateButton)
            make.height.equalToSuperview().multipliedBy(0.03)
            make.width.equalToSuperview().multipliedBy(0.09)
        }
        
        
        
       
    }
    

}




//
//  FuelHistoryView.swift
//  Bolt
//
//  Created by Roadcast on 17/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class FuelHistoryView: UIView {
    var viewHistoryLabel: UILabel!
    var historyButton:UIButton!
    var petrolLabel: UILabel!
    var dieselLabel: UILabel!
    var petrolButton: RadioButton!
    var dieselButton: RadioButton!
    var vehicleMilageLabel: UILabel!
    var vehicleMilageTextField: UITextField!
    var totalAmountLabel:UILabel!
    var totalAmountTextField: UITextField!
    var pricePerLitreLabel: UILabel!
    var pricePerLitreTextField: UITextField!
    var paymentMethodLabel : UILabel!
    var paymentMethodTextField:UILabel!
    var viewHistoryButton : UIButton!
    var attachBillBtn: UIButton!
    var bgView: UIView!
    var midLineView: UIImageView!
    var totalFilledHeading: UILabel!
    var totalFilledLabel: UILabel!
    
    var lastFilledHeading: UILabel!
    var lastFilledLabel: UILabel!
    
    var lastFillDateHeading: UILabel!
    var lastFillDateLabel: UILabel!
    
    var doneButton: UIButton!
    var table:UITableView!
    var dropDownBtn:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        addview()
        addconstraints()
        self.backgroundColor = .white
    }
    func addview() {
        viewHistoryLabel = UILabel()
        viewHistoryLabel.text = "View History"
        viewHistoryLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        addSubview(viewHistoryLabel)
        
        petrolButton = RadioButton()
        petrolButton.outerCircleColor = appGreenTheme
        petrolButton.innerCircleCircleColor = appGreenTheme
        petrolButton.isSelected = true
        addSubview(petrolButton)
        
        petrolLabel = UILabel()
        petrolLabel.text = "Petrol"
        petrolLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        addSubview(petrolLabel)
        
        dieselButton = RadioButton()
        dieselButton.outerCircleColor = appGreenTheme
        dieselButton.innerCircleCircleColor = appGreenTheme
        dieselButton.isSelected = false
        addSubview(dieselButton)
        
        dieselLabel = UILabel()
        dieselLabel.text = "Diesel"
        dieselLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        addSubview(dieselLabel)
        
        vehicleMilageLabel = UILabel()
        vehicleMilageLabel.text = "Vehicle Mileage"
        vehicleMilageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addSubview(vehicleMilageLabel)
        
        vehicleMilageTextField = UITextField()
        vehicleMilageTextField.layer.cornerRadius = 5
        vehicleMilageTextField.layer.masksToBounds = true
        vehicleMilageTextField.backgroundColor = UIColor(red: 221/255, green: 217/255, blue: 217/255, alpha:1)
        vehicleMilageTextField.keyboardType = .decimalPad
        vehicleMilageTextField.keyboardAppearance = .dark
        vehicleMilageTextField.textAlignment = .left
        addSubview(vehicleMilageTextField)
        
        totalAmountLabel = UILabel()
        totalAmountLabel.text = "Total Amount"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addSubview(totalAmountLabel)
        
        totalAmountTextField = UITextField()
        totalAmountTextField.layer.cornerRadius = 5
        totalAmountTextField.layer.masksToBounds = true
        totalAmountTextField.backgroundColor = UIColor(red: 221/255, green: 217/255, blue: 217/255, alpha: 1)
        totalAmountTextField.keyboardType = .decimalPad
        totalAmountTextField.keyboardAppearance = .dark
        totalAmountTextField.textAlignment = .left
        totalAmountTextField.tag = 0
        addSubview(totalAmountTextField)
        
        paymentMethodLabel = UILabel()
        paymentMethodLabel.text = "Payment Method"
        paymentMethodLabel.adjustsFontSizeToFitWidth = true
        paymentMethodLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addSubview(paymentMethodLabel)
        
        paymentMethodTextField = PaddingLabel()
        paymentMethodTextField.text = "Cash"
        paymentMethodTextField.textColor = .black
        paymentMethodTextField.layer.cornerRadius = 5
        paymentMethodTextField.layer.masksToBounds = true
        paymentMethodTextField.backgroundColor = UIColor(red: 221/255, green: 217/255, blue: 217/255, alpha: 1)
        paymentMethodTextField.isUserInteractionEnabled = true
        //        paymentMethodTextField.font = UIFont.systemFont(ofSize: 13.0)
        paymentMethodTextField.adjustsFontSizeToFitWidth = true
        addSubview(paymentMethodTextField)
        
        dropDownBtn = UIButton()
        dropDownBtn.isUserInteractionEnabled = true
        dropDownBtn.setImage(UIImage(named: "down_arrow"), for: .normal)
        paymentMethodTextField.addSubview(dropDownBtn)
        
        pricePerLitreLabel = UILabel()
        pricePerLitreLabel.text = "Price per Litre"
        pricePerLitreLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addSubview(pricePerLitreLabel)
        
        pricePerLitreTextField = UITextField()
        pricePerLitreTextField.layer.cornerRadius = 5
        pricePerLitreTextField.layer.masksToBounds = true
        pricePerLitreTextField.backgroundColor = UIColor(red: 221/255, green: 217/255, blue: 217/255, alpha: 1)
        pricePerLitreTextField.keyboardType = .decimalPad
        pricePerLitreTextField.keyboardAppearance = .dark
        pricePerLitreTextField.textAlignment = .left
        pricePerLitreTextField.tag = 1
        addSubview(pricePerLitreTextField)
        
        attachBillBtn = UIButton()
        attachBillBtn.isUserInteractionEnabled = true
        attachBillBtn.setImage(UIImage(named: "Attach_Billl"), for: .normal)
        addSubview(attachBillBtn)
        
        historyButton = UIButton()
        historyButton.isUserInteractionEnabled = true
        historyButton.setImage(UIImage(named: "Asset 129"), for: .normal)
        addSubview(historyButton)
        
        bgView = UIView()
        bgView.layer.cornerRadius = 10.0
        bgView.layer.masksToBounds = false
        bgView.backgroundColor = appDarkTheme
        addSubview(bgView)
        
        totalFilledHeading = UILabel()
        totalFilledHeading.text = "TOTAL FILLED"
        totalFilledHeading.textColor = appGreenTheme
        totalFilledHeading.textAlignment = .center
        totalFilledHeading.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        bgView.addSubview(totalFilledHeading)
        
        totalFilledLabel = UILabel()
        totalFilledLabel.textColor = .white
        //totalFilledLabel.text = "120000"
        totalFilledLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(totalFilledLabel)
        
        midLineView = UIImageView()
        midLineView.image = UIImage(named: "dotted-barline")?.resizedImage(CGSize(width: 100, height: 200), interpolationQuality: .default)
        midLineView.contentMode = .scaleAspectFill
        bgView.addSubview(midLineView)
        
        
        lastFilledHeading = UILabel()
        lastFilledHeading.text = "LAST FILLED"
        lastFilledHeading.numberOfLines = 1
        lastFilledHeading.textColor = appGreenTheme
        lastFilledHeading.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        bgView.addSubview(lastFilledHeading)
        
        lastFillDateHeading = UILabel()
        lastFillDateHeading.text = "2020-09-15"
        lastFillDateHeading.numberOfLines = 2
        lastFillDateHeading.textColor = .white
        lastFillDateHeading.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        bgView.addSubview(lastFillDateHeading)
        
        lastFilledLabel = UILabel()
        lastFilledLabel.textColor = .white
        lastFilledLabel.text = "1000 INR"
        lastFilledLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(lastFilledLabel)
        
        lastFillDateLabel = UILabel()
        lastFillDateLabel.textColor = appGreenTheme
        lastFillDateLabel.text = "35.7 L"
        lastFillDateLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(lastFillDateLabel)
        
        table = UITableView()
        table.backgroundColor = .white
        table.isHidden = true
        table.separatorColor = .black
        table.separatorStyle = .singleLine
        table.layer.borderColor = UIColor.black.cgColor
        table.layer.borderWidth = 1
        table.bounces = false
        addSubview(table)
        
        doneButton = UIButton()
        doneButton.setImage(UIImage(named: "Artboard 36")?.resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        doneButton.backgroundColor = appGreenTheme
        addSubview(doneButton)
        
    }
    func addconstraints() {
        viewHistoryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        historyButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(viewHistoryLabel)
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        petrolButton.snp.makeConstraints { (make) in
            make.top.equalTo(viewHistoryLabel.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.size.equalTo(30)
        }
        petrolLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(petrolButton)
            make.left.equalTo(petrolButton.snp.right).offset(10)
        }
        dieselButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(petrolLabel)
            make.left.equalTo(petrolLabel.snp.right).offset(screensize.width * 0.1)
            make.size.equalTo(petrolButton)
        }
        dieselLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(dieselButton)
            make.left.equalTo(dieselButton.snp.right).offset(10)
        }
        vehicleMilageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pricePerLitreLabel)
            make.left.equalTo(pricePerLitreLabel.snp.right).offset(screensize.width * 0.05)
            make.size.equalTo(pricePerLitreLabel)
        }
        vehicleMilageTextField.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleMilageLabel.snp.bottom).offset(5)
            make.left.equalTo(vehicleMilageLabel)
            make.size.equalTo(pricePerLitreTextField)
        }
        totalAmountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pricePerLitreTextField.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalTo(pricePerLitreLabel)
            make.size.equalTo(pricePerLitreLabel)
        }
        totalAmountTextField.snp.makeConstraints { (make) in
            make.top.equalTo(totalAmountLabel.snp.bottom).offset(5)
            make.left.equalTo(totalAmountLabel)
            make.size.equalTo(pricePerLitreTextField)
        }
        paymentMethodLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleMilageTextField.snp.bottom).offset(screensize.height * 0.01)
            make.left.equalTo(vehicleMilageLabel)
            make.size.equalTo(vehicleMilageLabel)
        }
        paymentMethodTextField.snp.makeConstraints { (make) in
            make.top.equalTo(paymentMethodLabel.snp.bottom).offset(5)
            make.left.equalTo(paymentMethodLabel)
            make.size.equalTo(totalAmountTextField)
        }
        dropDownBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(20)
        }
        attachBillBtn.snp.makeConstraints { (make) in
            make.top.equalTo(totalAmountTextField.snp.bottom).offset(screensize.height * 0.02)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.12)
        }
        pricePerLitreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(petrolLabel.snp.bottom).offset(screensize.height * 0.03)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.04)
        }
        pricePerLitreTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pricePerLitreLabel.snp.bottom).offset(5)
            make.left.equalTo(pricePerLitreLabel)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(attachBillBtn.snp.bottom).offset(screensize.height * 0.02)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.95)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        midLineView.snp.makeConstraints { (make) in
            make.left.equalTo(totalFilledHeading.snp.right).offset(10)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(1)
            make.centerY.equalToSuperview()
        }
        //total filled:-
        totalFilledHeading.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        totalFilledLabel.snp.makeConstraints { (make) in
            make.top.equalTo(totalFilledHeading.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalTo(totalFilledHeading)
            make.right.equalTo(midLineView.snp.left)
        }
        //last filled:-
        lastFilledHeading.snp.makeConstraints { (make) in
            make.left.equalTo(midLineView.snp.right).offset(10)
            make.top.equalToSuperview().offset(10)
        }
        lastFilledLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lastFilledHeading.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalTo(lastFilledHeading)
        }
        //Last filled date:-
        lastFillDateHeading.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        lastFillDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lastFillDateHeading.snp.bottom).offset(screensize.height * 0.02)
            make.right.equalTo(lastFillDateHeading)
        }
        table.snp.makeConstraints { (make) in
            make.top.equalTo(paymentMethodTextField.snp.bottom)
            make.width.equalTo(paymentMethodTextField).multipliedBy(0.8)
            make.height.equalTo(130)
            make.centerX.equalTo(paymentMethodTextField)
        }
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

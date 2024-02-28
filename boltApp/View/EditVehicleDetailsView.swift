//
//  EditVehicleDetailsView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class EditVehicleDetailsView: UIView {

    //MARK: - Properties
    var scrollView: UIScrollView!
    var vehicleNumberHeading: UILabel!
    var vehicleNumberLabel: UILabel!
    var dateAddedHeading: UILabel!
    var dateLabel: UILabel!
    var registrationCeritificateHeading: UILabel!
    var registrationCeritificateLabel: UILabel!
    var brandHeading: UILabel!
    var brandTextfield: UITextField!
    var modelHeading: UILabel!
    var modelTextfield: UITextField!
    var insuranceExpiryDateHeading: UILabel!
    var insuranceExpiryDateLabel: UITextField!
    var pollutionExpiryDateHeading: UILabel!
    var pollutionExpiryDateLabel: UITextField!
    var insuranceImageHeading: UILabel!
    var insuranceImageLabel: UILabel!
    var pollutionImageHeading: UILabel!
    var pollutionImageLabel: UILabel!
    
    //MARK : fitness
    var fitnessExpiryDateHeading: UILabel!
    var fitnessExpiryDateLabel: UITextField!
    var fitnessImageHeading: UILabel!
    var fitnessImageLabel: UILabel!
    
    //MARK : national permit
    var nationalPermitExpiryDateHeading: UILabel!
    var nationalPermitExpiryDateLabel: UITextField!
    var nationalPermitExpiryImageHeading: UILabel!
    var nationalPermitExpiryImageLabel: UILabel!
    
    //MARK : 5 years permit
    var fiveYearsPermitExpiryDateHeading: UILabel!
    var fiveYearsPermitExpiryDateLabel: UITextField!
    var fiveYearsPermitExpiryImageHeading: UILabel!
    var fiveYearsPermitExpiryImageLabel: UILabel!
    
    //MARK : tax
    var taxExpiryDateHeading: UILabel!
    var taxExpiryDateLabel: UITextField!
    var taxExpiryImageHeading: UILabel!
    var taxExpiryImageLabel: UILabel!
    
    
    var bottomView: UIView!
    var subscriptionHeading: UILabel!
    var subscriptionDateLabel: UILabel!
    var extendSubscriptionButton: UIButton!
    var imagePopupView: UIView!
    var docImage: UIImageView!
    var editButton: UIButton!
    var dismissButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addElements()
        addConstraints()
        imagePopupView.layer.cornerRadius = (self.frame.size.height * 0.35) / 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Subviews Definations
    private func addElements() {
        scrollView = UIScrollView()
//        scrollView.contentSize = CGSize(width: self.frame.size.width, height: self.frame.size.height + 100)
//        scrollView.setContentOffset(CGPoint(x: 0,y: -self.scrollView.contentInset.top), animated: true)
        scrollView.contentSize = self.frame.size
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = false
        addSubview(scrollView)
        
        vehicleNumberHeading = UILabel()
        vehicleNumberHeading.text = "Vehicle number"
        vehicleNumberHeading.textColor = .white
        vehicleNumberHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(vehicleNumberHeading)
        
        vehicleNumberLabel = UILabel()
        vehicleNumberLabel.text = "N/A"
        vehicleNumberLabel.textAlignment = .right
        vehicleNumberLabel.textColor = appGreenTheme
        vehicleNumberLabel.isUserInteractionEnabled = true
        vehicleNumberLabel.adjustsFontSizeToFitWidth = true
        vehicleNumberLabel.underline()
        scrollView.addSubview(vehicleNumberLabel)
        
        dateAddedHeading = UILabel()
        dateAddedHeading.text = "Date Added"
        dateAddedHeading.textColor = .white
        dateAddedHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(dateAddedHeading)
        
        dateLabel = UILabel()
        dateLabel.text = "2018"
        dateLabel.textAlignment = .right
        dateLabel.textColor = appGreenTheme
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.underline()
        scrollView.addSubview(dateLabel)
        
        registrationCeritificateHeading = UILabel()
        registrationCeritificateHeading.text = "Registration Certificate"
        registrationCeritificateHeading.textColor = .white
        registrationCeritificateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(registrationCeritificateHeading)
        
        registrationCeritificateLabel = UILabel()
        registrationCeritificateLabel.text = "Add image"
        registrationCeritificateLabel.textAlignment = .right
        registrationCeritificateLabel.textColor = appGreenTheme
        registrationCeritificateLabel.adjustsFontSizeToFitWidth = true
        registrationCeritificateLabel.isUserInteractionEnabled = true
        registrationCeritificateLabel.underline()
        scrollView.addSubview(registrationCeritificateLabel)
        
        brandHeading = UILabel()
        brandHeading.text = "Select Brand"
        brandHeading.textColor = .white
        brandHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(brandHeading)
        
        brandTextfield = UITextField()
        brandTextfield.borderStyle = .none
        brandTextfield.backgroundColor = .clear
        brandTextfield.textColor = appGreenTheme
        brandTextfield.textAlignment = .right
        brandTextfield.attributedPlaceholder = NSAttributedString(string: "Select Brand", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        brandTextfield.clearButtonMode = .whileEditing
        scrollView.addSubview(brandTextfield)
        
        modelHeading = UILabel()
        modelHeading.text = "Select Model"
        modelHeading.textColor = .white
        modelHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(modelHeading)
        
        modelTextfield = UITextField()
        modelTextfield.borderStyle = .none
        modelTextfield.backgroundColor = .clear
        modelTextfield.textColor = appGreenTheme
        modelTextfield.textAlignment = .right
        modelTextfield.attributedPlaceholder = NSAttributedString(string: "Select Model", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        modelTextfield.clearButtonMode = .whileEditing
        scrollView.addSubview(modelTextfield)
        
        insuranceExpiryDateHeading = UILabel()
        insuranceExpiryDateHeading.text = "Insurance Expiry Date"
        insuranceExpiryDateHeading.textColor = .white
        insuranceExpiryDateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(insuranceExpiryDateHeading)
        
        insuranceExpiryDateLabel = UITextField()
        insuranceExpiryDateLabel.borderStyle = .none
        insuranceExpiryDateLabel.backgroundColor = .clear
        insuranceExpiryDateLabel.textColor = appGreenTheme
        insuranceExpiryDateLabel.textAlignment = .right
        insuranceExpiryDateLabel.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        insuranceExpiryDateLabel.clearButtonMode = .whileEditing
        scrollView.addSubview(insuranceExpiryDateLabel)
        
        pollutionExpiryDateHeading = UILabel()
        pollutionExpiryDateHeading.text = "Pollution Expiry Date"
        pollutionExpiryDateHeading.textColor = .white
        pollutionExpiryDateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(pollutionExpiryDateHeading)
        
        pollutionExpiryDateLabel = UITextField()
        pollutionExpiryDateLabel.borderStyle = .none
        pollutionExpiryDateLabel.backgroundColor = .clear
        pollutionExpiryDateLabel.textColor = appGreenTheme
        pollutionExpiryDateLabel.textAlignment = .right
        pollutionExpiryDateLabel.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        pollutionExpiryDateLabel.clearButtonMode = .whileEditing
        scrollView.addSubview(pollutionExpiryDateLabel)
        
        insuranceImageHeading = UILabel()
        insuranceImageHeading.text = "Insurance Image"
        insuranceImageHeading.textColor = .white
        insuranceImageHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(insuranceImageHeading)
        
        insuranceImageLabel = UILabel()
        insuranceImageLabel.text = "Add Image"
        insuranceImageLabel.textAlignment = .right
        insuranceImageLabel.textColor = appGreenTheme
        insuranceImageLabel.adjustsFontSizeToFitWidth = true
        insuranceImageLabel.isUserInteractionEnabled = true
        insuranceImageLabel.underline()
        scrollView.addSubview(insuranceImageLabel)
        
        pollutionImageHeading = UILabel()
        pollutionImageHeading.text = "Pollution Image"
        pollutionImageHeading.textColor = .white
        pollutionImageHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(pollutionImageHeading)
        
        pollutionImageLabel = UILabel()
        pollutionImageLabel.text = "Add Image"
        pollutionImageLabel.textAlignment = .right
        pollutionImageLabel.textColor = appGreenTheme
        pollutionImageLabel.adjustsFontSizeToFitWidth = true
        pollutionImageLabel.isUserInteractionEnabled = true
        pollutionImageLabel.underline()
        scrollView.addSubview(pollutionImageLabel)
        
        fitnessExpiryDateHeading = UILabel()
        fitnessExpiryDateHeading.text = "Fitness Expiry Date"
        fitnessExpiryDateHeading.textColor = .white
        fitnessExpiryDateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(fitnessExpiryDateHeading)
        
        fitnessExpiryDateLabel = UITextField()
        fitnessExpiryDateLabel.borderStyle = .none
        fitnessExpiryDateLabel.backgroundColor = .clear
        fitnessExpiryDateLabel.textColor = appGreenTheme
        fitnessExpiryDateLabel.textAlignment = .right
        fitnessExpiryDateLabel.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        fitnessExpiryDateLabel.clearButtonMode = .whileEditing
        scrollView.addSubview(fitnessExpiryDateLabel)
        
        fitnessImageHeading = UILabel()
        fitnessImageHeading.text = "Fitness Image"
        fitnessImageHeading.textColor = .white
        fitnessImageHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(fitnessImageHeading)
        
        fitnessImageLabel = UILabel()
        fitnessImageLabel.text = "Add image"
        fitnessImageLabel.textAlignment = .right
        fitnessImageLabel.textColor = appGreenTheme
        fitnessImageLabel.adjustsFontSizeToFitWidth = true
        fitnessImageLabel.isUserInteractionEnabled = true
        fitnessImageLabel.underline()
        scrollView.addSubview(fitnessImageLabel)
        
        nationalPermitExpiryDateHeading = UILabel()
        nationalPermitExpiryDateHeading.text = "National Permit Expiry Date"
        nationalPermitExpiryDateHeading.textColor = .white
        nationalPermitExpiryDateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(nationalPermitExpiryDateHeading)
        
        nationalPermitExpiryDateLabel = UITextField()
        nationalPermitExpiryDateLabel.borderStyle = .none
        nationalPermitExpiryDateLabel.backgroundColor = .clear
        nationalPermitExpiryDateLabel.textColor = appGreenTheme
        nationalPermitExpiryDateLabel.textAlignment = .right
        nationalPermitExpiryDateLabel.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        nationalPermitExpiryDateLabel.clearButtonMode = .whileEditing
        scrollView.addSubview(nationalPermitExpiryDateLabel)
        
        nationalPermitExpiryImageHeading = UILabel()
        nationalPermitExpiryImageHeading.text = "National Permit Image"
        nationalPermitExpiryImageHeading.textColor = .white
        nationalPermitExpiryImageHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(nationalPermitExpiryImageHeading)
        
        nationalPermitExpiryImageLabel = UILabel()
        nationalPermitExpiryImageLabel.text = "Add image"
        nationalPermitExpiryImageLabel.textAlignment = .right
        nationalPermitExpiryImageLabel.textColor = appGreenTheme
        nationalPermitExpiryImageLabel.adjustsFontSizeToFitWidth = true
        nationalPermitExpiryImageLabel.isUserInteractionEnabled = true
        nationalPermitExpiryImageLabel.underline()
        scrollView.addSubview(nationalPermitExpiryImageLabel)
        
        fiveYearsPermitExpiryDateHeading = UILabel()
        fiveYearsPermitExpiryDateHeading.text = "5 Years Permit Expiry Date"
        fiveYearsPermitExpiryDateHeading.textColor = .white
        fiveYearsPermitExpiryDateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(fiveYearsPermitExpiryDateHeading)
        
        fiveYearsPermitExpiryDateLabel = UITextField()
        fiveYearsPermitExpiryDateLabel.borderStyle = .none
        fiveYearsPermitExpiryDateLabel.backgroundColor = .clear
        fiveYearsPermitExpiryDateLabel.textColor = appGreenTheme
        fiveYearsPermitExpiryDateLabel.textAlignment = .right
        fiveYearsPermitExpiryDateLabel.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        fiveYearsPermitExpiryDateLabel.clearButtonMode = .whileEditing
        scrollView.addSubview(fiveYearsPermitExpiryDateLabel)
        
        fiveYearsPermitExpiryImageHeading = UILabel()
        fiveYearsPermitExpiryImageHeading.text = "5 Years Permit Image"
        fiveYearsPermitExpiryImageHeading.textColor = .white
        fiveYearsPermitExpiryImageHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(fiveYearsPermitExpiryImageHeading)
        
        fiveYearsPermitExpiryImageLabel = UILabel()
        fiveYearsPermitExpiryImageLabel.text = "Add image"
        fiveYearsPermitExpiryImageLabel.textAlignment = .right
        fiveYearsPermitExpiryImageLabel.textColor = appGreenTheme
        fiveYearsPermitExpiryImageLabel.adjustsFontSizeToFitWidth = true
        fiveYearsPermitExpiryImageLabel.isUserInteractionEnabled = true
        fiveYearsPermitExpiryImageLabel.underline()
        scrollView.addSubview(fiveYearsPermitExpiryImageLabel)
        
        taxExpiryDateHeading = UILabel()
        taxExpiryDateHeading.text = "Tax Expiry Date"
        taxExpiryDateHeading.textColor = .white
        taxExpiryDateHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(taxExpiryDateHeading)
        
        taxExpiryDateLabel = UITextField()
        taxExpiryDateLabel.borderStyle = .none
        taxExpiryDateLabel.backgroundColor = .clear
        taxExpiryDateLabel.textColor = appGreenTheme
        taxExpiryDateLabel.textAlignment = .right
        taxExpiryDateLabel.attributedPlaceholder = NSAttributedString(string: "N/A", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        taxExpiryDateLabel.clearButtonMode = .whileEditing
        scrollView.addSubview(taxExpiryDateLabel)
        
        taxExpiryImageHeading = UILabel()
        taxExpiryImageHeading.text = "Tax Image"
        taxExpiryImageHeading.textColor = .white
        taxExpiryImageHeading.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(taxExpiryImageHeading)
        
        taxExpiryImageLabel = UILabel()
        taxExpiryImageLabel.text = "Add image"
        taxExpiryImageLabel.textAlignment = .right
        taxExpiryImageLabel.textColor = appGreenTheme
        taxExpiryImageLabel.adjustsFontSizeToFitWidth = true
        taxExpiryImageLabel.isUserInteractionEnabled = true
        taxExpiryImageLabel.underline()
        scrollView.addSubview(taxExpiryImageLabel)
        
        bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.isHidden = false
        addSubview(bottomView)
        
        subscriptionHeading = UILabel()
        subscriptionHeading.text = "Subscription Expiry Date"
        subscriptionHeading.textColor = .black
        subscriptionHeading.textAlignment = .center
        subscriptionHeading.adjustsFontSizeToFitWidth = true
        bottomView.addSubview(subscriptionHeading)
        
        subscriptionDateLabel = UILabel()
        subscriptionDateLabel.textAlignment = .center
        subscriptionDateLabel.adjustsFontSizeToFitWidth = true
        subscriptionDateLabel.text = "N/A"
        subscriptionDateLabel.textColor = appGreenTheme
        bottomView.addSubview(subscriptionDateLabel)
        
        extendSubscriptionButton = UIButton()
        extendSubscriptionButton.setTitle("RENEW/EXTENDED SUBSCRIPTION", for: .normal)
        extendSubscriptionButton.layer.cornerRadius = 5.0
        extendSubscriptionButton.backgroundColor = appGreenTheme
        extendSubscriptionButton.setTitleColor(.white, for: .normal)
        extendSubscriptionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        bottomView.addSubview(extendSubscriptionButton)
        
        imagePopupView = UIView()
        imagePopupView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        imagePopupView.clipsToBounds = true
        imagePopupView.isHidden = true
        addSubview(imagePopupView)
        
        docImage = UIImageView()
        docImage.isUserInteractionEnabled = true
        docImage.image = #imageLiteral(resourceName: "cross")
        docImage.contentMode = .center
        imagePopupView.addSubview(docImage)
        
        editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0), for: .normal)
        imagePopupView.addSubview(editButton)
        
        dismissButton = UIButton()
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1.0), for: .normal)
        imagePopupView.addSubview(dismissButton)
        
    }
    
    private func addConstraints() {
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        vehicleNumberHeading.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(66)
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        vehicleNumberLabel.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(66)
            make.top.equalTo(scrollView.snp.top).offset(10)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        dateAddedHeading.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleNumberHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vehicleNumberLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        registrationCeritificateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(dateAddedHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        registrationCeritificateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        brandHeading.snp.makeConstraints { (make) in
            make.top.equalTo(registrationCeritificateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        brandTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(registrationCeritificateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        modelHeading.snp.makeConstraints { (make) in
            make.top.equalTo(brandHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        modelTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(brandTextfield.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        insuranceExpiryDateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(modelHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        insuranceExpiryDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(modelTextfield.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)//..
        }
        pollutionExpiryDateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(insuranceExpiryDateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        pollutionExpiryDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(insuranceExpiryDateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        insuranceImageHeading.snp.makeConstraints { (make) in
            make.top.equalTo(pollutionExpiryDateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        insuranceImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pollutionExpiryDateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        pollutionImageHeading.snp.makeConstraints { (make) in
            make.top.equalTo(insuranceImageHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        pollutionImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(insuranceImageLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        fitnessExpiryDateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(pollutionImageHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        fitnessExpiryDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(pollutionImageLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        fitnessImageHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fitnessExpiryDateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        fitnessImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fitnessExpiryDateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        nationalPermitExpiryDateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fitnessImageHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        nationalPermitExpiryDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fitnessImageLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        nationalPermitExpiryImageHeading.snp.makeConstraints { (make) in
            make.top.equalTo(nationalPermitExpiryDateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        nationalPermitExpiryImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nationalPermitExpiryDateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        fiveYearsPermitExpiryDateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(nationalPermitExpiryImageHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        fiveYearsPermitExpiryDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nationalPermitExpiryImageLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        fiveYearsPermitExpiryImageHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fiveYearsPermitExpiryDateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        fiveYearsPermitExpiryImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fiveYearsPermitExpiryDateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        taxExpiryDateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fiveYearsPermitExpiryImageHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        taxExpiryDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fiveYearsPermitExpiryImageLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        taxExpiryImageHeading.snp.makeConstraints { (make) in
            make.top.equalTo(taxExpiryDateHeading.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview().offset(-10)
        }
        taxExpiryImageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(taxExpiryDateLabel.snp.bottom).offset(15)
            make.left.equalTo(scrollView.snp.left).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.06)
            make.width.equalTo(scrollView.snp.width)
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom).offset(UIScreen.main.bounds.height * 0.05)
             make.height.equalToSuperview().multipliedBy(0.3)
             make.width.equalToSuperview()
             make.bottom.equalToSuperview()
        }
        subscriptionDateLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(subscriptionHeading.snp.bottom).offset(30)
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        subscriptionHeading.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(10)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.equalToSuperview()
        }
        extendSubscriptionButton.snp.makeConstraints { (make) in
            make.top.equalTo(subscriptionDateLabel.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        imagePopupView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        docImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(docImage.snp.height)
        }
        editButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        dismissButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
    }
    
    

}
extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}
extension UITextField {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

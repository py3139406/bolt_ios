//
//  POIScrollView.swift
//  Bolt
//
//  Created by Roadcast on 08/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class POIScrollView: UIScrollView {
    // properties
    var googleAddressTitleLabel:UILabel!
    var googleAddressTextField:UITextView!
    var titleLabel:UILabel!
    var titleTextField:UITextField!
    var imageLabel: UILabel!
    var imageSelectImageView: UIImageView!
    var descriptionTitleLabel:UILabel!
    var descriptionTextField:UITextField!
    var addNewButton:UIButton!
    var screenSize = UIScreen.main.bounds.size
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        addConstraints()
    }
    func addViews(){
        googleAddressTitleLabel = UILabel(frame: CGRect.zero)
        googleAddressTitleLabel.text = "Google Address"
        googleAddressTitleLabel.font = UIFont.systemFont(ofSize: 15)
        googleAddressTitleLabel.textColor = appGreenTheme
        addSubview(googleAddressTitleLabel)
        
        googleAddressTextField = UITextView(frame: CGRect.zero)
        googleAddressTextField.backgroundColor = .white
        googleAddressTextField.layer.cornerRadius = 5.0
        googleAddressTextField.clipsToBounds = true
        googleAddressTextField.textColor = .black
        googleAddressTextField.text = ""
       // googleAddressTextField.setLeftPaddingPoints(10)
        googleAddressTextField.sizeToFit()
        googleAddressTextField.leftSpace()
        UITextView().textContainer.maximumNumberOfLines = 2
        googleAddressTextField.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        googleAddressTextField.isUserInteractionEnabled = false
        addSubview(googleAddressTextField)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = appGreenTheme
        addSubview(titleLabel)
        
        titleTextField = UITextField()
        titleTextField.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        titleTextField.backgroundColor = .white
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.clipsToBounds = true
        titleTextField.textColor = .black
        titleTextField.tintColor = appGreenTheme
        titleTextField.text = ""
        titleTextField.setLeftPaddingPoints(10)
        addSubview(titleTextField)
        
        
        imageLabel = UILabel(frame: CGRect.zero)
        imageLabel.text = "Image"
        imageLabel.font = UIFont.systemFont(ofSize: 15)
        imageLabel.textColor = appGreenTheme
        addSubview(imageLabel)
        
        imageSelectImageView = UIImageView(frame: CGRect.zero)
        imageSelectImageView.image = UIImage(named: "ic_dotted_add")
        imageSelectImageView.contentMode = .scaleToFill
        addSubview(imageSelectImageView)
        
        descriptionTitleLabel = UILabel(frame: CGRect.zero)
        descriptionTitleLabel.text = "Description"
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionTitleLabel.textColor = appGreenTheme
        addSubview(descriptionTitleLabel)
        
        descriptionTextField = UITextField()
        descriptionTextField.backgroundColor = .white
        descriptionTextField.layer.cornerRadius = 5.0
        descriptionTextField.clipsToBounds = true
        descriptionTextField.textColor = .black
        descriptionTextField.tintColor = appGreenTheme
        descriptionTextField.text = ""
        descriptionTextField.setLeftPaddingPoints(10)
        descriptionTextField.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        addSubview(descriptionTextField)
        
        addNewButton = UIButton()
        //addNewButton.setTitle(buttonText, for: .normal)
        addNewButton.setTitleColor(.white, for: .normal)
        addNewButton.layer.cornerRadius = 5.0
        addNewButton.clipsToBounds = true
        addNewButton.backgroundColor = appGreenTheme
        addNewButton.titleLabel?.textAlignment = .center
        addNewButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        addSubview(addNewButton)
    }
    func addConstraints(){
        
        googleAddressTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(12)
        }
        googleAddressTextField.snp.makeConstraints { (make) in
            make.top.equalTo(googleAddressTitleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(12)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.93)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(googleAddressTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
        }
        titleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(12)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.93)
        }
        imageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
        }
        imageSelectImageView.snp.makeConstraints { (make) in
            make.top.equalTo(imageLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        descriptionTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageSelectImageView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
        }
        descriptionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTitleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
        addNewButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
class PaddingToLabel:UILabel {

    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat

    required init(withInsets top: CGFloat, _ bottom: CGFloat,_ left: CGFloat,_ right: CGFloat) {
        self.topInset = top
        self.bottomInset = bottom
        self.leftInset = left
        self.rightInset = right
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
extension UITextView {
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
    }
}

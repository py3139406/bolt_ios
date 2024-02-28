//
//  EditTemplateTableCell.swift
//  Bolt
//
//  Created by Roadcast on 23/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class EditTemplateTableCell: UITableViewCell {
    
    var leftLabel:UILabel!
    var tempTextField:UITextField!
    var tempLabel:UILabel!
    var tempBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = appDarkTheme
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViews(){
        leftLabel = UILabel()
       // leftLabel.text = "template name"
        leftLabel.textColor = .white
        leftLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        contentView.addSubview(leftLabel)
        
        tempTextField = UITextField()
       // tempTextField.placeholder = "Name"
        tempTextField.setLeftPaddingPoints(10)
        tempTextField.setRightPaddingPoints(10)
        tempTextField.textColor = .black
        tempTextField.backgroundColor = .white
        tempTextField.layer.cornerRadius = 5
        tempTextField.layer.masksToBounds = true
        tempTextField.isHidden = true
        tempTextField.frame.size.width = tempTextField.intrinsicContentSize.width
        contentView.addSubview(tempTextField)
        
        tempLabel = PaddingLabel()
      //  tempLabel.text = "Nothing selected"
        tempLabel.textColor = .black
        tempLabel.backgroundColor = .white
        tempLabel.layer.cornerRadius = 5
        tempLabel.layer.masksToBounds = true
        tempLabel.isHidden = true
        tempLabel.frame.size.width = tempLabel.intrinsicContentSize.width
        contentView.addSubview(tempLabel)
        
        tempBtn = UIButton()
        tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
        tempBtn.isHidden = true
        contentView.addSubview(tempBtn)
        
    }
    private func setConstraints(){
        leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.centerY.equalToSuperview()
        }
        tempBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(25)
        }
        tempTextField.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.centerY.equalToSuperview()
            make.left.equalTo(leftLabel.snp.right).offset(5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        tempLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.centerY.equalToSuperview()
            make.left.equalTo(leftLabel.snp.right).offset(5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  TreeTableViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//


import UIKit
import SnapKit

class TreeTableViewCell : UITableViewCell {
    
  var selectionBtn: UIButton!
    var detailsLabel: UILabel!
  var customTitleLabel: UILabel!
    var dropDownIcon:UIImageView!
    
//private var additionalButtonHidden : Bool {
//        get {
//            return additionalButton.isHidden;
//        }
//        set {
//            additionalButton.isHidden = newValue;
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setUpCellView()
        addConstrainst()
        
    }
    
    func setUpCellView(){
        customTitleLabel = UILabel(frame: CGRect.zero)
        customTitleLabel.adjustsFontSizeToFitWidth = true
        customTitleLabel.font = UIFont.systemFont(ofSize: 18)
        customTitleLabel.textColor = appGreenTheme
        contentView.addSubview(customTitleLabel)
        
        detailsLabel = UILabel(frame: CGRect.zero)
        detailsLabel.adjustsFontSizeToFitWidth = true
        detailsLabel.font = UIFont.systemFont(ofSize: 18)
        detailsLabel.textColor = appGreenTheme
        contentView.addSubview(detailsLabel)
        
        selectionBtn = UIButton(frame: CGRect.zero)
        selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
        contentView.addSubview(selectionBtn)
        
        dropDownIcon = UIImageView()
        dropDownIcon.contentMode = .scaleAspectFit
        contentView.addSubview(dropDownIcon)
        
        
    }
    
    func addConstrainst(){
        
        customTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(25)
            make.centerY.equalToSuperview()
        }
        
//
        detailsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(customTitleLabel).offset(25)
            make.top.equalTo(customTitleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
//
        
        selectionBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        dropDownIcon.snp.makeConstraints { (make) in
            make.right.equalTo(selectionBtn.snp.left).offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.05)
        }
        
    }
    
    
    
    var additionButtonActionBlock : ((TreeTableViewCell) -> Void)?;
    
    func setup(withTitle title: String, detailsText: String, level : Int) {
        customTitleLabel.text = title
         detailsLabel.text = detailsText
          self.backgroundColor = appDarkTheme
          self.contentView.backgroundColor = appDarkTheme
        
//        let left = 11.0 + 20.0 * CGFloat(level)
//        self.customTitleLabel.frame.origin.x = left
//        self.detailsLabel.frame.origin.x = left
    }
    
    func additionButtonTapped(_ sender : AnyObject) -> Void {
        if let action = additionButtonActionBlock {
            action(self)
        }
    }
    
}

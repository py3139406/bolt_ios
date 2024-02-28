//
//  SubscriptionTabeViewCell.swift
//  Bolt
//
//  Created by Vivek Kumar on 30/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class SubscriptionTabeViewCell: UITableViewCell {
    var kscreenwidth = UIScreen.main.bounds.width
    var kscreenheight = UIScreen.main.bounds.height
    var radioButton : RadioButton!
    var vehiclenameLabel: UILabel!
    var alertimageview: UIImageView!
    var dayleftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        // self.backgroundColor =  .black
        elements()
        addconstraints()
    }
    
    func elements(){
        radioButton = RadioButton(frame: CGRect.zero)
        radioButton.innerCircleCircleColor = UIColor.white
        radioButton.outerCircleColor = appGreenTheme
        contentView.addSubview(radioButton)
        
        vehiclenameLabel = UILabel(frame: CGRect.zero)
        vehiclenameLabel.textColor = .white
        vehiclenameLabel.font = .systemFont(ofSize: 15)
        vehiclenameLabel.text = ""
        vehiclenameLabel.numberOfLines = 3
        contentView.addSubview(vehiclenameLabel)
        
        alertimageview = UIImageView(frame: CGRect.zero)
        alertimageview.contentMode = .scaleAspectFit
        contentView.addSubview(alertimageview)
        
        dayleftLabel = UILabel(frame: CGRect.zero)
        dayleftLabel.font = .systemFont(ofSize: 15)
        dayleftLabel.textColor = .white
        dayleftLabel.text = ""
        contentView.addSubview(dayleftLabel)
        
    }
    func addconstraints(){
        radioButton.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(0.05 * kscreenwidth)
            make.width.height.equalTo(25)
        }
        vehiclenameLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(radioButton.snp.right).offset(0.04 * kscreenwidth)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        alertimageview.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(dayleftLabel.snp.left).offset(-0.02 * kscreenwidth)
            make.width.height.equalTo(25)
        }
        dayleftLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-0.03 * kscreenwidth)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }
    
}

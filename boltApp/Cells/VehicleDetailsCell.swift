//
//  VehicleDetailsCell.swift
//  Bolt
//
//  Created by Roadcast on 04/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class VehicleDetailsCell: UITableViewCell {

    var titleLabel:UILabel!
    var rightButton:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.backgroundColor =  appDarkTheme
        setViews()
        setConstraints()

    }
    func setViews(){
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel)
        
        rightButton = UIButton()
        rightButton.setTitle("N/A", for: .normal)
        rightButton.setTitleColor(appGreenTheme, for: .normal)
        rightButton.titleLabel?.underline()
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightButton.frame.size.width = rightButton.intrinsicContentSize.width
        contentView.addSubview(rightButton)
        
    }
    func setConstraints(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(screensize.width * 0.03)
            make.centerY.equalToSuperview()
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-screensize.width * 0.03)
            make.centerY.equalToSuperview()
            make.height.equalTo(titleLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

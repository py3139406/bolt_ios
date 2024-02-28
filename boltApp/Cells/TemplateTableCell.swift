//
//  TemplateTableCell.swift
//  Bolt
//
//  Created by Roadcast on 22/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class TemplateTableCell: UITableViewCell {
    
    var lView:UIView!
    var snTitle:UILabel!
    var snValue:UILabel!
    
    var rView:UIView!
    var nameTitle:UILabel!
    var devicesTitle:UILabel!
    var tempName:UILabel!
    var viewBtn:UIButton!
    var editBtn:UIButton!
    
    var containerView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setViews(){
        containerView = UIView()
        containerView.backgroundColor = .white
        contentView.addSubview(containerView)
        
        lView = UIView()
        lView.backgroundColor = .black
        containerView.addSubview(lView)
        
        snTitle = UILabel()
        snTitle.text = "S.No."
        snTitle.textAlignment = .center
        snTitle.textColor = .white
        snTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        lView.addSubview(snTitle)
        
        snValue = UILabel()
       // snValue.text = "1"
        snValue.textAlignment = .center
        snValue.textColor = appGreenTheme
        snValue.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        lView.addSubview(snValue)
        
        rView = UIView()
        rView.backgroundColor = appDarkTheme
        containerView.addSubview(rView)
        
        nameTitle = UILabel()
        nameTitle.text = "Name"
        nameTitle.textAlignment = .center
        nameTitle.textColor = .white
        nameTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        rView.addSubview(nameTitle)
        
        devicesTitle = UILabel()
        devicesTitle.text = "Devices"
        devicesTitle.textAlignment = .center
        devicesTitle.textColor = .white
        devicesTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        rView.addSubview(devicesTitle)
        
        tempName = UILabel()
     //   tempName.text = "template name"
        tempName.textAlignment = .left
        tempName.textColor = appGreenTheme
        tempName.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        rView.addSubview(tempName)
        
        viewBtn = UIButton()
        viewBtn.setTitle("View", for: .normal)
        viewBtn.setTitleColor(appGreenTheme, for: .normal)
        viewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        viewBtn.titleLabel?.underline()
        rView.addSubview(viewBtn)
        
        editBtn = UIButton()
        editBtn.setTitle("EDIT", for: .normal)
        editBtn.setTitleColor(.white, for: .normal)
        editBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        editBtn.backgroundColor = appGreenTheme
        rView.addSubview(editBtn)
    }
    private func setConstraints(){
        containerView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        lView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        snTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        snValue.snp.makeConstraints { (make) in
            make.top.equalTo(snTitle.snp.bottom).offset(10)
            make.centerX.equalTo(snTitle)
        }
        rView.snp.makeConstraints { (make) in
            make.left.equalTo(lView.snp.right)
            make.right.equalToSuperview().offset(-screensize.width * 0.05)
            make.top.bottom.equalToSuperview()
        }
        nameTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
        }
        devicesTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        tempName.snp.makeConstraints { (make) in
            make.top.equalTo(nameTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(viewBtn.snp.left)
        }
        viewBtn.snp.makeConstraints { (make) in
            make.top.equalTo(devicesTitle.snp.bottom).offset(10)
            make.right.equalToSuperview()//.offset(-10)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(tempName)
        }
        editBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tempName.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

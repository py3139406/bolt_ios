//
//  AlertTableView.swift
//  Bolt
//
//  Created by Roadcast on 26/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class AlertTableView: UIView {

    var alertTable:UITableView!
    var dismissBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addViews(){
        alertTable = UITableView()
        alertTable.backgroundColor = .white
        alertTable.separatorStyle = .singleLineEtched
        alertTable.separatorColor = .lightGray
        alertTable.layer.cornerRadius = 5
        alertTable.bounces = false
        addSubview(alertTable)
        
        dismissBtn = UIButton()
        dismissBtn.setTitle("Dismiss", for: .normal)
        dismissBtn.setTitleColor(.white, for: .normal)
        dismissBtn.backgroundColor = appGreenTheme
        dismissBtn.layer.cornerRadius = 5
        addSubview(dismissBtn)
    }
    private func addConstraints(){
        alertTable.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        dismissBtn.snp.makeConstraints { (make) in
            make.width.equalTo(alertTable)
            make.height.equalTo(50)
            make.top.equalTo(alertTable.snp.bottom)
            make.centerX.equalTo(alertTable)
        }
    }
}

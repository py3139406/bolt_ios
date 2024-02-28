//
//  EditTemplateView.swift
//  Bolt
//
//  Created by Roadcast on 23/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class EditTemplateView: UIView {
    var tempTable:UITableView!
    var submitBtn:UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addViews()
        addConstraints()
    }
    func addViews(){
        
        tempTable = UITableView()
        tempTable.backgroundColor = appDarkTheme
        tempTable.separatorStyle = .singleLineEtched
        tempTable.separatorColor = .white
        tempTable.bounces = false
        addSubview(tempTable)
        
        submitBtn = UIButton()
        submitBtn.setTitle("SUBMIT", for:.normal )
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        submitBtn.backgroundColor = appGreenTheme
        addSubview(submitBtn)
        
    }
    func addConstraints(){
        tempTable.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(submitBtn.snp.top)
        }
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

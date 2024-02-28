//
//  FilterView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class FilterView: UIView {

    var filterTabel:UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addView() {
        filterTabel = UITableView()
        filterTabel.backgroundColor = .white
        filterTabel.separatorColor = .black
        filterTabel.separatorStyle = .singleLine
        filterTabel.isScrollEnabled = false
        filterTabel.layer.cornerRadius = 5
        filterTabel.layer.masksToBounds = true
        addSubview(filterTabel)
    }
    func addConstraints() {
        filterTabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.08)
            make.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        
    }
}

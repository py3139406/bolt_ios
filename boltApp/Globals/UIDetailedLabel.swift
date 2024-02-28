//
//  UIDetailedLabel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation

class DetailedLabel: UIView {
    var headerLabel: UILabel!
    var detailedLabel: UILabel!
    var flag: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabels()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabels() -> Void {
        headerLabel = UILabel(frame: CGRect.zero)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.font = UIFont.systemFont(ofSize: 11)
        headerLabel.textColor = UIColor(red: 19/255, green: 175/255, blue: 170/255, alpha: 1)
        headerLabel.textAlignment = .center
        addSubview(headerLabel)
        
        detailedLabel = UILabel(frame: CGRect.zero)
      detailedLabel.textAlignment = .center
      detailedLabel.adjustsFontSizeToFitWidth = true
        detailedLabel.font = UIFont.systemFont(ofSize: 15)
        detailedLabel.textColor = .white
        addSubview(detailedLabel)
    }
    
    func addConstraints() -> Void {
        headerLabel.snp.makeConstraints { (make) in
            make.top.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.centerX.equalToSuperview()
        }
        
        detailedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
        }
    }
}

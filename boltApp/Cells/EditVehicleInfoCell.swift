//
//  EditVehicleInfoCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class EditVehicleInfoCell: UITableViewCell {

    var carLabel: UILabel!
    var button: UIButton!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = appDarkTheme
        addElements()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addElements() {
        carLabel = UILabel()
        carLabel.textColor = .white
        contentView.addSubview(carLabel)
        
        button = UIButton()
        button.setImage(#imageLiteral(resourceName: "righticon").resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
      //  button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        contentView.addSubview(button)
    }
    
    private func addConstraints() {
        carLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        button.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
    }
}

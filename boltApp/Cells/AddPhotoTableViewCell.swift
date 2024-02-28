//
//  AddPhotoTableViewCell.swift
//  Bolt
//
//  Created by Roadcast on 20/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class AddPhotoTableViewCell: UITableViewCell {
    let screensize = UIScreen.main.bounds.size
    
    var column1:UIImageView!
    var column2:UIImageView!
    var column3:UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
         super.init(style: style , reuseIdentifier: reuseIdentifier)
        addviews()
        addConstraints()
      
    }

    func addviews(){
         column1 = UIImageView(frame: CGRect.zero)
        column1.isUserInteractionEnabled = true
        // column1.image = #imageLiteral(resourceName: "iconbikegreen")
        // column1.layer.borderWidth = 2
         //column1.layer.borderColor = UIColor.brown.cgColor
        contentView.addSubview(column1)
         
          column2 = UIImageView(frame: CGRect.zero)
        // column2.layer.borderWidth = 2
        // column2.layer.borderColor = UIColor.brown.cgColor
         contentView.addSubview(column2)
         
          column3 = UIImageView(frame: CGRect.zero)
        // column3.layer.borderWidth = 2
        // column3.layer.borderColor = UIColor.brown.cgColor
         contentView.addSubview(column3)
}
    func addConstraints(){
            column1.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview()
                make.width.equalTo(screensize.width/3.2)
                make.height.equalToSuperview()
            }
            column2.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(column1.snp.right)
                make.width.equalTo(screensize.width/3.2)
            }
            column3.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(column2.snp.right)
                make.width.equalTo(screensize.width/3.2)
            }
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


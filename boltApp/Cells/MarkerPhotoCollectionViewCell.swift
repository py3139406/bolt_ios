//
//  MarkerPhotoCollectionViewCell.swift
//  Bolt
//
//  Created by Roadcast on 27/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class MarkerPhotoCollectionViewCell: UICollectionViewCell {
    let screensize = UIScreen.main.bounds.size
    var addimage:UIImageView!

    override init(frame: CGRect) {
         super.init(frame: frame)
        addViews()
        addConstraints()
     }
    
    
    func addViews(){
        addimage = UIImageView(frame: CGRect.zero)
        addimage.contentMode = .scaleAspectFit
        contentView.addSubview(addimage)

        
    }
    func addConstraints(){
        addimage.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.top.equalTo(self.contentView.safeAreaLayoutGuide.snp.top).offset(75)
//            } else {
//                // Fallback on earlier versions
//                make.top.equalTo(self.contentView.snp.top).offset(70)
//            }
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview()
        }

    }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

//
//  AddPhotoCollectionViewCell.swift
//  Bolt
//
//  Created by Roadcast on 19/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
class 	AddPhotoCollectionViewCell: UICollectionViewCell {
    var addImage : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addImage = UIImageView(frame: CGRect.zero)
        contentView.addSubview(addImage)
        addImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

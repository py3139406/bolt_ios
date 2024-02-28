//
//  geoofenceTableViewCell.swift
//  Bolt
//
//  Created by Saanica Gupta on 31/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit

class geoofenceTableViewCell: UITableViewCell {
    var cellitemLabel : UILabel!
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //call function here
        addTableValues()
        addConstraints()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func addTableValues(){
        cellitemLabel = UILabel(frame: CGRect.zero)
        cellitemLabel.textColor = .black
        cellitemLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(cellitemLabel)
    }
    func addConstraints(){
        cellitemLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(0.05 * kscreenwidth)
            
        }
        
    }
    
}



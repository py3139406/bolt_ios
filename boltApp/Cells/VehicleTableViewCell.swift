//
//  VehicleTableViewCell.swift
//  Bolt
//
//  Created by Saanica Gupta on 31/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class VehicleTableViewCell: UITableViewCell {

       
       var itemnameLabel : UILabel!
       
       
         
         let kscreenheight = UIScreen.main.bounds.height
         let kscreenwidth = UIScreen.main.bounds.width
         
         
         override func awakeFromNib() {
             super.awakeFromNib()
             // Initialization code
            
         }
         
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
             
             // Configure the view for the selected state
         }
         func addTableValues()
         {
           
             
             itemnameLabel = UILabel(frame: CGRect.zero)
             itemnameLabel.text = ""
             itemnameLabel.textColor = .black
              itemnameLabel.adjustsFontSizeToFitWidth = true
            contentView.addSubview(itemnameLabel)
           
            
             
             
         }
         
         func addConstraints()
         {
          
    itemnameLabel.snp.makeConstraints{(make) in
        make.centerY.equalToSuperview()
        make.left.equalTo(0.06 * kscreenwidth)
                    
                    
  
                     
             }
          
         }
         
     }

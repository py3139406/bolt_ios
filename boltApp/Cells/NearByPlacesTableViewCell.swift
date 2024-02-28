//
//  NearByPlacesTableViewCell.swift
//  Bolt
//
//  Created by Saanica Gupta on 24/03/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit

class NearByPlacesTableViewCell: UITableViewCell {
    
    var iconImageView : UIImageView!
    var iconitemnameLabel : UILabel!
    var forwardButton : UIImageView!
    
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
    
    func addTableValues(){
        iconImageView = UIImageView(frame: CGRect.zero)
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        
        iconitemnameLabel = UILabel(frame: CGRect.zero)
        iconitemnameLabel.text = ""
        iconitemnameLabel.textColor = .white
        iconitemnameLabel.font = UIFont.boldSystemFont(ofSize: 25.3)
        contentView.addSubview(iconitemnameLabel)
        
        forwardButton = UIImageView(frame: CGRect.zero)
        forwardButton.image = UIImage(named: "backimg-1")
        //      forwardButton(UIImage(named: "backimg-1"), for: .normal)
        forwardButton.contentMode = .scaleAspectFit
        contentView.addSubview(forwardButton)
        
        
    }
    
    func addConstraints(){
        iconImageView.snp.makeConstraints
        {
            (make) in
            
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(0.050 * kscreenwidth)
            make.width.equalTo(0.1 * kscreenwidth)
            make.height.equalTo(0.08 * kscreenheight)
        }
        
        iconitemnameLabel.snp.makeConstraints
        {
            (make) in
            // make.top.equalToSuperview().offset(0.04 * kscreenheight)
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(0.06 * kscreenwidth)
            //                   make.width.equalTo(0.5 * kscreenwidth)
            //                   make.height.equalTo(0.055 * kscreenheight)
            
        }
        
        forwardButton.snp.makeConstraints  {
            (make) in
            //make.top.equalTo(iconitemnameLabel.snp.bottom).offset(0.000 * kscreenheight)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-0.050 * kscreenwidth)
            make.width.equalTo(0.1 * kscreenwidth)
            make.height.equalTo(0.02 * kscreenheight)
            
        }
    }
}



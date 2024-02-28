//
//  NotificationFilterTableViewCell.swift
//  Bolt
//
//  Created by Roadcast on 06/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
class NotificationFilterTableViewCell: UITableViewCell {
    var selectionBtn : UIButton!
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //call function here
        self.backgroundColor = .appbackgroundcolor
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
        selectionBtn = UIButton()
        selectionBtn.backgroundColor = .clear
        selectionBtn.setImage(UIImage(named: "checked"), for: .normal)
        selectionBtn.contentMode = .scaleAspectFit
        contentView.addSubview(selectionBtn)
    }
    func addConstraints(){
        selectionBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.right.equalToSuperview().offset(-20)
            make.width.equalToSuperview().multipliedBy(0.1)
        }

    }
}


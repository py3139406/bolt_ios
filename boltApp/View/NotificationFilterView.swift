//
//  NotificationFilterView.swift
//  Bolt
//
//  Created by Roadcast on 06/07/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class NotificationFilterView: UIView {
        
    var notificationFilterTable:UITableView!
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
        override init(frame: CGRect) {
            super.init(frame: frame)
            addViews()
            addConstraints()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        func addViews(){
            notificationFilterTable = UITableView(frame: CGRect.zero)
            notificationFilterTable.backgroundColor = .appbackgroundcolor
            notificationFilterTable.bounces = false
            addSubview(notificationFilterTable)
        }
       
    func addConstraints(){
            notificationFilterTable.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
    }

//
//  LeaderShareFollowerSegmentView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class LeaderShareFollowerSegmentView: UIView {
    
    var tableView: UITableView!
    var obj:ShareLeaderFollowerTableViewCell!
    var  addFollowerButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() -> Void {
        tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.backgroundColor =  appDarkTheme
        obj = ShareLeaderFollowerTableViewCell(style: .default, reuseIdentifier: "Share")
        tableView.sectionIndexColor = .black
        tableView.rowHeight = 40
        tableView.allowsSelection = false
        addSubview(tableView)
        
        addFollowerButton = UIButton(frame: CGRect.zero)
        addFollowerButton.setImage(#imageLiteral(resourceName: "follower_icon"), for: .normal)
        addFollowerButton.isHidden = false
        addSubview(addFollowerButton)
    }
    
    func addConstraints() -> Void {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addFollowerButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().offset(-30)
            make.height.width.equalTo(50)
        }
    }
    
    

}


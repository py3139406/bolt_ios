//
//  PaymentHistoryTableViewCell.swift
//  Bolt
//
//  Created by Saanica Gupta on 02/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//
import Foundation
import UIKit

class PaymentHistoryTableViewCell: UITableViewCell {
    var kscreenwidth = UIScreen.main.bounds.width
    var kscreenheight = UIScreen.main.bounds.height
    var subscriptionLabel:UILabel!
    var vehiclenumber: UILabel!
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    var inrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        //self.backgroundColor =  UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
        elements()
        addconstraints()
    }
  
    func elements(){
        subscriptionLabel = UILabel(frame: CGRect.zero)
        subscriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        subscriptionLabel.textColor = .white
        subscriptionLabel.text = ""
        //subscriptionLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(subscriptionLabel)
        
        vehiclenumber = UILabel(frame: CGRect.zero)
        vehiclenumber.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        vehiclenumber.textColor = .white
        vehiclenumber.text = ""
        //vehiclenumber.adjustsFontSizeToFitWidth = true
        contentView.addSubview(vehiclenumber)
        
        dateLabel = UILabel(frame: CGRect.zero)
        dateLabel.textColor = .white
        dateLabel.text = ""
        contentView.addSubview(dateLabel)
        
        inrLabel = UILabel(frame: CGRect.zero)
        inrLabel.textColor = .white
        inrLabel.text = ""
        inrLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        contentView.addSubview(inrLabel)
    }
    func addconstraints(){
        subscriptionLabel.snp.makeConstraints{(make) in
            make.top.equalTo(0.01 * kscreenheight)
            make.left.equalTo(0.03 * kscreenwidth)
            make.width.equalTo(0.7 * kscreenwidth)
            
        }
        vehiclenumber.snp.makeConstraints{(make) in
            make.top.equalTo(subscriptionLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalTo(0.03 * kscreenwidth)
            make.width.equalTo(0.7 * kscreenwidth)
        }
        dateLabel.snp.makeConstraints{(make) in
            make.top.equalTo(vehiclenumber.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalTo(0.03 * kscreenwidth)
            make.width.equalTo(0.7 * kscreenwidth)
            make.bottom.equalTo(-0.01 * kscreenheight)
        }
        inrLabel.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-0.05 * kscreenwidth)
        }
        
        
    }
    
}

//import Foundation
//import UIKit
//
//class PaymentHistoryTableViewCell: UITableViewCell {
//    var kscreenwidth = UIScreen.main.bounds.width
//    var kscreenheight = UIScreen.main.bounds.height
//    var subscriptionLabel:UILabel!
//    var vehiclenumber: UILabel!
//    var dateLabel: UILabel!
//    var timeLabel: UILabel!
//    var inrLabel: UILabel!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style , reuseIdentifier: reuseIdentifier)
//        //self.backgroundColor =  UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
//        elements()
//        addconstraints()
//    }
//
//    func elements(){
//
//        subscriptionLabel = UILabel(frame: CGRect.zero)
//        subscriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
//        subscriptionLabel.textColor = .white
//        subscriptionLabel.text = ""
//        //subscriptionLabel.adjustsFontSizeToFitWidth = true
//        contentView.addSubview(subscriptionLabel)
//
//        vehiclenumber = UILabel(frame: CGRect.zero)
//        vehiclenumber.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        vehiclenumber.textColor = .white
//        vehiclenumber.text = ""
//        //vehiclenumber.adjustsFontSizeToFitWidth = true
//        contentView.addSubview(vehiclenumber)
//
//        dateLabel = UILabel(frame: CGRect.zero)
//        dateLabel.textColor = .white
//        dateLabel.text = ""
//        contentView.addSubview(dateLabel)
//
////        timeLabel = UILabel(frame: CGRect.zero)
////        timeLabel.textColor = .white
////        timeLabel.text = ""
////        addSubview(timeLabel)
//
//        inrLabel = UILabel(frame: CGRect.zero)
//        inrLabel.textColor = .white
//        inrLabel.text = ""
//        inrLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        contentView.addSubview(inrLabel)
//
//
//
//    }
//
//    func addconstraints()
//    {
//        subscriptionLabel.snp.makeConstraints{(make) in
//            make.top.equalTo(0.01 * kscreenheight)
//            make.left.equalTo(0.03 * kscreenwidth)
//            make.width.equalTo(0.7 * kscreenwidth)
//
//        }
//        vehiclenumber.snp.makeConstraints{(make) in
//            make.top.equalTo(subscriptionLabel.snp.bottom).offset(0.01 * kscreenheight)
//            make.left.equalTo(0.03 * kscreenwidth)
//            make.width.equalTo(0.7 * kscreenwidth)
//        }
//        dateLabel.snp.makeConstraints{(make) in
//            make.top.equalTo(vehiclenumber.snp.bottom).offset(0.01 * kscreenheight)
//            make.left.equalTo(0.03 * kscreenwidth)
//            make.width.equalTo(0.7 * kscreenwidth)
//            make.bottom.equalTo(-0.01 * kscreenheight)
//        }
////        timeLabel.snp.makeConstraints{(make) in
////            make.top.equalTo(vehiclenumber.snp.bottom).offset(0.01 * kscreenheight)
////            make.left.equalTo(dateLabel.snp.right).offset(0.006 * kscreenwidth)
////            make.width.equalTo(0.25 * kscreenwidth)
////            make.bottom.equalTo(-0.01 * kscreenheight)
////        }
//        inrLabel.snp.makeConstraints{(make) in
//            make.centerY.equalToSuperview()
//            make.right.equalTo(-0.05 * kscreenwidth)
//        }
//
//
//    }
//
//}

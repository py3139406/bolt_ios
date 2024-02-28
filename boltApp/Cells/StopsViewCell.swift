//
//  StopsViewCell.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class StopsViewCell: UITableViewCell {

    var dateLabel: UILabel!  // to show date on top of cell
    var leftView: UIView!   //act as container view for time and address
    var leftLabel: RCLabel!       // to show time
    var leftTextView: UILabel!   //to show address
    var distanceLabel: UILabel!
    var timeLabel: UILabel!
    var averageLabel: UILabel!
    var showdistaceLabel: UILabel!
    var showtimeLabel: UILabel!
    var showaverageLabel: UILabel!
    var containerView: UIView!
    var firstBlackLine:UIView!
    var secondBlackLine:UIView!
    
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        self.backgroundColor =  UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        addViews()
        addTextView()
        addLabel()
        addConstransts()
    }
    
    func addViews(){
        containerView = UIView(frame: CGRect.zero)
        containerView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        leftView = UIView()
        leftView.backgroundColor = .white
        leftView.layer.cornerRadius = 5
        leftView.clipsToBounds = true
        containerView.addSubview(leftView)
        
        firstBlackLine = UIView(frame: CGRect.zero)
        firstBlackLine.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        containerView.addSubview(firstBlackLine)
        
        secondBlackLine = UIView(frame: CGRect.zero)
        secondBlackLine.backgroundColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0)
        containerView.addSubview(secondBlackLine)
      }
    
    func addTextView(){
        
        leftLabel = RCLabel(frame: CGRect.zero)
        leftLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)
        leftLabel.textColor = .white
        leftLabel.textAlignment = .center
        leftLabel.layer.cornerRadius = 5
        leftLabel.clipsToBounds = true
        leftLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        containerView.addSubview(leftLabel)
        
        leftTextView = UILabel(frame:CGRect.zero)
        leftTextView.textAlignment = .center
        leftTextView.numberOfLines = 0
        leftTextView.adjustsFontForContentSizeCategory = true
        leftTextView.adjustsFontSizeToFitWidth = true
        leftTextView.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        //leftTextView.lineBreakMode = .byWordWrapping
        leftTextView.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
       // leftTextView.minimumScaleFactor = 0.5
        leftTextView.layer.cornerRadius = 5
        leftTextView.clipsToBounds = true
        leftTextView.backgroundColor = .white
        containerView.addSubview(leftTextView)
        }
    
    
    func addLabel(){
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontSizeToFitWidth = true
        //  dateLabel.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(dateLabel)
        
        
        distanceLabel = UILabel()
        distanceLabel.text = "DISTANCE"
        distanceLabel.textAlignment = .center
        distanceLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        distanceLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        distanceLabel.adjustsFontForContentSizeCategory = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(distanceLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "TIME"
        timeLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(timeLabel)
        
        averageLabel = UILabel()
        averageLabel.text = "AVG.SPEED"
        averageLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        averageLabel.textAlignment = .center
        averageLabel.font =  UIFont.systemFont(ofSize: 13, weight: .thin)
        averageLabel.adjustsFontForContentSizeCategory = true
        averageLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(averageLabel)
        
        showdistaceLabel = UILabel()
        showdistaceLabel.adjustsFontSizeToFitWidth = true
        showdistaceLabel.textAlignment = .center
        showdistaceLabel.font = UIFont.boldSystemFont(ofSize: 10)
        showdistaceLabel.adjustsFontForContentSizeCategory = true
        showdistaceLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(showdistaceLabel)
        
        showtimeLabel = UILabel()
        showtimeLabel.textAlignment = .center
        showtimeLabel.adjustsFontSizeToFitWidth = true
        showtimeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        showtimeLabel.adjustsFontForContentSizeCategory = true
        showtimeLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(showtimeLabel)
        
        showaverageLabel = UILabel()
        showaverageLabel.textAlignment = .center
        showaverageLabel.adjustsFontSizeToFitWidth = true
        showaverageLabel.font = UIFont.boldSystemFont(ofSize: 10)
        showaverageLabel.adjustsFontForContentSizeCategory = true
        showaverageLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(showaverageLabel)
        
    }
    
    
    
    func addConstransts(){
        containerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        
        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(10)
            make.right.equalTo(containerView.snp.right).offset(-10)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.height.equalTo(containerView).multipliedBy(0.50)
        }
        
        leftLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(dateLabel)
            make.top.equalTo(leftView.snp.top).offset(10)
            make.height.equalTo(dateLabel)
            make.width.equalToSuperview().multipliedBy(0.2)
            
        }
        
        leftTextView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView).offset(10)
            make.right.equalTo(leftView).offset(-10)
            make.top.equalTo(leftLabel.snp.bottom)
            make.height.equalTo(leftView).multipliedBy(0.50)
        }
//        distanceLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(leftTextView)
//            make.top.equalTo(leftView.snp.bottom).offset(10)
//            make.height.equalToSuperview().multipliedBy(0.08)
//            make.width.equalTo(leftTextView).multipliedBy(0.25)
//        }
        
//        showdistaceLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(distanceLabel)
//            make.top.equalTo(distanceLabel.snp.bottom).offset(5)
//            make.height.equalToSuperview().multipliedBy(0.05)
//            make.width.equalTo(distanceLabel)
//        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(leftLabel)
            make.top.equalTo(leftView.snp.bottom).offset(10)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalTo(leftTextView).multipliedBy(0.3)
        }
        
//        averageLabel.snp.makeConstraints { (make) in
//             make.right.equalTo(leftTextView)
//             make.top.height.equalTo(distanceLabel)
//             make.width.equalTo(distanceLabel)
//        }
        
//        showaverageLabel.snp.makeConstraints { (make) in
//            make.top.height.equalTo(showdistaceLabel)
//            make.left.width.equalTo(averageLabel)
//
//        }
        
//        firstBlackLine.snp.makeConstraints { (make) in
//            make.left.equalTo(distanceLabel.snp.right).offset(3)
//            make.top.equalTo(distanceLabel)
//            make.bottom.equalTo(showdistaceLabel)
//            make.width.equalTo(1)
//
//        }
//        secondBlackLine.snp.makeConstraints { (make) in
//            make.top.height.width.equalTo(firstBlackLine)
//            make.right.equalTo(averageLabel.snp.left).offset(-3)
//        }
        
        showtimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.centerX.equalTo(timeLabel)
            make.height.width.equalTo(timeLabel)
            
        }
    }

}

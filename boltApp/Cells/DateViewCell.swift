//
//  DateViewCell.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//
import UIKit
import SnapKit

class DateViewCell: UITableViewCell {

    var carNameLabel: UILabel!
    var dateLabel: UILabel!
    var leftView: UIView!
    var rightView: UIView!
    var leftLabel: UILabel!
    var rightLabel: UILabel!
    var leftTextView: UILabel!
    var rightTextView: UILabel!
    var connector: UIImageView!
    
    var distanceLabel: UILabel!
    var timeLabel: UILabel!
    var averageLabel: UILabel!
    
    var showdistaceLabel: UILabel!
    var showtimeLabel: UILabel!
    var showaverageLabel: UILabel!
    
    var drivingSafetyLabel: UILabel!
    var colorCodeLabel: UILabel!
    var excessiveIdleTimeLabel: UILabel!
    
    var showDrivingSafetyLabel: UILabel!
    var showColorCodeView: UIView!
    var showExcessiveIdleTimeLabel: UILabel!
    
    var containerView: UIView!
    
    var firstBlackLine:UIView!
    var secondBlackLine:UIView!
    
    var thirdBlackLine:UIView!
    var fourthBlackLine:UIView!
    var seperator:UIView = UIView()
    
    var firstCircle:UIButton!
    var secondCircle:UIButton!
    var aLine:UILabel!
    
    // Image Marker
    var photoView: UIView!
    var photoLabel: UILabel!
    var photoButton: UIButton!

    
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
        self.backgroundColor =  UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.0)
        
        addViews()
        addTextView()
        addLabel()
        addConnector()
        addConstransts()
    }
    
    func addConnector(){
        firstCircle = UIButton(frame: CGRect.zero)
        firstCircle.layer.cornerRadius = 6
        firstCircle.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        containerView.addSubview(firstCircle)
        
        secondCircle = UIButton(frame: CGRect.zero)
        secondCircle.backgroundColor = UIColor(red: 202/255, green: 36/255, blue: 83/255, alpha: 1.0)
        secondCircle.layer.cornerRadius = 6
        containerView.addSubview(secondCircle)
        
        aLine = UILabel(frame: CGRect.zero)
        aLine.backgroundColor = .white
        containerView.addSubview(aLine)
    }
    
    func addViews(){
        containerView = UIView(frame: CGRect.zero)
        containerView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        containerView.layer.cornerRadius = 10;
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        leftView = UIView()
        leftView.backgroundColor = .white
        leftView.layer.cornerRadius = 5
        leftView.clipsToBounds = true
        containerView.addSubview(leftView)
        
        rightView = UIView()
        rightView.backgroundColor = .white
        rightView.layer.cornerRadius = 5
        rightView.clipsToBounds = true
        containerView.addSubview(rightView)
        
        firstBlackLine = UIView(frame: CGRect.zero)
        firstBlackLine.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        containerView.addSubview(firstBlackLine)
        
        secondBlackLine = UIView(frame: CGRect.zero)
        secondBlackLine.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        containerView.addSubview(secondBlackLine)
        
        thirdBlackLine = UIView(frame: CGRect.zero)
        thirdBlackLine.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        containerView.addSubview(thirdBlackLine)
        
        fourthBlackLine = UIView(frame: CGRect.zero)
        fourthBlackLine.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        containerView.addSubview(fourthBlackLine)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        containerView.addSubview(seperator)
    }
    
    func addTextView(){
        
        leftLabel = UILabel(frame: CGRect.zero)
        leftLabel.layer.cornerRadius = 5
        leftLabel.clipsToBounds = true
        leftLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)
        leftLabel.textAlignment = .center
        leftLabel.textColor = .white
        leftLabel.backgroundColor = UIColor(red: 55/255, green: 174/255, blue: 160/255, alpha: 1.0)
        containerView.addSubview(leftLabel)
        
        leftTextView = UILabel(frame:CGRect.zero)
        leftTextView.textAlignment = .center
        leftTextView.numberOfLines = 0
        leftTextView.adjustsFontForContentSizeCategory = true
        leftTextView.adjustsFontSizeToFitWidth = true
        leftTextView.textColor = .black
       // leftTextView.lineBreakMode = .byWordWrapping
       // leftTextView.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        leftTextView.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
       // leftTextView.minimumScaleFactor = 0.5
        leftTextView.layer.cornerRadius = 5
        leftTextView.clipsToBounds = true
        leftTextView.backgroundColor = .white
        containerView.addSubview(leftTextView)
        
        rightLabel = UILabel(frame: CGRect.zero)
        rightLabel.layer.cornerRadius = 5
        rightLabel.clipsToBounds = true
        rightLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)
        rightLabel.textColor = .white
        rightLabel.textAlignment = .center
        rightLabel.backgroundColor = UIColor(red: 202/255, green: 36/255, blue: 83/255, alpha: 1.0)
        rightLabel.layer.cornerRadius = 5
        containerView.addSubview(rightLabel)
        
        rightTextView = UILabel(frame:CGRect.zero)
        rightTextView.textAlignment = .center
        rightTextView.numberOfLines = 0
        rightTextView.adjustsFontForContentSizeCategory = true
        rightTextView.adjustsFontSizeToFitWidth = true
        rightTextView.textColor = .black
       // rightTextView.lineBreakMode = .byWordWrapping
        rightTextView.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .thin)
      //  rightTextView.minimumScaleFactor = 0.5
        rightTextView.layer.cornerRadius = 5
        rightTextView.clipsToBounds = true
        rightTextView.backgroundColor = .white
        containerView.addSubview(rightTextView)
    }
    
//    func addConnector(){
//        connector = UIImageView()
//        connector.image = #imageLiteral(resourceName: "reportConnector")
//        connector.contentMode = .scaleToFill
//        containerView.addSubview(connector)
//    }
    
    func addblackLine(){
//        blackLine = UIView()
//        blackLine.backgroundColor = .black
//        containerView.addSubview(blackLine)
    }
    
    func addLabel(){
        carNameLabel = UILabel()
        carNameLabel.adjustsFontSizeToFitWidth = true
        carNameLabel.adjustsFontForContentSizeCategory = true
        containerView.addSubview(carNameLabel)
        
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontSizeToFitWidth = true
        //  dateLabel.font = UIFont.systemFont(ofSize: 18)
        containerView.addSubview(dateLabel)
     
        
        distanceLabel = UILabel()
        distanceLabel.text = "DIST."
        distanceLabel.textAlignment = .center
        distanceLabel.textColor = .black
        distanceLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        distanceLabel.adjustsFontForContentSizeCategory = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(distanceLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "ENGINE ON TIME"
        timeLabel.textColor = .black
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(timeLabel)
        
        averageLabel = UILabel()
        averageLabel.text = "AVG.SPEED"
        averageLabel.textColor = .black
        averageLabel.textAlignment = .center
        averageLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        averageLabel.adjustsFontForContentSizeCategory = true
        averageLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(averageLabel)

        
        showDrivingSafetyLabel = UILabel()
        showDrivingSafetyLabel.adjustsFontSizeToFitWidth = true
        showDrivingSafetyLabel.textAlignment = .center
        showDrivingSafetyLabel.font = UIFont.boldSystemFont(ofSize: 10)
        showDrivingSafetyLabel.adjustsFontForContentSizeCategory = true
        showDrivingSafetyLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(showDrivingSafetyLabel)
        
       
        showColorCodeView = UIView(frame: CGRect.zero)
        showColorCodeView.backgroundColor = UIColor.red
        containerView.addSubview(showColorCodeView)
        
        showExcessiveIdleTimeLabel = UILabel()
        showExcessiveIdleTimeLabel.textAlignment = .center
        showExcessiveIdleTimeLabel.adjustsFontSizeToFitWidth = true
        showExcessiveIdleTimeLabel.font = UIFont.boldSystemFont(ofSize: 10)
        showExcessiveIdleTimeLabel.adjustsFontForContentSizeCategory = true
        showExcessiveIdleTimeLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(showExcessiveIdleTimeLabel)
        
        drivingSafetyLabel = UILabel()
        drivingSafetyLabel.text = "DRIVING SAFETY SCORE"
        drivingSafetyLabel.textAlignment = .center
        drivingSafetyLabel.textColor = .black
        drivingSafetyLabel.font = UIFont.systemFont(ofSize: 11, weight: .thin)
        drivingSafetyLabel.adjustsFontForContentSizeCategory = true
        drivingSafetyLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(drivingSafetyLabel)
        
        colorCodeLabel = UILabel()
        colorCodeLabel.text = "COLOR CODE"
        colorCodeLabel.textColor = .black
        colorCodeLabel.textAlignment = .center
        colorCodeLabel.font = UIFont.systemFont(ofSize: 11, weight: .thin)
        colorCodeLabel.adjustsFontForContentSizeCategory = true
        colorCodeLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(colorCodeLabel)
        
        excessiveIdleTimeLabel = UILabel()
        excessiveIdleTimeLabel.text = "EXCESSIVE IDLE TIME"
        excessiveIdleTimeLabel.textColor = .black
        excessiveIdleTimeLabel.textAlignment = .center
        excessiveIdleTimeLabel.font = UIFont.systemFont(ofSize: 11, weight: .thin)
        excessiveIdleTimeLabel.adjustsFontForContentSizeCategory = true
        excessiveIdleTimeLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(excessiveIdleTimeLabel)

        
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
        showaverageLabel.font = UIFont.boldSystemFont(ofSize: 11)
        showaverageLabel.adjustsFontForContentSizeCategory = true
        showaverageLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(showaverageLabel)
        
        
        photoView = UIView()
        photoView.backgroundColor = .white
        photoView.layer.cornerRadius = 6
        photoView.layer.masksToBounds = true
        containerView.addSubview(photoView)
        
        photoLabel = UILabel()
        photoLabel.text = "Safety Event Count: 0"
        photoLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        photoLabel.textColor = .black
        photoView.addSubview(photoLabel)

        
    }
    
    
    
    func addConstransts(){
        containerView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview()//.offset(10)
            make.bottom.equalToSuperview()//.offset(-10)
        }
        carNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(carNameLabel.snp.bottom).offset(5)//changes done here
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview().multipliedBy(0.10)
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        
        photoView.snp.makeConstraints{(make) in
        
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(30)
            make.width.equalToSuperview().multipliedBy(0.40)
        }
        
        photoLabel.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
        }


        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(containerView.snp.left).offset(4)
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.45)
            make.width.equalTo(containerView).multipliedBy(0.44)
        }
        leftLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(leftView)
            make.top.equalTo(leftView.snp.top).offset(5)
            make.height.equalToSuperview().multipliedBy(0.07)
            make.width.equalTo(leftView).multipliedBy(0.4)
        }
        leftTextView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView).offset(5)
            make.right.equalTo(leftView).offset(-10)
            make.top.equalTo(leftLabel.snp.bottom)
            make.bottom.equalTo(leftView)
        }
      

        rightView.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(leftView)
            make.right.equalTo(containerView.snp.right).offset(-4)
        }
 
        rightLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(rightView)
            make.top.height.width.equalTo(leftLabel)
        }
        rightTextView.snp.makeConstraints { (make) in
            make.left.equalTo(rightView).offset(5)
            make.top.height.width.equalTo(leftTextView)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftTextView)
            make.top.equalTo(leftView.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.30)
        }
        showdistaceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceLabel)
            make.top.equalTo(distanceLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalTo(distanceLabel)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(firstBlackLine.snp.right).offset(5)
            make.right.equalTo(secondBlackLine.snp.left).offset(-5)
            make.top.height.equalTo(distanceLabel)
        }
        averageLabel.snp.makeConstraints { (make) in
            make.right.equalTo(rightTextView)
            make.top.height.width.equalTo(distanceLabel)
        }
        showaverageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(averageLabel.snp.left)
           make.top.equalTo(averageLabel.snp.bottom).offset(5)
           make.height.equalToSuperview().multipliedBy(0.05)
           make.width.equalTo(averageLabel)
            
        }
        firstBlackLine.snp.makeConstraints { (make) in
            make.left.equalTo(distanceLabel.snp.right).offset(3)
            make.top.equalTo(distanceLabel).offset(3)
            make.bottom.equalTo(showdistaceLabel).offset(-3)
            make.width.equalTo(1)

        }
        secondBlackLine.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(firstBlackLine)
            make.right.equalTo(averageLabel.snp.left).offset(-3)
        }
        seperator.snp.makeConstraints { (make) in
            make.top.equalTo(showdistaceLabel.snp.bottom)
            make.height.equalTo(1)
            make.width.equalToSuperview()
        }
        showtimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel.snp.left)
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalTo(timeLabel)
            
        }
        
        
        drivingSafetyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(distanceLabel)
            make.top.equalTo(showdistaceLabel.snp.bottom).offset(5)
            make.height.width.equalTo(distanceLabel)
        }
        showDrivingSafetyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(drivingSafetyLabel)
            make.top.equalTo(drivingSafetyLabel.snp.bottom).offset(5)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalTo(drivingSafetyLabel)
        }
        
        colorCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(thirdBlackLine.snp.right).offset(5)
            make.right.equalTo(fourthBlackLine.snp.left).offset(-5)
            make.top.height.equalTo(drivingSafetyLabel)
        }
        excessiveIdleTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(averageLabel.snp.right)
            make.top.height.width.equalTo(drivingSafetyLabel)
        }
        showExcessiveIdleTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(excessiveIdleTimeLabel.snp.left)
           make.top.equalTo(excessiveIdleTimeLabel.snp.bottom).offset(5)
           make.height.equalToSuperview().multipliedBy(0.05)
           make.width.equalTo(excessiveIdleTimeLabel)
            
        }
        thirdBlackLine.snp.makeConstraints { (make) in
            make.left.equalTo(drivingSafetyLabel.snp.right).offset(3)
            make.top.equalTo(drivingSafetyLabel).offset(3)
            make.bottom.equalTo(showDrivingSafetyLabel).offset(-3)
            make.width.equalTo(1)

        }
        fourthBlackLine.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(thirdBlackLine)
            make.right.equalTo(excessiveIdleTimeLabel.snp.left).offset(-3)
        }
        showColorCodeView.snp.makeConstraints { (make) in
            make.centerX.equalTo(colorCodeLabel.snp.centerX)
            make.top.equalTo(colorCodeLabel.snp.bottom).offset(5)
            make.width.height.equalTo(20)
            
        }
        
        firstCircle.snp.makeConstraints { (make) in
           make.top.equalTo(leftView.snp.centerY)
           make.centerX.equalTo(leftView.snp.right)
           make.height.width.equalTo(12)
        }
        
        secondCircle.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(firstCircle)
            make.centerX.equalTo(rightView.snp.left)
        }
        
        aLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(firstCircle.snp.centerY)
            make.left.equalTo(firstCircle.snp.right)
            make.right.equalTo(secondCircle.snp.left)
            make.height.equalTo(firstCircle).multipliedBy(0.3)
        }
        
    }
}


//
//  BottomSheetView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//
import UIKit
import SnapKit

class BottomSheetView: UIView {
    
    var featureScroll: BottomSheetViewCell!
    var locationImage: UIImageView!
    var locationLabel: UILabel!
    var back: UIView!
    //    var tripD: DetailedLabel!
    //    var tripDuration: DetailedLabel!
    //    var numberofStops: DetailedLabel!
    //    var idleTime: DetailedLabel!
    //    var maxSpeed: DetailedLabel!
    //    var totalDistance: DetailedLabel!
    
    var odoLableHeader: UILabel!
    var odoImage: UIImageView!
    var odoValueLabel: UILabel!
    var odoValueUnit: UILabel!
    
    var speedLableHeader: UILabel!
    var speedImage: UIImageView!
    var speedValueLabel: UILabel!
    var speedValueUnit: UILabel!
    
    var fuelLableHeader: UILabel!
    var fuelImage: UIImageView!
    var fuelValueLabel: UILabel!
    var fuelValueUnit: UILabel!
    
    var lineView: UIView!
    var line1View: UIView!
    var line2View: UIView!
    var darkView: UIView!
    var lastUpdateLabel: UILabel!
    var moreInfoButton: UIButton!
    var odometerView: UIView!
    var speedometerView: UIView!
    var fuelmeterView: UIView!
    var tripDetailsCollection: UICollectionView!
//    var rightbutton: UIButton!
//    var leftbutton: UIButton!
    var backgroundView: UIView!
    var liveshareView: UIView!
    var liveshareImage: UIImageView!
    var liveshareLabel: UILabel!
    var calldriverView: UIView!
    var calldriverImage: UIImageView!
    var calldriverLabel: UILabel!
    var pathreplayView: UIView!
    var pathreplayImage: UIImageView!
    var pathreplayLabel: UILabel!
    var addphotoView: UIView!
    var addphotoImage: UIImageView!
    var addphotoLabel: UILabel!
    var refreshImage: UIImageView!
    var gpsLabel: UILabel!
    var gpsImage: UIImageView!
    var networkLabel: UILabel!
    var networkImage: UIImageView!
    var powerLabel: UILabel!
    var powerImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        //addbutton()
        addConstraints()
        
        backgroundColor = appDarkTheme//UIColor(red: 40/255, green: 38/255, blue: 57/255, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        featureScroll = BottomSheetViewCell(frame: CGRect.zero)
        featureScroll.setContentOffset(
            CGPoint(x: 0,y: -self.featureScroll.contentInset.top),
            animated: true)
        featureScroll.backgroundColor = .clear
        featureScroll.alwaysBounceHorizontal = true
        featureScroll.contentMode = .right
        featureScroll.contentSize = CGSize(width: self.frame.width * 2, height: self.frame.height * 0.2)
        featureScroll.showsHorizontalScrollIndicator = false
        addSubview(featureScroll)
        
        backgroundView = UIView(frame: CGRect.zero)
        backgroundView.backgroundColor = .white
        addSubview(backgroundView)
        
        liveshareView = UIView(frame: CGRect.zero)
        liveshareView.backgroundColor = UIColor(red: 96/255, green: 116/255, blue: 229/255, alpha: 1.0)
        liveshareView.layer.cornerRadius = 5
        liveshareView.layer.masksToBounds = true
        backgroundView.addSubview(liveshareView)
        
        liveshareLabel = UILabel(frame: CGRect.zero)
        liveshareLabel.text = "LIVE SHARE"
        liveshareLabel.textAlignment = .center
        liveshareLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        liveshareLabel.textColor = .black
        liveshareLabel.backgroundColor = UIColor(red: 233/255, green: 240/255, blue: 255/255, alpha: 1.0)
        liveshareView.addSubview(liveshareLabel)

        liveshareImage = UIImageView(frame: CGRect.zero)
        if let myImage = UIImage(named: "sharebuttonicon") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            liveshareImage.image = tintableImage
        }
        liveshareImage.tintColor = UIColor.white
        liveshareImage.contentMode = .scaleAspectFit
        liveshareView.addSubview(liveshareImage)
        
        
        calldriverView = UIView(frame: CGRect.zero)
        calldriverView.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1.0)
        calldriverView.layer.cornerRadius = 5
        calldriverView.layer.masksToBounds = true
        backgroundView.addSubview(calldriverView)
        
        calldriverLabel = UILabel(frame: CGRect.zero)
        calldriverLabel.text = "CALL DRIVER"
        calldriverLabel.textAlignment = .center
        calldriverLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        calldriverLabel.textColor = .black
        calldriverLabel.backgroundColor = UIColor(red: 233/255, green: 240/255, blue: 255/255, alpha: 1.0)
        calldriverView.addSubview(calldriverLabel)
        
        calldriverImage = UIImageView(frame: CGRect.zero)
        if let myImage = UIImage(named: "call0") {
//            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            calldriverImage.image = myImage
        }
        calldriverImage.tintColor = UIColor.white
        calldriverImage.contentMode = .scaleAspectFit
        calldriverView.addSubview(calldriverImage)
        
        pathreplayView = UIView(frame: CGRect.zero)
        pathreplayView.backgroundColor = UIColor(red: 85/255, green: 157/255, blue: 242/255, alpha: 1.0)
        pathreplayView.layer.cornerRadius = 5
        pathreplayView.layer.masksToBounds = true
        backgroundView.addSubview(pathreplayView)
        
        pathreplayLabel = UILabel(frame: CGRect.zero)
        pathreplayLabel.text = "PATH REPLAY"
        pathreplayLabel.textAlignment = .center
        pathreplayLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        pathreplayLabel.textColor = .black
        pathreplayLabel.backgroundColor = UIColor(red: 233/255, green: 240/255, blue: 255/255, alpha: 1.0)
        pathreplayView.addSubview(pathreplayLabel)
        
        pathreplayImage = UIImageView(frame: CGRect.zero)
        if let myImage = UIImage(named: "pathreplay") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            pathreplayImage.image = tintableImage
        }
        pathreplayImage.tintColor = UIColor.white
        pathreplayImage.contentMode = .scaleAspectFit
        pathreplayView.addSubview(pathreplayImage)
        
        addphotoView = UIView(frame: CGRect.zero)
        addphotoView.backgroundColor = UIColor(red: 246/255, green: 71/255, blue: 67/255, alpha: 1.0)
        addphotoView.layer.cornerRadius = 5
        addphotoView.layer.masksToBounds = true
        backgroundView.addSubview(addphotoView)
        
        addphotoLabel = UILabel(frame: CGRect.zero)
        addphotoLabel.text = "ADD PHOTOS"
        addphotoLabel.textAlignment = .center
        addphotoLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        addphotoLabel.textColor = .black
        addphotoLabel.backgroundColor = UIColor(red: 233/255, green: 240/255, blue: 255/255, alpha: 1.0)
        addphotoView.addSubview(addphotoLabel)
        
        addphotoImage = UIImageView(frame: CGRect.zero)
        if let myImage = UIImage(named: "addphoto") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            addphotoImage.image = tintableImage
        }
        addphotoImage.tintColor = UIColor.white
        addphotoImage.contentMode = .scaleAspectFit
        addphotoView.addSubview(addphotoImage)
        
        
        lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = .white
        addSubview(lineView)
        
        line1View = UIView(frame: CGRect.zero)
        line1View.backgroundColor = .lightGray
        addSubview(line1View)
        
        line2View = UIView(frame: CGRect.zero)
        line2View.backgroundColor = .white
        addSubview(line2View)
        
        darkView = UIView(frame: CGRect.zero)
        darkView.backgroundColor = .black//UIColor(red: 29/255, green: 28/255, blue: 41/255, alpha: 1)
        addSubview(darkView)
        
        refreshImage = UIImageView()
        refreshImage.contentMode = .scaleAspectFit
        refreshImage.clipsToBounds = true
        refreshImage.image = #imageLiteral(resourceName: "sync")
        addSubview(refreshImage)
        
        
        lastUpdateLabel = UILabel(frame: CGRect.zero)
        lastUpdateLabel.text = "Last update: 0 Mins ago (xx-xx-xxxx, xx:xx pm)"
        lastUpdateLabel.textColor = .white
        lastUpdateLabel.textAlignment = .center
        lastUpdateLabel.backgroundColor = .clear
        lastUpdateLabel.font = UIFont.italicSystemFont(ofSize: 10)
        addSubview(lastUpdateLabel)
        

        
        powerLabel = UILabel.init(frame: CGRect.zero)
        powerLabel.text = "POWER"
        powerLabel.textColor = .white
        powerLabel.font = UIFont.systemFont(ofSize: 11)
        powerLabel.textAlignment = .center
        addSubview(powerLabel)
        
        powerImage = UIImageView()
        powerImage.contentMode = .scaleAspectFit
        powerImage.clipsToBounds = true
        powerImage.image = #imageLiteral(resourceName: "lowbat")
        addSubview(powerImage)
        
        networkLabel = UILabel.init(frame: CGRect.zero)
        networkLabel.text = "Network"
        networkLabel.textColor = .white
        networkLabel.font = UIFont.systemFont(ofSize: 11)
        networkLabel.textAlignment = .center
        addSubview(networkLabel)
        
        networkImage = UIImageView()
        networkImage.contentMode = .scaleAspectFit
        networkImage.clipsToBounds = true
        networkImage.image = #imageLiteral(resourceName: "netoff")
        addSubview(networkImage)
        
        gpsLabel = UILabel.init(frame: CGRect.zero)
        gpsLabel.text = "GPS"
        gpsLabel.textColor = .white
        gpsLabel.font = UIFont.systemFont(ofSize: 11)
        gpsLabel.textAlignment = .center
        addSubview(gpsLabel)
        
        gpsImage = UIImageView()
        gpsImage.contentMode = .scaleAspectFit
        gpsImage.clipsToBounds = true
        gpsImage.image = #imageLiteral(resourceName: "Layer 2-2")
        addSubview(gpsImage)
        
        
        
        locationImage = UIImageView(frame: CGRect.zero)
        locationImage.image = #imageLiteral(resourceName: "mapWhite")
        locationImage.backgroundColor = .clear
        locationImage.contentMode = .scaleAspectFit
        addSubview(locationImage)
        
        locationLabel = UILabel(frame: CGRect.zero)
        locationLabel.text = "Address not available"
        locationLabel.numberOfLines = 3
        locationLabel.textAlignment = .left
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.font = UIFont.boldSystemFont(ofSize: 10)
        locationLabel.textColor = .white
        addSubview(locationLabel)
        
        moreInfoButton = UIButton(frame: CGRect.zero)
        moreInfoButton.backgroundColor = UIColor(red: 49/255, green: 176/255, blue: 159/255, alpha: 1.0)
        moreInfoButton.setTitle("MORE INFO", for: .normal)
        moreInfoButton.setTitleColor(.white, for: .normal)
        moreInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        moreInfoButton.layer.cornerRadius = 5
        moreInfoButton.layer.masksToBounds = true
        addSubview(moreInfoButton)
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: kscreenwidth * 0.9,
                                 height: kscreenheight * 0.1)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        tripDetailsCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        tripDetailsCollection.backgroundColor = .black
        tripDetailsCollection.isPagingEnabled = true
        
        tripDetailsCollection.layer.cornerRadius = 5
        tripDetailsCollection.layer.masksToBounds = true
        tripDetailsCollection.reloadData()
        addSubview(tripDetailsCollection)
        
       
        
        odometerView = UIView(frame: CGRect.zero)
        odometerView.backgroundColor = .black
        odometerView.layer.cornerRadius = 5
        odometerView.layer.masksToBounds = true
        addSubview(odometerView)
        
        odoLableHeader = UILabel(frame: CGRect.zero)
        odoLableHeader.text = "Odometer"
        odoLableHeader.textColor = UIColor(red: 85/255, green: 156/255, blue: 244/255, alpha: 1)
        odoLableHeader.font = UIFont.systemFont(ofSize: 13)
        odometerView.addSubview(odoLableHeader)
        
        odoImage = UIImageView(frame: CGRect.zero)
        odoImage.image = #imageLiteral(resourceName: "odo")
        odoImage.backgroundColor = .clear
        odoImage.contentMode = .scaleAspectFit
        odometerView.addSubview(odoImage)
        
        odoValueLabel = UILabel(frame: CGRect.zero)
        odoValueLabel.text = "0.0"
        odoValueLabel.adjustsFontSizeToFitWidth = true
        odoValueLabel.textAlignment = .left
        odoValueLabel.textColor = .white
        odoValueLabel.font = UIFont.systemFont(ofSize: 13)
        odometerView.addSubview(odoValueLabel)
        
        odoValueUnit = UILabel(frame:CGRect.zero)
        odoValueUnit.text = "km"
        odoValueUnit.textAlignment = .left
        odoValueUnit.textColor = .white
        odoValueUnit.font = UIFont.systemFont(ofSize: 12)
        odometerView.addSubview(odoValueUnit)
        
        
        speedometerView = UIView(frame: CGRect.zero)
        speedometerView.backgroundColor = .black
        speedometerView.layer.cornerRadius = 5
        speedometerView.layer.masksToBounds = true
        addSubview(speedometerView)
        
        speedLableHeader = UILabel(frame: CGRect.zero)
        speedLableHeader.text = "Current Speed"
        speedLableHeader.textColor = UIColor(red: 200/255, green: 172/255, blue: 0/255, alpha: 1)
        speedLableHeader.font = UIFont.systemFont(ofSize: 13)
        speedometerView.addSubview(speedLableHeader)
        
        speedImage = UIImageView(frame: CGRect.zero)
        speedImage.image = #imageLiteral(resourceName: "speed")
        speedImage.backgroundColor = .clear
        speedImage.contentMode = .scaleAspectFit
        speedometerView.addSubview(speedImage)
        
        speedValueLabel = UILabel(frame: CGRect.zero)
        speedValueLabel.text = "0"
        speedValueLabel.adjustsFontSizeToFitWidth = true
        speedValueLabel.textAlignment = .left
        speedValueLabel.textColor = .white
        speedValueLabel.font = UIFont.systemFont(ofSize: 13)
        speedometerView.addSubview(speedValueLabel)
        
        speedValueUnit = UILabel(frame:CGRect.zero)
        speedValueUnit.text = "kmph"
        speedValueUnit.textAlignment = .left
        speedValueUnit.textColor = .white
        speedValueUnit.font = UIFont.systemFont(ofSize: 12)
        speedometerView.addSubview(speedValueUnit)
        
        fuelmeterView = UIView(frame: CGRect.zero)
        fuelmeterView.backgroundColor = .black
        fuelmeterView.layer.cornerRadius = 5
        fuelmeterView.layer.masksToBounds = true
        addSubview(fuelmeterView)
        
        
        fuelLableHeader = UILabel(frame: CGRect.zero)
        fuelLableHeader.text = "Fuel Filled"
        fuelLableHeader.isUserInteractionEnabled = true
        fuelLableHeader.textColor = UIColor(red: 246/255, green: 71/255, blue: 68/255, alpha: 1)
        fuelLableHeader.font = UIFont.systemFont(ofSize: 13)
        fuelmeterView.addSubview(fuelLableHeader)
        
        fuelImage = UIImageView(frame: CGRect.zero)
        fuelImage.image = #imageLiteral(resourceName: "fuel-1")
        fuelImage.backgroundColor = .clear
        fuelImage.isUserInteractionEnabled = true
        fuelImage.contentMode = .scaleAspectFit
        fuelmeterView.addSubview(fuelImage)
        
        fuelValueLabel = UILabel(frame: CGRect.zero)
        fuelValueLabel.text = "N/A"
        fuelValueLabel.adjustsFontSizeToFitWidth = true
        fuelValueLabel.textAlignment = .left
        fuelValueLabel.isUserInteractionEnabled = true
        fuelValueLabel.textColor = .white
        fuelValueLabel.font = UIFont.systemFont(ofSize: 13)
        fuelmeterView.addSubview(fuelValueLabel)
        
        fuelValueUnit = UILabel(frame:CGRect.zero)
        fuelValueUnit.text = "litres"
        fuelValueUnit.textAlignment = .left
        fuelValueUnit.isUserInteractionEnabled = true
        fuelValueUnit.textColor = .white
        fuelValueUnit.font = UIFont.systemFont(ofSize: 12)
        fuelmeterView.addSubview(fuelValueUnit)
        
        
    }
    
//    func addbutton()
//    {
//
//        leftbutton = UIButton(frame: CGRect.zero)
//        leftbutton.setImage(UIImage(named: "lefticon-1"), for: .normal)
//        leftbutton.contentMode = .scaleAspectFit
//        leftbutton.backgroundColor = .black
//        leftbutton.sizeToFit()
//        addSubview(leftbutton)
//        //leftbutton.addTarget(self, action: #selector(leftbtnAction), for: .touchUpInside)
//
//        rightbutton = UIButton(frame: CGRect.zero)
//        rightbutton.setImage(UIImage(named: "righticon"), for: .normal)
//        rightbutton.contentMode = .scaleAspectFit
//        rightbutton.backgroundColor = .black
//        addSubview(rightbutton)
//        //rightbutton.addTarget(self, action: #selector(rightbtnAction), for: .touchUpInside)
//    }
    
    
    func addConstraints() -> Void {
        
        backgroundView.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.13)
        }
        
        
        pathreplayView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.002 * kscreenheight)
            make.width.equalTo(0.22 * kscreenwidth)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.equalToSuperview().offset(0.03 * kscreenwidth)
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
        }
        pathreplayLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        pathreplayImage.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(pathreplayLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.width.equalTo(0.07 * kscreenwidth)
            make.height.equalTo(0.03 * kscreenheight)
        }
        
        calldriverView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.002 * kscreenheight)
            make.width.equalTo(0.22 * kscreenwidth)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.equalTo(liveshareView.snp.right).offset(0.02 * kscreenwidth)
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
        }
        calldriverLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        calldriverImage.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(calldriverLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.width.equalTo(0.11 * kscreenwidth)
            make.height.equalTo(0.03 * kscreenheight)
        }
        
        liveshareView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.002 * kscreenheight)
            make.width.equalTo(0.22 * kscreenwidth)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.equalTo(addphotoView.snp.right).offset(0.02 * kscreenwidth)
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
        }
        liveshareLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        liveshareImage.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(liveshareLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.width.equalTo(0.07 * kscreenwidth)
            make.height.equalTo(0.03 * kscreenheight)
        }
        
        addphotoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.002 * kscreenheight)
            make.width.equalTo(0.22 * kscreenwidth)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.equalTo(pathreplayView.snp.right).offset(0.02 * kscreenwidth)
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
        }
        addphotoLabel.snp.makeConstraints{(make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        addphotoImage.snp.makeConstraints{(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(addphotoLabel.snp.bottom).offset(0.011 * kscreenheight)
            make.width.equalTo(0.07 * kscreenwidth)
            make.height.equalTo(0.03 * kscreenheight)
        }
        
        
        
        
        
        darkView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.snp.bottom).offset(1)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalToSuperview()
        }
        refreshImage.snp.makeConstraints{ (make) in
            make.top.equalTo(backgroundView.snp.bottom).offset(1)
            make.left.equalTo(lastUpdateLabel.snp.right).offset(100)
            make.centerX.equalTo(darkView.snp.centerX)
            make.height.equalTo(20)
        }
        
        gpsImage.snp.makeConstraints { (make) in
            make.top.equalTo(darkView.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.07)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        gpsLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(gpsImage)
            make.top.equalTo(gpsImage.snp.bottom).offset(05)
            make.height.equalTo(20)
            
        }
        networkImage.snp.makeConstraints { (make) in
            make.top.equalTo(darkView.snp.bottom)
            make.left.equalTo(gpsImage.snp.right).offset(140)
            make.width.equalToSuperview().multipliedBy(0.07)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        networkLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(networkImage)
            make.top.equalTo(networkImage.snp.bottom)
            make.height.equalTo(20)

        }
        powerImage.snp.makeConstraints { (make) in
            make.top.equalTo(darkView.snp.bottom)
            make.left.equalTo(networkImage.snp.right).offset(130)
            make.width.equalToSuperview().multipliedBy(0.07)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        powerLabel.snp.makeConstraints{ (make) in
            make.centerX.equalTo(powerImage)
            make.top.equalTo(powerImage.snp.bottom)
            make.height.equalTo(15)

        }

        
        locationImage.snp.makeConstraints { (make) in
            make.top.equalTo(gpsLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.08)
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(locationImage)
            make.left.equalTo(locationImage.snp.right).offset(10)
            make.width.equalTo(0.6 * kscreenwidth)
            make.height.equalToSuperview().multipliedBy(0.1)
            
        }
        moreInfoButton.snp.makeConstraints{(make) in
            make.top.equalTo(powerLabel.snp.bottom).offset(15)
            make.right.equalTo(-0.02 * kscreenwidth)
            make.width.equalTo(0.2 * kscreenwidth)
            make.height.equalTo(0.04 * kscreenheight)
        }
        
        tripDetailsCollection.snp.makeConstraints{(make) in
            make.top.equalTo(locationImage.snp.bottom).offset(kscreenheight * 0.012)
            make.width.equalTo(0.9 * kscreenwidth)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.08 * kscreenheight)
        }
        
//        rightbutton.snp.makeConstraints { (make) in
//            //                make.top.equalTo(tripDetailsCollection.snp.top).offset(tripDetailsCollection.bounds.height).dividedBy(4)
//            make.centerY.equalTo(tripDetailsCollection)
//            make.width.height.equalTo(27)
//            make.right.equalTo(-0.016 * kscreenwidth)
//        }
//
//        leftbutton.snp.makeConstraints { (make) in
//            make.centerY.equalTo(tripDetailsCollection)
//            make.width.height.equalTo(27)
//            make.left.equalTo(0.016 * kscreenwidth)
//        }
        //        back.snp.makeConstraints { (make) in
        //            make.top.equalTo(locationImage.snp.bottom).offset(10)
        //            make.width.equalToSuperview()
        //            make.centerX.equalToSuperview()
        //            make.height.equalToSuperview().multipliedBy(0.26)
        //        }
        //
        //        tripD.snp.makeConstraints { (make) in
        //            make.top.equalToSuperview().offset(5)
        //            make.height.equalToSuperview().dividedBy(2)
        //            make.left.equalToSuperview()
        //            make.width.equalToSuperview().dividedBy(3)
        //        }
        //
        //        tripDuration.snp.makeConstraints { (make) in
        //            make.top.equalToSuperview().offset(5)
        //            make.height.equalToSuperview().dividedBy(2)
        //            make.left.equalTo(tripD.snp.right)
        //            make.width.equalToSuperview().dividedBy(3)
        //        }
        //
        //        numberofStops.snp.makeConstraints { (make) in
        //            make.top.equalToSuperview().offset(5)
        //            make.height.equalToSuperview().dividedBy(2)
        //            make.right.equalToSuperview()
        //            make.width.equalToSuperview().dividedBy(3)
        //        }
        //
        //        idleTime.snp.makeConstraints { (make) in
        //            make.top.equalTo(tripD.snp.bottom)
        //            make.height.equalToSuperview().dividedBy(2)
        //            make.left.equalToSuperview()
        //            make.width.equalToSuperview().dividedBy(3)
        //        }
        //
        //
        //        maxSpeed.snp.makeConstraints { (make) in
        //            make.top.height.width.equalTo(idleTime)
        //            make.left.equalTo(idleTime.snp.right)
        //        }
        //
        //
        //        totalDistance.snp.makeConstraints { (make) in
        //            make.top.height.width.equalTo(idleTime)
        //            make.right.equalToSuperview()
        //        }
        
        odometerView.snp.makeConstraints{(make) in
           // make.top.equalTo(tripDetailsCollection.snp.bottom).offset(0.001 * kscreenheight)
            make.bottom.equalToSuperview().offset(-0.09 * kscreenheight)
            make.width.equalTo(0.32 * kscreenwidth)
            make.left.equalTo(0.01 * kscreenwidth)
            make.height.equalTo(0.11 * kscreenheight)
        }
        
        odoLableHeader.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //            make.width.equalToSuperview().multipliedBy(0.25)
            //            make.height.equalToSuperview().multipliedBy(0.04)
        }
        
        
        odoValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(odoLableHeader.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //                    make.width.equalToSuperview().multipliedBy(0.15)
            //                    make.height.equalToSuperview().multipliedBy(0.05)
            
        }
        
        
        odoValueUnit.snp.makeConstraints { (make) in
            make.top.equalTo(odoValueLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //                    make.width.equalToSuperview().multipliedBy(0.12)
            //                    make.height.equalToSuperview().multipliedBy(0.04)
        }
        
        odoImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
            make.right.equalToSuperview().offset(-0.01 * kscreenwidth)
            make.width.equalTo(0.08 * kscreenwidth)
            make.height.equalTo(0.06 * kscreenheight)
        }
        
        
        speedometerView.snp.makeConstraints{(make) in
           // make.top.equalTo(tripDetailsCollection.snp.bottom).offset(0.001 * kscreenheight)
            make.bottom.equalToSuperview().offset(-0.09 * kscreenheight)
            make.width.equalTo(0.32 * kscreenwidth)
            make.left.equalTo(odometerView.snp.right).offset(0.01 * kscreenwidth)
            make.height.equalTo(0.11 * kscreenheight)
        }
        
        speedLableHeader.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //            make.width.equalToSuperview().multipliedBy(0.25)
            //            make.height.equalToSuperview().multipliedBy(0.04)
        }
        
        
        speedValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(speedLableHeader.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //                    make.width.equalToSuperview().multipliedBy(0.15)
            //                    make.height.equalToSuperview().multipliedBy(0.05)
            
        }
        
        
        speedValueUnit.snp.makeConstraints { (make) in
            make.top.equalTo(speedValueLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //                    make.width.equalToSuperview().multipliedBy(0.12)
            //                    make.height.equalToSuperview().multipliedBy(0.04)
        }
        
        speedImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
            make.right.equalToSuperview().offset(-0.01 * kscreenwidth)
            make.width.equalTo(0.08 * kscreenwidth)
            make.height.equalTo(0.06 * kscreenheight)
        }
        
        
        fuelmeterView.snp.makeConstraints{(make) in
            //make.top.equalTo(tripDetailsCollection.snp.bottom).offset(0.001 * kscreenheight)
            make.bottom.equalToSuperview().offset(-0.09 * kscreenheight)
            make.width.equalTo(0.32 * kscreenwidth)
            make.left.equalTo(speedometerView.snp.right).offset(0.01 * kscreenwidth)
            make.height.equalTo(0.11 * kscreenheight)
        }
        
        fuelLableHeader.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //            make.width.equalToSuperview().multipliedBy(0.25)
            //            make.height.equalToSuperview().multipliedBy(0.04)
        }
        
        
        fuelValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fuelLableHeader.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
            //                    make.width.equalToSuperview().multipliedBy(0.15)
            //                    make.height.equalToSuperview().multipliedBy(0.05)
            
        }
        
        
        fuelValueUnit.snp.makeConstraints { (make) in
            make.top.equalTo(fuelValueLabel.snp.bottom).offset(0.01 * kscreenheight)
            make.left.equalToSuperview().offset(0.01 * kscreenwidth)
        }
        
        fuelImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-0.01 * kscreenheight)
            make.right.equalToSuperview().offset(-0.01 * kscreenwidth)
            make.width.equalTo(0.08 * kscreenwidth)
            make.height.equalTo(0.06 * kscreenheight)
        }
        lastUpdateLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(0.07)
            make.height.equalToSuperview().multipliedBy(0.05)
            make.centerX.equalTo(darkView.snp.centerX)
            make.top.equalTo(darkView.snp.top)
        }
        
        
        
    }
    
    
    
    
}

//
//  DashboardView.swift
//  Bolt
//
//  Created by Roadcast on 08/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class DashboardView: UIView {
    //MARK: properties
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    let scrollview = UIScrollView()
    let circularRing = CircularProgressBar()
    let circularRing2 = CircularProgressBar()
    let circularRing3 = CircularProgressBar()
    //let ContentView = UIView ()
    let progressBarView = UIView()
    var totalVehiclesContainerView = UIView()
    var insidefenceContainerView = UIView()
    var inactiveContainerView = UIView()
    var outsideContainerView = UIView()
    var Dashboard = UILabel()
    let TotalDistance = UILabel()
    let TotalDistanceContainer = UIView()
    var distance = UILabel()
    let greenline = UIView()
    var selectVehicleTextField = UITextField()
    var cancelBtn = UIButton()
    var TotalVehicles = UILabel()
    var Inactive = UILabel()
    var Inside = UILabel()
    var Outside = UILabel()
    var totalVehiclesDataLabel = UILabel()
    
    var insidefenceDataLabel = UILabel()
    var inactiveDataLabel = UILabel()
    var outsideDataLabel = UILabel()
    var Inactivelab = UILabel()
    var IgnitionOnlab = UILabel()
    var IgnitionOfflab = UILabel()
    var purplebox = UIImageView()
    var cyanbox = UIImageView()
    var redbox = UIImageView()
    var graphCollectionView: UICollectionView!
    //  var datacolors = ["red" , "green" , "cyan"]
    var leftbutton : UIButton!
    var rightbutton : UIButton!
    var totalVehicleImageIcon : UIImageView!
    var inactiveImageIcon:UIImageView!
    var insideFenceImageIcon:UIImageView!
    var outsideFenceImageIcon:UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        addview()
        addlabel()
        addCircularRing()
        addbutton()
        addConstraints()
    }
    func addview(){
        scrollview.backgroundColor = .appbackgroundcolor
        scrollview.isScrollEnabled = true
        scrollview.isDirectionalLockEnabled = true
        scrollview.bounces = false
        scrollview.isExclusiveTouch = false
        scrollview.delaysContentTouches = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollview)
        
        //      ContentView.backgroundColor = .appbackgroundcolor
        //      ContentView.translatesAutoresizingMaskIntoConstraints = false
        //      scrollview.addSubview(ContentView)
        
        totalVehiclesContainerView = UIView(frame: .zero)
        totalVehiclesContainerView.backgroundColor = .appviewbgcolor
        totalVehiclesContainerView.layer.cornerRadius = 10
        totalVehiclesContainerView.layer.masksToBounds = false
        scrollview.addSubview(totalVehiclesContainerView)
        
        insidefenceContainerView = UIView(frame: .zero)
        insidefenceContainerView.backgroundColor = .appviewbgcolor
        insidefenceContainerView.layer.cornerRadius = 10
        totalVehiclesContainerView.layer.masksToBounds = false
        scrollview.addSubview(insidefenceContainerView)
        
        inactiveContainerView = UIView(frame: .zero)
        inactiveContainerView.backgroundColor = .appviewbgcolor
        inactiveContainerView.layer.cornerRadius = 10
        totalVehiclesContainerView.layer.masksToBounds = false
        scrollview.addSubview(inactiveContainerView)
        
        outsideContainerView = UIView(frame: .zero)
        outsideContainerView.backgroundColor = .appviewbgcolor
        outsideContainerView.layer.cornerRadius = 10
        totalVehiclesContainerView.layer.masksToBounds = false
        scrollview.addSubview(outsideContainerView)
        
        TotalDistanceContainer.translatesAutoresizingMaskIntoConstraints = false
        TotalDistanceContainer.backgroundColor = .appviewbgcolor
        scrollview.addSubview(TotalDistanceContainer)
        
        progressBarView.backgroundColor = .appviewbgcolor
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(progressBarView)
        
        greenline.backgroundColor = .appGreen
        //        greenline.translatesAutoresizingMaskIntoConstraints = false
        scrollview.addSubview(greenline)
        
        
        
        purplebox.backgroundColor = .appPurple
        purplebox.layer.cornerRadius = 5
        purplebox.layer.masksToBounds = false
        progressBarView.addSubview(purplebox)
        
        cyanbox.backgroundColor = .appGreen
        cyanbox.layer.cornerRadius = 5
        cyanbox.layer.masksToBounds = false
        progressBarView.addSubview(cyanbox)
        
        redbox.backgroundColor = .red
        redbox.layer.cornerRadius = 5
        redbox.layer.masksToBounds = false
        progressBarView.addSubview(redbox)
        
        totalVehicleImageIcon = UIImageView(image: #imageLiteral(resourceName: "greenNotification"))
        totalVehicleImageIcon.contentMode = .scaleAspectFit
        totalVehiclesContainerView.addSubview(totalVehicleImageIcon)
        
        insideFenceImageIcon = UIImageView(image: #imageLiteral(resourceName: "geofenceicon"))
        insideFenceImageIcon.contentMode = .scaleAspectFit
        insidefenceContainerView.addSubview(insideFenceImageIcon)
        
        inactiveImageIcon = UIImageView(image: #imageLiteral(resourceName: "deleteicon"))
        inactiveImageIcon.contentMode = .scaleAspectFit
        inactiveContainerView.addSubview(inactiveImageIcon)
        
        outsideFenceImageIcon = UIImageView(image: #imageLiteral(resourceName: "Asset 11-1"))
        outsideFenceImageIcon.contentMode = .scaleAspectFit
        outsideContainerView.addSubview(outsideFenceImageIcon)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: -1, right: 0)
        layout.itemSize = CGSize(width: screensize.width,
                                 height: ScreenHeight * 0.50)
        graphCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        graphCollectionView.backgroundColor = .appbackgroundcolor
        graphCollectionView.setCollectionViewLayout(layout, animated: true)
        graphCollectionView.bounces = false
//        graphCollectionView.isPagingEnabled = true
        scrollview.addSubview(graphCollectionView)
    }
    
    func addlabel(){
        Dashboard.text = "Dashboard"
        Dashboard.textColor = UIColor.white
        Dashboard.font = UIFont.systemFont(ofSize: 32.0 , weight: .regular)
        scrollview.addSubview(Dashboard)
        
        TotalDistance.text = "Total Distance"
        TotalDistance.textColor = .appGreen
        TotalDistance.textAlignment = .left
        TotalDistance.font = UIFont.systemFont(ofSize: 23.0 , weight: .regular)
        TotalDistance.sizeToFit()
        TotalDistanceContainer.addSubview(TotalDistance)
        
        //  let dist = findTotalDistanceForAllDevices()
        
        //   distance.text = "\(dist)" + "Km"
        distance.textColor = .white
        distance.textAlignment = .left
        distance.font = UIFont.systemFont(ofSize: 30.0 , weight: .regular)
        distance.sizeToFit()
        distance.adjustsFontSizeToFitWidth = true
        TotalDistanceContainer.addSubview(distance)
        
        TotalVehicles.text = "Total Vehicles"
        TotalVehicles.textColor = .white
        TotalVehicles.textAlignment = .center
        TotalVehicles.font = UIFont.systemFont(ofSize: 15 , weight: .medium)
        TotalVehicles.sizeToFit()
        totalVehiclesContainerView.addSubview(TotalVehicles)
        
        Inactive.text = "Inactive(24 hrs)"
        Inactive.textColor = .white
        Inactive.textAlignment = .center
        Inactive.font = UIFont.systemFont(ofSize: 15 , weight: .medium)
        Inactive.sizeToFit()
        inactiveContainerView.addSubview(Inactive)
        
        Inside.text = "Inside fence"
        Inside.textColor = .white
        Inside.textAlignment = .center
        Inside.font = UIFont.systemFont(ofSize: 15 , weight: .medium)
        Inside.sizeToFit()
        insidefenceContainerView.addSubview(Inside)
        
        Outside.text = "Outside fence"
        Outside.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        
        Outside.textAlignment = .center
        Outside.font = UIFont.systemFont(ofSize: 15 , weight: .medium)
        Outside.sizeToFit()
        //    make.top.equalTo(totalVehiclesContainerView.snp.top)
        //       make.left.equalTo(totalVehiclesContainerView.snp.left)
        //       make.centerX.centerY.equalTo(totalVehiclesContainerView)
        outsideContainerView.addSubview(Outside)
        
        //   let totalVehicleCount = ignitionOffCount + ignitionOnCount + notActiveCount
        
        //      totalVehiclesDataLabel.text = "\(totalVehicleCount)"
        totalVehiclesDataLabel.textColor = .appGreen
        totalVehiclesDataLabel.textAlignment = .center
        totalVehiclesDataLabel.font = UIFont.systemFont(ofSize: 30 , weight: .medium)
        totalVehiclesDataLabel.sizeToFit()
        totalVehiclesContainerView.addSubview(totalVehiclesDataLabel)
        
        // insidefenceDataLabel.text = "\(geofenceInArray.count)"
        insidefenceDataLabel.textColor = .appPurple
        insidefenceDataLabel.textAlignment = .center
        insidefenceDataLabel.font = UIFont.systemFont(ofSize: 30 , weight: .medium)
        insidefenceDataLabel.sizeToFit()
        insidefenceContainerView.addSubview(insidefenceDataLabel)
        
        //  inactiveDataLabel.text = "\(notActiveCount)"
        inactiveDataLabel.textColor = .gray
        inactiveDataLabel.textAlignment = .center
        inactiveDataLabel.font = UIFont.systemFont(ofSize: 30 , weight: .medium)
        inactiveDataLabel.sizeToFit()
        inactiveContainerView.addSubview(inactiveDataLabel)
        
        //  outsideDataLabel.text = "\(geofenceOutArray.count)"
        outsideDataLabel.textColor = .red
        outsideDataLabel.textAlignment = .center
        outsideDataLabel.font = UIFont.systemFont(ofSize: 30 , weight: .medium)
        outsideDataLabel.sizeToFit()
        outsideContainerView.addSubview(outsideDataLabel)
        
        // namefield.placeholder = "select vehicle"
        selectVehicleTextField.layer.borderWidth = 1
        selectVehicleTextField.layer.cornerRadius = 5
        selectVehicleTextField.backgroundColor = .white
        selectVehicleTextField.textColor = .black
        selectVehicleTextField.text = "SELECT VEHICLE"
        selectVehicleTextField.textAlignment = .center
        selectVehicleTextField.allowsEditingTextAttributes = false
        scrollview.addSubview(selectVehicleTextField)
        
        cancelBtn.setImage(UIImage(named: "cross_white"), for: .normal)
        cancelBtn.isHidden = true
      //  cancelBtn.setTitleColor(appGreenTheme, for: .normal)
      //  cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        scrollview.addSubview(cancelBtn)
        
        Inactivelab.text = "Inactive (10 mins)"
        Inactivelab.numberOfLines = 1
        Inactivelab.textColor = UIColor.white
        Inactivelab.font = UIFont.systemFont(ofSize: 10.0)
        Inactivelab.sizeToFit()
        Inactivelab.isUserInteractionEnabled = true
        progressBarView.addSubview(Inactivelab)
        
        
        IgnitionOnlab.text = "Ignition On"
        IgnitionOnlab.numberOfLines = 1
        IgnitionOnlab.textColor = UIColor.white
        IgnitionOnlab.font = UIFont.systemFont(ofSize: 10.0)
        IgnitionOnlab.sizeToFit()
        IgnitionOnlab.isUserInteractionEnabled = true
        progressBarView.addSubview(IgnitionOnlab)
        
        
        IgnitionOfflab.text = "Ignition Off"
        IgnitionOfflab.numberOfLines = 1
        IgnitionOfflab.textColor = UIColor.white
        IgnitionOfflab.font = UIFont.systemFont(ofSize: 10.0)
        IgnitionOfflab.sizeToFit()
        IgnitionOfflab.isUserInteractionEnabled = true
        progressBarView.addSubview(IgnitionOfflab)
        
    }
    func addCircularRing(){
        circularRing.strokeColour = UIColor.appPurple.cgColor
        circularRing.labelSize = 20
        circularRing.isUserInteractionEnabled = true
        
        circularRing.safePercent = 10
        circularRing.setProgress(to: 1, withAnimation: false)
        circularRing.clipsToBounds = false
        progressBarView.addSubview(circularRing)
        
        circularRing2.strokeColour = UIColor.appGreen.cgColor
        circularRing2.labelSize = 20
        circularRing2.safePercent = 10
        circularRing2.setProgress(to: 1, withAnimation: false)
        circularRing2.clipsToBounds = false
        circularRing2.isUserInteractionEnabled = true
        progressBarView.addSubview(circularRing2)
        
        circularRing3.strokeColour = UIColor.appRed.cgColor
        circularRing3.labelSize = 20
        circularRing3.safePercent = 10
        circularRing3.setProgress(to: 1, withAnimation: false)
        circularRing3.clipsToBounds = false
        circularRing3.isUserInteractionEnabled = true
        progressBarView.addSubview(circularRing3)
    }
    
    func addConstraints(){
        scrollview.snp.makeConstraints{make in
            make.edges.equalToSuperview()
        }
        totalVehiclesContainerView.snp.makeConstraints { (make) in
            make.size.equalTo(screensize.width * 0.45)
           // make.height.equalToSuperview().multipliedBy(0.15)
            make.top.equalTo(Dashboard.snp.bottom).offset(ScreenHeight * 0.03)//50
            make.left.equalToSuperview().offset(15)
        }
        insidefenceContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(totalVehiclesContainerView.snp.bottom).offset(10)
            make.left.equalTo(totalVehiclesContainerView.snp.left)
            make.size.equalTo(totalVehiclesContainerView)
        }
        
        inactiveContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(totalVehiclesContainerView.snp.top)
            make.size.equalTo(totalVehiclesContainerView)
            make.left.equalTo(totalVehiclesContainerView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        outsideContainerView.snp.makeConstraints { (make) in
            make.top.equalTo(inactiveContainerView.snp.bottom).offset(10)
            make.left.equalTo(inactiveContainerView.snp.left)
            make.size.equalTo(totalVehiclesContainerView)
            make.right.equalTo(inactiveContainerView.snp.right)
        }
        Dashboard.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(scrollview.snp.top).offset(10)
            make.left.equalToSuperview().offset(15)
        }
        greenline.snp.makeConstraints { (make) in
            make.top.equalTo(insidefenceContainerView.snp.bottom).offset(20)
            make.left.equalTo(scrollview.snp.left)
            make.right.equalTo(TotalDistanceContainer.snp.left)
            make.width.equalTo(10)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        totalVehicleImageIcon.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(inactiveImageIcon)
        }
        inactiveImageIcon.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(screensize.width * 0.07)
        }
        insideFenceImageIcon.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(inactiveImageIcon)
        }
        outsideFenceImageIcon.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(inactiveImageIcon)
        }
        TotalDistanceContainer.snp.makeConstraints { (make) in
            make.top.equalTo(insidefenceContainerView.snp.bottom).offset(20)//20
            make.left.equalTo(greenline.snp.right)
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        TotalDistance.snp.makeConstraints { (make) in
            make.top.equalTo(TotalDistanceContainer.snp.top).offset(5)
            make.left.equalTo(TotalDistanceContainer.snp.left).offset(12)
        }
        circularRing.snp.makeConstraints { (make) in
            //make.top.equalTo(progressBarView.snp.top).offset(10)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.27)
            make.height.equalToSuperview().multipliedBy(0.27)
        }
        circularRing2.snp.makeConstraints { (make) in
            //  make.top.equalToSuperview().offset(5)
            make.center.equalToSuperview()
            make.size.equalTo(circularRing)
        }
        circularRing3.snp.makeConstraints { (make) in
            // make.top.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(circularRing)
        }
        distance.snp.makeConstraints { (make) in
            // make.top.equalTo(TotalDistanceContainer.snp.top).offset(48)
            make.left.equalTo(TotalDistanceContainer.snp.left).offset(12)
            make.bottom.equalToSuperview().offset(-2)
        }
        progressBarView.snp.makeConstraints { (make) in
            make.top.equalTo(TotalDistanceContainer.snp.bottom).offset(ScreenHeight * 0.01)//20
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        selectVehicleTextField.snp.makeConstraints { (make) in
            make.top.equalTo(progressBarView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()//.offset(screensize.width * 0.05)
            make.height.equalTo(ScreenHeight * 0.05)
            make.width.equalToSuperview().multipliedBy(0.60)
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(selectVehicleTextField)
            make.left.equalTo(selectVehicleTextField.snp.right).offset(screensize.width * 0.01)
            make.size.equalTo(30)
          //  make.width.equalToSuperview().multipliedBy(0.20)
        }
        graphCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(selectVehicleTextField.snp.bottom).offset(10)//10 = 0.014
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenHeight * 0.50) //0.54
            make.bottom.equalToSuperview()
            //            if #available(iOS 11.0, *) {
            //                make.bottom.equalTo(scrollview.safeAreaLayoutGuide.snp.bottom)
            //            } else {
            //                make.bottom.equalToSuperview()
            //            }
        }
        TotalVehicles.snp.makeConstraints { (make) in
            make.top.equalTo(totalVehiclesContainerView.snp.top).offset(screensize.height * 0.005)
            make.centerX.equalToSuperview()
        }
        Inactive.snp.makeConstraints { (make) in
            make.top.equalTo(inactiveContainerView.snp.top).offset(screensize.height * 0.005)
            make.centerX.equalToSuperview()
        }
        Inside.snp.makeConstraints { (make) in
            make.top.equalTo(insidefenceContainerView.snp.top).offset(screensize.height * 0.005)
            make.centerX.equalToSuperview()
        }
        Outside.snp.makeConstraints { (make) in
            make.top.equalTo(outsideContainerView.snp.top).offset(screensize.height * 0.005)
            make.centerX.equalToSuperview()
        }
        totalVehiclesDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
           // make.size.equalTo(screensize.width * 0.1)
        }
        insidefenceDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
           // make.size.equalTo(screensize.width * 0.1)
        }
        inactiveDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
           // make.size.equalTo(screensize.width * 0.1)
        }
        outsideDataLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
          //  make.size.equalTo(screensize.width * 0.1)
        }
        Inactivelab.snp.makeConstraints { (make) in
            make.left.equalTo(purplebox.snp.right).offset(2)
            make.bottom.equalToSuperview().offset(-10)
        }
        IgnitionOnlab.snp.makeConstraints { (make) in
           // make.left.equalTo(cyanbox.snp.right).offset(2)
            make.centerX.equalTo(circularRing2).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        IgnitionOfflab.snp.makeConstraints { (make) in
           // make.left.equalTo(redbox.snp.right).offset(2)
            make.centerX.equalTo(circularRing3).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        purplebox.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.left.equalTo(circularRing)//.offset(5)
            make.size.equalTo(15)
        }
        cyanbox.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(IgnitionOnlab.snp.left).offset(-2)//.offset(10)
            make.size.equalTo(15)
        }
        redbox.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(IgnitionOfflab.snp.left).offset(-2)//.offset(10)
            make.size.equalTo(15)
        }
        
        rightbutton.snp.makeConstraints { (make) in
            make.centerY.equalTo(graphCollectionView)
            make.right.equalTo(graphCollectionView.snp.right)
            make.size.equalTo(screensize.width * 0.1)
        }
        
        leftbutton.snp.makeConstraints { (make) in
            make.centerY.equalTo(graphCollectionView)
            make.left.equalTo(graphCollectionView.snp.left)
            make.size.equalTo(screensize.width * 0.1)
        }
    }
    
    func addbutton(){
        leftbutton = UIButton()
        leftbutton.setImage(#imageLiteral(resourceName: "lefticon"), for: .normal)
        //leftbutton.setTitle("<-", for: .normal)
       // leftbutton.backgroundColor = .black
        leftbutton.sizeToFit()
        scrollview.addSubview(leftbutton)
        
        
        rightbutton = UIButton()
        rightbutton.sizeToFit()
        rightbutton.setImage(#imageLiteral(resourceName: "righticon"), for: .normal)
      //  rightbutton.backgroundColor = .black
        scrollview.addSubview(rightbutton)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

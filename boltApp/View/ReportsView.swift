//
//  ReportsView.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class ReportsView: UIView {
    
    var reportLabel: RCLabel!
    var notigficationImageView: UIImageView!
    var calanderImageView: UIImageView!
    var calanderTextContainer: UIView!
    var vechileTextContainer: UIView!
    var usersHerarchyContainer: UIView!
    var userSelection: UILabel!
    var calenderTextField: UITextField!
    var vechicleImageView: UIImageView!
    var vechileTextField: UITextField!
    var radioButton: RadioButton!
    var selectAllLabel: UILabel!
  
    var radioBtnForKilometreReport: RadioButton!
    var kilometerReport: UILabel!
  
    var segmentedController: UISegmentedControl!
    var searchButton: UIButton!
    var tripsTableView: UITableView!
    var dateCell: DateViewCell!
    var backgroundView : UIView!     // to show background color black when view appers on screen
//    var navBar:UINavigationBar!
   
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        addimageView()
        addBackgroundContainer()
        addTextField()
        addSegmentedController()
        addButton()
        addtableView()
        addConstrainsts()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Error")
    }
    
    @objc func backButtonAction(){
        print("back button is pressed")
    }
    
    
    func addtableView(){
        tripsTableView = UITableView()
        tripsTableView.separatorStyle = .none
        tripsTableView.separatorColor = .blue
        tripsTableView.backgroundColor =  UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        tripsTableView.sectionIndexColor = .black
        addSubview(tripsTableView)
        backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.23, alpha:1.0)
        addSubview(backgroundView)
      
    }
  
    func addLabel(){
        reportLabel = RCLabel(frame: CGRect.zero)
        reportLabel.text = "Reports".toLocalize
        reportLabel.textColor = .black
        reportLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        addSubview(reportLabel)
    }
    
    func addimageView(){
        notigficationImageView = UIImageView()
        notigficationImageView.image = #imageLiteral(resourceName: "calendar-3")
        notigficationImageView.contentMode = .center
        addSubview(notigficationImageView)
        
        calanderImageView = UIImageView()
        calanderImageView.image = #imageLiteral(resourceName: "calendar-2").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        calanderImageView.contentMode = .center
        calanderImageView.backgroundColor = appDarkTheme
        addSubview(calanderImageView)
        
        vechicleImageView = UIImageView()
        vechicleImageView.image = #imageLiteral(resourceName: "car-wheel").resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)
        vechicleImageView.backgroundColor = appDarkTheme
        vechicleImageView.contentMode = .center
        addSubview(vechicleImageView)
    }
    
    func addBackgroundContainer(){
        calanderTextContainer = UIView(frame: CGRect.zero)
        calanderTextContainer.backgroundColor = .white
        addSubview(calanderTextContainer)
        
        vechileTextContainer = UIView(frame: CGRect.zero)
        vechileTextContainer.backgroundColor = .white
        addSubview(vechileTextContainer)
    }
    
    func addTextField(){
        userSelection = UILabel()
        userSelection.text = "USERS"
        userSelection.textAlignment = .center
        userSelection.backgroundColor = .white
        userSelection.layer.cornerRadius = 4.0
        userSelection.clipsToBounds = true
        userSelection.isUserInteractionEnabled = true
        addSubview(userSelection)
        
        radioButton = RadioButton()
        radioButton.innerCircleCircleColor = appGreenTheme
        radioButton.outerCircleColor = appGreenTheme
        addSubview(radioButton)
      
      radioBtnForKilometreReport = RadioButton()
      radioBtnForKilometreReport.innerCircleCircleColor = appGreenTheme
      radioBtnForKilometreReport.outerCircleColor = appGreenTheme
      addSubview(radioBtnForKilometreReport)
        
        calenderTextField = UITextField()
        calenderTextField.placeholder = "Select date".toLocalize
        calenderTextField.backgroundColor = .white
        addSubview(calenderTextField)
        
        vechileTextField = UITextField()
        vechileTextField.placeholder = "Select your Vehicle".toLocalize //vehicle        vechileTextField.backgroundColor = .white
        addSubview(vechileTextField)
        
        selectAllLabel = UILabel()
        selectAllLabel.text = "Select all vehicle"
        selectAllLabel.textAlignment = .left
        selectAllLabel.adjustsFontSizeToFitWidth = true
        selectAllLabel.font = UIFont.systemFont(ofSize: 15)
        addSubview(selectAllLabel)
      
      kilometerReport = UILabel()
      kilometerReport.text = "Kilometre Report"
      kilometerReport.textAlignment = .right
      kilometerReport.adjustsFontSizeToFitWidth = true
      kilometerReport.font = UIFont.systemFont(ofSize: 15)
      addSubview(kilometerReport)
        
        
    }
    
    func addSegmentedController(){
        segmentedController = UISegmentedControl(items: ["STOPS".toLocalize, "TRIPS".toLocalize, "DAILY".toLocalize])
      //  let font = UIFont.systemFont(ofSize: 15, weight: .thin)
      //  segmentedController.setTitleTextAttributes([NSAttributedStringKey.font:font], for: .normal)
        segmentedController.tintColor = appGreenTheme
        segmentedController.backgroundColor = .white
        segmentedController.selectedSegmentIndex = 1
        addSubview(segmentedController)
    }
    
    func addButton(){
        searchButton = UIButton()
        searchButton.setImage(#imageLiteral(resourceName: "Artboard 59").resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        searchButton.layer.cornerRadius = 5.0
        searchButton.backgroundColor = appGreenTheme
        addSubview(searchButton)
        
    }
    
    func addConstrainsts(){
        
        
//      reportLabel.snp.makeConstraints { (make) in
//        if #available(iOS 11, *){
//            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
//        }else{
//          make.top.equalToSuperview().offset(70)
//        }
//        make.left.equalToSuperview().offset(20)
//        make.height.equalToSuperview().multipliedBy(0.06)
//
//        }
        userSelection.snp.makeConstraints { (make) in
            //make.top.equalToSuperview().offset(70)
            if #available(iOS 11, *){
                            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).offset(10)
                        } else {
                          make.top.equalToSuperview().offset(70)
                        }
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(35)
        }
        calanderImageView.snp.makeConstraints { (make) in
            make.top.equalTo(userSelection.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(40)
        }
        calenderTextField.snp.makeConstraints { (make) in
            make.top.equalTo(calanderImageView.snp.top)
            make.left.equalTo(calanderImageView.snp.right).offset(20)
            make.height.equalTo(calanderImageView)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        vechicleImageView.snp.makeConstraints { (make) in
           make.top.equalTo(calanderImageView.snp.bottom).offset(5)
           make.left.equalToSuperview().offset(15)
           make.width.height.equalTo(calanderImageView)
        }
        
        vechileTextField.snp.makeConstraints { (make) in
            make.top.equalTo(vechicleImageView.snp.top)
            make.left.equalTo(vechicleImageView.snp.right).offset(20)
            make.height.equalTo(calanderImageView)
            make.right.equalToSuperview().offset(-20)
        }
        calanderTextContainer.snp.makeConstraints { (make) in
            make.left.equalTo(calanderImageView.snp.right)
            make.top.equalTo(calanderImageView.snp.top)
            make.height.equalTo(calanderImageView.snp.height)
            make.right.equalTo(calenderTextField)
        }
//
//        notigficationImageView.snp.makeConstraints { (make) in
//            make.top.equalTo(reportLabel)
//            make.right.equalTo(calanderTextContainer)
//            make.height.equalTo(reportLabel)
//            make.width.equalToSuperview().multipliedBy(0.2)
//        }
        vechileTextContainer.snp.makeConstraints { (make) in
            make.left.equalTo(vechicleImageView.snp.right)
            make.top.equalTo(vechicleImageView.snp.top)
            make.height.equalTo(vechicleImageView.snp.height)
            make.right.equalTo(vechileTextField)
        }
      
        radioButton.snp.makeConstraints { (make) in
            make.top.equalTo(vechicleImageView.snp.bottom).offset(10)
            make.centerX.equalTo(vechicleImageView)
            make.width.height.equalTo(25)
        }
      
      
      radioBtnForKilometreReport.snp.makeConstraints { (make) in
               make.top.equalTo(vechileTextField.snp.bottom).offset(10)
               make.width.height.equalTo(25)
              make.right.equalTo(kilometerReport.snp.left).offset(-10)
        //make.right.equalTo(vechileTextField.snp.right)
           }
      
      
      kilometerReport.snp.makeConstraints { (make) in
        make.top.equalTo(vechileTextField.snp.bottom).offset(10)
        //make.right.equalTo(radioBtnForKilometreReport.snp.left).offset(-10)
        make.right.equalTo(vechileTextField.snp.right)
        make.height.equalTo(25)
      //  make.width.equalToSuperview().multipliedBy(0.5)
      }
      
      
        selectAllLabel.snp.makeConstraints { (make) in
            make.top.equalTo(vechicleImageView.snp.bottom).offset(10)
          make.left.equalTo(radioButton.snp.right).offset(10)
            make.height.equalTo(25)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        segmentedController.snp.makeConstraints { (make) in
             make.left.equalTo(vechicleImageView.snp.left)
             make.height.equalTo(35)
             make.right.equalToSuperview().offset(-20)
             make.top.equalTo(selectAllLabel.snp.bottom).offset(10)
        }
        
        searchButton.snp.makeConstraints { (make) in
            make.left.equalTo(segmentedController.snp.left)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(vechicleImageView)
            make.top.equalTo(segmentedController.snp.bottom).offset(5)
        }
        
        tripsTableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalTo(tripsTableView)
           
        }
    }
}



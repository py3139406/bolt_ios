//
//  AddContactView.swift
//  Consumer
//
//  Created by Roadcast on 16/12/19.
//  Copyright © 2019 Roadcast. All rights reserved.
//

import UIKit

class AddContactView: UIView {
    
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width
    var scrollview : AddContactScrollView!
    var scrollcontentsize : CGFloat = 0.0
      var addmoresaveView : UIView!
    var addmorecontactButton : UIButton!
    var lineView : UIView!
    var saveButton : UIButton!
    var addcontactLabel : UILabel!
    var contactImage : UIImageView!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           addViews()
           addConstraints()
           //backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 57/255, alpha: 1)
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func addViews() {
        
//        addcontactlabelImageView = UIView(frame: CGRect.zero)
//        addcontactlabelImageView.backgroundColor = .white
//        addSubview(addcontactlabelImageView)
        
        addcontactLabel = UILabel(frame: CGRect.zero)
        addcontactLabel.text = "Add Contacts"
        addcontactLabel.textColor = .white
        addcontactLabel.adjustsFontSizeToFitWidth = true
        addcontactLabel.font = UIFont.boldSystemFont(ofSize: 25)
           addSubview(addcontactLabel)
        
        contactImage = UIImageView(frame: CGRect.zero)
        contactImage.image = UIImage(named: "Asset 62")
        contactImage.contentMode = .scaleToFill
        contactImage.tintColor = .white
           addSubview(contactImage)
        
        lineView = UIView(frame: CGRect.zero)
        lineView.backgroundColor = .white
        addSubview(lineView)
        
        
           scrollview = AddContactScrollView(frame: CGRect.zero)
           scrollview.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        //statusScroll.setContentOffset(CGPoint(x: 0,y: -self.statusScroll.contentInset.top),animated: true)
        scrollview.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 59/255, alpha: 1.0)
           scrollview.alwaysBounceHorizontal = false
        scrollview.alwaysBounceVertical = true
        scrollview.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 1)
           scrollview.showsHorizontalScrollIndicator = false
           scrollview.showsVerticalScrollIndicator = false
        scrollview.layoutIfNeeded()
        scrollview.isScrollEnabled = true
//        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height)
        addSubview(scrollview)
        
//        addmoresaveView = UIView(frame: CGRect.zero)
//        addmoresaveView.backgroundColor = UIColor(red: 40/255, green: 38/255, blue: 57/255, alpha: 1)
//        
//        addSubview(addmoresaveView)
        
        
        addmorecontactButton = UIButton(frame: CGRect.zero)
        addmorecontactButton.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1.0)
        addmorecontactButton.setTitle("Add more contacts", for: .normal)
        addmorecontactButton.layer.cornerRadius = 5
            addSubview(addmorecontactButton)

        saveButton = UIButton(frame: CGRect.zero)
        saveButton.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1.0)
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 5
        addSubview(saveButton)
        

    }
    func addConstraints()
    {
        addcontactLabel.snp.makeConstraints{(make) in
          make.top.equalTo(0.11 * kscreenheight)
            make.left.equalTo(0.04 * kscreenwidth)
            make.width.equalTo(0.6 * kscreenwidth)
            make.height.equalTo(0.08 * kscreenheight)
        }
        contactImage.snp.makeConstraints{(make) in
            make.top.equalTo(0.1 * kscreenheight)
            make.right.equalTo(-0.05 * kscreenwidth)
            make.height.equalTo(0.11 * kscreenheight)
            make.width.equalTo(0.15 * kscreenwidth)
        }
        scrollview.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(0.002 * kscreenheight)
                   make.width.equalToSuperview()
            make.height.equalTo(0.6 * kscreenheight)
                  // make.centerX.equalToSuperview()
               }
//
        lineView.snp.makeConstraints{(make) in
            make.top.equalTo(contactImage.snp.bottom).offset(0.002 * kscreenheight)
                            make.width.equalToSuperview()
            make.height.equalTo(0.001 * kscreenheight)
                        }
        addmorecontactButton.snp.makeConstraints{(make) in
//                   make.top.equalToSuperview().offset(0.001 * kscreenheight)
              make.top.equalTo(scrollview.snp.bottom).offset(0.001 * kscreenheight)
                   make.width.equalTo(0.8 * kscreenwidth)
                   make.centerX.equalToSuperview()
                   make.height.equalTo(0.08 * kscreenheight)
                           }
               saveButton.snp.makeConstraints{(make) in
                   make.top.equalTo(addmorecontactButton.snp.bottom).offset(0.01 * kscreenheight)
                   make.width.equalTo(0.8 * kscreenwidth)
                   make.centerX.equalToSuperview()
                   make.height.equalTo(0.06 * kscreenheight)
               }
    }

}

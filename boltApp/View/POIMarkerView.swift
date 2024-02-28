//
//  POIMarkerView.swift
//  Bolt
//
//  Created by Shanky on 08/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class POIMarkerView: UIView {
    
    var locationImageView: UIImageView!
        var upperImageView: UIImageView!
        var boundaryView: UIView!
        var textLabel: UILabel!
        var kscreenheight = UIScreen.main.bounds.height
        var kscreenwidth = UIScreen.main.bounds.width
        
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          addViews()
          constraints()
      }
      
      required init?(coder aDecoder: NSCoder) {
        
          super.init(coder: aDecoder)
          fatalError("Error")
      }
       
         func addViews()
            {
                
                boundaryView = UIView(frame: CGRect.zero)
                boundaryView.backgroundColor = .white
                boundaryView.layer.borderWidth = 1
                boundaryView.layer.borderColor = UIColor.black.cgColor
                addSubview(boundaryView)
                
                textLabel = UILabel(frame: CGRect.zero)
                textLabel.text = "POI"
                textLabel.textColor = .black
                boundaryView.addSubview(textLabel)
                
                locationImageView = UIImageView(frame: CGRect.zero)
                locationImageView.image = UIImage(named: "location")
                locationImageView.contentMode = .scaleAspectFit
                boundaryView.addSubview(locationImageView)
                
                upperImageView = UIImageView(frame: CGRect.zero)
                upperImageView.image = UIImage(named: "cash")
    //            upperImageView.backgroundColor = .white
    //            upperImageView.layer.cornerRadius = 25
    //            upperImageView.layer.masksToBounds = true
                upperImageView.contentMode = .scaleAspectFit
                locationImageView.addSubview(upperImageView)
                
                
        }
        func constraints()
        {
            
            boundaryView.snp.makeConstraints{(make) in
                make.top.equalToSuperview().offset(0.04 * kscreenheight)
                make.left.equalToSuperview().offset(0.04 * kscreenwidth)
                make.width.equalTo(0.3 * kscreenwidth)
                make.height.equalTo(0.18 * kscreenheight)
            }
            textLabel.snp.makeConstraints{(make) in
                make.top.equalToSuperview().offset(0.015 * kscreenheight)
                make.centerX.equalToSuperview()
            }
            locationImageView.snp.makeConstraints{(make) in
                make.top.equalTo(textLabel.snp.bottom).offset(0.022 * kscreenheight)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(80)
            }
            upperImageView.snp.makeConstraints{(make) in
               make.top.equalToSuperview().offset(0.007 * kscreenheight)
                //make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.height.equalTo(60)
            }
        }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

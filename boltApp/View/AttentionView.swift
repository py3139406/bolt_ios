//
//  AttentionView.swift
//  Bolt
//
//  Created by Roadcast on 12/12/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class AttentionView: UIView {
       var vehicleattentionview : UIView!
       var wheelImageView : UIImageView!
       var alertImageView : UIImageView!
       var attentionLabel : UILabel!
       var vehicledangerLabel : UILabel!
       var dismissButton: UIButton!
    let kscreenheight = UIScreen.main.bounds.height
    let kscreenwidth = UIScreen.main.bounds.width

      override init(frame: CGRect) {
            super.init(frame: frame)
            addvehicleattentionalarm()
            addmakeConstraints()
        }        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
       
       func addvehicleattentionalarm()
       {
                 vehicleattentionview = UIView(frame: CGRect.zero)
                 vehicleattentionview.backgroundColor = .white
                 vehicleattentionview.clipsToBounds = true
                 vehicleattentionview.layer.cornerRadius = 5
                 addSubview(vehicleattentionview)
           
               wheelImageView = UIImageView(frame: CGRect.zero)
               wheelImageView.image = UIImage(named: "sos")
               wheelImageView.contentMode = .scaleAspectFit
               vehicleattentionview.addSubview(wheelImageView)
           
               alertImageView = UIImageView(frame: CGRect.zero)
               alertImageView.image = UIImage(named: "Asset 86")
               alertImageView.contentMode = .scaleAspectFit
               vehicleattentionview.addSubview(alertImageView)
                 
               attentionLabel = UILabel(frame: CGRect.zero)
               attentionLabel.text = "Attention"
               attentionLabel.textAlignment = .center
               attentionLabel.font = UIFont.boldSystemFont(ofSize: 25)
               attentionLabel.textColor = .black
               vehicleattentionview.addSubview(attentionLabel)
           
               vehicledangerLabel = UILabel(frame: CGRect.zero)
               vehicledangerLabel.text = "Your vehicle is in danger"
               vehicledangerLabel.textAlignment = .center
               vehicledangerLabel.font = UIFont.boldSystemFont(ofSize: 20)
               vehicledangerLabel.textColor = .black
               vehicleattentionview.addSubview(vehicledangerLabel)
                 
                 dismissButton = UIButton(frame: CGRect.zero)
                 dismissButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                 dismissButton.setTitle("DISMISS", for: .normal)
                 dismissButton.setTitleColor(UIColor.black, for: .normal)
                 dismissButton.backgroundColor = .green
                 vehicleattentionview.addSubview(dismissButton)
                 
       }
    
    func addmakeConstraints()
    {
        vehicleattentionview.snp.makeConstraints{(make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(0.7 * kscreenwidth)
        }
        
        wheelImageView.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(0.1 * kscreenheight)
            make.width.equalTo(0.2 * kscreenwidth)
            make.left.equalTo(0.4 * kscreenwidth)
            make.height.equalTo(0.2 * kscreenheight)
        }
        alertImageView.snp.makeConstraints{(make) in
            //make.top.equalToSuperview().offset(0.2 * kscreenheight)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(0.3 * kscreenwidth)
            make.height.equalTo(0.2 * kscreenheight)
        }
        attentionLabel.snp.makeConstraints{(make) in
            make.top.equalTo(alertImageView.snp.bottom).offset(0.001 * kscreenheight)
            make.centerX.equalToSuperview()
            
        }
        vehicledangerLabel.snp.makeConstraints{(make) in
            make.top.equalTo(attentionLabel.snp.bottom).offset(0.001 * kscreenheight)
            make.centerX.equalToSuperview()
        }
        dismissButton.snp.makeConstraints{(make) in
            make.bottom.equalTo(-0.001 * kscreenheight)
            make.width.equalToSuperview()
            make.height.equalTo(0.15 * kscreenheight)
        }
        
    }

}

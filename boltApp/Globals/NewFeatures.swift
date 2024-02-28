//
//  NewFeatures.swift
//  Bolt
//
//  Created by Roadcast on 30/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import SnapKit

class NewFeatures {
    func boltTimePicker()-> UIView{
        let bgView = UIView()
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .time
        datePicker.locale = .current
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.tintColor = .black
            datePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        bgView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        return bgView
    }
    func blurrEffect()-> UIVisualEffectView{
        let blurEffect:UIBlurEffect!
        if #available(iOS 13.0, *) {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.systemUltraThinMaterialDark)
        } else {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        }
       let  blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    
}

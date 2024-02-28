//
//  ReportsDateRangeView.swift
//  Bolt
//
//  Created by Roadcast on 27/01/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar


class ReportsDateRangeView: UIView {

    var menuCalender: CVCalendarMenuView!
    var leavesCalender: CVCalendarView!
    var monthLabel: UILabel!
    var descriptionTextField: UITextField!
    var applyButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        monthLabel = UILabel()
        monthLabel.textColor = .black
        monthLabel.text = "Month"
        monthLabel.textAlignment = .center
        monthLabel.textColor = appGreenTheme
        monthLabel.font = UIFont.boldSystemFont(ofSize: 20)
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(monthLabel)
        
        menuCalender = CVCalendarMenuView(frame: CGRect.zero)
        menuCalender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menuCalender)
        
        leavesCalender = CVCalendarView(frame: CGRect.zero)
        leavesCalender.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leavesCalender)
        
        descriptionTextField = UITextField(frame: CGRect.zero)
        descriptionTextField.backgroundColor = .white
        descriptionTextField.placeholder = "   Description"
        descriptionTextField.textColor = .black
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionTextField)
        
        applyButton = UIButton(frame:CGRect.zero)
        applyButton.setTitle("APPLY FOR LEAVES", for: .normal)
        applyButton.backgroundColor = appGreenTheme
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.layer.cornerRadius = 5.0
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(applyButton)
    }
    
    func addConstraints() {
        monthLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: CGFloat( 80)).isActive = true
        monthLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        monthLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        
        menuCalender.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10).isActive = true
        menuCalender.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        menuCalender.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuCalender.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.05).isActive = true
        
        leavesCalender.topAnchor.constraint(equalTo: menuCalender.bottomAnchor).isActive = true
        leavesCalender.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        leavesCalender.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        leavesCalender.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        
        descriptionTextField.topAnchor.constraint(equalTo: leavesCalender.bottomAnchor, constant: 10).isActive = true
        descriptionTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        descriptionTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.06).isActive = true
        descriptionTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        applyButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20).isActive = true
        applyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        applyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        applyButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.06).isActive = true
    }
    

    

}

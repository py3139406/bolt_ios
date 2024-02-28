//
//  CalendarViewController.swift
//  Bolt
//
//  Created by Roadcast on 27/01/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar
import SnapKit
import DefaultsKit

class CalenderController: UIViewController {
    
    private var monthLabel: UILabel!
    private var menu: CVCalendarMenuView!
    private var calendar: CVCalendarView!
    var currentCalendar: Calendar!
    var backgroundView: UIView!
    var dragView: UIView!
    var doneButton: UIButton!
    private var selectedDay: DayView!
    var selectedDateType: String = ""
    private var animationFinished = true
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var callback : (([Date]?) -> Void)?
    private var dates = [Date]()
    var dateTextField:UITextField!
    var singleDateLabel:UILabel!
    var rangeDateLabel:UILabel!
    var singleBtn:RadioButton!
    var rangeBtn:RadioButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        editTheView()
        setUpCalendar()
        addConstraints()
        setActions()
        self.menu.menuViewDelegate = self
        self.calendar.calendarAppearanceDelegate = self
        self.calendar.calendarDelegate = self
    }
    func setActions(){
        singleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(singleBtnTap(sender:))))
      rangeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rangeBtnTap(sender:))))
    }
    @objc func singleBtnTap(sender:RadioButton){
        if  singleBtn.isSelected == false {
            rangeBtn.isSelected = false
            singleBtn.isSelected = true
        }
    }
    @objc func rangeBtnTap(sender:RadioButton){
        if  rangeBtn.isSelected == false {
            rangeBtn.isSelected = true
            singleBtn.isSelected = false
            
        }
    }
    func editTheView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 25.0
        backgroundView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:))))
        view.addSubview(backgroundView)
        
        singleBtn = RadioButton(frame: CGRect.zero)
        singleBtn.innerCircleCircleColor = appGreenTheme
        singleBtn.outerCircleColor = appGreenTheme
        singleBtn.innerCircleGap = 2
        singleBtn.isSelected = true
        backgroundView.addSubview(singleBtn)
        
        rangeBtn = RadioButton(frame: CGRect.zero)
        rangeBtn.innerCircleCircleColor = appGreenTheme
        rangeBtn.outerCircleColor = appGreenTheme
        rangeBtn.innerCircleGap = 2
        backgroundView.addSubview(rangeBtn)
        
        singleDateLabel  = UILabel()
        singleDateLabel.textColor = .black
        singleDateLabel.text = "Single date"
        singleDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        backgroundView.addSubview(singleDateLabel)
        
        rangeDateLabel  = UILabel()
        rangeDateLabel.textColor = .black
        rangeDateLabel.text = "Range date"
        rangeDateLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        backgroundView.addSubview(rangeDateLabel)
        
        dragView = UIView()
        dragView.backgroundColor = UIColor.gray
        dragView.layer.cornerRadius = 5.0
        backgroundView.addSubview(dragView)
        
        monthLabel = UILabel()
        monthLabel.textColor = .black
        monthLabel.text = "Month"
        monthLabel.textAlignment = .center
        monthLabel.textColor = UIColor(red: 239/255, green: 83/255, blue: 80/255, alpha: 1.0)
        monthLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        backgroundView.addSubview(monthLabel)
        
        menu = CVCalendarMenuView(frame: CGRect.zero)
        view.addSubview(menu)
        calendar = CVCalendarView(frame: CGRect.zero)
        backgroundView.addSubview(calendar)
        
        doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        doneButton.setTitleColor(UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0), for: .normal)
        doneButton.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
        doneButton.layer.cornerRadius = 15.0
        doneButton.addTarget(self, action: #selector(dismissTheCalendar), for: .touchUpInside)
        view.addSubview(doneButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menu.commitMenuViewUpdate()
        self.calendar.commitCalendarViewUpdate()
    }
    
    func setUpCalendar() {
        currentCalendar = Calendar.current
        currentCalendar?.locale = Locale.current
        currentCalendar?.timeZone = TimeZone.current
        if let currentCalender = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalender).globalDescription
        }
    }
    
    @objc func dismissTheCalendar() {
            if selectedDateType == "range" {
                Defaults().set(true, for: Key<Bool>("rangeDate"))
                if Defaults().has(Key<Date>("StartDateTask")) && Defaults().has(Key<Date>("endDateTask")) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "range"), object: nil)
                    let dateStart = Defaults().get(for: Key<Date>("StartDateTask"))!
                    let dateEnd = Defaults().get(for: Key<Date>("endDateTask"))!
                    dateTextField.text = "\(RCGlobals.getFormattedDataReportForLabel(date: dateStart as NSDate)) - \(RCGlobals.getFormattedDataReportForLabel(date: dateEnd as NSDate))"
                    if let cb = callback {
                        cb([dateStart,dateEnd])
                    }
                    self.dismiss(animated: true, completion: nil)
                } else{
                    prompt("Please select range date")
                }
            } else if selectedDateType == "single" {
                Defaults().set(false, for: Key<Bool>("rangeDate"))
                if Defaults().has(Key<Date>("currentDayTask")) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "single"), object: nil)
                    let datesingle = Defaults().get(for: Key<Date>("currentDayTask"))!
            dateTextField.text = "\(RCGlobals.getFormattedDataReportForLabel(date: datesingle as NSDate)) - \(RCGlobals.getFormattedDataReportForLabel(date: datesingle as NSDate))"
                    if let cb = callback {
                        
                        cb([datesingle])
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                 self.dismiss(animated: true, completion: nil)
            }
        
    }
    
    @objc private func singleDateSelected(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
    }
    
    func addConstraints() {
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        backgroundView.snp.makeConstraints { (make) in
            make.bottom.equalTo(doneButton.snp.top).offset(-5)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        dragView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(10)
        }
        singleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(dragView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(50)
            make.size.equalTo(25)
        }
        singleDateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(singleBtn)
            make.left.equalTo(singleBtn.snp.right).offset(5)
        }
        rangeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(singleDateLabel)
            make.left.equalTo(singleDateLabel.snp.right).offset(50)
            make.size.equalTo(25)
        }
        rangeDateLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(rangeBtn)
            make.left.equalTo(rangeBtn.snp.right).offset(5)
        }
        monthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(singleBtn.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        menu.snp.makeConstraints { (make) in
            make.top.equalTo(monthLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.98)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        calendar.snp.makeConstraints { (make) in
            make.top.equalTo(menu.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
}
extension CalenderController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
  // don't scroll after current month
//    func disableScrollingBeyondDate() -> Date {
//        return Date()
//    }
//    func disableScrollingBeforeDate() -> Date {
//        let date = Calendar.current.date(byAdding: .month, value: -2, to: Date())
//         return date!
//    }
    func shouldShowCustomSingleSelection() -> Bool {
        true
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
        if dayView.date.convertedDate()! > (NSDate() as Date) {
            print("single not valid  valid")
        }
        //print(RCGlobals.getDateFromString(selectedDay.date.commonDescription, format: "dd MMMM, yyyy"))
        Defaults().set(selectedDay.date.commonDescription, for: Key<String>("singleDate"))
        Defaults().set(selectedDay.date.convertedDate(calendar: Calendar.current)!, for: Key<Date>("currentDayTask"))
    }
    
//    func shouldShowWeekdaysOut() -> Bool { return shouldShowDaysOut }
    
    func dayOfWeekBackGroundColor() -> UIColor { return .white }
    
    
    /// Circle date code start //////////////
  //  func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool { return true }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        
        let ringLayer = CAShapeLayer()
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 2.0 - ringLineWidth
        
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let centrePoint = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        guard let currentCalendar = currentCalendar else { return false }
        
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar)
        
        var shouldDisplay = false
        
        if dates.contains(dayView.date.convertedDate()!) {
            shouldDisplay = true
        }
        
        
        return shouldDisplay
    }
    

    func shouldAutoSelectDayOnMonthChange() -> Bool { return true }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ? UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.black
    }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        Defaults().set(startDayView.date.convertedDate(calendar: currentCalendar)!, for: Key<Date>("StartDateTask"))
        Defaults().set(endDayView.date.convertedDate(calendar: Calendar.current)!, for: Key<Date>("endDateTask"))
        let endSelectedDate = endDayView.date.commonDescription
        let firstSelectedDate = startDayView.date.commonDescription
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let current = dateFormatter.string(from: todaysDate as Date)
        print(current)
        print(startDayView.date.commonDescription)
        print(endDayView.date.commonDescription)
 
    }
    func latestSelectableDate() -> Date {
        return Date()
    }
    func earliestSelectableDate() -> Date {

       let date = Calendar.current.date(byAdding: .month, value: -2, to: Date())
        return date!
    }

    func maxSelectableRange() -> Int { return 64 }

    func shouldSelectRange() -> Bool {
        if singleBtn.isSelected{
             selectedDateType = "single"
              return false
        } else {
             selectedDateType = "range"
            return true
        }
      
    }
//    func shouldSelectDayView(_ dayView: DayView) -> Bool {
//          let dayDate = dayView.date.convertedDate()
//          if dayDate! < Date()-60*60*24 {
//              return false
//          }else{
//              return true
//          }
//    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.sunday
    }
    
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(monthLabel.frame.height)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -0)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
}

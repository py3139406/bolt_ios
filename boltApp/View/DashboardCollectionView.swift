//
//  DashboardCollectionView.swift
//  Bolt
//
//  Created by Roadcast on 11/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import Charts
import SwiftCharts
class DashboardCollectionView: UIView {
    var name : UILabel!
    let greenline2 = UIView()
    let thismonthview = UIView()
    var thismonthlabel = UILabel()
    let redline = UIView()
    let lastdayview = UIView()
    var lastdaylabel = UILabel()
    let thismonthdistance = UILabel()
    let lastdaydistance = UILabel()
    var lineChartView:LineChartView!
   // var circleColors = [NSUIColor]()
    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    override init(frame:CGRect){
        super.init(frame: frame)
        let xAxis = [1,2,3,4,5,6,7]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0,17.0]
      //  let count = Int(arc4random_uniform(5))
       // circleColors.append(NSUIColor.white)
        addviewcell()
        addlabelcell()
        addConstraintsCell()
        addchart(dataPoints: xAxis , values: unitsSold)
    }
        func addchart(dataPoints: [Int], values: [Double]){
        
            // set chart data entry
            var dataEntries: [ChartDataEntry] = []
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
                       dataEntries.append(dataEntry)
                   }
            
//         let values = (0..<count).map{ (i) -> ChartDataEntry in
//            let val = Double(signOf: Double(arc4random_uniform(UInt32(count))), magnitudeOf: +3)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
            
            // set line chart dataset
            let set1 = LineChartDataSet(entries: dataEntries, label: "Distance" )
            set1.circleHoleRadius = 2.0
           // set1.circleColors = circleColors
            set1.highlightColor = NSUIColor.white
            set1.lineWidth = 1.8
            set1.circleHoleColor = .white
            set1.circleRadius = 3.0
            set1.formLineWidth = 1.8
            set1.setColor(appGreenTheme)
            
            set1.valueTextColor = .white
            let data = LineChartData(dataSet: set1)
            set1.drawHorizontalHighlightIndicatorEnabled = false
            self.lineChartView.tintColor = .white
            self.lineChartView.data = data
            self.lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
            

        }
        
        func addviewcell(){
            name = UILabel(frame: CGRect.zero)
            name.textColor = .appGreen
            name.textAlignment = .center
            name.adjustsFontSizeToFitWidth = true
            addSubview(name)
            greenline2.backgroundColor = .appGreen
            addSubview(greenline2)
            thismonthview.backgroundColor = .appviewbgcolor
           addSubview(thismonthview)
            redline.backgroundColor = .appRed
            lastdayview.backgroundColor = .appviewbgcolor
            addSubview(redline)
            addSubview(lastdayview)
            lineChartView = LineChartView(frame: CGRect.zero)
            lineChartView.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 42/255, alpha: 1.0)
            lineChartView.gridBackgroundColor = .appviewbgcolor
            addSubview(lineChartView)

        }
        
        func addlabelcell(){
            
            thismonthlabel.text = "This Month"
            thismonthlabel.numberOfLines = 1
            thismonthlabel.textColor = .appGreen
            thismonthlabel.font = UIFont.systemFont(ofSize: 12.0)
            thismonthlabel.sizeToFit()
            thismonthview.addSubview(thismonthlabel)
            
            thismonthdistance.text = "0.0 km"
            thismonthdistance.numberOfLines = 1
            thismonthdistance.textColor = .white
            thismonthdistance.adjustsFontSizeToFitWidth = true
            thismonthdistance.font = UIFont.systemFont(ofSize: 18.0)
            thismonthdistance.sizeToFit()
            thismonthview.addSubview(thismonthdistance)
            
            lastdaylabel.text = "Last 7 days"
            lastdaylabel.numberOfLines = 1
            lastdaylabel.textColor = .red
            lastdaylabel.font = UIFont.systemFont(ofSize: 12.0)
            lastdaylabel.sizeToFit()
            lastdayview.addSubview(lastdaylabel)
            
            lastdaydistance.text = "342.4 km"
            lastdaydistance.numberOfLines = 1
            lastdaydistance.adjustsFontSizeToFitWidth = true
            lastdaydistance.textColor = .white
            lastdaydistance.font = UIFont.systemFont(ofSize: 18.0)
            
            lastdaydistance.sizeToFit()
            lastdayview.addSubview(lastdaydistance)
        }
        func addConstraintsCell() {
            
            name.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(screensize.height * 0.04)
                
            }
            lineChartView.snp.makeConstraints { (make) in
                make.top.equalTo(name.snp.bottom).offset(5)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.height.equalTo(screensize.height * 0.30)
            }
            
            greenline2.snp.makeConstraints { (make) in
                make.top.equalTo(lineChartView.snp.bottom).offset(10)
                make.left.equalToSuperview()
                make.width.equalTo(10)
                make.height.equalTo(screensize.height * 0.10)
            }
            
            thismonthview.snp.makeConstraints { (make) in
                make.top.equalTo(lineChartView.snp.bottom).offset(10)
                make.left.equalTo(greenline2.snp.right)
                make.width.equalTo(screensize.width * 0.20)//187 = 0.452
                make.height.equalTo(greenline2)
               // make.bottom.equalToSuperview()
            }
            
            thismonthlabel.snp.makeConstraints { (make) in
                make.top.equalTo(thismonthview.snp.top).offset(10)
                make.left.equalTo(thismonthview.snp.left).offset(10)
            }
            
            thismonthdistance.snp.makeConstraints { (make) in
                make.top.equalTo(thismonthview.snp.top).offset(30)
                make.left.equalTo(thismonthview.snp.left).offset(10)
            }
            
            lastdaylabel.snp.makeConstraints { (make) in
                make.top.equalTo(lastdayview.snp.top).offset(10)
                make.left.equalTo(lastdayview.snp.left).offset(10)
            }
            lastdaydistance.snp.makeConstraints { (make) in
                make.top.equalTo(lastdayview.snp.top).offset(30)
                make.left.equalTo(lastdayview.snp.left).offset(10)
            }
            redline.snp.makeConstraints { (make) in
                make.top.equalTo(lineChartView.snp.bottom).offset(10)
                make.left.equalTo(thismonthview.snp.right)
                make.width.equalTo(10)
                make.height.equalTo(greenline2)
                //make.bottom.equalToSuperview()
            }
            
            lastdayview.snp.makeConstraints { (make) in
                make.top.equalTo(lineChartView.snp.bottom).offset(10)
                make.left.equalTo(redline.snp.right)
                make.right.equalToSuperview()
                make.size.equalTo(thismonthview)
              //  make.bottom.equalToSuperview()
            }
            
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

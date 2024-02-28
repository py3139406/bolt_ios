//
//  SubscriptionDetailVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import DefaultsKit

class SubscriptionDetailVC: UIViewController {
    let blurView = NewFeatures().blurrEffect()
    var detailsTable:UITableView!
    
    // footer
    var footerView = UIView()
    var footerTitle = UILabel()
    var totAmtTitle = UILabel()
    var totAmtValue = UILabel()
    var doneBtn = UIButton()
    // header
    var headerView = UIView()
    var headerTitle = UILabel()
    var rowCount = 1
    
    var aisDeviceArr:[String] = []
    var normalDeviceArr:[String] = []
    var totalAmt = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if aisDeviceArr.count > 0 && normalDeviceArr.count > 0 {
            rowCount = 2
        }
        setViews()
        const()
        setActions()
    }
    private func setViews(){
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        detailsTable = UITableView()
        detailsTable.backgroundColor = .white
        detailsTable.layer.cornerRadius = 10
        detailsTable.layer.masksToBounds = true
        detailsTable.bounces = false
        view.addSubview(detailsTable)
        
        footerTitle.text = "Total Amount"
        footerTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        footerTitle.textColor = appGreenTheme
        footerTitle.textAlignment = .center
        
        headerTitle.text = "Subscription Details"
        headerTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerTitle.adjustsFontSizeToFitWidth = true
        headerTitle.textColor = appGreenTheme
        headerTitle.textAlignment = .center
        headerView.addSubview(headerTitle)

        totAmtTitle.text = "Total\n(all devices)"
        totAmtTitle.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        totAmtTitle.adjustsFontSizeToFitWidth = true
        totAmtTitle.numberOfLines = 2
        totAmtTitle.textColor = .black
        
        totAmtValue.text = "INR 0"
        totAmtValue.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        totAmtValue.adjustsFontSizeToFitWidth = true
        totAmtValue.textColor = .black
        
        doneBtn.setTitle("GOT IT", for: .normal)
        doneBtn.setTitleColor(.white, for: .normal)
        doneBtn.backgroundColor = appGreenTheme
        footerView.addSubview(footerTitle)
        footerView.addSubview(totAmtTitle)
        footerView.addSubview(totAmtValue)
        footerView.addSubview(doneBtn)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissView()
    }
    private func setActions(){
        
        detailsTable.register(SubsDetailsCell.self, forCellReuseIdentifier: "cell")
        detailsTable.delegate = self
        detailsTable.dataSource = self
        doneBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
  
    func const() {
        detailsTable.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            if rowCount == 2 {
                make.height.equalToSuperview().multipliedBy(0.9)
            }else {
                make.height.equalToSuperview().multipliedBy(0.6)
            }
            
        }
        footerTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        headerTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
        }
        totAmtTitle.snp.makeConstraints { (make) in
            make.top.equalTo(footerTitle.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        totAmtValue.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(totAmtTitle)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        doneBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
    }

}
extension SubscriptionDetailVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubsDetailsCell
        cell.selectionStyle = .none
        
        if rowCount == 1 {
            if aisDeviceArr.count > 0 {
               var totAmt =  getDeviceTypeAmount(deviceId: Int(aisDeviceArr[0]) ?? 0)
                totAmt = totAmt * aisDeviceArr.count
                let normalRate = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWALAIS"))?.rate ?? 0.0
                let normalTax = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWALAIS"))?.tax ?? 0.0
                cell.otherTitle.text = "AIS devices"
                cell.otherGSTTitle.text = "GST @ \(normalTax)%\n(per device)"
                cell.otherTotalTitle.text = "Total\n \(aisDeviceArr.count) device"
                cell.otherRateValue.text = "INR \(normalRate)"
                cell.otherGSTValue.text = "INR \(Int(calculatePercentage(value: Double(normalRate), percentageVal:  Double(normalTax))))"
                cell.otherTotalValue.text = "INR \(totAmt)"
                
            }else if normalDeviceArr.count > 0 {
                var totAmt =  getDeviceTypeAmount(deviceId: Int(normalDeviceArr[0]) ?? 0)
                totAmt = totAmt * normalDeviceArr.count
                let normalRate = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWAL"))?.rate ?? 0.0
                let normalTax = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWAL"))?.tax ?? 0.0
                cell.otherTitle.text = "Other devices"
                cell.otherGSTTitle.text = "GST @ \(normalTax)%\n(per device)"
                cell.otherTotalTitle.text = "Total\n \(normalDeviceArr.count) device"
                cell.otherRateValue.text = "INR \(normalRate)"
                cell.otherGSTValue.text = "INR \(Int(calculatePercentage(value: Double(normalRate), percentageVal:  Double(normalTax))))"
                cell.otherTotalValue.text = "INR \(totAmt)"
            }
    
        } else if rowCount == 2 {
            switch indexPath.row {
            case 0:
                if aisDeviceArr.count > 0 {
                   var totAmt =  getDeviceTypeAmount(deviceId: Int(aisDeviceArr[0]) ?? 0)
                    totAmt = totAmt * aisDeviceArr.count
                    let normalRate = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWALAIS"))?.rate ?? 0.0
                    let normalTax = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWALAIS"))?.tax ?? 0.0
                    cell.otherTitle.text = "AIS devices"
                    cell.otherGSTTitle.text = "GST @ \(normalTax)%\n(per device)"
                    cell.otherTotalTitle.text = "Total\n \(aisDeviceArr.count) device"
                    cell.otherRateValue.text = "INR \(normalRate)"
                    cell.otherGSTValue.text = "INR \(Int(calculatePercentage(value: Double(normalRate), percentageVal:  Double(normalTax))))"
                    cell.otherTotalValue.text = "INR \(totAmt)"
                    
                }
                break
            case 1:
                if normalDeviceArr.count > 0 {
                   var totAmt =  getDeviceTypeAmount(deviceId: Int(normalDeviceArr[0]) ?? 0)
                   totAmt = totAmt * normalDeviceArr.count
                   let normalRate = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWAL"))?.rate ?? 0.0
                   let normalTax = Defaults().get(for: Key<PaymentRatesModelData>("Payment_RENEWAL"))?.tax ?? 0.0
                   cell.otherTitle.text = "Other devices"
                    cell.otherGSTTitle.text = "GST @ \(normalTax)%\n(per device)"
                   cell.otherTotalTitle.text = "Total\n \(normalDeviceArr.count) device"
                   cell.otherRateValue.text = "INR \(normalRate)"
                    cell.otherGSTValue.text = "INR \(Int(calculatePercentage(value: Double(normalRate), percentageVal:  Double(normalTax))))"
                   cell.otherTotalValue.text = "INR \(totAmt)"
               }
                break
            default:
                break
            }
        }
       return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if normalDeviceArr.count > 0 {
            totalAmt = totalAmt + (getDeviceTypeAmount(deviceId: Int(normalDeviceArr[0]) ?? 0) * normalDeviceArr.count)
        }
        if aisDeviceArr.count > 0 {
            totalAmt = totalAmt + (getDeviceTypeAmount(deviceId: Int(aisDeviceArr[0]) ?? 0) * aisDeviceArr.count)
        }
        totAmtValue.text = "INR\(totalAmt)"
        totAmtTitle.text = "Total\n (all device)"
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return detailsTable.frame.size.height * 0.3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return detailsTable.frame.size.height * 0.6/CGFloat(rowCount)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return detailsTable.frame.size.height * 0.1
    }
    
}
class SubsDetailsCell: UITableViewCell {
    var otherTitle:UILabel!
    var otherRateTitle:UILabel!
    var otherGSTTitle:UILabel!
    var otherTotalTitle:UILabel!
    var otherRateValue:UILabel!
    var otherGSTValue:UILabel!
    var otherTotalValue:UILabel!
    var otherStackView:UIStackView!
    
    var stackView:UIStackView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addView(){
        otherTitle = UILabel(frame: CGRect.zero)
        otherTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        otherTitle.textColor = appGreenTheme
        otherTitle.textAlignment = .center
        
        otherRateTitle = UILabel(frame: CGRect.zero)
        otherRateTitle.text = "Rate\n(per device)"
        otherRateTitle.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        otherRateTitle.numberOfLines = 2
        otherRateTitle.textColor = .black
        
        otherGSTTitle = UILabel(frame: CGRect.zero)
//        otherGSTTitle.text = "GST @ 18.0%\n(per device)"
        otherGSTTitle.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        otherGSTTitle.numberOfLines = 2
        otherGSTTitle.textColor = .black
        
        otherTotalTitle = UILabel(frame: CGRect.zero)
        otherTotalTitle.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        otherTotalTitle.numberOfLines = 2
        otherTotalTitle.textColor = .black
        
        otherRateValue = UILabel(frame: CGRect.zero)
        otherRateValue.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        otherRateValue.adjustsFontSizeToFitWidth = true
        otherRateValue.textColor = .black
        
        otherGSTValue = UILabel(frame: CGRect.zero)
        otherGSTValue.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        otherGSTValue.adjustsFontSizeToFitWidth = true
        otherGSTValue.textColor = .black
        
        otherTotalValue = UILabel(frame: CGRect.zero)
        otherTotalValue.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        otherTotalValue.adjustsFontSizeToFitWidth = true
        otherTotalValue.textColor = .black
        
        stackView = UIStackView()
        stackView.addSubview(otherTitle)
        stackView.addSubview(otherRateValue)
        stackView.addSubview(otherRateTitle)
        stackView.addSubview(otherGSTTitle)
        stackView.addSubview(otherGSTValue)
        stackView.addSubview(otherTotalValue)
        stackView.addSubview(otherTotalTitle)
        stackView.addSubview(otherTitle)
        contentView.addSubview(stackView)
    }
    func addConstraints(){
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        otherTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        otherRateTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(otherTitle.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.28)
        }
        otherGSTTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(otherRateTitle.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.28)
        }
        otherTotalTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(otherGSTTitle.snp.bottom)
            make.height.equalToSuperview().multipliedBy(0.28)
        }
        otherRateValue.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(otherRateTitle)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        otherGSTValue.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(otherGSTTitle)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        otherTotalValue.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(otherTotalTitle)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        
    }
    
}


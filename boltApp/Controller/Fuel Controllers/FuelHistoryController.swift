//
//  FuelHistoryController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import RealmSwift
import SnapKit
import DefaultsKit

class 
FuelHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fuelHeading: UILabel!
    var dateHeading: UILabel!
    var priceHeading: UILabel!
    var fillHeading: UILabel!
    var totalHeading: UILabel!
    var extraLabel: UILabel!
    var realm: Realm!
    var fuelHistoryTable: UITableView!
    var fuelHistoryData = [FuelModelApiData]()
    
    var imagePopupView: UIView!
    var docImage: UIImageView!
    var dismiisBtn: UIButton!
    var viewBtn:UIButton!
    private let cellIdentifier: String = "FuelCell"
    var imString = ""
    var bgView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        try! realm = Realm()
        view.backgroundColor = .clear
        addViews()
        addConstraints()
        addDataToTableView()
        
    }
    
    func addViews() {
        bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        view.addSubview(bgView)
        
        imagePopupView = UIView()
        imagePopupView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        imagePopupView.clipsToBounds = true
        imagePopupView.isHidden = true
        imagePopupView.layer.cornerRadius = (self.view.frame.size.height * 0.35) / 10
      //  let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        view.addSubview(imagePopupView)
        //self.view.addSubview(imagePopupView)
        
        docImage = UIImageView()
        docImage.isUserInteractionEnabled = true
        docImage.image = #imageLiteral(resourceName: "cross")
        docImage.contentMode = .center
        imagePopupView.addSubview(docImage)
        
        dismiisBtn = UIButton()
        dismiisBtn.setTitle("Dismiss", for: .normal)
        dismiisBtn.setTitleColor(UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1.0), for: .normal)
        imagePopupView.addSubview(dismiisBtn)
        dismiisBtn.addTarget(self, action: #selector(dismissImageView), for: .touchUpInside)
        
        viewBtn = UIButton()
        viewBtn.setTitle("View", for: .normal)
        viewBtn.setTitleColor(UIColor(red: 1, green: 59/255, blue: 48/255, alpha: 1.0), for: .normal)
        imagePopupView.addSubview(viewBtn)
        viewBtn.addTarget(self, action: #selector(imgZoomingView), for: .touchUpInside)
        
        fuelHeading = UILabel()
        fuelHeading.text = "Petrol"
        fuelHeading.textColor = appGreenTheme
        fuelHeading.adjustsFontForContentSizeCategory = true
        fuelHeading.textAlignment = .center
        bgView.addSubview(fuelHeading)
        
        dateHeading = UILabel()
        dateHeading.text = "Date"
        dateHeading.backgroundColor = .black
        dateHeading.textColor = .white
        dateHeading.adjustsFontForContentSizeCategory = true
        dateHeading.textAlignment = .center
        bgView.addSubview(dateHeading)
        
        priceHeading = UILabel()
        priceHeading.text = "Price"
        priceHeading.backgroundColor = .black
        priceHeading.textColor = .white
        priceHeading.adjustsFontForContentSizeCategory = true
        priceHeading.textAlignment = .center
        bgView.addSubview(priceHeading)
        
        fillHeading = UILabel()
        fillHeading.text = "Fill"
        fillHeading.textColor = .white
        fillHeading.backgroundColor = .black
        fillHeading.adjustsFontForContentSizeCategory = true
        fillHeading.textAlignment = .center
        bgView.addSubview(fillHeading)
        
        totalHeading = UILabel()
        totalHeading.text = "Total"
        totalHeading.textColor = appGreenTheme
        totalHeading.backgroundColor = .black
        totalHeading.adjustsFontForContentSizeCategory = true
        totalHeading.textAlignment = .center
        bgView.addSubview(totalHeading)
        
        extraLabel = UILabel()
        extraLabel.text = ""
        extraLabel.textColor = appGreenTheme
        extraLabel.backgroundColor = .black
        extraLabel.adjustsFontForContentSizeCategory = true
        extraLabel.textAlignment = .center
        bgView.addSubview(extraLabel)
        
        
        
        
        fuelHistoryTable = UITableView()
        fuelHistoryTable.backgroundColor = .white
        fuelHistoryTable.separatorColor = .black
        fuelHistoryTable.separatorStyle = .singleLineEtched
        fuelHistoryTable.delegate = self
        fuelHistoryTable.dataSource = self
        fuelHistoryTable.bounces = false
        fuelHistoryTable.register(FuelHistoryCell.self, forCellReuseIdentifier: cellIdentifier)
        bgView.addSubview(fuelHistoryTable)
    }
    
    @objc  func dismissImageView() {
        self.imagePopupView.isHidden = true
    }
    @objc  func imgZoomingView() {
        let image = docImage.image
        let vc = ImageFullSizeViewController()
        vc.selectedImg = image
        self.present(vc, animated: true, completion: nil)
    }
    
    func addDataToTableView() {
        
        
        let fuelData = realm.objects(FuelModelApiData.self).filter( { $0.device_id == "\(bottomSheetDeviceId)" })
        
        let temp = fuelData.sorted(by: { RCGlobals.getDateFromTwo($0.timestamp!) < RCGlobals.getDateFromTwo($1.timestamp!)})
        
        if let typeOfFuel = temp.first?.fuel_type {
            if typeOfFuel == "petrol" {
                fuelHeading.text = "Petrol"
            } else {
                fuelHeading.text = "Diesel"
            }
        }
        if temp.count > 0 {
            fuelHistoryData = Array(temp)
            fuelHistoryTable.reloadData()
        }
        
        // fuelHistoryTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fuelHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FuelHistoryCell
        cell.dateLabel.text = RCGlobals.getStringDateFromString(fuelHistoryData[indexPath.row].timestamp!)
        let totalFuel = fuelHistoryData[indexPath.row].fuel_filled
        let pricePerLitre = fuelHistoryData[indexPath.row].price_per_litre ?? "0.0"
        let amountStr = fuelHistoryData[indexPath.row].amount ?? "0.0"
        
        let tf = Double(totalFuel) ?? 0.0
        let pl =  Double(pricePerLitre) ?? 0.0
        let amount = Double(amountStr) ?? 0.0
        // let totalCost =  tf * pl
        
        //let doubleStTotalCost = String(format: "%.2f", totalCost)
        let doubleStTotalFill = String(format: "%.2f", tf)
        let doubleStpricePerLit = String(format: "%.2f", pl)
        let doubleStTotalCost = String(format: "%.1f", amount)
        
        
        
        cell.imageBtn.addTarget(self, action: #selector(clickedImage(sender:)), for: .touchUpInside)
        cell.imageBtn.tag = indexPath.row
        
        cell.fillLabel.text = "\(doubleStTotalFill)"
        cell.priceLabel.text = "\(doubleStpricePerLit)"
        cell.totalLabel.text = "\(doubleStTotalCost)  " +  "(" + (fuelHistoryData[indexPath.row].payment_type ?? "") + ")"
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    @objc func clickedImage(sender:UIButton) {
        //
        let imageToShow = fuelHistoryData[sender.tag].image_name
        self.docImage.image = nil
        if let imageUrl = imageToShow {
            if imageUrl != "" {
                self.imagePopupView.isHidden = false
                if imageUrl.contains("firebase") {
                    self.docImage.downloaded(from: imageUrl, contentMode: .scaleAspectFit)
                } else {
                    self.imagePopupView.isHidden = false
                    let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
                    let link = "https://track.roadcast.co.in//user_docs/user_" + "\(userID)" + "/" + imageUrl
                    self.docImage.downloaded(from: link, contentMode: .scaleAspectFit)
                }
            } else {
                self.imagePopupView.isHidden = true
                self.prompt("No Image for the entry")
            }
        } else {
            self.imagePopupView.isHidden = true
            self.prompt("No Image for the entry")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.imagePopupView.isHidden {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func addConstraints() {
        bgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        fuelHeading.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        dateHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fuelHeading.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(4.5)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        priceHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fuelHeading.snp.bottom)
            make.left.equalTo(dateHeading.snp.right)
            make.size.equalTo(dateHeading)
        }
        fillHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fuelHeading.snp.bottom)
            make.left.equalTo(priceHeading.snp.right)
            make.size.equalTo(dateHeading)
        }
        totalHeading.snp.makeConstraints { (make) in
            make.top.equalTo(fuelHeading.snp.bottom)
            make.left.equalTo(fillHeading.snp.right)
            make.size.equalTo(dateHeading)
        }
        extraLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fuelHeading.snp.bottom)
            make.left.equalTo(totalHeading.snp.right)
            make.width.equalTo(fillHeading.snp.width)
            make.height.equalTo(fillHeading.snp.height)
        }
        fuelHistoryTable.snp.makeConstraints { (make) in
            make.top.equalTo(dateHeading.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        imagePopupView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        docImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalTo(docImage.snp.height)
        }
        
        viewBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        dismiisBtn.snp.makeConstraints { (make) in
            make.right.equalTo(viewBtn.snp.left).offset(-10)
            make.centerY.equalTo(viewBtn)
            make.size.equalTo(viewBtn)
        }
    }
    
}

//
//  SubscriptionDetailView.swift
//  Bolt
//
//  Created by Saanica Gupta on 01/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import Foundation
import SnapKit

class SubscriptionDetailView: UIView {
    
    var detailsTable:UITableView!
    
    var titleLbl:UILabel!
    var vStack:UIStackView!
    
    var otherTitle:UILabel!
    var otherRateTitle:UILabel!
    var otherGSTTitle:UILabel!
    var otherTotalTitle:UILabel!
    var otherRateValue:UILabel!
    var otherGSTValue:UILabel!
    var otherTotalValue:UILabel!
    var otherStackView:UIStackView!
    
    var aisTitle:UILabel!
    var aisRateTitle:UILabel!
    var aisGSTTitle:UILabel!
    var aisTotalTitle:UILabel!
    var aisRateValue:UILabel!
    var aisGSTValue:UILabel!
    var aisTotalValue:UILabel!
    var aisStackView:UIStackView!
    
    var totalTitle:UILabel!
    var totalAmtTitle:UILabel!
    var totalAmtValue:UILabel!
    var totalStackView:UIStackView!
    
    var doneBtn:UIButton!
    
    
    var subscriptiondetailsview: UIView!
    var lineview: UIView!
    var subscriptiondetailsLabel: UILabel!
    var otherdeviceLabel: UILabel!
    var rateLabel: UILabel!
    var rateperdeviceLabel: UILabel!
    var rateamountLabel: UILabel!
    var gstLabel : UILabel!
    var perdevicegstLabel: UILabel!
    var gstamountLabel: UILabel!
    var totalLabel: UILabel!
    var totaldeviceLabel : UILabel!
    var totalamountLabel: UILabel!
    var line1view: UIView!
    var total: UILabel!
    var totalamont: UILabel!
    var totalalldeviceLabel: UILabel!
    var amount : UILabel!
    var gotitButton: UIButton!
    
    var kscreenheight = UIScreen.main.bounds.height
    var kscreenwidth = UIScreen.main.bounds.width
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        views()
        addconstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func views(){
        titleLbl = UILabel(frame: CGRect.zero)
        titleLbl.text = "Subscription Details"
        titleLbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        
        // other
        otherTitle = UILabel(frame: CGRect.zero)
        otherTitle.text = "Other devices"
        otherTitle.font = UIFont.systemFont(ofSize: 15, weight: .light)
        otherTitle.adjustsFontSizeToFitWidth = true
        otherTitle.textColor = appGreenTheme
        otherTitle.textAlignment = .center
        
        otherRateTitle = UILabel(frame: CGRect.zero)
        otherRateTitle.text = "Other devices"
        otherRateTitle.font = UIFont.systemFont(ofSize: 15, weight: .light)
        otherRateTitle.adjustsFontSizeToFitWidth = true
        otherRateTitle.textColor = appGreenTheme
        otherRateTitle.textAlignment = .center
        
        gotitButton = UIButton(frame: CGRect.zero)
        gotitButton.setTitle("GOT IT", for: .normal)
        gotitButton.backgroundColor = appGreenTheme
        gotitButton.titleLabel?.textColor = .white
     //   subscriptiondetailsview.addSubview(gotitButton)
        
        detailsTable = UITableView()
        detailsTable.backgroundColor = .white
        addSubview(detailsTable)
    }
    func addconstraints(){
        detailsTable.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

//
//  HelpViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit

class HelpViewController: UIViewController {

   fileprivate var headingLabel: UILabel!
   fileprivate var contactLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        addConstraints()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(dismissThis(_:)))
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    }
    
    @objc fileprivate func dismissThis(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func addViews() {
        headingLabel = UILabel()
        headingLabel.text = "Please contact customer care"
        headingLabel.adjustsFontSizeToFitWidth = true
        headingLabel.textAlignment = .center
        headingLabel.textColor = UIColor(red: 79/255, green: 195/255, blue: 247/255, alpha: 1.0)
        view.addSubview(headingLabel)
        
        contactLabel = UILabel()
        contactLabel.text = "support@roadcast.in" + "\n" + "+91-7290055599"
        contactLabel.numberOfLines = 2
        contactLabel.adjustsFontSizeToFitWidth = true
        contactLabel.textAlignment = .center
        contactLabel.textColor = .black
        view.addSubview(contactLabel)
    }
    
    fileprivate func addConstraints() {
        headingLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        contactLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headingLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }

}

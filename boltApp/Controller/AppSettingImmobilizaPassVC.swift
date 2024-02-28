//
//  AppSettingImmobilizaPassVC.swift
//  Bolt
//
//  Created by Roadcast on 13/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
class AppSettingImmobilizaPassVC: UIViewController {
    var popview:UIView!
    var alert:UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
      
        
    }
    
 func   addview(){
    popview = UIView(frame: CGRect.zero)
    popview.backgroundColor = .white
    popview.layer.cornerRadius = 10
    popview.clipsToBounds = true
    view.addSubview(popview)
    
    alert = UIAlertController(title: "Enter Password", message: "please enter password to proceed further.", preferredStyle: .alert)
    alert.addTextField { (textField : UITextField!) -> Void in
        textField.placeholder = "******"
        textField.textColor = .black
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = true
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { alert -> Void in
        self.view.resignFirstResponder()
    })
    let okbtn = UIAlertAction(title: "OK", style: .default
        , handler: {alert -> Void in
            
    })
    
    
    alert.addAction(cancel)
    alert.addAction(okbtn)

    self.present(alert, animated: true, completion: nil)
    }
    
    func addconstr(){
        popview.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.60)
            make.height.equalToSuperview().multipliedBy(0.40)
        }
    }

}

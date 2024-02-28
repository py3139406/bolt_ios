//
//  TrackerDetailsViewController.swift
//  Bolt
//
//  Created by Arshad Ali on 15/12/17.
//  Copyright © 2017 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class TrackerDetailsViewController: UIViewController{
    
    var trackerDetailsView : TrackerDetailsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        trackerDetailsView =  TrackerDetailsView()
        trackerDetailsView.backgroundColor = .white
        view.addSubview(trackerDetailsView)
        addConstrants()
        
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func addConstrants(){
        trackerDetailsView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
            
        }
    }

  
}

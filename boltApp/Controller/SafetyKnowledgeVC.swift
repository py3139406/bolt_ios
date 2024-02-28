//
//  SafetyKnowledgeVC.swift
//  Bolt
//
//  Created by Saanica Gupta on 04/04/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import Foundation

class SafetyKnowledgeVC: UIViewController {
  
   var safetyFeatureview: SecurityFeatureView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
        addNavigationBar()

        safetyFeatureview = SecurityFeatureView(frame: view.bounds)
        safetyFeatureview.backgroundColor = .white
        view.addSubview(safetyFeatureview)
    }
  


private func addNavigationBar() {
  
    self.navigationController?.navigationBar.tintColor = appGreenTheme
    self.navigationController?.navigationBar.backgroundColor = .white
  
    let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done,
                                     target: self,
                                     action: #selector(backButtonTapped))
  
    self.navigationItem.leftBarButtonItem = leftButton
}

@objc private func backButtonTapped() {
  self.navigationController?.popViewController(animated: true)
}
  
}

//
//  AttentionVC.swift
//  Bolt
//
//  Created by Roadcast on 12/12/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import UIKit

class AttentionVC: UIViewController {

    var attentionview : AttentionView!
       override func viewDidLoad() {
           super.viewDidLoad()
           attentionview = AttentionView(frame: view.bounds)
                  view.backgroundColor = .lightGray
                  self.navigationController?.isNavigationBarHidden = false
                  view.addSubview(attentionview)
                  let navigate = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
                  self.navigationItem.leftBarButtonItem  = navigate

              }
              @objc func back()
                        {   self.dismiss(animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)}
              
              func dismissKeyboard() {
                  self.view.endEditing(true)
              }
              

              override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                  self.view.endEditing(true)
              }
           
}

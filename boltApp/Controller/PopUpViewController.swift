//
//  PopUpViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class PopUpViewController: UIViewController {
    
    var popupView : PopUp!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView = PopUp(frame:view.bounds)
        view.addSubview(popupView)
        popupView.dismissBtn.addTarget(self, action: #selector(dismissBtnAction(_sender:)), for: .touchUpInside)
     }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissBtnAction(_sender : UIButton){
       self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        popupView.lastTextView.sizeToFit()
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

}

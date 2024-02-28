//
//  BasicViewController.swift
//  Bolt
//
//  Created by Roadcast on 20/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {
    let index : Int

     init(index: Int) {
         self.index = index
         super.init(nibName: nil, bundle: nil)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var img = UIImageView()
     let imageViews = [#imageLiteral(resourceName: "petrol") , #imageLiteral(resourceName: "Restroom") ,#imageLiteral(resourceName: "Restraunt") , #imageLiteral(resourceName: "Medical") , #imageLiteral(resourceName: "plolice") ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "IMAGE[\(index + 1)]"
        navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backarrow"), style: .plain, target: self, action: #selector(dismissView(_:)))
        img.image = imageViews[index]
        img.contentMode = .scaleToFill
        view.addSubview(img)
        img.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaInsets).offset(100)
            } else {
                // Fallback on earlier versions
                make.top.equalToSuperview().offset(100)
            }
            make.left.equalToSuperview().offset(20)
             make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-100)
        }
     
    }
    @objc func dismissView(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    



}

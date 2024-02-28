
//
//  TestView.swift
//  Bolt
//
//  Created by Roadcast on 9/4/18.
//  Copyright © 2018 Arshad Ali. All rights reserved.
//

import UIKit

class TestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1.0)
        self.layer.cornerRadius = 8.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

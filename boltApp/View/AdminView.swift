//
//  AdminView.swift
//  Bolt
//
//  Created by Roadcast on 02/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import WebKit

class AdminView: UIView {
    var webView: WKWebView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setViews(){
        webView = WKWebView()
        webView.backgroundColor = .white
        addSubview(webView)
    }
    func setConstraints(){
        webView.snp.makeConstraints { (make) in
            make.top.width.height.bottom.equalToSuperview()
        }
    }
}

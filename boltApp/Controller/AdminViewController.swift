//
//  AdminViewController.swift
//  Bolt
//
//  Created by Roadcast on 02/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit
import WebKit

class AdminViewController: UIViewController {
    var adminView:AdminView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFunction()
        setViews()
        setConstraints()
        setActions()
    }
    func setActions(){
        let password = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            let username = UserDefaults.standard.string(forKey: "userName") ?? ""
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            let url = NSURL (string: "https://track.roadcast.co.in/v1/auth/login?menu=true&url=/app/admin/manage&basic=\(base64LoginString)")
        let requestObj = NSURLRequest(url: url! as URL)
        adminView.webView.load(requestObj as URLRequest)
        
        let preferences = WKPreferences()
         preferences.javaScriptEnabled = true
        if #available(iOS 13.0, *) {
            preferences.isFraudulentWebsiteWarningEnabled = true
        } else {
          
        }
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
    }
    func setViews(){
        adminView = AdminView()
        view.addSubview(adminView)
    }
    func  setConstraints(){
        adminView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
   func navigationBarFunction() {
       self.navigationItem.title = "Admin"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
    }
    @objc func backTapped() {
        self.prompt("Exit admin panel", "Are you sure ", "NO", "YES", handler1: { (_) in} , handler2: { (_) in
            self.dismiss(animated: true, completion: nil)
        })
//        if adminView.webView.canGoBack {
//        adminView.webView.goBack()
//        } else {
//            self.prompt("Exit admin panel", "Are you sure ", "NO", "YES", handler1: { (_) in} , handler2: { (_) in
//                self.dismiss(animated: true, completion: nil)
//            })
//        }
        
    }

}

//
//  FAQView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import UIKit
import WebKit


class FAQController : UIViewController , UIWebViewDelegate{
    
    let faqview = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))

        let faqview = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        faqview.load(NSURLRequest(url: NSURL(string: "https://track.roadcast.co.in/track/faq.html")! as URL) as URLRequest)
        self.view.addSubview(faqview)
        
        faqview.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
    }
    
}

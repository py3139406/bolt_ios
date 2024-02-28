//
//  TermsAndConditionsView.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import WebKit

class TermsAndConditionsView: UIView {
    
    var topLabel:UILabel!
    var webView:WKWebView!
    var yesButton:UIButton!
    var aLabel: UILabel!
    var navBarView: UIView!
    var navBack: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  UIColor(red: 243/255, green: 244/255, blue: 245/255, alpha: 1.0)
        addlabel()
        addWevView()
        addButton()
        addConstrants()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addlabel(){
        
        navBarView = UIView(frame: CGRect.zero)
        navBarView.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        addSubview(navBarView)
        
        navBack = UIButton(frame: CGRect.zero)
        navBack.setImage(#imageLiteral(resourceName: "back-1").resizedImage(CGSize.init(width: 15, height: 25), interpolationQuality: .default), for: UIControlState.normal)
        addSubview(navBack)
        
        topLabel = UILabel(frame: CGRect.zero)
        topLabel.text = "Terms & Conditions".toLocalize
        topLabel.textColor = .black
        topLabel.font = UIFont.systemFont(ofSize: 35, weight: .thin)
        topLabel.adjustsFontSizeToFitWidth = true
        addSubview(topLabel)
        
        
    }
    
    func addWevView(){
        webView = WKWebView(frame:CGRect.zero)
        let htmlFilePath = Bundle.main.path(forResource: "termsCondition", ofType: "html")
        let html = try? String(contentsOfFile: htmlFilePath!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(html!, baseURL: nil)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .white
        addSubview(webView)
        
        aLabel = UILabel(frame: CGRect.zero)
 //       let byString =  "By tapping".toLocalize
//        aLabel.text = "By tapping \" Yes, I agree \"  you accept the terms & conditions listed above in Roadcast\'s service agreement."
        
        let by = "By tapping".toLocalize
        let yes = "Yes, I agree".toLocalize
        let text = "you accept the terms & conditions listed above in Roadcast\'s service agreement.".toLocalize
        aLabel.text = "\(by) \" \(yes) \"  \(text)."
        aLabel.numberOfLines = 0
        aLabel.adjustsFontSizeToFitWidth = true
        aLabel.textColor = .black
        aLabel.backgroundColor = .white
        aLabel.isHidden = false
        webView.addSubview(aLabel)
        
    }
    
    func addButton(){
        yesButton = UIButton(frame:CGRect.zero)
        yesButton.backgroundColor =  appGreenTheme
        yesButton.isHidden = false
        yesButton.setTitle("Yes, I Agree".toLocalize, for: .normal)
        yesButton.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        addSubview(yesButton)
    }

    func addConstrants(){
        navBarView.snp.makeConstraints { (make) in
            if #available(iOS 11, *){
               make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            }else{
               make.top.equalToSuperview()
            }
            
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        
        navBack.snp.makeConstraints { (make) in
            make.top.height.equalTo(navBarView)
            make.left.equalToSuperview().offset(15)
            make.width.equalTo(30)
        }
       
        topLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(safeAreaLayoutGuide.snp.leftMargin).offset(20)
                make.top.equalTo(navBarView.snp.bottom)
                make.leading.equalTo(safeAreaLayoutGuide.snp.leadingMargin)
                make.trailing.equalTo(safeAreaLayoutGuide.snp.trailingMargin)
                make.height.equalToSuperview().multipliedBy(0.08)
                make.width.equalToSuperview().multipliedBy(0.90)
            } else {
                make.left.equalToSuperview().offset(20)
                make.top.equalTo(navBarView.snp.bottom)
                make.height.equalToSuperview().multipliedBy(0.08)
                make.width.equalToSuperview().multipliedBy(0.90)
            }
        }
        
      
        webView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(topLabel.snp.bottom).offset(5)
            make.right.equalToSuperview()
            if #available(iOS 11, *){
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin).offset(-0.1 * kscreenheight)
            }else{
              make.bottom.equalToSuperview().offset(-0.1 * kscreenheight)
            }

        }
        
        yesButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
            if #available(iOS 11, *){
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin).offset(-0.05 * kscreenheight)
            }else{
                make.bottom.equalToSuperview().offset(-0.05 * kscreenheight)
            }
            
        }
        
        aLabel.snp.makeConstraints { (make) in
            make.left.equalTo(webView.snp.left)
            make.right.equalTo(webView.snp.right).offset(-1)
            make.bottom.equalTo(yesButton.snp.top)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        
    }
    
    
}



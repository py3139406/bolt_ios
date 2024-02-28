//
//  TermsAndConditionsViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

class TermsAndConditionsViewController: UIViewController {

    var termsAndConditionsView :TermsAndConditionsView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appDarkTheme
        termsAndConditionsView = TermsAndConditionsView(frame:CGRect.zero)
        view.addSubview(termsAndConditionsView)
        setConstraints()
        termsAndConditionsView.yesButton.addTarget(self, action: #selector(yesButtonAction(sender:)), for: .touchUpInside)
        termsAndConditionsView.webView.scrollView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        termsAndConditionsView.navBack.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    func setConstraints(){
        termsAndConditionsView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
  @objc   func yesButtonAction(sender:UIButton){
      let navController =  OTPViewController()
      navController.isHeroEnabled = true
      navController.heroModalAnimationType = .zoomSlide(direction: .left)
      self.hero.replaceViewController(with: navController)
    }
    @objc func backTapped(){
      //  self.dismiss(animated: true, completion: nil)
        let navController =  SignUpViewController() // Creating a navigation controller with resultController at the root of the navigation stack.
        navController.isHeroEnabled = true
        navController.heroModalAnimationType = .zoomSlide(direction: .right)
        self.hero.replaceViewController(with: navController)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TermsAndConditionsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottom = termsAndConditionsView.aLabel.bounds.height+10
        termsAndConditionsView.webView.scrollView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom:bottom,right: 0)
        termsAndConditionsView.yesButton.isHidden = false
        termsAndConditionsView.aLabel.isHidden = false
    }
    
}

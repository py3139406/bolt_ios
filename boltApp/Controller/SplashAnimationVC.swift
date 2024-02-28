//
//  SplashAnimationVC.swift
//  Bolt
//
//  Created by Vishal Jain on 08/08/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseStorage
import DefaultsKit

class SplashAnimationVC: UIViewController {

    var splashAnimationView:SplashAnimationView = SplashAnimationView(frame: CGRect.zero)
    var HUD: MBProgressHUD?
    var fileExists:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showProgress(message: "Please wait...")
    }
    
    @objc func cancelAnimation(_ sender:UIButton) {
        RCGlobals.updateAnimationDate()
        self.splashAnimationView.window?.rootViewController = ViewController()
        
    }
    
    func addView() {
        view.addSubview(splashAnimationView)
        
        splashAnimationView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        self.splashAnimationView.closeButton.addTarget(self, action: #selector(cancelAnimation(_:)), for: .touchUpInside)
        
        handleAnimation()
    }
    
    func handleAnimation() {
        let storage = Storage.storage()
        
        let httpsReference = storage.reference().child("AnimationFiles").child("splash_animation.gif")
        
        httpsReference.downloadURL {
            (url, error) in
            guard let downloadURL = url
            else {
                self.fileExists = false
                self.hideProgress()
                RCGlobals.updateAnimationDate()
                self.splashAnimationView.window?.rootViewController = ViewController()
                return
            }
            
            if let animationData = Defaults().get(for: Key<Data>(defaultKeyNames.animationData.rawValue)) {
                self.hideProgress()
                self.splashAnimationView.animationView.animate(withGIFData: animationData)
                let start = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: start){
                    RCGlobals.updateAnimationDate()
                    self.splashAnimationView.window?.rootViewController = ViewController()
                }
            } else {
                
                // Download in memory with a maximum allowed size of 5MB (5 * 1024 * 1024 bytes)
                httpsReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    self.hideProgress()
                    if let error = error {
                        print("\(error.localizedDescription)")
                        RCGlobals.updateAnimationDate()
                        self.splashAnimationView.window?.rootViewController = ViewController()
                    } else {
                        if let imageData = data {
                            Defaults().set(imageData, for: Key<Data>(defaultKeyNames.animationData.rawValue))
                            self.splashAnimationView.animationView.animate(withGIFData: imageData)
                            let start = DispatchTime.now() + 5
                            DispatchQueue.main.asyncAfter(deadline: start){
                                RCGlobals.updateAnimationDate()
                                self.splashAnimationView.window?.rootViewController = ViewController()
                            }
                        }
                    }
                }
            }
        }
    }
    

    func showProgress (message : String) {
        let topWindow = UIApplication.shared.keyWindow
        if let window = topWindow {
            HUD = MBProgressHUD.showAdded(to: window, animated: true)
            HUD?.animationType = .fade
            HUD?.mode = .indeterminate
            HUD?.labelText = message
        }
    }
    
    func hideProgress () {
        HUD?.hide(true)
    }
    

}

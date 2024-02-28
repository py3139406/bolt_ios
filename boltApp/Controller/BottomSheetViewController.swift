//
//  BottomSheetViewController.swift
//  Bolt
//
//  Created by Roadcast on 29/08/18.
//  Copyright © 2018 Arshad Ali. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController, UIScrollViewDelegate {
    let screensize = UIScreen.main.bounds.size
   lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0)
        return bdView
    }()
    
    let menuHeight = UIScreen.main.bounds.height / 2
    var isPresenting = false
    let cellId = "collectionCellID"
    var bottomView = BottomSheetView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backdropView)
        
        addBottomView()
        // Do any additional setup after loading the view.
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        //transitioningDelegate = self as! UIViewControllerTransitioningDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBottomView() -> Void {
        bottomView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.20)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.30)
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(self.view.safeAreaInsets.bottom)
//            } else {
//                // Fallback on earlier versions
//                make.bottom.equalToSuperview()
//            }
        }
        //bottomView = BottomSheetView(frame: CGRect(x: 0, y: self.view.center.y, width: self.view.frame.width, height: self.view.frame.height/2))
        bottomView.featureScroll.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
        view.addSubview(bottomView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
}

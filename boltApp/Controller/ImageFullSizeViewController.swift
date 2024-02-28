//
//  ImageFullSizeViewController.swift
//  Bolt
//
//  Created by Roadcast on 24/09/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit

class ImageFullSizeViewController: UIViewController, UIScrollViewDelegate {
    var img:UIImageView!
    var scroll:UIScrollView!
    var selectedImg:UIImage? = nil
    var cancelBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        scroll.delegate = self
        cancelBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img
    }
    func  setViews(){
        
        scroll = UIScrollView()
        scroll.backgroundColor = .white
        scroll.backgroundColor?.withAlphaComponent(0.5)
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 10
        scroll.alwaysBounceVertical = false
        scroll.alwaysBounceHorizontal = false
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        scroll.contentSize = .init(width: screensize.width, height: screensize.height)
        view.addSubview(scroll)
        
        img = UIImageView()
        img.image = selectedImg
        img.clipsToBounds = false
        img.layer.cornerRadius = 10
        scroll.addSubview(img)
        
        cancelBtn = UIButton()
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.titleLabel?.textColor = .white
        cancelBtn.backgroundColor = .red
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        scroll.addSubview(cancelBtn)

    }
    func setConstraints(){
        scroll.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
        cancelBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screensize.height * 0.05)
            make.left.equalToSuperview().offset(screensize.width * 0.05)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        img.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)

        }
    }
}

//
//  ShowDateOrTimerVC.swift
//  Bolt
//
//  Created by Roadcast on 30/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class ShowDateOrTimerVC: UIViewController {
    var DoneBtn = UIButton()
    var timerView:UIView = NewFeatures().boltTimePicker()
    let blurView = NewFeatures().blurrEffect()
    var workType:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        DoneBtn.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.dismiss(animated: true, completion: nil)
    }
    @objc func dismiss(_ sender:UIButton){
        if workType == "start"{
        
        } else if workType == "end"{
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    func setViews(){
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        timerView.layer.cornerRadius = 5
        timerView.layer.masksToBounds = true
        timerView.backgroundColor = .white
        timerView.tintColor = .black
        view.addSubview(timerView)
        
        DoneBtn.setTitle("DONE", for: .normal)
        DoneBtn.setTitleColor(.white, for: .normal)
        DoneBtn.backgroundColor = appGreenTheme
        DoneBtn.layer.cornerRadius = 5
        DoneBtn.layer.masksToBounds = true
        view.addSubview(DoneBtn)
        
    }
    func setConstraints(){
        timerView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.center.equalToSuperview()
        }
        DoneBtn.snp.makeConstraints { (make) in
            make.top.equalTo(timerView.snp.bottom).offset(20)
            make.width.equalTo(timerView)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.centerX.equalTo(timerView)
        }
    }
    
}

//
//  AcceptCallVC.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit
import AudioToolbox
import AVFAudio
import AVFoundation

class AcceptCallVC: UIViewController {

    var acceptCallView:AcceptCallView!
    var callImei:String = Defaults().get(for: Key<String>(defaultKeyNames.callIMEI.rawValue)) ?? ""
    var callName:String = Defaults().get(for: Key<String>(defaultKeyNames.callName.rawValue)) ?? ""
    var remoteCounter = 0
    var remoteTimer:Timer?
    var isAccepted:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFunction()
        addViews()
        setConstraints()
        addActions()
        playSound()
        startTimer()
    }
    
    func addViews() {
        acceptCallView = AcceptCallView()
        view.addSubview(acceptCallView)
    }
    
    func setConstraints() {
        acceptCallView.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
//            } else {
                make.edges.equalToSuperview()
//            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Defaults().set(true, for: Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Defaults().clear(Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue))
        if !isAccepted {
            self.leaveCall()
        }
    }
    
    func addActions() {
        acceptCallView.downloadView.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(acceptCall))
        acceptCallView.downloadView.addGestureRecognizer(gestureRecogniser)
    }
    
    func navigationBarFunction() {
        self.navigationItem.title = "Accept Call"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.remoteTimer = timer
            self.remoteCounter += 1
                if self.remoteCounter == 30 {
                    DispatchQueue.main.async {
                        self.isAccepted = false
                        self.leaveCall()
                        self.dismiss(animated: true)
                    }
                }
        }
    }
    
    fileprivate func leaveCall() {
        player?.stop()
        Defaults().clear(Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue))
        Defaults().set(false, for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callIMEI.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callName.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callAppToken.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callAppId.rawValue))
        self.remoteTimer?.invalidate()
        self.remoteTimer = nil
    }
    
    @objc func acceptCall() {
        isAccepted = true
        player?.stop()
        RCLocalAPIManager.shared.getCallToken(deviceImei: callImei, success: { response in
            let appId:String = response.app_id
            let token:String = response.token
            Defaults().set(appId, for: Key<String>(defaultKeyNames.callAppId.rawValue))
            Defaults().set(token, for: Key<String>(defaultKeyNames.callAppToken.rawValue))
            self.dismiss(animated: true, completion: {
                Defaults().clear(Key<Bool>(defaultKeyNames.acceptScreenShown.rawValue))
                let vc = VoiceCallVC()
                UIApplication.topViewController()?.present(vc, animated: true)
            })
//            self.navigationController?.present(vc, animated: true)
        }, failure: { error in
            
            self.prompt("Request failed, Please try again")
        })
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func playSound() {
        let resourceValue = "agora_call"
        let resourceExtValue = "mp3"
        
        guard let url = Bundle.main.url(forResource: resourceValue, withExtension: resourceExtValue) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            print("playing.......")
            guard let player = player else {
                dismiss(animated: true, completion: nil)
                print("dismiss called")
                return
            }
            player.numberOfLoops = 20
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

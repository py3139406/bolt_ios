//
//  VoiceCallVC.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit
import AgoraRtcKit
import DefaultsKit

class VoiceCallVC: UIViewController {
    var voiceCallView:VoiceCallView!
//    var localView: UIView!
//    var remoteView: UIView!
    var agoraKit: AgoraRtcEngineKit?
    let appId:String = Defaults().get(for: Key<String>(defaultKeyNames.callAppId.rawValue)) ?? ""
    let appToken:String = Defaults().get(for: Key<String>(defaultKeyNames.callAppToken.rawValue)) ?? ""
    let callImei:String = Defaults().get(for: Key<String>(defaultKeyNames.callIMEI.rawValue)) ?? ""
    let callName:String = Defaults().get(for: Key<String>(defaultKeyNames.callName.rawValue)) ?? ""
    var seconds = 0
    var remoteCounter = 0
    var timer:Timer?
    var remoteTimer:Timer?
    var isRemoteUserJoinFail:Bool = true
    var progress: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initializeAndJoinChannel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        remoteView.frame = self.view.bounds
//        localView.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 90, height: 160)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        handleCallEnd()
    }
    
    func handleCallEnd() {
        Defaults().set(false, for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callIMEI.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callName.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callAppToken.rawValue))
        Defaults().clear(Key<String>(defaultKeyNames.callAppId.rawValue))
        self.timer?.invalidate()
        self.remoteTimer?.invalidate()
        agoraKit?.leaveChannel(nil)
        AgoraRtcEngineKit.destroy()
    }
    
    func initView() {
//        remoteView = UIView()
//        self.view.addSubview(remoteView)
//        localView = UIView()
//        self.view.addSubview(localView)
        
            voiceCallView = VoiceCallView()
            view.addSubview(voiceCallView)
        
        voiceCallView.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
//            } else {
                make.edges.equalToSuperview()
//            }
        }
        
        voiceCallView.downloadView.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(leaveCall))
        voiceCallView.downloadView.addGestureRecognizer(gestureRecogniser)
        
        voiceCallView.labelNewBooking.text = callName
    }
    
    @objc func leaveCall() {
        handleCallEnd()
        self.dismiss(animated: true)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i.%02i", hours, minutes, seconds)
    }
    
    func initializeAndJoinChannel() {
        // Pass in your App ID here
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        // Video is disabled by default. You need to call enableVideo to start a video stream.
//        agoraKit?.enableVideo()
        // Create a videoCanvas to render the local video
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = 0
//        videoCanvas.renderMode = .hidden
//        videoCanvas.view = localView
//        agoraKit?.setupLocalVideo(videoCanvas)
        
        agoraKit?.enableAudio()
        
        // Join the channel with a token. Pass in your token and channel name here
        // MARK :- Default token can be nil
        // ID hardcoded for testing purpose.
        
//        agoraKit.join
        
        let mediaOptions: AgoraRtcChannelMediaOptions = AgoraRtcChannelMediaOptions()
        mediaOptions.autoSubscribeAudio = true
        mediaOptions.clientRoleType = AgoraClientRole.broadcaster
        mediaOptions.audioDelayMs = 0
        
        agoraKit?.joinChannel(byToken: appToken, channelId: callImei, uid: 0, mediaOptions: mediaOptions, joinSuccess: { (channel, uid, elapsed) in
            Defaults().set(true, for: Key<Bool>(defaultKeyNames.ongoingCall.rawValue))
            self.showProgress(message: "Checking status...")
            self.startTimer()
        })
        
        
//        agoraKit?.joinChannel(byToken: appToken, channelId: callImei, info: nil, uid: 0, joinSuccess: { (channel, uid, elapsed) in
//            self.view.makeToast("Channel joined successfully")
//        })
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timer = timer
            if !self.isRemoteUserJoinFail {
                self.hideProgress()
                self.seconds += 1
                DispatchQueue.main.async {
                    self.voiceCallView.labelTimer.text = self.timeString(time: TimeInterval(self.seconds))
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.remoteTimer = timer
            self.remoteCounter += 1
            if self.isRemoteUserJoinFail {
                if self.remoteCounter == 4 {
                    self.hideProgress()
                    DispatchQueue.main.async {
                        UIApplication.shared.keyWindow?.makeToast("Unable to connect call.".toLocalize, duration: 2.0, position: .bottom)
                        self.leaveCall()
                    }
                }
            } else {
                self.hideProgress()
                self.view.makeToast("Channel joined successfully")
                timer.invalidate()
            }
        }
    }
    
    func showProgress(message:String) {
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = message.toLocalize
    }
    
    func hideProgress() {
        progress?.hide(true)
    }
    
}

extension VoiceCallVC: AgoraRtcEngineDelegate {
    // This callback is triggered when a remote user joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        isRemoteUserJoinFail = false
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("Remote offline.")
        leaveCall()
    }
    
}

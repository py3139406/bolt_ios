//
//  LiveStreamingShowVC.swift
//  Bolt
//
//  Created by Roadcast on 14/08/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import UIKit
import IJKMediaFramework
import DefaultsKit
import ReplayKit

class LiveStreamingShowVC: UIViewController {
    var player:IJKFFMoviePlayerController!
    
    var lsDeviceimeiNumber: String = ""
    var lsDevicedeviceId = 0
    var lsDevicename = ""
    var isBoltCam:Bool = false
    var isPlaying:Bool = false
    
    let urls = ["http://boltcam.roadcast.co.in:3333/video/053810567010-1",
                "http://boltcam.roadcast.co.in:3333/video/053810567010-2"]
    
    var videoView: UIView!
    
    var progress: MBProgressHUD?
    
    var recordButton: UIButton = UIButton(frame: CGRect.zero)
    
//    var recordView:UIView = UIView(frame: CGRect.zero)
    var recordLabel:UIButton = UIButton(frame: CGRect.zero)
    var recordImage:UIImageView = UIImageView(frame: CGRect.zero)
    var isRecordingStarted:Bool = false
    var seconds = 0
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i.%02i", hours, minutes, seconds)
    }
    
    fileprivate func play(_ url: URL) {
        showProgress(message: "Preparing Stream, Please wait...")
        let start = DispatchTime.now() + 45
        DispatchQueue.main.asyncAfter(deadline: start){
            if(!self.isPlaying) {
                self.hideProgress()
                self.prompt("Unable to load stream.")
            }
        }
        let options = IJKFFOptions.byDefault()
        
        //初始化播放器，播放在线视频或直播（RTMP）
        let player = IJKFFMoviePlayerController(contentURL: url, with: options)
        //播放页面视图宽高自适应
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player?.setFormatOptionIntValue(1, forKey: "dns_cache_clear")
        player?.view.frame = self.videoView.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.videoView.autoresizesSubviews = true
        self.videoView.addSubview((player?.view)!)
        self.player = player
        
        self.player.shouldShowHudView = false
        self.player.prepareToPlay()
        self.player.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //视频源地址
        self.view.backgroundColor = .white
        recordButton.setImage(UIImage(named: "ic_record_stop"), for: .normal)
        recordButton.setImage(UIImage(named: "ic_record_stop_new"), for: .selected)
        view.addSubview(recordButton)
        
//        recordView.isHidden = true
//        view.addSubview(recordView)
        
//        recordLabel.setImage(UIImage(named: "ic_record_start"), for: .normal)
        recordLabel.setTitle("00:00:00", for: .normal)
        recordLabel.isHidden = true
        recordLabel.setTitleColor(UIColor.red, for: .normal)
//        recordLabel.text = "00:00:00"
//        recordLabel.textColor = UIColor.red
//        recordLabel.textAlignment = .right
//        recordLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 10)
//        recordLabel.layer.zPosition = 1
//        recordLabel.isUserInteractionEnabled = true
        view.addSubview(recordLabel)
        
        recordImage.image = UIImage(named: "ic_record_start")
        recordImage.isUserInteractionEnabled = true
        recordImage.layer.zPosition = 1
        view.addSubview(recordImage)
        
        videoView = UIView()//(frame: CGRect(x: 0, y: 200, width: view.frame.size.width, height: 400))
        view.addSubview(videoView)
        addNavigationBar()
        setConstraints()
        addNotificationObserver()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "flip-5")?.resizedImage(CGSize(width: 30, height: 30), interpolationQuality: .default), style: .plain, target: self, action: #selector(flipCamera))
        //  self.player.loadState = IJKMPMovieLoadState
        var url = URL(string: "https://boltcam.roadcast.co.in/live?port=1935&app=small&stream=\(lsDeviceimeiNumber)")!
        if (isBoltCam) {
            let cameraSide:String = Defaults().get(for: Key<String>(defaultKeyNames.streamingCamera.rawValue)) ?? streamCamera.inside.rawValue
            url = URL(string: "http://boltcam.roadcast.co.in:3333/video/\(lsDeviceimeiNumber)-\(cameraSide)")!
        }
        play(url)
        
        recordButton.addTarget(self, action: #selector(handleRecording(_:)), for: .touchUpInside)
    }
    
    func recordStartView() {
        recordButton.isSelected = true
        recordLabel.isHidden = false
        isRecordingStarted = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            
            if !self.isRecordingStarted {
                timer.invalidate()
                self.recordStopView()
            } else {
                self.seconds += 1
                DispatchQueue.main.async {
                    self.recordLabel.setTitle(self.timeString(time: TimeInterval(self.seconds)), for: .normal)
                }
            }
        }
    }
    
    @objc func handleRecording(_ sender: UIButton) {
        if sender.isSelected {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    func stopRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.stopRecording { (preview,error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                if let unwrappedPreview = preview {
                    self.isRecordingStarted = false
                    unwrappedPreview.previewControllerDelegate = self
                    self.present(unwrappedPreview, animated: true, completion: nil)
                }
            }
        }
    }
    
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = true
        recorder.startRecording { (error) in
            if let unwrappedError = error {
//                print(unwrappedError.localizedDescription)
                self.prompt(unwrappedError.localizedDescription)
            } else {
                self.recordStartView()
            }
        }
    }
    
    func recordStopView() {
        recordButton.isSelected = false
        recordLabel.setTitle("00:00:00", for: .normal)
        recordLabel.isHidden = true
    }
    
    private func setConstraints(){
        videoView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        recordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
            make.width.height.equalTo(50)
        }
//        recordView.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(-10)
//            make.top.equalToSuperview().offset(20)
//            make.width.equalToSuperview()
//            make.height.equalTo(40)
//        }
//        recordImage.snp.makeConstraints {(make) in
//            make.top.equalToSuperview().offset(20)
//            make.right.equalToSuperview()
//            make.width.height.equalTo(30)
//        }
        recordLabel.snp.makeConstraints {(make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(recordButton.snp.bottom)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    private func addNavigationBar() {
        self.navigationItem.title = "\(!lsDevicename.isEmpty ? lsDevicename : "Live Streaming")"
        self.navigationController?.navigationBar.tintColor = appGreenTheme
        self.navigationController?.navigationBar.backgroundColor = .white
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    func  addNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playBackIsPrepareToPlay), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerPlaybackStateDidChange), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: nil)
    }
    @objc func loadStateDidChange(){
        print("loadStateDidChange")
    }
    @objc func playBackIsPrepareToPlay(){
        isPlaying = true;
        let start = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: start){
            self.hideProgress()
        }
        
        print("playBackIsPrepareToPlay")
    }
    @objc func playerPlaybackStateDidChange(){
        print("playerPlaybackStateDidChange")
    }
    @objc func flipCamera() {
        let oldStatus:String = Defaults().get(for: Key<String>(defaultKeyNames.streamingCamera.rawValue)) ?? streamCamera.inside.rawValue
        
        var newStatus:String = streamCamera.inside.rawValue
        
        if oldStatus == streamCamera.inside.rawValue{
            newStatus = streamCamera.outside.rawValue
        }
        
        if isBoltCam {
            self.stopPlayer()
//            sendCommand(parameters: RCGlobals.getStreamingData(deviceId: lsDevicedeviceId, camera: oldStatus, streamState: streamStatus.stop.rawValue), isStart: false,status: newStatus)
            var url = URL(string: "http://boltcam.roadcast.co.in:3333/video/\(self.lsDeviceimeiNumber)-\(newStatus)")!
            self.play(url)
        } else {
            sendCommand(parameters: RCGlobals.getStreamingData(deviceId: lsDevicedeviceId, camera: oldStatus, streamState: streamStatus.stop.rawValue), isStart: false,status: newStatus)
        }
    }
    
    func sendCommand(parameters: [String:Any], isStart: Bool, status: String) {
        
        RCLocalAPIManager.shared.liveStreaming(loadingMsg: "Loading...", deviceID: lsDevicedeviceId, parameters: parameters, success: { (success) in
            if isStart {
                self.isPlaying = false
                Defaults().set(status, for: Key<String>(defaultKeyNames.streamingCamera.rawValue))
                var url = URL(string: "https://boltcam.roadcast.co.in/live?port=1935&app=small&stream=\(self.lsDeviceimeiNumber)")!
                if (self.isBoltCam) {
                    url = URL(string: "http://boltcam.roadcast.co.in:3333/video/\(self.lsDeviceimeiNumber)-\(status)")!
                }
                self.play(url)
            } else {
                self.showProgress(message: "Loading...")
                let start = DispatchTime.now() + 2
                
//                self.player.stop()
                DispatchQueue.main.asyncAfter(deadline: start){
                    self.hideProgress()
                    self.sendCommand(parameters: RCGlobals.getStreamingData(deviceId: self.lsDevicedeviceId, camera: status, streamState: streamStatus.start.rawValue), isStart: true,status: status)
                }
            }
            print("device streaming success")
            
        }) { (err ) in
            
            print("device streaming failure")
            
        }
        
    }
    
    func stopPlayer() {
        for subview in self.videoView.subviews {
            subview.removeFromSuperview()
        }
        if (self.player.isPlaying() || self.player.isPreparedToPlay) {
            self.player.stop()
        }
        self.player.shutdown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //开始播放
        self.player.prepareToPlay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopPlayer()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        //关闭播放器
//        stopPlayer()
//    }
    
    func showProgress(message:String) {
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = message
    }
    
    func hideProgress() {
        progress?.hide(true)
    }
}

extension LiveStreamingShowVC : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
    }
}

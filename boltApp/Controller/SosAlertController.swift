//
//  SosAlertController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import AudioToolbox
import AVFAudio
import AVFoundation

 var player: AVAudioPlayer?
class SosAlertController: UIViewController {

    var sosView : SosView!
    var alertType: String = ""
    var deviceName: String = ""
  //  var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Defaults().has(Key<String>("AlertPopWindow")) {
            alertType = Defaults().get(for: Key<String>("AlertPopWindow")) ?? "sos"
        }
        textInSOSAlert()
        playSound()
        sosView.dismissBtn.addTarget(self, action: #selector(dismissBtnAction(_sender:)), for: .touchUpInside)
        
    }
    
    @objc func dismissBtnAction(_sender : UIButton){                                                                                                                    
        if player != nil && ((player?.isPlaying) != nil){
            player?.stop()
        }
//        if alertType != "spymode" {
            Defaults().clear(Key<String>("AlertPopWindow"))
            Defaults().clear(Key<String>("deviceName"))
//        }
        dismiss(animated: true, completion: nil)
    }
    
    func textInSOSAlert() {
        if Defaults().has(Key<String>("deviceName")) {
            deviceName = Defaults().get(for: Key<String>("deviceName")) ?? "Test"
        }
        sosView = SosView(frame: view.bounds)
        if alertType == "sos" {
            sosView.headingLabel.text = "Help! SOS Alert".toLocalize
            sosView.firstLabel.text = "SOS button in vehicle \'\(deviceName)\' has been pressed. Immediate attention required".toLocalize
            sosView.imageView.image = #imageLiteral(resourceName: "sosImage")
        }
        if alertType == "CutOff" {
            sosView.headingLabel.text = "Power cut".toLocalize
            sosView.firstLabel.text = "Someone has removed your vehicle\'s \'\(deviceName)\' battery or unplugged your device".toLocalize
            sosView.imageView.image = #imageLiteral(resourceName: "powercutpopup")
        }
        if alertType == "spymode" {
            sosView.headingLabel.text = "Attention".toLocalize
            sosView.firstLabel.text = "Your vehicle \'\(deviceName)\' is in danger.".toLocalize
            sosView.imageView.image = #imageLiteral(resourceName: "spymodealert")
        }else{
            sosView.headingLabel.text = "Attention".toLocalize
            sosView.firstLabel.text = "Your vehicle \'\(deviceName)\' is in danger.".toLocalize
            sosView.imageView.image = #imageLiteral(resourceName: "spymodealert")
        }
        view.addSubview(sosView)
    }
    
    
    func playSound() {
        var resourceValue = ""
        var resourceExtValue = ""
        
        if alertType == "CutOff" {
            resourceValue = "cutOffAlert"
            resourceExtValue = "wav"
        }
        if alertType == "sos" {
            resourceValue = "sos_sound"
            resourceExtValue = "mp3"
        }
        if alertType == "spymode" {
            resourceValue = "spyModeAlert"
            resourceExtValue = "wav"
        }
        
        guard let url = Bundle.main.url(forResource: resourceValue, withExtension: resourceExtValue) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            if alertType == "CutOff" {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            }
            
            if alertType == "sos" {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            }
            
            if alertType == "spymode" {
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            }
            
           
//            timer  = Timer(timeInterval: 60, repeats: true, block: { _ in
//                guard let player = player else {
//                    self.dismiss(animated: true, completion: nil)
//                    self.timer.invalidate()
//                    if player != nil && ((player?.isPlaying) != nil){
//                        player?.stop()
//                    }
//                    print("dismiss called....")
//                    return
//                }
//                player.play()
//                print("playing again...")
//            })
            // iOS 10 and earlier require the following line:
            //            @available(iOS 10.0, *)
            //            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            
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

//
//  AddScannerViewController.swift
//  Bolt
//
//  Created by Shanky on 17/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import AVFoundation

class AddScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var line = UIView()
    var optionType:String?
    var imeiField:UITextField!
    var codeField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appDarkTheme
        captureSession = AVCaptureSession()
        
        line.backgroundColor = .green

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            switch optionType {
            case "codeScn":
                metadataOutput.metadataObjectTypes = [.qr,.ean13, .ean8,.code128]
            case "imeiScn":
                metadataOutput.metadataObjectTypes = [.ean13, .ean8,.code128 ]
            default:
                break
            }
       
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: screensize.height * 0.3, width: screensize.width, height:  screensize.height * 0.3)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        line.frame = CGRect(x: 0, y: screensize.height * 0.3, width: screensize.width, height:1)
        view.addSubview(line)
        captureSession.startRunning()
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
             self.line.transform = CGAffineTransform(translationX: 0, y: screensize.height * 0.3)
        }, completion: nil)
    }
    @objc func backTapped() {
         self.dismiss(animated: true, completion: nil)
     }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
            self.line.layer.removeAllAnimations()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            let dataType = readableObject.type.rawValue
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue , typeOf:dataType )
    }
    }
    
    func found(code: String , typeOf:String) {
        switch optionType {
        case "codeScn":
            codeField.text = code
        case "imeiScn":
            imeiField.text = code
        default:
            break
        }
        self.navigationController?.popViewController(animated: true)
                
                
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}


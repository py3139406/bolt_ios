//
//  DeviceScanQRVC.swift
//  Bolt
//
//  Created by Vishal Jain on 19/01/23.
//  Copyright © 2023 Arshad Ali. All rights reserved.
//

import UIKit

class DeviceScanQRVC: UIViewController {
    
    var deviceScanView:DeviceQRScanView!
    var device:TrackerDevicesMapperModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarFunction()
        addViews()
        setConstraints()
        addActions()
        generateQR()
    }
    
    func generateQR() {
        // 1
        let myString = "https://bolt-voice.web.app/?voice=\(device?.uniqueId ?? "")"
        // 2
        let data = myString.data(using: String.Encoding.ascii)
        // 3
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // 4
        qrFilter.setValue(data, forKey: "inputMessage")
        // 5
        guard let qrImage = qrFilter.outputImage else { return }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        deviceScanView.qrImageView.image = UIImage(ciImage: scaledQrImage)
    }
    
    func addViews() {
        deviceScanView = DeviceQRScanView()
        view.addSubview(deviceScanView)
    }
    
    func setConstraints() {
        deviceScanView.snp.makeConstraints { (make) in
//            if #available(iOS 11.0, *) {
//                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
//            } else {
                make.edges.equalToSuperview()
//            }
        }
    }
    
    func addActions() {
        deviceScanView.downloadView.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(takeScreenShot))
        deviceScanView.downloadView.addGestureRecognizer(gestureRecogniser)
        deviceScanView.downloadButton.addTarget(self, action: #selector(takeScreenShot), for: .touchUpInside)
    }
    
    @objc func takeScreenShot() {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: deviceScanView.bounds.width, height: deviceScanView.bounds.height),
            false,
            2
        )
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(imageWasSaved), nil)
    }
    
    @objc func imageWasSaved(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        self.prompt("Download successfully.")
        
        print("Image was saved in the photo gallery")
        //          UIApplication.shared.open(URL(string:"photos-redirect://")!)
    }
    
    func navigationBarFunction() {
        self.navigationItem.title = "\(device?.name ?? "QR View")"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
    }
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

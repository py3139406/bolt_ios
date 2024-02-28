//
//  ShareLocPopVC.swift
//  Bolt
//
//  Created by Roadcast on 05/11/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
import DefaultsKit
import KeychainAccess

class ShareLocPopVC: UIViewController {
    var sharePopView:ShareLocPopView!
    var deviceId:Int?
    var device:TrackerDevicesMapperModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        addViews()
        setConstraints()
        setActions()
        let keyValue = "Device_" + "\(deviceId ?? 0)"
        device = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        sharePopView.titleLabel.text = "Share \(device?.name ?? "device location")"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != sharePopView{
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func addViews(){
        sharePopView = ShareLocPopView()
        sharePopView.layer.cornerRadius = 5
        sharePopView.layer.masksToBounds = true
        view.addSubview(sharePopView)
    }
    private func setConstraints(){
        sharePopView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalToSuperview().multipliedBy(0.3)
            make.center.equalToSuperview()
        }
        
    }
    
    private func setActions() {
        sharePopView.textField.delegate = self
        sharePopView.cancelBtn.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        sharePopView.shareBtn.addTarget(self, action: #selector(shareLocationTapped), for: .touchUpInside)
        
//        sharePopView.currentBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentLocationTap(sender:))))
//        sharePopView.liveBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(liveLocationTap(sender:))))
        
        sharePopView.currentBtn.addTarget(self, action: #selector(currentLocationTap(sender:)), for: .touchUpInside)
        sharePopView.liveBtn.addTarget(self, action: #selector(liveLocationTap(sender:)), for: .touchUpInside)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareLocationTapped() {
        let posValuePair = "Position_" + "\(deviceId ?? 0)"
        let position = Defaults().get(for: Key<TrackerPositionMapperModel>(posValuePair))
        if sharePopView.currentBtn.isSelected == true {
            let date = RCGlobals.getDateFor(device?.lastUpdate ?? "") as Date
            let msg:String = "Vehicle Name - \(device?.name ?? "")\n"
                + "Location - \(position?.address ?? "")\n"
                + "Date - \(RCGlobals.convertDateToString(date: date, format: "dd MMM yyyy hh:mm a", toUTC: false))\n"
                + "Map - https://www.google.com/maps/search/?api=1&query=\(position?.latitude ?? 0),\(position?.longitude ?? 0)\n"
                + "-Sent via: BOLT app"
            
            let shareLink:[Any] = [NSLocalizedString(msg, comment: "Sent via: BOLT app")]
            
            let shareVC = UIActivityViewController(activityItems:shareLink, applicationActivities: nil)
            shareVC.excludedActivityTypes = [.assignToContact,.print, .postToVimeo]
            // here is the changes for ipad -->
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popOver = shareVC.popoverPresentationController {
                  popOver.sourceView = self.view
                    popOver.sourceRect = CGRect(origin: CGPoint(x: 0,y: (screensize.height - 200)), size: CGSize(width: screensize.width, height: 200))
                    popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                }
            }
                present(shareVC, animated: true, completion:nil)
            //<--
            shareVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                self.cancelTapped()
            }
        } else if sharePopView.liveBtn.isSelected == true {
            if sharePopView.textField.text!.isEmpty {
                self.view.makeToast("Please enter valid time", duration: 0.5, position: ToastPosition.bottom)
            } else {
                  shareLiveLocation()
            }
        } else {
            print("Do Nothing")
        }
    }
    
    @objc func currentLocationTap(sender:RadioButton) {
        sharePopView.liveBtn.isSelected = false
        sharePopView.currentBtn.isSelected = true
        sharePopView.textLabel.isHidden = true
        sharePopView.textField.isHidden = true
    }
    
    @objc func liveLocationTap(sender:RadioButton) {
        sharePopView.liveBtn.isSelected = true
        sharePopView.currentBtn.isSelected = false
        sharePopView.textLabel.isHidden = false
        sharePopView.textField.isHidden = false
    }
    
    private func shareLiveLocation () {
        let locationTime:String = sharePopView.textField.text ?? "1"
        
        let timeInterval:Double = Double(locationTime) ?? 0.0
        let dateValue:Date = Date().addingTimeInterval(timeInterval * 3600)
        let validTill = RCGlobals.convertDateToString(date: dateValue, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toUTC: true)
        let parameters:[String:Any] = [
            "valid_till":validTill,
            "device_id": deviceId ?? 0,
            "device_name": device?.name ?? "",
            "category": device?.category ?? ""
        ]
        
        RCLocalAPIManager.shared.getShareURL(with: parameters, success:  { hash in
            self.generateLink(hash)
        }) { message in
            UIApplication.shared.keyWindow?.makeToast("Request failed, Please try again.", duration: 1.0, position: .bottom)
        }
        
    }
    
    private func generateLink(_ uniqueId: String) {
        let keychain = Keychain(service: "in.roadcast.bolt")
        let SparkGPStoken = try? keychain.getString("boltToken") ?? ""
        let updatedToken = (SparkGPStoken ?? "").replacingOccurrences(of: " ", with: "%20")
        
        let name:String = "\(device?.name ?? "")"
        
        let updatedName:String = name.replacingOccurrences(of: " ", with: "%20")
        
        let msg:String = "\(RCRouter.multipleShareURL)" + "\(uniqueId)" +
            "&value=\(deviceId ?? 0)" +
            "&au=\(updatedToken)" + "&name=\(updatedName)"

        let shareLink:[Any] = [NSLocalizedString(msg, comment: "Please choose app")]
        
        let shareVC = UIActivityViewController(activityItems:shareLink, applicationActivities: nil)
        shareVC.excludedActivityTypes = [.assignToContact,.print, .postToVimeo]
        present(shareVC, animated: true, completion:nil)
        
        shareVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            self.cancelTapped()
        }
        
    }
}
extension ShareLocPopVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                if textField == sharePopView.textField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

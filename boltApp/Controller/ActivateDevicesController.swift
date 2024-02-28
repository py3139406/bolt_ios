//
//  ActivateDevicesController.swift
//  boltApp
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit

//class ActivateDevicesController: UIViewController {
//
//    var activateView : ActivateDevicesView!
//    var data: DeviceDetails?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        activateView = ActivateDevicesView(frame: view.frame)
//        view.addSubview(activateView)
//        view.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1)
//        activateView.activateButton.isUserInteractionEnabled = true
//        activateView.activateButton.addTarget(self, action: #selector(activateButtonClicked(sender:)), for: .touchUpInside)
//    }
//
//    @objc func activateButtonClicked(sender: UIButton) {
//        if (activateView.firstCheckBox.isChecked && activateView.secondCheckBox.isChecked && activateView.thirdCheckBox.isChecked) {
//
//            let userId = (Defaults().get(for: Key<SessionResponseModel>("SessionResponseModel")))?.id
//            let attributes = ["countryCode":"91", "vibrationAlert": "0", "overspeedAlert": "0", "overspeedValue": "0", "centerNumber": "", "alertNumber": ""]
//
//            RCLocalAPIManager.shared.addDevice(with: (data?.deviceIMEI)!, name: (data?.vehicleName)!, phone: (data?.deviceMobileNo)!, attributes: attributes, fitterName: (data?.fitterName)!, category: (data?.type)!, userId: userId!, success: { [weak self] hash in
//                guard let weakSelf = self else { return }
//                OperationQueue.main.addOperation {
//                    let closureHandler1 = { (action:UIAlertAction!) -> Void in
//                        weakSelf.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: {})
//                    }
//                    weakSelf.prompt("Message".toLocalize, "Device has been added successfully.".toLocalize, "OKAY".toLocalize, handler1: closureHandler1)
//                }
//
//            }) { [weak self] message in
//                guard let weakSelf = self else { return }
//                weakSelf.prompt("It seems the tracker is already added")
//            }
//
//
//        }else {
//            self.showalert("All fields are required".toLocalize)
//        }
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}

struct DeviceDetails {
    var vehicleName = ""
    var deviceMobileNo = ""
    var deviceIMEI = ""
    var fitterName = ""
    var type = ""
}

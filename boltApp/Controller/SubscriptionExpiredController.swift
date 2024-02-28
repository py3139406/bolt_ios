//
//  SubscriptionExpiredController.swift
//  Bolt
//
//  Created by Vishesh on 5/16/19.
//  Copyright © 2019 Arshad Ali. All rights reserved.
//

import Foundation
import UIKit

extension SubscriptionExpired {
    
    @objc func liveChatButtonTapped(_ sender : Any) {
        print("Extend subscription tapped")
        
//        let tag = "Inbox"
//        let message = "I want to renew my subscription"
//        let freshchatMessage = FreshchatMessage.init(message: message, andTag: tag)
//        Freshchat.sharedInstance().send(freshchatMessage)
//        Freshchat.sharedInstance().showConversations(self)
        
        let deviceArray:[String] =   UserDefaults.standard.stringArray(forKey: "expiredDeviceIds") ?? []
        let vc = SubscriptiomMainVC()
        var ais:[String] = []
        var norm:[String] = []
        if deviceArray.count > 0 {
            
            for map in deviceArray{
                if (RCGlobals.isAISDevice(deviceId: Int(map) ?? 0)) {
                    ais.append(map)

                } else {
                    norm.append(map)

                }
                
            }
            vc.selectedAISDeviceArray = ais
            vc.selectedNormalDeviceArray = norm
        }

        
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.backgroundColor = .white
        navController.navigationBar.tintColor = appGreenTheme
        self.present(navController, animated: false, completion: nil)
        
    }
    
    @objc func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onCompletion?(true)
        }
    }
    
}

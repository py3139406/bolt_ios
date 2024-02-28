//
//  FolloweShareViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import SnapKit
import DefaultsKit
import Firebase
import SwiftMessages

class FolloweShareViewController: UIViewController {
    
    var followerShareView: FollowerShareView!
    var rcChatViewController : RCShareConnectChatViewController!
    var rcChatView: UIView!
    var followerMapVC : FollowerMapViewController!
    var followerMapView:UIView!
    private var shareFollowers : [AnyObject] = []
    private var userReference : DatabaseReference!
    var followerToken: String!
    private var loginUser : LoginResponseModel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
        setViews()
        setconstraints()
        
        followerShareView.segmentedController.addTarget(self, action: #selector((self.segmentTapped)), for: .valueChanged)
        followerShareView.closeButton.addTarget(self, action: #selector(stopFollowingTapped), for: .touchUpInside)
        followerShareView.backButton.isHidden = true

        followerToken = Defaults().get(for: Key<String>("ShareVehicleFollowerPin")) ?? ""
        userReference = Database.database().reference().child("bolt/rooms/\(followerToken ?? "")/users")
        
        loginUser = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))

    }
    func setViews(){
        followerShareView = FollowerShareView()
        view.addSubview(followerShareView)
        
        rcChatViewController = RCShareConnectChatViewController()
        rcChatView = rcChatViewController.view
        rcChatView.isHidden = true
        view.addSubview(rcChatView)
        
        followerMapVC = FollowerMapViewController()
        followerMapView = followerMapVC.view
        followerMapView.isHidden = false
        followerMapVC.geoFenceMapView.mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 20)
        view.addSubview(followerMapView)
    }
    func setconstraints(){
        followerShareView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.20)
        }
        rcChatView.snp.makeConstraints { (make) in
            make.top.equalTo(followerShareView.snp.bottom)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        followerMapView.snp.makeConstraints { (make) in
            make.top.equalTo(followerShareView.snp.bottom)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    

    @objc func backTapped() {
        isViaShareChatBackPressed = true
        dismiss(animated: true, completion: {})
    }
    
    @objc func stopFollowingTapped() {
        self.prompt("Sharing Vehicle".toLocalize, "Do you want to stop sharing?".toLocalize, "Okay".toLocalize, "Cancel".toLocalize, handler1: { [self] (_) in
            SwiftMessages.hideAll()
            let userID = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
            Database.database().reference().child("bolt/rooms/\(Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? "test")/users/\(userID)").removeValue()
            Defaults().set("", for: Key<String>("ShareVehicleRandomPin"))
            Defaults().clear(Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
            Defaults().clear(Key<String>("ShareVehicleName"))
            Defaults().clear(Key<String>("ShareVehicleFollowerPin"))
            let userRoot : DatabaseReference = self.userReference.child("\(loginUser.data?.id ?? "0")")
            userRoot.removeValue()
            self.dismiss(animated: true) {
                UIApplication.shared.keyWindow?.rootViewController = ViewController()
            }
        }, handler2: {_ in })
    }
    
    @objc func segmentTapped(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            rcChatView.isHidden = false
            followerMapView.isHidden = true
        case 1:
           rcChatView.isHidden = true
           followerMapView.isHidden = false
        default:
            print("ERROR")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

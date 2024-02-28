//
//  LeaderShareViewController.swift
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

let screenSize = UIScreen.main.bounds.size
class LeaderShareViewController:UIViewController {
    
    var rcChatViewController : RCShareConnectChatViewController!
    var rcChatView :  UIView!
    private var usersReference : DatabaseReference!
    private var chatToken : String?
    private var shareFollowers : [AnyObject] = []
    var shareLeaderView: LeaderShareView!
    var shareByLeader: LeaderShareFollowerSegmentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setActions()
    }
    func setActions(){
        chatToken = Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? ""
        usersReference = Database.database().reference().child("bolt/rooms/\(chatToken ?? "")/users")
        observeUsers()
        shareByLeader.addFollowerButton.addTarget(self, action: #selector(addFollowerAction(sender:)), for: .touchUpInside) 
        shareLeaderView.segmentedController.addTarget(self, action: #selector((segmentTapped)), for: .valueChanged)
        shareByLeader.tableView.delegate = self
        shareByLeader.tableView.dataSource = self
        shareLeaderView.closeButton.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        shareLeaderView.backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        shareByLeader.tableView.register(ShareLeaderFollowerTableViewCell.self, forCellReuseIdentifier: "Share")
    }
    func setConstraints(){
        shareLeaderView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                make.top.equalToSuperview().offset(20)
            }
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        shareByLeader.snp.makeConstraints { (make) in
            make.top.equalTo(shareLeaderView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        rcChatView.snp.makeConstraints { (make) in
            make.top.equalTo(shareLeaderView.snp.bottom).offset(10)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    func setViews(){
        view.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
        shareLeaderView = LeaderShareView()
        shareByLeader = LeaderShareFollowerSegmentView()
        rcChatViewController = RCShareConnectChatViewController()
        rcChatView = rcChatViewController.view
        rcChatView.backgroundColor = .white
        
        view.addSubview(shareLeaderView)
        view.addSubview(shareByLeader)
        view.addSubview(rcChatView)
        rcChatView.isHidden = false
        shareByLeader.isHidden = true
    }
    @objc func backTapped() {
        isViaShareChatBackPressed = true
        let newVC = ViewController()
        self.definesPresentationContext = true
        newVC.modalPresentationStyle = .custom
        self.present(newVC, animated: true, completion: nil)
    }
    
    @objc func stopTapped() {
        self.prompt("Sharing Vehicle".toLocalize, "Do you want to stop sharing?".toLocalize, "Okay".toLocalize, "Cancel".toLocalize, handler1: { (_) in
            SwiftMessages.hideAll()
            Database.database().reference().child("bolt/rooms/\(Defaults().get(for: Key<String>("ShareVehicleRandomPin")) ?? "test")/").removeValue()
            Defaults().set("", for: Key<String>("ShareVehicleRandomPin"))
            Defaults().clear(Key<TrackerDevicesMapperModel>("ShareVehicleDevicesModel"))
            Defaults().clear(Key<String>("ShareVehicleName"))
            self.dismiss(animated: true, completion: nil)
        }, handler2: {_ in })
        
    }
    
    @objc func segmentTapped(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            rcChatView.isHidden = false
            shareByLeader.isHidden = true
            
        case 1:
            rcChatView.isHidden = true
            shareByLeader.isHidden = false
        default:
            print("ERROR")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func addFollowerAction(sender:UIButton) {
        self.shareVehicleLocation()
        
    }
    
    func shareVehicleLocation() {
        
        let shareVehicleName = Defaults().get(for: Key<String>("ShareVehicleName")) ?? ""
        
        let shareLink: [Any] = [NSLocalizedString("View " + shareVehicleName + " location by opening this link \n", comment: "View my vehicle's location by opening this link")+" https://track.roadcast.co.in/share?id=\(String(describing: chatToken ?? ""))\n"+NSLocalizedString("Sent via: Mosfet", comment: "Sent via: Mosfet")]
        let shareVC = UIActivityViewController(activityItems:shareLink, applicationActivities: nil)
        shareVC.excludedActivityTypes = [.assignToContact,.print, .postToVimeo]
        // here is the changes for ipad -->
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popOver = shareVC.popoverPresentationController {
                popOver.sourceView = self.view
                popOver.sourceRect = CGRect(origin: CGPoint(x: 0,y: (screenSize.height - 200)), size: CGSize(width: screenSize.width, height: 200))
                popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }
        present(shareVC, animated: true, completion:nil)
        //<--
        
        shareVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
        }
        
        
    }
    
    private func observeUsers() -> Void {
        usersReference.observe(.childAdded, with: { [weak self] (snapshot) in
            if let response = snapshot.value as AnyObject? {
                guard let weakSelf = self else {
                    return
                }
                weakSelf.shareFollowers.append(response)
                weakSelf.shareByLeader.tableView.reloadData()
            }
            return
        })
        
        usersReference.observe(.childChanged, with: { [weak self] (snapshot) in
            if let response = snapshot.value as AnyObject? {
                guard let weakSelf = self else {
                    return
                }
                for (index, follower) in ((weakSelf.shareFollowers).enumerated()) {
                    if response["deviceId"] as! Int == follower["deviceId"]  as! Int {
                        weakSelf.shareFollowers.remove(at: index)
                        break
                    }
                }
                weakSelf.shareFollowers.append(response)
                weakSelf.shareByLeader.tableView.reloadData()
                //                self?.shareFollowers.first({ $0.deviceId == response.deviceId})?.added = response
            }
            return
        })
        
        usersReference.observe(.childRemoved, with: { [weak self] (snapshot) in
            if let response = snapshot.value as AnyObject? {
                guard let weakSelf = self else {
                    return
                }
                for (index, follower) in ((weakSelf.shareFollowers).enumerated()) {
                    if response["deviceId"] as! Int == follower["deviceId"]  as! Int {
                        weakSelf.shareFollowers.remove(at: index)
                        break
                    }
                }
                weakSelf.shareByLeader.tableView.reloadData()
            }
            return
        })
    }
    
}

extension LeaderShareViewController: UITableViewDelegate {
    
}

extension LeaderShareViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareFollowers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        shareByLeader.obj = tableView.dequeueReusableCell(withIdentifier: "Share", for: indexPath) as? ShareLeaderFollowerTableViewCell
        shareByLeader.obj.backgroundColor =  UIColor(red: 39/255, green: 38/255, blue: 57/255, alpha: 1.0)
        shareByLeader.obj.label.text = (shareFollowers[indexPath.row]["name"] as! String) + "  -  " + (shareFollowers[indexPath.row]["userType"] as! String)
        return shareByLeader.obj
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

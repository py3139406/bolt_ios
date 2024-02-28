//
//  ProfileViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import DefaultsKit
import SafariServices
import KeychainAccess
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let titles = ["Username".toLocalize,"Name".toLocalize, "Email".toLocalize,"Personal Verification".toLocalize,
                  "Reset Password".toLocalize, "List of Vehicles".toLocalize,
                  "Payment History".toLocalize]
    var profileView: ProfileView!
    let cellId = "PROFILECELLID"
    var allDevices : [TrackerDevicesMapperModel] = []
    var deviceCount:String?
    var username :String?
    var emailId :String?
    var usernamePhone: String?
    var imageURL:String = Defaults().get(for: Key<String>("profile_url")) ?? ""
    var imagView : UIImageView!
    var HUD: MBProgressHUD?
    var taskCounter:Int = 0
    var imagePicker: UIImagePickerController!
    let keychain = Keychain(service: "in.roadcast.bolt")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        addConstraints()
        setupData()
        callPaymentHistoryApi()
        addActions()
        
    }
    
    fileprivate func addActions() {
             profileView.deleteAccountBtn.addTarget(self, action: #selector(deleteAccount(_:)), for: .touchUpInside)
         }
         
     //    'https://prod-s2.track360.net.in/api/v1/auth/delete_user?user_id=87740
         @objc func deleteAccount(_ sender : UIButton) {
             
             self.prompt("Delete Account", "Are you sure?", "NO", "YES", handler1: { (_) in

             }) { (_) in
                 self.showProgress("Please wait...")
                 self.taskCounter = 0;
                 RCLocalAPIManager.shared.deleteUser(success: { success in
                     self.getTaskStatus()
                 }, failure: { failure in
                     self.hideProgress()
                     self.prompt("Request failed, Please try again.")
                 })
             }
         }
    
    
    func addConstraints(){
        profileView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
                // Fallback on earlier versions
            }
        }
    }
    private func getTaskStatus(){
                taskCounter += 1
                sleep(1)
                let task_id =  Defaults().get(for: Key<String>(defaultKeyNames.taskId.rawValue)) ?? ""
                RCLocalAPIManager.shared.getTaskStatusRequest(loadingMsg: "", taskId: task_id) { (success) in
                    if let state = success["state"] as? String {
                        if state == "PENDING"{
                            if self.taskCounter <= 10 {
                                self.getTaskStatus()
                            } else {
                                self.hideProgress()
                                self.prompt("Request failed, Please try again.")
                            }
                        } else {
                            self.hideProgress()
                            if let data = success["data"] as? [String: Any] {
                                if let status = data["status"] as? String {
                                    if status == "success"{
                                        self.prompt("Success", "Account deleted successfully.", "OK") { (_) in
                                            self.completeLogout()
                                        }
                                        
                                    } else {
                                        self.prompt("", "\(data["message"] as? String ?? "")", "OK") { (_) in
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                }
                            }
                        }
                    }

                } failure: { (message) in
                    print(message)
                    self.hideProgress()
                    self.prompt("Request failed, Please try again.")
                }

            }
            fileprivate func completeLogout() {
                DBManager.shared.deleteAllFromDatabase()
                
                do {
                    try keychain.remove("boltPassword")
                    try keychain.remove("boltToken")
                } catch let error { print("error: \(error)") }
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                Defaults().clear(Key<Bool>("isParkingBadgeVisible"))
                Defaults().clear(Key<Bool>("allNotifications"))
                Defaults().set("Map Screen",for: Key<String>("homescreenLabel"))
                

                RCSocketManager.shared.stopObserving()
                markers.removeAll()
                RCMapView.clearMap()
                
                Defaults().clear(Key<Bool>("isFirstTimeList"))
                
                RCGlobals.clearAllDefaults()
                
                self.view.window?.rootViewController = LoginViewController()
            }

    func callPaymentHistoryApi() {
        
        RCLocalAPIManager.shared.getPaymentHistory(success: { (success) in
            
            print("success in getting payment history")
            
        }) { (failure) in
            
            print("failure in getting payment History")
            
        }
    }
    func setupView() {
        profileView = ProfileView()
        view.addSubview(profileView)
        profileView.profileTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: cellId)
        profileView.profileTableView.delegate = self
        profileView.profileTableView.dataSource = self
        view.backgroundColor = .white
    }
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            let versionString = "v" + version
            let rightItem = UIBarButtonItem(title: versionString,
                                            style: UIBarButtonItemStyle.plain,
                                            target: nil,
                                            action: nil)
            
            rightItem.tintColor = appGreenTheme
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }
    func setupData() {
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue))
        allDevices = RCGlobals.getExpiryFilteredList(data ?? [])
        username  = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.name ?? " "
        emailId = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.attributes?.email ?? " "
        usernamePhone = Defaults().get(for:  Key<LoginResponseModel>("LoginResponseModel"))?.data?.email ?? ""
        
        deviceCount = allDevices.count.description

    }
    func showProgress (_ message: String) {
              let topWindow = UIApplication.shared.keyWindow
              HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
              HUD?.animationType = .fade
              HUD?.mode = .indeterminate
              HUD?.labelText = message
          }

          func hideProgress () {
              HUD?.hide(true)
          }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func emailCall(_ cell:ProfileTableViewCell){
        let alert = UIAlertController(title: "Change email".toLocalize , message: nil , preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter new email id".toLocalize
        })
        
        alert.addAction(UIAlertAction(title: "SAVE".toLocalize, style: .default, handler: { action in
            let email_Id = alert.textFields?.first?.text
            if  email_Id!.isValidEmail() {
                
                let id = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.id
                let mobileNumber = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email ?? " "
                let name = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.name ?? " "
                RCLocalAPIManager.shared.UpdateUseDetails(with: id!, fname: name, lname: " ", email: email_Id!, mobile: mobileNumber, success: { [weak self] hash in
                    guard let weakSelf = self else {
                        return
                    }
                    let data = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))
                    let loginData = data?.data
                    let attributes = loginData?.attributes
                    attributes?.email = email_Id
                    loginData?.attributes = attributes
                    data?.data = loginData
                    Defaults().set(data!, for: Key<LoginResponseModel> ("LoginResponseModel"))
                    weakSelf.emailId = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.attributes?.email ?? " "
                    weakSelf.profileView.profileTableView.reloadData()
                    
                }) { [weak self] message in
                    guard let weakSelf = self else {
                        return
                    }
                    weakSelf.prompt("please try again")
                    print(message)
                }
                
                
            } else {
                UIApplication.shared.keyWindow?.makeToast("Please enter valid email", duration: 0.5, position: .bottom)
            }
            
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".toLocalize, style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func resetPwdCall(){
        let alert = UIAlertController(title: "Reset Password".toLocalize, message:"Please logout & then tap on forget password to reset your password".toLocalize, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".toLocalize, style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func showVehicleList(){
        let vc = EditVehicleInfoController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func paymentHostoryCall(){
        let paymentHistory = PaymentHisoryVC()
        self.navigationController?.pushViewController(paymentHistory, animated: true)
    }
    @objc func nameCall(_ cell:ProfileTableViewCell){
        let alert = UIAlertController(title: "Change username".toLocalize , message: nil , preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter new user name".toLocalize
        })
        
        alert.addAction(UIAlertAction(title: "SAVE".toLocalize, style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                
                let id = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.id
                let emailId = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.attributes?.email ?? " "
                let mobileNumber = (Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel")))?.data?.email ?? " "
                if name.count > 0 {
                    RCLocalAPIManager.shared.UpdateUseDetails(with: id!, fname: name, lname: " ", email: emailId, mobile: mobileNumber, success: { [weak self] hash in
                        guard let weakSelf = self else {
                            return
                        }
                        let data = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))
                        let loginData = data?.data
                        loginData?.name = name
                        data?.data = loginData
                        Defaults().set(data!, for: Key<LoginResponseModel> ("LoginResponseModel"))
                        weakSelf.username = name
                        weakSelf.profileView.profileTableView.reloadData()
                        
                    }) { [weak self] message in
                        guard let weakSelf = self else {
                            return
                        }
                        weakSelf.prompt("please try again")
                        print(message)
                    }
                }
                
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL".toLocalize, style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileTableViewCell
        cell.titleLabel.text = titles[indexPath.row]
        //for infoButton
        cell.inputButton.removeTarget(self, action: nil, for: .allEvents)
        switch titles[indexPath.row] {
        case "Username".toLocalize:
            cell.inputButton.setTitle(usernamePhone, for: .normal)
        case "Name".toLocalize:
            cell.inputButton.setTitle(username, for: .normal)
            cell.inputButton.titleLabel?.underline()
            cell.inputButton.addTarget(self, action: #selector(nameCall(_:)), for: .touchUpInside)
        case "Email".toLocalize:
            cell.inputButton.setTitle(emailId, for: .normal)
            cell.inputButton.titleLabel?.underline()
            cell.inputButton.addTarget(self, action: #selector(emailCall(_:)), for: .touchUpInside)
        case "Reset Password".toLocalize:
            cell.inputButton.setTitle("*****", for: .normal)
            cell.inputButton.titleLabel?.underline()
            cell.inputButton.addTarget(self, action: #selector(resetPwdCall), for: .touchUpInside)
        case "List of Vehicles".toLocalize:
            cell.inputButton.setTitle("\(String(describing: allDevices.count)) >", for: .normal)
            cell.inputButton.addTarget(self, action: #selector(showVehicleList), for: .touchUpInside)
        case "Payment History".toLocalize:
            cell.inputButton.setImage(#imageLiteral(resourceName: "righticon").resizedImage(CGSize(width: 20, height: 20), interpolationQuality: .default), for: .normal)
            cell.inputButton.addTarget(self, action: #selector(paymentHostoryCall), for: .touchUpInside)
        case "Personal Verification".toLocalize:
            cell.inputButton.setTitle("view image", for: .normal)
            cell.inputButton.titleLabel?.underline()
            cell.inputButton.addTarget(self, action: #selector(viewImage(sender:)), for: .touchUpInside)
        default:
            break
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    func openCameraGalleryChooser() {
        let alert = UIAlertController(title: "Choose source", message: "Select a source", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default){ action in
            
            let  imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default){ action in
            
            let  imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc private func openImagePicker() {
        openCameraGalleryChooser()
    }
    @objc func viewImage(sender:UIButton){
        
        let alertMessage = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let cancel = UIAlertAction(title: "Edit", style: .default, handler: { _ in
//            let  imagePickerController = UIImagePickerController()
//            imagePickerController.delegate = self
//            imagePickerController.sourceType = .savedPhotosAlbum
//            imagePickerController.allowsEditing = true
//            self.present(imagePickerController, animated: true, completion: nil)
            self.openCameraGalleryChooser()
        })
        alertMessage.addAction(cancel)
        alertMessage .addAction(action)
        imagView = UIImageView()//(frame: CGRect(x: alertMessage.view.frame.size.width / 7, y: 10, width: 150, height: 130))
        imagView.image = UIImage(named: "placeholder")
        imagView.contentMode = .scaleToFill
        loadImageFromURL()
        alertMessage.view.addSubview(imagView)
        alertMessage.view.snp.makeConstraints { (make) in
            make.height.equalTo(200)
        }
        imagView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(130)
        }

        self.present(alertMessage, animated: true, completion: nil)
   }
    func loadImageFromURL() {
        guard let url = URL(string: self.imageURL) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imagView.image = image
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromImagePicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            // add img where you want to use
//            let userId = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
//            let parameters:[String:Any] = [ "userId" : userId ]
//            requestWith(imageData: UIImagePNGRepresentation(selectedImage)!, fileName: "PROFILE_\(userId).jpg", parameters: parameters, onCompletion: { [weak self] message in
//                guard self != nil else { return }
//                if  message == "Success" {
//                }
//                print("success")
//            }) { [weak self] error in
//                guard let weakself = self else { return }
//                weakself.prompt("Image upload failed.")
//            }
            let imageData = compressImage(image: selectedImage)
            sendImageToServer(imageData: imageData, onCompletion: { imagePath in
                self.patchImagePath(imagePath: imagePath)
            }, onFail: { error in
                self.prompt("Unable to upload image")
            })
            
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendImageToServer(imageData: Data, onCompletion: @escaping (String) -> Void, onFail: @escaping (String) -> Void ) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let userId = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        let fileName:String = "PROFILE_\(userId).jpg"
        let markerRef = storageRef.child("uploads/\(fileName)")
        _ = markerRef.putData(imageData, metadata: metadata) {
            (metadata, error) in
            guard metadata != nil else {
                onFail("Image upload failed")
                // Uh-oh, an error occurred!
                return
            }
            markerRef.downloadURL {
                (url, error) in
                guard let downloadURL = url
                    else {
                    onFail("Image upload failed")
                    return
                }
                onCompletion(downloadURL.absoluteString)
            }
        }
    }
    
    func patchImagePath(imagePath:String) {
        RCLocalAPIManager.shared.updateProfileImage(imageUrl: imagePath, success: { success in
            self.imageURL = imagePath
            self.profileView.profileTableView.reloadData()
        }, failure: { error in
            self.prompt("Unable to update image")
            self.profileView.profileTableView.reloadData()
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.contentSize.height/CGFloat(titles.count)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch titles[indexPath.row] {
        case "List of Vehicles":
            showVehicleList()
        case "Payment History":
            paymentHostoryCall()
        default:
            break
        }
    }
}
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

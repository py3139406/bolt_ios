//
//  AddPhotoViewController.swift
//  Bolt
//
//  Created by Roadcast on 19/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.


import UIKit
import SnapKit
import ImageViewer_swift
import DefaultsKit
import Firebase

class AddPhotoViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    var addPhotosTitleLabel:UILabel!
    var topcameraImage:UIImageView!
    var enterTitleField:UITextField!
    var descriptionTextfield :UITextField!
    var crossButton:UIButton!
    var imageButton:UIButton!
    var cancelButton:UIButton!
    var saveButton:UIButton!
    let screesize = UIScreen.main.bounds.size
    var picImageview1:UIImageView!
    var picImageview2:UIImageView!
    var picImageview3:UIImageView!
    var picImageview4:UIImageView!
    var picImageview5:UIImageView!
  //  var imageTable:UITableView!
    var imageCollectionView : UICollectionView!
    var imagePickerController:UIImagePickerController!
    var imageviewsArray:[UIImage] = []
    var selectedIndexArray:[Int] = []
    var cell = "cell"
    lazy var imagePicker = UIImagePickerController()
    private var rootReference : DatabaseReference!
    
    private var device : TrackerDevicesMapperModel!
    
    var counter = 0
    
    var uploadCounter = 0
    
    var imagePathArray = [String]()
    
    var markerId = ""
    
    var time = NSDate()
    
    var HUD: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(backTapped))
    
        addViews()
        addcontraintsforViews()
        addAction()
        
        markerId = UUID.init().uuidString
        
        rootReference = Database.database().reference().child("Bolt/Markers")
        
        let deviceId = Defaults().get(for: Key<Int> ("bottomSheetDeviceId"))
    
        let keyValue = "Device_" + "\(deviceId ?? 0)"
        device = Defaults().get(for: Key<TrackerDevicesMapperModel>(keyValue))
        
        Auth.auth().signInAnonymously { (user, error) in
          
        }
    }
    
    func addAction(){
        imageButton.addTarget(self, action: #selector(onPhotoButton), for: .touchUpInside)
        crossButton.addTarget(self, action: #selector(onRemoveButton), for: .touchUpInside)
    }
    
    func removeImages () {
        
        var array:[UIImage] = []
        
        for (index, item) in imageviewsArray.enumerated() {
            if  !selectedIndexArray.contains(index) {
                array.append(item)
            }
        }
        
        imageviewsArray = array
        
        counter = imageviewsArray.count
        selectedIndexArray.removeAll()
        imageCollectionView.reloadData()
    }
    
    @objc func onRemoveButton () {
//                let vc = MarkerPhotoViewController()
//                navigationController?.pushViewController(vc, animated: true)
        if selectedIndexArray.count > 0 {
            let message = "Are you sure?"
            let alertController = UIAlertController(title: "Remove images".toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes".toLocalize, style: .destructive, handler: { alert -> Void in
                self.removeImages()
            })

            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let message = "Please select an image to remove."
            let alertController = UIAlertController(title: "Remove image".toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func onPhotoButton(){
        if  counter < 5 {
            openCameraGalleryChooser()
        } else {
            let message = "Maximum five images are allowed."
            let alertController = UIAlertController(title: "Add image".toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    @objc func onSaveButton(){
        time = NSDate()
        let title : String  = self.enterTitleField.text ?? ""
        if  title.isEmpty {
            
            let message = "Please enter a title."
            let alertController = UIAlertController(title: "Enter Title".toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        } else if imageviewsArray.count == 0  {
            let message = "At-least one image is required to save."
            let alertController = UIAlertController(title: "Click Image".toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            
            let topWindow = UIApplication.shared.keyWindow
            HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
            HUD?.animationType = .fade
            HUD?.mode = .indeterminate
            HUD?.labelText = "Please wait...".toLocalize
            
            uploadImages()
        }
    }
    
    func uploadImages() {
        let uploadImage = imageviewsArray[uploadCounter]
        let imageData = compressImage(image: uploadImage)
        let date = RCGlobals.getFormattedDate(date: time, format: "yyyyMMdd_HHmmss", zone:TimeZone(identifier:"UTC")!)
        let imageName = "MARKER__\(markerId)_\(date)_\(uploadCounter + 1)"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let markerRef = storageRef.child("Markers/\(markerId)/\(imageName)")
        _ = markerRef.putData(imageData, metadata: metadata) {
            (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
//            let size = metadata.size
            // You can also access to download URL after upload.
            markerRef.downloadURL {
                (url, error) in
                guard let downloadURL = url
                    else {
                        // Uh-oh, an error occurred!
                    return
                }
                self.imagePathArray.append(downloadURL.absoluteString)
                self.uploadCounter += 1
                if  self.uploadCounter < self.imageviewsArray.count {
                    self.uploadImages()
                } else {
                    self.uploadCounter = 0
                    self.addMarkerToFirebase()
                }
            }
        }
    }
    
    func addMarkerToFirebase() {
        
        if rootReference != nil {
            let date = RCGlobals.getFormattedDate(date: time, format: "dd-MM-yyyy", zone:TimeZone(identifier:"UTC")!)
            let markerRef : DatabaseReference = rootReference.child("\(device.id ?? 0)").child("\(date)").child("\(markerId)")
            
            let keyValuePos = "Position_" + "\(device.id ?? 0)"
            let devPostition = Defaults().get(for: Key<TrackerPositionMapperModel>(keyValuePos))
            
            let dateTime = RCGlobals.getFormattedDate(date: time, format: "yyyy-MM-dd'T'HH:mm:ssZ", zone:TimeZone(identifier:"UTC")!)
            
            var user : [String: Any] = [:]
            
            let title : String  = self.enterTitleField.text ?? ""
            
            let description : String  = self.descriptionTextfield.text ?? ""
            
            user["userLat"] = 0.0
            user["userLng"] = 0.0
            user["deviceLat"] = devPostition?.latitude
            user["deviceLng"] = devPostition?.longitude
            user["timestamp"] = dateTime
            user["title"] = title
            user["description"] = description
            user["imagePathList"] = imagePathArray
            markerRef.setValue(user)
            
            HUD?.hide(true)
            
            let message = "All marker details are saved successfully."
            let alertController = UIAlertController(title: "Marker".toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: { alert -> Void in
                self.backTapped()
            })
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
        }
    }

    
    @objc func onCancelButton(){
        let message = "Are you sure?"
        let alertController = UIAlertController(title: "Exit".toLocalize, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".toLocalize, style: .destructive, handler: { alert -> Void in
            self.backTapped()
        })
        
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
            imageviewsArray.append(selectedImage)
            counter += 1
            imageCollectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func addViews(){
        addPhotosTitleLabel = UILabel(frame: CGRect.zero)
        addPhotosTitleLabel.text = "Add Photos"
        addPhotosTitleLabel.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        addPhotosTitleLabel.textColor = .black
        view.addSubview(addPhotosTitleLabel)
        
        topcameraImage = UIImageView(frame: CGRect.zero)
        topcameraImage.image = #imageLiteral(resourceName: "camera")
        view.addSubview(topcameraImage)

        
        enterTitleField = UITextField(frame: CGRect.zero)
        enterTitleField.attributedPlaceholder = NSAttributedString(string: "Enter Title",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        enterTitleField.textAlignment = .natural
        enterTitleField.textColor = .white
        enterTitleField.tintColor = .white
        enterTitleField.setLeftPaddingPoints(20)
        enterTitleField.backgroundColor = UIColor(red: 60/255, green: 68/255, blue: 160/255, alpha: 1)
        view.addSubview(enterTitleField)
        
        crossButton = UIButton(frame: CGRect.zero)
        crossButton.setImage(#imageLiteral(resourceName: "Artboard 35"), for: .normal)
        view.addSubview(crossButton)
        
        imageButton = UIButton(frame: CGRect.zero)
        imageButton.setImage(UIImage(named: "camera1"), for: .normal)
        
        view.addSubview(imageButton)
        
        descriptionTextfield = UITextField(frame: CGRect.zero)
        descriptionTextfield.placeholder = "Description"
        descriptionTextfield.textAlignment = .natural
        descriptionTextfield.sizeToFit()
        descriptionTextfield.textColor = .black
        descriptionTextfield.tintColor = .black
        descriptionTextfield.setLeftPaddingPoints(20)
        descriptionTextfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(descriptionTextfield)
        
        cancelButton = UIButton(frame: CGRect.zero)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .black
        cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCancelButton)))
        view.addSubview(cancelButton)

        saveButton = UIButton(frame: CGRect.zero)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = UIColor(red: 48/255, green: 174/255, blue: 160/255, alpha: 1)
        saveButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSaveButton)))
        view.addSubview(saveButton)
        
        updateImageViewTable()
    }
    
    func updateImageViewTable() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screesize.width * 0.40,
                                 height: screensize.height * 0.20)
        imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        imageCollectionView.backgroundColor = .white

        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
        imageCollectionView.setCollectionViewLayout(layout, animated: true)
        imageCollectionView.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        imageCollectionView.reloadData()
        view.addSubview(imageCollectionView)
    }
    
    func addcontraintsforViews(){
        addPhotosTitleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaInsets.top).offset(100)
            } else {
                make.top.equalToSuperview().offset(100)
                // Fallback on earlier versions
            }
            make.left.equalToSuperview().offset(screesize.width * 0.10)
            
        }
        topcameraImage.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotosTitleLabel.snp.top)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(35)
           // make.height.equalTo(screesize.height * 0.03)
            
        }
        enterTitleField.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotosTitleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(screesize.height * 0.05)
            
        }
            imageCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(enterTitleField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.height.equalTo(screesize.height * 0.25)
                }

        crossButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(screesize.height * 0.7)
            make.left.equalTo(view.snp.centerX)
            make.width.height.equalTo(35)
            
        }
        imageButton.snp.makeConstraints { (make) in
            make.top.equalTo(crossButton.snp.top)
            make.left.equalTo(crossButton.snp.right).offset(10)
            make.width.height.equalTo(35)
            
        }
      descriptionTextfield.snp.makeConstraints { (make) in
        make.top.equalTo(crossButton.snp.bottom).offset(30)
        make.left.right.equalToSuperview()
       make.height.equalTo(screesize.height * 0.05)
        }
        cancelButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview().offset(10)
                // Fallback on earlier versions
            }
          make.left.equalToSuperview()
        make.width.equalTo(screesize.width * 0.50)
        make.height.equalTo(screesize.height * 0.05)
          }
        saveButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview().offset(10)
                // Fallback on earlier versions
            }
            make.left.equalTo(cancelButton.snp.right)
           make.width.equalTo(screesize.width * 0.50)
          make.height.equalTo(screesize.height * 0.05)
          }
    }
    @objc func backTapped(){
        self.dismiss(animated: true, completion: nil)
    }

}
extension AddPhotoViewController:UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageviewsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddPhotoCollectionViewCell
        if  !selectedIndexArray.contains(indexPath.row) {
            cell.addImage.image = self.imageviewsArray[indexPath.row]
            let renderingMode: UIImageRenderingMode = .alwaysOriginal
            cell.addImage.image = cell.addImage.image?.withRenderingMode(renderingMode)
        } else {
//            if let myImage = cell.addImage.image {
//                let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
//                cell.addImage.image = tintableImage
//            }
//            cell.addImage.tintColor = UIColor(red:48/255.0, green: 174/255.0, blue: 159/255.0, alpha:0.8)
            
            let inputImage = self.imageviewsArray[indexPath.row]
            let context = CIContext(options: nil)

            if let currentFilter = CIFilter(name: "CISepiaTone") {
                let beginImage = CIImage(image: inputImage)
                currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
                currentFilter.setValue(0.8, forKey: kCIInputIntensityKey)

                if let output = currentFilter.outputImage {
                    if let cgimg = context.createCGImage(output, from: output.extent) {
                        let processedImage = UIImage(cgImage: cgimg)
                        // do something interesting with the processed image
                        cell.addImage.image = processedImage
                    }
                }
            }
            
        }
        cell.addImage.contentMode = .scaleToFill
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = BasicViewController(index: indexPath.row)
//        navigationController?.pushViewController(vc, animated: true)
//        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AddPhotoCollectionViewCell
        if  selectedIndexArray.contains(indexPath.row) {
            selectedIndexArray.removeObject(obj: indexPath.row)
        } else {
            selectedIndexArray.append(indexPath.row)
        }
        imageCollectionView.reloadData()
    }
   
}



extension AddPhotoViewController {
    
    func openCameraGalleryChooser() {
        let alert = UIAlertController(title: "Choose source", message: "Select a source", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default){ action in
            
            self.imagePickerController = UIImagePickerController()
                    print("Button capture")
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .savedPhotosAlbum
            self.imagePickerController.allowsEditing = true
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default){ action in
            
            self.imagePickerController = UIImagePickerController()
                    print("Button capture")
            self.imagePickerController.delegate = self
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.allowsEditing = true
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}

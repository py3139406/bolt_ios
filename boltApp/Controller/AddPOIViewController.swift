//
//  AddPOIViewController.swift
//  Bolt
//
//  Created by Roadcast on 01/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import DefaultsKit
import Firebase

protocol POIDelegate {
    func tableReload()
}

class AddPOIViewController: UIViewController , UITextFieldDelegate {
    //MARK: Properties
    var addPOIScroolView: POIScrollView!
    lazy var poiVC = POIViewController()
    var mapView:RCMainMap!
    var buttonText:String = ""
    var screenSize = UIScreen.main.bounds.size
    var poiData : POIInfoDataModel!
    var isEdit : Bool = false
    var poiLocation:CLLocation!
    var isCameraMoved:Bool = false
    var zoom:Float = 17
    var isImageChanged:Bool = false
    var imageURL:String = ""
    var newImage:UIImage!
    var shouldShowMap:Bool = false
    
    var poiDelegate: POIDelegate?
    
    var imagePicker:UIImagePickerController!
    
    var progress: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //addNavigationBar()
        addViews()
        addConstraints()
        addPOIScroolView.googleAddressTextField.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchAddress(_:)))
        addPOIScroolView.googleAddressTextField.addGestureRecognizer(guestureRecognizer)
        addPOIScroolView.addNewButton.addTarget(self, action: #selector(addNewButtonAction(_:)), for: .touchUpInside)
        
        addPOIScroolView.imageSelectImageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
        addPOIScroolView.imageSelectImageView.addGestureRecognizer(imageGestureRecognizer)
        
        setUpMap()
        
        if isEdit {
            updateCurrentPOIData()
        }
        
        Auth.auth().signInAnonymously { (user, error) in
            
        }
        
        self.poiDelegate = poiVC
    }
    
    func openCameraGalleryChooser() {
        let alert = UIAlertController(title: "Choose source", message: "Select a source", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Gallery", style: .default){ action in
            
            self.imagePicker = UIImagePickerController()
                print("Button capture")
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default){ action in
            
            self.imagePicker = UIImagePickerController()
                print("Button capture")
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){ action in
            alert.dismiss(animated: true)
        }
        
        alert.addAction(gallery)
        alert.addAction(camera)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func selectImage (_ sender : Any) {
        self.openCameraGalleryChooser()
    }
    
    @objc func searchAddress(_ sender : Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func setUpMap() -> Void {
        mapView.clear()
        mapView.delegate = self
    }
    
    func updateCurrentPOIData() {
        addPOIScroolView.titleTextField.text = poiData.title
        addPOIScroolView.descriptionTextField.text = poiData.description ?? ""
        addPOIScroolView.googleAddressTextField.text = poiData.address ?? ""
        
        var latitude : Double = 0
        var longitude : Double = 0
        
        if  let lat = Double(poiData.lat ?? "0") {
            latitude = lat
        }
        
        if  let lng = Double(poiData.lng ?? "0") {
            longitude = lng
        }
        
        imageURL = poiData.image ?? ""
        
        loadImageFromURL()
        
        poiLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        moveCamera(poiLocation.coordinate)
        
        addPOIMarker()
    }
    
    func loadImageFromURL () {
        
        guard let url = URL(string: self.imageURL) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.addPOIScroolView.imageSelectImageView.image = image
            }
        }
    }
    
    func addViews(){
        
        mapView = RCMainMap(frame: CGRect.zero)
        view.addSubview(mapView)
        
        addPOIScroolView = POIScrollView(frame: CGRect.zero)
        addPOIScroolView.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 59/255, alpha: 1)
        addPOIScroolView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.56)
        addPOIScroolView.bounces = false
        view.addSubview(addPOIScroolView)

        addPOIScroolView.addNewButton.setTitle(buttonText, for: .normal)
    }
    func addConstraints(){
        mapView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(screenSize.height * 0.45)
        }
        addPOIScroolView.snp.makeConstraints { (make) in
            make.top.equalTo(mapView.snp.bottom)
            make.width.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
//    private func addNavigationBar() {
////        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
////        self.navigationItem.leftBarButtonItem = leftButton
//
//    }
    @objc func addNewButtonAction(_ sender:UIButton){
        if  ( addPOIScroolView.titleTextField.text?.isEmpty ?? true
            || addPOIScroolView.googleAddressTextField.text?.isEmpty ?? true
            || addPOIScroolView.descriptionTextField.text?.isEmpty ?? true ){
            prompt("Please fill all fields")
        }
        else {
            var title = "Add new POI"
            if  isEdit {
                title = "Update POI"
            }
            let message = "Are you sure?"
            let alertController = UIAlertController(title: title.toLocalize, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Yes".toLocalize, style: .destructive, handler: { alert -> Void in
                if  self.isImageChanged {
                    self.uploadPOIImage()
                } else {
                    self.poiRequestHandling()
                }
            })
            
            alertController.addAction(okAction)
            let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func uploadPOIImage() {
        
        let topWindow = UIApplication.shared.keyWindow
        progress = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        progress?.animationType = .fade
        progress?.mode = .indeterminate
        progress?.labelText = "Uploading image, Please wait...".toLocalize
        
        let imageData = compressImage(image: newImage)
        let date = Int((Date().timeIntervalSince1970) * 1000)
        let imageName = "POI_\(date)"
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let userId = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data?.id ?? "0"
        let markerRef = storageRef.child("POI/\(userId)/\(imageName)")
        _ = markerRef.putData(imageData, metadata: metadata) {
            (metadata, error) in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            // let size = metadata.size
            // You can also access to download URL after upload.
            markerRef.downloadURL {
                (url, error) in
                guard let downloadURL = url
                    else {
                        // Uh-oh, an error occurred!
                        self.progress?.hide(true)
                        return
                }
                self.imageURL = downloadURL.absoluteString
                self.progress?.hide(true)
                self.poiRequestHandling()
            }
        }
    }
    
    func poiRequestHandling() {
        if self.isEdit {
            self.updatePOIRequest()
        } else {
            self.addNewPOIRequest()
        }
    }
    
    func updatePOIRequest() {
        let googleAddress = addPOIScroolView.googleAddressTextField.text
        let title = addPOIScroolView.titleTextField.text
        let description = addPOIScroolView.descriptionTextField.text
        let lat = String(poiLocation.coordinate.latitude)
        let lng = String(poiLocation.coordinate.longitude)
        let parameters = ["address":googleAddress!,"title":title!,"description":description!,"lat":lat,"lng":lng,"image":imageURL] as [String:Any]
        RCLocalAPIManager.shared.updatePOIData(with: parameters,id: poiData.id ?? "0", loadingMsg: "Updating POI, Please wait...",success: { (success) in
            self.getPOIDataRequest("UPDATE")
        }) { (failure) in
            self.prompt("failure in updating POI info")
        }
    }
    
    func addNewPOIRequest() {
        let googleAddress = addPOIScroolView.googleAddressTextField.text
        let title = addPOIScroolView.titleTextField.text
        let description = addPOIScroolView.descriptionTextField.text
        let lat = String(poiLocation.coordinate.latitude)
        let lng = String(poiLocation.coordinate.longitude)
        let parameters = ["address":googleAddress!,"title":title!,"description":description!,"lat":lat,"lng":lng,"image":imageURL] as [String:Any]
        RCLocalAPIManager.shared.addPOIData(with: parameters, loadingMsg: "Adding POI, Please wait...",success: { (success) in
            self.getPOIDataRequest("ADD")
        }) { (failure) in
            self.prompt("failure in adding POI")
        }
    }
    
    func getPOIDataRequest (_ requestType : String) {
        self.isImageChanged = false
        RCLocalAPIManager.shared.getPOIData(with:"Fetching latest poi info.", success: { (success) in
            if requestType == "ADD" {
                self.poiRequestSuccess("POI successfully added.")
            } else {
                self.poiRequestSuccess("POI successfully updated.")
            }
        }) { (failure) in
            print("failure in getting POI info")
        }
    }
    
    func poiRequestSuccess(_ message : String) {
        let alertController = UIAlertController(title: "POI".toLocalize, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".toLocalize, style: .destructive, handler: { alert -> Void in
            self.moveToPreviousController()
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        moveToPreviousController()
    }
    
    func moveToPreviousController() {
        if shouldShowMap {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: {
                self.poiDelegate?.tableReload()
            })
        }
    }
    
    func moveCamera (_ position: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withTarget: position, zoom: zoom)
        mapView.camera = camera
    }
    
    func addPOIMarker() {
        let marker = GMSMarker(position: poiLocation.coordinate)
        marker.map = mapView
        marker.icon = #imageLiteral(resourceName: "ic_poi_loc").resizedImage(CGSize.init(width: 16, height: 35), interpolationQuality: .default)
        marker.title = "POI"
    }
    
    func reverseGeocoding(latiude: Double, longitude: Double) {
        let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latiude, longitude: longitude)
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            let addressText = lines.joined(separator: " ")
            self.addPOIScroolView.googleAddressTextField.text = addressText
        }
    }
}

extension AddPOIViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        poiLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        addPOIMarker()
        
        moveCamera(coordinate)
        
        reverseGeocoding(latiude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        mapView.clear()
        
        poiLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        addPOIMarker()
        
        moveCamera(location)
        
        reverseGeocoding(latiude: location.latitude, longitude: location.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if isCameraMoved {
            isCameraMoved = false
            
            mapView.clear()
            
            zoom = mapView.camera.zoom
            
            poiLocation = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            
            addPOIMarker()
            
            reverseGeocoding(latiude: position.target.latitude, longitude: position.target.longitude)
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        isCameraMoved = true
    }
    
}

extension AddPOIViewController: GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        mapView.clear()
        poiLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        zoom = 17
        
        addPOIMarker()
        
        addPOIScroolView.googleAddressTextField.text = place.formattedAddress
        
        moveCamera(place.coordinate)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddPOIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromImagePicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromImagePicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromImagePicker = originalImage
        }
        
        if let selectedImage = selectedImageFromImagePicker {
            self.isImageChanged = true
            self.newImage = selectedImage
            self.addPOIScroolView.imageSelectImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


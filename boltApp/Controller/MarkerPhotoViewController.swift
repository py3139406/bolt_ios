//
//  MarkerPhotoViewController.swift
//  Bolt
//
//  Created by Roadcast on 23/05/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
import DefaultsKit
import GoogleMaps
import Firebase

class MarkerPhotoViewController: UIViewController {
     let screensize = UIScreen.main.bounds.size
    var descriptionLabel:UILabel!
    var descriptionView:UILabel!
    var addressLabel:UILabel!
    var addressTextView:UILabel!
    var TakenOnLabel:UILabel!
    var takenOnTextView:UILabel!
    var photoCollectionView : UICollectionView!
    var imagePathArray:[String] = []
    var counter : Int = 0
    var downloadFailCounter : Int = 0
    var HUD: MBProgressHUD?
    var markerFirebaseModel: MarkerFirebaseModel?
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .black
            navigationItem.title = "Title"
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .plain, target: self, action: #selector(dismissView(_:)))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(DownloadFile(_:)))
          addviews()
          addConstraints()
         markerFirebaseModel = Defaults().get(for: Key<MarkerFirebaseModel> ("particularMarkerInfo"))
                 
                 navigationItem.title = markerFirebaseModel!.title
                 descriptionView.text = markerFirebaseModel!.description
                 takenOnTextView.text = RCGlobals.getDefaultUTCDateImageMarker(markerFirebaseModel!.timestamp!)
            
            imagePathArray = markerFirebaseModel!.imagePathList!

            reverseGeocoding(latiude: markerFirebaseModel!.deviceLat!, longitude: markerFirebaseModel!.deviceLng!)
                 
        }
             
             func reverseGeocoding(latiude: Double, longitude: Double) {
               var addressText = ""
               let cordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latiude, longitude: longitude)
               let geocoder = GMSGeocoder()
               geocoder.reverseGeocodeCoordinate(cordinate) { (response, error) in
                 guard let address = response?.firstResult(), let lines = address.lines else { return }
                 addressText = lines.joined(separator: " ")
                 self.addressTextView.text = addressText
         //        print(addressText)
               }
             }
    
  func  addviews(){
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: screensize.width ,
                             height: screensize.height)
    photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    photoCollectionView.backgroundColor = .black

    self.photoCollectionView.delegate = self
    self.photoCollectionView.dataSource = self
    photoCollectionView.setCollectionViewLayout(layout, animated: true)
    photoCollectionView.reloadData()
    photoCollectionView.register(MarkerPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photocell")
    view.addSubview(photoCollectionView)
    
    descriptionLabel = UILabel(frame: CGRect.zero)
    descriptionLabel.text = "Description"
    descriptionLabel.textColor = appGreenTheme
    descriptionLabel.isUserInteractionEnabled = false
    descriptionLabel.font = UIFont.systemFont(ofSize: 20)
    view.addSubview(descriptionLabel)
    
    descriptionView = UILabel(frame: CGRect.zero)
    descriptionView.text = "Description in details dgmlaglg"
    descriptionView.textColor = .white
    descriptionView.isUserInteractionEnabled = false
    descriptionView.font = UIFont.systemFont(ofSize: 15)
    view.addSubview(descriptionView)
    
    addressLabel = UILabel(frame: CGRect.zero)
    addressLabel.text = "Address"
    addressLabel.textColor = appGreenTheme
    addressLabel.isUserInteractionEnabled = false
    addressLabel.font = UIFont.systemFont(ofSize: 20)
    view.addSubview(addressLabel)
    
    addressTextView = UILabel(frame: CGRect.zero)
    addressTextView.numberOfLines = 2
    addressTextView.text = "this is address  in details dgmlaglg fhjfsdj bhfx gcfg "
    addressTextView.textColor = .white
    addressTextView.isUserInteractionEnabled = false
    addressTextView.font = UIFont.systemFont(ofSize: 15)
    view.addSubview(addressTextView)
    
    TakenOnLabel = UILabel(frame: CGRect.zero)
    TakenOnLabel.text = "Taken On"
    TakenOnLabel.textColor = appGreenTheme
    TakenOnLabel.isUserInteractionEnabled = false
    TakenOnLabel.font = UIFont.systemFont(ofSize: 20)
    view.addSubview(TakenOnLabel)
    
    takenOnTextView = UILabel(frame: CGRect.zero)
    takenOnTextView.text = "may 27,2020@ 2.30"
    takenOnTextView.textColor = .white
    takenOnTextView.isUserInteractionEnabled = false
    takenOnTextView.font = UIFont.systemFont(ofSize: 15)
    view.addSubview(takenOnTextView)
    
    }
  func   addConstraints(){
    photoCollectionView.snp.makeConstraints { (make) in
        if #available(iOS 11.0, *) {
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        } else {
            make.top.equalToSuperview().offset(60)
            // Fallback on earlier versions
        }
        make.left.right.equalToSuperview()
        make.height.equalTo(screensize.height * 0.50)
    }
    descriptionLabel.snp.makeConstraints { (make) in
        make.top.equalTo(photoCollectionView.snp.bottom).offset(screensize.height * 0.02)
        make.left.equalToSuperview().offset(20)
        make.right.equalToSuperview()
    }
    descriptionView.snp.makeConstraints { (make) in
        make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
        make.left.equalToSuperview().offset(20)
        make.right.equalToSuperview()
    }
    addressLabel.snp.makeConstraints { (make) in
        make.top.equalTo(descriptionView.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
    }
    addressTextView.snp.makeConstraints { (make) in
        make.top.equalTo(addressLabel.snp.bottom).offset(5)
        make.left.equalToSuperview().offset(20)
        make.right.equalToSuperview()
    }
    TakenOnLabel.snp.makeConstraints { (make) in
        make.top.equalTo(addressTextView.snp.bottom).offset(screensize.height * 0.02)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
    }
    takenOnTextView.snp.makeConstraints { (make) in
        make.top.equalTo(TakenOnLabel.snp.bottom).offset(5)
        make.left.equalToSuperview().offset(20)
        make.right.equalToSuperview()
    }
    
    }
    @objc func DownloadFile(_ sender:UIBarButtonItem){
        downloadFailCounter = 0
        counter = 0
        showProgress(message: "Please wait, Downloading files...")
        downloadAllImages(imagePathArray[counter])
    }
    @objc func dismissView(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadAllImages(_ imageUrl : String) {
        counter += 1
        let storage = Storage.storage()
        
        let httpsReference = storage.reference(forURL: imageUrl)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let time = NSDate()
        
        let dateTime = RCGlobals.getFormattedDate(date: time, format: "yyyy_MM_ddHH_mm_ss", zone:NSTimeZone.system)
        
        let fileName : String = "\(markerFirebaseModel?.deviceId ?? "0")_\(dateTime)_\(counter)"

        let destinationPath = URL(fileURLWithPath: documentsPath).appendingPathComponent("\(fileName).png")
        
        _ = httpsReference.write(toFile: destinationPath) { url, error in
            if error != nil {
            // Uh-oh, an error occurred!
                self.downloadFailCounter += 1
                self.handleRestImages()
            } else {
            // Local file URL for "images/island.jpg" is returned
                self.handleRestImages()
            }
        }

    }
    
    func handleRestImages() {
        if  self.counter < self.imagePathArray.count {
            self.downloadAllImages(self.imagePathArray[self.counter])
        } else {
            self.hideProgress()
            if  downloadFailCounter > 0 {
                self.prompt("Unable to download some images")
            } else {
                self.prompt("All images downloaded in files successfully.")
            }
        }
    }
    
    func showProgress (message : String) {
        let topWindow = UIApplication.shared.keyWindow
        HUD = MBProgressHUD.showAdded(to: topWindow!, animated: true)
        HUD?.animationType = .fade
        HUD?.mode = .indeterminate
        HUD?.labelText = message
    }
    
    func hideProgress () {
        HUD?.hide(true)
    }
        
}
extension MarkerPhotoViewController:UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagePathArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photocell = collectionView.dequeueReusableCell(withReuseIdentifier: "photocell", for: indexPath) as! MarkerPhotoCollectionViewCell
//        photocell.addimage.image = imageViews[indexPath.row]
        setImage(url: imagePathArray[indexPath.row], imageView: photocell.addimage)
        photocell.addimage.contentMode = .scaleAspectFit
        return photocell
    }
    
    func setImage(url: String, imageView: UIImageView) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }
    
    
}

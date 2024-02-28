//
//  POIViewController.swift
//  Bolt
//
//  Created by Roadcast on 01/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class POIViewController: UIViewController {
    //MARK: properties
    let screenSize = UIScreen.main.bounds.size
    var addPlusButton:UIButton!
    var poiTable:UITableView!
    var poiArray : [POIInfoDataModel] = []
    var filtered:[POIInfoDataModel]!
    var isSearching:Bool = false
    var addsearchBar:UISearchBar!
    var filteredData: [String]!
    let POIData = Defaults().get(for: Key<[POIInfoDataModel]> ("POI"))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        addNavigationBar()
        addScreenView()
        addConstraints()
        addDoneButtonOnKeyboard()
        addAction()
        if  let poidata = POIData {
            self.poiArray = poidata
            self.poiTable.reloadData()
        }
        
        getPOIDataRequest()
        // Do any additional setup after loading the view.
    }
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        addsearchBar.inputAccessoryView = doneToolbar
    }
    @objc func doneButtonAction(){
        addsearchBar.endEditing(true)
    }
    
    
    func getPOIDataRequest () {
        RCLocalAPIManager.shared.getPOIData(with:"Updating POI Info.", success: { (success) in
            print("success in getting POI info")
            if  let poidata = Defaults().get(for: Key<[POIInfoDataModel]> ("POI")) {
                self.poiArray = poidata
                self.poiTable.reloadData()
            }
        }) { (failure) in
            print("failure in getting POI info")
        }
    }
    
    func addAction(){
        let plusButtonGesture = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped(_:)))
        plusButtonGesture.numberOfTouchesRequired = 1
        addPlusButton.addGestureRecognizer(plusButtonGesture)
        
        poiTable.delegate = self
        poiTable.dataSource = self
        poiTable.register(UITableViewCell.self, forCellReuseIdentifier: "poicell")
        poiTable.reloadData()
    }
    @objc func plusButtonTapped(_ sender :UITapGestureRecognizer){
        let vc = AddPOIViewController()
        vc.buttonText = "Add New"
        vc.isEdit = false
        vc.poiVC = self
//        let controller = UINavigationController(rootViewController: vc)
//        controller.navigationBar.backgroundColor = .white
//        self.present(controller, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    func addScreenView(){
        
        addPlusButton = UIButton()
        addPlusButton.setImage(UIImage(named: "addicon")?.resizedImage(CGSize.init(width: 20, height: 20), interpolationQuality: .default), for: .normal)
        addPlusButton.contentMode = .scaleAspectFit
        addPlusButton.backgroundColor = appGreenTheme
        view.addSubview(addPlusButton)
        
        poiTable = UITableView(frame: CGRect.zero)
        poiTable.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 59/255, alpha: 1)
        poiTable.bounces = false
        view.addSubview(poiTable)
        
        addsearchBar = UISearchBar()
        addsearchBar.placeholder = "Search POI"
        addsearchBar.barStyle = .default
        addsearchBar.barTintColor = .white
        addsearchBar.backgroundColor = .white
        addsearchBar.delegate = self
        view.addSubview(addsearchBar)
        
    }
    func addConstraints(){
        addPlusButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            } else {
                // Fallback on earlier versions
                make.top.equalToSuperview().offset(screenSize.height * 0.002)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(screenSize.height * 0.05)
        }
        addsearchBar.snp.makeConstraints { (make) in
            make.top.equalTo(addPlusButton.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(screenSize.height * 0.06)
        }
        poiTable.snp.makeConstraints { (make) in
            make.top.equalTo(addsearchBar.snp.bottom)
            make.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
    }
    private func addNavigationBar() {
        self.navigationItem.title = "POI"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        let textFont = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 25, weight: .medium)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textFont
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg"), style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = leftButton
        let myImage = UIImage(named: "Asset 8")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: myImage?.resizedImage(CGSize.init(width: 25, height: 25), interpolationQuality: .default)?.withRenderingMode(.alwaysOriginal),style: .plain, target: nil, action: nil)
    }
    
    @objc  func backButtonTapped() {
       self.dismiss(animated: true, completion: nil)
    }
    
    func deletePOIConformation (_ poiData: POIInfoDataModel) {
        let message = "Are you sure?"
        let alertController = UIAlertController(title: "Delete POI - (\(poiData.title ?? ""))".toLocalize, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes".toLocalize, style: .destructive, handler: { alert -> Void in
            self.deletePOIRequest(poiData)
        })
        
        alertController.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No".toLocalize, style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func deletePOIRequest(_ poiData: POIInfoDataModel) {
        RCLocalAPIManager.shared.deletePOIData(with: poiData.id ?? "0", loadingMsg: "Deleting POI, Please wait...",success: { (success) in
            self.prompt("POI successfully deleted.")
            self.getPOIDataRequest()
        }) { (failure) in
            print("failure in deleting POI")
        }
    }
    
}
extension POIViewController:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearching) {
            return filtered.count
        } else {
            return poiArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "poicell", for: indexPath)
        
        cell.textLabel?.textColor = appGreenTheme
        cell.backgroundColor = UIColor(red: 39/255, green: 38/255, blue: 59/255, alpha: 1)
        cell.selectionStyle = .none
        if(isSearching) {
            cell.textLabel?.text = filtered[indexPath.row].title
        } else {
            cell.textLabel?.text = poiArray[indexPath.row].title
        }
        return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title:  "DELETE",
                                        handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deletePOIConformation(self.isSearching ? self.filtered[indexPath.row] : self.poiArray[indexPath.row])
        })
//        let alert = UIAlertController(title: "Delete POI", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
//        let ok = UIContextualAction(style: .destructive, title: "CANCEL", handler: nil)
//        alert.addAction(delete)
//        alert.addAction(ok)
//        self.present(alert, animated: true, completion: nil)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        return UISwipeActionsConfiguration()
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddPOIViewController()
        vc.buttonText = "UPDATE"
        vc.isEdit = true
        vc.poiData = isSearching ? filtered[indexPath.row] : poiArray[indexPath.row]
        vc.poiVC = self
//        let controller = UINavigationController(rootViewController: vc)
//        //        controller.navigationBar.backgroundColor = .white
//        self.present(controller, animated: false, completion: nil)
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
}

extension POIViewController: POIDelegate {
    func tableReload () {
        if  let poidata = Defaults().get(for: Key<[POIInfoDataModel]> ("POI")) {
            self.poiArray = poidata
            self.poiTable.reloadData()
        }
    }
}
extension POIViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filtered = poiArray.filter({ (text) -> Bool in
                let tmp: NSString = text.title! as NSString
                let range = tmp.range(of: searchText, options: .caseInsensitive)
                return range.location != NSNotFound
            })
        }
        
        poiTable.reloadData()
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        addsearchBar.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        addsearchBar.endEditing(true)
    }

    
}


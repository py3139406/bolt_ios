//
//  TemplateVC.swift
//  Bolt
//
//  Created by Roadcast on 22/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

class TemplateVC: UIViewController {
    var templateView:TemplateView!
    var tempDataModel: [TemplateDataModel] = []
    var customDataModel: [TemplateDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getTemplates()
        setViews()
        setConstraints()
        setActions()
    }
    func getTemplates(){
        
        RCLocalAPIManager.shared.getTemplates(with: "Getting templates...") { (success) in
            print("\(success.description)")
            self.tempDataModel = success
            self.customDataModel = success
            self.templateView.tempTable.reloadData()
        } failure: { (failure) in
            print("\(failure.description)")
        }

    }
    func setActions(){
        templateView.plusBtn.addTarget(self, action: #selector(newtemplate(_:)), for: .touchUpInside)
        templateView.tempTable.register(TemplateTableCell.self, forCellReuseIdentifier: "tempCell")
        templateView.tempTable.delegate = self
        templateView.tempTable.dataSource = self
    }
    func setViews(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backTapped))
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = search
        } else {
            // Fallback on earlier versions
        }
        templateView = TemplateView()
        view.addSubview(templateView)
    }
    @objc func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    func setConstraints(){
        templateView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    @objc func newtemplate(_ sender:UIButton){
        let vc =  EditTemplateVC()
        vc.isEditingTemplate = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func editTemplate(_ sender:UIButton){
        let vc =  EditTemplateVC()
        let tempData:TemplateDataModel = tempDataModel[sender.tag]
        vc.templateData = tempData
        vc.isEditingTemplate = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func openTempDevices(_ sender:UIButton){
        let templateId = "\(String(describing: tempDataModel[sender.tag].id))"
        print("tempid = :\(templateId) for \(String(describing: tempDataModel[sender.tag].name))")
        let vc = AlertTableVC()
        RCLocalAPIManager.shared.getTemplateDevices(with: "Fetching...", tempId: templateId) { (success) in
            print("\(success.description)")
            var deviceArray:[String] = []
            for temp in success {
                let key = "Device_\(temp.deviceid)"
                if let device = Defaults().get(for: Key<TrackerDevicesMapperModel>(key)) {
                    deviceArray.append(device.name ?? "")
                }
            }
            vc.deviceNameArray = deviceArray
            if deviceArray.count == 0 {
                self.view.makeToast("no device found")
            }else {
                self.present(vc, animated: true, completion: nil)
            }
           
        } failure: { (failure) in
            print("\(failure.description)")
        }
    }

}
extension TemplateVC:  UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            self.customDataModel = []
            self.customDataModel = tempDataModel
            self.templateView.tempTable.reloadData()
        } else {
            let array = customDataModel.filter {
                return $0.name!.localizedCapitalized.range(of: searchText) != nil
            }
            self.customDataModel = array
            self.templateView.tempTable.reloadData()
        }
    }
}
extension TemplateVC:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customDataModel.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tempCell" ,for:indexPath) as! TemplateTableCell
        cell.selectionStyle = .none
        cell.tempName.text = customDataModel[indexPath.row].name
        cell.snValue.text = "\(indexPath.row + 1)"
        cell.editBtn.tag = indexPath.section
        cell.viewBtn.tag = indexPath.section
        cell.editBtn.addTarget(self, action: #selector(editTemplate(_:)), for: .touchUpInside)
        cell.viewBtn.addTarget(self, action: #selector(openTempDevices(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (screensize.height * 0.03 + 50)
    }
    
}
//extension TemplateVC {
//    func addDoneButtonOnKeyboard(){
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        templateView.searchBar.inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction(){
//        templateView.searchBar.endEditing(true)
//    }
//}

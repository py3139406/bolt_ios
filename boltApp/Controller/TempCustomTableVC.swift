//
//  TempCustomTableVC.swift
//  Bolt
//
//  Created by Roadcast on 28/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import DefaultsKit

enum selectionType:Int {
    case selectAll = 1
    case deselectAll = 0
}

class TempCustomTableVC: UIViewController {
    var customView:TempCustomTableView!
    var blurEffect:UIBlurEffect!
    var blurEffectView:UIVisualEffectView!
    var selectedDeviceArray:[String]?
    var totalDevices: [TrackerDevicesMapperModel] = []
    var seletionType:Int = 2
    var selectedTempDevices: [TrackerDevicesMapperModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        getAllDevices()
        setViews()
        setupAction()
    }
    func getAllDevices(){
        let data = Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
        for i in data {
            totalDevices.append(i)
            }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      //  let touch: UITouch? = touches.first
//        if touch?.view != self.customView {
            self.dismiss(animated: true, completion: nil)
    }
    func getDevices(){
//        let allDevices =  Defaults().get(for: Key<[TrackerDevicesMapperModel]>(defaultKeyNames.allDevices.rawValue)) ?? []
//        if allDevices.count > 0{
//            for temp in allDevices {
//                totalDevices.append(temp)
//            }
//        }
    }
    func setupAction(){
        customView.submitBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        customView.alertTable.register(UITableViewCell.self, forCellReuseIdentifier: "alertCell")
        customView.selectAllBtn.addTarget(self, action: #selector(selectAllDevices(_:)), for: .touchUpInside)
        customView.deselectBtn.addTarget(self, action: #selector(deselectAllDevices(_:)), for: .touchUpInside)
        customView.alertTable.delegate = self
        customView.alertTable.dataSource = self
    }
    @objc func selectAllDevices(_ sender: UIButton) {
        seletionType = 1
        selectionTypeUpdate()
    }
    @objc   func deselectAllDevices(_ sender:UIButton){
        seletionType = 0
        selectionTypeUpdate()
    }
    func reloadTable(){
        customView.alertTable.reloadData()
    }
    @objc func submitTapped(_ sender:UIButton){
        print("total selected device array : \(String(describing: self.selectedDeviceArray))")
        for i in totalDevices {
            if ((self.selectedDeviceArray?.contains(i.name ?? "")) != nil){
                self.selectedTempDevices.append(i)
            }
        }
        Defaults().set(self.selectedTempDevices, for: Key<[TrackerDevicesMapperModel]>("selectedTempDevices"))
        dismiss()
    }
    func setViews(){
        if #available(iOS 13.0, *) {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.systemUltraThinMaterialDark)
        } else {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        }
         blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        customView = TempCustomTableView(frame: view.bounds)
        view.addSubview(customView)
    }
     func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    func selectionTypeUpdate(){
        if seletionType == selectionType.selectAll.rawValue {
            for i in totalDevices{
                self.selectedDeviceArray?.append(i.name ?? "")
            }
            reloadTable()
//            Defaults().set(totalDevices, for: Key<[TrackerDevicesMapperModel]>("selectedTempDevices"))
        }
        else {
            self.selectedDeviceArray = []
            reloadTable()
        }
    }

}
extension TempCustomTableVC:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as UITableViewCell
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = totalDevices[indexPath.row].name
        cell.selectionStyle = .none
        if let array = self.selectedDeviceArray {
            if  array.contains(totalDevices[indexPath.row].name!){
                print("added: \(String(describing: totalDevices[indexPath.row].name))")
                cell.imageView?.image = #imageLiteral(resourceName: "green-tick").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)
            }else {
                print("Notadded: \(String(describing: totalDevices[indexPath.row].name))")
                cell.imageView?.image = #imageLiteral(resourceName: "circle-1").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)
            }
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath:IndexPath) -> CGFloat{
     return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print("selected: \(String(describing: totalDevices[indexPath.row].name))")
        if let array = self.selectedDeviceArray {
        if  !(array.contains(totalDevices[indexPath.row].name ?? "")){
            self.selectedDeviceArray?.append(totalDevices[indexPath.row].name!)
            cell?.imageView?.image = #imageLiteral(resourceName: "green-tick").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)
        }else{
            self.selectedDeviceArray = self.selectedDeviceArray?.filter({ $0 != totalDevices[indexPath.row].name})
            cell?.imageView?.image = #imageLiteral(resourceName: "circle-1").resizedImage(CGSize(width: 25, height: 25), interpolationQuality: .default)
        }
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return customView.footView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return customView.headView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
}

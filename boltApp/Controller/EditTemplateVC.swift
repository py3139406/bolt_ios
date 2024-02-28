//
//  EditTemplateVC.swift
//  Bolt
//
//  Created by Roadcast on 23/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit
import SnapKit
import DefaultsKit

class EditTemplateVC: UIViewController {
    var editTemplateView: EditTemplateView!
    let templateItem = ["Template Name","Selected Device","Ignition On","Ignition Off","Geofence enter","Geofence exit","Overspeed","Powercut","SOS","Reachability","Stoppage Alert"]
    let additionalItem = ["Alert repetition","Time Difference(mins)","Work Start","Work End"]
    let lastItem = ["Email"]
    var updatedList:[String] = []
    var isStoppageOpen:Bool = false
    var isEmailSaved:Bool = false
    var emailAddress:String = "pavanyadav@gmail.com"
    // footer
    var bgView:UIView!
    var emailLabel:UILabel!
    var isEditingTemplate:Bool = false
    var templateData:TemplateDataModel?
    var deviceNameArray:[String] = []
    var selecteDeviceArray:[String] = []
    var str = ""
    var templateDataDictionay = TemplateDataDict()
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditingTemplate {
            fetchingTempDevices()
        }
        updateItems()
        setViews()
        setConstraints()
        tableFooterView()
        setActions()
    }
    func setActions(){
        editTemplateView.tempTable.register(EditTemplateTableCell.self, forCellReuseIdentifier: "edittempCell")
        editTemplateView.tempTable.delegate = self
        editTemplateView.tempTable.dataSource = self
        editTemplateView.submitBtn.addTarget(self, action: #selector(updateOrSubmitTempData(edit:)), for: .touchUpInside)
    }
    func submitButtonTapped(){
        if ((templateData?.name?.isEmpty) != nil){
            self.view.makeToast("Name can not be empty")
            return
        }else if ((templateData?.email?.isEmpty) != nil){
            self.view.makeToast("Please enter valid emailId to be used for mail config.")
            return
        } else if templateData?.is_stoppage_alert == "1" && ((templateData?.st_alert_time_difference?.isEmpty) != nil){
            self.view.makeToast("time difference field can not be empty.")
            return
        } else if deviceNameArray.count == 0 {
            self.view.makeToast("Please select at-least one device.")
            return
        }else {
            
        }
    }
    @objc func updateOrSubmitTempData(edit:Bool){
        let selectedDevices:[String:Any] = [:]
        let unSelectedDevices:[String:Any] = [:]
        let parameters:[String:Any] = ["deviceId":selectedDevices,"name":templateData?.name,"ignition_on":templateData?.ignition_on,"ignition_off":templateData?.ignition_off,"geofence_enter":templateData?.geofence_enter,"geofence_exit":templateData?.geofence_exit,"overspeed":templateData?.overspeed,"sos":templateData?.sos,"power_cut":templateData?.power_cut,"geo_scheduling":templateData?.geo_scheduling,"st_alert_repetition":templateData?.st_alert_repetition,"st_alert_time_difference":templateData?.st_alert_time_difference,"st_work_start_time":templateData?.st_work_start_time,"st_work_end_time":templateData?.st_work_end_time,"is_stoppage_alert":templateData?.is_stoppage_alert,"is_sms":templateData?.is_sms,"is_mail":templateData?.is_mail,"mobile":templateData?.mobile,"email":templateData?.email,"userid":templateData?.userid,"unlinkedDeviceIds":unSelectedDevices]
        
        if edit{
            RCLocalAPIManager.shared.updateTemplateData(with: parameters, id: templateData!.id ?? "", loadingMsg: "updating...") { (success) in
                self.view.makeToast("successfully updated...")
                self.backTapped()
            } failure: { (failure) in
                print("failed reason:\(failure.description)")
                self.view.makeToast("please try again...")
            }

            
        }else {
            
        }
    }
    func setViews(){
        self.navigationItem.title = "Templates"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backimg").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backTapped))
        
        editTemplateView = EditTemplateView()
        view.addSubview(editTemplateView)
    }
    func tableFooterView(){
        bgView = UIView()
        bgView.backgroundColor = appDarkTheme
        
        emailLabel = UILabel()
        emailLabel.textColor = .black
        emailLabel.textAlignment = .center
        emailLabel.backgroundColor = .white
        emailLabel.layer.cornerRadius = 5
        emailLabel.layer.masksToBounds = true
        bgView.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        // constraints
    }
    override func viewWillAppear(_ animated: Bool) {
        let selectedDevices = Defaults().get(for: Key<[TrackerDevicesMapperModel]>("selectedTempDevices")) ?? []
        if selectedDevices.count > 0 {
            
            if selecteDeviceArray.count > 0 {
                str = ""
                for i in selectedDevices{
                    str = str + "," + (i.name ?? "")
                }
            }
        }else if selecteDeviceArray.count > 0 {
            str = ""
            for i in selecteDeviceArray{
                str = str + "," + i
            }
        }else{
            str = "No device selected"
        }
    }

    func updateItems(){
        updatedList = []
        updatedList.append(contentsOf: templateItem)
        if let data = templateData {
            if data.is_stoppage_alert == "1" {
                updatedList.append(contentsOf: additionalItem)
            }
        }else {
            if templateDataDictionay.is_stoppage_alert == "1" {
                updatedList.append(contentsOf: additionalItem)
            }
        }
        updatedList.append(contentsOf: lastItem)
    }
    func reloadTable(){
        isEditingTemplate = false
        editTemplateView.tempTable.reloadData()
    }
    @objc func backTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    func setConstraints(){
        editTemplateView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    @objc func cellBtnTapped(_ sender:UIButton){
        print("\(updatedList[sender.tag]) button tappped")
        switch updatedList[sender.tag] {
        case "Ignition On" :
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    templateData?.ignition_on = "1"
                  templateDataDictionay.ignition_on = "1"
                    reloadTable()
                }else {
                    templateData?.ignition_on = "0"
                    templateDataDictionay.ignition_on = "0"
                    reloadTable()
                }
            break
        case "Ignition Off":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.ignition_off = "1"
                templateDataDictionay.ignition_off = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.ignition_off = "0"
                    templateDataDictionay.ignition_off = "0"
                    reloadTable()
                }
            break
        case "Geofence enter":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.geofence_enter = "1"
                templateDataDictionay.geofence_enter = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.geofence_enter = "0"
                    templateDataDictionay.geofence_enter = "0"
                    reloadTable()
                }
            break
        case "Geofence exit":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.geofence_exit = "1"
                templateDataDictionay.geofence_exit = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.geofence_exit = "0"
                    templateDataDictionay.geofence_exit = "0"
                    reloadTable()
                }
            break
        case "Overspeed":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.overspeed = "1"
                templateDataDictionay.overspeed = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.overspeed = "0"
                    templateDataDictionay.overspeed = "0"
                    reloadTable()
                }
            break
        case "Powercut":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.power_cut = "1"
                templateDataDictionay.power_cut = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.power_cut = "0"
                    templateDataDictionay.power_cut = "0"
                    reloadTable()
                }
            break
        case "SOS":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.sos = "1"
                templateDataDictionay.sos = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.sos = "0"
                    templateDataDictionay.sos = "0"
                    reloadTable()
                }
            break
        case "Reachability":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.geo_scheduling = "1"
                templateDataDictionay.geo_scheduling = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.geo_scheduling = "0"
                    templateDataDictionay.geo_scheduling = "0"
                    reloadTable()
                }
            break
        case "Stoppage Alert":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.is_stoppage_alert = "1"
                templateDataDictionay.is_stoppage_alert = "1"
                    updateItems()
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.is_stoppage_alert = "0"
                    templateDataDictionay.is_stoppage_alert = "0"
                    updateItems()
                    reloadTable()
                }
            break
        case "Alert repetition":
            if sender.currentImage == #imageLiteral(resourceName: "newRedNotification"){
                    sender.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    templateData?.st_alert_repetition = "1"
                templateDataDictionay.st_alert_repetition = "1"
                    reloadTable()
                }else {
                    sender.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    templateData?.st_alert_repetition = "0"
                    templateDataDictionay.st_alert_repetition = "0"
                    reloadTable()
                }
            break
        case "Time Difference(mins)":
            break
        case "Work Start":
            break
        case "Work End":
            break
        case "Email":
            if let tempData = templateData{
                if sender.currentImage == #imageLiteral(resourceName: "onlineNotificationicon.png"){
                    let alert = UIAlertController(title: "Enter email", message: "", preferredStyle: .alert )
                    let cancel =  UIAlertAction(title: "CANCEL", style: .cancel, handler: {_ in
                    })
                    alert.addTextField { (textfield) in
                        textfield.text = tempData.email
                    }
                    let save = UIAlertAction(title: "SAVE", style: .default) { (_) in
                        let textField = alert.textFields![0]
                        if !((textField.text?.isValidEmail())!){
                            self.view.makeToast("please enter valid mail")
                        }else {
                            tempData.email = textField.text  ?? self.templateDataDictionay.email
                            tempData.is_mail = "0"
                            self.reloadTable()
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(save)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "Enter email", message: "", preferredStyle: .alert )
                    let cancel =  UIAlertAction(title: "CANCEL", style: .cancel, handler: {_ in
                    })
                    alert.addTextField { (textfield) in
                        textfield.text = tempData.email ?? self.templateDataDictionay.email
                    }
                    let save = UIAlertAction(title: "SAVE", style: .default) { (_) in
                        let textField = alert.textFields![0]
                        if !((textField.text?.isValidEmail())!){
                            self.view.makeToast("please enter valid mail")
                        }else {
                            tempData.email = textField.text ?? ""
                            tempData.is_mail = "1"
                            self.reloadTable()
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(save)
                    self.present(alert, animated: true, completion: nil)
                }
            }else {
                if sender.currentImage == #imageLiteral(resourceName: "onlineNotificationicon.png") {
                    let alert = UIAlertController(title: "Enter email", message: "", preferredStyle: .alert )
                    let cancel =  UIAlertAction(title: "CANCEL", style: .cancel, handler: {_ in
                    })
                    alert.addTextField { (textfield) in
                        textfield.text = self.templateDataDictionay.email
                    }
                    let save = UIAlertAction(title: "SAVE", style: .default) { (_) in
                        let textField = alert.textFields![0]
                        if !((textField.text?.isValidEmail())!){
                            self.view.makeToast("please enter valid mail")
                        }else {
                            self.templateDataDictionay.email = textField.text  ?? ""
                            self.templateDataDictionay.is_mail = "0"
                            self.reloadTable()
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(save)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "Enter email", message: "", preferredStyle: .alert )
                    let cancel =  UIAlertAction(title: "CANCEL", style: .cancel, handler: {_ in
                    })
                    alert.addTextField { (textfield) in
                        textfield.text = self.templateDataDictionay.email
                    }
                    let save = UIAlertAction(title: "SAVE", style: .default) { (_) in
                        let textField = alert.textFields![0]
                        if !((textField.text?.isValidEmail())!){
                            self.view.makeToast("please enter valid mail")
                        }else {
                            self.templateDataDictionay.email = textField.text ?? ""
                            self.templateDataDictionay.is_mail = "1"
                            self.reloadTable()
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(save)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            break
        default:
            break
        }
    }
     func fetchingTempDevices(){
        let templateId = "\(String(describing: templateData!.id))"
        RCLocalAPIManager.shared.getTemplateDevices(with: "", tempId: templateId) { (success) in
            print("\(success.description)")
            for temp in success {
                let key = "Device_\(temp.deviceid)"
                if let device = Defaults().get(for: Key<TrackerDevicesMapperModel>(key)) {
                    self.selecteDeviceArray.append(device.name ?? "")
                }
            }
            self.deviceNameArray = self.selecteDeviceArray
            
        } failure: { (failure) in
            print("\(failure.description)")
        }
    }
    func selectDevices(){
        let vc = TempCustomTableVC()
        vc.selectedDeviceArray = self.selecteDeviceArray
        self.present(vc, animated: true, completion: nil)
        
    }
    func showTimePicker(work:String){
        let vc  = ShowDateOrTimerVC()
        vc.workType = work
        self.present(vc, animated: true, completion: nil)
    }
}
extension EditTemplateVC:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("selected text is \(textField.text)")
        switch textField.tag {
        case 0:
            self.templateDataDictionay.name = textField.text ?? ""
            self.templateData?.name = textField.text ?? ""
            self.editTemplateView.tempTable.reloadData()
            break
        case 1:
            self.templateDataDictionay.st_alert_time_difference = textField.text ?? ""
            self.templateData?.st_alert_time_difference = textField.text ?? ""
            self.editTemplateView.tempTable.reloadData()
            break
        default:
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
extension EditTemplateVC:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updatedList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edittempCell") as! EditTemplateTableCell
        cell.selectionStyle = .none
        cell.leftLabel.text = updatedList[indexPath.row]
        cell.tempBtn.tag = indexPath.row
        cell.tempBtn.addTarget(self, action: #selector(cellBtnTapped(_:)), for: .touchUpInside)
        cell.tempTextField.delegate = self
        
        switch updatedList[indexPath.row] {
        case "Template Name":
            cell.tempTextField.isHidden = false
            cell.tempBtn.isHidden = true
            cell.tempLabel.isHidden = true
            cell.tempTextField.placeholder = "name"
            cell.tempTextField.tag = 0
            cell.tempTextField.text = templateData?.name ?? templateDataDictionay.name
            break
        case "Selected Device" :
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = true
            cell.tempLabel.isHidden = false
            cell.tempLabel.text = str
            break
        case "Ignition On" :
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true
            
            if let tempData = templateData {
            if tempData.ignition_on == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.ignition_on == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Ignition Off":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true
            
            if let tempData = templateData {
            if tempData.ignition_off == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.ignition_off == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Geofence enter":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.geofence_enter == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.geofence_enter == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Geofence exit":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.geofence_exit == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.geofence_exit == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Overspeed":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.overspeed == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.overspeed == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Powercut":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.power_cut == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.power_cut == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "SOS":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.sos == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.sos == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Reachability":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.geo_scheduling == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.geo_scheduling == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Stoppage Alert":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.is_stoppage_alert == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.is_stoppage_alert == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Alert repetition":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.st_alert_repetition == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.st_alert_repetition == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
        case "Time Difference(mins)":
            cell.tempTextField.isHidden = false
            cell.tempBtn.isHidden = true
            cell.tempLabel.isHidden = true
            cell.tempTextField.tag = 0
            cell.tempTextField.text = templateData?.st_alert_time_difference ?? templateDataDictionay.st_alert_time_difference
            break
        case "Work Start":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = true
            cell.tempLabel.isHidden = false
            cell.tempLabel.text = templateData?.st_work_start_time ?? templateDataDictionay.st_work_start_time
            break
        case "Work End":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = true
            cell.tempLabel.isHidden = false
            cell.tempLabel.text = templateData?.st_work_end_time ?? templateDataDictionay.st_work_end_time
            break
        case "Email":
            cell.tempTextField.isHidden = true
            cell.tempBtn.isHidden = false
            cell.tempLabel.isHidden = true

            if let tempData = templateData {
            if tempData.is_mail == "1"{
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                }else {
                    cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                }
            } else {
                if templateDataDictionay.is_mail == "1"{
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "onlineNotificationicon.png"), for: .normal)
                    }else {
                        cell.tempBtn.setImage(#imageLiteral(resourceName: "newRedNotification"), for: .normal)
                    }
            }
            break
            
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if updatedList[indexPath.row] == "Selected Device" {
            selectDevices()
        }else if updatedList[indexPath.row] == "Work Start" {
            showTimePicker(work: "start")
        }else if updatedList[indexPath.row] == "Work End" {
            showTimePicker(work: "end")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let data = templateData {
            self.emailLabel.text = data.email
            if data.is_mail == "1" {
                return bgView
            }else {
                return UIView()
            }
        } else{
            self.emailLabel.text = templateDataDictionay.email
            if templateDataDictionay.is_mail == "1" {
                return bgView
            }else {
                return UIView()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let data = templateData {
            if data.is_mail == "1" {
                return 50
            }else {
                return 10
            }
        }else {
            if templateDataDictionay.is_mail == "1" {
                return 50
            }else {
                return 10
            }
        }
    }
}


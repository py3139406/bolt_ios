//
//  AlertTableVC.swift
//  Bolt
//
//  Created by Roadcast on 26/12/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class AlertTableVC: UIViewController {
    var alertView:AlertTableView!
    var deviceNameArray: [String] = []
    var bgView:UIView!
    var dismissBtn:UIButton!
    var bgView2:UIView!
    var titleLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(white: 0.5, alpha: 0.4)
        setViews()
        setConstraints()
      //  tableFooterView()
        tableHeaderView()
        setupAction()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view != self.alertView.alertTable {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setupAction(){
        alertView.alertTable.register(UITableViewCell.self, forCellReuseIdentifier: "alertCell")
        alertView.alertTable.delegate = self
        alertView.alertTable.dataSource = self
        alertView.dismissBtn.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
    }
    func setViews(){
        alertView = AlertTableView()
        view.addSubview(alertView)
    }
    func setConstraints(){
        alertView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    @objc func dismiss(sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    func tableFooterView(){
        bgView = UIView()
        bgView.backgroundColor = .white
        
        dismissBtn = UIButton()
        dismissBtn.setTitle("Dismiss", for: .normal)
        dismissBtn.setTitleColor(.white, for: .normal)
        dismissBtn.backgroundColor = appGreenTheme
        dismissBtn.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
        bgView.addSubview(dismissBtn)
        
        dismissBtn.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    func tableHeaderView(){
        bgView2 = UIView()
        bgView2.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.text = "Devices"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = appGreenTheme
        bgView2.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}
extension AlertTableVC:UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as UITableViewCell
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = deviceNameArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath:IndexPath) -> CGFloat{
     return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return bgView2
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

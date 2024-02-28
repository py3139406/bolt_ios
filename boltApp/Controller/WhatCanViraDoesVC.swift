//
//  WhatCanViraDoesVC.swift
//  Bolt
//
//  Created by Vivek Kumar on 29/06/20.
//  Copyright © 2020 Arshad Ali. All rights reserved.
//

import UIKit

class WhatCanViraDoesVC: UIViewController {
    var whatCanViraDo: WhatViraCanDoView!
    var orders: ViraTableViewCell!
    var cell = "cell"
    let resueIdentifier = "vira"
    let titleTextData:[String] = ["Tell you the location of your vehicle" ,"Immobilize your vehicle" , "Turn on Parking Mode"]
    let subTitleTextData: [String] = ["eg. ask\"where is my car?\"" ,"eg. ask\"immobilize my car?\"","eg. ask\"turn on parking mode?\""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        whatCanViraDo = WhatViraCanDoView()
        whatCanViraDo.backgroundColor = .white
        view.addSubview(whatCanViraDo)
        setConstraints()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        addTableView()
    }
    func setConstraints(){
        whatCanViraDo.snp.makeConstraints { (make) in
        if #available(iOS 11.0, *) {
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        } else {
            make.edges.equalToSuperview()
            // Fallback on earlier versions
        }
    }
    }
    func addTableView()
    {
        whatCanViraDo.CustomTableview.register(ViraTableViewCell.self, forCellReuseIdentifier: "cell")
        whatCanViraDo.CustomTableview.delegate = self
        whatCanViraDo.CustomTableview.dataSource = self
        whatCanViraDo.CustomTableview.isScrollEnabled = false
        whatCanViraDo.CustomTableview.tableFooterView = UIView()
    }
    
}
extension WhatCanViraDoesVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleTextData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        orders = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ViraTableViewCell
        orders.titleLabel.text = titleTextData[indexPath.row]
        orders.subtitleLabel.text = subTitleTextData[indexPath.row]
        orders.selectionStyle = .none
        orders.backgroundColor  = .white
        return orders
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


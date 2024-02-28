//
//  RCDropDownView.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

//protocol BranchSelectorDelegate: class{
//    func didSelect(branch: RCAdminDetailModel?)
//}
//
//class RCDropDownView: UIView, UITableViewDelegate, UITableViewDataSource{
//    
//    weak var delegate:BranchSelectorDelegate?
//    private var tableView = UITableView()
//    fileprivate  var button = UIButton(type:.custom)
//    open var isSelected:Bool = false
//
//    fileprivate var dataSource: [String] = ["All Employees"]
//    fileprivate var arrayList: [RCAdminDetailModel]!
//
//    private let CellIdentifier = "employeeIdentifier"
//    
//    override init(frame: CGRect) {
//        super.init(frame:frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    public func showDropDown(dropDownButton: UIButton, withHeight:CGFloat, arrayData: [RCAdminDetailModel]) -> Void {
//        isSelected = true
//        backgroundColor = UIColor.red
//        button = dropDownButton
//        arrayList  = arrayData
//        for employee in arrayData {
//            dataSource.append(employee.firstname!)
//        }
//
//        let buttonframe:CGRect = button.frame
//        tableView.backgroundColor = .clear
//        tableView.frame = CGRect(x:buttonframe.origin.x, y:buttonframe.origin.y + buttonframe.size.height, width:buttonframe.size.width, height:withHeight)
//        tableView.rowHeight = 40
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier:CellIdentifier)
//        tableView.layer.shadowColor = UIColor.black.cgColor
//        tableView.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(0))
//        tableView.layer.shadowRadius = 5.0
//        tableView.layer.shadowOpacity = 1
//        self.tableView.clipsToBounds = false
//        self.tableView.layer.masksToBounds = false
//        
//        dropDownButton.superview?.addSubview(tableView)
//    }
//    
//    public func hideDropDownMenu(dropDownButton:UIButton) -> Void {
//        isSelected = false
//        tableView.removeFromSuperview()
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell =  self.tableView.dequeueReusableCell(withIdentifier:CellIdentifier, for:indexPath)
//            cell.textLabel?.textColor = .black
//            cell.textLabel?.text = dataSource[indexPath.row]
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at:indexPath, animated:true)
//        hideDropDownMenu(dropDownButton:button)
//        if indexPath.row == 0 {
//            delegate?.didSelect(branch: nil)
//        } else {
//            delegate?.didSelect(branch: arrayList[indexPath.row - 1])
//        }
//        
//        let cellOption = tableView.cellForRow(at:indexPath)
//        button.setTitle(cellOption?.textLabel?.text, for:.normal)
//    }
//}


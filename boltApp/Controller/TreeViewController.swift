//
//  TreeViewController.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit
import RATreeView
import SnapKit
import DefaultsKit

protocol SelectedUserHierarchyDelegate: class {
    func selectedUser(userId: String?, userName: String?)
}
class TreeViewController: UIViewController {
    var treeView : RATreeView!
    var data : [DataObject] = []
    var editButton : UIBarButtonItem!
    var topTitleLabel: UILabel!
    var button_OnTopLevel: UIButton!
    var selectedUserId: String!
    var isReportView: Bool = false
    
    static let usersHierarchy:UsersHerarchy = Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy"))!
    
    let usersHierarchy:UsersHerarchy = Defaults().get(for: Key<UsersHerarchy>("UsersHerarchy"))!
    
    convenience init() {
        self.init(nibName : nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        data = TreeViewController.commonInit()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        data = TreeViewController.commonInit()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appDarkTheme
        setUpTopTitleView()
        setupTreeView()
        addConstrants()
        self.button_OnTopLevel.addTarget(self, action: #selector(backButtonAction(sender:)), for: .touchUpInside)
    }
    
    func setupTreeView() -> Void {
        treeView = RATreeView(frame: CGRect.zero)
        treeView.register(TreeTableViewCell.self, forCellReuseIdentifier: "cellId")
        treeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = UIView()
        treeView.separatorColor = .black
        treeView.allowsSelection = true
        treeView.allowsMultipleSelection = true
        treeView.backgroundColor = appDarkTheme
        view.addSubview(treeView)
    }
    
    func setUpTopTitleView(){
        topTitleLabel = UILabel(frame: CGRect.zero)
        topTitleLabel.text = "Users/Vehicles".toLocalize
        topTitleLabel.textAlignment = .center
        topTitleLabel.backgroundColor = .white
        topTitleLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(topTitleLabel)
        
        button_OnTopLevel = UIButton(frame: CGRect.zero)
        button_OnTopLevel.setImage(#imageLiteral(resourceName: "backimg"), for: .normal)
        view.addSubview(button_OnTopLevel)
    }
    func addConstrants(){
        topTitleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            make.width.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.08)
        }
        button_OnTopLevel.snp.makeConstraints { (make) in
            make.left.equalTo(topTitleLabel).offset(20)
            make.top.equalTo(topTitleLabel)
            make.height.equalTo(topTitleLabel)
            make.width.equalTo(50)
        }
        treeView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo(topTitleLabel.snp.bottom)
            if #available(iOS 11, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
    }
    @objc func backButtonAction(sender:UIButton) {
        if isReportView {
         NewReportViewController().selectedUser(userId: selectedUserId, userName: topTitleLabel.text)
        } else {
         VehicleViewController().selectedUser(userId: selectedUserId, userName: topTitleLabel.text)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func editButtonTapped(_ sender: AnyObject) -> Void {
        treeView.setEditing(!treeView.isEditing, animated: true)
    }
}
extension TreeViewController: RATreeViewDelegate, RATreeViewDataSource {
    
    //MARK: RATreeView data source
    func treeView(_ treeView: RATreeView, numberOfChildrenOfItem item: Any?) -> Int {
        if let item = item as? DataObject {
            return item.children.count
        } else {
            return self.data.count
        }
    }
    func treeView(_ treeView: RATreeView, child index: Int, ofItem item: Any?) -> Any {
        if let item = item as? DataObject {
            return item.children[index]
        } else {
            return data[index] as AnyObject
        }
    }
    func treeView(_ treeView: RATreeView, cellForItem item: Any?) -> UITableViewCell {
        let cell = treeView.dequeueReusableCell(withIdentifier: "cellId") as! TreeTableViewCell
        let item = item as! DataObject
        
        let level = treeView.levelForCell(forItem: item)
        
        let selectedBranchId:String = Defaults().get(for: Key<String>(defaultKeyNames.selectedBranch.rawValue)) ?? "0"
        
        if selectedBranchId == item.id {
            cell.selectionBtn.setImage(UIImage(named: "green-tick"), for: .normal)
        } else {
            cell.selectionBtn.setImage(UIImage(named: "circle-1"), for: .normal)
        }
        
        let childCount:Int = RCGlobals.getChildListForBranch(branchId: item.id).count
        cell.dropDownIcon.isHidden = true
      //  let detailText = "Number of children \(item.children.count)"
        if  childCount > 0 {
            cell.dropDownIcon.isHidden = false
            let img = RCGlobals.imageRotatedByDegrees(oldImage: UIImage(named: "backimg-1")!, deg: 90)
            cell.dropDownIcon.image = img
        }
        cell.selectionStyle = .none
        cell.setup(withTitle: item.name + "(\(childCount))", detailsText: "", level: level)
        cell.additionButtonActionBlock = { [weak treeView] cell in
            guard let treeView = treeView else {
                return;
            }
            let item = treeView.item(for: cell) as! DataObject
            let newItem = DataObject(name: "Added value", id:"")
            item.addChild(newItem)
            treeView.insertItems(at: IndexSet(integer: item.children.count-1), inParent: item, with: RATreeViewRowAnimationNone);
            treeView.reloadRows(forItems: [item], with: RATreeViewRowAnimationNone)
        }
        return cell
    }
    func treeView(_ treeView: RATreeView, canEditRowForItem item: Any) -> Bool {
        return false
    }
    func treeView(_ treeView: RATreeView, commit editingStyle: UITableViewCellEditingStyle, forRowForItem item: Any) {
             
            guard editingStyle == .delete else { return; }
            let item = item as! DataObject
            let parent = treeView.parent(forItem: item) as? DataObject

            let index: Int
            if let parent = parent {
                index = parent.children.index(where: { dataObject in
                    return dataObject === item
                })!
                parent.removeChild(item)

            } else {
                index = self.data.index(where: { dataObject in
                    return dataObject === item;
                })!
                self.data.remove(at: index)
            }

            self.treeView.deleteItems(at: IndexSet(integer: index), inParent: parent, with: RATreeViewRowAnimationRight)
            if let parent = parent {
                self.treeView.reloadRows(forItems: [parent], with: RATreeViewRowAnimationNone)
            }
        }
    func treeView(_ treeView: RATreeView, heightForRowForItem item: Any) -> CGFloat {
        return 70
    }
    func treeView(_ treeView: RATreeView, didSelectRowForItem item: Any) {
        
        let selectedCell: DataObject = item as! DataObject
        
        topTitleLabel.text = selectedCell.name
        selectedUserId = selectedCell.id
        let cell1 = treeView.cell(forItem: item) as! TreeTableViewCell
        cell1.selectionBtn.setImage(UIImage(named: "checked"), for: .normal)
        
        let cell = treeView.dequeueReusableCell(withIdentifier: "cellId") as! TreeTableViewCell
        let level = treeView.levelForCell(forItem: item)
        
        let selLevelUsers = usersHierarchy.allUsers.filter{$0.parentId == selectedCell.id}
        
        if selLevelUsers.count > 0 {
            cell.selectionStyle = .none
            
            cell.setup(withTitle: selectedCell.name, detailsText: "", level: level)
            
            for user in selLevelUsers[0].parentUsers {
                
                if !selectedCell.children.contains{ $0.id == user.childId} {
                    let newItem = DataObject(name: user.childName!, id: user.childId!)
                    selectedCell.addChild(newItem)
                    treeView.insertItems(at: IndexSet(integer: selectedCell.children.count-1), inParent: selectedCell, with: RATreeViewRowAnimationNone);
                    treeView.reloadRows(forItems: [selectedCell], with: RATreeViewRowAnimationNone)
                }
            }
        } else {
            if isReportView {
                NewReportViewController().selectedUser(userId: selectedUserId, userName: topTitleLabel.text)
            } else {
                VehicleViewController().selectedUser(userId: selectedUserId, userName: topTitleLabel.text)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}



private extension TreeViewController {
    
    static func commonInit() -> [DataObject] {
        
        let userDetails = Defaults().get(for: Key<LoginResponseModel>("LoginResponseModel"))?.data
        
        let firstLevelUsers = usersHierarchy.allUsers.filter{$0.parentId == userDetails?.id}
        
        if firstLevelUsers.count == 0 {
            return []
        }
        var users:[DataObject] = []
        if firstLevelUsers.count != 0 {
        for user in firstLevelUsers[0].parentUsers {
            users.append(DataObject(name: user.childName!, id: user.childId!))
        }
        }
        let parentUser:DataObject = DataObject(name: userDetails?.name ?? "", id: (userDetails?.id)!, children: users)
        
        return [parentUser]
    }
    
}



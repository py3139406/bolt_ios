//
//  File.swift
//  findMe
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

extension UIView {

    func createAndAddSubView(view:String) -> AnyObject{
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String;
        let temporaryView = NSClassFromString(namespace+"."+view) as! UIView.Type
        let insetView = temporaryView.init()
        insertSubview(insetView, at:subviews.count)
        return insetView
    }

   func create(subView:String) -> AnyObject{
    let temporaryView = NSClassFromString(subView) as! UIView.Type
    let insetView = temporaryView.init()
    insertSubview(insetView, at:subviews.count)
    return insetView
   
  }

}

extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
}


extension UINavigationBar {
    
    func leftBarItem() -> [UIImageView] {
        var items = [UIImageView]()
        
        for view in self.subviews {
            if view.isKind(of: NSClassFromString("UINavigationButton")!) {
                for subview in view.subviews {
                    subview.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    items.append(subview as! UIImageView)
                }
            }
        }
        
        return items 
    }
    
    
}

//- (id)createAndAddSubView:(Class)modelClass {
//    id temporaryView = [modelClass new];
//    [self insertSubview:(UIView *)temporaryView atIndex:self.subviews.count];
//    return temporaryView;
//}

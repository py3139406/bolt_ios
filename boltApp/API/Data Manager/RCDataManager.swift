//
//  RCDataManager.swift
//  RCLocatorSample
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation

class RCDataManager : NSObject {
    
    static func set(value:Any ,forKey: String) -> Void {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: forKey)
    }
    
    static func set(string:String ,forKey: String) -> Void {
        UserDefaults.standard.set(string, forKey:forKey)
    }
    
    static func get(objectforKey:String) -> Any? {
        if UserDefaults.standard.object(forKey: objectforKey) != nil {
            return NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: objectforKey) as! Data)
        }
        return nil
    }
    
    static func get(stringforKey:String) -> String? {
        return UserDefaults.standard.object(forKey:stringforKey) as? String
    }
    
    static func delete(objectforKey:String) -> Void {
        UserDefaults.standard.set(nil, forKey: objectforKey)
    }
}

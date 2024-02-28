//
//  UsersHierarchy.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import UIKit

class UsersHerarchy: NSObject, Codable {
    var allUsers:[ParentUsers] = []
}

class ParentUsers: NSObject, Codable {
    var parentUsers: [ChildUsers] = []
    var parentId: String?
}

class ChildUsers : NSObject, Codable{
    
    var childUserDevices: UserDevices?
    var childId: String?
    var childName: String?
}

class UserDevices: NSObject, Codable{
    var devices: [String] = []
}

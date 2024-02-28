//
//  DBManager.swift
//  Synco
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import RealmSwift

class DBManager {
   
    private var database: Realm!
    static let shared = DBManager()
    
    private init() {
         database = try! Realm()
    }
    
    func getResults(RealmObject: Object.Type) -> Results<Object> {
        let results = database.objects(RealmObject.self)
        return results
    }

    func addData(object: Object) {
        try! database.write {
            database.add(object)
//            print("Added new object")
        }
    }
    
    func addDataUpdate(object: Object) {
        try! database.write {
            database.add(object, update: true)
        }
//        print("updated")
    }
    
    func deleteAllFromDatabase() {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: Object) {
        try! database.write {
            database.delete(object)
        }
    }
}


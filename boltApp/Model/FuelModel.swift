//
//  FuelModel.swift
//  Bolt
//
//  Created By Anshul Jain on 25-March-2019
//Copyright © Roadcast Tech Solutions Private Limited
//

import Foundation
import RealmSwift

class FuelModel: Object {

    @objc dynamic var odometer: Double = 0.0
    @objc dynamic var fuel: Double = 0.0
    @objc dynamic var currentOdometer: Double = 0.0
    @objc dynamic var currentFuel: Double = 0.0
    @objc dynamic var milage: Double = 0.0
    @objc dynamic var deviceId: Int = 0
    @objc dynamic var fuelType: String?
    @objc dynamic var lastFilledDate: String?
    @objc dynamic var lastFilledAmount: String?
    @objc dynamic var paymentType: String?
    @objc dynamic var imageBill: String?
    
    override static func primaryKey() -> String? {
        return "deviceId"
    }
}

class FuelHistoryModel: Object {
    @objc dynamic var date: String?
    @objc dynamic var deviceId: Int = 0
    @objc dynamic var price: Double = 0.0
    @objc dynamic var fill: Double = 0.0
    @objc dynamic var total: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "date"
    }
}

//
//  RCTransformer.swift
//  Bus993
//
//  Created By Anshul Jain on 25-March-2019
//  Copyright © Roadcast Tech Solutions Private Limited
//

import CoreLocation
import ObjectMapper

/// Date transformer with format "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
class StudentDOBTransformer: TransformType {
    
    typealias Object = Date
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Date? {
        let sample = value as? String
        let hero = sample!
        print(sample ?? hero)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let formattedDate: Date? = dateFormatter.date(from: hero)
        return formattedDate
    }
    
    func transformToJSON(_ value: Date?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone.system
        let dateString = dateFormatter.string(from:value!)
        return dateString
    }
    
}

/// Boolean transformer for status key in JSON
class RCStatusTransformer: TransformType {
    
    typealias Object = Bool
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Bool? {
        if (value as? String)! == "success" {
            return true
        }
        return false
    }
    
    func transformToJSON(_ value: Bool?) -> String? {
        if value! {
            return "success"
        }
        return "error"
    }
    
}

/// Generic String to Integer transformer
class RCIntegerTransformer: TransformType {
    
    typealias Object = Int
    typealias JSON = String

    func transformFromJSON(_ value: Any?) -> Int? {
        if let numberString = value as? String {
           return Int(numberString)
        }
        return nil
    }
    
    func transformToJSON(_ value: Int?) -> String? {
        return String(value!)
    }
    
}

class RCInteger64Transformer: TransformType {
    
    typealias Object = Int64
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Int64? {
        if let numberString = value as? String {
            return Int64(numberString)
        }
        return nil
    }
    
    func transformToJSON(_ value: Int64?) -> String? {
        return String(value!)
    }
    
}


/// Generic String to Double transformer
class RCDoubleTransformer: TransformType {
    
    typealias Object = Double
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Double? {
        if let numberString = value as? String {
            return Double(numberString)
        }
        return nil
    }
    
    func transformToJSON(_ value: Double?) -> String? {
        return String(value!)
    }
    
}

/// Generic String to Integer transformer
class RCBooleanTransformer: TransformType {
    
    typealias Object = Bool
    typealias JSON = Int
    
    func transformFromJSON(_ value: Any?) -> Bool? {
        if let number = value as? Int {
            return number == 1 ? true : false
        }
        return false
    }
    
    func transformToJSON(_ value: Bool?) -> Int? {
        return value! ? 0 : 1
    }
    
}

/// Unix date to Notification date conversion
//class RCUnixTransformer: TransformType {
//
//    typealias Object = String
//    typealias JSON = String
//
//    func transformFromJSON(_ value: Any?) -> String? {
//        if let timestamp = value as? String {
//            return RCGlobals.convert(string: timestamp)
//        }
//        return ""
//    }
//
//    func transformToJSON(_ value: String?) -> String? {
//        return ""
//    }
//
//}


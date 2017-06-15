//
//  UserInfo.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/13/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation

class UserInfo {
    var uid: String?
    var userName: String?
    var photoURL: String?
    var whatsup: String?
    var dateOfBirth: String?
    var phoneNumber: String?
    var zipCode: String?
    var sales: [ItemInfo]?
    
    /// Init for new created user
    init?(uid: String,
          userName: String,
          photoURL: String,
          whatsup: String,
          dateOfBirth: String,
          phoneNumber: String,
          zipCode: String) {
        
        self.uid = uid
        self.userName = userName
        self.photoURL = photoURL
        self.whatsup = whatsup
        self.dateOfBirth = dateOfBirth
        self.phoneNumber = phoneNumber
        self.zipCode = zipCode
        self.sales = []
    }
    
    /// User to JSON for Database
    func toJSON() -> [String: Any]? {
        guard let userName = self.userName,
            let photoURL = self.photoURL,
            let whatsup = self.whatsup,
            let dateOfBirth = self.dateOfBirth,
            let phoneNumber = self.phoneNumber,
            let zipCode = self.zipCode,
            let sales = self.sales else {
                return nil
        }
        var json = [String: Any]()
        
        // no need for uid
        json["userName"] = userName
        json["photoURL"] = photoURL
        json["whatsup"] = whatsup
        json["dateOfBirth"] = dateOfBirth
        json["phoneNumber"] = phoneNumber
        json["zipCode"] = zipCode
        json["sales"] = sales
        
        return json
    }
    
    /// Init from JSON
    init?(uid: String?, fromJSON json: [String: Any]) {
        guard let uid = uid,
            let userName = json["userName"] as? String,
            let photoURL = json["photoURL"] as? String,
            let whatsup = json["whatsup"] as? String,
            let dateOfBirth = json["dateOfBirth"] as? String,
            let phoneNumber = json["phoneNumber"] as? String,
            let zipCode = json["zipCode"] as? String,
            let sales = json["sales"] as? [ItemInfo] else {
                return nil
        }
        self.uid = uid
        self.userName = userName
        self.photoURL = photoURL
        self.whatsup = whatsup
        self.dateOfBirth = dateOfBirth
        self.phoneNumber = phoneNumber
        self.zipCode = zipCode
        self.sales = sales
    }
}

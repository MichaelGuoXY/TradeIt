//
//  SalesManager.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/13/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation
import Firebase

class SalesManager {
    /// singleton for SalesManager
    static let shared = SalesManager()
    
    /// Firebase Database ref
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    /// Upload new created Item onto database
    func upload(newItem item: ItemInfo?, withSuccessBlock sblock: @escaping (Void) -> Void, withErrorBlock eblock: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            let error = "user does not exist, upload new item failing"
            print(error)
            eblock(error)
            return
        }
        guard let item = item else {
            let error = "item does not exist, upload new item failing"
            print(error)
            eblock(error)
            return
        }
        // [Firebase Database Begin]
        let uid = user.uid
        let key = ref.child("sales").childByAutoId().key
        let childUpdates = ["/users/\(uid)/sales/\(key)": ["status" : item.status ?? MyStrings.itemStatusDefault],
                            "/sales/\(key)": item.toJSONBrief() ?? [:],
                            "/salesDetail/\(key)": item.toJSONDetail() ?? [:],
                            "/zipCodes/\(item.zipCode ?? MyStrings.zipCodeDefault)/\(key)": ["status" : item.status ?? MyStrings.itemStatusDefault]]
        ref.updateChildValues(childUpdates, withCompletionBlock: {(error, ref) in
            if let error = error {
                print(error.localizedDescription)
                eblock(error.localizedDescription)
            } else {
                // success
                sblock()
            }
        })
    }
    
    /// Update old Item onto database
    func update(oldItem item: ItemInfo?, withSuccessBlock sblock: @escaping (Void) -> Void, withErrorBlock eblock: @escaping (String) -> Void) {
        guard let user = Auth.auth().currentUser else {
            let error = "user does not exist, update old item failing"
            print(error)
            eblock(error)
            return
        }
        guard let item = item else {
            let error = "item does not exist, update old item failing"
            print(error)
            eblock(error)
            return
        }
        guard let sid = item.sid else {
            let error = "item does not has valid sid, update old item failing"
            print(error)
            eblock(error)
            return
        }
        // [Firebase Database Begin]
        let uid = user.uid
        let key = sid
        let childUpdates = ["/users/\(uid)/sales/\(key)": ["status" : item.status ?? MyStrings.itemStatusDefault],
                            "/sales/\(key)": item.toJSONBrief() ?? [:],
                            "/salesDetail/\(key)": item.toJSONDetail() ?? [:],
                            "/zipCodes/\(item.zipCode ?? MyStrings.zipCodeDefault)/\(key)": ["status" : item.status ?? MyStrings.itemStatusDefault]]
        ref.updateChildValues(childUpdates, withCompletionBlock: {(error, ref) in
            if let error = error {
                print(error.localizedDescription)
                eblock(error.localizedDescription)
            } else {
                // success
                sblock()
            }
        })
    }
}

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
    func upload(newItem item: ItemInfo?, withSid sid: String, withSuccessBlock sblock: ((Void) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let user = Auth.auth().currentUser else {
            let error = "user does not exist, upload new item failing"
            print(error)
            eblock?(error)
            return
        }
        guard let item = item else {
            let error = "item does not exist, upload new item failing"
            print(error)
            eblock?(error)
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
                eblock?(error.localizedDescription)
            } else {
                // success
                sblock?()
            }
        })
    }
    
    /// Update old Item onto database
    func update(oldItem item: ItemInfo?, withSuccessBlock sblock: ((Void) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let user = Auth.auth().currentUser else {
            let error = "user does not exist, update old item failing"
            print(error)
            eblock?(error)
            return
        }
        guard let item = item else {
            let error = "item does not exist, update old item failing"
            print(error)
            eblock?(error)
            return
        }
        guard let sid = item.sid else {
            let error = "item does not has valid sid, update old item failing"
            print(error)
            eblock?(error)
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
                eblock?(error.localizedDescription)
            } else {
                // success
                sblock?()
            }
        })
    }
    
    /// Fetch userName with uid
    func fetchSeller(withUid uid: String?, withSuccessBlock sblock: ((String, String?) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let uid = uid else {
            let error = "Error: uid not valid"
            print(error)
            eblock?(error)
            return
        }
        // fetch from database
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: {snapshot in
            let dict = snapshot.value as? [String: Any] ?? [:]
            let userName = dict["userName"] as? String ?? "no name"
            let photoURL = dict["photoURL"] as? String
            sblock?(userName, photoURL)
        }) {error in
            print(error.localizedDescription)
            eblock?(error.localizedDescription)
        }
    }
    
    /// Fetch items that meets zip code requirement
    func fetchItems(with zipCode: String, withSuccessBlock sblock: ((ItemInfo) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        fetchSids(with: zipCode, withSuccessBlock: { sids in
            for sid in sids {
                self.fetchItemBrief(with: sid, withSuccessBlock: { item in
                    // success
                    sblock?(item)
                }, withErrorBlock: nil)
            }
        }, withErrorBlock: nil)
    }
    
    
    /// Fetch items-sid that meets the zip code requirement
    func fetchSids(with zipCode: String, withSuccessBlock sblock: (([String]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        let zipCodeRef = ref.child("zipCodes").child(zipCode)
        zipCodeRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                // success
                if let dict = snapshot.value as? [String: Any] {
                    sblock?(Array(dict.keys))
                } else {
                    // error
                    let msg = "fetch zip codes from Firebase, snapshot cannot be converted into json"
                    print(msg)
                    eblock?(msg)
                }
            } else {
                // error
                let msg = "fetch zip codes from Firebase, snapshot is null"
                print(msg)
                eblock?(msg)
            }
        })
    }
    
    /// Fetch single item with sid
    func fetchItemBrief(with sid: String, withSuccessBlock sblock: ((ItemInfo) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        let itemRef = ref.child("sales").child(sid)
        itemRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                // success
                if let dict = snapshot.value as? [String: Any] {
                    let item = ItemInfo(sid: sid, fromJSON: dict)
                    if let item = item {
                        sblock?(item)
                    } else {
                        // error
                        let msg = "item created is nil"
                        print(msg)
                        eblock?(msg)
                    }
                }
            } else {
                // error
                let msg = "fetch item from Firebase, snapshot is null"
                print(msg)
                eblock?(msg)
            }
        })
    }
    
    /// Fetch item detail info with sid
    func fetchItemDetail(with sid: String, withSuccessBlock sblock: (([String: Any]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        let itemRef = ref.child("salesDetail").child(sid)
        itemRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                // success
                if let dict = snapshot.value as? [String: Any] {
                    sblock?(dict)
                }
            } else {
                // error
                let msg = "fetch item from Firebase, snapshot is null"
                print(msg)
                eblock?(msg)
            }
        })
    }
}

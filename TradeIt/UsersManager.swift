//
//  UsersManager.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/13/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation
import Firebase

class UsersManager {
    /// singleton for UsersManager
    static let shared = UsersManager()
    
    /// Firebase Database ref
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    /// Upload new user onto Database
    func upload(newUser user: User?, withSuccessBlock sblock: @escaping (Void) -> Void, withErrorBlock eblock: @escaping (String) -> Void) {
        guard let user = user else {
            let error = "upload newUser, while user passed in is not valid"
            print(error)
            eblock(error)
            return
        }
        // create new UserInfo obj
        guard let userInfo = UserInfo(uid: user.uid,
                                userName: user.displayName ?? "",
                                photoURL: user.photoURL?.absoluteString ?? "",
                                whatsup: "",
                                dateOfBirth: "",
                                phoneNumber: "",
                                zipCode: "") else {
                                    let error = "create userInfo error found"
                                    print(error)
                                    eblock(error)
                                    return
        }
        // upload onto database
        ref.child("users").child(userInfo.uid!).setValue(userInfo.toJSON(), withCompletionBlock: {(error, ref) in
            if let error = error {
                let errorInfo = "upload new user: Error Found is \(error.localizedDescription)"
                print(errorInfo)
                eblock(errorInfo)
            } else {
                // success
                sblock()
            }
        })
    }
    
    func fetch(oldUser user: User?, withSuccessBlock sblock: @escaping (DataSnapshot) -> Void, withErrorBlock eblock: @escaping (String) -> Void) {
        guard let user = user else {
            let error = "upload newUser, while user passed in is not valid"
            print(error)
            eblock(error)
            return
        }
        
        // fetch from database
        ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: {snapshot in
            sblock(snapshot)
        })
    }
}

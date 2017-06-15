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
    func upload(newUser user: User?, withSuccessBlock sblock: @escaping (Void) -> Void, withErrorBlock eblock: @escaping (Void) -> Void) {
        guard let user = user else {
            print("upload newUser, while user passed in is not valid")
            eblock()
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
                                    print("create userInfo error found")
                                    eblock()
                                    return
        }
        // upload onto database
        ref.child("users").child(userInfo.uid!).setValue(userInfo.toJSON(), withCompletionBlock: {(error, ref) in
            if let error = error {
                print("upload new user: Error Found is \(error)")
                eblock()
            } else {
                // success
                sblock()
            }
        })
    }
}

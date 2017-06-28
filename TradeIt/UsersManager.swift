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
    func upload(newUser user: User?, withSuccessBlock sblock: ((Void) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let user = user else {
            let error = "upload newUser, while user passed in is not valid"
            print(error)
            eblock?(error)
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
                                    eblock?(error)
                                    return
        }
        
        // upload onto database
        ref.child("users").child(userInfo.uid!).setValue(userInfo.toJSON(), withCompletionBlock: { (error, ref) in
            if let error = error {
                let errorInfo = "upload new user: Error Found is \(error.localizedDescription)"
                print(errorInfo)
                eblock?(errorInfo)
            } else {
                // success
                sblock?()
            }
        })
    }
    
    /// Fetch old user info from Database with uid
    func fetch(oldUser user: User?, withSuccessBlock sblock: ((DataSnapshot) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let user = user else {
            let error = "fetch old user, while user passed in is not valid"
            print(error)
            eblock?(error)
            return
        }
        
        // fetch from database
        ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                sblock?(snapshot)
            } else {
                let msg = "user not exists on firebase"
                print(msg)
                eblock?(msg)
            }
        })
    }
    
    /// Update user zip code onto Database
    func update(oldUser user: User?, zipCode: String, withSuccessBlock sblock: ((Void) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let user = user else {
            let error = "update user zip code, while user passed in is not valid"
            print(error)
            eblock?(error)
            return
        }
        
        // update onto database
        ref.child("users").child(user.uid).child("zipCode").setValue(zipCode, withCompletionBlock: { (error, ref) in
            if let error = error {
                let errorInfo = "upload new user: Error Found is \(error.localizedDescription)"
                print(errorInfo)
                eblock?(errorInfo)
            } else {
                // success
                sblock?()
            }
        })
    }
    
    /// Fetch user name and profile image with uid
    func fetchUsernameAndProfileImageURL(withUid uid: String, withSuccessBlock sblock: ((String, String) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                // success
                if let dict = snapshot.value as? [String: Any] {
                    let photoURL = dict["photoURL"] as? String ?? ""
                    let userName = dict["userName"] as? String ?? "anonymous"
                    sblock?(userName, photoURL)
                } else {
                    
                }
            } else {
                let errorInfo = "Error found when fetch user name and profile iamge URL..."
                print(errorInfo)
                eblock?(errorInfo)
            }
        })
    }
}

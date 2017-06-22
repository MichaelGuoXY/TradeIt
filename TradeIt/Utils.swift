//
//  Utils.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/19/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation
import Firebase

class Utils {
    static let userDefault = UserDefaults.standard
    
    static var zipCode: String? {
        
        set(newZipCode) {
            userDefault.set(newZipCode, forKey: "zipCode")
            UsersManager.shared.update(oldUser: Auth.auth().currentUser, zipCode: zipCode!)
        }
        
        get {
            return userDefault.string(forKey: "zipCode")
        }
        
    }
    
    static func clear() {
        zipCode = nil
    }
    
    /// run block on main thread asyc
    static func runOnMainThread(block: @escaping (Void) -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
    
    /// get zip codes at a zip code within miles
    static func getZipCodes(at zipCode: String, within mile: Int, withSuccessBlock sblock: (([String]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        URLManager.shared.runHTTPRequest(at: zipCode, within: mile, withSuccessBlock: { dict in
            guard let zipCodes = dict["zip_codes"] as? [String] else {
                let msg = "get zip code failure, cannot parse"
                print(msg)
                eblock?(msg)
                return
            }
            // success
            sblock?(zipCodes)
        }, withErrorBlock: { error in
            eblock?(error)
        })
    }
}

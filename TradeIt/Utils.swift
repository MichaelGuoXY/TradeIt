//
//  Utils.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/19/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation

class Utils {
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
}

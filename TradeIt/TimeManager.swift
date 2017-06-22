//
//  TimeManager.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/19/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation

class TimeManager {
    static let shared = TimeManager()
    
    /// Get current timestamp since 1970 Double -> String
    func timestamp() -> String {
        return "\(Date().timeIntervalSince1970)"
    }
    
    func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: Date())
    }
    
    func timeFromTimestamp(timestamp: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        let timeInterval = Double(timestamp) ?? Date().timeIntervalSince1970
        return formatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}

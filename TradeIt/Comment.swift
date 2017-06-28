//
//  Comment.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/27/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation

class Comment {
    var sid: String
    var from: String
    var to: String
    var msg: String
    var timestamp: String
    
    init(sid: String, from: String, to: String, msg: String) {
        self.sid = sid
        self.from = from
        self.to = to
        self.msg = msg
        self.timestamp = TimeManager.shared.timestamp()
    }
    
    init?(sid: String, fromJSON json: [String: Any]) {
        guard let from = json["from"] as? String,
            let to = json["to"] as? String,
            let msg = json["msg"] as? String,
            let timestamp = json["timestamp"] as? String
            else {
                let error = "cannot parse JSON into Comment object"
                print(error)
                return nil
        }
        self.sid = sid
        self.from = from
        self.to = to
        self.msg = msg
        self.timestamp = timestamp
    }
    
    func toJSON() -> [String: Any] {
        return ["from": self.from,
                "to": self.to,
                "msg": self.msg,
                "timestamp": self.timestamp]
    }
    
}

//
//  ItemInfo.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/13/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation
import Firebase


class ItemInfo {
    /// sid for firebase unique timestamp id
    var sid: String?
    
    // Brief part of item
    var uid: String?
    var title: String?
    var timestamp: String?
    var mainImageUrl: String?
    var price: String?
    var status: String?
    var viewCount: String?
    
    // Detail part of item
    var zipCode: String?
    var details: String?
    var imageUrls: [String]?
    var watchers: [String]?
    
    /// Init for the first time item created
    init?(user: User?,
          title: String,
          timestamp: String,
          mainImageUrl: String,
          price: String,
          zipCode: String,
          details: String,
          imageUrls: [String]) {
        
        self.sid = "not initialized"
        guard let user = user else {
            print("user does not exist, init item failing")
            return nil
        }
        self.uid = user.uid
        self.title = title
        self.timestamp = timestamp
        self.mainImageUrl = mainImageUrl
        self.price = price
        self.status = "sale" // for the first time created
        self.zipCode = zipCode
        self.details = details
        self.imageUrls = imageUrls
        
        // set for default
        self.viewCount = "0"
        self.watchers = []
    }
    
    /// Convet JSON into Item Brief
    init?(sid: String?, fromJSON value: [String: Any]) {
        guard let sid = sid,
            let uid = value["uid"] as? String,
            let title = value["title"] as? String,
            let timestamp = value["timestamp"] as? String,
            let mainImageUrl = value["mainImageUrl"] as? String,
            let price = value["price"] as? String,
            let status = value["status"] as? String,
            let viewCount = value["viewCount"] as? String else {
                print("something went wrong when trying to parse JSON into Item Brief")
                return nil
        }
        self.sid = sid
        self.uid = uid
        self.title = title
        self.timestamp = timestamp
        self.mainImageUrl = mainImageUrl
        self.price = price
        self.status = status
        self.viewCount = viewCount
    }
    
    /// Insert detail info into this Item
    func getDetail(fromJSON value: [String: Any]) {
        guard let zipCode = value["zipCode"] as? String,
            let details = value["details"] as? String,
            let imageUrls = value["imageUrls"] as? [String],
            let watchers = value["watchers"] as? [String] else {
                print("something went wrong when trying to parse JSON into Item Detail")
                return
        }
        // update detail part of Item
        self.zipCode = zipCode
        self.details = details
        self.imageUrls = imageUrls
        self.watchers = watchers
    }
    
    /// Convert item into JSON Brief
    func toJSONBrief() -> [String: Any]? {
        guard let uid = self.uid,
            let title = self.title,
            let timestamp = self.timestamp,
            let mainImageUrl = self.mainImageUrl,
            let price = self.price,
            let status = self.status,
            let viewCount = self.viewCount else {
                print("something went wrong when trying to convert Item into JSON Brief")
                return nil
        }
        var json = [String: Any]()
        json["uid"] = uid
        json["title"] = title
        json["timestamp"] = timestamp
        json["mainImageUrl"] = mainImageUrl
        json["price"] = price
        json["status"] = status
        json["viewCount"] = viewCount
        return json
    }
    
    /// Convert item into JSON Detail
    func toJSONDetail() -> [String: Any]? {
        guard let uid = self.uid,
            let zipCode = self.zipCode,
            let details = self.details,
            let imageUrls = self.imageUrls,
            let watchers = self.watchers else {
                print("something went wrong when trying to convert Item into JSON Detail")
                return nil
        }
        var json = [String: Any]()
        json["uid"] = uid
        json["zipCode"] = zipCode
        json["details"] = details
        json["imageUrls"] = imageUrls
        json["watchers"] = watchers
        return json
    }
    
}

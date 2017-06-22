//
//  URLManager.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/22/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation

class URLManager {
    static let shared = URLManager()
    let APIKey = "BdYzZgNmpJKzpyxGtWh4NFD6SJJjfbBQpzqpQdLfXvPm4m2xjkC70fdTYWce8N4y"
    let a = "https://www.zipcodeapi.com/rest/"
    let b = "/radius.json/"
    let c = "/mile?minimal"
    
    func runHTTPRequest(at zipCode: String, within mile: Int, withSuccessBlock sblock: (([String: Any]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        let URLString = "\(a)\(APIKey)\(b)\(zipCode)/\(mile)\(c)"
        let url = URL(string: URLString)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                eblock?((error?.localizedDescription)!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                eblock?("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = json as? [String: Any] else {
                print("JSON is not valid")
                eblock?("JSON is not valid")
                return
            }
            print(dict)
            sblock?(dict)
        }
        task.resume()
    }
}

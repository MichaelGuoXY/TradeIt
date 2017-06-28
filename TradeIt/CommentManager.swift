//
//  CommentManager.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/28/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation
import Firebase

class CommentManager {
    /// singleton for UsersManager
    static let shared = CommentManager()
    
    /// Firebase Database ref
    var ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    func uploadComment(withComment comment: Comment, withSuccessBlock sblock: ((Void) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        ref.child("comments").child(comment.sid).childByAutoId().setValue(comment.toJSON(), withCompletionBlock: { (error, ref) in
            if let error = error {
                let errorInfo = "upload new comment: Error Found is \(error.localizedDescription)"
                print(errorInfo)
                eblock?(errorInfo)
            } else {
                // success
                sblock?()
            }
        })
    }
    
    func fetchComments(withSid sid: String, withSuccessBlock sblock: (([Comment]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        ref.child("comments").child(sid).observe(.value, with: { snapshot in
            if snapshot.exists() {
                if let dict = snapshot.value as? [String: Any] {
                    let arr = Array(dict.values)
                    var comments: [Comment] = []
                    for o in arr {
                        if let commentJSON = o as? [String: Any] {
                            let comment = Comment(sid: sid, fromJSON: commentJSON)
                            comments.append(comment!)
                        }
                    }
                    // success
                    sblock?(comments)
                }
            } else {
                let errorInfo = "Error found when try to fetch comment with sid"
                print(errorInfo)
                eblock?(errorInfo)
            }
        })
    }
}

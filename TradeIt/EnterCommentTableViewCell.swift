//
//  EnterCommentTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/27/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit
import Firebase

class EnterCommentTableViewCell: UITableViewCell {
    var sid: String!
    var to: String!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // config user profile image view
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2
        userProfileImageView.layer.masksToBounds = true
        
        // config msgTextView
        msgTextView.layer.cornerRadius = 5
        msgTextView.layer.masksToBounds = true
        msgTextView.layer.borderColor = UIColor.black.cgColor
        msgTextView.layer.borderWidth = 1
        
        // buttons config
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.masksToBounds = true
        commentButton.layer.cornerRadius = 5
        commentButton.layer.masksToBounds = true
        
        // fetch user profile image
        if let uid = Auth.auth().currentUser?.uid {
            UsersManager.shared.fetchUsernameAndProfileImageURL(withUid: uid, withSuccessBlock: { (userName, photoURL) in
                self.userNameLabel.text = userName
                ImageManager.shared.fetchImage(withURL: photoURL, at: self.userProfileImageView)
            }, withErrorBlock: nil)
        }
        
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    func updateTimeLabel() {
        timeLabel.text = TimeManager.shared.getCurrentTimestamp()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func cancelButtonDidClicked(_ sender: UIButton) {
        msgTextView.text = ""
    }
    
    @IBAction func commentButtonDidClicked(_ sender: UIButton) {
        if let uid = Auth.auth().currentUser?.uid {
            let comment = Comment(sid: sid, from: uid, to: to, msg: msgTextView.text)
            CommentManager.shared.uploadComment(withComment: comment, withSuccessBlock: nil, withErrorBlock: nil)
        }
        msgTextView.text = ""
    }
}

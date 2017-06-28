//
//  CommentTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/27/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate: class {
    func reloadTableView(atRow row: Int, forHeight height: CGFloat)
}

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!

    weak var delegate: CommentTableViewCellDelegate!
    var row: Int!
    
    var comment: Comment! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        let from = comment.from
        let to = comment.to
        let msg = comment.msg
        let timestamp = comment.timestamp
        
        UsersManager.shared.fetchUsernameAndProfileImageURL(withUid: from, withSuccessBlock: { (userName, photoURL) in
            self.userNameLabel.text = userName
            ImageManager.shared.fetchImage(withURL: photoURL, at: self.userProfileImageView)
        }, withErrorBlock: nil)
        
        UsersManager.shared.fetchUsernameAndProfileImageURL(withUid: to, withSuccessBlock: { (userName, _) in
            self.msgLabel.text = "@\(userName): \(msg)"
            self.msgLabel.sizeToFit()
            self.delegate.reloadTableView(atRow: self.row, forHeight: 30 + 23 + self.msgLabel.bounds.height + 10 + 10)
        }, withErrorBlock: nil)
        
        timeLabel.text = TimeManager.shared.timeFromTimestamp(timestamp: timestamp)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // config user profile image view
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2
        userProfileImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

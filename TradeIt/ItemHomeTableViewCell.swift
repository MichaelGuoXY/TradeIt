//
//  ItemHomeTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/19/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class ItemHomeTableViewCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var itemStatusLabel: UILabel!
    
    // variables
    var item: ItemInfo! {
        didSet {
            updateUI()
        }
    }
    
    /// Update UI when item set
    func updateUI() {
        // do UI upates
        guard let item = item else {
            let error = "Tried to display item in cell \(self.tag), but failed"
            print(error)
            return
        }
        titleLabel.text = item.title
        // download image for this item
        ImageManager.shared.fetchImage(with: item, at: mainImageView)
        mainImageView.clipsToBounds = true
        
        // fetch seller name for uid in this item
        SalesManager.shared.fetchUserName(withUid: item.uid, withSuccessBlock: {userName in
            self.sellerLabel.text = userName
        }, withErrorBlock: nil)
        
        priceLabel.text = item.price
        
        detailTextView.text = item.details
        detailTextView.isEditable = false
        
        tagLabel.text = item.tags
        
        timeLabel.text = TimeManager.shared.timeFromTimestamp(timestamp: item.timestamp!)
        
        viewCountLabel.text = item.viewCount
        itemStatusLabel.text = item.status
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

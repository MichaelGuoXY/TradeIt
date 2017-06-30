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
    @IBOutlet weak var sellerProfileImageView: UIImageView!
    
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
        titleLabel.sizeToFit()

        // download image for this item
        ImageManager.shared.fetchImage(with: item, at: mainImageView)
        mainImageView.clipsToBounds = true
        mainImageView.backgroundColor = UIColor.clear
        
        // fetch seller name for uid in this item
        SalesManager.shared.fetchSeller(withUid: item.uid, withSuccessBlock: { (userName, photoURL) in
            self.sellerLabel.text = userName
            // seller profile image view loading (async)
            ImageManager.shared.fetchImage(withURL: photoURL, at: self.sellerProfileImageView)
        }, withErrorBlock: nil)
        
        priceLabel.text = item.price
        
        detailTextView.text = item.details
        detailTextView.backgroundColor = UIColor.clear
        detailTextView.isEditable = false
        
        tagLabel.text = item.tags
        
        timeLabel.text = TimeManager.shared.timeFromTimestamp(timestamp: item.timestamp!)
        
        viewCountLabel.text = item.viewCount
        itemStatusLabel.text = item.status
        
        // seller profile image view setting
        sellerProfileImageView.layer.cornerRadius = sellerProfileImageView.bounds.width / 2
        sellerProfileImageView.layer.masksToBounds = true
        
        
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

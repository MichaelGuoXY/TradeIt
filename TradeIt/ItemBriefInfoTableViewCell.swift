//
//  ItemBriefInfoTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/28/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

protocol ItemBriefInfoTableViewCellDelegate: class {
    func reloadTableViewForBrief(atRow row: Int, forHeight height: CGFloat)
}

class ItemBriefInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var viewCountsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    weak var delegate: ItemBriefInfoTableViewCellDelegate!
    var row: Int!
    
    var item: ItemInfo! {
        didSet {
            titleLabel.text = item.title
            priceLabel.text = item.price
            tagLabel.text = item.tags
            timeLabel.text = TimeManager.shared.timeFromTimestamp(timestamp: item.timestamp!)
            viewCountsLabel.text = item.viewCount
            statusLabel.text = item.status
            titleLabel.sizeToFit()
            delegate.reloadTableViewForBrief(atRow: row, forHeight: 5 * 20 + 7 * 10 + titleLabel.bounds.height)
        }
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

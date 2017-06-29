//
//  ItemDetailTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/28/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

protocol ItemDetailTableViewCellDelegate: class {
    func reloadTableViewForDetail(atRow row: Int, forHeight height: CGFloat)
}

class ItemDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    
    weak var delegate: ItemDetailTableViewCellDelegate!
    var row: Int!
    
    var item: ItemInfo! {
        didSet {
            detailLabel.text = item.details
            detailLabel.sizeToFit()
            delegate.reloadTableViewForDetail(atRow: row, forHeight: 50 + detailLabel.bounds.height)
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

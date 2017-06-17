//
//  DetailTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/16/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        detailTextView.layer.borderWidth = 2.0
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

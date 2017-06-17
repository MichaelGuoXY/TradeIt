//
//  PriceTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/16/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet weak var priceTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        priceTextField.layer.borderWidth = 2.0
        priceTextField.layer.cornerRadius = 5.0
        priceTextField.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

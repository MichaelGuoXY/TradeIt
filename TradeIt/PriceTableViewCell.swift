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
    
    var viewType: ItemDetailViewType! {
        didSet {
            setupCellAttrs()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellAttrs()
    }
    
    func setupCellAttrs() {
        priceTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        priceTextField.layer.borderWidth = {
            if let viewType = viewType {
                if viewType == .preview {
                    return 0.0
                } else {
                    return 2.0
                }
            } else {
                return 2.0
            }
        }()
        priceTextField.layer.cornerRadius = 5.0
        priceTextField.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                priceTextField.isEnabled = false
            } else {
                priceTextField.isEnabled = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

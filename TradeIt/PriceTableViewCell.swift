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
    
    var viewType: NewItemViewType! {
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
        
        priceTextField.layer.cornerRadius = 5.0
        priceTextField.backgroundColor = UIColor.clear
        priceTextField.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                priceTextField.isEnabled = false
                priceTextField.borderStyle = .none
                priceTextField.layer.borderWidth = 0.0
            } else {
                priceTextField.isEnabled = true
                priceTextField.borderStyle = .roundedRect
                priceTextField.layer.borderWidth = 2.0
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

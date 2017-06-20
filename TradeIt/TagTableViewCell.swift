//
//  TagTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/17/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class TagTableViewCell: UITableViewCell {

    @IBOutlet weak var tagTextField: UITextField!
    
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
        tagTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        tagTextField.layer.borderWidth = {
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
        tagTextField.layer.cornerRadius = 5.0
        tagTextField.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                tagTextField.isEnabled = false
            } else {
                tagTextField.isEnabled = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

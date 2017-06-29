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
        tagTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        tagTextField.layer.cornerRadius = 5.0
        tagTextField.backgroundColor = UIColor.clear
        tagTextField.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                tagTextField.isEnabled = false
                tagTextField.borderStyle = .none
                tagTextField.layer.borderWidth = 0.0
            } else {
                tagTextField.isEnabled = true
                tagTextField.borderStyle = .roundedRect
                tagTextField.layer.borderWidth = 2.0
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

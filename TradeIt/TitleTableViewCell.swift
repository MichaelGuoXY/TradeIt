//
//  TitleTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/16/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
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
        titleTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.backgroundColor = UIColor.clear
        titleTextField.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                titleTextField.isEnabled = false
                titleTextField.borderStyle = .none
                titleTextField.layer.borderWidth = 0.0
            } else {
                titleTextField.isEnabled = true
                titleTextField.borderStyle = .roundedRect
                titleTextField.layer.borderWidth = 2.0
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

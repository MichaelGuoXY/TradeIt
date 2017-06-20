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
        titleTextField.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        titleTextField.layer.borderWidth = {
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
        titleTextField.layer.cornerRadius = 5.0
        titleTextField.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                titleTextField.isEnabled = false
            } else {
                titleTextField.isEnabled = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

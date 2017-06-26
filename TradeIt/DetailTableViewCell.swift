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
        detailTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        detailTextView.layer.borderWidth = {
            if let viewType = viewType {
                if viewType == .preview || viewType == .detail {
                    return 0.0
                } else {
                    return 2.0
                }
            } else {
                return 2.0
            }
        }()
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
        if let viewType = viewType {
            if viewType == .preview {
                detailTextView.isEditable = false
                detailTextView.isScrollEnabled = false
            } else if viewType == .detail {
                detailTextView.isEditable = false
                detailTextView.isScrollEnabled = true
            } else {
                detailTextView.isEditable = true
                detailTextView.isScrollEnabled = true
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

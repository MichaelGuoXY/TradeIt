//
//  ImagePickerTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/14/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class ImagePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        collectionView.layer.borderWidth = {
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
        collectionView.layer.cornerRadius = 5.0
        collectionView.layer.masksToBounds = true
    }
    
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate> (dataSourceDelegate: D) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()
    }
}

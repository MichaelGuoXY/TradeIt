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
    
    
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate> (dataSourceDelegate: D) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.reloadData()
    }
}

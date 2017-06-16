//
//  PostNewItemTableViewController.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/14/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit
import DKImagePickerController

class PostNewItemTableViewController: UITableViewController {
    // consts
    let imagePickerTableViewCellReuseID = "ImagePickerTableViewCell"
    let imagePickerAddButtonReuseID = "ImagePickerCollectionViewCellAdd"
    let imagePickerImageReuseID = "ImagePickerCollectionViewCell"
    let addButtonFileName = "add_photo"
    
    // variables
    var images: [UIImage] = [] {
        didSet {
            if images.count == imagesCount {
                tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
            }
        }
    }
    var imagesCount: Int = 0
    var rowHeightForImagePickerCell: CGFloat = 70.0
    var rowHeightForImagePickerCellOffSet: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imagePickerTableViewCellReuseID, for: indexPath)
        
        if let tableViewCell = cell as? ImagePickerTableViewCell {
            tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self)
            return tableViewCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return CGFloat(images.count / 5) * 90.0 + 90.0
        }
        return 50.0
    }
}


extension PostNewItemTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagePickerAddButtonReuseID,
                                                          for: indexPath)
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.image = UIImage(named: addButtonFileName)
            cell.contentView.addSubview(imageView)
            cell.contentView.bringSubview(toFront: imageView)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagePickerImageReuseID,
                                                          for: indexPath)
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.image = images[indexPath.item - 1]
            cell.contentView.addSubview(imageView)
            cell.contentView.bringSubview(toFront: imageView)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let pickerController = DKImagePickerController()
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                self.images = []
                self.imagesCount = assets.count
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                for asset in assets {
                    asset.fetchImageWithSize(CGSize(width: 1000, height: 1000), completeBlock: {(image, _) in
                        if let image = image {
                            self.images.append(image)
                        }
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                        }
                    })
                }
            }
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if images.count == imagesCount {
            
        }
    }
}

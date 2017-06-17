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
    // table view cell
    let imagePickerTableViewCellReuseID = "ImagePickerTableViewCell"
    let titleTableViewCellReuseID = "TitleTableViewCell"
    let tagTableViewCellReuseID = "TagTableViewCell"
    let priceTableViewCellReuseID = "PriceTableViewCell"
    let detailTableVIewCellReuseID = "DetailTableViewCell"
    
    // collection view cell
    let imagePickerAddButtonReuseID = "ImagePickerCollectionViewCellAdd"
    let imagePickerImageReuseID = "ImagePickerCollectionViewCell"
    
    // images name
    let addButtonFileName = "add_photo"
    
    // variables
    var images: [UIImage] = [] {
        didSet {
            if images.count == imagesCount || images.count == 0 {
                tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .fade)
            }
        }
    }
    
    // buttons
    lazy var postButton: UIButton = {[unowned self] in
        var buttonWidth: CGFloat = 60.0
        var buttonSpace: CGFloat = 50.0
        var button = UIButton(frame: CGRect(x: self.view.bounds.width - buttonWidth - buttonSpace,
                                            y: self.view.bounds.height - buttonWidth - buttonSpace,
                                            width: buttonWidth,
                                            height: buttonWidth))
        button.backgroundColor = UIColor.purple
        button.layer.cornerRadius = buttonWidth / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    // image picker cell vars
    var imagesCount: Int = 0
    var heightForLabelImagePicker: CGFloat = 25.5 + 5.0 + 5.0
    var rowHeightForImagePickerCell: CGFloat = 68.0
    var rowHeightForImagePickerCellOffSet: CGFloat = 17.0
    var rowHeightForImagePickerCellAll: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // init for vars
        rowHeightForImagePickerCellAll = rowHeightForImagePickerCell + rowHeightForImagePickerCellOffSet
        
        // layout buttons
        view.addSubview(postButton)
        view.bringSubview(toFront: postButton)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: titleTableViewCellReuseID, for: indexPath) as? TitleTableViewCell {
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: tagTableViewCellReuseID, for: indexPath) as? TagTableViewCell {
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: priceTableViewCellReuseID, for: indexPath) as? PriceTableViewCell {
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: imagePickerTableViewCellReuseID, for: indexPath) as? ImagePickerTableViewCell {
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self)
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: detailTableVIewCellReuseID, for: indexPath) as? DetailTableViewCell {
                return cell
            }
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1, 2:
            return 100
        case 3:
            return CGFloat(images.count / 5 + 1) * rowHeightForImagePickerCellAll + heightForLabelImagePicker
        case 4:
            return 150
        default:
            return 50
        }
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
                    asset.fetchOriginalImageWithCompleteBlock {(image, _) in
                        if let image = image {
                            self.images.append(image)
                        }
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                        }
                    }
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

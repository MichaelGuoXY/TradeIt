//
//  ItemDetailViewController.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/17/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit
import DKImagePickerController
import Firebase

enum ItemDetailViewType {
    case new
    case edit
    case preview
}

class ItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // view type
    var viewType: ItemDetailViewType! {
        didSet {
            // table view reload
            if let tableView = tableView {
                imageViews = []
                tableView.reloadData()
            }
            // button title changes
            switch viewType! {
            case .new, .edit:
                DispatchQueue.main.async {
                    self.leftButton.setTitle("Cancel", for: .normal)
                    self.leftButton.backgroundColor = UIColor.yellow
                    self.rightButton.setTitle("Continue", for: .normal)
                    self.rightButton.backgroundColor = UIColor.green
                }
            case .preview:
                DispatchQueue.main.async {
                    self.leftButton.setTitle("Edit", for: .normal)
                    self.leftButton.backgroundColor = UIColor.orange
                    self.rightButton.setTitle("Post", for: .normal)
                    self.rightButton.backgroundColor = UIColor.black
                }
            }
        }
    }
    
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
    
    var imageViews: [UIImageView] = []
    
    // buttons
    lazy var leftButton: UIButton = {[unowned self] in
        var buttonWidth: CGFloat = self.view.bounds.width / 2
        var buttonHeight: CGFloat = 50.0
        var button = UIButton(frame: CGRect(x: 0.0,
                                            y: self.view.bounds.height - buttonHeight,
                                            width: buttonWidth,
                                            height: buttonHeight))
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
        return button
        }()
    
    lazy var rightButton: UIButton = {[unowned self] in
        var buttonWidth: CGFloat = self.view.bounds.width / 2
        var buttonHeight: CGFloat = 50.0
        var button = UIButton(frame: CGRect(x: buttonWidth,
                                            y: self.view.bounds.height - buttonHeight,
                                            width: buttonWidth,
                                            height: buttonHeight))
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "ChalkboardSE-Regular", size: 22)
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
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.bringSubview(toFront: leftButton)
        view.bringSubview(toFront: rightButton)
        
        // buttons action
        leftButton.addTarget(self, action: #selector(ItemDetailViewController.leftButtonClicked(_:)), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(ItemDetailViewController.rightButtonClicked(_:)), for: .touchUpInside)
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: titleTableViewCellReuseID, for: indexPath) as? TitleTableViewCell {
                cell.viewType = viewType
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: tagTableViewCellReuseID, for: indexPath) as? TagTableViewCell {
                cell.viewType = viewType
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: priceTableViewCellReuseID, for: indexPath) as? PriceTableViewCell {
                cell.viewType = viewType
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: imagePickerTableViewCellReuseID, for: indexPath) as? ImagePickerTableViewCell {
                cell.viewType = viewType
                cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self)
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: detailTableVIewCellReuseID, for: indexPath) as? DetailTableViewCell {
                cell.viewType = viewType
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    // Buttons Action
    func leftButtonClicked(_ sender: UIButton) {
        switch viewType! {
        case .new, .edit:
            naviBackToHomeView()
        case .preview:
            viewType = .edit
        }
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        switch viewType! {
        case .new, .edit:
            viewType = .preview
        case .preview:
            postItem()
        }
    }
    
    // navi back to home view
    func naviBackToHomeView() {
        dismiss(animated: true, completion: nil)
    }
    
    // post item .new or .edit
    func postItem() {
        let ref = Database.database().reference()
        let sid = ref.child("sales").childByAutoId().key
        ImageManager.shared.upload(imageViews: imageViews, uid: Auth.auth().currentUser?.uid, sid: sid, withSuccessBlock: { imagesURL in
            // success
            print(imagesURL)
        }, withErrorBlock: { _ in
            // error
            
        })
    }
}


extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewType! {
        case .new, .edit:
            return images.count + 1
        case .preview:
            return images.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewType! {
        case .new, .edit:
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
        case .preview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagePickerImageReuseID,
                                                          for: indexPath)
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.image = images[indexPath.item]
            imageViews.append(imageView)
            cell.contentView.addSubview(imageView)
            cell.contentView.bringSubview(toFront: imageView)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewType! {
        case .new, .edit:
            if indexPath.item == 0 {
                let pickerController = DKImagePickerController()
                pickerController.maxSelectableCount = 5
                pickerController.didSelectAssets = { (assets: [DKAsset]) in
                    self.images = []
                    self.imageViews = []
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
        case .preview:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if images.count == imagesCount {
            
        }
    }
}


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
    case detail
}

class ItemDetailViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
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
                self.leftButton.setTitle("Cancel", for: .normal)
                self.leftButton.backgroundColor = UIColor.yellow
                self.rightButton.setTitle("Continue", for: .normal)
                self.rightButton.backgroundColor = UIColor.green
            case .preview:
                self.leftButton.setTitle("Edit", for: .normal)
                self.leftButton.backgroundColor = UIColor.orange
                self.rightButton.setTitle("Post", for: .normal)
                self.rightButton.backgroundColor = UIColor.black
            case .detail:
                self.leftButton.setTitle("Back", for: .normal)
                self.leftButton.backgroundColor = UIColor.blue
                self.rightButton.setTitle("Watch", for: .normal)
                self.rightButton.backgroundColor = UIColor.red
                self.tableViewTopConstraint.constant = -64.0
            }
            
            // layout buttons
            view.addSubview(leftButton)
            view.addSubview(rightButton)
            view.bringSubview(toFront: leftButton)
            view.bringSubview(toFront: rightButton)
        }
    }
    
    // table view cell
    let imagePickerTableViewCellReuseID = "ImagePickerTableViewCell"
    let titleTableViewCellReuseID = "TitleTableViewCell"
    let tagTableViewCellReuseID = "TagTableViewCell"
    let priceTableViewCellReuseID = "PriceTableViewCell"
    let detailTableVIewCellReuseID = "DetailTableViewCell"
    let commentTableViewCellReuseID = "CommentTableViewCell"
    let enterCommentTableViewCellReuseID = "EnterCommentTableViewCell"
    
    // collection view cell
    let imagePickerAddButtonReuseID = "ImagePickerCollectionViewCellAdd"
    let imagePickerImageReuseID = "ImagePickerCollectionViewCell"
    
    // images name
    let addButtonFileName = "add_photo"
    
    // variables
    var images: [UIImage] = [] {
        didSet {
            if images.count == imagesCount || images.count == 0 {
                tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
            }
        }
    }
    
    var imageViews: [UIImageView] = [] {
        didSet {
            if viewType != .detail {
                return
            }
            // .detail mode
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .fade)
        }
    }
    
    var comments: [Comment] = [] {
        didSet {
            if viewType != .detail {
                return
            }
            // .detail mode
            tableView.reloadData()
        }
    }
    
    var heightForCommentCells: [Int: CGFloat] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Detail view status
    var isDetailEditing: Bool = false
    var isCommentEditing: Bool = false
    
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
        button.addTarget(self, action: #selector(ItemDetailViewController.leftButtonClicked(_:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(ItemDetailViewController.rightButtonClicked(_:)), for: .touchUpInside)
        return button
        }()
    
    // image picker cell vars
    var imagesCount: Int = 0
    var heightForLabelImagePicker: CGFloat = 25.5 + 5.0 + 5.0
    var rowHeightForImagePickerCell: CGFloat = 68.0
    var rowHeightForImagePickerCellOffSet: CGFloat = 17.0
    var rowHeightForImagePickerCellAll: CGFloat!
    
    // vars used to create new item info
    var itemTitle: String?
    var itemPrice: String?
    var itemTags: String?
    var itemDetail: String?
    
    // item to show
    var item: ItemInfo! {
        didSet {
            // prepare for item detail view
            if viewType == .detail {
                // pre-fetch images for this item
                SalesManager.shared.fetchItemDetail(with: item.sid!, withSuccessBlock: { dict in
                    self.item.getDetail(fromJSON: dict)
                    self.imageViews = ImageManager.shared.fetchImage(with: self.item)
                }, withErrorBlock: nil)
                
                // pre-fetch comments for this item
                CommentManager.shared.fetchComments(withSid: item.sid!, withSuccessBlock: { comments in
                    self.comments = comments
                }, withErrorBlock: nil)
            }
        }
    }
    
    // vars used to auto size detail cell text view
    var detailTextViewContentHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // init for vars
        rowHeightForImagePickerCellAll = rowHeightForImagePickerCell + rowHeightForImagePickerCellOffSet
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        // tap gesture added to table view
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tgr.cancelsTouchesInView = false
        tgr.delegate = self
        self.tableView.addGestureRecognizer(tgr)
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // constraints
        // table view bottom
        self.tableViewBottomConstraint.constant = 50.0
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 100; // set to whatever your "average" cell height is
    }
    
    // Deal with keyboard notification
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.height {
                tableViewBottomConstraint.constant = 50.0
            } else {
                tableViewBottomConstraint.constant = endFrame?.size.height ?? 50.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: { _ in
                            if self.isDetailEditing {
                                self.tableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .bottom, animated: true)
                                self.isDetailEditing = false
                            } else if self.isCommentEditing {
                                self.tableView.scrollToRow(at: IndexPath(row: 4 + self.comments.count + 1, section: 0), at: .bottom, animated: true)
                                self.isCommentEditing = false
                            }
            })
        }
    }
    
    // deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Buttons Action
    func leftButtonClicked(_ sender: UIButton) {
        switch viewType! {
        case .new, .edit:
            naviBackToHomeView()
        case .preview:
            viewType = .edit
        case .detail:
            popViewController()
        }
    }
    
    func rightButtonClicked(_ sender: UIButton) {
        switch viewType! {
        case .new, .edit:
            viewType = .preview
        case .preview:
            postItem()
        case .detail:
            watchThisItem()
        }
    }
    
    // navi back to home view
    func naviBackToHomeView() {
        dismiss(animated: true, completion: nil)
    }
    
    /// pop this view controller from navigation controller
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    /// Watch this item func
    func watchThisItem() {
        
    }
    
    // post item .new or .edit
    func postItem() {
        let ref = Database.database().reference()
        let sid = ref.child("sales").childByAutoId().key
        ImageManager.shared.upload(imageViews: imageViews, uid: Auth.auth().currentUser?.uid, sid: sid, withSuccessBlock: { imagesURL in
            // success
            // create new item
            // validate vars
            if self.validateItemInfo() == false {
                let msg = "item info required not valid, cannot create new item"
                print(msg)
                return
            }
            // item info valid
            let newItem = ItemInfo(user: Auth.auth().currentUser, title: self.itemTitle!, timestamp: TimeManager.shared.timestamp(), mainImageUrl: imagesURL[0], price: self.itemPrice!, zipCode: Utils.zipCode!, details: self.itemDetail!, imageUrls: imagesURL, tags: self.itemTags!)
            SalesManager.shared.upload(newItem: newItem, withSid: sid, withSuccessBlock: { _ in
                let msg = "new item created successfully"
                print(msg)
                self.dismiss(animated: true, completion: nil)
            }, withErrorBlock: { _ in
                let msg = "new item not created successfully"
                print(msg)
            })
        }, withErrorBlock: { _ in
            // error
            let msg = "images not uploaded successfully"
            print(msg)
        })
    }
    
    func validateItemInfo() -> Bool {
        if itemTitle == nil || itemTitle?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let msg = "item doesn't have a valid title"
            print(msg)
            return false
        }
        if itemPrice == nil || itemPrice?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let msg = "item doesn't have a valid price"
            print(msg)
            return false
        }
        if itemTags == nil || itemTags?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let msg = "item doesn't have valid tags"
            print(msg)
            return false
        }
        if itemDetail == nil || itemDetail?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let msg = "item doesn't have a valid detal"
            print(msg)
            return false
        }
        if Utils.zipCode == nil || Utils.zipCode == "" {
            let msg = "item doesn't have a valid zip code"
            print(msg)
            return false
        }
        return true
    }
    
}

extension ItemDetailViewController: UIGestureRecognizerDelegate {
    
    func viewTapped(_ tgr: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension ItemDetailViewController: UITextViewDelegate {
    // tag 10 for detail text view
    // tag 11 for comment text view
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 10 { isDetailEditing = true }
        if textView.tag == 11 { isCommentEditing = true }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        detailTextViewContentHeight = textView.contentSize.height
    }
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType! {
        case .detail:
            return 5 + comments.count + 1
        default:
            return 5
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: titleTableViewCellReuseID, for: indexPath) as? TitleTableViewCell {
                cell.viewType = viewType
                switch viewType! {
                case .preview:
                    itemTitle = cell.titleTextField.text
                case .detail:
                    cell.titleTextField.text = item.title
                default:
                    break
                }
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: tagTableViewCellReuseID, for: indexPath) as? TagTableViewCell {
                cell.viewType = viewType
                switch viewType! {
                case .preview:
                    itemTags = cell.tagTextField.text
                case .detail:
                    cell.tagTextField.text = item.tags
                default:
                    break
                }
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: priceTableViewCellReuseID, for: indexPath) as? PriceTableViewCell {
                cell.viewType = viewType
                switch viewType! {
                case .preview:
                    itemPrice = cell.priceTextField.text
                case .detail:
                    cell.priceTextField.text = item.price
                default:
                    break
                }
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
                cell.detailTextView.delegate = self
                switch viewType! {
                case .preview:
                    itemDetail = cell.detailTextView.text
                case .detail:
                    cell.detailTextView.text = item.details
                default:
                    break
                }
                return cell
            }
        case 4 + comments.count + 1:
            // enter comment cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: enterCommentTableViewCellReuseID, for: indexPath) as? EnterCommentTableViewCell {
                cell.sid = item.sid!
                cell.to = item.uid!
                cell.msgTextView.delegate = self
                return cell
            }
        default:
            // comment cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: commentTableViewCellReuseID, for: indexPath) as? CommentTableViewCell {
                cell.comment = comments[indexPath.row - 4 - 1]
                cell.delegate = self
                cell.row = indexPath.row
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1, 2:
            return 100
        case 3:
            if viewType == .preview || viewType == .detail {
                return CGFloat((images.count - 1) / 5 + 1) * rowHeightForImagePickerCellAll + heightForLabelImagePicker
            } else {
                return CGFloat(images.count / 5 + 1) * rowHeightForImagePickerCellAll + heightForLabelImagePicker
            }
        case 4:
            if viewType == .preview {
                return 26.0 + 5.0 + detailTextViewContentHeight! + 30.0
            }
            else {
                return 200
            }
        case 4 + comments.count + 1:
            return 300
        default:
            return heightForCommentCells[indexPath.row - 4 - 1] ?? 50
        }
    }
    
}

extension ItemDetailViewController: CommentTableViewCellDelegate {
    func reloadTableView(atRow row: Int, forHeight height: CGFloat) {
        if heightForCommentCells[row - 4 - 1] == nil {
            heightForCommentCells[row - 4 - 1] = height
            tableView.reloadData()
        }
    }
}


extension ItemDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewType! {
        case .new, .edit:
            return images.count + 1
        case .preview:
            return images.count
        case .detail:
            return imageViews.count
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
        case .detail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagePickerImageReuseID,
                                                          for: indexPath)
            let imageView = imageViews[indexPath.item]
            imageView.frame = cell.contentView.bounds
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
        case .detail:
            // TODO: fullscreen image view
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if images.count == imagesCount {
            
        }
    }
}


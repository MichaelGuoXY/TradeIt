//
//  ItemDetailViewController.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/28/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var comments: [Comment] = [] {
        didSet {
//            heightForCommentCells = [:]
            tableView.reloadData()
        }
    }
    
    var isCommentEditing: Bool = false
    
    var heightForCommentCells: [Int: CGFloat] = [:] {
        didSet {
        }
    }
    
    var heightForDetailCell: CGFloat?
    var heightForBriefCell: CGFloat?
    
    // item to show
    var item: ItemInfo! {
        didSet {
            // pre-fetch comments for this item
            CommentManager.shared.fetchComments(withSid: item.sid!, withSuccessBlock: { comment in
                self.comments.append(comment)
            }, withErrorBlock: nil)
        }
    }
    
    // table view cell reuse ID
    let imageGalleryTableViewCellReuseID = "ImageGalleryTableViewCell"
    let itemBriefTableViewCellReuseID = "ItemBriefInfoTableViewCell"
    let itemDetailTableViewCellReuseID = "ItemDetailTableViewCell"
    let commentTableViewCellReuseID = "CommentTableViewCell"
    let enterCommentTableViewCellReuseID = "EnterCommentTableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100; // set to whatever your "average" cell height is
        
        // tap gesture added to table view
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tgr.cancelsTouchesInView = false
        tgr.delegate = self
        self.tableView.addGestureRecognizer(tgr)
        
        // Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.black
        title = item.title
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
                tableViewBottomConstraint.constant = 0
            } else {
                tableViewBottomConstraint.constant = endFrame?.size.height ?? 0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: { _ in
                            if self.isCommentEditing {
                                self.tableView.scrollToRow(at: IndexPath(row: 3 + self.comments.count, section: 0), at: .bottom, animated: true)
                                self.isCommentEditing = false
                            }
            })
        }
    }
    
    // deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        if textView.tag == 11 { isCommentEditing = true }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}

extension ItemDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4 + comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 300
        case 1:
            //brief
            return heightForBriefCell ?? 210
        case 2:
            //detail
            return heightForDetailCell ?? 100
        case 3 + comments.count:
            return 300
        default:
            return heightForCommentCells[indexPath.row - 3] ?? 72
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: imageGalleryTableViewCellReuseID, for: indexPath) as? ImageGalleryTableViewCell {
                cell.item = item
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: itemBriefTableViewCellReuseID, for: indexPath) as? ItemBriefInfoTableViewCell {
                cell.delegate = self
                cell.row = indexPath.row
                cell.item = item
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: itemDetailTableViewCellReuseID, for: indexPath) as? ItemDetailTableViewCell {
                cell.delegate = self
                cell.row = indexPath.row
                cell.item = item
                return cell
            }
        case 3 + comments.count:
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
                cell.delegate = self
                cell.row = indexPath.row
                cell.comment = comments[indexPath.row - 3]
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension ItemDetailViewController: CommentTableViewCellDelegate {
    func reloadTableView(atRow row: Int, forHeight height: CGFloat) {
        if heightForCommentCells[row - 3] == nil {
            heightForCommentCells[row - 3] = height
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }
}

extension ItemDetailViewController: ItemBriefInfoTableViewCellDelegate {
    func reloadTableViewForBrief(atRow row: Int, forHeight height: CGFloat) {
        if heightForBriefCell == nil {
            heightForBriefCell = height
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }
}

extension ItemDetailViewController: ItemDetailTableViewCellDelegate {
    func reloadTableViewForDetail(atRow row: Int, forHeight height: CGFloat) {
        if heightForDetailCell == nil {
            heightForDetailCell = height
            tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
        }
    }
}

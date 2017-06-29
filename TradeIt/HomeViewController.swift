//
//  HomeViewController.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/18/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var postNewItemButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let itemHomeTableViewReuseID = "ItemHomeTableViewCell"
    
    var items: [ItemInfo] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // var used to determine scroll view direction
    var lastContentOffset: CGPoint! = CGPoint()
    
    // vars to store origin button y
    var yBtn01: CGFloat!
    var yBtn02: CGFloat!
    var yBtn03: CGFloat!
    
    // bool to determine whether buttons are shown
    var isBtnShown = true
    var isAnimating = false
    
    @IBAction func postNewItemButtonClicked(_ sender: UIButton) {
        if let postNewItemVC = storyboard?.instantiateViewController(withIdentifier: "NewItemViewController") as? NewItemViewController {
            postNewItemVC.viewType = .new
            present(postNewItemVC, animated: true, completion: nil)
        }
    }
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        
    }
    @IBAction func profileButtonClicked(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 205.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // fetch items that meet requirements
        Utils.getZipCodes(at: Utils.zipCode!, within: 5, withSuccessBlock: { zipCodes in
            for zipCode in zipCodes {
                SalesManager.shared.fetchItems(with: zipCode, withSuccessBlock: { [weak self] (sid, dict) in
                    guard let strongSelf = self else { return }
                    let item = ItemInfo(sid: sid, fromJSON: dict)
                    if let item = item {
                        strongSelf.items.append(item)
                    }
                    }, withErrorBlock: nil)
            }
        }, withErrorBlock: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // init buttons vars
        if isBtnShown && !isAnimating {
            yBtn01 = searchButton.frame.origin.y
            yBtn02 = postNewItemButton.frame.origin.y
            yBtn03 = profileButton.frame.origin.y
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Hide three buttons animation
    func hideButton1() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchButton.frame.origin.y = self.view.frame.size.height
        }, completion: { _ in
            self.hideButton2()
        })
    }
    
    func hideButton2() {
        UIView.animate(withDuration: 0.2, animations: {
            self.postNewItemButton.frame.origin.y = self.view.frame.size.height
        }, completion: { _ in
            self.hideButton3()
        })
    }
    
    func hideButton3() {
        UIView.animate(withDuration: 0.2, animations: {
            self.profileButton.frame.origin.y = self.view.frame.size.height
        }, completion: { _ in
            self.isAnimating = false
            self.isBtnShown = false
        })
    }
    
    /// Show three buttons animation
    func showButton1() {
        UIView.animate(withDuration: 0.2, animations: {
            self.searchButton.frame.origin.y = self.yBtn01
        }, completion: { _ in
            self.showButton2()
        })
    }
    
    func showButton2() {
        UIView.animate(withDuration: 0.2, animations: {
            self.postNewItemButton.frame.origin.y = self.yBtn02
        }, completion: { _ in
            self.showButton3()
        })
    }
    
    func showButton3() {
        UIView.animate(withDuration: 0.2, animations: {
            self.profileButton.frame.origin.y = self.yBtn03
        }, completion: { _ in
            self.isAnimating = false
            self.isBtnShown = true
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemHomeTableViewReuseID, for: indexPath)
        
        if let cell = cell as? ItemHomeTableViewCell {
            cell.item = items[indexPath.row]
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // navigation controller push detail view onto top
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        detailVC.item = items[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset.x < scrollView.contentOffset.x {
            print("Scrolled Right")
        }
        else if lastContentOffset.x > scrollView.contentOffset.x {
            print("Scrolled Left")
        }
            
        else if lastContentOffset.y < scrollView.contentOffset.y {
            print("Scrolled Down")
            // Hide three buttons
            if isBtnShown && !isAnimating {
                isAnimating = true
                hideButton1()
            }
        }
            
        else if lastContentOffset.y > scrollView.contentOffset.y {
            print("Scrolled Up")
            // Show three buttons
            if !isBtnShown && !isAnimating {
                isAnimating = true
                showButton1()
            }
        }
    }
}

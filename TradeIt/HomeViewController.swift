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
    
    @IBAction func postNewItemButtonClicked(_ sender: UIButton) {
        if let postNewItemVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch items that meet requirements
        Utils.getZipCodes(at: Utils.zipCode!, within: 5, withSuccessBlock: { zipCodes in
            for zipCode in zipCodes {
                SalesManager.shared.fetchItems(with: zipCode, withSuccessBlock: { items in
                    self.items = items
                }, withErrorBlock: nil)
            }
        }, withErrorBlock: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
}

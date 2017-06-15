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
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImagePickerTableViewCell", for: indexPath)
        
        if let tableViewCell = cell as? ImagePickerTableViewCell {
            tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self)
            if tableViewCell.contentView.bounds.height < tableViewCell.collectionView.contentSize.height {
                tableViewCell.frame = CGRect(origin: tableViewCell.frame.origin, size: tableViewCell.collectionView.contentSize)
            }
            return tableViewCell
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCollectionViewCellAdd",
                                                          for: indexPath)
            let imageView = UIImageView(frame: cell.contentView.bounds)
            imageView.image = UIImage(named: "add_photo")
            cell.contentView.addSubview(imageView)
            cell.contentView.bringSubview(toFront: imageView)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCollectionViewCell",
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
                print("didSelectAssets")
                print(assets)
                self.images = []
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                for asset in assets {
                    asset.fetchImageWithSize(CGSize(width: 100, height: 100), completeBlock: {(image, _) in
                        if let image = image {
                            self.images.append(image)
                        }
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                            self.tableView.reloadData()
                        }
                    })
                }
            }
            self.present(pickerController, animated: true, completion: nil)
        }
    }
}

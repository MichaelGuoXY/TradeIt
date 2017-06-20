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

        // Do any additional setup after loading the view.
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

//
//  EnterZipCodeViewController.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/20/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit


class EnterZipCodeViewController: UIViewController {
    
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        // TODO: Validate zip code
        Utils.zipCode = zipCodeTextField.text
        naviToHomeViewController()
    }
    
    func naviToHomeViewController() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewNavigationController") as? UINavigationController {
            present(homeVC, animated: true, completion: nil)
        } else {
            print("Error found when trying to present home view controller")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config the button
        continueButton.layer.cornerRadius = 5
        continueButton.layer.masksToBounds = true
        
        // show up keyboard
        if zipCodeTextField.canBecomeFirstResponder {
            zipCodeTextField.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if zipCodeTextField.canResignFirstResponder {
            zipCodeTextField.resignFirstResponder()
        }
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

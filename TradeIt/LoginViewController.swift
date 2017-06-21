//
//  LoginViewController.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/12/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import DKImagePickerController

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInWithGoogleBtn: GIDSignInButton!
    @IBAction func signInWithGoogleBtnClicked(_ sender: UIButton) {
    }
    @IBAction func btnClicked(_ sender: UIButton) {
        
    }
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        signInWithGoogleBtn.style = .wide
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // [START_EXCLUDE]
            self.setTitleDisplay(user)
            // [END_EXCLUDE]
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        showSpinner {
            Auth.auth().signIn(with: credential) { (user, error) in
                // [START_EXCLUDE silent]
                self.hideSpinner {
                    // [END_EXCLUDE]
                    if let error = error {
                        // [START_EXCLUDE]
                        self.showMessagePrompt(error.localizedDescription)
                        // [END_EXCLUDE]
                        return
                    }
                    // User is signed in
                    // [START_EXCLUDE]
                    // Merge prevUser and currentUser accounts and data
                    // download user data from firebase if exists
                    UsersManager.shared.fetch(oldUser: Auth.auth().currentUser, withSuccessBlock: { snapshot in
                        // user exists on Firebase Database
                        if let dict = snapshot.value as? [String: Any] {
                            Utils.zipCode = dict["zipCode"] as? String ?? ""
                        }
                        self.naviToHomeViewController()
                    }, withErrorBlock: { error in
                        // user doesn't exist on Firebase Database
                        // need to upload user onto Firebase Database
                        UsersManager.shared.upload(newUser: Auth.auth().currentUser, withSuccessBlock: {
                            Utils.clear()
                            self.naviToHomeViewController()
                        }, withErrorBlock: { error in
                            
                        })
                    })
                    // [END_EXCLUDE]
                }
            }
            // [END signin_credential]
        }
    }
    
    func naviToHomeViewController() {
        if Utils.zipCode == nil || Utils.zipCode == "" {
            if let enterZipCodeVC = storyboard?.instantiateViewController(withIdentifier: "EnterZipCodeViewController") as? EnterZipCodeViewController {
                present(enterZipCodeVC, animated: true, completion: nil)
            }
        } else {
            if let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                present(homeVC, animated: true, completion: nil)
            } else {
                print("Error found when trying to present home view controller")
            }
        }
    }
    
    func setTitleDisplay(_ user: User?) {
        if let name = user?.displayName {
            self.navigationItem.title = "Welcome \(name)"
        } else {
            self.navigationItem.title = "Authentication Example"
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

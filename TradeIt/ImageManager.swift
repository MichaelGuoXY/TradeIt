//
//  ImageManager.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/19/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorageUI

class ImageManager {
    static let shared = ImageManager()
    
    var imagesRootRef: StorageReference
    var countForImages: Int
    var imagesURL: [String]
    
    init() {
        imagesRootRef = Storage.storage().reference().child("images")
        countForImages = 0
        imagesURL = []
    }
    
    func upload(imageViews: [UIImageView]?, uid: String?, sid: String?, withSuccessBlock sblock: (([String]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        
        guard let uid = uid else {
            let error = "uid not valid"
            print(error)
            eblock?(error)
            return
        }
        guard let sid = sid else {
            let error = "sid not valid"
            print(error)
            eblock?(error)
            return
        }
        guard let imageViews = imageViews else {
            let error = "image views not valid"
            print(error)
            eblock?(error)
            return
        }
        
        var i = 0
        for imageView in imageViews {
            upload(imageView: imageView, count: imageViews.count, uid: uid, sid: sid, path: "\(i).jpg", withSuccessBlock: sblock, withErrorBlock: eblock)
            i += 1
        }
    }
    
    func upload(imageView: UIImageView, count: Int, uid: String, sid: String, path: String, withSuccessBlock sblock: (([String]) -> Void)? = nil, withErrorBlock eblock: ((String) -> Void)? = nil) {
        guard let image = imageView.image else {
            let error = "image view doesn't contain image"
            print(error)
            eblock?(error)
            return
        }
        
        let data = UIImageJPEGRepresentation(image, 1)
        let imageRef = imagesRootRef.child(uid).child(sid).child(path)
        let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
                eblock?(error.localizedDescription)
            } else{
                
                // Metadata contains file metadata such as size, content-type, and download URL.
                if let downloadURL = metadata!.downloadURL() {
                    self.countForImages += 1
                    self.imagesURL.append(downloadURL.absoluteString)
                    if self.countForImages == count {
                        // success for all images, now run sblock
                        sblock?(self.imagesURL)
                        // reset
                        self.countForImages = 0
                        self.imagesURL = []
                    }
                }
            }
        })
        // task monitor
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            Utils.runOnMainThread {
                // update UI on image view
                // remove previous label
                for view in imageView.subviews {
                    if view.tag == 1 || view.tag == 2 {
                        view.removeFromSuperview()
                    }
                }
                
                let shade = UIView(frame: CGRect(x: 0, y: 0, width: imageView.bounds.width * CGFloat(percentComplete / 100), height: imageView.bounds.height))
                shade.backgroundColor = UIColor.black
                shade.alpha = 0.5
                shade.tag = 2
                
                let label = UILabel(frame: imageView.bounds)
                label.text = String(format: "%d%%", arguments: [Int(percentComplete)])
                label.textColor = UIColor.white
                label.textAlignment = .center
                label.font = UIFont(name: "ChalkboardSE-Regular", size: 24)
                label.tag = 1
                
                imageView.addSubview(shade)
                imageView.addSubview(label)
                imageView.bringSubview(toFront: shade)
                imageView.bringSubview(toFront: label)
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            Utils.runOnMainThread {
                // Upload completed successfully
                for view in imageView.subviews {
                    if view.tag == 1 || view.tag == 2 {
                        view.removeFromSuperview()
                    }
                }
                
                let shade = UIView(frame: imageView.bounds)
                shade.backgroundColor = UIColor.black
                shade.alpha = 0.5
                
                let checkImageView = UIImageView(frame: CGRect(x: imageView.bounds.width / 4, y: imageView.bounds.height / 4, width: imageView.bounds.width / 2, height: imageView.bounds.height / 2))
                checkImageView.image = UIImage(named: "check")
                
                imageView.addSubview(shade)
                imageView.addSubview(checkImageView)
                imageView.bringSubview(toFront: shade)
                imageView.bringSubview(toFront: checkImageView)
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }
    
    /// fetch image of certain item
    func fetchImage(with item: ItemInfo, at imageView: UIImageView) {
        
        // Reference to an image file in Firebase Storage
        let imageRef = imagesRootRef.child(item.uid!).child(item.sid!).child("0.jpg")
        
        // Placeholder image
        let placeholderImage = UIImage(named: "img_placeholder")
        
        // Load the image using SDWebImage
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.white)
        imageView.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
    }
}

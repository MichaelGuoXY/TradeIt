//
//  ImageGalleryTableViewCell.swift
//  TradeIt
//
//  Created by Xiaoyu Guo on 6/28/17.
//  Copyright © 2017 Xiaoyu Guo. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageViews: [UIImageView] = [] {
        didSet {
            var workingFrame = scrollView.bounds
            for imageView in imageViews {
                imageView.frame = workingFrame
                scrollView.addSubview(imageView)
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width
            }
            scrollView.isPagingEnabled = true
            scrollView.contentSize = CGSize(width: workingFrame.origin.x, height: workingFrame.size.height)
        }
    }
    
    var item: ItemInfo! {
        didSet {
            // pre-fetch images for this item
            SalesManager.shared.fetchItemDetail(with: item.sid!, withSuccessBlock: { dict in
                self.item.getDetail(fromJSON: dict)
                self.imageViews = ImageManager.shared.fetchImage(with: self.item)
            }, withErrorBlock: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

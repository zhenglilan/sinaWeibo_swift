//
//  PicPickerCollectionViewCell.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/2/7.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class PicPickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageBtn: UIButton!
    @IBOutlet weak var deleteImgBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
//                imageBtn.setBackgroundImage(image, for: .normal)
                imageBtn.isUserInteractionEnabled = false
                deleteImgBtn.isHidden = false
            }else {
//                imageBtn.setBackgroundImage(UIImage(named:"compose_pic_add"), for: .normal)
                imageView.image = nil
                imageBtn.isUserInteractionEnabled = true
                deleteImgBtn.isHidden = true
            }
        }
    }

    
   
    @IBAction func addPicBtnClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: addPicNotification), object: nil)
    }

    @IBAction func deletePicBtnClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: deletePicNotification), object: imageView.image)
    }
}

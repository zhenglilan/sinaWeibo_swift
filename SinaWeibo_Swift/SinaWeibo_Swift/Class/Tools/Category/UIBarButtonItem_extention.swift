//
//  UIBarButtonItem_extention.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/12.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String) {
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        button.sizeToFit()
        
        self.init(customView: button)
    }
}

//
//  UIButton_Extention.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/11.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

extension UIButton {
    // 遍历构造函数
    convenience init(imageNamed: String, bgImageNamed: String) {
        self.init()
        setImage(UIImage(named: imageNamed), for: .normal)
        setImage(UIImage(named: imageNamed + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageNamed), for: .normal)
        setBackgroundImage(UIImage(named: bgImageNamed + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
}

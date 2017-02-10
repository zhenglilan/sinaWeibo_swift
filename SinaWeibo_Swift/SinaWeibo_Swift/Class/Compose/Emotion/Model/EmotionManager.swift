//
//  EmotionManager.swift
//  EmotionKeyboard
//
//  Created by 郑丽兰 on 17/2/8.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class EmotionManager {

    var packages: [EmotionPackage] = [EmotionPackage]()
    
    init() {
        // 1. 添加最近
        packages.append(EmotionPackage(id: ""))
        // 2. 默认
        packages.append(EmotionPackage(id: "com.sina.default"))
        // 3. emoji
        packages.append(EmotionPackage(id: "com.apple.emoji"))
        // 4. 浪小花
        packages.append(EmotionPackage(id: "com.sina.lxh"))
    }
}

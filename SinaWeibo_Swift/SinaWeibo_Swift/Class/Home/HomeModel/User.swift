//
//  User.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/19.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class User: NSObject {
    var profile_image_url: String? // 头像
    var screen_name: String?       // 名称
    var verified_type: Int = -1    // 认证类型
    var mbrank: Int = 0            //会员等级
        
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

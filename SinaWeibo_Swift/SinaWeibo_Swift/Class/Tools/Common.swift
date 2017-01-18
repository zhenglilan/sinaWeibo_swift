//
//  Common.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/17.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import Foundation

// MARK: - 授权常量
let app_key = "3077430719"
let redirect_uri = "https://www.baidu.com"
let app_secret = "4a23ac3a1d2b1e2fc6d5c1c69c3952cc"

// MARK: - 网址
let accessTokenURLString = "https://api.weibo.com/oauth2/access_token"
let userInfoURLString = "https://api.weibo.com/2/users/show.json"

// MARK: - 沙盒路径
let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
let accountPath = (documentPath.first! as NSString).appendingPathComponent("account.plist")

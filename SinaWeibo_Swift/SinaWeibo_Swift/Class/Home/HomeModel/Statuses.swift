//
//  Statuses.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/19.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class Statuses: NSObject {
    // MARK: - 属性
    var created_at: String?           // 微博创建时间
    var mid: Int = 0                  // 微博MID
    var text: String?                 // 微博内容
    var source: String?               // 微博来源
    var user: User?                   // 用户信息
    var pic_urls: [[String: String]]? // 图片地址
    var retweeted_status: Statuses?   // 转发微博数据
    var reposts_count: Int = 0        // 转发数量
    
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
        // 用户字典转成用户模型
        if let userDic = dict["user"] as? [String: Any] {
            user = User.init(dict: userDic)
        }
        // 转发微博字典转成转发微博模型对象
        if let retweetedStatus = dict["retweeted_status"] as? [String: Any] {
            retweeted_status = Statuses(dict: retweetedStatus)
        }
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

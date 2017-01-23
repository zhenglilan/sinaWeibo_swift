//
//  UserAccountModel.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/18.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//  字典转模型

import UIKit

class UserAccountModel: NSObject, NSCoding {
    // MARK: - 属性
    var access_token: String?
    var expires_in: TimeInterval = 0.0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: expires_in)
        }
    }
    var uid: String?
    // MARK: - 转换时间属性
    var expires_date: Date?
    
    // MARK: - 用户属性
    var screen_name: String?
    var avatar_large: String?
    
    // MARK: - 自定义构造器
    init(dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    // 重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
    
    // MARK: - 归档&解档
    // 解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    
    // 归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
}

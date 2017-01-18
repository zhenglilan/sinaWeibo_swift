//
//  UserAccountTool.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/18.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    // 将类设计成单例
    static let shareUserAccountViewModel = UserAccountViewModel()
    
    var account: UserAccountModel?
    
    // MARK: - 计算属性
    var isLogin: Bool {
        if account == nil {
            return false
        }
        guard let expireDate = account?.expires_date  else{
            return false
        }
        return expireDate.compare(Date()) == .orderedDescending
    }
    
    init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccountModel
    }
}

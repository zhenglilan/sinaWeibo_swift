//
//  StatusesViewModel.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/20.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class StatusesViewModel: NSObject {

    // MARK: - 属性
    var statuses: Statuses?
    // MARK: - 处理过的属性
    var sourceTest: String?         // 处理来源
    var createdAtTest: String?      // 处理时间
    var verifiedImage: UIImage?     // 处理认证图片
    var mbrankImage: UIImage?       // 处理等级
    var profileImageURL: URL?       // 处理头像地址
    var picURLs: [URL] = [URL]()    // 处理配图地址
    
    init(statuses: Statuses) {
        self.statuses = statuses
        // 1. 处理来源
        if let source = statuses.source , source != "" {
            // <a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            sourceTest = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
        
        // 2. 处理时间
        if let createdAt = statuses.created_at {
            createdAtTest = Date.createDateString(createAtString: createdAt)
        }
        
        // 3. 处理认证图片
        let verifiedType = statuses.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            verifiedImage = nil
        }
        
        // 4. 处理等级
        let mbrank = statuses.user?.mbrank ?? 0
        if mbrank > 1 && mbrank <= 6 {
            mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }

        // 5. 处理头像
        let profileImageURLString = statuses.user?.profile_image_url ?? ""
        profileImageURL = URL(string: profileImageURLString)
        
        // 6. 处理配图
        let picURLDicsArray = statuses.pic_urls!.count != 0 ? statuses.pic_urls : statuses.retweeted_status?.pic_urls
        if let picURLDicsArray = picURLDicsArray {
            for picURLDic in picURLDicsArray {
                guard let picURLStr = picURLDic["thumbnail_pic"] else {
                    continue // 跳出此次循环
                }
                picURLs.append(URL(string: picURLStr)!)
            }
        }
    }
}

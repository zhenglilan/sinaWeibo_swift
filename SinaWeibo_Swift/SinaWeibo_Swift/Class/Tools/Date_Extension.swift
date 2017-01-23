//
//  Date_Extension.swift
//  时间处理
//
//  Created by 郑丽兰 on 17/1/19.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import Foundation
extension Date {
    static func createDateString(createAtString: String) -> String {
        // 1. 创建时间格式化对象
        let format = DateFormatter()
        format.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        
        // 2. 将字符串转成NSDate类型
        guard let createDate = format.date(from: createAtString) else {
            return ""
        }
        
        // 3. 创建当前时间
        let nowDate = Date()
        
        // 4. 计算时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        
        // 5.对时间间隔进行处理
        // 5.1 刚刚
        if interval < 60 {
            return "刚刚"
        }
        
        // 5.2 几分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 5.3 几小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        // 5.4 创建日历对象
        let calendar = Calendar.current
        
        // 5.5 处理昨天的数据
        if calendar.isDateInYesterday(createDate) {
            format.dateFormat = "昨天 HH:mm"
            let timeStr = format.string(from: createDate)
            return timeStr
        }
        
        // 5.6 处理一年之内数据
        let cmps = calendar.dateComponents([.year], from: createDate, to: nowDate)
        if cmps.year! < 1 {
            format.dateFormat = "MM-dd HH:mm"
            let timeStr = format.string(from: createDate)
            return timeStr
        }
        // 5.7 超过一年
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = format.string(from: createDate)
        return timeStr
    }
}

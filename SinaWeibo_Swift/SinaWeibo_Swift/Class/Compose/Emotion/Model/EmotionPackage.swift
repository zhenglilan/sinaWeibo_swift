//
//  EmotionPackage.swift
//  EmotionKeyboard
//
//  Created by 郑丽兰 on 17/2/8.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class EmotionPackage: NSObject {
    var emotions:[Emotion] = [Emotion]()
    
    init(id: String) {
        super.init()
        // 最近分组
        if id == "" {
            addEmptyEmotion(isRecent: true)
            return
        }
        // 拼接路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let array = NSArray(contentsOfFile: plistPath)! as! [[String: String]]
        var index = 0 // 记录最后一个删除按钮
        for var dic in array {
            // 拼接png的路径
            if let png = dic["png"] {
                dic["png"] = id + "/" + png
            }
            emotions.append(Emotion(dic: dic))
            
            index += 1
            if index == 20 {
                emotions.append(Emotion(isDelete: true))
                index = 0
            }
        }
        
        // 添加空白表情
       addEmptyEmotion(isRecent: false)
    }
    
    fileprivate func addEmptyEmotion(isRecent: Bool) {
        let count = emotions.count % 21
        if count == 0 && !isRecent {
            return
        }
        for _ in count..<20 {
            emotions.append(Emotion(isEmpty: true))
        }
        emotions.append(Emotion(isDelete: true))
    }
    
}

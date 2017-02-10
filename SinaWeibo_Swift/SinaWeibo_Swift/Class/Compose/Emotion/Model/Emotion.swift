//
//  Emotion.swift
//  EmotionKeyboard
//
//  Created by 郑丽兰 on 17/2/8.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class Emotion: NSObject {
    // MARK: - 属性
    var code: String? {
        didSet {
            guard let code = code else {
                return
            }
            // 1. 创建扫描器
            let scanner = Scanner(string: code)
            // 2. 扫描出值
            var value: UInt32 = 0
            scanner.scanHexInt32(&value)
            // 3. 将value转成字符
            let c = Character(UnicodeScalar(value)!)
            // 4. 将字符转成字符串
            emojiCode = String(c)
        }
    }
    var png: String? {
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs: String?
    

    /// 处理数据属性
    var pngPath: String?
    var emojiCode: String?
    var isDelete: Bool = false
    var isEmpty: Bool = false
    
    init(dic: [String: String]) {
        super.init()
        setValuesForKeys(dic)
    }
    init(isDelete: Bool) {
        self.isDelete = isDelete
    }
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode", "pngPath", "chs"]).description
    }
}

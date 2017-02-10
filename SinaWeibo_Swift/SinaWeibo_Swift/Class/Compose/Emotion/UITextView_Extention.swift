//
//  UITextView_Extention.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/2/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

extension UITextView {
    /// 获取textview的字符串对应的表情文字
    func getEmotionString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        // 遍历
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            /// 取到表情
            if let attach = dict["NSAttachment"] as? EmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attach.chs!)
            }
        }
        return attrMStr.string
    }
    
    func insertEmotion(emotion: Emotion) {
        // 空白表情不作处理
        if emotion.isEmpty {
            return
        }
        // 删除按钮
        if emotion.isDelete {
            deleteBackward()
            return
        }
        // emoji
        if emotion.emojiCode != nil {
            let textRange = selectedTextRange!
            replace(textRange, withText: emotion.emojiCode!)
            return
        }
        // 图文混排
        let attatchment = EmotionAttachment()
        attatchment.chs = emotion.chs
        attatchment.image = UIImage(contentsOfFile: emotion.pngPath!)
        let font = self.font!
        attatchment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageString = NSAttributedString(attachment: attatchment)
        // 创建可变的属性字符串
        let attrMString = NSMutableAttributedString(attributedString: attributedText)
        // 将图片替换到某个位置
        let range = selectedRange
        attrMString.replaceCharacters(in: range, with: attrImageString)
        attributedText = attrMString
        // 重置文字大小
        self.font = font
        // 光标设置回原来位置 + 1
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}

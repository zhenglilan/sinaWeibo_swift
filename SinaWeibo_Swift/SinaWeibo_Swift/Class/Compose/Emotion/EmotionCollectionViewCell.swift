//
//  EmotionCollectionViewCell.swift
//  EmotionKeyboard
//
//  Created by 郑丽兰 on 17/2/9.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
  
    fileprivate lazy var button: UIButton = UIButton()
    
    var emotion:Emotion? {
        didSet {
            guard let emotion = emotion else{
                return
            }
            button.setImage(UIImage(contentsOfFile:emotion.pngPath ?? ""), for: .normal)
            button.setTitle(emotion.emojiCode, for: .normal)
            
            if emotion.isDelete {
                button.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            
            if emotion.isEmpty {
                button.setTitle("", for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmotionCollectionViewCell {
    fileprivate func setUpUI() {
        contentView.addSubview(button)
        button.frame = contentView.bounds
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}

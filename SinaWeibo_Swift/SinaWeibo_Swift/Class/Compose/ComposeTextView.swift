//
//  ComposeTextView.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/2/7.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {
    lazy var placeHolderLabel: UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTextView()
    }

}

extension ComposeTextView {
    fileprivate func setUpTextView() {
        addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(13)
        }
        
        placeHolderLabel.font = font
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.textColor = UIColor.lightGray
        
        textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
    }
}

//
//  ComposeTitleView.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/2/7.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {
    // MARK: - 懒加载
    fileprivate lazy var titleLabel: UILabel = UILabel()
    fileprivate lazy var screenNameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTitleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ComposeTitleView {
    fileprivate func setUpTitleView() {
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareUserAccountViewModel.account?.screen_name
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.font = UIFont.systemFont(ofSize: 12)
        screenNameLabel.textColor = UIColor.lightGray
    }
}

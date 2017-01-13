//
//  ZLLPresentationController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/12.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class ZLLPresentationController: UIPresentationController {

    // MARK: - 提供给外界属性
    var presentedViewFrame: CGRect = CGRect.zero
    // MARK: - 懒加载
    lazy fileprivate var coverView: UIView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        // 设置下拉框的大小及位置
        presentedView?.frame = presentedViewFrame
        // 设置蒙板
        setUpCoverView()
    }
}

extension ZLLPresentationController {
    fileprivate func setUpCoverView() {
        containerView?.insertSubview(coverView, belowSubview: presentedView!)
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        containerView?.addGestureRecognizer(tapGes)
    }
}

// MARK: - 事件监听
extension ZLLPresentationController {
    @objc fileprivate func tapClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

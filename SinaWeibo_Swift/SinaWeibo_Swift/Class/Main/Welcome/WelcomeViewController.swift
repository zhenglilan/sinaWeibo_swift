//
//  WelcomeViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/19.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    // MARK: - 拖线属性
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    // MARK: - 属性
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatarUrl = UserAccountViewModel.shareUserAccountViewModel.account?.avatar_large
        // 设置头像
        avatarImageView.sd_setImage(with: URL(string: avatarUrl ?? ""), placeholderImage: UIImage(named:"avatar_default"))
        
        // 改变约束的值
        bottomConstraints.constant = UIScreen.main.bounds.height - 220
        // 执行动画
        // usingSpringWithDamping: 阻力系数，阻力系数越大越不明显
        // initialSpringVelocity: 初始化速度
        UIView.animate(withDuration: 3.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()
        }
    }

}

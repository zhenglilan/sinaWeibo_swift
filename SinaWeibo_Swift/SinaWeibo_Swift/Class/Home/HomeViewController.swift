//
//  HomeViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - 属性
    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn: TitleButton = TitleButton()
    fileprivate lazy var popViewAnimation: PoperViewAnimation = PoperViewAnimation {[unowned self] (isPopShow) in
        self.titleBtn.isSelected = isPopShow
    }
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

       visitorView.addRotateAnimation()
        // 1. 没有登陆
        if !isLogin {
            return
        }
        
        // 2. 登录成功
       setUpNavigationBar()
    }

}

// MARK: - UI界面
extension HomeViewController {
    fileprivate func setUpNavigationBar() {
        // 设置item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        // 设置 titleview
        titleBtn.setTitle("微博名称", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(_:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

// MARK: - 监听事件
extension HomeViewController {
    @objc fileprivate func titleBtnClick(_ titleBtn: TitleButton) {
       
        // 1. 创建弹出的控制器
        let popViewController = PoperViewController()
            // 模态跳转默认跳转出控制器后，底部的其它控制器都会被回收掉
        // 2. 设置控制器的modal样式
        popViewController.modalPresentationStyle = .custom
        // 3. 设置转场代理
        popViewController.transitioningDelegate = popViewAnimation
        popViewAnimation.presentedViewFrame = CGRect(x: 100, y: 55, width: 180, height: 250)
        // 4. 弹出控制器
        present(popViewController, animated: true, completion: nil)
    }
}













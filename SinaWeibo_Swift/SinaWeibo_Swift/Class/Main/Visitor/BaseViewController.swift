//
//  BaseViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/12.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    // MARK: - 懒加载属性
    lazy var visitorView: VisitorView = VisitorView.visitorView()
    
    // MARK: - 定义变量
    var isLogin = true
    
    // MARK: - 系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
    }
    
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }
}


 // MARK: - 界面UI
extension BaseViewController {
    fileprivate func setUpVisitorView() {
        view = visitorView
        visitorView.registerBtn.addTarget(self, action: #selector(registerBtnClick), for: .touchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
    }
    
    fileprivate func setUpNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(loginBtnClick))
    }
}

// MARK: - 监听事件
extension BaseViewController {
    @objc fileprivate func registerBtnClick() {
        print("register")
    }
    @objc fileprivate func loginBtnClick() {
        print("login")
    }
}



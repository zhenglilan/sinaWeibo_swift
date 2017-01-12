//
//  MainViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    
    /*******storyboard构建项目*****/
    // MARK: - 懒加载
//    fileprivate lazy var imageNames = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    fileprivate lazy var composeBtn: UIButton = UIButton(imageNamed: "tabbar_compose_icon_add", bgImageNamed: "tabbar_compose_button")
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
       setUpComposeBtn()
        
    }

    // MARK: - 纯代码构建项目
    func Original() {
        /********************************* 纯代码构建项目*******************
         override func viewDidLoad() {
         super.viewDidLoad()
         // 1. 获取json路径
         guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings", ofType: ".json") else {
         print("没找到该路径")
         return
         }
         // 2. 读取json文件中内容
         guard let jsonData = NSData.init(contentsOfFile: jsonPath) else {
         print("没有数据")
         return
         }
         
         // try? : 通过将错误转成一个可选值来处理错误
         guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else {
         return
         }
         guard let dataArray = anyObject as? [[String: AnyObject]] else {
         return
         }
         
         for dic in dataArray {
         guard let vcName = dic["vcName"] as? String else {
         continue
         }
         guard let title = dic["title"] as? String else {
         continue
         }
         guard let imageName = dic["imageName"] as? String else {
         continue
         }
         addChildViewController(childControllerName: vcName, title: title, imageName: imageName)
         }
         }
         
         // MARK: - 私有方法
         // swift支持方法的重载
         private func addChildViewController(childControllerName: String, title: String, imageName: String) {
         // 0. 获取命名空间
         guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
         print("没有获取命名空间")
         return
         }
         // 1. 根据字符串获取对应的class
         guard let childVcClass = NSClassFromString(nameSpace + "." + childControllerName) else {
         print("没有字符串对应的类")
         return
         }
         // 2. 将对应的AnyObject转成控制器的类
         guard let childVcType = childVcClass as? UIViewController.Type else {
         print("没有转成控制器的类")
         return
         }
         print("存在该字符串所对应的类")
         // 3. 创建对应的控制器
         let childVc = childVcType.init()
         // 4. 设置自控制器的属性
         childVc.title = title
         childVc.tabBarItem.image = UIImage(named: imageName)
         childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
         // 5. 包装导航控制器
         let childNav = UINavigationController(rootViewController: childVc)
         // 6. 添加控制器
         addChildViewController(childNav)
         }
         
         **********/

    }
}

    // MARK: - UI界面设置
extension MainViewController {
    /// 发布按钮设置
    fileprivate func setUpComposeBtn() {
        // 1. 将按钮添加到tabbar
        tabBar.addSubview(composeBtn)

        // 2. 按钮位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height / 2.0)
        
        // 3. 监听事件
        composeBtn.addTarget(self, action: #selector(composeBtnClick), for: .touchUpInside)
    }
    
    /// tabbar中item的设置
    /*  在viewWillAppear中调用此方法
    fileprivate func setUpItem() {
        for i in 0..<tabBar.items!.count {
            // 取出每个item
            let item = tabBar.items![i]
            // 中间不可点
            if i == 2 {
                item.isEnabled = false
                continue
            }
            // 设置其他item选中状态图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
     */
}

// MARK: - 监听事件
extension MainViewController {
    // @objc作用是私有方法依旧可以加到方法列表中，并且保持私有
    @objc fileprivate func composeBtnClick() {
        print("btnClick")
    }
}

//
//  MainViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    
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



}

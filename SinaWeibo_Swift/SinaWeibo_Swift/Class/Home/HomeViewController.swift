//
//  HomeViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: BaseViewController {
    
    // MARK: - 属性
    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn: TitleButton = TitleButton()
    fileprivate lazy var popViewAnimation: PoperViewAnimation = PoperViewAnimation {[unowned self] (isPopShow) in
        self.titleBtn.isSelected = isPopShow
    }
    fileprivate lazy var viewModels: [StatusesViewModel] = [StatusesViewModel]()
    
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
        
        // 3. 请求数据
        loadStatuses()
        
        // 自适应cell中内容的高度
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
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

// MARK: - 请求数据
extension HomeViewController {
    fileprivate func loadStatuses() {
        NetworkTool.shareInstance.loadHomeData { (result, error) in
            if error != nil {
                return
            }
            guard let resultArray = result else {
                return
            }
            for dataDic in resultArray {
               let status = Statuses.init(dict: dataDic)
               let viewModel = StatusesViewModel.init(statuses: status)
               self.viewModels.append(viewModel)
            }

            // 缓存图片
            self.cacheImages(viewModels: self.viewModels)
        }
    }
    fileprivate func cacheImages(viewModels: [StatusesViewModel]) {
        let group = DispatchGroup()
        for viewmodel in viewModels {
            for picURL in viewmodel.picURLs {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
            }
        }
        // 刷新表格
        group.notify(queue: DispatchQueue.main) {
            // 全部图片都下载完成后，刷新表格
            self.tableView.reloadData()
        }
    }
}



// MARK: - 代理方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}










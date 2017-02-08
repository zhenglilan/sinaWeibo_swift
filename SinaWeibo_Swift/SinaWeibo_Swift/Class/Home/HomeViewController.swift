//
//  HomeViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    // MARK: - 属性
    // MARK: - 懒加载属性
    fileprivate lazy var titleBtn: TitleButton = TitleButton()
    fileprivate lazy var popViewAnimation: PoperViewAnimation = PoperViewAnimation {[unowned self] (isPopShow) in
        self.titleBtn.isSelected = isPopShow
    }
    fileprivate lazy var viewModels: [StatusesViewModel] = [StatusesViewModel]()
    fileprivate lazy var tipLabel: UILabel = UILabel()
    
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
//        loadStatuses()
        
        // 自适应cell中内容的高度
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        // 下拉刷新
        setUpRefreshHeaderView()
        // 上拉加载
        setUpRefreshFooterView()
        // 加载提示语
        setUpTipLabel()
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
    
    fileprivate func setUpRefreshHeaderView() {
        // 1. 创建
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewStatus))
        // 2. 设置属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        // 3. 设置tableview的header
        tableView.mj_header = header
        // 4. 进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    
    fileprivate func setUpRefreshFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatus))
    }
    
    fileprivate func setUpTipLabel() {
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
//        navigationController?.navigationBar.sendSubview(toBack: tipLabel)
        
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        tipLabel.textColor = UIColor.white
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
    
        tipLabel.isHidden = true
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
    
    @objc fileprivate func loadNewStatus() {
         loadStatuses(isNewData: true)
    }
    
    @objc fileprivate func loadMoreStatus() {
         loadStatuses(isNewData: false)
    }
}

// MARK: - 请求数据
extension HomeViewController {
    fileprivate func loadStatuses(isNewData: Bool) {
        // 1. 获取since_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.statuses?.mid ?? 0
        } else {
            max_id = viewModels.last?.statuses?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetworkTool.shareInstance.loadHomeData(since_id: since_id, max_id: max_id) { (result, error) in
            // 1. 校验错误
            if error != nil {
                return
            }
            // 2. 获取数据
            guard let resultArray = result else {
                return
            }
            
            // 3. 遍历微博对应的字典
            var tempArray = [StatusesViewModel]()
            for dataDic in resultArray {
               let status = Statuses.init(dict: dataDic)
               let viewModel = StatusesViewModel.init(statuses: status)
                tempArray.append(viewModel)
            }
            // 4. 将数据放到成员变量的数组里
            if isNewData {
                self.viewModels = tempArray + self.viewModels
            } else {
                self.viewModels += tempArray
            }

            // 5.缓存图片
            self.cacheImages(tempArray)
        }
    }
    
    fileprivate func cacheImages(_ viewModels: [StatusesViewModel]) {
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
            // 停止刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            self.showTipLabel(count: viewModels.count)
        }
    }
    
    fileprivate func showTipLabel(count: Int) {
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新更新的微博" : "更新了\(count)条微博"
        
        UIView.animate(withDuration: 1.0, animations: { 
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: { 
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
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










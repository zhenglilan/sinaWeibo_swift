//
//  OauthViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/17.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SVProgressHUD

class OauthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationItem()
        loadWebView()
    }

}

// MARK: - UI界面设置
extension OauthViewController {
    fileprivate func setUpNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(returnBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fill))
        title = "微博登录"
    }
    fileprivate func loadWebView() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}
// MARK: - 监听事件点击
extension OauthViewController {
    @objc fileprivate func returnBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fill() {
        let jsCode = "document.getElementById('userId').value='495533108@qq.com',document.getElementById('passwd').value='xhdwkd,.!@0128'"
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK: - webview代理方法
extension OauthViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    
    /// 当准备加载某一个页面，会执行该方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 获得url
        guard let url = request.url else {
            return true
        }
        // url转成string
        let urlStr = url.absoluteString
        // 判断字符串里是否包含code
        guard urlStr.contains("code") else {
            return true
        }
        // 分割字符串将code取出
        let code = urlStr.components(separatedBy: "code=").last!
        // 请求accesstoken
        loadAccessToken(code: code)
        return false
    }
}

// MARK: -请求数据
extension OauthViewController {
    fileprivate func loadAccessToken(code: String) {
        NetworkTool.shareInstance.loadAccessToken(code: code) { (result: [String : Any]?, error: Error?) in
            // 校验错误
            if error != nil {
                print(error ?? "error is nil")
                return
            }
            guard let accountDic = result else {
                print("result is nil")
                return
            }
            // 字典转模型
            let account = UserAccountModel.init(dict: accountDic)
            // 请求用户数据
            self.loadUserInfo(account: account)
        }
    }
}

// MARK: -请求用户信息
extension OauthViewController {
    fileprivate func loadUserInfo(account: UserAccountModel) {
        NetworkTool.shareInstance.loadUserInfo(account: account) { (result, error) in
            if error != nil {
                return
            }
            guard let userInfoDic = result else {
                return
            }
            account.screen_name = userInfoDic["screen_name"] as? String
            account.avatar_large = userInfoDic["avatar_large"] as? String
            // 归档account            
                // 归档
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
            
            // 将account赋值给单例里的account
            UserAccountViewModel.shareUserAccountViewModel.account = account
            // 退出授权页面，显示欢迎页
            self.dismiss(animated: false, completion: { 
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}

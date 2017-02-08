//
//  NetworkTool.swift
//  AFN封装
//
//  Created by 郑丽兰 on 17/1/16.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import AFNetworking

enum RequestType {
    case GET
    case POST
}

class NetworkTool: AFHTTPSessionManager {
    // 单例
    static let shareInstance: NetworkTool = {
        let tool = NetworkTool()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tool
    }()// ()马上执行闭包
}

// MARK- : 封装网络请求方法
extension NetworkTool {
    func request(methodType: RequestType, URLString: String, parameters: [String: Any], finished: @escaping (_ result: Any?, _ error: Error?) -> ()) {
        
        // 定义成功的回调闭包
        let successed = {(task: URLSessionDataTask, result: Any?) in
            finished(result, nil)
        }
        
        // 定义失败的回调闭包
        let failured = { (task: URLSessionDataTask?, error: Error) in
            finished(nil, error)
        }
        
        // 发送网络请求
        if methodType == .GET {
            get(URLString, parameters: parameters, progress: nil, success: successed, failure: failured)
        }else {
            post(URLString, parameters: parameters, progress: nil, success: successed, failure: failured)
        }
    }
}

// MARK- : 请求accessToken
extension NetworkTool {
    func loadAccessToken(code: String, finished: @escaping (_ result: [String: Any]?, _ error: Error?)->()) {
        
        let parameters = ["client_id": app_key,
                          "client_secret": app_secret,
                          "grant_type": "authorization_code",
                          "code": code,
                          "redirect_uri": redirect_uri]
        request(methodType: .POST, URLString: accessTokenURLString, parameters: parameters){(result, error) in
            finished(result as? [String : Any], error)
        }
    }
}

// MARK- : 请求用户数据
extension NetworkTool {
    func loadUserInfo(account: UserAccountModel, finished: @escaping (_ result: [String: Any]?, _ error: Error?)->()) {
        let parameters = ["access_token": account.access_token,
                          "uid": account.uid]
        request(methodType: .GET, URLString: userInfoURLString, parameters: parameters) { (result, error) in
            finished(result as? [String: Any], error)
        }
    }
}

// MARK: - 请求微博首页数据
extension NetworkTool {
    func loadHomeData(since_id: Int, max_id: Int, finished: @escaping (_ result: [[String: Any]]?, _ error: Error?) -> ()) {
        let paramerter = [
            "access_token": (UserAccountViewModel.shareUserAccountViewModel.account?.access_token)!,
            "since_id": "\(since_id)",
            "max_id": "\(max_id)"
            ]
        request(methodType: .GET, URLString: homeTimelineURLString, parameters: paramerter) { (result, error) in
            guard let statusesDic = result as? [String: Any] else {
                return
            }
            finished(statusesDic["statuses"] as? [[String: Any]], error)
         }
    }
}









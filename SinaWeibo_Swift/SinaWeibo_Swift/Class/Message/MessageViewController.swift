//
//  MessageViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/10.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setUpVisitorViewInfo(iconName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }
}

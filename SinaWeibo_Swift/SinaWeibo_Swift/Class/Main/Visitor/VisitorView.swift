//
//  VisitorView.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/12.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    /// 类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    
    // MARK: - 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var rotateImageView: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    // MARK: - 自定义函数
    func setUpVisitorViewInfo(iconName: String, title: String) {
        iconImageView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotateImageView.isHidden = true
    }
    
    func addRotateAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = M_PI * 2
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.duration = 15
        rotationAnimation.isRemovedOnCompletion = false
        rotateImageView.layer.add(rotationAnimation, forKey: nil)
    }
    
}

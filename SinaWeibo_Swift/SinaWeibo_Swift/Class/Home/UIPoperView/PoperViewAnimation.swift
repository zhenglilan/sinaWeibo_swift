//
//  PoperViewAnimation.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/13.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class PoperViewAnimation: NSObject {
    
    var isPresented: Bool = false
    var presentedViewFrame: CGRect = CGRect.zero
    var callBack: ((_ isPopShow: Bool) -> ())?
    init(callBack: @escaping (_ isPopShow: Bool) -> ()) {
        self.callBack = callBack
    }
}
// MARK: - 自定义转场代理的方法
extension PoperViewAnimation: UIViewControllerTransitioningDelegate {
    // 目的： 改变弹出的view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = ZLLPresentationController(presentedViewController: presented, presenting: presenting)
        presentationController.presentedViewFrame = presentedViewFrame
        return presentationController
    }
    
    // 目的： 自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    
    // 目的： 自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
}


// MARK: -自定义动画代理方法
extension PoperViewAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationPresentedView(using: transitionContext) : dismissPresentedView(using: transitionContext)
        
    }
    
    /// 自定义动画弹出
    fileprivate func animationPresentedView(using transitionContext:UIViewControllerContextTransitioning) {
        // 1. 获取弹出的view,
        // UITransitionContextToViewKey 获取弹出的view；
        // UITransitionContextFromViewKey 获取消失的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        
        // 2. 将弹出的view添加到containerview里
        transitionContext.containerView.addSubview(presentedView!)
        
        // 3. 执行动画
        presentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        // 改一下卯点
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            presentedView?.transform = CGAffineTransform.identity
        }) { (_) in
            // 告诉转场上下文已经完成动画
            transitionContext.completeTransition(true)
        }
        
    }
    /// 自定义动画消失
    fileprivate func dismissPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        let dismissPresentedView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            dismissPresentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.000000001)
        }) { (_) in
            dismissPresentedView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

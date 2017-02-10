//
//  ComposeViewController.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/2/7.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    // MARK: - 属性
    fileprivate lazy var titleView: ComposeTitleView = ComposeTitleView()
    fileprivate lazy var imageArrayData: [UIImage] = [UIImage]()
    fileprivate lazy var emotionVC: EmotionViewController = EmotionViewController {[weak self] (emotion) in
        /// 闭包回调函数
        self?.textView.insertEmotion(emotion: emotion)
        self?.textViewDidChange(self!.textView)
    }
    
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    
    // MARK: - 约束属性
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var picPickerHeightConstraint: NSLayoutConstraint!
    

    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
      }
}

// MARK: - 设置UI界面
extension ComposeViewController {
    fileprivate func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(send))
        navigationItem.rightBarButtonItem?.isEnabled = false
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    fileprivate func setUpNotification() {
        /// 监听键盘
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        /// 监听选择照片
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: NSNotification.Name(rawValue: addPicNotification), object: nil)
        
        // 监听删除照片
        NotificationCenter.default.addObserver(self, selector: #selector(deletePhotoClick(_:)), name: NSNotification.Name(rawValue: deletePicNotification), object: nil)
    }
}

// MARK: - 监听事件
extension ComposeViewController {
    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func send() {
        textView.resignFirstResponder()
        let statusText = textView.getEmotionString()
        let finishCallback =  { (isSuccess: Bool) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }

        if let image = imageArrayData.first {
            NetworkTool.shareInstance.sendStatus(statusText: statusText, image: image, isSuccess: finishCallback)
        }else {
            NetworkTool.shareInstance.sendStatus(statusText: statusText, isSuccess:finishCallback)
        }
    }
    
    /// 监听键盘高度
    @objc fileprivate func keyboardWillChangeFrame(_ note: NSNotification) {
        let duration = note.userInfo!["UIKeyboardAnimationDurationUserInfoKey"] as! TimeInterval
        // 获取键盘最终Y
        let endFrame = (note.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 间距
        let margin = UIScreen.main.bounds.height - y
        
        bottomConstraint.constant = margin
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    /// 点击第一个选择照片按钮
    @IBAction func picPickerBtnClick(_ sender: UIButton) {
        textView.resignFirstResponder()
        picPickerHeightConstraint.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 点击第四个切换表情键盘
    @IBAction func swichEmotionKeyboard(_ sender: UIButton) {
        // 退出键盘
        textView.resignFirstResponder()
        // 切换键盘
        textView.inputView = textView.inputView != nil ? nil : emotionVC.view
        // 弹出键盘
        textView.becomeFirstResponder()
    }
}

// MARK: - 监听添加照片和删除照片事件
extension ComposeViewController {
    @objc fileprivate func addPhotoClick() {
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        // 3.设置照片源
        ipc.sourceType = .photoLibrary
        // 4.设置代理
        ipc.delegate = self
        // 弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc fileprivate func deletePhotoClick(_ note: NSNotification) {
        guard let image = note.object as? UIImage else {
            return
        }
        guard let index = imageArrayData.index(of: image) else {
            return
        }
        imageArrayData.remove(at: index)
        picPickerCollectionView.images = imageArrayData
    }
}

// MARK: - 输入框代理方法
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    /// 滚动时收键盘
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
}

// MARK: - UIImagePickerController代理方法
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        print(info)
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        imageArrayData.append(image)
        picPickerCollectionView.images = imageArrayData
        picker.dismiss(animated: true, completion: nil)
    }
}

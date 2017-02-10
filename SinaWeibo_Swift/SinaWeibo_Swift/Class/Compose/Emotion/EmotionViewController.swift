//
//  EmotionViewController.swift
//  EmotionKeyboard
//
//  Created by 郑丽兰 on 17/2/8.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

fileprivate let collectionCellID = "cellID"

class EmotionViewController: UIViewController {
    // 属性
    var emotionCallBack: (_ emotion: Emotion)->()
    
    // MARK: - 懒加载
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmotionCollectionViewLayout())
    fileprivate lazy var toolbar: UIToolbar = UIToolbar()
    // 数据源
    fileprivate lazy var emotionManager: EmotionManager = EmotionManager()
    
    // 自定义构造函数
    init(emotionCallBack: @escaping (_ emotion: Emotion)->()) {
        self.emotionCallBack = emotionCallBack
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}


// MARK: - 界面
extension EmotionViewController {
    func setUpUI() {
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        
        collectionView.backgroundColor = UIColor.yellow
        toolbar.backgroundColor = UIColor.lightGray
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let HConstraint = "H:|-0-[collectionV]-0-|"
        let VConstraint = "V:|-0-[collectionV]-0-[tBar]|"
        let views = ["tBar": toolbar, "collectionV": collectionView] as [String : Any]
        var consArray = NSLayoutConstraint.constraints(withVisualFormat: HConstraint, options: [], metrics: nil, views: views)
        consArray += NSLayoutConstraint.constraints(withVisualFormat: VConstraint, options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        self.view .addConstraints(consArray)
        
        prepareCollectionView()
        
        prepareToolBar()
    }
    
    fileprivate func prepareCollectionView() {
        collectionView.register(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func prepareToolBar() {
        let itemTitles = ["最近", "默认", "emoji", "浪小花"]
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for itemTitle in itemTitles {
            let item = UIBarButtonItem(title: itemTitle, style: .plain, target: self, action: #selector(itemClick(_:)))
            item.tag = index
            index += 1
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        tempItems.removeLast()
        toolbar.items = tempItems
        toolbar.tintColor = UIColor.orange
    }
}

// MARK: - 监听事件点击
extension EmotionViewController {
    @objc fileprivate func itemClick(_ item: UIBarButtonItem) {
//        print(item.tag)
        // 获取tag
        let tag = item.tag
        // 根据tag获取到当前组
        let indexPath = IndexPath(item: 0, section: tag)
        // 滚动到对应位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// MARK: - collectionView代理方法
extension EmotionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emotionManager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let packages = emotionManager.packages[section]
        return packages.emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath) as! EmotionCollectionViewCell
//        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.orange : UIColor.white
        let packages = emotionManager.packages[indexPath.section]
        let emotion = packages.emotions[indexPath.item]
        cell.emotion = emotion
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let package = emotionManager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
        // 添加到最近里面
        addToRecently(emotion: emotion)
        emotionCallBack(emotion)
        
    }
    fileprivate func addToRecently(emotion: Emotion) {
        // 点击空白、删除按钮不添加到最近表情里
        if emotion.isEmpty || emotion.isDelete {
            return
        }
        // 删除相同表情
        if emotionManager.packages.first!.emotions.contains(emotion) {
            let index = (emotionManager.packages.first?.emotions.index(of: emotion))!
            emotionManager.packages.first?.emotions.remove(at: index)
        }else {
           emotionManager.packages.first?.emotions.remove(at: 19)
        }
        // 插入表情
        emotionManager.packages.first?.emotions.insert(emotion, at: 0)
    }
}

// MARK: - 自定义UICollectionViewFlowLayout
class EmotionCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let edgeMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: edgeMargin, left: 0, bottom: edgeMargin, right: 0)
    }
}

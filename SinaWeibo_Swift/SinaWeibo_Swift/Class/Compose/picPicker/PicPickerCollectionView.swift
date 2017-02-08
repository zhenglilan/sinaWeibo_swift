//
//  PicPickerCollectionView.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/2/7.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

fileprivate let picPickerCell = "picPickerCell"
fileprivate let edgeMargin: CGFloat = 13

class PicPickerCollectionView: UICollectionView {

    var images: [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置collectionview的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        
        // 设置collectionview的属性
        register(UINib(nibName: "PicPickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        
        // 设置collectionview的内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
}

extension PicPickerCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerCollectionViewCell
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        return cell
    }
}

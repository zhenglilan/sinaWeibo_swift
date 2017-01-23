//
//  PicCollectionView.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/22.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {
    var picURLs: [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
    }
}

// MARK: - 代理方法
extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: " HomeViewCell", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.row]
        return cell
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var picImageView: UIImageView!

    var picURL: URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            picImageView.sd_setImage(with: picURL, placeholderImage: UIImage(named:"empty_picture"))
        }
    }
    
}

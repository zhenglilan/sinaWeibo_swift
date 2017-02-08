//
//  HomeViewCell.swift
//  SinaWeibo_Swift
//
//  Created by 郑丽兰 on 17/1/20.
//  Copyright © 2017年 zhenglilan. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let edgeMargin: CGFloat = 15
fileprivate let itemMargin: CGFloat = 10

class HomeViewCell: UITableViewCell {

    // MARK: - 控见属性
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vertifierImageView: UIImageView!
    @IBOutlet weak var mbrankImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picCollectionView: PicCollectionView!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var reweetedText: UILabel!
    @IBOutlet weak var retweetedBGView: UIView!
    
    
    // MARK: - 约束属性
    @IBOutlet weak var contentLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopConstraint: NSLayoutConstraint!
    
    
    var viewModel: StatusesViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            // 1. 设置头像
            avatar.sd_setImage(with:viewModel.profileImageURL, placeholderImage: UIImage(named:"avatar_default_small"))
            // 2. 设置微博名称
            screenNameLabel.text = viewModel.statuses?.user?.screen_name
            // 3. 设置时间
            createTimeLabel.text = viewModel.createdAtTest
            // 4. 设置来源
            if let source = viewModel.sourceTest {
                sourceLabel.text = "来自" + source
            } else {
                sourceLabel.text = nil
            }
            // 5. 设置认证图片
            vertifierImageView.image = viewModel.verifiedImage
            // 6. 设置等级图片
            mbrankImageView.image = viewModel.mbrankImage
            // 7. 设置微博正文
            contentLabel.text = viewModel.statuses?.text
            // 8. 设置VIP用户名称颜色
            screenNameLabel.textColor = viewModel.verifiedImage == nil ? UIColor.black : UIColor.orange
            // 9. 计算picView的宽度和高度约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWidthConstraint.constant = picViewSize.width
            picViewHeightConstraint.constant = picViewSize.height
            // 10. 传递数据
            picCollectionView.picURLs = viewModel.picURLs
            
            // 11. 设置转发正文
            if viewModel.statuses?.retweeted_status != nil {
                if let screenName = viewModel.statuses?.retweeted_status?.user?.screen_name, let text = viewModel.statuses?.retweeted_status?.text {
                    reweetedText.text = "@" + "\(screenName): " + text
                    retweetedContentLabelTopConstraint.constant = 15
                }
                retweetedBGView.isHidden = false

            } else {
                reweetedText.text = ""
                retweetedBGView.isHidden = true
                retweetedContentLabelTopConstraint.constant = 0
            }
            
            // 12. 设置转发数量
            if let forwardCount = viewModel.statuses?.reposts_count {
                if forwardCount == 0 {
                    forwardBtn.setTitle("转发", for: .normal)
                }else {
                    forwardBtn.setTitle(String(forwardCount), for: .normal)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置正文的宽度约束
        contentLabelWidthConstraint.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }
}

// MARK: - 计算方法
extension HomeViewCell {
    fileprivate func calculatePicViewSize(count: Int) -> CGSize {
        // 1. 没有配图
        if count == 0 {
            picViewBottomConstraint.constant = 0
            return CGSize.zero
        }
        
        // 有配图
        picViewBottomConstraint.constant = 5
        // 取出layout
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
       
        // 单张配图
        if count == 1 {
            let urlString = viewModel?.picURLs.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)!
            layout.itemSize = CGSize(width: image.size.width * 2, height: image.size.height * 2)
            return CGSize(width: image.size.width * 2, height: image.size.height * 2)
        }
        
        // 2. 计算出来imageView的宽高
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3.0
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        // 3. 四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        // 4. 其它张配图
        // 4.1 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        // 4.2 计算picview的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        // 4.3 计算picview的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}


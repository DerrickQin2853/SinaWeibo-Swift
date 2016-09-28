//
//  DQStatusesCell.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SDWebImage

private let commonMargin: CGFloat = 8
private let pictureCellMargin: CGFloat = 3
//pictureView的最大宽度
private let pictureViewMaxWidth: CGFloat = ScreenWidth - 2 * commonMargin
//每张图片的宽高
private let pictureWH: CGFloat = (pictureViewMaxWidth - 2 * pictureCellMargin) / 3

class DQStatusesCell: UITableViewCell {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userVipImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var membershipLevelImageView: UIImageView!
    @IBOutlet weak var sinceTimeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var pictureView: DQPictureView!
    @IBOutlet weak var pictureViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pictureViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var pictureViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var pictureViewTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var attitudesButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var bottomBar: UIView!
    
    var statusViewModel: DQStatusesViewModel? {
        didSet{
            userIconImageView.sd_setImage(with: statusViewModel?.avatarIconURL)
            userVipImageView.image = statusViewModel?.avatarTypeImage
            membershipLevelImageView.image = statusViewModel?.membershipImage
            userNameLabel.text = statusViewModel?.status?.user?.name
            sinceTimeLabel.text = statusViewModel?.status?.created_at
            sourceLabel.text = statusViewModel?.status?.source
            contentLabel.text = statusViewModel?.status?.text
            
            let picCount = statusViewModel?.pictureInfos?.count ?? 0
            let picViewSize = setPictureViewSize(pictureCount: picCount)
            pictureViewWidthCons.constant = picViewSize.width
            pictureViewHeightCons.constant = picViewSize.height
            pictureViewTopCons.constant = picCount == 0 ? 0 : commonMargin
            
            pictureView.pictureInfos = statusViewModel?.pictureInfos
            
            repostButton.setTitle(statusViewModel?.reposts_text, for: .normal)
            commentButton.setTitle(statusViewModel?.comments_text, for: .normal)
            attitudesButton.setTitle(statusViewModel?.attitudes_text, for: .normal)
            //转发文字
            retweetedContentLabel?.text = statusViewModel?.status?.retweeted_status?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cell选中样式
        selectionStyle = .none
        //内容换行
        contentLabel.preferredMaxLayoutWidth = ScreenWidth - commonMargin * 2
        retweetedContentLabel?.preferredMaxLayoutWidth = ScreenWidth - commonMargin * 2
        //设置flowlayout
        pictureViewFlowLayout.itemSize = CGSize(width: pictureWH, height: pictureWH)
        
        pictureViewFlowLayout.minimumInteritemSpacing = pictureCellMargin
        pictureViewFlowLayout.minimumLineSpacing = pictureCellMargin
    }
    
    func getRowHeight(viewModel: DQStatusesViewModel) -> CGFloat {
        self.statusViewModel = viewModel
        self.contentView.layoutIfNeeded()
        return bottomBar.frame.maxY
    }
    
    
    //根据图片张数设置pictureView的大小
    private func setPictureViewSize(pictureCount: Int) -> CGSize {
        if pictureCount == 0 {
            return CGSize.zero
        }
        else if pictureCount == 4 {
            let WH = pictureWH * 2 + pictureCellMargin
            return CGSize(width: WH, height: WH)
        }
        else {
            //#Warning 加不加括号?
            let rowCount = CGFloat((pictureCount - 1) / 3 + 1)
            let h = rowCount * pictureWH + (rowCount - 1) * pictureCellMargin
            
            return CGSize(width: pictureViewMaxWidth, height: h)
            
        }
    }
    
    
    
}

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

class DQStatusesCell: UITableViewCell {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userVipImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var membershipLevelImageView: UIImageView!
    @IBOutlet weak var sinceTimeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var statusViewModel: DQStatusesViewModel? {
        didSet{
            userIconImageView.sd_setImage(with: statusViewModel?.avatarIconURL)
            userVipImageView.image = statusViewModel?.avatarTypeImage
            membershipLevelImageView.image = statusViewModel?.membershipImage
            userNameLabel.text = statusViewModel?.status?.user?.name
            sinceTimeLabel.text = statusViewModel?.status?.created_at
            sourceLabel.text = statusViewModel?.status?.source
            contentLabel.text = statusViewModel?.status?.text
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cell选中样式
        selectionStyle = .none
        //内容换行
        let aa =  ScreenWidth - commonMargin * 2
        
        contentLabel.preferredMaxLayoutWidth = ScreenWidth - commonMargin * 2
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

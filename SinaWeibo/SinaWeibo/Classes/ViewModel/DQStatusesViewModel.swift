//
//  DQStatusesViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQStatusesViewModel: NSObject {

    //set方法传递
    var status: DQStatuses? {
        didSet{
            dealAvatarIconURL()
            dealAvatarTypeImage()
            dealMembershipImage()
            dealBottomBarButton()
        }
    }
    
    var avatarTypeImage: UIImage?
    var membershipImage: UIImage?
    var avatarIconURL: URL?
    
    //底部三按钮
    //转发的数量
    var reposts_text: String?
    //评论的数量
    var comments_text: String?
    //点赞的数量
    var attitudes_text: String?
    
    var pictureInfos: [DQStatusPictureInfo]? {
        return status?.retweeted_status == nil ? status?.pic_urls : status?.retweeted_status?.pic_urls
    }
    
    //didSet方法封装到外面来
    
    private func dealAvatarIconURL() {
        let urlString = status?.user?.avatar_large ?? ""
        avatarIconURL = URL(string: urlString)
    }
    private func dealAvatarTypeImage() {
        let type = status?.user?.verified_type ?? -1
        switch type {
        case 0:
            avatarTypeImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            avatarTypeImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            avatarTypeImage = #imageLiteral(resourceName: "avatar_grassroot")
        default:
            avatarTypeImage = nil
        }
    }
    private func dealMembershipImage() {
        //在if let/var 语句中赋值对象后面跟 ',' ','就可以直接使用前面赋值的对象
        if let mbrank = status?.user?.mbrank, mbrank > 0 && mbrank < 7 {
            let imageName = "common_icon_membership_level\(mbrank)"
            membershipImage = UIImage(named: imageName)
        }
    }
    
    private func dealBottomBarButton() {
        reposts_text = getBottomBarButtonText(count: status?.reposts_count ?? 0, defaultText: "转发")
        comments_text = getBottomBarButtonText(count: status?.comments_count ?? 0, defaultText: "评论")
        attitudes_text = getBottomBarButtonText(count: status?.attitudes_count ?? 0, defaultText: "点赞")
    }
    
    private func getBottomBarButtonText(count: Int, defaultText: String) -> String {
//        if count == 0 {
//            return defaultText
//        }
        if count > 10000 {
            return "\(Double(count / 1000) / 10)万"
        }
//        return count.description
        return "\(count)"
    }
}

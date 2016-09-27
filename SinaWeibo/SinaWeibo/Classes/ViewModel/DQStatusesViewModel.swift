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
            getAvatarIconURL()
            getAvatarTypeImage()
            getMembershipImage()
        }
    }
    
    var avatarTypeImage: UIImage?
    var membershipImage: UIImage?
    var avatarIconURL: URL?
    
    //didSet方法封装到外面来
    
    private func getAvatarIconURL() {
        let urlString = status?.user?.avatar_large ?? ""
        avatarIconURL = URL(string: urlString)
    }
    private func getAvatarTypeImage() {
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
    private func getMembershipImage() {
        //在if let/var 语句中赋值对象后面跟 ',' ','就可以直接使用前面赋值的对象
        if let mbrank = status?.user?.mbrank, mbrank > 0 && mbrank < 7 {
            let imageName = "common_icon_membership_level\(mbrank)"
            membershipImage = UIImage(named: imageName)
        }
    }
}

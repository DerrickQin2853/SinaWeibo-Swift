//
//  DQUser.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQUser: NSObject {

//    var userId: Int64 = 0
    
    var name: String?
    
    var avatar_large: String?
    //会员等级
    var mbrank: Int = 0
    /// 认证类型: -1：没有认证，0：认证用户，2,3,5: 企业认证，220: 达人
    var verified_type: Int = 0
    
}

//
//  DQStatuses.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import YYModel

class DQStatuses: NSObject, YYModel {

    //微博ID
    var id: Int = 0
    
    var text: String?
    
    var created_at: String?
    
    var source: String?
    
    var user: DQUser?
    
    var pic_urls: DQStatusPictureInfo?
    
    //实际上是告诉YYModel在转换字典数组的时候 需要将字典转成什么类型的模型对象

    static func modelContainerPropertyGenericClass() -> [String : Any]? {
        return ["pic_urls" : DQStatusPictureInfo.self]
    }
}

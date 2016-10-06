//
//  DQStatusPictureInfo.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQStatusPictureInfo: NSObject {
    
    var thumbnail_pic: String? {
        didSet{
         bmiddle_pic = thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        wap360_pic = thumbnail_pic?.replacingOccurrences(of: "thumbnail", with: "wap360")
        }
    }
    
    var bmiddle_pic: String?
    
    var wap360_pic: String?
    
}

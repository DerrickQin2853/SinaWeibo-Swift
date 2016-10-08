//
//  DQEmoticon.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQEmoticon: NSObject {
    //想服务器发送的表情文字
    var chs: String?
    //本地用来匹配文字 显示对应的图片
    var png: String?
    //0 就是图片表情 1 就是Emoji表情
    var type: Int = 0
    //Emoji表情的十六进制的字符串
    var code: String?
}

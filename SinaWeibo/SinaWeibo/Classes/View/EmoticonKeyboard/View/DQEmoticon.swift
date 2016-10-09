//
//  DQEmoticon.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQEmoticon: NSObject, NSCoding {
    //想服务器发送的表情文字
    var chs: String?
    //本地用来匹配文字 显示对应的图片
    var png: String?
    //0 就是图片表情 1 就是Emoji表情
    var type: Int = 0
    //Emoji表情的十六进制的字符串
    var code: String? {
        didSet{
            emojiString = ((code ?? "") as NSString).emoji()
        }
    }
    
    //图片路径：只有图片表情才有，emoji没有
    var imagePath: String?
    
    var emojiString: String?
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //给对象发送消息 ,需要确保对象已经被实例化
        super.init()
        self.yy_modelInit(with: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        yy_modelEncode(with: aCoder)
    }

}

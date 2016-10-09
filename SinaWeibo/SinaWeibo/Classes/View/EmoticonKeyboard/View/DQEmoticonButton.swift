//
//  DQEmoticonButton.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/9.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQEmoticonButton: UIButton {

    var emoticon: DQEmoticon? {
        didSet{
            let bundle = DQEmoticonTools.sharedTools.emoticonBundle
            
            if emoticon!.type == 0 {
                let image = UIImage(named: emoticon!.imagePath!, in: bundle, compatibleWith: nil)
                setImage(image, for: .normal)
                setTitle(nil, for: .normal)
            }
            else{
                setImage(nil, for: .normal)
                setTitle(emoticon!.emojiString, for: .normal)
            }
        }
    }
}

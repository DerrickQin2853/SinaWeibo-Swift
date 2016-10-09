//
//  DQEmoticonPopView.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/10.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import pop

class DQEmoticonPopView: UIView {

    @IBOutlet weak var emoticonButton: DQEmoticonButton!
    
    var lastEmoticon: DQEmoticon?

    class func loadPopoView() -> DQEmoticonPopView {
        let nib = UINib(nibName: "DQEmoticonPopView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).last as! DQEmoticonPopView
    }
    
    func showEmoticon() {
        
        if let em = lastEmoticon {
            if em.chs == emoticonButton.emoticon?.chs {
                return
            }
            if em.code == emoticonButton.emoticon?.code {
                return
            }
        }

        
        let anim = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)!
        
        anim.fromValue = 40
        anim.toValue = 25
        
        anim.springBounciness = 20
        anim.springSpeed = 20
        emoticonButton.pop_add(anim, forKey: nil)
    }


}

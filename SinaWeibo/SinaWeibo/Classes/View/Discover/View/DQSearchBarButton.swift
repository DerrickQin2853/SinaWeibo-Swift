//
//  DQSearchBarButton.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

@IBDesignable class DQSearchBarButton: UIButton {

    //类方法
    class func loadSearchButton () -> DQSearchBarButton {
       return UINib(nibName: "DQSearchBarButton", bundle: nil).instantiate(withOwner: nil, options: nil).last as! DQSearchBarButton
    }
    
    
    override func awakeFromNib() {
        //设置图片的内边距
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        //设置文字的内边距
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        //通过代码的方式设置宽度
        bounds.size.width = UIScreen.main.bounds.width
        
        adjustsImageWhenHighlighted = false
    }
    
    

}

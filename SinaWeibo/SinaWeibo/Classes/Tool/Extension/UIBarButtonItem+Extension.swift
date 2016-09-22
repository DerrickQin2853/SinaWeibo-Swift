//
//  UIBarButtonItem+Extension.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    //便捷初始化方法
    convenience init(title: String = "", imageName: String, target: Any?, action: Selector) {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitleColor(UIColor.orange, for: .highlighted)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        
        button.sizeToFit()
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.init()
        
        customView = button
    }
}

//
//  UIButton+Extension.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/23.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, textColor:UIColor, textFontSize: CGFloat) {
        self.init()
        setTitle(title, for: .normal)
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: textFontSize)
        self.sizeToFit()
    }
}

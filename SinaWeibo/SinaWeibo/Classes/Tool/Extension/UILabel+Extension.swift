//
//  UILabel+Extension.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/23.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(title: String, textColor: UIColor, textFontSize: CGFloat) {
        self.init()
        self.text = title
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: textFontSize)
        self.sizeToFit()
    }
}

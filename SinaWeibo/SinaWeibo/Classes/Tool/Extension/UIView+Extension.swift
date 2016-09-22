//
//  UIView+Extension.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get{
            return layer.cornerRadius
        }
        
        set{
            layer.cornerRadius = newValue
            //右边表达式,新值为true
            layer.masksToBounds = newValue > 0
        }
    }
    
}

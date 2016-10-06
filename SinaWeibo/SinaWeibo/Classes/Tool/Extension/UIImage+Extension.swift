//
//  UIImage+Extension.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
//截取当前屏幕
extension UIImage {
    class func snapShotCurrentScreen() -> UIImage {
        let currentWindow = UIApplication.shared.keyWindow!
        
        UIGraphicsBeginImageContextWithOptions(currentWindow.bounds.size, false, UIScreen.main.scale)
        currentWindow.drawHierarchy(in: currentWindow.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

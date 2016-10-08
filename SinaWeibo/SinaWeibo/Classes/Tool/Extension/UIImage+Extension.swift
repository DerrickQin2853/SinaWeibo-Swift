//
//  UIImage+Extension.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
extension UIImage {
    //截取当前屏幕
    class func snapShotCurrentScreen() -> UIImage {
        let currentWindow = UIApplication.shared.keyWindow!
        
        UIGraphicsBeginImageContextWithOptions(currentWindow.bounds.size, false, UIScreen.main.scale)
        currentWindow.drawHierarchy(in: currentWindow.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
   //缩小图片，减少内存
    func scaleImage(width: CGFloat) -> UIImage {
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        
        if originalWidth < width {
            return self
        }
        let height = originalHeight / originalWidth * width
        let imageBounds = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, UIScreen.main.scale)
        self.draw(in: imageBounds)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

//
//  Common.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/25.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit


//定义屏幕宽度和高度
let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

let client_id = "2288790350"
let client_secret = "d928fdf706d6a235e9eee46a8e0b85e0"
let redirect_uri = "http://www.itheima.com"

let navBarHeight: CGFloat = 64

let errorTip = "网络出现错误"

let kChangeRootControllerNotification = "ChangeRootControllerNotification"


//定义全局的方法 随机色

func randomColor() -> UIColor {
    let r = CGFloat(arc4random() % 256) / 255.0
    let g = CGFloat(arc4random() % 256) / 255.0
    let b = CGFloat(arc4random() % 256) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1)
}

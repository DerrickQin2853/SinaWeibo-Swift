//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerNotification()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = DQUserAccountViewModel.sharedViewModel.userLogin ? DQWelcomeViewController() : DQTabBarController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    //注册通知
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setRootViewController(notification:)), name: Notification.Name(rawValue:kChangeRootControllerNotification), object: nil)
    }
    //响应通知，切换根控制器
    @objc private func setRootViewController(notification: NSNotification) {
        if (notification.object as! NSString).isEqual(to: "TabBar")  {
            window?.rootViewController = DQTabBarController()
        }
        else if (notification.object as! NSString).isEqual(to: "Welcome") {
            window?.rootViewController = DQWelcomeViewController()
        }
    }
    //没有逻辑意义，但保持代码美观
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


//
//  DQTabBarController.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置自定义tabbar
        let baseTabBar = DQBaseTabBar()
        //使用KVC
        setValue(baseTabBar, forKey: "tabBar")
        
        baseTabBar.composeButtonClosure = {
            print("composeButton Click!")
        }
        
        //添加子控制器
        addChildViewControllers()
    }

    private func addChildViewControllers() {
        addChildViewController(viewController: DQHomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(viewController: DQMessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(viewController: DQDiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(viewController: DQProfileViewController(), title: "我", imageName: "tabbar_profile")
    }

    private func addChildViewController(viewController: UIViewController, title: String, imageName: String) {
        //设置title
        viewController.navigationItem.title = title
        
        //BUG:要同时设置title 和图片才可以显示
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        //选中图片
        viewController.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        //设置文字颜色
        viewController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected)
        //设置字体
//        viewController.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 12)], for: .normal)
        //设置偏移
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        //设置徽标
        viewController.tabBarItem.badgeValue = nil
        
        //设置控制器
        let navigationVC = DQBaseNavigationController(rootViewController: viewController)
        
        addChildViewController(navigationVC)
        
    }
}

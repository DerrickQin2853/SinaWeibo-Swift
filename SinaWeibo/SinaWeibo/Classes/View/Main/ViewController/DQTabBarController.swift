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
        addChildViewController(viewController: DQHomeViewController(), title: "首页", imageName: "tabbar_home",index: 0)
        addChildViewController(viewController: DQMessageViewController(), title: "消息", imageName: "tabbar_message_center",index: 1)
        addChildViewController(viewController: DQDiscoverViewController(), title: "发现", imageName: "tabbar_discover",index: 2)
        addChildViewController(viewController: DQProfileViewController(), title: "我", imageName: "tabbar_profile",index: 3)
    }

    private func addChildViewController(viewController: UIViewController, title: String, imageName: String, index: Int) {
        //设置title
        viewController.navigationItem.title = title
        
        //BUG:要同时设置title 和图片才可以显示
        viewController.tabBarItem.title = title
        //添加tag
        viewController.tabBarItem.tag = index
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var index = 0
        for subview in tabBar.subviews {
            if subview.isKind(of: NSClassFromString("UITabBarButton")!) {
                if index == item.tag{
                    for target in subview.subviews {
                        if target.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                            target.transform = CGAffineTransform.init(scaleX: 0.4, y: 0.4)
                            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: { 
                                target.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                                }, completion: nil)
                        }
                    }
                }
                index += 1
            }
        }
    }
}

//
//  DQBaseNavigationController.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        let vcCount = childViewControllers.count
        
        if vcCount > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", imageName: "navigationbar_back_withtext", target: self, action: #selector(backItemClick))
            //push后隐藏tabbar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)

    }
    
    @objc private func backItemClick() {
        popViewController(animated: true)
    }

}

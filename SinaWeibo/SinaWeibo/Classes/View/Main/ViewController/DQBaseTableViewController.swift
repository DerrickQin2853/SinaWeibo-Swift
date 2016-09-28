//
//  DQBaseTableViewController.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/23.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQBaseTableViewController: UITableViewController, DQVisitorLoginViewDelegate {

    //用户是否登录标签
    var isUserLogin = DQUserAccountViewModel.sharedViewModel.userLogin
    //懒加载 游客界面
    lazy var visitorLoginView: DQVisitorLoginView = DQVisitorLoginView()
    
    override func loadView() {
        //判断是否登录
        if isUserLogin {
            super.loadView()
        }
        else{
            view = visitorLoginView;
            visitorLoginView.delegate = self;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //代理方法实现
    func userLogin() {
        //model推送页面
        let oauthVC = DQOauthViewController()
        
        let oauthNavigationVC = UINavigationController(rootViewController: oauthVC)
        
        present(oauthNavigationVC, animated: true, completion: nil)
        
    }
    
    func userRegister() {
        print("注册按钮点击")
    }
}

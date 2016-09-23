//
//  DQBaseTableViewController.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/23.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQBaseTableViewController: UITableViewController, DQDQVisitorLoginViewDelegate {

    //用户是否登录标签
    var isUserLogin = false
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
        print("登录按钮点击")
        
        //网络测试
        let urlString = "http://www.weather.com.cn/data/sk/101010100.html"
        
        DQNetworkTools.sharedTools.requset(method: .Get, urlString: urlString, parameters: nil) { (responseObject, error) in
            
            if error != nil {
                print(error)
                return
            }
            //请求成功
            print(responseObject!)
        }
        
    }
    
    func userRegister() {
        print("注册按钮点击")
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

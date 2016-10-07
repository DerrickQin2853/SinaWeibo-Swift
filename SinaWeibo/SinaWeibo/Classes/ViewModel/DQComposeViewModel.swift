//
//  DQComposeViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQComposeViewModel: NSObject {

    func postStatus(statusText: String, finish:@escaping ((Bool) -> ())) {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        //在数组和字典中不能够直接添加隐式的可选类型
        let parameters = ["access_token" : DQUserAccountViewModel.sharedViewModel.userInfo?.access_token ?? "" ,
                          "status" : statusText]
        DQNetworkTools.sharedTools.requset(method: .Post, urlString: urlString, parameters: parameters) { (_, error) in
            if error != nil {
                finish(false)
                return
            }
            
            finish(true)
        }

    }
}

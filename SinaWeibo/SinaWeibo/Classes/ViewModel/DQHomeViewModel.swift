//
//  DQHomeViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQHomeViewModel: NSObject {
    //懒加载
    lazy var statusesViewModelArray: [DQStatusesViewModel] = [DQStatusesViewModel]()
    
    func loadData(finish:@escaping (Bool) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token":DQUserAccountViewModel.sharedViewModel.userInfo?.access_token ?? ""]
        
        DQNetworkTools.sharedTools.requset(method: .Get, urlString: urlString, parameters: parameters) { (responseObject, error) in
            if error != nil {
                print(error)
                finish(false)
                return
            }
            let dict = responseObject as! [String:Any]
            
            guard let statusesArray = dict["statuses"] as? [[String:Any]] else{
                finish(false)
                return
            }
            
            for item in statusesArray {
                let statusesViewModel = DQStatusesViewModel()
                let status = DQStatuses()
                status.yy_modelSet(with: item)
                statusesViewModel.status = status
                self.statusesViewModelArray.append(statusesViewModel)
            }
            //执行成功
            
            finish(true)
        }
    }
}

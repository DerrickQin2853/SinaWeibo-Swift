//
//  DQHomeViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SDWebImage

class DQHomeViewModel: NSObject {
    //懒加载
    lazy var statusesViewModelArray: [DQStatusesViewModel] = [DQStatusesViewModel]()
    
    func loadData(isPullUp: Bool, finish:@escaping (Bool, Int) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        var parameters = ["access_token":DQUserAccountViewModel.sharedViewModel.userInfo?.access_token ?? ""]
        
        //添加上拉下拉刷新的判断
        if isPullUp {
            //上拉
            let max_id = (statusesViewModelArray.last?.status?.id ?? 0) - 1
            parameters["max_id"] = "\(max_id)"
        }
        else{
            //下拉
            let since_id = statusesViewModelArray.first?.status?.id ?? 0
            parameters["since_id"] = "\(since_id)"
        }
        
        
        DQNetworkTools.sharedTools.requset(method: .Get, urlString: urlString, parameters: parameters) { (responseObject, error) in
            if error != nil {
                print(error)
                finish(false,0)
                return
            }
            let dict = responseObject as! [String:Any]
            
            guard let statusesArray = dict["statuses"] as? [[String:Any]] else{
                finish(false,0)
                return
            }
            
            var tempArray = [DQStatusesViewModel]()
            
            for item in statusesArray {
                let statusesViewModel = DQStatusesViewModel()
                let status = DQStatuses()
                status.yy_modelSet(with: item)
                statusesViewModel.status = status
                tempArray.append(statusesViewModel)
            }
            //执行成功
            if isPullUp {
                self.statusesViewModelArray = self.statusesViewModelArray + tempArray
            }
            else{
                self.statusesViewModelArray = tempArray + self.statusesViewModelArray
            }
            
            
//            finish(true,tempArray.count)
            self.loadSinglePicture(dataArray: tempArray,loadSingleFinished: finish)
        }
    }
    
    private func loadSinglePicture(dataArray:[DQStatusesViewModel], loadSingleFinished: @escaping ((Bool,Int) -> ())) {
        let group = DispatchGroup.init()
        for viewModel in dataArray {
            if viewModel.pictureInfos?.count == 1 {
                let url = URL(string: viewModel.pictureInfos?.first?.wap360_pic ?? "")
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                    group.leave()
                })
            }
            
        }
        group.notify(queue: DispatchQueue.main) { 
            loadSingleFinished(true,dataArray.count)
        }
    }
    
}

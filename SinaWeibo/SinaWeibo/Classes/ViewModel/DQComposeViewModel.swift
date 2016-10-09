//
//  DQComposeViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQComposeViewModel: NSObject {
    //发布文字微博
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
    
    //发布文字带图微博
    func postStatusWithOnePicture(statusText: String, images: [UIImage] , finish:@escaping ((Bool) -> ())) {
        let urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        let parameters = ["access_token" : DQUserAccountViewModel.sharedViewModel.userInfo?.access_token ?? "" ,
                          "status" : statusText]
        DQNetworkTools.sharedTools.post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
//            var tempData = Data()
//            
//            for value in images.enumerated() {
//                let imageData = UIImagePNGRepresentation(value.element)
//                
//                tempData.append(imageData!)
//               
//            }
            let imageData = UIImagePNGRepresentation(images.last!)
             formData.appendPart(withFileData: imageData!, name: "pic", fileName: "Weibopic2016", mimeType: "application/octet-stream")
            
            }, progress: nil, success: { (_, _) in
                finish(true)
            }) { (_, error) in
                print(error)
                finish(false)
        }
    }
    
}

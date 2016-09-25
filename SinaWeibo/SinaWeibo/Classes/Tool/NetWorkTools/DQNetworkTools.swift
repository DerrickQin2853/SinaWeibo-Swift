//
//  DQNetworkTools.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/23.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import AFNetworking

enum HttpMethod {
    case Get
    case Post
}

class DQNetworkTools: AFHTTPSessionManager {

    //单例对象
    static let sharedTools: DQNetworkTools = {
       let tools = DQNetworkTools()
       tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    

    
    //核心方法
    func requset(method: HttpMethod, urlString: String, parameters: Any?, finished: @escaping ((Any?,Error?) -> ())) {
        
        let successClosure = {(task: URLSessionDataTask,responseObject: Any?) -> () in
            finished(responseObject,nil)
        }
        
        let failureClosure = {(task: URLSessionDataTask?, error: Error) -> () in
            print(error)
            finished(nil,error)
        }
        
        if method == .Get {
            get(urlString, parameters: parameters, progress: nil, success: successClosure, failure: failureClosure)
        }
        else if method == .Post {
            post(urlString, parameters: parameters, progress: nil, success: successClosure, failure: failureClosure)
        }
    }
    
}

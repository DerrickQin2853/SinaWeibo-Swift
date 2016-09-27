//
//  DQUserAccountViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/25.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

private let localPathForUserInfo = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")


class DQUserAccountViewModel: NSObject {
    
    
    //单例
    static let sharedViewModel: DQUserAccountViewModel = DQUserAccountViewModel()
    /*
     赋值有两种情况
     1. 用户未登陆 -> 输入用户名,密码 -> 授权 -> 截取code -> code 换token, 获取用户信息 -> 给用户信息赋值
     2. 用户已经登陆,第二次打开应用的时候 -> 从沙盒中获取用户信息  -> 给 userAccount赋值
     */
    var userInfo: DQUserInfo?
    
    var userLogin: Bool {
        if userInfo?.access_token != nil && isExpires == false {
            return true
        }
        return false
    }
    var isExpires: Bool {
        if userInfo?.expires_date?.compare(Date()) == ComparisonResult.orderedDescending {
            return false
        }
        return true
    }
    
    var userIconURL: URL? {
        let urlString = userInfo?.avatar_large ?? ""
        let url = URL(string: urlString)
        return url
    }
    
    ///重写init
    override init() {
        super.init()
        self.userInfo = loadUserInfoFromLocal()
    }
    
    
   ///获取token接口
    internal func loadAccessToken(code: String, finish: @escaping ((Bool)->())) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        
        let paramenters = ["client_id":client_id,
                           "client_secret":client_secret,
                           "grant_type":"authorization_code",
                           "code":code,
                           "redirect_uri":redirect_uri]
        
        DQNetworkTools.sharedTools.requset(method: .Post, urlString: urlString, parameters: paramenters) { (responseObject, error) in
            if error != nil {
                finish(false)
                return
            }
            //请求成功返回
            self.loadUserInfo(dict: responseObject as! [String : Any], finish: finish)
        }
    }
    
    private func loadUserInfo(dict: [String : Any], finish: @escaping ((Bool)->())) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        let access_token = dict["access_token"]!
        let uid = dict["uid"]!
        let parameters = ["access_token":access_token,
                          "uid":uid]
        
        DQNetworkTools.sharedTools.requset(method: .Get, urlString: urlString, parameters: parameters) { (responseObject, error) in
            if error != nil {
                print(error)
                finish(false)
                return
            }
            
            //请求成功
            var userInfoDict = responseObject as! [String : Any]
            //合并字典
            for keyValues in dict {
                userInfoDict[keyValues.key] = keyValues.value
            }
            
            //字典转模型
            let userInfoModel = DQUserInfo.init(dict: userInfoDict)
            
            self.saveUserInfoToLocal(userInfoModel: userInfoModel)
            
            self.userInfo = userInfoModel
            
            finish(true)
        }
        
        
    }
    //用户信息存入本地
    private func saveUserInfoToLocal(userInfoModel: DQUserInfo) {
        NSKeyedArchiver.archiveRootObject(userInfoModel, toFile: localPathForUserInfo)
    }
    
    //从本地读取用户信息
    private func loadUserInfoFromLocal() -> DQUserInfo? {
        let userInfoModel = NSKeyedUnarchiver.unarchiveObject(withFile: localPathForUserInfo) as? DQUserInfo
        return userInfoModel
    }
}

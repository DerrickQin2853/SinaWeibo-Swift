//
//  DQUserInfoModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/25.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQUserInfoModel: NSObject, NSCoding {

    var access_token: String?
    
    var expires_in: Int = 0 {
        didSet {
            expires_date = Date(timeIntervalSinceNow: Double(expires_in))
        }
    }
    
    var expires_date: Date?
    
    var uid: String?
    
    var name: String?
    
    var avatar_large: String?
    
    //init方法
    init(dict: [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //过滤不需要属性
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
    
    //归档
   func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(expires_date, forKey: "expires_date")
        
    }
    
    //解档
    required init?(coder aDecoder: NSCoder) {
        //给模型的属性赋值
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
    }

    
}

//
//  DQEmoticonTools.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQEmoticonTools: NSObject {

    static let sharedTools: DQEmoticonTools = DQEmoticonTools()
    
    func loadEmoticon(infoName: String) -> [DQEmoticon]{
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)
        let emoticonBundle = Bundle.init(path: path!)!
        let infoPath = emoticonBundle.path(forResource: infoName + "/info.plist", ofType: nil)
        let dataArray = NSArray(contentsOfFile: infoPath!) as! [[String:Any]]
        var emoticonArray = [DQEmoticon]()
        for item in dataArray {
            let temp = DQEmoticon()
            temp.yy_modelSet(with: item)
            emoticonArray.append(temp)
        }
        return emoticonArray
    }
    
}

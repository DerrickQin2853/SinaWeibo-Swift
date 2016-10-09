//
//  DQEmoticonTools.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

//通知key
let KsaveRecentEmoticon = "KsaveRecentEmoticon"
let KSelectEmoticon =  "KSelectEmoticon"

//沙盒路径
private let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("recent.plist")

//每页最多有多少个表情
let emoticonPageMaxCount = 20

class DQEmoticonTools: NSObject {

    static let sharedTools: DQEmoticonTools = DQEmoticonTools()
    
    
    func saveRecentEmoticons(emoticon: DQEmoticon) {
        
        if recentEmoticons.contains(emoticon) {
            guard let index = recentEmoticons.index(of: emoticon) else {
                return
            }
            recentEmoticons.remove(at: index)
        }
        recentEmoticons.insert(emoticon, at: 0)
        
        if recentEmoticons.count > 20 {
            recentEmoticons.removeLast()
        }
        allEmoticon[0][0] = recentEmoticons
        
        //存沙盒
        NSKeyedArchiver.archiveRootObject(recentEmoticons, toFile: path)
        //发通知
        NotificationCenter.default.post(name: NSNotification.Name(KsaveRecentEmoticon), object: nil)
    }
    
    
    /// 将模型数组切割成二维数组
    private func splitEmoticons(emoticons:[DQEmoticon]) -> [[DQEmoticon]] {
        let cellPageCount = (emoticons.count - 1) / emoticonPageMaxCount + 1
        
        var sectionEmoticons = [[DQEmoticon]]()
        
        for i in 0..<cellPageCount {
            let loc = i * emoticonPageMaxCount
            var len = emoticonPageMaxCount
            if loc + len > emoticons.count {
                len = emoticons.count - loc
            }
            let splitedArray = (emoticons as NSArray).subarray(with: NSMakeRange(loc, len))
            
            sectionEmoticons.append(splitedArray as! [DQEmoticon])
        }
        return sectionEmoticons
    }
    
    
    /// 根据不同的路径返回不同的表情模型数组
    private func loadEmoticon(infoName: String) -> [DQEmoticon]{
        
        let infoPath = emoticonBundle.path(forResource: infoName + "/info.plist", ofType: nil)
        let dataArray = NSArray(contentsOfFile: infoPath!) as! [[String:Any]]
        var emoticonArray = [DQEmoticon]()
        for item in dataArray {
            let temp = DQEmoticon()
            temp.yy_modelSet(with: item)
            
            if let img = temp.png {
                temp.imagePath = infoName + "/" + img
            }
            
            emoticonArray.append(temp)
        }
        return emoticonArray
    }
    
    
    //所有的表情数组 
    lazy var allEmoticon: [[[DQEmoticon]]] = {
        return [[self.recentEmoticons],
                self.splitEmoticons(emoticons: self.defaultEmoticons),
                self.splitEmoticons(emoticons: self.emojiEmoticons),
                self.splitEmoticons(emoticons: self.lxhEmoticons)]
    }()
    
    //懒加载bundle对象
    lazy var emoticonBundle: Bundle = {
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)
        let bundle = Bundle.init(path: path!)!
        return bundle
    }()
    //最近表情数组
    lazy var recentEmoticons: [DQEmoticon] = {
        
        if let array = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [DQEmoticon] {
            return array
        }
        
        return [DQEmoticon]()
    }()
    //默认表情数组
    lazy var defaultEmoticons: [DQEmoticon] = {
        return self.loadEmoticon(infoName: "default")
    }()
    //emoji表情数组
    lazy var emojiEmoticons: [DQEmoticon] = {
        return self.loadEmoticon(infoName: "emoji")
    }()
    //浪小花表情数组
    lazy var lxhEmoticons: [DQEmoticon] = {
        return self.loadEmoticon(infoName: "lxh")
    }()
}

//
//  DQStatusesViewModel.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/27.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQStatusesViewModel: NSObject {

    //set方法传递
    var status: DQStatuses? {
        didSet{
            dealAvatarIconURL()
            dealAvatarTypeImage()
            dealMembershipImage()
            dealBottomBarButton()
            sourceText = dealSourceText()
        }
    }
    
    var avatarTypeImage: UIImage?
    var membershipImage: UIImage?
    var avatarIconURL: URL?
    
    //底部三按钮
    //转发的数量
    var reposts_text: String?
    //评论的数量
    var comments_text: String?
    //点赞的数量
    var attitudes_text: String?
    
    var pictureInfos: [DQStatusPictureInfo]? {
        return status?.retweeted_status == nil ? status?.pic_urls : status?.retweeted_status?.pic_urls
    }
    
    var sourceText: String?
    /*
     今年:
       今天:
       - 60s之内   --> 刚刚
       - 一小时之内  --> xx分钟前
       - 其他: 多少小时前
       昨天:
        - 昨天 HH:mm
        其他:
        - MM-dd
     非当年:
     - yyyy-MM-dd
     */
    var sinceTimeText: String? {
        let dateString = status?.created_at ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        dateFormatter.locale = Locale(identifier: "en")
        let createDate = dateFormatter.date(from: dateString)
        guard let tempDate = createDate else{
            return ""
        }
        
        let calendar = Calendar.current
        
        if isThisYear(targetDate: tempDate) {
            if calendar.isDateInToday(tempDate) {
                let date = Date()
                let detla =  date.timeIntervalSince(tempDate)
                if detla < 60 {
                    return "刚刚"
                } else if detla < 3600 {
                    return "\(Int(detla) / 60)分钟前"
                } else {
                    return "\(Int(detla) / 3600)小时前"
                }
            }
            else if calendar.isDateInYesterday(tempDate){
                dateFormatter.dateFormat = "昨天 HH:mm"
                return dateFormatter.string(from: tempDate)
            }
            else{
                dateFormatter.dateFormat = "MM-dd"
                return dateFormatter.string(from: tempDate)
            }
        }
        else{
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: tempDate)
        }
        
    }
    
    var isFisrt: Bool = false
    
    //didSet方法封装到外面来
    
    private func dealAvatarIconURL() {
        let urlString = status?.user?.avatar_large ?? ""
        avatarIconURL = URL(string: urlString)
    }
    private func dealAvatarTypeImage() {
        let type = status?.user?.verified_type ?? -1
        switch type {
        case 0:
            avatarTypeImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            avatarTypeImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            avatarTypeImage = #imageLiteral(resourceName: "avatar_grassroot")
        default:
            avatarTypeImage = nil
        }
    }
    private func dealMembershipImage() {
        //在if let/var 语句中赋值对象后面跟 ',' ','就可以直接使用前面赋值的对象
        if let mbrank = status?.user?.mbrank, mbrank > 0 && mbrank < 7 {
            let imageName = "common_icon_membership_level\(mbrank)"
            membershipImage = UIImage(named: imageName)
        }
    }
    
    private func dealBottomBarButton() {
        reposts_text = getBottomBarButtonText(count: status?.reposts_count ?? 0, defaultText: "转发")
        comments_text = getBottomBarButtonText(count: status?.comments_count ?? 0, defaultText: "评论")
        attitudes_text = getBottomBarButtonText(count: status?.attitudes_count ?? 0, defaultText: "点赞")
    }
    
    private func getBottomBarButtonText(count: Int, defaultText: String) -> String {
        if count > 10000 {
            return "\(Double(count / 1000) / 10)万"
        }
        return "\(count)"
    }
    //判断是不是第一条微博，是的话消除灰色分隔条
    func dealIsFirst(index: Int) {
        if index == 0 {
            isFisrt = true
        }
    }
    
    private func isThisYear(targetDate: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        dateFormatter.locale = Locale(identifier: "en")
        
        let currentTime = Date()
        
        dateFormatter.dateFormat = "yyyy"
        
        let targetYear = dateFormatter.string(from: targetDate)
        let currentYear = dateFormatter.string(from: currentTime)

        return currentYear == targetYear
    }
    
    //处理来源
    private func dealSourceText() -> String {
    // <a href=\"http://app.weibo.com/t/feed/3jskmg\" rel=\"nofollow\">iPhone 6s</a>
        let originString = status?.source ?? ""
        
        let startTag = "\">"
        let endTag = "</a>"
        
        guard let startRangeIndex = originString.range(of: startTag),
           let endRangeIndex = originString.range(of: endTag) else{
                return "来自未知设备"
        }
        
        let startIndex = startRangeIndex.upperBound
        let endIndex = endRangeIndex.lowerBound
        let rangeIndex = startIndex..<endIndex
        return "来自" + originString.substring(with: rangeIndex)
    }
}

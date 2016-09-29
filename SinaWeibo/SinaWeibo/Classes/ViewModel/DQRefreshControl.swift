//
//  DQRefreshControl.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/29.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

//enum RefreshStatus: Int {
//    case Normal = 0
//    case Pulling
//    case Refreshing
//}

enum RefreshStatue: Int {
    case Normal = 0     //默认状态
    case Pulling        //准备刷新状态
    case Refreshing     //正在刷新状态
}

private let refreshControlHeight: CGFloat = 45

class DQRefreshControl: UIControl {

//    var refreshStatus: RefreshStatus = .Pulling {
//        didSet {
//            switch refreshStatus {
//            case .Pulling:
//                print("下拉起飞")
//                print("~~~~~~~~~~~~~~~~~~~~~~")
//            case .ReadayToRefresh:
//                print("准备起飞")
//                print("~~~~~~~~~~~~~~~~~~~~~~")
//            case .ReadayToRefresh:
//                print("正在飞...")
//                print("~~~~~~~~~~~~~~~~~~~~~~")
//            }
//        }
//    }
    
    var refreshStatus: RefreshStatue = .Normal {
        didSet {
            switch refreshStatus {
            case .Normal:
                print("下拉起飞")
                print("~~~~~~~~~~~~~~~~~~~~~~")
            case .Pulling:
                print("准备起飞")
                print("~~~~~~~~~~~~~~~~~~~~~~")
            case .Refreshing:
                print("正在飞...")
                print("~~~~~~~~~~~~~~~~~~~~~~")
            }
        }
    }

    
    
    override init(frame: CGRect){
        let rect = CGRect(x: 0, y: -refreshControlHeight, width: ScreenWidth, height: refreshControlHeight)
        super.init(frame: rect)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let tempSuperView = newSuperview as? UIScrollView {
            //为何要声明变量
            scrollView = tempSuperView
            tempSuperView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offsetY = scrollView?.contentOffset.y ?? 0
        let targetY = -(navBarHeight + refreshControlHeight)
        
        if scrollView!.isDragging {
            //正在拽动
            if  refreshStatus == .Normal && offsetY < targetY {
                refreshStatus = .Pulling
            } else if refreshStatus == .Pulling && offsetY > targetY {
                refreshStatus = .Normal
            }
        } else {
            if refreshStatus == .Pulling {
                refreshStatus = .Refreshing
            }
        }
    }
    
    
    private func setupUI() {
        addSubview(tipLabel)
        addSubview(indicator)
        addSubview(arrowIcon)
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        indicator.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.trailing.equalTo(tipLabel.snp.leading)
        }
        
        arrowIcon.snp.makeConstraints { (make) in
            make.center.equalTo(indicator)
        }
    }
    
    private var scrollView: UIScrollView?
    
    private lazy var arrowIcon: UIImageView = UIImageView(image:#imageLiteral(resourceName: "tableview_pull_refresh"))
    private lazy var tipLabel: UILabel = UILabel(title: "下拉刷新", textColor: UIColor.gray, textFontSize: 14)
    private lazy var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    
    deinit {
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}

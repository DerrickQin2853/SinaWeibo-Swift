//
//  DQRefreshControl.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/29.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

enum RefreshStatue: Int {
    case Normal = 0     //默认状态
    case Pulling        //准备刷新状态
    case Refreshing     //正在刷新状态
}

private let refreshControlHeight: CGFloat = 45

class DQRefreshControl: UIControl {
    
    var refreshStatus: RefreshStatue = .Normal {
        didSet {
            switch refreshStatus {
            case .Normal:
                arrowIcon.isHidden = false
                tipLabel.text = "下拉刷新"
                indicator.stopAnimating()
                
                if oldValue == .Refreshing {
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.scrollView!.contentInset.top = self.scrollView!.contentInset.top - refreshControlHeight
                    })
                }
                UIView.animate(withDuration: 0.25, animations: {
                    self.arrowIcon.transform = CGAffineTransform.identity
                })
                
            case .Pulling:
                arrowIcon.isHidden = false
                tipLabel.text = "松手刷新"
                indicator.stopAnimating()
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.arrowIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI))
                })
            case .Refreshing:
                arrowIcon.isHidden = true
                tipLabel.text = "正在刷新"
                indicator.startAnimating()
                scrollView!.contentInset.top = scrollView!.contentInset.top + refreshControlHeight
                
                self.sendActions(for: .valueChanged)
            }
        }
    }

    func stopAnimating() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) { 
            self.refreshStatus = .Normal
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
        addSubview(backgroundImage)
        addSubview(tipLabel)
        addSubview(indicator)
        addSubview(arrowIcon)
        
        backgroundImage.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
        }
        
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
    private lazy var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    private lazy var backgroundImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "refreshbg"))
    
    deinit {
        self.scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
}

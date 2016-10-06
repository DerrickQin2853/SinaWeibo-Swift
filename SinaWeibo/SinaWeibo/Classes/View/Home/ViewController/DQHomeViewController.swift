//
//  DQHomeViewController.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SVProgressHUD

private let DQStatusesCellID = "DQStatusesCell"
private let DQRetweetedCellID = "DQRetweetedCell"

class DQHomeViewController: DQBaseTableViewController {

    lazy var homeViewModel: DQHomeViewModel = DQHomeViewModel()
    
    let homeRefreshControl = DQRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightButtonItemClick))
        
        
        if !isUserLogin {
            //设置游客界面信息
            visitorLoginView.setPageInfo(tipText: "关注一些人,快回到这里看看有什么惊喜")
            return
        }
        
        setupTableView()
        
        loadData()
        
        
    }
    
    @objc private func rightButtonItemClick() {
        navigationController?.pushViewController(DQTempViewController(), animated: true)
    }
    //为什么用internal??
    internal func loadData() {
        
        homeViewModel.loadData(isPullUp: indicatorView.isAnimating) { (isSuccess, count) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            
            self.homeRefreshControl.stopAnimating()
            
            if !self.indicatorView.isAnimating {
                self.startTipLabelAnimation(count: count)
            }
            
            //indicator停止转动
            self.indicatorView.stopAnimating()
            

            //返回成功 刷新
            self.tableView.reloadData()
            
            
        }
    }
    
    
    private func setupTableView() {
        //注册CELL
        let nib = UINib(nibName: "DQStatusesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DQStatusesCellID)
        let retweetednib = UINib(nibName: "DQRetweetedCell", bundle: nil)
        tableView.register(retweetednib, forCellReuseIdentifier: DQRetweetedCellID)
        //分割线
        tableView.separatorStyle = .none
        //隐藏滑动条
        tableView.showsVerticalScrollIndicator = false
        
        tableView.tableFooterView = indicatorView
        
        homeRefreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        view.addSubview(homeRefreshControl)
        tipLabel.frame.origin.y = navBarHeight - 35
        navigationController?.view.addSubview(tipLabel)
        navigationController?.view.insertSubview(tipLabel, belowSubview: self.navigationController!.navigationBar)
        
    }
    
    private func startTipLabelAnimation(count: Int) {
        
        if self.tipLabel.isHidden == false {
            return
        }
        //设置文字
        self.tipLabel.text = count == 0 ? "没有新微博" : "更新了\(count)条微博"
        self.tipLabel.isHidden = false
        //在动画之前先记录之前的y值
        let lastY = self.tipLabel.frame.origin.y
        UIView.animate(withDuration: 0.6, animations: {
            self.tipLabel.frame.origin.y = navBarHeight
        }) { (_) in
            //添加一个返回原位置的动画 需要延迟
            UIView.animate(withDuration: 0.6, delay: 0.8, options: [], animations: {
                self.tipLabel.frame.origin.y = lastY
                }, completion: { (_) in
                    self.tipLabel.isHidden = true
            })
        }
        
    }

    
    
    
    lazy var indicatorView: UIActivityIndicatorView = {
       
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return indicatorView
    }()
    
    private lazy var tipLabel: UILabel = {
        let l = UILabel(title: "", textColor: UIColor.white, textFontSize: 14)
        //设置背景颜色
        l.backgroundColor = UIColor.orange
        //设置对齐
        l.textAlignment = .center
        l.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 35)
        l.isHidden = true
        return l
    }()

    
    
}

extension DQHomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.statusesViewModelArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let statusViewModel = homeViewModel.statusesViewModelArray[indexPath.row]

        statusViewModel.dealIsFirst(index: indexPath.row)
        
        //判断是否用转发xib微博
        
        let cellID = getCellIdWithViewModel(viewModel: statusViewModel)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DQStatusesCell

        cell.statusViewModel = statusViewModel
        
        return cell
    }
    
    //静默加载
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == homeViewModel.statusesViewModelArray.count - 2 && !indicatorView.isAnimating {
            indicatorView.startAnimating()
            loadData()
        }
    }
    
    
    //设置行高
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusViewModel = homeViewModel.statusesViewModelArray[indexPath.row]
        let cellId = getCellIdWithViewModel(viewModel: statusViewModel)
        let cell = getCellWithCellId(cellId: cellId)
        return cell.getRowHeight(viewModel: statusViewModel)
    }
    
    
    private func getCellIdWithViewModel(viewModel: DQStatusesViewModel) -> String {
        if viewModel.status?.retweeted_status != nil {
            return DQRetweetedCellID
        }
        else{
            return DQStatusesCellID
        }
    }
    
    private func getCellWithCellId(cellId: String) -> DQStatusesCell {
        let nibName = cellId == DQStatusesCellID ? "DQStatusesCell" : "DQRetweetedCell"
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil).last as! DQStatusesCell
        
    }
    
}

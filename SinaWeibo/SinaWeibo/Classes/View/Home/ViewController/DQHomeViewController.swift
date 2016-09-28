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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightButtonItemClick))
        
        //设置游客界面信息
        visitorLoginView.setPageInfo(tipText: "关注一些人,快回到这里看看有什么惊喜")
        
        setupTableView()
        
        loadData()
        
        
    }
    
    @objc private func rightButtonItemClick() {
        navigationController?.pushViewController(DQTempViewController(), animated: true)
    }
    //为什么用internal??
    internal func loadData() {
        
        homeViewModel.loadData(isPullUp: indicatorView.isAnimating) { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: errorTip)
                return
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
        //行高
        tableView.rowHeight = 600
        //分割线
        tableView.separatorStyle = .none
        //隐藏滑动条
        tableView.showsVerticalScrollIndicator = false
        
        tableView.tableFooterView = indicatorView
        
    }
    
    lazy var indicatorView: UIActivityIndicatorView = {
       
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return indicatorView
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

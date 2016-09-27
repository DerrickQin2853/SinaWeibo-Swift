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

class DQHomeViewController: DQBaseTableViewController {

    lazy var homeViewModel: DQHomeViewModel = DQHomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(rightButtonItemClick))
        
        //设置游客界面信息
        visitorLoginView.setPageInfo(tipText: "关注一些人,快回到这里看看有什么惊喜")
        
        setupTableView()
        
        homeViewModel.loadData { (isSuccess) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: errorTip)
                return
            }
            print(self.homeViewModel)
            //返回成功 刷新
            self.tableView.reloadData()
        }
       
    }
    
    @objc private func rightButtonItemClick() {
        navigationController?.pushViewController(DQTempViewController(), animated: true)
    }
    
    private func setupTableView() {
        //注册CELL
        let nib = UINib(nibName: "DQStatusesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: DQStatusesCellID)
        //行高
        tableView.rowHeight = 450
        //分割线
        tableView.separatorStyle = .none
    }
    
}

extension DQHomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.statusesViewModelArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DQStatusesCellID, for: indexPath) as! DQStatusesCell
        
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
}

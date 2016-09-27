//
//  DQOauthViewController.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/25.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SVProgressHUD

class DQOauthViewController: UIViewController {

    lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        //设置代理
        webView.delegate = self
        webView.isOpaque = false
        
        view.backgroundColor = UIColor.white
        
        //设置导航栏按钮
        setupNaviagationBar()
        //加载页面
        loadOauthPage()
        
    }
    
    //设置导航条
    private func setupNaviagationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", imageName: nil, target: self, action: #selector(cancelButtonClick))
        ///测试用，之后删除
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充测试", imageName: nil, target: self, action: #selector(fillTest))
    }
    
    
    //按钮监听事件
    @objc private func cancelButtonClick() {
      dismiss(animated: true, completion: nil)
    }
    ///之后删除  测试用
    @objc private func fillTest() {
      let jsString = "document.getElementById('userId').value = '13761068518', document.getElementById('passwd').value = 'Qsy_589032'"
      webView.stringByEvaluatingJavaScript(from: jsString)
    }
    
    //加载登录界面的webview
    private func loadOauthPage() {
        let urlString = "https://api.weibo.com/oauth2/authorize?" + "client_id=" + client_id + "&redirect_uri=" + redirect_uri
        
        let url = URL(string: urlString)
        let requset = URLRequest(url: url!)
        webView.loadRequest(requset)
        
    }

    //防止旋转条的卡顿
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }

}

extension DQOauthViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    //网页每次加载新的页面实际上都是重写发送了request 在该方法中就可以拦截该请求
    //该协议方法的返回值是bool类型 如果返回true 该空间可以正常使用否则就不能够正常
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.url?.absoluteString ?? ""
        
        //重要判断依据
        let flag = "code="
        //如果包含code说明是授权成功的消息
        if urlString .contains(flag) {
            let qurey = request.url?.query ?? ""
            //Optional("code=da5c36d22bb40d5132b8acb898b15159")
            let code = (qurey as NSString).substring(from: flag.characters.count)
            
            DQUserAccountViewModel.sharedViewModel.loadAccessToken(code: code, finish: { (isSuccess) in
                if !isSuccess {
                    SVProgressHUD.showError(withStatus: "网络出现问题")
                    return
                }
                
                NotificationCenter.default.post(name: Notification.Name(kChangeRootControllerNotification), object: "Welcome")
                
            })
            return false
        }
        return true
    }
}


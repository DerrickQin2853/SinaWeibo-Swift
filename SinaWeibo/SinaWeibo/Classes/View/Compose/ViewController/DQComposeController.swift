//
//  DQComposeController.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQComposeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupNavigationBar()
        setTextView()
    }

    
    @objc internal func backItemClick() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc internal func sendBtnDidClick() {
        
    }
    
    internal lazy var sendBtn: UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 35))
        btn.setTitle("发送", for: .normal)
        //设置背景图片
//        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
//        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
//        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.addTarget(self, action: #selector(sendBtnDidClick), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: btn)
        barButtonItem.isEnabled = false
        return barButtonItem
    }()
    
    internal lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.white
        tv.textColor = UIColor.darkGray
        tv.font = UIFont.systemFont(ofSize: 16)
        //设置代理
        tv.delegate = self
        tv.alwaysBounceVertical = true
        return tv
    }()

    //占位文本
    internal lazy var placeHolderLabel: UILabel = UILabel(title: "分享新鲜事...", textColor: UIColor.lightGray, textFontSize: 16)
    
    
}

extension DQComposeController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.sendBtn.isEnabled = textView.hasText
        self.placeHolderLabel.isHidden = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}


extension DQComposeController {
    internal func setupNavigationBar() {
        let backItem = UIBarButtonItem(title: "关闭", imageName: nil, target: self, action: #selector(backItemClick))
        navigationItem.leftBarButtonItem = backItem
        
        let titleLabel = UILabel(title: "", textColor: UIColor.darkGray, textFontSize: 16)
        var titleText = "发布微博"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        if let userName = DQUserAccountViewModel.sharedViewModel.userInfo?.name{
            titleText = "发布微博\n\(userName)"
            let strM = NSMutableAttributedString(string: titleText)
            let range = (titleText as NSString).range(of: userName)
            strM.addAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName : UIColor.lightGray], range: range)
            titleLabel.attributedText = strM
        }
        else{
            titleLabel.text = titleText
        }
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        self.navigationItem.rightBarButtonItem = sendBtn
    }
    internal func setTextView() {
        self.view.addSubview(textView)
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view).offset(8)
            make.trailing.equalTo(self.view).offset(-8)
            make.height.equalTo(ScreenHeight / 4)
        }
        //添加到textView
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(8)
            make.left.equalTo(textView).offset(5)
        }
    }

}

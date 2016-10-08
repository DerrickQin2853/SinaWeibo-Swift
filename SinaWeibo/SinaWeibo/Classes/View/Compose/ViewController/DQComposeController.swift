//
//  DQComposeController.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SVProgressHUD

class DQComposeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        registerNotification()
        setupNavigationBar()
        setTextView()
        setupPictureSelectView()
        setToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectPictureController.images.count != 0 {
            selectPictureController.view.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectPictureController.images.count == 0 {
        textView.becomeFirstResponder()
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notificate:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    @objc private func keyboardWillChange(notificate: Notification) {
        let keyboardEndFrame = (notificate.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let newOffsetY = -ScreenHeight + keyboardEndFrame.origin.y
        
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(newOffsetY)
        }
        
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @objc internal func backItemClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc internal func sendBtnDidClick() {
        if selectPictureController.images.count == 0 {
            composeViewModel.postStatus(statusText: textView.text ?? "") { (success) in
                if !success {
                    SVProgressHUD.showError(withStatus: "发布失败，请检查网络设置")
                    SVProgressHUD.dismiss(withDelay: 0.5)
                }
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.dismiss(withDelay: 0.5)
                })
                
            }

        }
        else{
            composeViewModel.postStatusWithOnePicture(statusText: textView.text ?? "", image: selectPictureController.images.last!, finish: { (success) in
                if !success {
                    SVProgressHUD.showError(withStatus: "发布失败，请检查网络设置")
                    SVProgressHUD.dismiss(withDelay: 0.5)
                }
                SVProgressHUD.showSuccess(withStatus: "发布成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.dismiss(animated: true, completion: nil)
                    SVProgressHUD.dismiss(withDelay: 0.5)
                })
            })
        }
        
    }
    
    @objc internal func toolBarButtonClick(btn: UIButton) {
        switch btn.tag {
        case 0:
//            print("发布图片")
            selectPictureController.addPicture()
        case 1:
            print("@某人")
        case 2:
            print("发布话题")
        case 3:
//            print("发送表情")
            if !textView.isFirstResponder {
                textView.becomeFirstResponder()
            }
            
            textView.inputView = (textView.inputView == nil ? emoticonKeyboardView : nil)
            
            textView.reloadInputViews()
        case 4:
            print("更多")
        default:
            print("瞎点")
        }
    }
    
    private lazy var composeViewModel: DQComposeViewModel = DQComposeViewModel()
    
    lazy var emoticonKeyboardView: DQEmoticonKeyboardView = {
       let keyboardView = DQEmoticonKeyboardView(frame: CGRect(x: 0, y: 0, width: 0, height: emoticonKeyboardHeight))
       return keyboardView
    }()
    
    internal lazy var selectPictureController: DQPictureSelectViewController = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = selectCellMargin
        layout.minimumInteritemSpacing = selectCellMargin
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.sectionInset = UIEdgeInsets(top: selectCellMargin, left: selectCellMargin, bottom: 0, right: selectCellMargin)
        let vc = DQPictureSelectViewController(collectionViewLayout: layout)
        vc.collectionView?.backgroundColor = UIColor.white
        return vc
    }()
    
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
    //底部工具条
    internal lazy var toolBar: UIToolbar = {
       let tempToolBar = UIToolbar()
       var items = [UIBarButtonItem]()
        let imageNames = ["compose_toolbar_picture",
                         "compose_mentionbutton_background",
                         "compose_trendbutton_background",
                         "compose_emoticonbutton_background",
                         "compose_add_background"]
        for value in imageNames.enumerated() {
            let btn = UIButton()
            btn.setImage(UIImage(named: value.element), for: .normal)
            btn.setImage(UIImage(named: value.element + "_highlighted"), for: .highlighted)
            btn.tag = value.offset
            btn.addTarget(self, action: #selector(toolBarButtonClick(btn:)), for: .touchUpInside)
            btn.sizeToFit()
            let barItem = UIBarButtonItem(customView: btn)
            items.append(barItem)
            let spaceFlex = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            items.append(spaceFlex)
        }
        items.removeLast()
        tempToolBar.setItems(items, animated: false)
        return tempToolBar
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
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
    
    internal func setupPictureSelectView() {
        self.addChildViewController(selectPictureController)
        self.view.addSubview(selectPictureController.view)
        
        selectPictureController.view.snp.makeConstraints { (make) in
            make.bottom.trailing.leading.equalTo(self.view)
            make.height.equalTo(ScreenHeight / 4 * 3)
        }
        
        selectPictureController.view.isHidden = true
    }
    
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
    
    internal func setToolbar() {
        self.view.addSubview(toolBar)
        
        toolBar.snp.makeConstraints { (make) in
            make.leading.right.bottom.equalTo(self.view)
            make.height.equalTo(36)
        }
    }

}

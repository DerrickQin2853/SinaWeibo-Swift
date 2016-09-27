//
//  DQWelcomeViewController.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/26.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SDWebImage

private let bottomMargin: CGFloat = 170
private let iconImagePix: CGFloat = 85

class DQWelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //执行动画
        startAnimation()
    }

    ///执行动画方法
    private func startAnimation() {
        let offsetY = -(UIScreen.main.bounds.size.height - bottomMargin - iconImagePix)
        
        iconView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(offsetY)
        }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 4, options: [], animations: {
            self.view.layoutIfNeeded()
            }) { (true) in
                UIView.animate(withDuration: 2, animations: {
                    self.welcomeLabel.alpha = 1
                    }, completion: { (true) in
                        NotificationCenter.default.post(name: Notification.Name(kChangeRootControllerNotification), object: "TabBar")
                })
        }
    }
    
    
    
    
    private func setupSubviews() {
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-bottomMargin)
            make.size.equalTo(CGSize(width: iconImagePix, height: iconImagePix))
        }
        
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(20)
        }
        
        iconView.sd_setImage(with: DQUserAccountViewModel.sharedViewModel.userIconURL)
    }
    
    ///懒加载控件
    private lazy var iconView: UIImageView = {
       let iconImageView = UIImageView(image: #imageLiteral(resourceName: "avatar_default_big"))
        //不是继承自 UIControl的不用masktobounds
        iconImageView.cornerRadius = iconImagePix / 2
        iconImageView.layer.borderWidth = 3
        iconImageView.layer.borderColor = UIColor.orange.cgColor
        
        return iconImageView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel(title: "欢迎回来", textColor: UIColor.darkGray, textFontSize: 15)
        label.alpha = 0
        return label
    }()

}

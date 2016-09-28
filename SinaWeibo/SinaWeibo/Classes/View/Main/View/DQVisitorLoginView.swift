//
//  DQVisitorLoginView.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/23.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol DQVisitorLoginViewDelegate: NSObjectProtocol {
    @objc optional func userLogin()
    @objc optional func userRegister()
}

class DQVisitorLoginView: UIView {

    //代理
    weak var delegate: DQVisitorLoginViewDelegate?
    
    //对外设置信息方法
    func setPageInfo(tipText: String, imageName: String? = nil) {
        tipLabel.text = tipText
        if imageName == nil {
            //为空代表是首页 不改图片 做动画
            startAnimation()
        }
        else{
            //非首页，不做动画， 该图片
            circleView.image = UIImage(named: imageName!)
            iconImageView.isHidden = true
            bringSubview(toFront: circleView)
        }
    }
    
    private func startAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = M_PI * 2
        animation.duration = 12
        animation.repeatCount = MAXFLOAT
        
        //重要属性 当动画结束的时候或者当页面处于非活跃状态移除动画效果 默认值是true
        animation.isRemovedOnCompletion = false
        
        circleView.layer.add(animation, forKey: "circleRotate")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //加载子视图
    private func setupSubviews () {
        addSubview(circleView)
        addSubview(blockMaskView)
        addSubview(iconImageView)
        addSubview(tipLabel)
        addSubview(loginButton)
        addSubview(registerButton)
        
        //设置自动布局
        circleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-80)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        
        blockMaskView.snp.makeConstraints { (make) in
            make.center.equalTo(circleView)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(circleView)
            make.top.equalTo(circleView.snp.bottom).offset(20)
            
            make.leading.equalTo(self).offset(65)
            make.trailing.equalTo(self).offset(-65)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            make.leading.equalTo(tipLabel)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            make.trailing.equalTo(tipLabel)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        let colorValue = CGFloat(237/255.0)
        
        backgroundColor = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1)
        
        //添加点击事件
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        
        registerButton.addTarget(self, action: #selector(registerButtonClick), for: .touchUpInside)
    }
    
    @objc private func loginButtonClick() {
        delegate?.userLogin?()
    }
    
    @objc private func registerButtonClick() {
        delegate?.userRegister?()
    }
    
    
    //懒加载子视图
    
    //环
    private lazy var circleView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"))
    //icon
    private lazy var iconImageView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_house"))
    //遮罩
    private lazy var blockMaskView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_mask_smallicon"))
    //提示文字
    private lazy var tipLabel: UILabel = {
       let tempLabel = UILabel(title: "默认提示文字", textColor: UIColor.darkGray, textFontSize: 14)
        tempLabel.numberOfLines = 0
        //与自动换行有关，建议设置
        tempLabel.preferredMaxLayoutWidth = 224
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    //注册按钮
    private lazy var registerButton: UIButton = {
        let tempButton = UIButton(title: "注册", textColor: UIColor.orange, textFontSize: 14)
        tempButton.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        return tempButton
    }()
    //登录按钮
    private lazy var loginButton: UIButton = {
        let tempButton = UIButton(title: "登录", textColor: UIColor.darkGray, textFontSize: 14)
        tempButton.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .normal)
        return tempButton
    }()
}

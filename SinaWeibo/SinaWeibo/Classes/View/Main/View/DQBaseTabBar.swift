//
//  DQBaseTabBar.swift
//  SinaWeibo
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQBaseTabBar: UITabBar {

    //闭包属性
    var composeButtonClosure: (() -> ())?
    
    //懒加载button
    private lazy var composeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        button.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button_highlighted"), for: .highlighted)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(composeButtonClick), for: .touchUpInside)
    }
    
    @objc private func composeButtonClick() {
        //调用闭包
        composeButtonClosure?()
    }
    
    
    //解档 当视图从 xib 或者 sb中加载的时候会执行这个方法
    //从xib中加载该控件程序会崩溃
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //宽高
        let buttonWidth = bounds.size.width / 5
        let buttonHeight = bounds.size.height
        //索引
        var index = 0
        
        for subview in subviews {
            if subview .isKind(of: NSClassFromString("UITabBarButton")!) {
                subview.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
                
                index += (index == 1) ? 2 : 1
            }
        }
        
        composeButton.bounds.size = CGSize(width: buttonWidth, height: buttonHeight)
        composeButton.center = CGPoint(x: center.x, y: bounds.size.height / 2)
    }

}

//
//  DQComposeView.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/7.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit
import pop



class DQComposeView: UIView {

    var targetVC: UIViewController?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(targetVC: UIViewController?) {
        self.targetVC = targetVC
        targetVC?.view.addSubview(self)
    }

    private func setupUI() {
        let backgroundView = UIImageView(image: UIImage.snapShotCurrentScreen().applyLightEffect())
        self.addSubview(backgroundView)
        
        let slogan = UIImageView(image: #imageLiteral(resourceName: "compose_slogan"))
        self.addSubview(slogan)
        
        slogan.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
        }

        setupButtons()
    }
    
    private func setupButtons() {
        let margin = (ScreenWidth - 3 * composeBtnW) / 4
        
        for i in 0..<6 {
            let btn = DQComposeButton()
            let tempImage = UIImage(named: dataArray[i]["pic"] as! String!)
            btn.setTitle(dataArray[i]["name"] as! String!, for: .normal)
            btn.setImage(tempImage, for: .normal)
            let colIndex = i % 3
            let rowIndex = i / 3
            let btnX = margin + (margin + composeBtnW) * CGFloat(colIndex)
            let btnY = (margin + composeBtnH) * CGFloat(rowIndex) + ScreenHeight
            btn.frame = CGRect(x: btnX, y: btnY, width: composeBtnW, height: composeBtnH)
            //添加点击事件
            btn.addTarget(self, action: #selector(composeTypeBtnDidClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
            buttonArray.append(btn)
        }
    }
    
    private func startAnimation(btn: DQComposeButton, index: Int, isUp: Bool) {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        animation?.springBounciness = 10
        animation?.springSpeed = 12
        animation?.beginTime = CACurrentMediaTime() + Double(index) * 0.025
        animation?.toValue = NSValue.init(cgPoint: CGPoint(x: btn.center.x, y: btn.center.y + (isUp == true ? -350 : 350)))
        btn.pop_add(animation, forKey: nil)
    }
    
    
    @objc private func composeTypeBtnDidClick(btn: DQComposeButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for value in buttonArray.reversed().enumerated() {
            startAnimation(btn: value.element, index: value.offset, isUp: false)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7) {
            self.removeFromSuperview()
        }
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        for value in buttonArray.enumerated() {
            startAnimation(btn: value.element, index: value.offset, isUp: true)
        }
    }
    
    
    lazy var buttonArray = [DQComposeButton]()
    
    private lazy var dataArray: [[String : Any]] = {
        let tempArray = NSArray(contentsOfFile: Bundle.main.path(forResource: "ComposeViewButtons", ofType: "plist")!)
        return tempArray as! [[String : Any]]
    }()
}

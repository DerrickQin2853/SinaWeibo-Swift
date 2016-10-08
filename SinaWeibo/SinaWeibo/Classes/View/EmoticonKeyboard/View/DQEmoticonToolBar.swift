//
//  DQEmoticonToolBar.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

enum EmoticonType: Int {
    case RECENT = 0
    case DEFAULT
    case EMOJI
    case LXH
}


class DQEmoticonToolBar: UIStackView {

    override init(frame: CGRect) {
     super.init(frame: frame)
        setupUI()
        axis = .horizontal
        distribution = .fillEqually
        tag = 999
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addButton(title: "最近", backgroundImageName: "compose_emotion_table_left", type: .RECENT)
        addButton(title: "默认", backgroundImageName: "compose_emotion_table_mid", type: .DEFAULT)
        addButton(title: "Emoji", backgroundImageName: "compose_emotion_table_mid", type: .EMOJI)
        addButton(title: "浪小花", backgroundImageName: "compose_emotion_table_right", type: .LXH)
    }
    
    
    private func addButton(title: String, backgroundImageName: String, type: EmoticonType) {
        let button = UIButton()
        
        button.tag = type.rawValue
        button.setBackgroundImage(UIImage(named: backgroundImageName + "_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: backgroundImageName + "_selected"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonClick(btn:)), for: .touchUpInside)
        self.addArrangedSubview(button)
        
        if type == .RECENT {
            button.isSelected = true
            lastSelectedButton = button
        }
    }
    
    
    func setButtonSelected(indexPath: IndexPath) {
        let btn = self.viewWithTag(indexPath.section) as! UIButton
        
        if btn.isSelected {
            return
        }
        lastSelectedButton?.isSelected = false
        lastSelectedButton = btn
        btn.isSelected = true
    }
    
    @objc private func buttonClick(btn: UIButton) {
        if btn.isSelected {
            return
        }
        lastSelectedButton?.isSelected = false
        lastSelectedButton = btn
        btn.isSelected = true
        emoticonTypeSelectClosure?(EmoticonType.init(rawValue: btn.tag)!)
    }
    
    
    var lastSelectedButton: UIButton?
    
    var emoticonTypeSelectClosure: ((EmoticonType) -> ())?
}

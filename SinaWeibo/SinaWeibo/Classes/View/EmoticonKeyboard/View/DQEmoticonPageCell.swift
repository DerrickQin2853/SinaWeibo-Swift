//
//  DQEmoticonPageCell.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

let emoticonPageControlHeight: CGFloat = 30

class DQEmoticonPageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addChildButton()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        contentView.addGestureRecognizer(longPress)
    }
    
    @objc private func longPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: contentView)
        
        guard let btn = findEmoticonButton(point: point) else {
            popView.removeFromSuperview()
            return
        }
        
        if btn.isHidden == true {
            popView.removeFromSuperview()
            return
        }
        
        switch gesture.state {
        case .began,.changed:
            let keyboardWindow = UIApplication.shared.windows.last!
            
            let rect = btn.superview!.convert(btn.frame, to: window)
            //let rect =  btn.convert(btn.bounds, to: window)
            popView.center.x = rect.midX
            popView.frame.origin.y = rect.maxY - popView.bounds.height
            //给表情按钮设置模型
            popView.emoticonButton.emoticon = btn.emoticon
            keyboardWindow.addSubview(popView)
            popView.showEmoticon()
//            btn.isHidden = true
        default:
            popView.removeFromSuperview()
//            btn.isHidden = false

        }
    }
    
    private func findEmoticonButton(point: CGPoint) -> DQEmoticonButton? {
        for btn in buttonArray {
            if btn.frame.contains(point) {
                return btn
            }
        }
        return nil
    }
    
    private func addChildButton() {
        
        let buttonWidth = ScreenWidth / 7
        let buttonHeight = (emoticonKeyboardHeight - emoticonToolBarHeight - emoticonPageControlHeight) / 3
        
        for i in 0..<emoticonPageMaxCount {
            let button = DQEmoticonButton()
            
            let colIndex = i % 7
            let rawIndex = i / 7
            
            let buttonX = CGFloat(colIndex) * buttonWidth
            let buttonY = CGFloat(rawIndex) * buttonHeight
            
            button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
            
//            button.backgroundColor = randomColor()
            button.adjustsImageWhenHighlighted = false
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            contentView.addSubview(button)
            buttonArray.append(button)
            button.addTarget(self, action: #selector(emoticonButtonClick(btn:)), for: .touchUpInside)
        }
        
        //删除按钮
        let deleteButton = UIButton()
        deleteButton.frame = CGRect(x: ScreenWidth - buttonWidth, y: buttonHeight * 2, width: buttonWidth, height: buttonHeight)
        deleteButton.setImage(#imageLiteral(resourceName: "compose_emotion_delete"), for: .normal)
        deleteButton.adjustsImageWhenHighlighted = false
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        contentView.addSubview(deleteButton)
    }
    
    @objc private func emoticonButtonClick(btn: DQEmoticonButton) {
        DQEmoticonTools.sharedTools.saveRecentEmoticons(emoticon: btn.emoticon!)
        NotificationCenter.default.post(name: NSNotification.Name(KSelectEmoticon), object: btn.emoticon)
    }
    
    @objc private func deleteButtonClick() {
        NotificationCenter.default.post(name: NSNotification.Name(KSelectEmoticon), object: nil)
    }
    
    
    lazy var buttonArray: [DQEmoticonButton] = [DQEmoticonButton]()
    
    lazy var popView: DQEmoticonPopView = {
      return DQEmoticonPopView.loadPopoView()
    }()
    
    var emoticons: [DQEmoticon]? {
        didSet{
            for button in buttonArray {
                button.isHidden = true
            }
            for value in emoticons!.enumerated() {
                let btn = buttonArray[value.offset]
                btn.isHidden = false
                btn.emoticon = value.element
            }
        }
    }
    
}

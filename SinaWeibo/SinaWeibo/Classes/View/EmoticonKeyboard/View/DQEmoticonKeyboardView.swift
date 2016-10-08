//
//  DQEmoticonKeyboardView.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

let emoticonKeyboardHeight: CGFloat = 220
let emoticonToolBarHeight: CGFloat = 37

private let emoticonPageCellId = "EmoticonPageCell"


class DQEmoticonKeyboardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(toolBar)
        
        toolBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(emoticonToolBarHeight)
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        //闭包实现
        toolBar.emoticonTypeSelectClosure = { type in
            let indexPath = IndexPath(item: 0, section: type.rawValue)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: ScreenWidth, height: emoticonKeyboardHeight - emoticonToolBarHeight)
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //注册CELL
        cv.register(DQEmoticonPageCell.self, forCellWithReuseIdentifier: emoticonPageCellId)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.bounces = false
        return cv
    }()
    
    lazy var toolBar: DQEmoticonToolBar = DQEmoticonToolBar()
    
    private lazy var pageControl : UIPageControl = {
        let page = UIPageControl()
        
        return page
    }()
    
    private lazy var recentTipLabel: UILabel = UILabel(title: "最近使用的表情", textColor: UIColor.darkGray, textFontSize: 10)
    
}



extension DQEmoticonKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonPageCellId, for: indexPath) as! DQEmoticonPageCell
        
        cell.indexPath = indexPath
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x + 0.5 * ScreenWidth
        let point = CGPoint(x: contentOffsetX, y: 10)
        let indexPath = collectionView.indexPathForItem(at: point)
        toolBar.setButtonSelected(indexPath: indexPath!)
    }
}



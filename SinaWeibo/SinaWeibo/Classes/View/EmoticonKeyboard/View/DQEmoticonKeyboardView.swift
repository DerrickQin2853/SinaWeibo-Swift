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
        addSubview(pageControl)
        addSubview(recentTipLabel)
        
        toolBar.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(emoticonToolBarHeight)
        }
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self.toolBar.snp.top)
        }
        
        recentTipLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.pageControl)
        }
        
        
        //闭包实现
        toolBar.emoticonTypeSelectClosure = { type in
            let indexPath = IndexPath(item: 0, section: type.rawValue)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
//            self.updatePageControl(indexPath: indexPath)
        }
        
        registerNotification()
        
        DispatchQueue.main.async {
            self.updatePageControl(indexPath: IndexPath(item: 0, section: 0))
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(KsaveRecentEmoticon), object: nil)
    }
    
    
    func updatePageControl(indexPath: IndexPath) {
        let emoticon = DQEmoticonTools.sharedTools.allEmoticon[indexPath.section]
        
        pageControl.numberOfPages = emoticon.count
        pageControl.currentPage = indexPath.item
        pageControl.isHidden = (indexPath.section == 0)
        recentTipLabel.isHidden = (indexPath.section != 0)
    }
    
    
    @objc private func reloadData() {
        //如果当前显示的就是第0组 就不执行刷新
        let index = collectionView.indexPathsForVisibleItems.last!
        if index.section != 0 {
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
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
        cv.backgroundColor = UIColor.white
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var toolBar: DQEmoticonToolBar = DQEmoticonToolBar()
    
    private lazy var pageControl : UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = 5
        page.currentPage = 1
        page.setValue(#imageLiteral(resourceName: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        page.setValue(#imageLiteral(resourceName: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        return page
    }()
    
    private lazy var recentTipLabel: UILabel = UILabel(title: "最近使用的表情", textColor: UIColor.darkGray, textFontSize: 10)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}


//数据源方法
extension DQEmoticonKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionEmoticons = DQEmoticonTools.sharedTools.allEmoticon
        return sectionEmoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionEmoticons = DQEmoticonTools.sharedTools.allEmoticon
        let emoticons = sectionEmoticons[section]
        return emoticons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonPageCellId, for: indexPath) as! DQEmoticonPageCell
        
        cell.emoticons = DQEmoticonTools.sharedTools.allEmoticon[indexPath.section][indexPath.item]
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x + 0.5 * ScreenWidth
        let point = CGPoint(x: contentOffsetX, y: 10)
        let indexPath = collectionView.indexPathForItem(at: point)
        toolBar.setButtonSelected(indexPath: indexPath!)
        updatePageControl(indexPath: indexPath!)
    }
}



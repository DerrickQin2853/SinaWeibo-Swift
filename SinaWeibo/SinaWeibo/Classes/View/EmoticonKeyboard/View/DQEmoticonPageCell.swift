//
//  DQEmoticonPageCell.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

class DQEmoticonPageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        contentView.addSubview(testLabel)
        testLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
    }
    
    
    var indexPath: IndexPath? {
        didSet{
            testLabel.text = "第\(indexPath!.section)组，" + "第\(indexPath!.item)个"
        }
    }
    
    
    lazy var testLabel: UILabel = UILabel(title: "", textColor: UIColor.brown, textFontSize: 23)
}

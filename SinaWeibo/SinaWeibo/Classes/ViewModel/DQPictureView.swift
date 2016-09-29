//
//  DQPictureView.swift
//  SinaWeibo
//
//  Created by admin on 2016/9/28.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

private let DQPictureCellID = "DQPictureCell"

class DQPictureView: UICollectionView {

    var pictureInfos: [DQStatusPictureInfo]? {
        didSet{
            reloadData()
        }
    }
    
    override func awakeFromNib() {
        
        dataSource = self
        register(DQPictureCell.self, forCellWithReuseIdentifier: DQPictureCellID)
    }
}

extension DQPictureView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureInfos?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DQPictureCellID, for: indexPath) as! DQPictureCell
        
        cell.pictureInfo = pictureInfos![indexPath.item]
        
        return cell
    }
    
}

class DQPictureCell: UICollectionViewCell {
    
    var pictureInfo: DQStatusPictureInfo? {
        didSet{
            let url = URL(string: pictureInfo?.thumbnail_pic ?? "")
            cellImageView.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(cellImageView)
        
        cellImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.edges)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var cellImageView: UIImageView = {
       let tempImageView = UIImageView()
        tempImageView.contentMode = .scaleAspectFill
        tempImageView.clipsToBounds = true
        return tempImageView
    }()
    
}

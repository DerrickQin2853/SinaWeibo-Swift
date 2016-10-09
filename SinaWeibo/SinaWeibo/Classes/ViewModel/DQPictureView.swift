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
            let url = URL(string: pictureInfo?.wap360_pic ?? "")
            
            if url!.absoluteString.hasSuffix(".gif") {
                gificon.isHidden = false
                let urlTemp = URL(string: pictureInfo?.bmiddle_pic ?? "")
                cellImageView.sd_setImage(with: urlTemp)
            }
            else{
                gificon.isHidden = true
                let urlTemp = URL(string: pictureInfo?.wap360_pic ?? "")
                cellImageView.sd_setImage(with: urlTemp)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(cellImageView)
        
        cellImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView.snp.edges)
        
        self.contentView.addSubview(gificon)
        gificon.snp.makeConstraints({ (make) in
            make.trailing.bottom.equalTo(self.contentView)
        })
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
    
    private lazy var gificon: UIImageView = UIImageView(image: #imageLiteral(resourceName: "timeline_image_gif"))
}

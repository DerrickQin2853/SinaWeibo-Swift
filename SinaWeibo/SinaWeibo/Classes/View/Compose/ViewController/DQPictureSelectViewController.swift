//
//  DQPictureSelectViewController.swift
//  SinaWeibo
//
//  Created by admin on 2016/10/8.
//  Copyright © 2016年 Derrick_Qin. All rights reserved.
//

import UIKit

let selectCellMargin: CGFloat = 4
let colCount = 3
let itemWH = (ScreenWidth - (CGFloat(colCount) + 1) * selectCellMargin) / CGFloat(colCount)
private let maxPictureCount = 9

private let reuseIdentifier = "PictureSelectCell"

class DQPictureSelectViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(DQPictureSelectCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

   

    //图片数组
    lazy var images: [UIImage] = [UIImage]()
}
//数据源方法
extension DQPictureSelectViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imagesCount = images.count
        
        return imagesCount + (imagesCount == maxPictureCount ? 0 : 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DQPictureSelectCell
        cell.delegate = self
        
        if indexPath.item == images.count {
            cell.contentImage = nil
        }
        else{
            cell.contentImage = images[indexPath.item]
        }
        
        return cell
    }

}

extension DQPictureSelectViewController: DQpictureSelectCellDelegate {
    func addPicture() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func removePicture(cell: DQPictureSelectCell) {
        let indexPath = collectionView?.indexPath(for: cell)
        images.remove(at: indexPath!.item)
        view.isHidden = (self.images.count == 0)
        self.collectionView?.reloadData()
    }
}


extension DQPictureSelectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //实现协议方法 没有实现协议方法之前 控制器可以自动dismiss
    //一旦实现了协议方法之后 控制器的dismiss 就交给了程序员
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        images.append(image.scaleImage(width: 600))
        self.collectionView?.reloadData()
        dismiss(animated: true, completion: nil)
    }
}


//定义cell的协议
@objc protocol DQpictureSelectCellDelegate: NSObjectProtocol {
    @objc optional func addPicture()
    
    @objc optional func removePicture(cell: DQPictureSelectCell)
}


//自定义cell
class DQPictureSelectCell: UICollectionViewCell {
    
    //重写init方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        self.contentView.addSubview(addButton)
        self.contentView.addSubview(removeButton)
        
        addButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        removeButton.snp.makeConstraints { (make) in
            make.trailing.top.equalTo(self.contentView)
        }
    }
    
    
    
    
    @objc private func addButtonClick() {
        if contentImage != nil {
            return
        }
        delegate?.addPicture?()
    }
    
    @objc private func removeButtonClick() {
        delegate?.removePicture?(cell: self)
    }
    
    
    var contentImage: UIImage? {
        didSet{
            addButton.setImage(contentImage, for: .normal)
            removeButton.isHidden = (contentImage == nil)
            let updateBackImage: UIImage? = (contentImage == nil ? #imageLiteral(resourceName: "compose_pic_add") : nil)
            addButton.setBackgroundImage(updateBackImage, for: .normal)
        }
    }
    //代理对象属性
    weak var delegate: DQpictureSelectCellDelegate?
    
    //懒加载控件
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_pic_add"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(#imageLiteral(resourceName: "compose_photo_close"), for: .normal)
        btn.addTarget(self, action: #selector(removeButtonClick), for: .touchUpInside)
        return btn
    }()
}





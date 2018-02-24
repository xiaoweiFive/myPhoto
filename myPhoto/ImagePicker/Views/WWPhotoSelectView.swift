//
//  WWPhotoSelectView.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPhotoSelectView
// @abstract 相册中选择的照片的view
// @discussion 相册中选择的照片的view
//

import UIKit
import Photos

internal class WWPhotoSelectView: UIView,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource {
    
    private var pickerManager: WWPickerManager?
//    @IBOutlet weak var imageSelectImage: UIImageView!
//    @IBOutlet weak var imageSelectNum: UILabel!
//    @IBOutlet weak var selectCollectionView: UICollectionView!
    
    var imageSelectImage:UIImageView
    var imageSelectNum:UILabel
    var selectCollectionView:UICollectionView
    
    var pushBlock: ((_: UIViewController) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
     func setSelectViewInfo() {
        if let color = WWImagePickerOptions.selectViewBackColor {
            backgroundColor = color
        }else {
            backgroundColor = WWImagePickerOptions.tintColor
        }
        selectCollectionView.register(WWSelecteCVCell.self, forCellWithReuseIdentifier: WWSelecteCVCell.identfier)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadSelectTotalNum), name: WWImagePickerNotify.reloadSelectTotalNum, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteSelectTotalNum(_ :)), name: WWImagePickerNotify.deleteSelectCell, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(insertSelectTotalNum(_ :)), name: WWImagePickerNotify.insertSelectCell, object: nil)
        
        let size = CGSize.init(width: 26, height: 26)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if let color = WWImagePickerOptions.pickerSelectColor {
            color.setFill()
        }else {
            WWImagePickerOptions.tintColor.setFill()
        }
        context?.addArc(center: CGPoint.init(x: size.width / 2, y: size.height / 2), radius: size.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context?.fillPath()
        let selectImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageSelectImage.image = selectImage
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        imageSelectImage.snp.makeConstraints({ (make) in
//            make.width.height.equalTo(27)
//            make.right.equalTo(-17)
//            make.centerX.equalTo(self.snp.centerX)
//        })
//
//        imageSelectNum.snp.makeConstraints({ (make) in
//            make.center.equalTo(imageSelectImage.snp.center)
//            make.left.equalTo(imageSelectImage.snp.left)
//            make.right.equalTo(imageSelectImage.snp.right)
//        })
//
//        selectCollectionView.snp.makeConstraints({ (make) in
//            make.left.top.bottom.equalTo(0)
//            make.right.equalTo(imageSelectImage.snp.left).offset(-10)
//        })
//
//    }
    
    required init() {
        imageSelectImage = UIImageView()
        imageSelectNum = UILabel()
        imageSelectNum.textAlignment = .center
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        selectCollectionView =  UICollectionView.init(frame: .zero, collectionViewLayout: layout)
     
        super.init(frame: .zero)
        self.addSubview(imageSelectImage)
        self.addSubview(imageSelectNum)
        selectCollectionView.delegate = self
        selectCollectionView.dataSource = self
        self.addSubview(selectCollectionView)
        
        imageSelectImage.snp.makeConstraints({ (make) in
            make.width.height.equalTo(27)
            make.right.equalTo(-17)
            make.centerY.equalTo(self.snp.centerY)
        })
        
        imageSelectNum.snp.makeConstraints({ (make) in
            make.center.equalTo(imageSelectImage.snp.center)
            make.left.equalTo(imageSelectImage.snp.left)
            make.right.equalTo(imageSelectImage.snp.right)
        })
        
        selectCollectionView.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(imageSelectImage.snp.left).offset(-10)
        })
        
        setSelectViewInfo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Initial Methods
    class func `init`(frame: CGRect, pickerManager: WWPickerManager) -> WWPhotoSelectView {
        let view = WWPhotoSelectView()
        view.frame         = frame
        view.pickerManager = pickerManager
        return view
    }
    
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let count = pickerManager?.selectPhotoArr.count {
            if count != indexPath.row {
                let browserVC = WWPhotoBrowserController.init(pickerManager!, currentIndex: indexPath.row, selectAssetArr: pickerManager!.selectPhotoArr)
                pushBlock?(browserVC)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 36, height: 36)
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pickerManager!.selectPhotoArr.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WWSelecteCVCell.identfier, for: indexPath) as! WWSelecteCVCell
        if let pickerManager = pickerManager {
            if indexPath.row == pickerManager.selectPhotoArr.count {
                cell.selectImageView.image = WWImagePickerOptions.selectPlaceholder
            }else {
                weak var weakCell = cell
                let assetArr: [PHAsset] = pickerManager.selectPhotoArr
                pickerManager.getPhoto(CGSize(width: 36, height: 36), alasset: assetArr[indexPath.row], resultHandler: { (image, infoDic) in
                    weakCell?.selectImageView.image = image
                })
            }
        }else {
            cell.selectImageView.image = WWImagePickerOptions.selectPlaceholder
        }
        return cell
    }
    
    //MARK: Notification Methods
    @objc private func reloadSelectTotalNum() {
        if let pickerManager = pickerManager {
            imageSelectNum.text = String.init(format: "%d", pickerManager.selectPhotoArr.count)
        }
    }
    
    @objc private func deleteSelectTotalNum(_ not: Notification) {
        if let index = not.object as? IndexPath {
            selectCollectionView.performBatchUpdates({ [weak self] in
                self?.selectCollectionView.deleteItems(at: [index])
            }, completion: nil)
        }
    }

    @objc private func insertSelectTotalNum(_ not: Notification) {
        if let index = not.object as? IndexPath {
            selectCollectionView.performBatchUpdates({ [weak self] in
                self?.selectCollectionView.insertItems(at: [index])
                }, completion: nil)
        }
    }
}



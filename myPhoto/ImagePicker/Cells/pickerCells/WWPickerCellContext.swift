//
//  WWPickerCellContext.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPickerCellContext
// @abstract 图片选择器cell的Context
// @discussion 图片选择器cell的Context
//

import UIKit
import Photos

class WWPickerCellContext: NSObject {
    
    private var pickerManager: WWPickerManager
    
    //MARK: Initial Methods
    init(pickerManager: WWPickerManager) {
        self.pickerManager = pickerManager
        super.init()
    }
    
    //MARK: Public Methods
    func register(collectionView: UICollectionView) {

        collectionView.register(WWCameraCVCell.self, forCellWithReuseIdentifier: WWCameraCVCell.identfier)
        collectionView.register(WWPickerCVCell.self, forCellWithReuseIdentifier: WWPickerCVCell.identfier)
    }
    
    func getPikcerCellNumber(ablumIndex: Int) -> Int {
        var count = pickerManager.getAblumCount(ablumIndex)
        if WWImagePickerOptions.needPickerCamera {
            count = count + 1
        }
        return count
    }
    
    func getPickerCell(_ collectionView: UICollectionView, ablumIndex: Int, photoIndex: Int) -> UICollectionViewCell {
        if WWImagePickerOptions.needPickerCamera && photoIndex == 0 {
            return getCameraCell(collectionView, ablumIndex: ablumIndex, cellForItemAtIndexPath: IndexPath(item: photoIndex, section: 0))
        }else {
            return getPhotoCell(collectionView, ablumIndex: ablumIndex, cellForItemAtIndexPath: IndexPath(item: photoIndex, section: 0))
        }
    }
    
    //MARK: Private Methods
    /**
     返回WWCameraCVCell，拍照的cell
     */
    private func getCameraCell(_ collectionView: UICollectionView, ablumIndex: Int, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WWCameraCVCell.identfier, for: indexPath)
        return cell
    }
    
    /**
     返回WWPickerCVCell，照片的cell
     */
    private func getPhotoCell(_ collectionView: UICollectionView, ablumIndex: Int, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WWPickerCVCell.identfier, for: indexPath) as! WWPickerCVCell
        //加载图片
        var photoIndexPath = indexPath.row
        if WWImagePickerOptions.needPickerCamera == true {
            photoIndexPath = photoIndexPath - 1
        }
        weak var weakCell = cell
        if let photoAsset = pickerManager.getPHAsset(ablumIndex, photoIndex: photoIndexPath) {
            pickerManager.getPhotoDefalutSize(ablumIndex, photoIndex: photoIndexPath, resultHandler: { (image, infoDic) in
                weakCell?.photoImageView.image = image
            })
            //改变状态
            if let photoIndex = pickerManager.index(ofSelect: photoAsset) {
                weakCell?.selectNumBt.isSelected = true
                cell.selectNumBt.setTitle("\(photoIndex+1)", for: .selected)
            }else {
                weakCell?.selectNumBt.isSelected = false
                cell.selectNumBt.setTitle("", for: .normal)
            }
            setPickerSelectBlock(cell: cell, photoAsset: photoAsset, ablumIndex: ablumIndex, photoIndex: photoIndexPath)
        }
        return cell
    }
    
    private func setPickerSelectBlock(cell: WWPickerCVCell, photoAsset: PHAsset, ablumIndex: Int, photoIndex: Int) {
        weak var weakCell = cell
        //判断selectCV是需要加入还是删除
        cell.selectBlock = { [weak self] () in
            let selectCount = self?.pickerManager.selectPhotoArr.count ?? 0
            if self?.pickerManager.isContains(formSelect: photoAsset) ?? false {
                let photoIndex  = self?.pickerManager.index(ofSelect: photoAsset) ?? 0
                let index       = photoIndex
                self?.pickerManager.remove(formSelect: photoAsset)
                NotificationCenter.default.post(name: WWImagePickerNotify.deleteSelectCell, object: IndexPath.init(item: index, section: 0))
                NotificationCenter.default.post(name: WWImagePickerNotify.reloadImagePicker, object: nil)
            }else {
                if selectCount >= WWImagePickerOptions.maxPhotoSelectNum {
                    guard self != nil else {
                        return
                    }
                    NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noMoreThanImages)
                    return
                }else {
                    //添加selectCV的cell
                    self?.pickerManager.append(toSelect: photoAsset)
                    let selectCount = self?.pickerManager.selectPhotoArr.count ?? 0
                    weakCell?.selectNumBt.isSelected = true
                    weakCell?.selectNumBt.setTitle("\(selectCount)", for: .selected)
                    weakCell?.animation()
                    NotificationCenter.default.post(name: WWImagePickerNotify.insertSelectCell, object: IndexPath.init(item: selectCount - 1, section: 0))
                }
            }
            NotificationCenter.default.post(name: WWImagePickerNotify.reloadSelectTotalNum, object: nil)
        }
    }
}

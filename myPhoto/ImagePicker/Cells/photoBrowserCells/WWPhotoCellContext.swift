//
//  WWPhotoCellContext.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPhotoCellContext
// @abstract PhotoBrowserCell的context
// @discussion PhotoBrowserCell的context
//

import UIKit
import Photos

class WWPhotoCellContext: NSObject {
    
    private var pickerManager: WWPickerManager

    init(pickerManager: WWPickerManager) {
        self.pickerManager = pickerManager
        super.init()
    }
    
    //MARK: Public Methods
    func register(collectionView: UICollectionView) {
        collectionView.register(UINib.init(nibName: WWPhotoCVCell.identfier , bundle: WWImagePickerBundle.bundle), forCellWithReuseIdentifier: WWPhotoCVCell.identfier)
        
//        collectionView.register(WWPhotoCVCell.self, forCellWithReuseIdentifier: WWPhotoCVCell.identfier)

    }
    
    func getCell(asset: PHAsset, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WWPhotoCVCell.identfier, for: indexPath) as! WWPhotoCVCell
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        pickerManager.getPhoto(size, alasset: asset) { (image, info) in
            if let image = image {
                let size = image.size
                let scale = CGFloat(size.width/size.height)
                let deviceScale = cell.photoSrcollView.bounds.width/cell.photoSrcollView.bounds.height
                if scale >= deviceScale {
                    cell.imageWidth.constant  = cell.photoSrcollView.bounds.width
                    cell.imageHeight.constant = cell.imageWidth.constant/scale
                    let interval = cell.photoSrcollView.bounds.height - cell.imageHeight.constant
                    cell.imageBottom.constant = interval/2
                    cell.imageTop.constant    = interval/2
                    cell.imageRight.constant  = 0
                    cell.imageLeft.constant   = 0
                }else {
                    cell.imageHeight.constant = cell.photoSrcollView.bounds.height
                    cell.imageWidth.constant  = cell.imageHeight.constant*scale
                    let interval = cell.photoSrcollView.bounds.width - cell.imageWidth.constant
                    cell.imageRight.constant  = interval/2
                    cell.imageLeft.constant   = interval/2
                    cell.imageTop.constant    = 0
                    cell.imageBottom.constant = 0
                }
            }
            cell.photoImageView.image = image
        }
        return cell
    }
}

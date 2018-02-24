//
//  WWCameraCVCell.swift
//  WWImagePickrController-swift
//
// **************************************************
// *                                  _____         *
// *         __  _  __     ___        \   /         *
// *         \ \/ \/ /    / __\       /  /          *
// *          \  _  /    | (__       /  /           *
// *           \/ \/      \___/     /  /__          *
// *                               /_____/          *
// *                                                *
// **************************************************
//  Github  :https://github.com/631106979
//  HomePage:http://imWW.com
//  CSDN    :http://blog.csdn.net/wang631106979
//
//  Created by 王崇磊 on 16/9/14.
//  Copyright © 2016年 王崇磊. All rights reserved.
//
// @class WWCameraCVCell
// @abstract 图片选择器的摄像的CollectionViewCell
// @discussion 图片选择器的摄像的CollectionViewCell

import UIKit

class WWCameraCVCell: UICollectionViewCell,
                       WWCellIdentfier {

    var imageCameraView:UIImageView

    
    override init(frame:CGRect){
        
        imageCameraView = UIImageView()
        super.init(frame: frame)
        contentView.addSubview(imageCameraView)

        imageCameraView.snp.makeConstraints({ (make) in
            make.center.equalTo(contentView.snp.center)
            make.width.height.equalTo(40)
        })

        imageCameraView.image = WWImagePickerOptions.cameraImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

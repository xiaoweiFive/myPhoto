//
//  WWCameraCVCell.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
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

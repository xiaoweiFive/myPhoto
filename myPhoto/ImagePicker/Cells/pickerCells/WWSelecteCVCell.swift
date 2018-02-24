//
//  WWSelecteCVCell.swift
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
// @class WWSelecteCVCell
// @abstract WWSelecteView的cell
// @discussion WWSelecteView的cell
//

import UIKit

class WWSelecteCVCell: UICollectionViewCell,
                        WWCellIdentfier {
    
    var selectImageView:UIImageView
    
    override init(frame:CGRect){
        selectImageView = UIImageView()
        super.init(frame: frame)
        contentView.addSubview(selectImageView)
        selectImageView.snp.makeConstraints({ (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(contentView)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

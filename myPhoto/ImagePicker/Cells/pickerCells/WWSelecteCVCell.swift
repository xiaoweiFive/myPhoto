//
//  WWSelecteCVCell.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
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

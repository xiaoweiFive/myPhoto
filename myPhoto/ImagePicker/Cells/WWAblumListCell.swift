//
//  WWAblumListCell.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWAblumListCell
// @abstract 相册列表的TableViewCell
// @discussion 相册列表的TableViewCell

import UIKit
import SnapKit

class WWAblumListCell: UITableViewCell,
                        WWCellIdentfier {

    var ablumNameLabel:UILabel
    var ablumImageView:UIImageView
    var selectImageView:UIImageView
    
//    //MARK: Override
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        ablumImageView.image  = WWImagePickerOptions.imageBuffer
//        selectImageView.highlightedImage = WWImagePickerOptions.ablumSelectBackGround
//    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String? ) {
        ablumNameLabel = UILabel()
        ablumImageView = UIImageView()
        selectImageView = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        ablumNameLabel.font = UIFont.systemFont(ofSize: 19.0)
        ablumNameLabel.textColor = color(50, 50, 50)
        contentView.addSubview(ablumNameLabel)
        contentView.addSubview(ablumImageView)
        contentView.addSubview(selectImageView)
        contentView.backgroundColor = UIColor.white
   
        ablumImageView.snp.makeConstraints({ (make) in
            make.left.top.equalTo(10)
            make.width.height.equalTo(70)
        })
        
        ablumNameLabel.snp.makeConstraints({ (make) in
            make.left.top.equalTo(ablumImageView.snp.right).offset(17)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(-10)
        })
        
        selectImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.bottom.top.equalTo(0)
            make.right.equalTo(0)
        })
        
        ablumImageView.image  = WWImagePickerOptions.imageBuffer
        selectImageView.highlightedImage = WWImagePickerOptions.ablumSelectBackGround
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

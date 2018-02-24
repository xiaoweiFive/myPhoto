//
//  WWSelectView.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWSelectView
// @abstract WWPhotoBrowserController页面的右上角的选择view
// @discussion WWPhotoBrowserController页面的右上角的选择view
//

import UIKit

internal class WWSelectView: UIView {
    
    var selectLabel:UILabel
    var selectBt:UIButton

    var selecrIndex: Int = 0 {
        willSet {
            if newValue == 0 {
                selectBt.isSelected  = false
                selectLabel.isHidden = true
            }else {
                selectBt.isSelected  = true
                selectLabel.isHidden = false
                selectLabel.text     = "\(newValue)"
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        selectLabel.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(0)
        })
        
        selectBt.snp.makeConstraints({ (make) in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(0)
        })
    }
    
    
    required init() {
        selectLabel = UILabel()
        selectBt = UIButton()
        super.init(frame: .zero)
        self.addSubview(selectLabel)
        self.addSubview(selectBt)

        let size = CGSize.init(width: 22, height: 22)
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
        selectBt.setImage(selectImage, for: .selected)
        
        selectBt.setImage(WWImagePickerBundle.imageFromBundle("image_pickerDefault"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        let size = CGSize.init(width: 22, height: 22)
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        let context = UIGraphicsGetCurrentContext()
//        if let color = WWImagePickerOptions.pickerSelectColor {
//            color.setFill()
//        }else {
//            WWImagePickerOptions.tintColor.setFill()
//        }
//        context?.addArc(center: CGPoint.init(x: size.width / 2, y: size.height / 2), radius: size.width / 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
//        context?.fillPath()
//        let selectImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        selectBt.setImage(selectImage, for: .selected)
//
//        selectBt.setImage(WWImagePickerBundle.imageFromBundle("image_pickerDefault"), for: .normal)
//    }
    
    //MARK: init Methods
    class func initFormNib() -> WWSelectView {
        let view = WWSelectView()
        view.selectBt.isSelected  = false
        view.selectLabel.isHidden = true
        return view
    }

}

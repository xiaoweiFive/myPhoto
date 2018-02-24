//
//  WWPickerCVCell.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPickerCVCell
// @abstract 图片选择器的CollectionViewCell
// @discussion 图片选择器的CollectionViewCell

import UIKit

class WWPickerCVCell: UICollectionViewCell,
                       WWCellIdentfier {
    
    var selectNumBt:UIButton
    var clickNumBt:UIButton
    var photoImageView:UIImageView
    var selectBlock:(()->Void)?

    override init(frame:CGRect){
        selectNumBt = UIButton()
        clickNumBt = UIButton()
        photoImageView = UIImageView()
        super.init(frame: frame)

        contentView.addSubview(photoImageView)
        contentView.addSubview(selectNumBt)
        contentView.addSubview(clickNumBt)
        
        clickNumBt.addTarget(self, action: #selector(selectAction(sender:)), for: .touchUpInside)

        selectNumBt.snp.makeConstraints({ (make) in
            make.top.equalTo(8)
            make.right.equalTo(-8)
            make.width.height.equalTo(22)
        })
        
        clickNumBt.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.width.height.equalTo(37)
        })
        
        photoImageView.snp.makeConstraints({ (make) in
            make.left.equalTo(0)
            make.bottom.top.equalTo(0)
            make.right.equalTo(0)
        })
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        selectNumBt.setBackgroundImage(WWImagePickerOptions.pickerDefault, for: .normal)
        
        let size = WWImagePickerOptions.pickerDefault?.size ?? CGSize.zero
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
        selectNumBt.setBackgroundImage(selectImage, for: .selected)
    }
    
    
    //MARK: - Public Methods
    @discardableResult
    func animation() -> WWPickerCVCell {
        let animation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        animation.duration = 0.35
        animation.calculationMode = kCAAnimationCubic
        animation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        self.selectNumBt.layer.add(animation, forKey: "scaleAnimation")
        return self
    }
    
    //MARK: - Target Methods
    @objc fileprivate func selectAction(sender: UIButton) {
        if selectBlock != nil {
            selectBlock!()
        }
    }
    
}

//
//  WWAblumCenterView.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWAblumCenterView
// @abstract 图片选择器nav上的titleView
// @discussion 图片选择器nav上的titleView
//

import UIKit

internal class WWAblumCenterView: UIView {

    var centerTitle:String? {
        didSet {
            titleLabel.text = centerTitle
        }
    }
    
    var selectBlock:((Bool) ->Void)?
    
    var isSelect = false {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                self.arrowImageView.layer.transform = CATransform3DRotate(self.arrowImageView.layer.transform,  CGFloat(Double.pi), 1.0, 0.0, 0.0)
            }) 
            selectBlockAction()
        }
    }
    
    private let arrowImageView = UIImageView.init(image: WWImagePickerOptions.pickerArrow)
    private let titleLabel = UILabel()
    
    //MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.textColor = UIColor.white
        titleLabel.textColor = UIColor.green

        addSubview(arrowImageView)
        addSubview(titleLabel)
        //添加约束
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -11.0))
        addConstraint(NSLayoutConstraint.init(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint.init(item: arrowImageView, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint.init(item: arrowImageView, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1.0, constant: 7.0))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelect = !isSelect
        selectBlockAction()
    }
    
    func selectBlockAction() {
        if selectBlock != nil {
            selectBlock!(isSelect)
        }
    }
    
    //MARK: Initial Methods
    convenience init(frame: CGRect, selectBlock:@escaping (Bool) ->Void) {
        self.init(frame: frame)
        self.selectBlock = selectBlock
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

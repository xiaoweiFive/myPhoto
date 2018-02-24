//
//  WWPickerExtension.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPickerExtension
// @abstract WWPicker的扩展
// @discussion WWPicker的扩展
//

import UIKit

internal extension UIViewController {
    
    /**
     添加nav右侧按钮
     */
    @discardableResult
    func addWWPhotoNavRightButton(_ btName:String) -> UIButton {
        let rightBt = UIButton()
        rightBt.contentHorizontalAlignment = .right
        rightBt.setTitle(btName, for: UIControlState())
        rightBt.setTitleColor(UIColor.white, for: UIControlState())
        rightBt.titleLabel?.font = UIFont.WWRegularFontOfSize(15)
        rightBt.addTarget(self, action: #selector(photoRightAction(_:)), for: .touchUpInside)
        rightBt.frame.size = CGSize(width: 16*CGFloat(btName.characters.count), height: 20)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBt)
        return rightBt
    }
    
    /**
     添加nav左侧按钮
     */
    @discardableResult
    func addWWPhotoNavLeftButton(_ btName:String) -> UIButton {
        let leftBt = UIButton()
        leftBt.contentHorizontalAlignment = .left
        leftBt.setTitle(btName, for: UIControlState())
        leftBt.setTitleColor(UIColor.white, for: UIControlState())
        leftBt.titleLabel?.font = UIFont.WWRegularFontOfSize(15)
        leftBt.frame.size = CGSize(width: 16*CGFloat(btName.characters.count), height: 20)
        leftBt.addTarget(self, action: #selector(photoLeftAction(_:)), for: .touchUpInside)
        leftBt.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBt)
        return leftBt
    }
    
    /**
     添加nav的titleView
     */
    @discardableResult
    func setWWPhotoNavTitle(_ title:String) -> UILabel {
        let titleLable = UILabel()
        titleLable.text = title
        titleLable.textColor = UIColor.white
        titleLable.font = UIFont.WWMediumFontOfSize(17)
        titleLable.sizeToFit()
        navigationItem.titleView = titleLable
        return titleLable
    }
    
    @objc func photoLeftAction(_ sender: UIButton) {
        
    }
    
    @objc func photoRightAction(_ sender: UIButton) {
        
    }
}

//MARK: 字体
extension UIFont {
    /**
     更具系统不同返回light字体
     */
    class func WWLightFontOfSize(_ fontSize:CGFloat) -> UIFont {
        return UIFont.init(name: WWImagePickerOptions.fontLightName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    /**
     更具系统不同返回Regular字体
     */
    class func WWRegularFontOfSize(_ fontSize:CGFloat) -> UIFont {
        return UIFont.init(name: WWImagePickerOptions.fontRegularName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    /**
     更具系统不同返回Medium字体
     */
    class func WWMediumFontOfSize(_ fontSize:CGFloat) -> UIFont {
        return UIFont.init(name: WWImagePickerOptions.fontMediumName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
}

//MARK: 数组的扩展
extension Array {
    subscript (WW_safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
    @discardableResult
    mutating func WW_removeSafe(at index: Int) -> Bool {
        if (0..<count).contains(index) {
            self.remove(at: index)
            return true
        }
        return false
    }
}

protocol WWCellIdentfier {}

extension WWCellIdentfier {
    static var identfier:String {
        return "\(self)"
    }
}

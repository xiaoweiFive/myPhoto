//
//  WWImagePickerOptions.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//

import UIKit

public struct WWImagePickerOptions {
    
    /// 字体设置，默认苹方字体
    public static var fontLightName: String   = "PingFangSC-Light"
    public static var fontRegularName: String = "PingFangSC-Regular"
    public static var fontMediumName: String  = "PingFangSC-Medium"
    
    /// 是否需要拍照功能
    public static var needPickerCamera: Bool  = false
    /// 相册页每行的照片数，默认每行3张
    public static var photoLineNum: Int       = 3
    /// 相册选择页照片的间隔，默认3，最小为2
    public static var photoInterval: Int      = 3
    /// 相册选择器最大选择的照片数
    public static var maxPhotoSelectNum: Int  = 9
    /// 是否显示selectView
    public static var isShowSelecView: Bool   = true
    
    /// launchImage的配置
    /// 相册启动图片和启动颜色，二选一，launchImage优先级高
    public static var launchImage: UIImage?   = nil
    /// 没有设置默认用imageTintColor
    public static var launchColor: UIColor?   = nil
    
    /// 状态栏的样式
    public static var statusBarStyle: UIStatusBarStyle = .lightContent
    
    /// 图片的配置
    public static var imageBuffer: UIImage?        = WWImagePickerBundle.imageFromBundle("image_buffer")
    public static var ablumSelectBackGround: UIImage?   = WWImagePickerBundle.imageFromBundle("image_ablumSelectBackGround")
    public static var cameraImage: UIImage?   = WWImagePickerBundle.imageFromBundle("image_camera")
    public static var pickerArrow: UIImage?   = WWImagePickerBundle.imageFromBundle("image_pickerArrow")
    public static var pickerDefault: UIImage? = WWImagePickerBundle.imageFromBundle("image_pickerDefault")
    public static var selectPlaceholder: UIImage? = WWImagePickerBundle.imageFromBundle("image_selectPlaceholder")
    
    /// 颜色的配置
    public static var tintColor: UIColor       = UIColor(red: 49/255, green: 47/255, blue: 47/255, alpha: 1)
    /// 没有设置默认用imageTintColor
    public static var pickerSelectColor: UIColor?   = UIColor(red: 255/255, green: 0/255, blue: 27/255, alpha: 1)
    /// 没有设置默认用imageTintColor
    public static var selectViewBackColor: UIColor? = nil
}

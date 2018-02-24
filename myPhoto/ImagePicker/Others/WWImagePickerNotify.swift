//
//  WWImagePickerNotify.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWImagePickerNotify
// @abstract WWImagePicker的通知类
// @discussion WWImagePicker的通知类
//

import Foundation

internal struct WWImagePickerNotify {
    // 刷新imagePicker
    static let reloadImagePicker = Notification.Name("WWReloadImagePickerNotify")
    
    // 刷新imagePicker的selectView
    static let reloadSelect = Notification.Name("WWReloadSelectPickerNotify")
    // 删除imagePicker的selectView的cell
    static let deleteSelectCell = Notification.Name("WWDeleteSelectPickerCellNotofy")
    // 插入imagePicker的selectView的cell
    static let insertSelectCell = Notification.Name("WWInsertSelectPickerCellNotofy")

    // 刷新imagePicker的selectView的TotalNum
    static let reloadSelectTotalNum = Notification.Name("WWReloadSelectTotalNumNotofy")
    
    // imagePicker的error通知
    static let imagePickerError = Notification.Name("WWImagePickerErrorNotify")
    
    // selectPicker的zoom通知
    static let selectPickerZoom = Notification.Name("WWSelectPickerZoom")
}





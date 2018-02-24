//
//  WWImagePikcerDelegate.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWImagePikcerDelegate
// @abstract WWImagePikcerVC的Delegate
// @discussion WWImagePikcerVC的Delegate
//

import UIKit

public protocol WWImagePikcerDelegate: class {
    /// 点击取消按钮的回调方法
    func WWImagePickerCancel(_ picker: WWImagePickerController) -> Void
    /// 选择完成后的回调方法
    func WWImagePickerComplete(_ picker: WWImagePickerController, imageArr: [UIImage]) -> Void
    /// 反馈错误信息的回调方法
    func WWImagePickerError(_ picker: WWImagePickerController, error: WWError) -> Void
}

extension WWImagePikcerDelegate {
    public func WWImagePickerCancel(_ picker: WWImagePickerController) -> Void {}
    public func WWImagePickerComplete(_ picker: WWImagePickerController, imageArr: [UIImage]) -> Void {}
    public func WWImagePickerError(_ picker: WWImagePickerController, error: WWError) -> Void {}
}



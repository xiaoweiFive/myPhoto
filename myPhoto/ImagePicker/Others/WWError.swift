//
//  WWError.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWError
// @abstract 错误提示
// @discussion 错误提示
//

import UIKit

public enum WWError {
    /// 没有相册访问权限
    case noAlbumPermissions
    /// 没有摄像头访问权限
    case noCameraPermissions
    /// 超过选择最大数
    case noMoreThanImages
    public var lcalizable: String? {
        if self == .noAlbumPermissions {
            return WWImagePickerBundle.localizedString(key: "没有相册访问权限")
        }
        if self == .noCameraPermissions {
            return WWImagePickerBundle.localizedString(key: "没有摄像头访问权限")
        }
        if self == .noMoreThanImages {
            return String(format: WWImagePickerBundle.localizedString(key: "最多选择%d张照片") , WWImagePickerOptions.maxPhotoSelectNum)
        }
        return nil
    }
}

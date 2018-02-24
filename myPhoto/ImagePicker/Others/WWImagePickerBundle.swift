//
//  WWImagePickerBundle.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//

import UIKit

internal struct WWImagePickerBundle {
    
    // 当前的bundle
    static var bundle: Bundle {
        let bundle = Bundle(for: WWImagePickerController.self)
        return bundle
    }
    
    // 存放资源的bundle
    static var wwBundle: Bundle {
        let bundle = Bundle(path: self.bundle.path(forResource: "WWImagePickerController", ofType: "bundle")!)
        return bundle!
    }
    
    static func imageFromBundle(_ imageName: String) -> UIImage? {
        var imageName = imageName
        if UIScreen.main.scale == 2 {
            imageName = imageName + "@2x"
        }else if UIScreen.main.scale == 3 {
            imageName = imageName + "@3x"
        }
        
        let image = UIImage.init(named: imageName)
        
        return image
        
    }
    
    static func localizedString(key: String) -> String {

        return key
    }
}


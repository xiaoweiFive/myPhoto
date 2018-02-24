//
//  WWBaseImagePickerController.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWImagePickerController
// @abstract WWBaseImagePickerController
// @discussion WWBaseImagePickerController
//

import UIKit

internal class WWBaseImagePickerController: UIImagePickerController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return WWImagePickerOptions.statusBarStyle
    }
    
    //MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

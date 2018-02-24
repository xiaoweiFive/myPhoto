//
//  ViewController.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, WWImagePikcerDelegate  {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 300, width: 100, height: 50))
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        
        
        
    }
    
    
    @objc func clickBtn()  {
        
        let vc = WWImagePickerController.init()
        vc.delegate = self
        let nav = WWNavigationController.init(rootViewController: vc, navBarColor: WWImagePickerOptions.tintColor)
        self.present(nav, animated: true, completion: nil)
//
        
        
        WWImagePickerController.present(inVC: self, delegate: self)
    }
    

    func WWImagePickerCancel(_ picker: WWImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func WWImagePickerComplete(_ picker: WWImagePickerController, imageArr: [UIImage]) {
        picker.dismiss(animated: true, completion: nil)
        print(imageArr)
    }
    
    func WWImagePickerError(_ picker: WWImagePickerController, error: WWError) {
        let al = UIAlertController.init(title: nil, message: error.lcalizable, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        al.addAction(cancel)
        picker.present(al, animated: true, completion: nil)
    }
}



var screenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

var screenHight: CGFloat {
    return UIScreen.main.bounds.size.height
}


func color(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1.0) -> UIColor {
    
    return UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: a)
}


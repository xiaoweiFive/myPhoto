//
//  WWPhotoCVCell.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPhotoCVCell
// @abstract 图片浏览器的CollectionViewCell
// @discussion 图片浏览器的CollectionViewCell

import UIKit

class WWPhotoCVCell: UICollectionViewCell,
                      WWCellIdentfier,
                      UIScrollViewDelegate  {
    
    @IBOutlet weak var photoSrcollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageTop: NSLayoutConstraint!
    @IBOutlet weak var imageRight: NSLayoutConstraint!
    @IBOutlet weak var imageBottom: NSLayoutConstraint!
    @IBOutlet weak var imageLeft: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        NotificationCenter.default.addObserver(self, selector: #selector(zoomChage), name: WWImagePickerNotify.selectPickerZoom, object: nil)
    }
    
    @objc private func zoomChage() {
        photoSrcollView.zoomScale = 1.0
    }
    
    //MARK: UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var c = (scrollView.frame.height - photoImageView.frame.height) / 2
        if c <= 0 {c = 0}
        imageTop.constant = c
        imageBottom.constant = c
    }
}

//
//  WWPhotoBrowserController.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWPhotoBrowserController
// @abstract 相册的图片浏览器的VC
// @discussion 相册的图片浏览器的VC
//

import UIKit
import Photos

internal class WWPhotoBrowserController: UIViewController {

    fileprivate var photoBrowserView: UICollectionView!

    //当前photo的index
    var currentIndex:Int = 0
    
    fileprivate var context: WWPhotoCellContext?
    
    fileprivate var pickerManager: WWPickerManager
    //选择的是否是selectAssetArr
    fileprivate var isSelect:Bool = false
    //选择的照片的数组
    fileprivate var selectAssetArr: [PHAsset]?
    //相册的PHFetchResult
    fileprivate var photoResult: PHFetchResult<PHAsset>?
    //是否出现过
    fileprivate var isViewDidAppear: Bool = false
    
    fileprivate let selecView = WWSelectView.initFormNib()
    //MARK: Public Methods
    
    //MARK: Override
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidAppear = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionview()
        // Do any additional setup after loading the view.
        context = WWPhotoCellContext.init(pickerManager: pickerManager)
        context?.register(collectionView: photoBrowserView)
        addWWPhotoNavLeftButton(WWImagePickerBundle.localizedString(key: "返回"))
        countSelectIndex(currentIndex)
        
        pickerManager.isSynchronous = true
        photoBrowserView.performBatchUpdates(nil) { (finish) in
            let size = UIScreen.main.bounds.size
            self.photoBrowserView.setContentOffset(CGPoint.init(x: (size.width+20)*CGFloat(self.currentIndex), y: 0), animated: false)
            self.pickerManager.isSynchronous = false
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: selecView)
        selecView.selectBt.addTarget(self, action: #selector(selectViewAction(_ :)), for: .touchUpInside)
    }

    
    private func configCollectionview() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        photoBrowserView =  UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        photoBrowserView.delegate = self
        photoBrowserView.dataSource = self
        view.addSubview(photoBrowserView)
    }
    
    override func photoLeftAction(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: Initial Methods
    init(_ pickerManager: WWPickerManager, currentIndex: Int, selectAssetArr: [PHAsset]) {
        self.pickerManager  = pickerManager
        super.init(nibName: nil, bundle:nil)
        self.currentIndex   = currentIndex
        self.selectAssetArr = selectAssetArr
        self.isSelect       = true
    }
    
    init(_ pickerManager: WWPickerManager, currentIndex: Int, photoResult: PHFetchResult<PHAsset>) {
        self.pickerManager = pickerManager
        super.init(nibName: nil, bundle:nil)
        self.currentIndex  = currentIndex
        self.photoResult   = photoResult
        self.isSelect      = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    fileprivate func countSelectIndex(_ index: Int) {
        if isSelect {
            setWWPhotoNavTitle("\(index+1)/\(selectAssetArr!.count)")
            selecView.selecrIndex = index+1
        }else {
            setWWPhotoNavTitle("\(index+1)/\(photoResult!.count)")
            if let alasset = photoResult?[index] {
                let aindex = pickerManager.index(ofSelect: alasset)
                if aindex == nil {
                    selecView.selecrIndex = 0
                }else {
                    selecView.selecrIndex = aindex! + 1
                }
            }
        }
    }
    
    
    //MARK: Target Methods
    @objc private func selectViewAction(_ sender: UIButton) {
        defer {
            NotificationCenter.default.post(name: WWImagePickerNotify.reloadSelect, object: nil, userInfo: nil)
        }
        let index = currentIndex
        if sender.isSelected {
            //删除
            if isSelect {
                self.photoBrowserView.performBatchUpdates({
                    if let alasset = self.selectAssetArr?[index] {
                        if self.pickerManager.index(ofSelect: alasset) != nil {
                            self.pickerManager.remove(formSelect: alasset)
                        }
                    }
                    self.selectAssetArr?.remove(at: index)
                    if self.currentIndex != 0 {
                        self.currentIndex = self.currentIndex - 1
                    }
                    self.countSelectIndex(self.currentIndex)
                    self.photoBrowserView.deleteItems(at: [IndexPath.init(row: index, section: 0)])
                }, completion: { (complete) in
                    if self.pickerManager.selectPhotoArr.count == 0 {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                })
            }else {
                if let alasset = photoResult?[index] {
                    if self.pickerManager.index(ofSelect: alasset) != nil {
                        self.pickerManager.remove(formSelect: alasset)
                        selecView.selecrIndex = 0
                    }
                }
            }
        }else {
            //添加
            if !isSelect {
                if pickerManager.selectPhotoArr.count >= WWImagePickerOptions.maxPhotoSelectNum {
                    NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noMoreThanImages)
                    return
                }
                if let alasset = photoResult?[index] {
                    self.pickerManager.append(toSelect: alasset)
                    self.selecView.selecrIndex = self.pickerManager.selectPhotoArr.count
                }
            }
        }
    }
}


//MARK: UICollectionView
extension WWPhotoBrowserController:  UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout{
    //MARK: UICollectionViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isViewDidAppear else {
            return
        }
        let floatIndex:CGFloat = scrollView.contentOffset.x/scrollView.frame.width
        let intIndex:Int = Int(scrollView.contentOffset.x/scrollView.frame.width)
        if CGFloat(intIndex) == floatIndex {
            if intIndex != currentIndex {
                NotificationCenter.default.post(name: WWImagePickerNotify.selectPickerZoom, object: nil)
            }
            countSelectIndex(intIndex)
            currentIndex = intIndex
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        return CGSize(width: bounds.width + 20, height: bounds.height - 64)
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var asset: PHAsset?
        if isSelect {
            asset = selectAssetArr![indexPath.row]
        }else {
            asset = photoResult![indexPath.row]
        }
        let cell = context!.getCell(asset: asset!, collectionView: collectionView, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSelect {
            return selectAssetArr!.count
        }else {
            return photoResult!.count
        }
    }
}

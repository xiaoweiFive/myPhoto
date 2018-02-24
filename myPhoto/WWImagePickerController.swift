//
//  WWImagePickerController.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//

import UIKit
import Photos

public class WWImagePickerController: UIViewController {

    weak var delegate: WWImagePikcerDelegate?

    //UI需要定制
    fileprivate var centerView: WWAblumCenterView?
    fileprivate var ablumList: WWAblumListView?
    fileprivate var photoSelectView: WWPhotoSelectView?
    fileprivate var cellContext: WWPickerCellContext?
    
    fileprivate var photoAblumCV: UICollectionView!
    fileprivate let pickerView = WWBaseImagePickerController()
    fileprivate var pickerManager: WWPickerManager?

    //选择的相册的index
    fileprivate var ablumSelectIndex = 0
    //是否是第一次启动
    fileprivate var firstLaunch:Bool   = true
    //View是否DidLoad
    fileprivate var isViewDidLoad:Bool = false

    override public func viewDidLoad() {
        super.viewDidLoad()
        photoAuthorization()
        configCollectionview()
        configNav()
        addNotify()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @discardableResult
    class public func present(inVC: UIViewController?, delegate: WWImagePikcerDelegate) -> (WWImagePickerController, WWNavigationController) {
        let vc = WWImagePickerController()
        vc.delegate = delegate
        let nav = WWNavigationController.init(rootViewController: vc, navBarColor: WWImagePickerOptions.tintColor)
        inVC?.present(nav, animated: true, completion: nil)
        return (vc, nav)
    }
    
    //MARK: Override
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewDidLoad = true
        if firstLaunch == true && PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            configPhotoVC()
        }
    }

    override func photoLeftAction(_ sender: UIButton) {
        delegate?.WWImagePickerCancel(self)
    }
    
    override func photoRightAction(_ sender: UIButton) {
        var imageArr = [UIImage]()
        if pickerManager != nil {
            let count = pickerManager!.selectPhotoArr.count
            if count == 0 {
                delegate?.WWImagePickerComplete(self, imageArr: imageArr)
                return
            }
            for asset in pickerManager!.selectPhotoArr {
                pickerManager!.getPhotoData(alasset: asset, resultHandler: { [weak self] (data, orientation) in
                    if data != nil {
                        let image = UIImage.init(data: data!)
                        if image != nil {
                            imageArr.append(image!)
                        }
                        if imageArr.count == count {
                            DispatchQueue.main.async {
                                self?.delegate?.WWImagePickerComplete(self!, imageArr: imageArr)
                            }
                        }
                    }
                })
            }
        }
    }
    

    //MARK: Private Methods
    private func addNotify() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadSelect), name: WWImagePickerNotify.reloadSelect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPhoto), name: WWImagePickerNotify.reloadImagePicker, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(imagePickerError(_:)), name: WWImagePickerNotify.imagePickerError, object: nil)
    }
    
    private func configCollectionview() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        photoAblumCV =  UICollectionView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-64-60), collectionViewLayout: layout)
        photoAblumCV.delegate = self
        photoAblumCV.dataSource = self
        view.addSubview(photoAblumCV)
    }
    
    
    private func configNav() {
        addWWPhotoNavLeftButton(WWImagePickerBundle.localizedString(key: "取消"))
        addWWPhotoNavRightButton(WWImagePickerBundle.localizedString(key: "完成"))
    }
    
    /**
     刷新PhotoCV
     */
    private func reloadPhotoCV() {
        pickerManager?.isSynchronous = true
        photoAblumCV.reloadData()
        //保证刷新的时候是同步刷新的，要不会有闪烁
        photoAblumCV.performBatchUpdates({
        }, completion: { [weak self] (finished) in
            self?.pickerManager?.isSynchronous = false
        })
    }
    
    /**
     相册授权
     */
    private func photoAuthorization() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noAlbumPermissions)
            break
        // 用户拒绝,提示开启
        case .notDetermined:
            // 尚未请求,立即请求
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                if status == .authorized {
                    // 用户同意
                    DispatchQueue.main.async {
                        self.configPhotoVC()
                    }
                }
            })
            break
        case .restricted:
            NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noAlbumPermissions)
            break
        // 用户无法解决的无法访问
        case .authorized:
            // 用户已授权
            configPhotoVC()
            break
        }
    }
    
    private func configPhotoVC() {
        if isViewDidLoad == false {
            return
        }
        if firstLaunch {
            firstLaunch = false
        }
        pickerManager = WWPickerManager()
        cellContext   = WWPickerCellContext.init(pickerManager: pickerManager!)
        cellContext?.register(collectionView: photoAblumCV)
        addSelectView()
        addCenterView()
        addAblumList()
        photoAblumCV.reloadData()
    }
    
    fileprivate func addCenterView() {
        centerView = WWAblumCenterView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45), selectBlock: { [weak self] (select) in
            self?.ablumList?.dropAblbumList(select)
        })
        navigationItem.titleView = centerView
        centerView?.isUserInteractionEnabled = false
        centerView!.centerTitle  = pickerManager?.getAblumTitle(ablumSelectIndex)
    }
    
    fileprivate func addAblumList() {
        ablumList = WWAblumListView.show(inView: view, pickerManager: pickerManager!)
        ablumList?.select = { [weak self] (index) in
            self?.ablumSelectIndex = index
            self?.centerView?.isSelect = !(self?.centerView?.isSelect ?? false)
            self?.photoAblumCV.reloadData()
            self?.photoAblumCV.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self?.centerView?.centerTitle = self?.pickerManager?.getAblumTitle(index)
        }
        ablumList?.cancle = { [weak self] in
            self?.centerView?.isSelect = !(self?.centerView?.isSelect ?? false)
        }
    }
    
    fileprivate func addSelectView() {
        if WWImagePickerOptions.isShowSelecView {
            let bounds = UIScreen.main.bounds
            photoSelectView = WWPhotoSelectView.init(frame: CGRect.init(origin: CGPoint.init(x: 0, y: bounds.height - 47 - 64), size: CGSize.init(width: bounds.width, height: 47)), pickerManager: pickerManager!)
            
            photoSelectView?.pushBlock = { [weak self] (vc) in
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            photoAblumCV.contentInset = UIEdgeInsetsMake(0, 0, 47, 0)
            photoSelectView?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(photoSelectView!)
            photoSelectView?.addConstraint(NSLayoutConstraint(item: photoSelectView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 47))
            view.addConstraint(NSLayoutConstraint(item: photoSelectView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: photoSelectView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: photoSelectView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
            
        }else {
            photoAblumCV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    fileprivate func imageCamereShow() {
        if cameraAuthorization() {
            pickerView.navigationBar.barTintColor = WWImagePickerOptions.tintColor
            pickerView.navigationBar.tintColor    = UIColor.white
            pickerView.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            pickerView.delegate = self
            pickerView.sourceType = .camera
            self.present(pickerView, animated: true, completion: nil)
        }
    }
    
    fileprivate func cameraAuthorization() -> Bool {
        let mediaType = AVMediaType.video
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        /// 是否在模拟器
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noCameraPermissions)
            return false
        #else
            if authorizationStatus == .restricted || authorizationStatus == .denied {
                NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noCameraPermissions)
                AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (flag) in
                    if flag {
                        self.imageCamereShow()
                    }
                })
                return false
            }
            return true
        #endif
        //        if TARGET_OS_SIMULATOR != 0 {
        //            NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noCameraPermissions)
        //            return false
        //        }
    }
    
    //MARK: Notification Methods
    //刷新选择的相册列表
    @objc private func reloadSelect() {
        reloadPhotoCV()
        photoSelectView?.selectCollectionView.reloadData()
        if let pickerManager = pickerManager {
            photoSelectView?.imageSelectNum.text = String.init(format: "%d", pickerManager.selectPhotoArr.count)
        }
    }
    
    //刷新相册列表
    @objc private func reloadPhoto() {
        reloadPhotoCV()
    }
    
    //错误提示
    @objc private func imagePickerError(_ not: Notification) {
        if let error = not.object as? WWError {
            delegate?.WWImagePickerError(self, error: error)
        }
    }
}

//MARK: UICollectionView
extension WWImagePickerController: UICollectionViewDelegate,
    UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if WWImagePickerOptions.needPickerCamera && indexPath.row == 0 {
            let conut = pickerManager?.selectPhotoArr.count ?? 0
            if conut >= WWImagePickerOptions.maxPhotoSelectNum {
                NotificationCenter.default.post(name: WWImagePickerNotify.imagePickerError, object: WWError.noMoreThanImages)
                return
            }
            imageCamereShow()
            return
        }
        if let result = pickerManager?.getAblumResult(ablumSelectIndex) {
            var currentIndex = indexPath.row
            if WWImagePickerOptions.needPickerCamera {
                currentIndex = currentIndex - 1
            }
            let browserVC = WWPhotoBrowserController.init(pickerManager!, currentIndex: currentIndex, photoResult: result)
            navigationController?.pushViewController(browserVC, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return WWPickerManager.pickerPhotoSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(WWImagePickerOptions.photoInterval)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(WWImagePickerOptions.photoInterval)
    }
    
    //MARK: UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard cellContext != nil else {
            return 0
        }
        return cellContext!.getPikcerCellNumber(ablumIndex: ablumSelectIndex)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard cellContext != nil else {
            let cell = UICollectionViewCell()
            return cell
        }
        return cellContext!.getPickerCell(collectionView, ablumIndex: ablumSelectIndex, photoIndex: indexPath.row)
    }
}


//MARK: UIImagePickerController
extension WWImagePickerController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    //MARK: UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                DispatchQueue.main.async {
                    self.delegate?.WWImagePickerComplete(self, imageArr: [image])
                }
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (flag, error) in
                    
                })
            })
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

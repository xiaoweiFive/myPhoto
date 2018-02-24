//
//  WWAblumListView.swift
//  myPhoto
//
//  Created by zhangzhenwei on 2018/2/23.
//  Copyright © 2018年 zhangzhenwei. All rights reserved.
//
// @class WWAblumListView
// @abstract 相册列表的view
// @discussion 相册列表的view
//

import UIKit

internal class WWAblumListView: UIView,
                        UITableViewDelegate,
                        UITableViewDataSource {
    //选择的相册的index
    var ablumSelectIndex = 0
    private var pickerManager: WWPickerManager?
    @IBOutlet weak var ablumTableView: UITableView!
    @IBOutlet weak var maskBackView: UIView!
    @IBOutlet weak var ablumTableHeight: NSLayoutConstraint!
    
    var select: ((_ index: Int) -> Void)?
    var cancle: (() -> Void)?
    
    //MARK: Public Methods
    func dropAblbumList(_ select:Bool) {
        if select {
            isUserInteractionEnabled = true
        }else {
            isUserInteractionEnabled = false
        }
        UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
            if select {
                self.ablumTableHeight.constant = self.frame.size.height - 51
                self.maskBackView.alpha = 0.7
            }else {
                self.ablumTableHeight.constant = 0
                self.maskBackView.alpha = 0.0
            }
            self.layoutIfNeeded()
        }) { (complete) in
            DispatchQueue.main.async(execute: {
                self.ablumTableView.reloadData()
            })
        }
    }
    
    //MARK: Override
    override func awakeFromNib() {
        super.awakeFromNib()
        ablumTableView.register(UINib.init(nibName: WWAblumListCell.identfier, bundle: WWImagePickerBundle.bundle), forCellReuseIdentifier: WWAblumListCell.identfier)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(cancleAction))
        maskBackView.addGestureRecognizer(tap)
    }
    
    //MARK: Initial Methods
    class func `init`(pickerManager: WWPickerManager) -> WWAblumListView {
        let view = WWAblumListView()
        view.pickerManager = pickerManager
        return view
    }
    
    
    class func show(inView: UIView, pickerManager: WWPickerManager) -> WWAblumListView {
        let view = WWAblumListView.init(pickerManager: pickerManager)
        view.frame = inView.bounds
        inView.addSubview(view)
        view.isUserInteractionEnabled = false
        return view
    }
    
    //MARK: private Methods
    @objc private func cancleAction() {
        cancle?()
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        select?(indexPath.row)
        ablumSelectIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //相册的数量
        if pickerManager != nil {
            return pickerManager!.photoAlbums.count
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WWAblumListCell = tableView.dequeueReusableCell(withIdentifier: WWAblumListCell.identfier, for: indexPath) as! WWAblumListCell
        cell.ablumNameLabel.text = pickerManager?.getAblumTitle(indexPath.row)
        weak var weakCell = cell
        pickerManager?.getPhoto(indexPath.row, photoIndex: 0, photoSize: cell.ablumImageView.frame.size, resultHandler: { (image, infoDic) in
            weakCell?.ablumImageView.image = image
        })
        if (indexPath as NSIndexPath).row == ablumSelectIndex {
            cell.selectImageView.isHighlighted = true
        }else {
            cell.selectImageView.isHighlighted = false
        }
        return cell
    }
}

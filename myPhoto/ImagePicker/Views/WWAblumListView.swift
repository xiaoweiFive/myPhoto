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
                self.maskBackView.alpha = 0.7
                self.ablumTableView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 51 - 64)
            }else {
                self.maskBackView.alpha = 0.0
                self.ablumTableView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 0)
            }
        }) { (complete) in
            DispatchQueue.main.async(execute: {
                self.ablumTableView.reloadData()
            })
        }
    }

    lazy var maskBackView:UIView = {
        let maskBackView =  UIView.init(frame: self.bounds)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(cancleAction))
        maskBackView.addGestureRecognizer(tap)
        self.addSubview(maskBackView)
        return maskBackView
    }()
    
    
    lazy var ablumTableView:UITableView = {
        let tableView =  UITableView.init(frame:CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 51))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(WWAblumListCell.self, forCellReuseIdentifier: WWAblumListCell.identfier)
        self.addSubview(tableView)
        return tableView;
    }()
    
   
    
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

//
//  BTDetailViewController.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/7.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit
import Photos

class BTDetailViewController: BTBaseViewController {
    
    var myAsset:PHAsset!
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        //获取文件名
        PHImageManager.default().requestImageData(for: myAsset, options: nil,
                                                                 resultHandler: {
                                                                    _, _, _, info in
          self.title = (info!["PHImageFileURLKey"] as! NSURL).lastPathComponent
        })
        
        //获取图片信息
        textView.text = "图片详情：\n\n"
            + "类型：\(myAsset.mediaType)\n"
            + "日期：\(myAsset.creationDate!)\n"
            + "修改日期：\(myAsset.modificationDate!)\n"
            + "宽度：\(myAsset.pixelWidth)px\n"
            + "高度：\(myAsset.pixelHeight)px\n"
            + "位置：\(myAsset.location)\n"

        
        //获取原图
        PHImageManager.default().requestImage(for: myAsset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, imageDic) in
              self.imageView.image = image
        }
        
        view.addSubview(textView)
        view.addSubview(imageView)
    }
    
    //MARK: 懒加载UITextView
    fileprivate lazy var textView: UITextView = {
        let textV = UITextView(frame: .zero)
        textV.textColor = .black
        textV.font = UIFont.systemFont(ofSize: 17)
        textV.layer.masksToBounds = true
        textV.contentMode = .scaleAspectFill
        //textV.isEditable = false
        return textV
    }()
    
    //MARK: 懒加载UIImageView
    fileprivate lazy var imageView: UIImageView = {
        let imgV = UIImageView(frame: .zero)
        imgV.layer.masksToBounds = true
        imgV.contentMode = .scaleAspectFill
        imgV.backgroundColor = .cyan
        return imgV
    }()
    
    override func viewDidLayoutSubviews() {
        imageView.frame = CGRect(x: (SCREEN_WIDTH - 250)/2,y: 100 , width:250, height:250)
        
        textView.frame = CGRect(x: 50,y: SCREEN_HEIGHT/2, width:SCREEN_WIDTH - 40, height: SCREEN_HEIGHT/2)
    }

}

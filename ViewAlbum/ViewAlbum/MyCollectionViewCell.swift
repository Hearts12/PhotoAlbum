//
//  MyCollectionViewCell.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/5.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    let selectButton = UIButton()
    let imageView = UIImageView()
    
    //  cell 是否被选择
    var isChoose = false {
        didSet {
            selectButton.isSelected = isChoose
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //  展示图片
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.backgroundColor = .cyan
        
        //  展示图片选择图标
        selectButton.frame = CGRect(x: contentView.bounds.size.width * 3 / 4 - 2, y: 2,  width: contentView.bounds.size.width / 4 , height: contentView.bounds.size.width / 4)
        selectButton.setBackgroundImage(UIImage.init(named: "iw_unselected"), for: .normal)
        selectButton.setBackgroundImage(UIImage.init(named: "iw_selected"), for: .selected)
        imageView.addSubview(selectButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

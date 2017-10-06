//
//  BTAllPhotosController.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/6.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit
import Photos

class BTAllPhotosController: BTBaseViewController {
    
    var photoColl: PHAssetCollection? {
        
        didSet{
            
            guard photoColl != nil else {
                print("photoColl == nil")
                return
            }
            
            self.title = photoColl!.localizedTitle?.chinese()
            
            DispatchQueue.global().async(execute: {
                
                let fetchResult = PHAsset.fetchAssets(in: self.photoColl!, options: nil)
                
                fetchResult.enumerateObjects({ (asset, index, stop) in
                    
                    let model = picture()
                    
                    model.asset = asset
                    
                    self.photos.append(model)
                    
                })
                
                //每个图片设置一个初始标识符,数量和数据源数组的count保持一致，里面都是一些0，1标识，其中0代表未选择，1代表选择
                for _ in 0 ..< self.photos.count {
                    self.divideArray.append(0)
                }
            })
        }
    }
    
    // 已选图片数组，数据类型是 PHAsset
    fileprivate lazy var seletedPhotosArray: [PHAsset] = {
        let arr = [PHAsset]()
        return arr
    }()
    
    // 解决由于cell复用图片重复选择的问题
    fileprivate lazy var divideArray: [Int] = {
        let arr = [Int]()
        return arr
    }()
    
    fileprivate lazy var photos: [picture] = {
        let array = [picture]()
        return array
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 1. 添加collectionView
        setUpCollection()
        
        self.showCancleBtn()
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 5
        let cellWidth: CGFloat = (SCREEN_WIDTH - 5 * shape) / 4
        flowLayout.sectionInset = UIEdgeInsetsMake(0, shape, 0, shape)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionview.backgroundColor = UIColor.white
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
        
    }()
    
    //MARK: 底部View，点击选择完成
    fileprivate lazy var completedButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        btn.addTarget(self, action: #selector(completedBtnClick), for: .touchUpInside)
        return btn
    }()
    
    //MARK: 图片选择后点击完成按钮要做的动作
    @objc fileprivate func completedBtnClick(){
       
    }
    
    fileprivate lazy var overLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "完成"
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    fileprivate lazy var countLable: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .purple
        label.textColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = COUNTlABLEWH / 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19)
        return label
    }()
    
    //MARK: 页面添加collection
    fileprivate func setUpCollection() {
        
        self.view.backgroundColor = UIColor.white
        
        self.collectionView.register(BTCollectionViewCell.self, forCellWithReuseIdentifier: BTCollectionViewCellReuseIdentifier)
        
        view.addSubview(self.collectionView)
        view.addSubview(self.completedButton)
        self.completedButton.addSubview(self.overLabel)
        self.completedButton.addSubview(self.countLable)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = CGRect(x: 0, y: HEARERHEIGHT, width: self.view.BT_W, height: self.view.BT_H - HEARERHEIGHT)
        
        completedButton.frame = CGRect(x: 0, y:self.view.BT_H - HEARERHEIGHT, width: self.view.BT_W, height: HEARERHEIGHT)
        
        overLabel.frame = CGRect(x: self.view.BT_W / 2 + 8, y: 0, width: 40, height: HEARERHEIGHT)
        
        countLable.frame = CGRect(x: self.view.BT_W / 2 - 30, y: 10, width: COUNTlABLEWH, height: COUNTlABLEWH)
    }
}


extension BTAllPhotosController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    //#MARK: 代理和数据源
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BTCollectionViewCellReuseIdentifier, for: indexPath) as! BTCollectionViewCell
        
        cell.model = self.photos[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let currentCell = collectionView.cellForItem(at: indexPath) as! BTCollectionViewCell
        if seletedPhotosArray.count >= BT_MAX_SELECTED_PHOTO_COUNT && !currentCell.isChoose{
            
            let alterVc = UIAlertController(title: nil, message: "选择的图片数不能超过\(BT_MAX_SELECTED_PHOTO_COUNT)张", preferredStyle: .alert)
            
            let cancleAction = UIAlertAction(title: "宝宝知道了", style: .cancel) { (action) in
                print(action.title ?? "标题")
            }
            
            alterVc.addAction(cancleAction)
            
            self.present(alterVc, animated: true, completion: nil)
            
            return
        }
        currentCell.isChoose = !currentCell.isChoose
        
        let model:picture = self.photos[indexPath.row]
        //解决单元格复用导致统计选择图片的个数问题
        if currentCell.isChoose {
            divideArray[indexPath.row] = 1
            if !seletedPhotosArray.contains(model.asset!) {
                seletedPhotosArray.append(model.asset!)
            }
        }else{
            divideArray[indexPath.row] = 0
            if seletedPhotosArray.contains(model.asset!) {
                for (index, value) in seletedPhotosArray.enumerated() {
                    if value == model.asset! {
                        seletedPhotosArray.remove(at: index)
                    }
                }
            }
        }
        completedButtonShow()
    }
    
    //  MARK:- 展示和点击完成按钮
    func completedButtonShow() {
        var originY: CGFloat
        
        if seletedPhotosArray.count > 0 {
            originY = self.view.BT_H - 44
        } else {
            originY = self.view.BT_H
        }
        
        UIView.animate(withDuration: 0.2) {
            self.completedButton.frame.origin.y = originY
            self.countLable.text = String(self.seletedPhotosArray.count)
        }
    }
}

class BTCollectionViewCell: UICollectionViewCell {
    
    fileprivate var imageSize: CGSize?
    var indexPath: IndexPath?
    
    //cell是否被选择
    var isChoose = false {
        didSet {
            self.selectButton.isSelected = isChoose
        }
    }

    weak var model:picture? {
        
        didSet {
            
            guard model != nil else {
                return
            }
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .fast
            
            PHImageManager.default().requestImage(for: model!.asset!, targetSize:imageSize! , contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, imageDic) in
                
                self.imageView.image = image ?? UIImage.init(named: "iw_none")
      
            })
        }
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageSize = self.contentView.bounds.size
        contentView.addSubview(self.imageView)
        self.imageView.addSubview(self.selectButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = contentView.bounds
        self.selectButton.frame = CGRect(x: imageSize!.width * 3 / 4 - 2, y: 2,  width: imageSize!.width / 4 , height: imageSize!.width / 4)
    }
    
    //MARK: 懒加载imageView
    fileprivate lazy var imageView: UIImageView = {
        let icon = UIImageView(frame: .zero)
        icon.layer.masksToBounds = true
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = .cyan
        return icon
    }()
    
    //MARK: 懒加载selectButton
    fileprivate lazy var selectButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setBackgroundImage(UIImage.init(named: "disSelect"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "selected"), for: .selected)
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class picture: NSObject {
    
    var asset: PHAsset?
    /// 是否选中
    var isSelect: Bool = false
    
}


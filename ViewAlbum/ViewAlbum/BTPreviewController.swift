//
//  BTPreviewController.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/7.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit
import Photos

class BTPreviewController: BTBaseViewController {

    var selectPhotos: [PHAsset]? {
        
        didSet{
            guard (selectPhotos?.count)! > 0 else {
                print("selectPhotos == nil")
                return
            }
        }
    }
    
    //#MARK: viewDidLoad
    override func viewDidLoad() {
        setUpCollection()
        showCancleBtn()
    }
    
    //#MARK: collectionView
    fileprivate lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 10
        let cellWidth: CGFloat = (SCREEN_WIDTH - 5 * shape) / 2
        flowLayout.sectionInset = UIEdgeInsetsMake(0, shape, 0, shape)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        
        let collectionview = UICollectionView(frame: CGRect(x: 0, y: HEARERHEIGHT, width: self.view.BT_W, height: self.view.BT_H - HEARERHEIGHT), collectionViewLayout: flowLayout)
        
        collectionview.backgroundColor = UIColor.white
        collectionview.delegate = self
        collectionview.dataSource = self
        return collectionview
        
    }()
    
    fileprivate func setUpCollection() {
        
        self.view.backgroundColor = UIColor.white
        self.title = "所选图片"
        self.collectionView.register(BTPreviewCollectionCell.self, forCellWithReuseIdentifier: BTPreViewCellReuseIdentifier)
        view.addSubview(self.collectionView)

    }
    
    override var prefersStatusBarHidden: Bool {
        return (self.navigationController?.navigationBar.isHidden)!
    }
}


extension BTPreviewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //#MARK: UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectPhotos!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BTPreViewCellReuseIdentifier, for: indexPath) as! BTPreviewCollectionCell
        cell.photos = self.selectPhotos?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("选择了单元格")
        let myAsset =  self.selectPhotos![indexPath.row] 
        
        let detailVC: BTDetailViewController = BTDetailViewController()
        detailVC.myAsset = myAsset
        
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
}


//MARK: BTPreviewCollectionCell
class BTPreviewCollectionCell: UICollectionViewCell {
    
    fileprivate var imageSize: CGSize?
    var indexPath: IndexPath?
    
    var photos: PHAsset?{
        
        didSet {
            
            guard photos != nil  else {
                return
            }
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .fast
            
            PHImageManager.default().requestImage(for: photos!, targetSize:imageSize! , contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, imageDic) in
                
                self.imageView.image = image ?? UIImage.init(named: "iw_none")
                
            })
        }
        
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageSize = self.contentView.bounds.size
        contentView.addSubview(self.imageView)
    }

    //MARK: 懒加载imageView
    fileprivate lazy var imageView: UIImageView = {
        let icon = UIImageView(frame: self.contentView.bounds)
        icon.layer.masksToBounds = true
        icon.contentMode = .scaleAspectFill
        icon.backgroundColor = .cyan
        return icon
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

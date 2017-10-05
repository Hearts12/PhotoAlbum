//
//  AllPhotosViewController.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/5.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit
import Photos

class AllPhotosViewController: UIViewController , PHPhotoLibraryChangeObserver, UICollectionViewDelegate, UICollectionViewDataSource{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //  添加顶部、底部视图
        addHeaderViewAndBottomView()
        //  添加collectionView
        createCollectionView()
        
        //  获取全部图片
        getAllPhotos()
        
        }
    //获取屏幕宽度
    private var SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
    private var SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
    
    private let headerView = UIView()
    private var headerHeight:CGFloat = 50
    
    private let completedButton = UIButton()
    //  已选择图片数量
    private let countLable = UILabel()
    
    
    //  载体
    private var myCollectionView: UICollectionView!
    //  collectionView 布局
    private let flowLayout = UICollectionViewFlowLayout()
    //  collectionviewcell 复用标识
    private let cellIdentifier = "myCell"
    //  数据源
    private var photosArray = PHFetchResult<AnyObject>()
    //  已选图片数组，数据类型是 PHAsset
    private var seletedPhotosArray = [PHAsset]()
    
    
    //添加头view和底view的方法
    private func addHeaderViewAndBottomView()  {
        //添加头
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerHeight)
        headerView.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
        view.addSubview(headerView)
        
        //添加返回按钮
        let backButton = UIButton()
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        backButton.setTitle("取消", for: .normal)
        backButton.center = CGPoint(x:SCREEN_WIDTH - 40, y:headerHeight / 1.5)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.addTarget(self, action: #selector(AllPhotosViewController.dismissAction), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        let titleLable = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 2, height: headerHeight))
        titleLable.text = "全部图片"
        titleLable.textColor = .white
        titleLable.font = UIFont.systemFont(ofSize: 19)
        titleLable.textAlignment = .center
        titleLable.center = CGPoint(x: SCREEN_WIDTH / 2, y: headerHeight / 1.5)
        headerView.addSubview(titleLable)
    
        //  底部View，点击选择完成
        completedButton.frame = CGRect(x: 0, y:SCREEN_HEIGHT - 44, width: SCREEN_WIDTH, height: 44)
        completedButton.backgroundColor = UIColor.init(white: 0.8, alpha: 1)
        view.addSubview(completedButton)
        
        let overLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH / 2 + 8, y: 0, width: 40, height: 44))
        overLabel.text = "完成"
        overLabel.textColor = .blue
        overLabel.font = UIFont.systemFont(ofSize: 18)
        completedButton.addSubview(overLabel)
        
        countLable.frame = CGRect(x: SCREEN_WIDTH / 2 - 25, y: 10, width: 24, height: 24)
        countLable.backgroundColor = .green
        countLable.textColor = .white
        countLable.layer.masksToBounds = true
        countLable.layer.cornerRadius = countLable.bounds.size.height / 2
        countLable.textAlignment = .center
        countLable.font = UIFont.systemFont(ofSize: 19)
        completedButton.addSubview(countLable)
    }
    
    func dismissAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK：-获取全部图片
    private func getAllPhotos(){
        PHPhotoLibrary.shared().register(self)
        
        let allOptions = PHFetchOptions()
        
        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let allResults = PHAsset.fetchAssets(with: allOptions)
        photosArray = allResults as! PHFetchResult<AnyObject>
        
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange){
        getAllPhotos()
    }
    
    //MARK：-添加collectionView
    private func createCollectionView(){
        // 竖屏时每行显示4张图片
        let shape: CGFloat = 5
        let cellWidth: CGFloat = (SCREEN_WIDTH - 5 * shape) / 4
        flowLayout.sectionInset = UIEdgeInsetsMake(0, shape, 0, shape)
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        //  collectionView
        myCollectionView = UICollectionView(frame: CGRect(x: 0, y: headerHeight + 1, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 2 * headerHeight), collectionViewLayout: flowLayout)
        myCollectionView.backgroundColor = .white
        //  添加协议方法
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        //  设置 cell
        myCollectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(myCollectionView)
    }
    
    //  collectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! MyCollectionViewCell
        
        //展示图片
        PHCachingImageManager.default().requestImage(for: photosArray[indexPath.row] as! PHAsset, targetSize: CGSize.zero, contentMode: .aspectFit, options: nil) { (result: UIImage?, dictionry: Dictionary?) in
            cell.imageView.image = result ?? UIImage.init(named: "iw_none")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("进入这个方法了")
        let currentCell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        currentCell.isChoose = !currentCell.isChoose
        seletedPhotosArray.append(photosArray[indexPath.row] as! PHAsset)
        completedButtonShow()
    }
    
    //  MARK:- 展示和点击完成按钮
    func completedButtonShow() {
        var originY: CGFloat
        
        if seletedPhotosArray.count > 0 {
            originY = SCREEN_HEIGHT - 44
            flowLayout.sectionInset.bottom = 44
        } else {
            originY = SCREEN_HEIGHT
            flowLayout.sectionInset.bottom = 0
        }
        
        UIView.animate(withDuration: 0.2) { 
            self.completedButton.frame.origin.y = originY
            self.countLable.text = String(self.seletedPhotosArray.count)
            
            UIView.animate(withDuration: 0.2, animations: { 
                self.countLable.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
            })
        }
       
    }
}

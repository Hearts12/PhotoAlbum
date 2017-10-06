//
//  BTViewAlbum.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/6.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit
import Photos


//MARK: BTViewAlbum类
class BTViewAlbum: BTBaseViewController {
    override func viewDidLoad() {
        
        //1. 设置默认属性
        setDefault()
        
        //2. 添加TableView
        self.tableView.register(BTPhotoBrowserCell.self, forCellReuseIdentifier: BTTableViewCellReuseIdentifier)
        self.view.addSubview(self.tableView)
        
        //3. 获取photo
        getPhotos()
        
        self.showCancleBtn()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.frame = self.view.bounds
    }
    
    func setDefault() {
        view.backgroundColor = UIColor.white
        title = "手机相薄"
    }
    
    //#MARK: 懒加载
    fileprivate lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.tableFooterView = UIView()
        tableview.delegate = self
        tableview.dataSource = self
        
        return tableview
    }()
    
    //#MARK: 懒加载
    fileprivate lazy var photoArray: [BTPhotoDataModel] = {
       let arr = [BTPhotoDataModel]()
       return arr
    }()
    
    //#MARK: 获取系统相册资源
    func getPhotos() {
        
        PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
            if status == .notDetermined{
               print("NotDetermined")
            }else if status == .authorized{
              
                DispatchQueue.global().async(execute: { 
                    
                    //相机胶卷
                    let cameraRoll: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                    
                    cameraRoll.enumerateObjects({ (object, index, stop) in
                        let model = BTPhotoDataModel.init(object)
                        if model.collTitle == "相机胶卷"{
                           self.photoArray.insert(model, at: 0)
                        }else{
                           self.photoArray.append(model)
                        }
                    })
                    
                    let newRoll: PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                    newRoll.enumerateObjects({ (object, index, stop) in
                        let model = BTPhotoDataModel.init(object)
                        self.photoArray.append(model)
                    })
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                })
    
            }else if status == .restricted {
                print("Restricted")
            }else if status == .denied {
                print("没有获取到用户授权")
                
                DispatchQueue.main.async {
                    
                    self.authorLable.text = "请在iPhone的\"设置-隐私-照片\"选项中，\n允许访问你的手机相册。"
                    self.view.addSubview(self.authorLable)
                    
                }
                
            }
        }
    }
}

//MARK: 自定义tableView的代理和数据源方法
extension BTViewAlbum: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BTTableViewCellReuseIdentifier, for: indexPath) as! BTPhotoBrowserCell
        cell.model = self.photoArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.photoArray[indexPath.row]
        
        /*let photoVC = BTPhotosController(delegate: self.delegate!)
        photoVC.photoColl = model.photoColl*/
        
        let photoVC = BTAllPhotosController(delegate: self.delegate!)
        photoVC.photoColl = model.photoColl
        
        self.navigationController?.pushViewController(photoVC, animated: true)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BTPhotoCollTableViewCell_Height
    }
}

//MARK: 导航控制器
class BTNavgationBrowser: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.tintColor = BTNavgation_tintColor
        self.navigationBar.barTintColor = BTNavgation_barTintColor
        self.navigationBar.titleTextAttributes = BTNavgation_titleTextAttributes
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

//MARK: 协议
@objc protocol BTBaseViewControllerDelegate: NSObjectProtocol{

}


private extension Selector{
    static let rightBarButtonCancleChick = #selector(BTViewAlbum.cancle)
}
//MARK: 基类
class  BTBaseViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    weak var delegate: BTBaseViewControllerDelegate?
    
    //便利构造器
    convenience init(delegate: BTBaseViewControllerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func showCancleBtn(){
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.done, target: self, action: .rightBarButtonCancleChick)
    }
    
    func cancle() {
       // self.delegate?.baseViewcontroller?(didCancle: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 懒加载
    lazy var authorLable: UILabel = {
        let deniedLable = UILabel(frame: CGRect(x: 0, y: 84, width: self.view.BT_X, height: 44))
        deniedLable.numberOfLines = 0
        deniedLable.textAlignment = .center
        deniedLable.textColor = UIColor.black
        return deniedLable
        
    }()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}

//MARK: 相册分类列表
class BTPhotoBrowserCell: UITableViewCell {
    var model: BTPhotoDataModel? {
        
        didSet {
            
            if let getModel = model {
                
                iconImageView.image = getModel.collLastImg
                title.text = getModel.collTitle
                subtitle.text = "\(getModel.collImageCount)" + "张照片"
            }
            
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.BT_X = 5
        iconImageView.frame.size = CGSize(width: 50, height: 50)
        iconImageView.BT_centerY = self.contentView.BT_centerY
        
        title.sizeToFit()
        title.BT_X = self.iconImageView.frame.maxX + 15
        title.BT_centerY = self.iconImageView.BT_centerY
        
        subtitle.sizeToFit()
        subtitle.BT_X = self.title.frame.maxX + 10
        subtitle.BT_centerY = self.title.BT_centerY
        
    }
    //FIXME: 修改frame
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(iconImageView)
        self.contentView.addSubview(title)
        self.contentView.addSubview(subtitle)
        
        
    }
    //MARK: getter 设置cell子视图
    fileprivate lazy var iconImageView: UIImageView = {
        
        let icon = UIImageView()
        
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        return icon
        
    }()
    fileprivate lazy var title: UILabel = {
        
        let leftTitle = UILabel()
        
        leftTitle.textColor = BTPhotoCollTableViewCell_TitleColor
        leftTitle.font = BTPhotoCollTableViewCell_TitleFont
        
        return leftTitle
        
    }()
    
    fileprivate lazy var subtitle: UILabel = {
        
        let rightTitle = UILabel()
        
        rightTitle.textColor = BTPhotoCollTableViewCell_SubtitleColor
        rightTitle.font = BTPhotoCollTableViewCell_SubtitleFont
        
        return rightTitle
        
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: 相册数据模型
class BTPhotoDataModel: NSObject{
    var photoColl: PHAssetCollection?
    var collTitle: String?
    var collLastImg: UIImage?
    var collImageCount: Int = 0
    
    convenience init(_ assetResult: PHAssetCollection) {
        self.init()
        
        let result = PHAsset.fetchAssets(in: assetResult, options: nil)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .fast
        
        if let asset = result.lastObject {
            
            PHImageManager.default().requestImage(for: asset, targetSize:BTPhotoCollTableViewCell_ImageSize , contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, imageDic) in
                
                self.collLastImg = image
                
            })
            
        }else{
            
            self.collLastImg = BTPhotoCollTableViewCell_Image
            
        }
        self.collImageCount = result.countOfAssets(with: .image)
        self.collTitle = assetResult.localizedTitle?.chinese()
        self.photoColl = assetResult
    }
}



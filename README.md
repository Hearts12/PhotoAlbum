# PhotoAlbum
### 项目使用 <Photos.framework>，使用iOS8.0及以上
### 项目地址链接：[github](https://github.com/Hearts12/PhotoAlbum.git)

---

**注：由于以前学习的是Objective-C语言，对swift语言了解甚少，做这个项目时才开始学习swift语言，所以有些优化或是高级语法未能灵活应用，如果有什么需要优化或者不妥的地方，希望可以能够得到指导，谢谢**

---

**工程目录文件**



### 1. config.swift文件

* 该文件主要存放项目中用到的一些常用变量，便于修改
* 封装了相册英文名称对应的中文名（由于获取到的系统相册的名称是英文，因此通过编写String的扩展）
* 封装了UIView便捷获取frame/size/center的方法

### 2.ViewController.swift
**主要实现：获取系统相册资源的入口按钮，点击触发事件**


### 3.BTViewAlbum.swift

**主要实现：系统相册资源分类列表显示**

* BTBaseViewController: 封装基类，本项目所有ViewController都继承于该类，主要封装了使用基类协议便利初始化方法，导航栏取消按钮的实现逻辑等
* BTPhotoDataModel： 相册数据模型，PHAssetCollection数据集的数据封装为模
* 获取相册资源主要代码
`    
 
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
    
    `
    
    
* 使用自定义tableView显示数据

### 4.  BTAllPhotosController.swift，继承于BTBaseViewController基类
**主要实现：相册中某一分类图片的显示，并实现选择一定量的图片**
* 使用CollectionView显示图片
* 选择结束完成按钮的实现：主要实现界面跳转，并将所选图片显示出来，以便查看图片详细信息






//
//  config.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/6.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit

//MARK: 导航栏
let BTNavgation_tintColor = UIColor.white
let BTNavgation_barTintColor = UIColor.black
let BTNavgation_titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]


//MARK: TableViewCell
let BTTableViewCellReuseIdentifier = "tableViewCellID"
let BTCollectionViewCellReuseIdentifier = "collectionViewCellID"


let SCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.main.bounds.size.height
let HEARERHEIGHT:CGFloat = 50
let COUNTlABLEWH:CGFloat = 24
let BT_MAX_SELECTED_PHOTO_COUNT = 4

//MARK: 相册分类界面
let BTPhotoCollTableViewCell_ImageSize = CGSize(width: 50, height: 50)
let BTPhotoCollTableViewCell_Image = UIImage(named: "plc_icon")
let BTPhotoCollTableViewCell_TitleColor = UIColor ( red: 0.5333, green: 0.5333, blue: 0.5333, alpha: 1.0 )
let BTPhotoCollTableViewCell_TitleFont = UIFont.systemFont(ofSize: 17)
let BTPhotoCollTableViewCell_SubtitleColor = UIColor ( red: 0.8637, green: 0.8637, blue: 0.8637, alpha: 1.0 )
let BTPhotoCollTableViewCell_SubtitleFont = UIFont.systemFont(ofSize: 14)
let BTPhotoCollTableViewCell_Height: CGFloat = 66


//MARK: 照片缩略图界面
let HBPhotos_select_YES_Icon = UIImage(named: "seleced")
let HBPhotos_select_NO_Icon = UIImage(named: "disSelect")

//MARK: UI 设置 ------------------ END
let KEY_HB_ORIGINIMAGE = "KEY_HB_ORIGINIMAGE"

func color(_ r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return color_a(r: r, g: g, b: b, a: 1)
}
func color_a(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

//MARK:  相册英文名称对应的中文  Returns: String
extension String {
    
    func chinese() -> String {
        
        var name: String = ""
        
        switch self {
        case "Slo-mo":
            name = "慢动作"
        case "Recently Added":
            name = "最近添加"
        case "Favorites":
            name = "个人收藏"
        case "Recently Deleted":
            name = "最近删除"
        case "Videos":
            name = "视频"
        case "All Photos":
            name = "所有照片"
        case "Selfies":
            name = "自拍"
        case "Screenshots":
            name = "屏幕快照"
        case "Camera Roll":
            name = "相机胶卷"
        case "Panoramas":
            name = "全景照片"
        case "Hidden":
            name = "已隐藏"
        case "Time-lapse":
            name = "延时拍摄"
        case "Bursts":
            name = "连拍快照"
        case "Depth Effect":
            name = "景深效果"
        default:
            name = self
        }
        return name
    }
}

extension UIView {
    
    var BT_X: CGFloat {
        
        get{
            return self.frame.origin.x
        }
        set{
            var originRect = self.frame
            originRect.origin.x = newValue
            self.frame = originRect
        }
        
    }
    var BT_Y: CGFloat {
        
        get{
            return self.frame.origin.y
        }
        set{
            var originRect = self.frame
            originRect.origin.y = newValue
            self.frame = originRect
        }
        
    }
    var BT_W: CGFloat {
        
        get{
            return self.frame.size.width
        }
        set{
            var originRect = self.frame
            originRect.size.width = newValue
            self.frame = originRect
        }
        
    }
    var BT_H: CGFloat {
        
        get{
            return self.frame.size.height
        }
        set{
            var originRect = self.frame
            originRect.size.height = newValue
            self.frame = originRect
        }
        
    }
    var BT_centerX: CGFloat {
        
        get{
            return self.center.x
        }
        set{
            var originCenter = self.center
            originCenter.x = newValue
            self.center = originCenter
        }
        
    }
    var BT_centerY: CGFloat {
        
        get{
            return self.center.y
        }
        set{
            var originCenter = self.center
            originCenter.y = newValue
            self.center = originCenter
        }
        
    }
    var BT_center: CGPoint {
        
        get{
            return self.center
        }
        set{
            self.center = newValue
        }
        
    }
    
    
    func BT_starBoundsAnimation() {
        
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { (Finished) in
            UIView.animate(withDuration: 0.15, animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        })
    }
}

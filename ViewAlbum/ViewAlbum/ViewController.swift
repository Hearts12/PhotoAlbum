//
//  ViewController.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/5.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BTBaseViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //按钮事件
    @IBAction func btnClick(_ sender: UIButton) {
        //跳转页面
     
        let rootVC = BTViewAlbum(delegate: self)
        let nav = BTNavgationBrowser(rootViewController: rootVC)
        
        self.present(nav, animated: true, completion: nil)
    }
}

/*extension ViewController: BTBaseViewControllerDelegate{


}*/


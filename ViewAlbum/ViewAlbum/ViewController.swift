//
//  ViewController.swift
//  ViewAlbum
//
//  Created by mjl on 17/10/5.
//  Copyright © 2017年 bigtree. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //按钮事件
    @IBAction func btnClick(sender: UIButton) {
        //跳转页面
        let photosVC  = AllPhotosViewController()
        present(photosVC, animated: true, completion: nil)
    }

}


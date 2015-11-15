//
//  UserQrcodeViewController.swift
//
//  Created by midoks on 15/8/24.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import AVFoundation

class UserQrcodeViewController: UIViewController{

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1)
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("close:"))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        
//        self.title = "生成二维码"
//        let mkQrcode = MDQrcodeMakeViewController()
//        self.navigationController?.pushViewController(mkQrcode, animated: true)
        
        
        self.title = "二维码识别"
        let rdQrcode = MDQrcodeReaderViewViewController()
        self.navigationController?.pushViewController(rdQrcode, animated: true)


    }
    
    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            print("close")
        }
    }
    
    

}

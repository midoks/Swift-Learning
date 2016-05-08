//
//  MDQrcodeMakeViewController.swift
//
//  Created by midoks on 15/11/14.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import Foundation


class MDQrcodeMakeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MDQrcodeMakeViewController.close(_:)))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        let sQrcode = CGSize(width: 260, height: 260)
        let imageQrcode = UIImageView(frame: CGRectMake(view.center.x - sQrcode.width/2, view.center.y - sQrcode.width/2, sQrcode.width, sQrcode.height))
        imageQrcode.image = MDQrcodeMake.createQrcode("dd", qrImageName: "tabbar_me")
        self.view.addSubview(imageQrcode)
    }
    
    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
}
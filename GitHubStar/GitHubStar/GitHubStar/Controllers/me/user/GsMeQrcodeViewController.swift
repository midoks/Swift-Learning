//
//  GsMeQrcodeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/2/6.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsMeQrcodeViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "QR Code")
        self.view.backgroundColor = UIColor.gray
        
        self.asynTask { 
            self.initView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initView(){
        let w = self.view.frame.width
        let h = self.view.frame.height
        
        self.view.frame = CGRect(x:100, y:100, width:w * 0.9, height:h * 0.6)
        
        
        
        
        let viewBack = UIView(frame: CGRect(x: 100, y: 100, width: w * 0.95, height: h * 0.7))
        viewBack.center = self.view.center
        viewBack.backgroundColor = UIColor.white
        viewBack.layer.cornerRadius = 5
        self.view.addSubview(viewBack)
        
        
        let sQrcode = CGSize(width: 200, height: 200)
        let imageQrcode = UIImageView(frame: CGRect(x: view.center.x - sQrcode.width/2, y: view.center.y - sQrcode.width/2, width: sQrcode.width, height: sQrcode.height))
        
        let url = self.getQrcodeUrlValue()
        let icon = self.getQrcodeImageValue()
        imageQrcode.image = MDQrcodeMake.createQrcode(qrString: url, qrImageName: icon)
        imageQrcode.layer.cornerRadius = 10
        self.view.addSubview(imageQrcode)
    }
    
    //MARK: - Private Methods -
    //获取二维码的URL值
    func getQrcodeUrlValue() -> String {
//        let selectUser = UserModelList.instance().selectCurrentUser()
//        let u = JSON.parse(selectUser["info"] as! String)
//        let t = NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
//        let url = u["html_url"].stringValue + "?app=GitHubStar&t=" + String(t)
        
        let url = "http://baidu.com"
        
        //print(url)
        return url
    }
    
    //获取头像图片的位置
    func getQrcodeImageValue() -> String {
        let selectUser = UserModelList.instance().selectCurrentUser()
        let u = JSON.parse(selectUser["info"] as! String)
        let avatar_url  = u["avatar_url"].stringValue
        
        let r_avatar_url = MDCacheImageCenter.getFullCachePathFromUrl(url: avatar_url)
        //print(r_avatar_url)
        return r_avatar_url
    }
    
}

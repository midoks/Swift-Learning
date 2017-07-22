//
//  SystemSettingPage.swift
//  GitHubStar
//
//  Created by midoks on 16/1/9.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class SystemSettingPage {
    
    private static func base(url:NSURL){
        if UIApplication.shared.canOpenURL(url as URL) {
            print(url)
            UIApplication.shared.openURL(url as URL)
        }
    }
    
    //定位服务设置页面
    static func goLocationServices(){
        let url = NSURL(string: "prefs:root=LOCATION_SERVICES")
        base(url: url!)
    }
    
    //FaceTime设置界面
    static func goFaceTime(){
        let url = NSURL(string: "prefs:root=FACETIME")
        base(url: url!)
    }
    
    //邮件设置
    static func goMail(){
        let url = NSURL(string: "prefs:root=MAIL")
        base(url: url!)
    }

}

//
//  mUser.swift
//
//  Created by midoks on 15/7/26.
//  Copyright © 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit

class mUserTools: NSObject {
    
    static var defaults    = NSUserDefaults(suiteName: "loginToken")
    
    //判断值
    static func setValue(key:String, name:String){
        defaults!.setObject(name, forKey: key)
    }
    
    //判断是否登录
    static func isLogin()->Bool{
        let userToken = defaults!.objectForKey("username")
        if( userToken != nil && !userToken!.isEqual("")){
            return true
        }
        return false
    }
    
    static func loginOut()->Bool{
        defaults!.removeObjectForKey("username")
        return true
    }
    
    
    
}

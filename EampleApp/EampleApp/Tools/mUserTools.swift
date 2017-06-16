//
//  mUser.swift
//
//  Created by midoks on 15/7/26.
//  Copyright © 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit

class mUserTools: NSObject {
    
    static var defaults    = UserDefaults(suiteName: "loginToken")
    
    //判断值
    static func setValue(_ key:String, name:String){
        defaults!.set(name, forKey: key)
    }
    
    //判断是否登录
    static func isLogin()->Bool{
        let userToken = defaults!.object(forKey: "username")
        if( userToken != nil && !(userToken! as AnyObject).isEqual("")){
            return true
        }
        return false
    }
    
    static func loginOut()->Bool{
        defaults!.removeObject(forKey: "username")
        return true
    }
    
    
    
}

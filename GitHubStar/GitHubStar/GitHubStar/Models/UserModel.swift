//
//  UserModel.swift
//  GitHubStar
//
//  Created by midoks on 2017/6/19.
//  Copyright © 2017年 midoks. All rights reserved.
//

import UIKit

class UserModel: NSObject, NSCoding {
    
    var id:Int64
    var user:String
    var token:String
    var info:String
    var main:Int64

    
    required init?(coder aDecoder: NSCoder) {
        
        //super.init()
        
        id = aDecoder.decodeInt64(forKey: "id")
        user = aDecoder.decodeObject(forKey: "user") as! String
        token = aDecoder.decodeObject(forKey: "token") as! String
        info = aDecoder.decodeObject(forKey: "token") as! String
        main = aDecoder.decodeInt64(forKey: "main")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(info, forKey: "info")
        aCoder.encode(main, forKey: "main")
    }

}

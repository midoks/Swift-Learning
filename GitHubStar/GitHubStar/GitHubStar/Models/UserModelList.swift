

//
//  UserModel.swift
//  GitHubStar
//
//  Created by midoks on 15/12/1.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class UserModelList: NSObject, NSCoding {
    
    var list:[UserModel] = [UserModel]()
    
    private static var dbInstance:UserModelList?
    
    override init() {
        super.init();
    }
    
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        list = aDecoder.decodeObject(forKey: "list") as! [UserModel]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(list, forKey: "list")
    }
    
    //Mark: - 实例化 -
    static func instance() -> UserModelList {
        if((dbInstance == nil)){
            dbInstance = UserModelList()
        }
        return dbInstance!
    }
    

    //判断是否登录
    func isLogin() -> Bool {
        print(list.count)
        if( list.count > 0 ){
            return true
        }
        return false
    }
    
    //添加用户
    func addUser(userName:String, token:String) -> Bool {
        
        
        return false
    }

    //删除用户
    func deleteUser(userName:String) -> Bool {
  
        return false
    }
    
    //通过ID删除用户
    func deleteUserById(id:Int) -> Bool {
  
        return false
    }

   //删除主要用户
    func deleteMainUser() -> Bool {
        return false
    }

    //用户的Token
    func updateUser(userName:String, token:String) -> Bool {

        return false
    }
    
    
    func updateMainUserById(id:Int) -> Bool {
        let ret = false
        
        return ret
    }
 
    //更新用户数据信息
    func updateInfo(info:String, token: String) -> Bool{
   
        return false
    }
    
    //更新数据
    func updateInfoById(info:String, id: Int) -> Bool{
        return false
    }

    //查询指定用户
    func selectUser(userName:String) -> AnyObject {

        return false as AnyObject
    }
    
    //查询所有用户
    func selectAllUser() -> AnyObject {
        return false as AnyObject
    }
    
    //查询当前数据
    func selectCurrentUser() -> AnyObject {
        
        
        for i in list {
            print(i)
        }
        
  
        return false as AnyObject
    }
    

}

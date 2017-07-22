//
//  Created by midoks on 15/11/26.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - 公用的方法 -
    //- 获取当前的视图 -
    public func getRootVC() -> UIViewController {
        let window = UIApplication.shared.keyWindow
        return (window?.rootViewController)!
    }
    
    //- 通过颜色生成图片 -
    public func imageWithColor(color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fillEllipse(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //异步执行
    public func asynTask(callback:@escaping ()->Void){
        DispatchQueue.main.async {
            callback()
        }
    }
    
    //异步更新UI
    public func asynTaskUI(callback:@escaping ()->Void){
        DispatchQueue.main.async { 
            callback()
        }
    }
    
    //跳转
    public func push(v:UIViewController){
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    //弹出
    public func pop(){
        self.navigationController!.popViewController(animated: true)
    }
    
    //清除cookie
    public func clearCookie(){
        let c = HTTPCookieStorage.shared
        let a = c.cookies
        for i in a! {
            c.deleteCookie(i)
        }
    }
    
    //MARK: - 用户相关操作 -
    
    func isLogin() -> Bool {
        return UserModelList.instance().isLogin()
    }
    
    func getUser() -> AnyObject{
       return UserModelList.instance().selectCurrentUser()
    }
    
    //获取当前用登录的用户名
    func getUserName() -> String {
        let userInfo = UserModelList.instance().selectCurrentUser()
        let userName = userInfo["user"] as! String
        return userName
    }
    
    func getUserToken() -> String {
        let userInfo = UserModelList.instance().selectCurrentUser()
        let token = userInfo["token"] as! String
        return token
    }
    
}


func sysLang(key:String) -> String {
    let v = MDLangLocalizable.singleton().stringWithKey(key: key)
    if v == "" {
        return key
    }
    return v
}
//MARK: - 系统语言相关 -
extension UIViewController{
    func sysLang(key:String) -> String {
        let v = MDLangLocalizable.singleton().stringWithKey(key: key)
        if v == "" {
            return key
        }
        return v
    }
    
    //设置系统语言
    func sysSetLang(lang:String){
        MDLangLocalizable.singleton().setCurrentLanguage(lang: lang)
    }
}

struct GitResponseLink {
    var nextPage = ""
    var nextNum = 0
    
    var lastPage = ""
    var lastNum = 0
}


extension UIViewController {
    
    func getScreenImage(size:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 150,height: 150), false, 1.0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //大图bigImage
    //定义myImageRect，截图的区域
    //    CGRect myImageRect = CGRectMake(70, 10, 150, 150);
    //    UIImage* bigImage= [UIImage imageNamed:@"mm.jpg"];
    //    CGImageRef imageRef = bigImage.CGImage;
    //    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    //    CGSize size;
    //    size.width = 150;
    //    size.height = 150;
    //    UIGraphicsBeginImageContext(size);
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextDrawImage(context, myImageRect, subImageRef);
    //    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    //    UIGraphicsEndImageContext();
    //    return smallImage;
    func getImageSizeFromImage(){
        
        
    }
    
}

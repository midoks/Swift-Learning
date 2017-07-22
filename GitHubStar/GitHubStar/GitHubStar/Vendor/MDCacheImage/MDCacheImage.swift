//
//  MDCacheImage.swift
//
//  Created by midoks on 15/12/26.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

//MARK: - 扩展UIImageView方法 -
extension UIImageView{
    
    //异步执行
    public func asynTask(callback:@escaping ()->Void){
        DispatchQueue.global().async { 
            callback()
        }
    }
    
    //异步更新UI
    public func asynTaskUI(callback:@escaping ()->Void){
        DispatchQueue.global().async {
            callback()
        }
    }
    
    //图片设置
    func MDCacheImage(url:String?, defaultImage:String?, isCache:Bool = true) {
        
        if defaultImage != nil {
            self.image = UIImage(named: defaultImage!)
        }
        
        //self.asynTask{
        MDTask.shareInstance.asynTaskBack{
            if isCache {
                let data:NSData? = MDCacheImageCenter.readCacheFromUrl(url: url!)
                if data != nil {
                    self.image = UIImage(data: data! as Data)
                }else{
                    
                    if defaultImage != nil {
                        self.image = UIImage(named: defaultImage!)
                    }
                    
                    let URL:NSURL = NSURL(string: url!)!
                    let data:NSData? = NSData(contentsOf: URL as URL)
                    if data != nil {
                        //写缓存
                        MDCacheImageCenter.writeCacheToUrl(url: url!, data: data!)
                        MDTask.shareInstance.asynTaskFront(callback: {
                            self.image = UIImage(data: data! as Data)
                        })
                    }
                }
                
            } else {
                
                let URL:NSURL = NSURL(string: url!)!
                let data:NSData? = NSData(contentsOf: URL as URL)
                if data != nil {
                    MDTask.shareInstance.asynTaskFront(callback: {
                        self.image = UIImage(data: data! as Data)
                    })
                }
            }
        }
    }
}


//图片缓存控制中心
class MDCacheImageCenter: NSObject {
    
    private static var cacheDirName = "MDCache"
    
    private static var fm = FileManager.default
    
    
    //设置缓存文件
    static func setCacheDir(dirName:String){
        self.cacheDirName = dirName
    }
    
    //读取缓存文件
    static func readCacheFromUrl(url:String) -> NSData?{
        var data:NSData?
        let path:String = MDCacheImageCenter.getFullCachePathFromUrl(url: url)
        
        if FileManager.default.fileExists(atPath: path) {
            data = NSData(contentsOfFile: path)
        }
        return data
    }
    
    //写到缓存文件中去
    static func writeCacheToUrl(url:String, data:NSData){
        
        let path:String = MDCacheImageCenter.getFullCachePathFromUrl(url: url)
        
        data.write(toFile: path, atomically: true)
    }
    
    //设置缓存路径
    static func getFullCachePathFromUrl(url:String)->String{
        
        let dirName = self.cacheDirName
        
        var cachePath = NSHomeDirectory() + "/Library/Caches/" + dirName
        
        
        let fm:FileManager=FileManager.default
        fm.fileExists(atPath: cachePath)
        if !(fm.fileExists(atPath: cachePath)) {
            try! fm.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
        }
        //进行字符串处理
        let newURL = MDCacheImageCenter.stringToMDString(str: url as NSString)
        cachePath = cachePath.appendingFormat("/%@", newURL)
        
        //print(cachePath)
        return cachePath
    }
    
    
    //删除所有缓存文件
    static func removeAllCache(){
        let dirName = self.cacheDirName
        let cachePath = NSHomeDirectory() + "/Library/Caches/" + dirName
        if fm.fileExists(atPath: cachePath) {
            try! fm.removeItem(atPath: cachePath)
        }
    }
    
    
    
    //字节大小类型
    enum MDCacheImageType{
        case B
        case KB
        case MB
        case GB
        case TB
        case PB
        case EB
        case ZB
        case YB
        case BB
        case NB
        case DB
    }
    
    //统计缓存文件的大小
    static func cacheSize() -> Float {
        let dirName = self.cacheDirName
        let cachePath = NSHomeDirectory() + "/Library/Caches/" + dirName
        
        let size = self.calcCacheSize(path: cachePath)
        return size
        //        switch(type){
        //        case .B: return size
        //        case .KB: return size/(pow(1024,1))
        //        case .MB: return size/(pow(1024,2))
        //        case .GB: return size/(pow(1024,3))
        //        case .TB: return size/(pow(1024,4))
        //        case .PB: return size/(pow(1024,5))
        //        case .EB: return size/(pow(1024,6))
        //        case .ZB: return size/(pow(1024,7))
        //        case .YB: return size/(pow(1024,8))
        //        case .BB: return size/(pow(1024,9))
        //        case .NB: return size/(pow(1024,10))
        //        case .DB: return size/(pow(1024,11))
        //        }
    }
    
    //获取合适的数据
    static func getCacheSize() -> Float {
        return self.cacheSize()
    }
    
    
    //计算路径下所有文件的大小
    static func calcCacheSize(path:String) -> Float {
        
        let list = try? fm.contentsOfDirectory(atPath: path)
        
        if list == nil {
            return 0.0
        }
        
        var size:Float = 0.0
        let tmpDir = path + "/"
        for i in list! {
            
            let fpath = tmpDir + i
            
            let isDir = UnsafeMutablePointer<ObjCBool>.allocate(capacity: 1)
            fm.fileExists(atPath: fpath, isDirectory: isDir)
            if(isDir.pointee.boolValue){
                size += self.calcCacheSize(path: fpath)
            } else {
                //let attr = try! fm.attributesOfItem(atPath: fpath)
                size += 0
            }
        }
        return size
    }
    
    //移除特殊字符
    static func stringToMDString(str:NSString)-> String{
        
        let mdStr = str.components(separatedBy: "?")
        let str:NSString = mdStr[0] as NSString
        
        let newStr:NSMutableString = NSMutableString()
        for i:NSInteger in 0 ..< str.length {
            
            let c:unichar = str.character(at: i)
            if (c>=48&&c<=57)||(c>=65&&c<=90)||(c>=97&&c<=122){
                newStr.appendFormat("%c", c)
            }
        }
        return (newStr.copy() as! String) + ".png"
    }
    
}

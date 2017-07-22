//
//  ProjectModel.swift
//  GitHubStar
//
//  Created by midoks on 16/3/9.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON
//项目缓存
class ProjectModel: NSObject {
    
    private var cacheDirName = "MDRepoData"
    private var fm = FileManager.default
    
    var cacheTime:CGFloat = 60*60 //s
    
    private static var dbInstance:ProjectModel?
    
    //Mark: - 实例化 -
    static func instance() -> ProjectModel {
        if((dbInstance == nil)){
            dbInstance = ProjectModel()
        }
        return dbInstance!
    }
    
    private func stringToMDString(str:NSString)-> String{
        return "m" + str.replacingOccurrences(of: "/", with: "_") + ".txt"
    }
    
    //读取缓存文件
    private func readCacheFromUrl(url:String) -> String {
        
        let path = getFullCachePathFromUrl(url: url)
        if fm.fileExists(atPath: path) {
            let s = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
            return s
        }
        return ""
    }
    
    //设置缓存路径
    private func getFullCachePathFromUrl(url:String)->String{
        
        var cachePath = NSHomeDirectory() + "/Library/Caches/" + self.cacheDirName
        
        
        fm.fileExists(atPath: cachePath)
        if !(fm.fileExists(atPath: cachePath)) {
            try! fm.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: nil)
        }
        //进行字符串处理
        let newURL = stringToMDString(str: url as NSString)
        cachePath = cachePath.appendingFormat("/%@", newURL)
        
        return cachePath
    }
    
    private func getFileTime(url:String) -> AnyObject {
//        let v = try! fm.attributesOfItem(atPath: url)
//        if let data = v["NSFileModificationDate"] {
//            return data
//        }
        return "" as AnyObject
    }
    
    //写到缓存文件中去
    private func writeCacheToUrl(url:String, data:String){
        let path = getFullCachePathFromUrl(url: url)
        try! data.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
    }
    
    //计算路径下所有文件的大小
    private func calcCacheSize(path:String) -> Float {
        
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
                //size += attr["NSFileSize"]!.floatValue
                size += 0.0
            }
        }
        return size
    }
    
    
    //统计缓存文件的大小
    func cacheSize() -> Float {
        let dirName = self.cacheDirName
        let cachePath = NSHomeDirectory() + "/Library/Caches/" + dirName
        let size = self.calcCacheSize(path: cachePath)
        return size
    }
    
    
    
    //字符串转化时间戳
    static func stringToTimeStamp(stringTime:String) -> String {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: stringTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        
        return String(dateSt)
        
    }
    
    //时间戳转化时间
    static func timeStampToString(timeStamp:String) -> String {
        
        let string = NSString(string: timeStamp)
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.string(from: date as Date)
    }
    
    //MARK: - 清楚所有数据 -
    func clearAll(){
        clearRepo()
    }
    
    func clearRepo(){
    }
    
    //MARK: - 项目相关操作 -
    //添加项目
    func addRepo(key:String,value:String) {
        self.writeCacheToUrl(url: key, data: value)
    }
    
    func getRepo(key:String) -> String {
//        let file = self.getFullCachePathFromUrl(url: key)
//
//        if fm.fileExists(atPath: file) {
//            
//            let time = getFileTime(url: file)
//            let now = NSDate()
//            let diff = now.timeIntervalSince((time as! NSDate) as Date)
//    
//            if CGFloat(diff) > cacheTime {
//                return ""
//            }
//            return readCacheFromUrl(url: key)
//        }
        return ""
    }
}

extension GitHubApi {
    
    func getRepo(name:String, _ isCache:Bool = true, callback:@escaping (_ data:JSON)->Void) {
        
        let url = "/repos/" + name
        print(url)
        let v = ProjectModel.instance().getRepo(key: url)
        
        print(v)
        
        if v != "" {

            MDTask.shareInstance.asynTaskFront(callback: { 
                callback(JSON.parse(v))
            })
            
        } else {
            
            GitHubApi.instance.urlGet(url: url) { (data, response, error) -> Void in
                print(data, response, error)
                if data != nil {
                    let _data = String(data: data as! Data!, encoding: String.Encoding.utf8)!
                    
                    if isCache {
                        ProjectModel.instance().addRepo(key: url, value: _data)
                    }
                    callback(JSON.parse(_data))
                } else {
                    callback(JSON.null)
                }
            }

        }
        
    }
    
}

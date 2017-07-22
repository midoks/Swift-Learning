//
//  NetWork.swift
//
//  Created by midoks on 15/6/9.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

import Foundation

class NetWork {
    
    //解析NSdata数据为NSString
    static func parseData(data:NSData) -> NSString {
        return NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!
    }
    
    //GET获取数据带参数
    static func get(url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.request(method: "GET", url: url, params: params, callback: callback)
    }
    
    //GET获取数据带参数
    static func getStr(url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: NSString?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.requestStr(method: "GET", url: url, params: params, callback: callback)
    }
    
    //POST数据
    static func post(url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.request(method: "POST", url: url, params: params, callback: callback)
    }
    
    //POST数据
    static func postStr(url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: NSString?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.requestStr(method: "POST", url: url, params: params, callback: callback)
    }
    
    static func upload(url: String, files: Array<File>, callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        let params = Dictionary<String, AnyObject>()
        Upload(url: url, method: "POST", params: params, files: files, callback: callback).run()
    }
    
    //文件上传
    static func upload(url: String, params: Dictionary<String, AnyObject>, files: Array<File>, callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        Upload(url: url, method: "POST", params: params, files: files, callback: callback).run()
    }
    
    //请求返回字符串
    static func requestStr(method:String, url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: NSString?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.request(method: method, url: url, params: params) { (data, response, error) -> Void in
            let pData = self.parseData(data: data!)
            callback(pData, response, error)
        }
    }
    
    //更全面的请求
    static func request(method:String, url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        let session = URLSession.shared
        var newURL = url
        
        //GET传值
        
        if method == "GET" {
            if newURL.range(of: "?") == nil {
                if params.count > 0 {
                    newURL += self.buildParams(parameters: params)
                }
            } else {
                newURL += "&" + self.buildParams(parameters: params)
            }
        }

        let request = NSMutableURLRequest(url: NSURL(string: newURL)! as URL)
        request.httpMethod = method
        
        //POST传值
        if method == "POST" {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = NetWork.buildParams(parameters: params).data(using: String.Encoding.utf8, allowLossyConversion: true)
        }
        request.addValue("DNSPOD DDNS Mac OSX Client/1.0.1(midoks@163.com)", forHTTPHeaderField: "User-Agent")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            callback(data as NSData?, response, error as NSError?);
        })
        task.resume()
    }
    
    //组装请求串
    static func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key1 in Array(parameters.keys) {
            let value2: AnyObject! = parameters[key1]
            components += queryComponents(key1, value2)
        }
        
        let args = components.map(argsUrls)
        var buildUrl = ""
        
        var i = 0
        for arg in args {
            if(i==(args.count - 1)){
                buildUrl += "\(arg)"
            }else{
                buildUrl += "\(arg)&"
            }
            i += 1
        }
        
        return "?" + buildUrl
    }
    
    //组合请求参数
    static func argsUrls(key:String, value:String) -> String {
        return "\(key)=\(value)"
    }
    
    //过滤特殊字符
    static func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)", value)
            }
        } else {
            components.append(contentsOf: [(escape(string: key), escape(string: "\(value)"))])
        }
        
        return components
    }
    
    
    
    //安全过滤
    static func escape(string: String) -> String {
        return NSString().addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn: string) as CharacterSet)!
    }
}

//
//  NetWork.swift
//
//  Created by midoks on 15/6/9.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

import Foundation

class NetWork {
    

    //GET获取数据
    static func get(url:String, callback:(data: NSData!, response: NSURLResponse!, error:NSError!)->Void){
        let params = Dictionary<String, AnyObject>()
        request("GET", url: url, params: params, callback: callback)
    }
    
    static func getWithParams(url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:(data: NSData!, response: NSURLResponse!, error:NSError!)->Void){
        request("GET", url: url, params: params, callback: callback)
    }
    
    //POST数据
    static func postWithParams(url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:(data: NSData!, response: NSURLResponse!, error:NSError!)->Void){
        request("POST", url: url, params: params, callback: callback)
    }
    
    static func upload(url: String, files: Array<File>, callback:(data: NSData!, response: NSURLResponse!, error:NSError!)->Void){
        let params = Dictionary<String, AnyObject>()
        Upload(url: url, method: "POST", params: params, files: files, callback: callback).run()
    }
    
    //文件上传
    static func upload(url: String, params: Dictionary<String, AnyObject>, files: Array<File>, callback:(data: NSData!, response: NSURLResponse!, error:NSError!)->Void){
        Upload(url: url, method: "POST", params: params, files: files, callback: callback).run()
    }
    
    //更全面的请求
    static func request(method:String, url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:(data: NSData!, response: NSURLResponse!, error:NSError!)->Void){
        let session = NSURLSession.sharedSession()
        var newURL = url
        
        //GET传值
        if method == "GET" {
            if newURL.rangeOfString("?") == nil {
                newURL += "?" + NetWork.buildParams(params)
            } else {
                newURL += "&" + NetWork.buildParams(params)
            }
        }

        let request = NSMutableURLRequest(URL: NSURL(string: newURL)!)
        request.HTTPMethod = method
        
        //POST传值
        if method == "POST" {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = NetWork.buildParams(params).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            callback(data: data, response: response, error: error);
        })
        task.resume()
    }
    
    //组装请求串
    static func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys) {
            let value: AnyObject! = parameters[key]
            components += queryComponents(key, value)
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
        
        return buildUrl
    }
    
    static func argsUrls(key:String, value:String) -> String {
        return "\(key)=\(value)"
    }
    
    //过滤特殊字符
    static func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
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
            components.appendContentsOf([(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    static func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        
        //return NSString.stringByAddingPercentEncodingWithAllowedCharacters(string) as String
        
        //var p =  [NSString .stringByAddingPercentEscapesUsingEncoding(string)];
        //NSLog("%@", p);
        
        //return [NSString stringByAddingPercentEncodingWithAllowedCharacters:legalURLCharactersToBeEscaped ] as String;
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}
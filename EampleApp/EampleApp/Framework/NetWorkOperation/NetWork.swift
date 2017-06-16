//
//  NetWork.swift
//
//  Created by midoks on 15/6/9.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

import Foundation

class NetWork {
    

    //GET获取数据
    static func get(_ url:String, callback: @escaping (_ data: Data?, _ response: URLResponse?, _ error:NSError?)->Void){
        let params = Dictionary<String, AnyObject>()
        request("GET", url: url, params: params, callback: callback)
    }
    
    static func getWithParams(_ url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: Data?, _ response: URLResponse?, _ error:NSError?)->Void){
        request("GET", url: url, params: params, callback: callback)
    }
    
    //POST数据
    static func postWithParams(_ url:String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),  callback:@escaping (_ data: Data?, _ response: URLResponse?, _ error:NSError?)->Void){
        

        request("POST", url: url, params: params, callback: callback)
    }
    
    static func upload(_ url: String, files: Array<File>, callback:@escaping (_ data: Data?, _ response: URLResponse?, _ error:NSError?)->Void){
        let params = Dictionary<String, AnyObject>()
        Upload(url: url, method: "POST", params: params, files: files, callback: callback).run()
    }
    
    //文件上传
    static func upload(_ url: String, params: Dictionary<String, AnyObject>, files: Array<File>, callback:@escaping (_ data: Data?, _ response: URLResponse?, _ error:NSError?)->Void){
        Upload(url: url, method: "POST", params: params, files: files, callback: callback).run()
    }
    
    //更全面的请求
    static func request(_ method:String, url:String,
                        params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(),
                        callback:@escaping (_ data: Data?, _ response: URLResponse?, _ error:NSError?)->Void) {
        let session = URLSession.shared
        var newURL = url
        
        //GET传值
        if method == "GET" {
            if newURL.range(of: "?") == nil {
                newURL += "?" + NetWork.buildParams(params)
            } else {
                newURL += "&" + NetWork.buildParams(params)
            }
        }

        var request = URLRequest(url: URL(string: newURL)!)
        request.httpMethod = method
        
        //POST传值
        if method == "POST" {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = NetWork.buildParams(params).data(using: String.Encoding.utf8, allowLossyConversion: true)
        }
    
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
             callback(data, response, error! as NSError);
        }
        
        task.resume()
    }
    
    //组装请求串
    static func buildParams(_ parameters: [String: AnyObject]) -> String {
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
    
    static func argsUrls(_ key:String, value:String) -> String {
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
            components.append(contentsOf: [(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    
    static func escape(_ string: String) -> String {
        let legalURLCharactersToBeEscaped: CFString = ":&=;+!@#$()',*" as CFString
        
        //return NSString.stringByAddingPercentEncodingWithAllowedCharacters(string) as String
        
        //var p =  [NSString .stringByAddingPercentEscapesUsingEncoding(string)];
        //NSLog("%@", p);
        
        //return [NSString stringByAddingPercentEncodingWithAllowedCharacters:legalURLCharactersToBeEscaped ] as String;
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
}

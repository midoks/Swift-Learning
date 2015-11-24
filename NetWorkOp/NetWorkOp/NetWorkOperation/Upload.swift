//
//  Upload.swift
//
//  Created by midoks on 15/7/4.
//  Copyright (c) 2015年 midoks. All rights reserved.
//
//  学习地址:http://lvwenhan.com/ios/457.html

import Foundation


struct File{
    let name: String!
    let url: NSURL!
    
    init(name:String, url: NSURL){
        self.name   = name
        self.url    = url
    }
}

class Upload{
    
    let boundary = "midoksSwiftUpload"

    let url: String!
    let method: String!
    let params: Dictionary<String, AnyObject>
    let callback: (data: NSData!, response: NSURLResponse!, error: NSError!)->Void
    
    let session: NSURLSession!
    var request: NSMutableURLRequest!
    var task: NSURLSessionTask!
    
    var files: Array<File>
    
    init(url: String, method: String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), files: Array<File> =  Array<File>(), callback:(data: NSData!, response: NSURLResponse!, error: NSError!)->Void){
        
        self.url        = url
        self.method     = method
        self.params     = params
        self.files      = files
        self.callback   = callback
        
        self.session = NSURLSession.sharedSession()
        self.request    = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        //add files
        self.files      = files
    }
    
    
    
    //运行
    func run(){
        buildRequest()
        buildBody()
        fireTask()
    }
    
    
    //建立请求
    func buildRequest(){
        if self.method == "GET" && self.params.count > 0 {
            self.request = NSMutableURLRequest(URL: NSURL(string: url + "?" + buildParams(self.params))!)
        }
        
        request.HTTPMethod = self.method
        
        if self.files.count > 0 {
            request.addValue("multipart/form-data; boundary=" + self.boundary, forHTTPHeaderField: "Content-Type")
        } else if self.params.count > 0 {
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
    
    //建立请求体
    func buildBody(){
        let data = NSMutableData()
        
        if self.files.count > 0 {
            if self.method == "GET" {
                NSLog("\n\n------------------------\nThe remote server may not accept GET method with HTTP body. But I will send it anyway.\n------------------------\n\n")
            }
            
            for (key, value) in self.params {
                data.appendData(strToData("--\(self.boundary)\r\n"))
                data.appendData(strToData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"))
                data.appendData(strToData("\(value.description)\r\n"))
            }
            
            for file in self.files {
                
                data.appendData(strToData("--\(self.boundary)\r\n"))
                data.appendData(strToData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\((file.url.description as NSString).lastPathComponent)\"\r\n\r\n"))
                
                if let a = NSData(contentsOfURL: file.url) {
                    data.appendData(a)
                    data.appendData(strToData("\r\n"))
                }
            }
            
            data.appendData(strToData("--\(self.boundary)--\r\n"))
        
        } else if self.params.count > 0 && self.method != "GET" {
            data.appendData(strToData(buildParams(self.params)))
        }
        request.HTTPBody = data
    }
    
    //进程运行
    func fireTask(){
        task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            self.callback(data: data, response: response, error: error)
        })
        task.resume()
    }
    
    //字符串转化为NSData
    func strToData(string:String)->NSData{
        return string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    }
    
    //组装请求串
    func buildParams(parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in Array(parameters.keys).sort(<) {
            let value: AnyObject! = parameters[key]
            components += self.queryComponents(key, value)
        }
        return (components.map{"\($0)=\($1)"} as [String]).joinWithSeparator("&")
    }
    
    //过滤特殊字符
    func queryComponents(key: String, _ value: AnyObject) -> [(String, String)] {
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
    
    func escape(string: String) -> String {
        let legalURLCharactersToBeEscaped: CFStringRef = ":&=;+!@#$()',*"
        return CFURLCreateStringByAddingPercentEscapes(nil, string, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }


}
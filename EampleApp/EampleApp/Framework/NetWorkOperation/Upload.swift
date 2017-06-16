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
    let url: URL!
    
    init(name:String, url: URL){
        self.name   = name
        self.url    = url
    }
}

class Upload{
    
    let boundary = "midoksSwiftUpload"

    let url: String!
    let method: String!
    let params: Dictionary<String, AnyObject>
    let callback: (_ data: Data?, _ response: URLResponse?, _ error: NSError?)->Void
    
    let session: URLSession!
    var request: NSMutableURLRequest!
    var task: URLSessionTask!
    
    var files: Array<File>
    
    init(url: String, method: String, params: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>(), files: Array<File> =  Array<File>(), callback:@escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?)->Void){
        
        self.url        = url
        self.method     = method
        self.params     = params
        self.files      = files
        self.callback   = callback
        
        self.session = URLSession.shared
        self.request    = NSMutableURLRequest(url: URL(string: url)!)
        
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
            self.request = NSMutableURLRequest(url: URL(string: url + "?" + NetWork.buildParams(self.params))!)
        }
        
        request.httpMethod = self.method
        
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
                data.append(strToData("--\(self.boundary)\r\n"))
                data.append(strToData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"))
                data.append(strToData("\(value.description)\r\n"))
            }
            
            for file in self.files {
                
                data.append(strToData("--\(self.boundary)\r\n"))
                data.append(strToData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.url.lastPathComponent)\"\r\n\r\n"))
                
                if let a = try? Data(contentsOf: file.url) {
                    data.append(a)
                    data.append(strToData("\r\n"))
                }
            }
            
            data.append(strToData("--\(self.boundary)--\r\n"))
        
        } else if self.params.count > 0 && self.method != "GET" {
            data.append(strToData(NetWork.buildParams(self.params)))
        }
        request.httpBody = data as Data
    }
    
    //进程运行
    func fireTask(){
//        task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
//            self.callback(data, response, error)
//        })
        task.resume()
    }
    
    //字符串转化为NSData
    func strToData(_ string:String)->Data{
        return string.data(using: String.Encoding.utf8, allowLossyConversion: true)!
    }

}

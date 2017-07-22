

//
//  GitHubApi.swift
//  GitHubStar
//
//  Created by midoks on 15/12/18.
//  Copyright © 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

//MARK: - 基本的设置功能 -
public class GitHubApi:NSObject {
    
    public var clientID:String = ""
    public var clientSecret:String = ""
    public var scope:String = "user,user:follow,repo,public_repo,notifications,gist,read:org"
    
    let apiUrl = "https://api.github.com"
    
    public var request:NSMutableURLRequest?
    public var task:URLSessionDataTask?
    public var session:URLSession?
    
    public var oauth_token:String?
    public var isShowAlert = false
    
    static let instance = GitHubApi()
    
    //设置应用的clientID,clientSecret
    init(clientID:String = "", clientSecret:String = ""){
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
    
    //实例化再配置
    func initConfig(clientID:String, clientSecret:String){
        self.clientID = clientID
        self.clientSecret = clientSecret
    }
    
    //设置访问权限
    func setScope(scope:String){
        self.scope = scope
    }
    
    //组装url
    func buildUrl(path:String) -> String {
        let url = apiUrl + path
        return url
    }
    
    //组装url
    func bulidUrl(path:String, params:Dictionary<String, String>) -> String {
        let url = path + "?" + self.buildParam(params: params)
        return url
    }
    
    //组装参数
    public func buildParam(params:Dictionary<String, String>) -> String {
        var args = ""
        for (k,v) in params {
            if(!k.isEmpty){
                args += k + "=" + v + "&"
            }else{
                args = v
            }
        }
        return args.trim()
    }
    
}

//MARK: - 数据请求 -
extension GitHubApi{
    
    //GET获取数据带参数
    public func get(url:String, params: Dictionary<String, String> = Dictionary<String, String>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        
        MDTask.shareInstance.asynTaskBack {
            self.request(method: "GET", url: url, params: params, callback: callback)
        }
    }
    
    //POST数据
    public func post(url:String, params: Dictionary<String, String> = Dictionary<String, String>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        MDTask.shareInstance.asynTaskBack {
            self.request(method: "POST", url: url, params: params, callback: callback)
        }
    }
    
    //PUT数据
    func put(url:String, params: Dictionary<String, String> = Dictionary<String, String>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        MDTask.shareInstance.asynTaskBack {
            self.request(method: "PUT", url: url, params: params, callback: callback)
        }
    }
    
    //DELETE数据
    func delete(url:String, params: Dictionary<String, String> = Dictionary<String, String>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        MDTask.shareInstance.asynTaskBack {
            self.request(method: "DELETE", url: url, params: params, callback: callback)
        }
    }
    
    
    //更全面的请求
    private func request(method:String, url:String, params: Dictionary<String, String> = Dictionary<String, String>(),  callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        var newURL = url
        
        //GET传值
        if method == "GET" {
            if newURL.range(of: "?") == nil {
                if params.count > 0 {
                    newURL += "?" + self.buildParam(params: params)
                }
            } else {
                newURL += self.buildParam(params: params)
            }
        }
        
        //print(newURL)
        //newURL = self.buildClientUrl(newURL)
        
        self.request = NSMutableURLRequest(url: NSURL(string: newURL)! as URL)
        //self.request!.URL = NSURL(string: newURL)!
        self.request?.httpMethod = method
        
        self.request?.addValue("GitHubStar Client/1.0.1(midoks@163.com)", forHTTPHeaderField: "User-Agent")
        if( self.oauth_token != nil){
            self.request?.addValue("token " + self.oauth_token!, forHTTPHeaderField: "Authorization")
        }
        
        //POST传值
        if method == "POST" {
            self.request?.addValue("application/json", forHTTPHeaderField: "Accept")
            self.request?.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            self.request?.httpBody = self.buildParam(params: params).data(using: String.Encoding.utf8, allowLossyConversion: true)
        } else if method == "PUT" {
            self.request?.httpMethod = method
        } else if method == "DELETE" {
            self.request?.httpMethod = method
        }
        
        //执行请求
        self.session = URLSession.shared
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.task = self.session!.dataTask(with: self.request! as URLRequest, completionHandler: { (data, response, error) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            MDTask.shareInstance.asynTaskFront(callback: {
                callback(data as NSData?, response, error as NSError?)
            })
            
        })
        self.task!.resume()
    }
    
    //设置Header信息
    func setHeader(key:String, value:String){
        self.request?.addValue(value, forHTTPHeaderField: key)
    }
    
    func buildClientUrl(url:String) -> String {
        var _url = url
        if self.clientID != "" && self.clientSecret != "" {
            
            if url.range(of: "?") == nil {
                _url +=  "?client_id=" + self.clientID + "&client_serect=" + self.clientSecret
            } else {
                _url +=  "&client_id=" + self.clientID + "&client_serect=" + self.clientSecret
            }
        }
        return _url
    }
    
    //取消请求
    func close(){
        self.task?.cancel()
    }
}

//MARK: - 获取token -
extension GitHubApi{
    
    //第三方url地址
    public func authUrl() -> String {
        let url = self.bulidUrl(path: "https://github.com/login/oauth/authorize",
                                params: ["scope"   : self.scope,
                                    "client_id"    : self.clientID,
                                    "state"     : "midoks"])
        return url
    }
    
    //获取token
    public func getToken(code:String, callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        
        self.post(url: "https://github.com/login/oauth/access_token", params: [
            "scope"     : self.scope,
            "client_id" : self.clientID,
            "client_secret" : self.clientSecret,
            "code"      : code,
            "state"     : "midoks"]) { (data, response, error) -> Void in
                callback(data, response, error)
        }
    }
    
    //在请求里加入token
    public func setToken(token:String){
        self.oauth_token = token
    }
    
    //获取token
    public func getToken() -> String {
        return oauth_token!
    }
    
}

//GitHub数据编码
extension GitHubApi {
    func dataEncode64(strVal:String) -> String {
        
        let strValData = strVal.data(using: String.Encoding.utf8)
        let strValEncodeData = strValData!.base64EncodedData(options: Data.Base64EncodingOptions(rawValue: 0))
        let strValEncode = String(data: strValEncodeData, encoding: String.Encoding.utf8)
        
        return strValEncode!
    }
    
    func dataDecode64(strVal:String) -> String {
        let data = NSData(base64Encoded:strVal ,options: .ignoreUnknownCharacters)!
        let strValDecode = String(data: data as Data, encoding: String.Encoding.utf8)
        if strValDecode == nil {
            return ""
        }
        return strValDecode!
    }
}


//MARK: - 用户相关操作 -
extension GitHubApi{
    
    //用户数据
    func user(callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.get(url: self.buildUrl(path: "/user")) { (data, response, error) -> Void in
            callback(data, response, error)
        }
        
    }
    
    //获取用户邮件地址列表
    func userEmails(callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.get(url: self.buildUrl(path: "/user/emails")) { (data, response, error) -> Void in
            callback(data, response, error)
        }
    }
    
}

//MARK: - 容纳GitHub所有的请求 -
extension GitHubApi{
    
    //所有GET操作
    public func webGet(absoluteUrl:String, callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.get(url: absoluteUrl) { (data, response, error) -> Void in
            if self.checkGitAllError(data: data, response: response, error: error) {
                callback(data, response, error)
            } else {
                
                callback(nil, nil, nil)
            }
        }
    }
    
    //所有GET操作
    public func urlGet(url:String, callback:@escaping (_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        self.get(url: self.buildUrl(path: url)) { (data, response, error) -> Void in
            
            if self.checkGitAllError(data: data, response: response, error: error) {
                callback(data, response, error)
            } else {
                callback(nil, nil, nil)
            }
            
        }
    }
    
    private func gitJsonParse(data:NSData) -> JSON {
        let _data = String(data: data as Data, encoding: String.Encoding.utf8)!
        let _dataJson = JSON.parse(_data)
        return _dataJson
    }
    
    //- 获取当前的视图 -
    private func getRootVC() -> UIViewController {
        let window = UIApplication.shared.keyWindow
        return (window?.rootViewController)!
    }
    
    //显示提示信息
    private func showNotice(msg:String){
        
        if self.isShowAlert {
            return;
        }
        
        self.isShowAlert = true
        let root = self.getRootVC()
        
        root.showTextWithTime(msg: msg, time: 2) {
            self.isShowAlert = false
        }
    }
    
    public func checkGitAllError(data: NSData!, response: URLResponse!, error:NSError!) -> Bool {
        
        if error != nil {
            
            if error.code == -999 {//self close request
            } else {
                self.showNotice(msg: "网络不好!!!")
                print(error)
            }
        }
        
        if data != nil {
            
            let resp = response as! HTTPURLResponse
            let status = resp.statusCode
            if status == 204 || status == 404 {} else {
                let _json = self.gitJsonParse(data: data)
                if _json["message"].stringValue != "" {
                    print(_json)
                    self.showNotice(msg: _json["message"].stringValue)
                    return false
                }
            }
        }
        
        return true
    }
    
}







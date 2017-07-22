//
//  Github.swift
//  GitHubStar
//
//  Created by midoks on 2017/7/22.
//  Copyright © 2017年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Github: NSObject {
    
    public var clientID:String = ""
    public var clientSecret:String = ""
    public var scope:String = "user,user:follow,repo,public_repo,notifications,gist,read:org"
    
    let apiUrl = "https://api.github.com"
    
    static let instance = Github()
    
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
    
    func get(url:String, callback:(_ data: NSData?, _ response: URLResponse?, _ error:NSError?)->Void){
        print(url)
        
        Alamofire.request(url).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }

}


//GitHub数据编码
extension Github {
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

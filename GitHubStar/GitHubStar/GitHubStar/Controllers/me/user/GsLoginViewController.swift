//
//  LoginViewContoller.swift
//  GitHubStar
//
//  Created by midoks on 15/12/19.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsLoginViewController: GsWebViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "Login")
        
        let rightButton = UIBarButtonItem(title: "刷新", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.reloadRequestUrl))
        self.navigationItem.rightBarButtonItem  = rightButton
        
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.close))
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.loadRequestUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //关闭
    func close(){
        self.pop()
        self.dismiss(animated: true) { () -> Void in
            self.clearCookie()
        }
    }

    //加载url请求
    func loadRequestUrl(){
        let urlString = GitHubApi.instance.authUrl()
        let url = (NSURLComponents(string: urlString)?.url)!
        self.loadUrl(url: url as NSURL)
    }
    
    //重新加载
    func reloadRequestUrl(){
        self.reload()
    }
    
    //Mark: - webView delegate -
    override func webViewDidFinishLoad(_ webView: UIWebView) {
        super.webViewDidFinishLoad(webView)
        
        let code = webView.stringByEvaluatingJavaScript(from: "code")
        
        if code != "" {
            //print(code)
            GitHubApi.instance.getToken(code: code!, callback: { (data, response, error) -> Void in
                
                //print(error)
                //print(response)
                if (response != nil) {
                    
                    let data = String(data: data! as Data, encoding: String.Encoding.utf8)!
                    let userInfoData = JSON.parse(data)
                    let token = userInfoData["access_token"].stringValue
                    
                    GitHubApi.instance.setToken(token: token)
                    GitHubApi.instance.user(callback: { (data, response, error) -> Void in
                        
                        let userData = String(data: data! as Data, encoding: String.Encoding.utf8)!
                        
                        let userJsonData = JSON.parse(userData)
                        let name = userJsonData["login"].stringValue
                        
                        let userInfo = UserModelList.instance().selectUser(userName: name)
                        if (userInfo as! NSNumber != false && userInfo.count > 0) {
                            let id = userInfo["id"] as! Int
                            _ = UserModelList.instance().updateMainUserById(id: id)
                            _ = UserModelList.instance().updateInfoById(info: userData, id: id)
                        } else {
                            _ = UserModelList.instance().addUser(userName: name, token: token)
                            _ = UserModelList.instance().updateInfo(info: userData, token: token)
                        }
                        
                        self.close()
                    })
                } else {
                    print("error")
                }
                
            })
        }
        
    }
}

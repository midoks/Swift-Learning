//
//  GsRepoReadmeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/12.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsRepoReadmeViewController: UIViewController {
    
    var _webView:UIWebView = UIWebView()
    
    var progress: UIProgressView?
    var progressEnd = false
    var progressTimer: Timer?
    
    var _readmeData:JSON = JSON.parse("")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "Readme")
        self.view.backgroundColor = UIColor.white
        
        _webView.delegate = self
        _webView.frame = self.view.bounds
        _webView.frame.size.height += self.tabBarController!.tabBar.frame.height
        self.view.addSubview(_webView)
        
        //加载进度条
        self.progress = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        self.progress!.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height:2)
        self.progress!.progress = 0
        self.progress!.isHidden = false
        self.view.addSubview(self.progress!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func strToEncode64(strVal:String) -> String {
        
        let strValData = strVal.data(using: String.Encoding.utf8)
        let strValEncodeData = strValData?.base64EncodedData(options: Data.Base64EncodingOptions.init(rawValue: 0))
        
        let strValEncode = String(data: strValEncodeData!, encoding: String.Encoding.utf8)
        return strValEncode!
    }
    
    func strToDecode64(strVal:String) -> String {
        
        let data = NSData(base64Encoded:strVal ,options: .ignoreUnknownCharacters)!
        let strValDecode = String(data: data as Data, encoding: String.Encoding.utf8)
        return strValDecode!
    }
    
    func setReadmeData(data:JSON){
        
        self._readmeData = data
        
        //print(data["_links"])
        
        let content = data["content"].stringValue
        let contentDecode = strToDecode64(strVal: content)
        
        self.asynTask { () -> Void in
            //let v = MarkNoteParser.toHtml(contentDecode)
            //print(v)
            
            self._webView.loadHTMLString(contentDecode, baseURL: nil)
        }
    }
    
    func setReadmeUrl(url:NSURL){
        let u = NSURLRequest(url: url as URL)
        _webView.loadRequest(u as URLRequest)
    }
    
}


//MARK: - UIWebViewDelegate -
extension GsRepoReadmeViewController:UIWebViewDelegate {
    
    //进度条回调
    func progressCallback() {
        
        self.progress!.progress += 0.01
        
        if self.progressEnd {
            if self.progress!.progress >= 0.99 {
                self.progress!.progress = 1
                self.progress!.isHidden = true
                self.progressTimer!.invalidate()
            }
        } else {
            if self.progress!.progress >= 0.99 {
                self.progress!.progress = 1
                self.progress!.isHidden = true
                self.progressTimer!.invalidate()
            }
        }
    }
    
    //开启进度条定时检查
    func beginLoadProgressTimer(){
        
        if(self.progress!.progress == 0){
            if self.progressTimer != nil {
                self.progressTimer!.invalidate()
            }
            self.progressTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(GsRepoReadmeViewController.progressCallback), userInfo: nil, repeats: true)
        }
        
        self.progress!.progress = 0
        self.progress!.isHidden = false
        self.progressEnd = false
        self.progressTimer!.fire()
    }
    
    //进度条结束
    func endLoadProgressTimer(){
        self.progressEnd = true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        endLoadProgressTimer()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        beginLoadProgressTimer()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        endLoadProgressTimer()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        beginLoadProgressTimer()
        return true
    }
}

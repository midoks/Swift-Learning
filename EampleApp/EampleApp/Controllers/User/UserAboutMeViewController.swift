//
//  UserAboutMeViewController.swift
//  EampleApp
//
//  Created by midoks on 15/8/6.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class UserAboutMeViewController: UIViewController, UIWebViewDelegate {
    
    var web: UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于我"
        
        
        //print(self.view.frame.height)
        //print(self.tabBarController?.tabBar.frame.height)
        let webInitHeight = self.view.frame.height + (self.tabBarController?.tabBar.frame.height)!
        
        
        
        web = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: webInitHeight))
        web?.delegate = self
        
        //let url = "http://midoks.github.io/"
        let req = NSURLRequest(URL: NSURL(scheme: "http", host: "midoks.github.io", path: "/")!)
        self.view.addSubview(web!)
        
        web?.loadRequest(req)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    //隐藏tabbar
    func hiddenTabBar(){
        self.tabBarController?.tabBar.alpha = 0.5
        //web = UIWebView(frame: self.view.frame)
    }
    
    //显示tabbar
    func showTabBar(){
        self.tabBarController!.tabBar.hidden = false
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("web load ok")
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("web load start")
        
        
        print(webView.scrollView.contentSize.height)
        
//        let webHeight       = webView.scrollView.contentSize.height - 600
//        var nFrame          = web!.frame
//        nFrame.size.height  = webHeight
//        web?.frame          = nFrame
//        
//        print(web?.frame)
        
        
        //hiddenTabBar()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("web load error")
        
//        let alert = UIAlertController(title: "", message: "加载失败!", preferredStyle: UIAlertControllerStyle.Alert)
//        let reFreshAction = UIAlertAction(title: "刷新", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
//            web?.reload()
//            
//        })
//        alert.addAction(reFreshAction)
        //self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
}

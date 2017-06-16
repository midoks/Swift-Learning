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
    var mProgressView: UIProgressView?
    var loadUrlEnd: Bool = false
    var loadTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "关于我"
        
        self.loadTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(UserAboutMeViewController.loadProgressViewCallback), userInfo: nil, repeats: true)
    
        
        //请求页面
        loadRequestUrl()
        //加载进度条
        loadProgressView()
        
        //print(self.view.frame.height)
        //print(self.tabBarController?.tabBar.frame.height)               //tabbar高度
        //print(self.navigationController?.navigationBar.frame.height)    //导航高度
        //print(UIApplication.sharedApplication().statusBarFrame.height)  //状态高度
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserAboutMeViewController.NSNotificationCenterUser), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    func NSNotificationCenterUser(){
        let orientation = UIDevice.current.orientation
        print("通知时间")
        print(orientation)
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        print("旋转了")
        
        print(self.view.frame)
        
        if(toInterfaceOrientation.isLandscape){//横屏
            self.mProgressView!.frame = CGRect(x: 0, y: 32, width: self.view.frame.width, height: 1)
        }else{//竖屏
            self.mProgressView!.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 1)
        }
        
        let webInitHeight = self.view.frame.height + (self.tabBarController?.tabBar.frame.height)!
        web = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: webInitHeight))
    
    }
    
    
    //加载进度条
    func loadProgressView(){
        self.mProgressView = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        self.mProgressView!.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 4)
        //self.mProgressView!.frame = CGRect(x: 0, y: 32, width: self.view.frame.width, height: 1)
        self.mProgressView!.progress = 0
        self.mProgressView!.isHidden = false
        self.view.addSubview(self.mProgressView!)
    }
    
    //开启进度条定时检查
    func beginLoadProgressViewTimer(){
        
        if(mProgressView!.progress == 1){
            self.loadTimer!.invalidate()
            self.loadTimer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(UserAboutMeViewController.loadProgressViewCallback), userInfo: nil, repeats: true)
        }
        
        
        self.mProgressView!.progress = 0
        self.mProgressView!.isHidden = false
        self.loadUrlEnd = false
        self.loadTimer!.fire()
        
    }
    
    //进度条结束
    func endLoadProgressViewTimer(){
        self.loadUrlEnd = true
    }
    
    
    //进度条回调
    func loadProgressViewCallback() {
        let date = Date()
        //let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.S"
        
        print("定时器运行中...\n, \(timeFormatter.string(from: date))")
        print(self.loadTimer)
        
        
        if self.loadUrlEnd {
            //print("timer end")
            if self.mProgressView!.progress >= 1 {
                self.mProgressView!.progress = 1
                self.mProgressView!.isHidden = true
                self.loadTimer!.invalidate()
                   
            } else {
                self.mProgressView!.progress += 0.1
            }
        
        } else {
            //print("time starting")
            self.mProgressView!.progress += 0.05
            if self.mProgressView!.progress >= 0.95 {
                self.mProgressView!.progress = 0.95
            }
        }
    }
    

    //加载url请求
    func loadRequestUrl(){
        let webInitHeight = self.view.frame.height + (self.tabBarController?.tabBar.frame.height)!
        web = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: webInitHeight))
        web?.delegate = self
        
        //let url = "http://midoks.github.io/"
        let req = URLRequest(url: (URLComponents(string: "https://midoks.github.io/")?.url)!)
        
        self.view.addSubview(web!)
        web!.loadRequest(req)
    }
    
    //本页面显示时
    override func viewWillAppear(_ animated: Bool) {
    }
    
    //离开本页面
    override func viewWillDisappear(_ animated: Bool) {
        //self.tabBarController?.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
        
        //关闭定时器
        self.loadTimer!.invalidate()

    }
    
    //隐藏tabbar
    func hiddenTabBar(){
        self.tabBarController?.tabBar.alpha = 0.5
        //web = UIWebView(frame: self.view.frame)
    }
    
    //显示tabbar
    func showTabBar(){
        self.tabBarController!.tabBar.isHidden = false
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("web load ok")
        
        //进度条
        endLoadProgressViewTimer()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("web load start")
        
        //进度条
        
        beginLoadProgressViewTimer()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("web load error")

        //进度条
        endLoadProgressViewTimer()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("url req start")
        
        //beginLoadProgressViewTimer()
        return true
    }
    
}

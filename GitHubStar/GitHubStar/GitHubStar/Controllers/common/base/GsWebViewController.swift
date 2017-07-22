//
//  Created by midoks on 16/1/10.
//  Copyright © 2016年 midoks. All rights reserved.
//
//  Web浏览器基本ViewController

import UIKit


class GsWebViewController: UIViewController {
    
    var web: UIWebView?
    var progress: UIProgressView?
    var loadurlend: Bool = false
    var loadtimer: Timer?
    
    //进入时
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rootVC = self.getRootVC()
        
        if UIDevice.current.orientation.isPortrait {
            self.progress?.frame = CGRect(x: 0, y: 64, width: rootVC.view.frame.size.width, height: 0.5)
        } else if UIDevice.current.orientation.isLandscape {
            self.progress?.frame = CGRect(x: 0, y: 32, width: rootVC.view.frame.size.width, height: 0.5)
        }
    }
    
    //离开本页面
    override func viewWillDisappear(_ animated: Bool) {
        if self.loadtimer != nil {
            self.loadtimer!.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //url
        let webInitHeight = self.view.frame.height
        self.web = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: webInitHeight))
        self.web!.delegate = self
        self.web!.scalesPageToFit = true
        self.view.addSubview(self.web!)
        
        //加载进度条
        self.progress = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        self.progress!.frame = CGRect(x:0, y: 64, width: self.view.frame.width, height: 1)
        self.progress!.progress = 0
        self.progress!.isHidden = false
        self.view.addSubview(self.progress!)
    }
    
    //加载url
    func loadUrl(url:NSURL){
        let req = NSURLRequest(url: url as URL)
        self.web!.loadRequest(req as URLRequest)
    }
    
    func loadSourceData(data:String, tmpName:String = "sourceCode"){
        
        let baseUrl = NSURL.fileURL(withPath: Bundle.main.bundlePath)
        //print(baseUrl)
        let path = Bundle.main.path(forResource: tmpName, ofType: "mdhtml")
        //print(path)
        let html = try! String(contentsOfFile: path!)
    
        var c = html.replacingOccurrences(of: "<{CODE}>", with: data)
        c = c.replacingOccurrences(of: "<{ROOT_PATH}>", with: baseUrl.absoluteString)
        
        //print(c,baseUrl)
        self.web?.loadHTMLString(c, baseURL: baseUrl)
    }
    
    func loadCommitsData(data:String){
    
        let baseUrl = NSURL.fileURL(withPath: Bundle.main.bundlePath)
        //print(baseUrl)
        let path = Bundle.main.path(forResource: "commits", ofType: "mdhtml")
        //print(path)
        let html = try! String(contentsOfFile: path!)
        
        
        
        var c = html.replacingOccurrences(of: "<{CODE}>", with: data)
        c = c.replacingOccurrences(of: "<{ROOT_PATH}>", with: baseUrl.absoluteString)
        
        //print(c)
        self.web?.loadHTMLString(c, baseURL: baseUrl)
    }
    
    //开启进度条定时检查
    func beginLoadProgressViewTimer(){
        
        if(self.progress!.progress == 0){
            if self.loadtimer != nil {
                self.loadtimer!.invalidate()
            }
            self.loadtimer = Timer.scheduledTimer(timeInterval: 0.1667, target: self, selector: #selector(self.loadProgressViewCallback), userInfo: nil, repeats: true)
        }
        
        self.progress!.progress = 0
        self.progress!.isHidden = false
        self.loadurlend = false
        self.loadtimer!.fire()
    }
    
    //进度条回调
    func loadProgressViewCallback() {
        
        self.progress!.progress += 0.01
        
        if self.loadurlend {
            self.progress!.progress = 1
            self.progress!.isHidden = true
            self.loadtimer!.invalidate()
        } else {
            if self.progress!.progress >= 0.99 {
                self.progress!.progress = 1
                self.progress!.isHidden = true
                self.loadtimer!.invalidate()
            }
        }
    }
    
    //进度条结束
    func endLoadProgressViewTimer(){
        self.loadurlend = true
    }
    
    //重载
    func reload(){
        self.web!.reload()
    }
}

//MARK: - webViewDelegate -
extension GsWebViewController : UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        endLoadProgressViewTimer()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        beginLoadProgressViewTimer()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        endLoadProgressViewTimer()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        beginLoadProgressViewTimer()
        return true
    }
}

extension GsWebViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.web?.frame.size = size
        
        if UIDevice.current.orientation.isPortrait {
            self.progress?.frame = CGRect(x: 0, y: 64, width: size.width, height: 0.5)
        } else if UIDevice.current.orientation.isLandscape {
            self.progress?.frame = CGRect(x: 0, y: 32, width: size.width, height: 0.5)
        }
    }
}

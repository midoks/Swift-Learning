//
//  GsMeScanQrcodeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/5/8.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import AVFoundation

class GsMeScanQrcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    lazy var rdQrcode : MDQrcodeReader = {
        return MDQrcodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    }()
    
    lazy var scanView : MDScanView = {
        return MDScanView(frame:self.view.frame)
    }()
    
    deinit {
        print("GsMeScanQrcodeViewController deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if MDQrcodeReader.isCanRun() {
            rdQrcode.stopScanning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.title = sysLang(key: "Scan")
        initNav()
        initScanView()
        initScan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initNav(){
//        let closeButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.close))
//        self.navigationItem.rightBarButtonItem   = closeButton
    }
    
    func initScanView(){
        self.view.addSubview(self.scanView)
    }
    
    func initScan(){
        if MDQrcodeReader.isCanRun() {
            modalPresentationStyle = .formSheet
            
            rdQrcode.previewLayer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            rdQrcode.startScanning()
            
            view.layer.insertSublayer(rdQrcode.previewLayer, at: 0)
            
            rdQrcode.completionBlock = { (result: String?) in
                self.qRDroid(result: result!)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    // 二维码识别处理
    func qRDroid(result:String){
        print(result)
        if self.isHttpWeb(result: result) {
            let (r,t,e) = self.isGitHubPage(result: result)
            if e {
                if t == 1 {//用户follow
                    let url = GitHubApi.instance.buildUrl( path: "/user/following/" + r )
                    self.starGithub(url: url)
                } else if t == 2 {//repo
                    let url = GitHubApi.instance.buildUrl( path: "/user/starred/" + r )
                    self.starGithub(url: url)
                }
            } else {
                self.close()
                UIApplication.shared.openURL(NSURL(string: result)! as URL)
            }
        } else {
            let alert = UIAlertController(title: "识别成功", message: result, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func starGithub(url:String){
        
        GitHubApi.instance.webGet(absoluteUrl: url, callback: { (data, response, error) in
            
            if error == nil {
                let rep = response as! HTTPURLResponse
                let status = rep.allHeaderFields["Status"] as! String
                
                if status == "204 No Content" {
                    self.showTextWithTime(msg: "已经关注了!", time: 2, callback: {
                        self.close()
                    })
                    
                } else {
                    
                    GitHubApi.instance.put(url: url, params: [:], callback: { (data, response, error) in
                        if error == nil {
                            let rep = response as! HTTPURLResponse
                            let status = rep.allHeaderFields["Status"] as! String
                            
                            if status == "204 No Content" {
                                self.showTextWithTime(msg: "关注成功!", time: 2, callback: {
                                    self.close()
                                })
                            }
                            
                        }
                    })
                }
            }
        })
    }
    
    // 是否GitHub用户主页
    func isGitHubPage(result:String) ->(result:String, type:Int, err:Bool) {
        let pattern = "https://(www.)?github.com/(.*[^/])(\\?(.*[^/]))?"
        if result =~ pattern {
            let tmp_res = result.components(separatedBy: "?")
            let tmp2_res = tmp_res[0].components(separatedBy: "/")
            
            if tmp2_res.count == 4 {
                let username = tmp2_res[tmp2_res.count - 1]
                return (username,1,true)
            } else if tmp2_res.count == 5 {
                let repo = tmp2_res[tmp2_res.count - 2] + "/" + tmp2_res[tmp2_res.count - 1]
                return (repo,2,true)
            }
        }
        return ("",0,false)
    }
    
    func isHttpWeb(result:String) -> Bool {
        
        let pattern = "((http[s]{0,1})://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        if result =~ pattern {
            return true
        }
        return false
    }
    
    //关闭
    func close(){
        self.navigationController?.popViewController(animated: true)
    }
}

//////////////////正则
infix operator =~
func =~(input:String, pattern:String) -> Bool {
    return Regex(pattern: pattern).test(input: input)
}

//正则匹配
class Regex{
    
    let internalExpression:NSRegularExpression
    let pattern:String
    
    init(pattern:String){
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: self.pattern, options: .caseInsensitive)
    }
    
    func test(input:String) -> Bool {
        let matches = self.internalExpression.matches(in: input, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, input.length))
        return matches.count > 0
    }
    
}

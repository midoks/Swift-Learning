//
//  ViewController.swift
//  NetWorkOp
//
//  Created by midoks on 15/6/9.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func RequestNetWork(sender: UIButton) {
        
        println(NSHomeDirectory())
        //无参数GET获取
        NetWork.get("http://m.cn/swift.php", callback: { (data, response, error) -> Void in
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(string)
        })
        
        //有参数GET获取
        NetWork.getWithParams("http://m.cn/swift.php?a=true", params: ["h":"true"]) { (data, response, error) -> Void in
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(string)
            
            //使用这个json解析,非常方便
            //https://github.com/lingoer/SwiftyJSON
            let json = JSON(data: data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            println(json[0]["a"].string)
            
        }
        
        //POST传输数据
        NetWork.postWithParams("http://m.cn/swift.php?a=true", params: ["h":"true"]) { (data, response, error) -> Void in
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(string)
        }
        
        //文件上传
        let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Info", ofType: "plist")!)!)
        NetWork.upload("http://m.cn/swift.php", files: [file]) { (data, response, error) -> Void in
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            println(string)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


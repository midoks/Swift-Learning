//
//  UserSudokuViewController.swift
//
//  Created by midoks on 15/8/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit


//九宫格视图
class UserSudokuViewController: UIViewController, SudokuViewDelegate {
    
    var tmpBarColor:UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "九宫格验证"
        self.view.backgroundColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1)
        
        tmpBarColor = UINavigationBar.appearance().barTintColor
        UINavigationBar.appearance().barTintColor = UIColor(red: 35/255.0, green: 39/255.0, blue: 54/255.0, alpha: 1)
        
        
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("close:"))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        let sudoku = SudokuView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        sudoku.delegate = self
        
        //设置正确的密码
        //如果正在设置密码,就不需要填写了
        sudoku.setPwd("012345678")
        self.view.addSubview(sudoku)
    }
    
    
    func SudokuViewFail(pwd: NSString, status: NSString) {
        NSLog("pwd:%@, status:%@", pwd, status)
    }
    
    func SudokuViewOk(pwd: NSString, status: NSString) {
        NSLog("pwd:%@, status:%@", pwd, status)
        
        if("end" == status){
            let alertV = UIAlertView(title: "您的结果", message: pwd as String, delegate: nil, cancelButtonTitle: "我知道了")
            alertV.show()
        }
    }
    
    
    //离开本页面
    override func viewWillDisappear(animated: Bool) {
        UINavigationBar.appearance().barTintColor = tmpBarColor
    }
    
    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            //print("close")
        }
    }
    
    
}

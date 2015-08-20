//
//  UserSudokuViewController.swift
//
//  Created by midoks on 15/8/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit


//九宫格视图
class UserSudokuViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.title = "九宫格验证"
        self.view.backgroundColor = UIColor.clearColor()
    
        //UIBarButtonItem.appearance().tintColor = UIColor.clearColor()
        
        UINavigationBar.appearance().tintColor = UIColor.redColor()
        
        //self.navigationController?.navigationBarHidden = true
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("close:"))
        self.navigationItem.leftBarButtonItem   = leftButton
        
        print("九宫格视图")
        
        
        self.view = SudokuView(frame: CGRectZero)
    
    }
    
    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            //print("close")
        }
    }
    

}

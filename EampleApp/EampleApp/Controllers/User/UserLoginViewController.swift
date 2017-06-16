//
//  UserLoginViewController.swift
//
//  Created by midoks on 15/7/20.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initNav()
        initLoginPage()
    }
    
    //初始化导航
    func initNav(){
        let leftButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UserLoginViewController.close(_:)))
        let rightButton = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UserLoginViewController.register))
        
        self.navigationItem.leftBarButtonItem   = leftButton
        self.navigationItem.rightBarButtonItem  = rightButton
        
        //取tableview的背静颜色
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.title = "登录"
    }
    
    
    //初始化页面
    func initLoginPage(){
        let xCenter = self.view.bounds.size.width/2
        
        
        
        //let firstHight = 44 + 20
        
        //用户左边的提示
        let userNameLeft    = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        userNameLeft.textAlignment = NSTextAlignment.center
        //userNameLeft.backgroundColor = UIColor.redColor()
        userNameLeft.text   = "账户"
        
        //用户名输入
        let userName = UITextField(frame: CGRect(x: 0, y: 100, width: self.view.bounds.size.width * 0.8, height: 40))
        userName.center             = CGPoint(x: xCenter, y: 100)
        userName.keyboardType       = UIKeyboardType.twitter
        userName.borderStyle        = UITextBorderStyle.none
        userName.textAlignment      = NSTextAlignment.left
        userName.clearButtonMode    = UITextFieldViewMode.whileEditing
        userName.returnKeyType      = UIReturnKeyType.done
        userName.placeholder        = "请输入你的账户"
        userName.leftView           = userNameLeft
        userName.leftViewMode       = UITextFieldViewMode.always
        
        userName.delegate           = self
        userName.backgroundColor    = UIColor.white
        self.view.addSubview(userName)
    
        
        
        //密码左边的提示
        let userPwdLeft = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        userPwdLeft.textAlignment  = NSTextAlignment.center
        userPwdLeft.text           = "密码"
        
        
        let tool = setInputUIToolbar()
        //用户密码输入
        let userPwd = UITextField(frame: CGRect(x: 0, y: 141, width: self.view.bounds.size.width * 0.8, height: 40))
        userPwd.center             = CGPoint(x: xCenter, y: 141)
        userPwd.keyboardType       = UIKeyboardType.namePhonePad
        userPwd.borderStyle        = UITextBorderStyle.none
        userPwd.textAlignment      = NSTextAlignment.left
        userPwd.clearButtonMode    = UITextFieldViewMode.whileEditing
        userPwd.returnKeyType      = UIReturnKeyType.done
        userPwd.placeholder        = "请输入你的密码"
        userPwd.isSecureTextEntry    = true
        
        userPwd.leftView           = userPwdLeft
        userPwd.leftViewMode       = UITextFieldViewMode.always
        
        //自定义工具栏
        userPwd.inputAccessoryView = tool
        
        userPwd.delegate = self
        userPwd.backgroundColor = UIColor.white
        self.view.addSubview(userPwd)
        
        //登录按钮
        let loginButton = UIButton(frame: CGRect(x: 0, y: 182, width: self.view.bounds.size.width * 0.8, height: 40))
        loginButton.center = CGPoint(x: xCenter, y: 182)
        loginButton.setTitle("登录", for: UIControlState())
        loginButton.setTitleColor(UIColor.blue, for: UIControlState())
        loginButton.setTitleColor(UIColor.brown, for: UIControlState.highlighted)
        loginButton.addTarget(self, action: #selector(UserLoginViewController.close(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func setInputUIToolbar() -> UIToolbar {
        let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        
        let loginIn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        loginIn.setTitle("登录", for: UIControlState())
        loginIn.setTitleColor(UIColor.blue, for: UIControlState())
        loginIn.setTitleColor(UIColor.brown, for: UIControlState.highlighted)
        tool.addSubview(loginIn)
        
        let ok  = UIButton(frame: CGRect(x: self.view.frame.size.width - 60 , y: 0, width: 60, height: 40))
        ok.setTitle("Done", for: UIControlState())
        ok.setTitleColor(UIColor.blue, for: UIControlState())
        ok.setTitleColor(UIColor.brown, for: UIControlState.highlighted)
        tool.addSubview(ok)
        //frame: CGRect(x: self.view.frame.size.width - 60 , y: 0, width: 60, height: 40)
        return tool
    }
    
    //TextField按返回键的反应
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //跳到注册页
    func register(){
        let register = UserRegisterViewController()
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    
    //关闭
    func close(_ button: UIButton){
        self.dismiss(animated: true) { () -> Void in
            //print("close")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

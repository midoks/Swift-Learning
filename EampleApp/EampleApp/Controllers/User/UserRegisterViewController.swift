//
//  UserRegisterViewController.swift
//
//  Created by midoks on 15/7/23.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class UserRegisterViewController: UIViewController, UITextFieldDelegate {
    
    var userName :UITextField?
    var userPwd  :UITextField?
    var userNick :UITextField?
    var regButton:UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initNav()
        initRegisterPage()
        
    }
    
    func initNav(){
        let leftButton  = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UserRegisterViewController.close(_:)))
        let rightButton = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UserRegisterViewController.login))
        
        self.navigationItem.leftBarButtonItem   = leftButton
        self.navigationItem.rightBarButtonItem  = rightButton
        self.title = "注册"
        //取tableview的背静颜色
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    }
    
    func initRegisterPage(){
        let xCenter = self.view.bounds.size.width/2
        let fWidth  = self.view.bounds.width * 0.8
        
        //let firstHight = 44 + 20
        
        //用户左边的提示
        let userNameLeft    = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        userNameLeft.textAlignment = NSTextAlignment.Center
        //userNameLeft.backgroundColor = UIColor.redColor()
        userNameLeft.text   = "账户"
        
        //用户名输入
        userName = UITextField(frame: CGRect(x: 0, y: 100, width: fWidth, height: 40))
        userName!.center             = CGPoint(x: xCenter, y: 100)
        userName!.keyboardType       = UIKeyboardType.Twitter
        userName!.borderStyle        = UITextBorderStyle.None
        userName!.textAlignment      = NSTextAlignment.Left
        userName!.clearButtonMode    = UITextFieldViewMode.WhileEditing
        userName!.returnKeyType      = UIReturnKeyType.Done
        userName!.placeholder        = "注册账户"
        userName!.leftView           = userNameLeft
        userName!.leftViewMode       = UITextFieldViewMode.Always
        
        userName!.delegate           = self
        userName!.backgroundColor    = UIColor.whiteColor()
        self.view.addSubview(userName!)
        
        
        
        //密码左边的提示
        let userPwdLeft = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        userPwdLeft.textAlignment  = NSTextAlignment.Center
        userPwdLeft.text           = "密码"
        
        
        let tool = setInputUIToolbar()
        //用户密码输入
        userPwd = UITextField(frame: CGRect(x: 0, y: 141, width: fWidth, height: 40))
        userPwd!.center             = CGPoint(x: xCenter, y: 141)
        userPwd!.keyboardType       = UIKeyboardType.NamePhonePad
        userPwd!.borderStyle        = UITextBorderStyle.None
        userPwd!.textAlignment      = NSTextAlignment.Left
        userPwd!.clearButtonMode    = UITextFieldViewMode.WhileEditing
        userPwd!.returnKeyType      = UIReturnKeyType.Done
        userPwd!.placeholder        = "注册密码"
        userPwd!.secureTextEntry    = true
        
        userPwd!.leftView           = userPwdLeft
        userPwd!.leftViewMode       = UITextFieldViewMode.Always
        
        //自定义工具栏
        userPwd!.inputAccessoryView = tool
        
        userPwd!.delegate = self
        userPwd!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(userPwd!)
        
        
        let userNickLeft = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        userNickLeft.textAlignment  = NSTextAlignment.Center
        userNickLeft.text           = "昵称"
        
        //账户昵称
        userNick = UITextField(frame: CGRect(x: 0, y: 141, width: fWidth, height: 40))
        userNick!.center             = CGPoint(x: xCenter, y: 182)
        userNick!.keyboardType       = UIKeyboardType.NamePhonePad
        userNick!.borderStyle        = UITextBorderStyle.None
        userNick!.textAlignment      = NSTextAlignment.Left
        userNick!.clearButtonMode    = UITextFieldViewMode.WhileEditing
        userNick!.returnKeyType      = UIReturnKeyType.Done
        userNick!.placeholder        = "用户名字"
        userNick!.leftViewMode       = UITextFieldViewMode.Always
        userNick!.leftView           = userNickLeft
        
        
        userNick!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(userNick!)
        
        //注册按钮
        regButton = UIButton(frame: CGRect(x: 0, y: 182, width: self.view.bounds.size.width * 0.7, height: 40))
        regButton!.center = CGPoint(x: xCenter, y: 223)
        regButton!.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        regButton!.setTitleColor(UIColor.brownColor(), forState: UIControlState.Highlighted)
    
        regButton!.setTitle("注册", forState: UIControlState.Normal)
        regButton!.addTarget(self, action: #selector(UserRegisterViewController.doRegUser(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(regButton!)
    }
    
    //TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //执行用户注册
    func doRegUser(button: UIButton){
        
        let _userName = userName?.text
        let _userPwd  = userPwd?.text
        let _userNick = userNick?.text
        
        if(_userName!.isEmpty){
            Toast("请输入注册用户")
            return
        }
        
        if(_userPwd!.isEmpty){
            Toast("请输入注册密码")
            return
        }
        
        if(_userNick!.isEmpty){
            Toast("请输入用户昵称")
            return
        }
    
//        print("\(_userName)")
//        print("\(_userPwd)")
//        print("\(_userNick)")

        //保存用户信息
        mUserTools.setValue("username", name: _userName!)
        mUserTools.setValue("userpwd", name: _userPwd!)
        
        close(button)
    }
    
    func setInputUIToolbar() -> UIToolbar {
        let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        
        let loginIn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        loginIn.setTitle("注册", forState: UIControlState.Normal)
        loginIn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        loginIn.setTitleColor(UIColor.brownColor(), forState: UIControlState.Highlighted)
        tool.addSubview(loginIn)
        
        let ok  = UIButton(frame: CGRect(x: self.view.frame.size.width - 60 , y: 0, width: 60, height: 40))
        ok.setTitle("Done", forState: UIControlState.Normal)
        ok.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        ok.setTitleColor(UIColor.brownColor(), forState: UIControlState.Highlighted)
        tool.addSubview(ok)
        //frame: CGRect(x: self.view.frame.size.width - 60 , y: 0, width: 60, height: 40)
        return tool
    }
    
    
    //跳到注册页
    func login(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //关闭
    func close(button: UIButton){
        self.dismissViewControllerAnimated(true) { () -> Void in
            //print("close")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

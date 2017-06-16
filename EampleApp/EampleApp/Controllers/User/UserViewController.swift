//
//  UserViewController.swift
//  movie
//
//  Created by midoks on 15/7/18.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import LocalAuthentication


class UserViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var _tableView: UITableView?
    var _isLogin: Bool?
    
    var _searchBar:UISearchBar?
    var _searchBarController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "我"
        
        _tableView              = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView!.dataSource  = self
        _tableView!.delegate    = self
        
        self.view.addSubview(_tableView!)
        
        _isLogin = false
        _isLogin = mUserTools.isLogin()
    }
    
    
    
    //视图重新显示时
    override func viewDidAppear(_ animated: Bool) {
        _isLogin = mUserTools.isLogin()
        if(_isLogin == true){
            _tableView!.reloadData()
        }
        
    }
    
    
    //    override func viewWillLayoutSubviews() {
    //        super.viewWillLayoutSubviews()
    //
    //        var nFrame = self.view.frame
    //        nFrame.size.width   = self.view.frame.height
    //        nFrame.size.height  = self.view.frame.width
    //
    //        _tableView  = UITableView(frame: nFrame, style: UITableViewStyle.Grouped)
    //        _tableView!.reloadData()
    //
    //        print(self.view.frame)
    //        print(nFrame)
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //tabview多少组
    func numberOfSections(in tableView: UITableView) -> Int {
        if _isLogin == true {
            return 4
        }
        return 1
    }
    
    //每组多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if _isLogin == true {
            
            if(0 == section){
                return 1
            }else if(1 == section){
                return 4
            }else if(2 == section){
                return 3
            }else if(3 == section){
                return 1
            }
        }
        return 1
    }
    
    //每行的数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        if( _isLogin != true ){
            cell.textLabel!.text = "登录"
        }else{
            cell.textLabel!.text = "测试"
            if(0 == indexPath.section){
                if( 0 == indexPath.row){
                    cell.textLabel!.text = "我的"
                    cell.imageView!.image = UIImage(named: "tabbar_me")
                    cell.imageView?.backgroundColor = UIColor.clear
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
            }else if(1 == indexPath.section){
                if( 0 == indexPath.row){
                    cell.textLabel!.text = "浏览记录"
                    cell.imageView!.image = UIImage(named: "tabbar_me")
                    cell.imageView?.backgroundColor = UIColor.clear
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }else if(1 == indexPath.row){
                    cell.textLabel!.text = "分享"
                    cell.imageView!.image = UIImage(named: "tabbar_me")
                    cell.imageView?.backgroundColor = UIColor.clear
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }else if(2 == indexPath.row){
                    cell.textLabel!.text = "意见反馈"
                    cell.imageView!.image = UIImage(named: "tabbar_me")
                    cell.imageView?.backgroundColor = UIColor.clear
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }else if(3 == indexPath.row){
                    cell.textLabel!.text = "关于我"
                    cell.imageView!.image = UIImage(named: "tabbar_me")
                    cell.imageView?.backgroundColor = UIColor.clear
                    cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                }
                
            }else if (indexPath.section == 2){
                
                if(0 == indexPath.row){
                    cell.textLabel?.textAlignment = NSTextAlignment.center
                    cell.textLabel?.text = "TouchID验证"
                }else if(1 == indexPath.row){
                    cell.textLabel?.textAlignment = NSTextAlignment.center
                    cell.textLabel?.text = "九宫格验证"
                }else if(2 == indexPath.row){
                    cell.textLabel?.textAlignment = NSTextAlignment.center
                    cell.textLabel?.text = "二维码识别"
                }
                
            }else if(indexPath.section == 3){
                if(0 == indexPath.row){
                    cell.textLabel?.textAlignment = NSTextAlignment.center
                    cell.textLabel?.textColor = UIColor.red
                    cell.textLabel?.text = "退出登录"
                }
            }
        }
        return cell
    }
    
    //table 点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if( _isLogin != true ){
            //登录
            let u = UserLoginViewController()
            let uNav = UINavigationController(rootViewController: u)
            self.present(uNav, animated: true, completion: nil)
        }else{
            
            if(0 == indexPath.section ){
                
                if( 0 == indexPath.row){
                    Toast("我的信息设置与查看", time:1.5)
                }
                
            }else if( 1 == indexPath.section){
                
                if(3 == indexPath.row){
                    let aboutMe = UserAboutMeViewController();
                    //self.tabBarController?.hidesBottomBarWhenPushed = true
                    self.tabBarController?.tabBar.isHidden = true
                    self.navigationController?.pushViewController(aboutMe, animated: true)
                    
                    
                }else{
                    Toast("自己开发撒!!!", time:1.5)
                }
                
            }else if(2 == indexPath.section){
                
                if(0 == indexPath.row){//TouchID验证功能
                    //Toast("TouchID验证功能")
                    let laContext = LAContext()
                    //失败次数
                    //laContext.maxBiometryFailures = 3
                    
                    laContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "通过Home键验证已有手机指纹", reply: { (success, error) -> Void in
                        
                        if(success){
                            self.noticeText("验证", text: "成功", time: 2.0)
                        }else{
                            self.noticeText("验证", text: "失败", time: 2.0)
                        }
                    })
                    
                }else if(1 == indexPath.row){
                    let u = UserSudokuViewController()
                    let uNav = UINavigationController(rootViewController: u)
                    self.present(uNav, animated: true, completion: nil)
                    
                }else if(2 == indexPath.row){
                    let u = UserQrcodeViewController()
                    let uNav = UINavigationController(rootViewController: u)
                    self.present(uNav, animated: true, completion: nil)
                }
                
                
            }else if( 3 == indexPath.section){
                
                if( 0 == indexPath.row ){
                    
                    let alert = UIAlertController(title: "", message: "你真的要退出账号？", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                    let yesAction = UIAlertAction(title: "是的", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                        
                        mUserTools.loginOut()
                        self._isLogin = mUserTools.isLogin()
                        self._tableView!.reloadData()
                    })
                    alert.addAction(cancelAction)
                    alert.addAction(yesAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
}

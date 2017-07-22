//
//  GsMeInfoViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/1/15.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsMeInfoViewController: GsViewController, UITableViewDataSource, UITableViewDelegate {

    
    var _tableView: UITableView?
    var _tableUserData:JSON?
    
    //第一个用户信息cell的高度
    let userHeadHeight = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.initView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func initData(){
        
        let userData =  UserModelList.instance().selectCurrentUser()
        let userInfo = userData["info"] as! String
        let userJsonData = JSON.parse(userInfo)
        self._tableUserData = userJsonData
        
    }
    
    func initView(){
        self.title = "个人信息"
        self.view.backgroundColor = UIColor.white
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    //Mark: - UITableViewDataSource -
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            return CGFloat(userHeadHeight)
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        cell.textLabel?.text = "text"
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                cell.textLabel?.text = "头像"
                
                let avatar_url  = self._tableUserData?["avatar_url"].stringValue
                let data:NSData? = MDCacheImageCenter.readCacheFromUrl(url: avatar_url!)
                
                let setting_myqr:UIImage?
                if data == nil {
                    setting_myqr = UIImage(named: "avatar_default")
                }else{
                    setting_myqr = UIImage(data: data! as Data)
                }
                
                let setting_myQrView = UIImageView(image: setting_myqr)
                setting_myQrView.layer.cornerRadius = 5
                setting_myQrView.frame = CGRect(x: self.view.frame.size.width - 50 - 30,  y: (CGFloat(userHeadHeight) - 50)/2, width: 50, height: 50)
                cell.addSubview(setting_myQrView)
                
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == 1 {
                
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
                cell.textLabel?.text = "名字"
                cell.detailTextLabel?.text = self._tableUserData?["name"].stringValue
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == 2 {
                
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
                cell.textLabel?.text = "登录名"
                cell.detailTextLabel?.text = self._tableUserData?["login"].stringValue
                //cell.accessoryType = .DisclosureIndicator
                
            } else if indexPath.row == 3 {
                
                cell.textLabel?.text = "我的二维码"
                let setting_myQR = UIImage(named: "setting_myQR")
                let setting_myQrView = UIImageView(image: setting_myQR)
                setting_myQrView.frame = CGRect(x: self.view.frame.size.width - setting_myQR!.size.width - 30,
                                                y: (CGFloat(44) - setting_myQR!.size.height)/2,
                                                width: setting_myQR!.size.width,
                                                height:setting_myQR!.size.height)
                cell.addSubview(setting_myQrView)
                
                cell.accessoryType = .disclosureIndicator
            } else {
                
                cell.textLabel?.text = "愿意接受工作"
                
                let touchID = UISwitch(frame: CGRect(x: self.view.frame.size.width-55, y: fabs(cell.frame.size.height-50), width: 50, height: 50))
                cell.addSubview(touchID)
                
                let hireable = self._tableUserData?["hireable"].stringValue
                if hireable == "true" {
                    touchID.isOn = true
                } else {
                    touchID.isOn = false
                }
                
            }
        } else if indexPath.section == 1{
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "公司"
                
                let v = self._tableUserData?["company"].stringValue
                if v == "" {
                    cell.detailTextLabel?.text = "无"
                }else{
                    cell.detailTextLabel?.text = v
                }
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "地址"
                
                let v = self._tableUserData?["location"].stringValue
                if v == "" {
                    cell.detailTextLabel?.text = "无"
                }else{
                    cell.detailTextLabel?.text = v
                }
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "邮件"
                
                let v = self._tableUserData?["email"].stringValue
                if v == "" {
                    cell.detailTextLabel?.text = "无"
                }else{
                    cell.detailTextLabel?.text = v
                }
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "博客"
                
                let v = self._tableUserData?["blog"].stringValue
                if v == "" {
                    cell.detailTextLabel?.text = "无"
                }else{
                    cell.detailTextLabel?.text = v
                }
                cell.accessoryType = .disclosureIndicator
                
            } else if indexPath.row == 4 {
                cell.textLabel?.text = "加入时间"
                
                let v = self._tableUserData?["created_at"].stringValue
                
                if v == "" {
                    cell.detailTextLabel?.text = "无"
                }else{
                    cell.detailTextLabel?.text = gitTime(time: v!)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.section == 0 {
    
            if indexPath.row == 3 {
                let qrcode = GsMeQrcodeViewController()
                self.push(v: qrcode)
            }
            
        } else {
            
        }
    }
    
}

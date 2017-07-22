//
//  MeViewController.swift
//  GitHubStar
//
//  Created by midoks on 15/11/30.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsMeViewController: GsHomeViewController {
    
    var _tableData = JSON.parse("")
    
    var _dropDownList:MDDropDownList?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.endRefresh()
        
        self.initData()
        self.initView()
        self.resetDropDownListData()
        
        let scanQrcode = GsMeScanQrcodeViewController()
        self.navigationController?.pushViewController(scanQrcode, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initData()
        self.initView()
        self.addDropDownView()
    }
    
    deinit {
        print("GsMeViewController deinit")
    }
    
    //初始化数据
    func initData(){
        
        if self.isLogin() {
            let userData =  UserModelList.instance().selectCurrentUser()
            let userInfo = userData["info"] as! String
            
            if !userInfo.isEmpty {
                let userJsonData = JSON.parse(userInfo)
                _tableData = userJsonData
                _tableView?.reloadData()
            }
        }
    }
    
    //初始化view
    func initView(){
        
        self.setAvatar(url: _tableData["avatar_url"].stringValue)
        _headView.iconClick = { ()->() in
            
            if !self.isLogin() {
                self.push(v: GsLoginViewController())
                return
            }
            
            let info = GsMeInfoViewController()
            self.push(v: info)
        }
        
        if _tableData["login"].stringValue != "" {
            self.setName(name: _tableData["login"].stringValue)
        } else {
            self.setName(name: "Login")
        }
        
        if _tableData["name"].stringValue != "" {
            self.setDesc(desc: _tableData["name"].stringValue)
        }
        
        self.initIconView()
    }
    
    func initIconView(){
        
        var v = Array<GsIconView>()
        let followers = GsIconView()
        
        if _tableData["followers"].stringValue == "" {
            followers.key.text = "0"
        } else {
            followers.key.text = _tableData["followers"].stringValue
        }
        
        followers.desc.text = sysLang(key: "Followers")
        v.append(followers)
        
        let following = GsIconView()
        
        
        if _tableData["following"].stringValue == "" {
            following.key.text = "0"
        } else {
            following.key.text = _tableData["following"].stringValue
        }
        following.desc.text = sysLang(key: "Following")
        v.append(following)
        self.setIconView(icon: v)
        
        var userName = sysLang(key: "Login")
        if isLogin() {
            userName = self.getUserName()
        }
        
        _headView.listClick = {(type) -> () in
            
            switch type {
            case 0:
                if !self.isLogin() {
                    self.push(v: GsLoginViewController())
                    return
                }
                let followers = GsUserListViewController()
                followers.title = self.sysLang(key: "Followers")
                followers.setUrlData(url: "/users/" + userName + "/followers")
                self.push(v: followers)
                break
                
            case 1:
                if !self.isLogin() {
                    self.push(v: GsLoginViewController())
                    return
                }
                let followers = GsUserListViewController()
                followers.title = self.sysLang(key: "Following")
                followers.setUrlData(url: "/users/" + userName + "/following")
                self.push(v: followers)
                break
            default:break
            }
        }
    }
    
    
    func addDropDownView(){
        
        let left = UIBarButtonItem(title: sysLang(key: "QR Code"), style: UIBarButtonItemStyle.plain, target: self, action:Selector(("goQrcode:")))
        self.navigationItem.leftBarButtonItem = left
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.listFunc))
        self.navigationItem.rightBarButtonItem  = rightButton
        
        _dropDownList = MDDropDownList(frame: self.view.frame)
        self._dropDownList?.navHeight = self.getNavBarHeight()
        
        _dropDownList?.add(icon: UIImage(named: "droplist_users")!, title: "账户管理")
        //_dropDownList?.add(UIImage(named: "droplist_projects")!, title: "创建项目")
        _dropDownList?.add(icon: UIImage(named: "droplist_sweep")!, title: sysLang(key: "Scan"))
        //_dropDownList?.add(UIImage(named: "droplist_follow")!, title: "关注")
        
        _dropDownList?.listClick = { (tag)->() in
            print(tag)
            return
            if tag == 0 {
                
                if !self.isLogin() {
                    self.push(v: GsLoginViewController())
                    return
                }
                
                let userList = GsMeListViewController()
                self.push(v: userList)
            } else if tag == 1 {
                
                if !self.isLogin() {
                    self.push(v: GsLoginViewController())
                    return
                }
                
                let scanQrcode = GsMeScanQrcodeViewController()
                self.push(v: scanQrcode)
            } else if tag == 2 {}
        }
    }
    
    func removeDropDownView(){
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem  = nil
    }
    
    //跳到二维码页面
    func goQrcode(button: UIButton){
        
    
        
//        if !self.isLogin() {
//            self.push(v: GsLoginViewController())
//            return
//        }
        
        let qrcode = GsMeQrcodeViewController()
        self.push(v: qrcode)
    }
    
    func listFunc(){
        _dropDownList?.showAnimation()
    }
    
    override func refreshUrl() {
        super.refreshUrl()
        if _tableData != JSON.null {
            updateCurrentUserData()
        }
    }
    
    func updateIconData(){
        
        self._headView.listIcon[0].key.text = _tableData["followers"].stringValue
        self._headView.listIcon[1].key.text = _tableData["following"].stringValue
    }
    
    func updateCurrentUserData(){
        self.clearCookie()
        GitHubApi.instance.user(callback: { (data, response, error) -> Void in
            self.endRefresh()
            
            if error == nil {
                let userData = String(data: data! as Data, encoding: String.Encoding.utf8)!
                
                let userDataSource =  UserModelList.instance().selectCurrentUser()
                let id = userDataSource["id"] as! Int
                
                _ = UserModelList.instance().updateInfoById(info: userData, id: id)
                self.initData()
                self.updateIconData()
            }
        })
    }
}

//MARK: - UITableViewDataSource && UITableViewDelegate -
extension GsMeViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 5
        } else if section == 3 {
            return 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }
        return 48
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel?.text = sysLang(key: "News")
                cell.imageView?.image = UIImage(named: "github_news")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = sysLang(key: "Notifications")
                cell.imageView?.image = UIImage(named: "github_notif")
            }
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                
                cell.imageView?.image = UIImage(named: "repo_stars")
                cell.textLabel?.text = sysLang(key: "Starred")
                
            } else if indexPath.row == 1 {
                
                cell.imageView?.image = UIImage(named: "repo_repos")
                cell.textLabel?.text = sysLang(key: "Repositories")
                
            } else if indexPath.row == 2 {
                
                cell.imageView?.image = UIImage(named: "repo_gists")
                cell.textLabel?.text = sysLang(key: "Gists")
                
            } else if indexPath.row == 3 {
                
                cell.imageView?.image = UIImage(named: "repo_organizations")
                cell.textLabel?.text = sysLang(key: "Organizations")
                
                
            } else if indexPath.row == 4 {
                cell.imageView?.image = UIImage(named: "repo_events")
                cell.textLabel?.text = sysLang(key: "Public activtiy")
                
            }
            cell.accessoryType = .disclosureIndicator
            
        } else {
            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: "github_setting")
                cell.textLabel?.text = sysLang(key: "Settings")
            }
            
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    //点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if !self.isLogin() {
            self.push(v: GsLoginViewController())
            return
        }
        
        let userName = self.getUserName()
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let event = GsEventsViewController()
                event.setUrlData(url: "/users/" + userName + "/received_events")
                self.push(v: event)
            } else if indexPath.row == 1 {
                let event = GsEventsViewController()
                event.setUrlData(url: "/users/" + userName + "/received_events")
                self.push(v: event)
            }
            
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let starred = GsRepoListViewController()
                starred.showAuthor = true
                starred.setUrlData(url: "/user/starred")
                self.push(v: starred)
            } else if indexPath.row == 1 {
                let repo = GsRepoListViewController()
                repo.setUrlData(url: "/user/repos")
                self.push(v: repo)
            } else if indexPath.row == 2 {
                let gists = GsGistsViewController()
                gists.hidesBottomBarWhenPushed = true
                gists.setUrlData(url: "/gists/starred")
                self.push(v: gists)
            } else if indexPath.row == 3 {
                let org = GsOrgListViewController()
                org.setUrlData(url: "/users/" + userName + "/orgs")
                self.push(v: org)
            } else if indexPath.row == 4 {
                let event = GsEventsViewController()
                event.setUrlData(url: "/users/" + userName + "/events")
                self.push(v: event)
            }
            
        } else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let setting = GsSettingViewController()
                self.push(v: setting)
            }
        }
    }
}

extension GsMeViewController {
    
    func resetDropDownListData(){
        self._dropDownList?.navHeight = self.getNavBarHeight()
        let root = self.getRootVC()
        self._dropDownList?.setViewFrame(frame: CGRect(x: 0, y: 0, width: root.view.frame.width, height: root.view.frame.height))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self._dropDownList?.hide()
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
        }) { (UIViewControllerTransitionCoordinatorContext) in
            
            self.resetDropDownListData()
        }

    }
    
}

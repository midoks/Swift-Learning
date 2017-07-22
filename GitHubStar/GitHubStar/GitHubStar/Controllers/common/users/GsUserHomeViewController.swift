//
//  GsAuthorViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/1/28.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

//Author Home Page
class GsUserHomeViewController: GsHomeViewController {
    
    var _tableData:JSON = JSON.parse("")
    var _fixedUrl = ""
    

    var asyn_get_userinfo = false
    var isfollow = false

    
    var _rightButton:GsUserHomeButton?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //GitHubApi.instance.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _rightButton = GsUserHomeButton()
        self.navigationItem.rightBarButtonItem  = _rightButton?.createButton(target: self)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.initView()
    }
    
    //初始化视图
    func initView(){
        
        if _tableData != nil {
            
            self.initHeadView()
            self.initHeadIconView()
        }
    }
    
    func initHeadView(){
        
        self.setAvatar(url: self._tableData["avatar_url"].stringValue)
        self.setName(name: _tableData["login"].stringValue)
        if _tableData["name"].stringValue != "" {
            self.setDesc(desc: _tableData["name"].stringValue)
        }
    }
    
    func initHeadIconView(){
        
        var v = Array<GsIconView>()
        
        let followers = GsIconView()
        followers.key.text = _tableData["followers"].stringValue
        followers.desc.text = sysLang(key: "Followers")
        v.append(followers)
        
        let following = GsIconView()
        following.key.text = _tableData["following"].stringValue
        following.desc.text = sysLang(key: "Following")
        v.append(following)
        
        self.setIconView(icon: v)
        
        _headView.listClick = {(type) -> () in
            
            switch type {
                
            case 0:
                let followers = GsUserListViewController()
                followers.title = self.sysLang(key: "Followers")
                followers.setUrlData(url: "/users/" + self._tableData["login"].stringValue + "/followers")
                self.push(v: followers)
                break
                
            case 1:
                let following = GsUserListViewController()
                following.title = self.sysLang(key: "Following")
                following.setUrlData(url: "/users/" + self._tableData["login"].stringValue + "/following")
                self.push(v: following)
                break
            default:break
            }
        }
    }
    
    func setUrlWithData(data:JSON){
        
        self.setAvatar(url: data["avatar_url"].stringValue)
        self.setName(name: data["login"].stringValue)
        _fixedUrl = "/users/" + data["login"].stringValue
    }
    
    override func refreshUrl() {
        super.refreshUrl()
        
            self.asyn_get_userinfo = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        if _fixedUrl != "" {
            self.startRefresh()
            GitHubApi.instance.urlGet(url: _fixedUrl) { (data, response, error) -> Void in
                self.endRefresh()
                
                if data != nil {
                    let _dataJson = self.gitJsonParse(data: data!)
                    self._tableData = _dataJson
                    self.initView()
                    self._tableView?.reloadData()
                    
                    self.checkUserStatus()
                }
                
                self.asyn_get_userinfo = false
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    func checkUserStatus(){
        
        if self.isLogin() {
            let url = self.getStatusUrl()
            GitHubApi.instance.webGet(absoluteUrl: url, callback: { (data, response, error) in
                if data != nil {
                    let rep = response as! HTTPURLResponse
                    let status = rep.allHeaderFields["Status"] as! String
                    
                    if status == "204 No Content" {
                        self.isfollow = true
                    } else {
                        self.isfollow = false
                    }
                }
            })
        }
    }
    
    func getStatusUrl() -> String {
        let userName = self._tableData["login"].stringValue
        let url = GitHubApi.instance.buildUrl( path: "/user/following/" + userName)
        return url
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource -
extension GsUserHomeViewController {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if _tableData.count == 0 {
            return 0
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
            return 0
        } else if section == 1 {
            return 4
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Events"
                cell.imageView?.image = UIImage(named: "repo_events")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Organizations"
                cell.imageView?.image = UIImage(named: "repo_organizations")
                
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Repositories"
                cell.imageView?.image = UIImage(named: "repo_repos")
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Gists"
                cell.imageView?.image = UIImage(named: "repo_gists")
            }
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let event = GsEventsViewController()
                event.setUrlData( url: "/users/" + self._tableData["login"].stringValue + "/events")
                self.push(v: event)
                
            } else if indexPath.row == 1 {
                
                let org = GsOrgListViewController()
                org.setUrlData(url: "/users/" + self._tableData["login"].stringValue + "/orgs")
                self.push(v: org)
                
            } else if indexPath.row == 2 {
                let repo = GsRepoListViewController()
                repo.setUrlData(url: "/users/" + self._tableData["login"].stringValue + "/repos")
                self.push(v: repo)
                
            } else if indexPath.row == 3 {
                
                let gist = GsGistsViewController()
                gist.setUrlData(url: "/users/" + self._tableData["login"].stringValue + "/gists")
                self.push(v: gist)
                
            }
            
        }
    }
}


class GsUserHomeButton: NSObject{
    
    var _target: GsUserHomeViewController?
    
    func createButton(target: GsUserHomeViewController) -> UIBarButtonItem {
        _target = target
        let button = UIButton()
        button.frame = CGRect(x:20.0, y:20.0, width: 30.0, height: 35.0)
        button.setImage(UIImage(named: "repo_share"), for: .normal)
        button.addTarget(self, action:Selector(("buttonTouched:")), for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    func buttonTouched(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if _target!.isfollow {
            let unfollow = UIAlertAction(title: "Unfollow", style: .default) { (UIAlertAction) in
                let url = self._target!.getStatusUrl()
                GitHubApi.instance.delete(url: url, callback: { (data, response, error) in
                    if error == nil {
                        let rep = response as! HTTPURLResponse
                        let status = rep.allHeaderFields["Status"] as! String
                        if status == "204 No Content" {
                            self._target!.isfollow = false
                            self._target!.showTextWithTime(msg: "SUCCESS", time: 2)
                        } else {
                            self._target!.isfollow = true
                            self._target!.showTextWithTime(msg: "FAIL", time: 2)
                        }
                    }
                })
                
            }
            alert.addAction(unfollow)
            
        } else {
            let follow = UIAlertAction(title: "Follow", style: .default) { (UIAlertAction) in
                let url = self._target!.getStatusUrl()
                GitHubApi.instance.put(url: url, callback: { (data, response, error) in
                    if error == nil {
                        let rep = response as! HTTPURLResponse
                        let status = rep.allHeaderFields["Status"] as! String
                        
                        if status == "204 No Content" {
                            self._target!.isfollow = true
                            self._target!.showTextWithTime(msg: "SUCCESS", time: 2)
                        } else {
                            self._target!.isfollow = false
                            self._target!.showTextWithTime(msg: "FAIL", time: 2)
                        }
                    }
                })
            }
            alert.addAction(follow)
        }
        
        
        let cancal = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        alert.addAction(cancal)
        
        _target!.present(alert, animated: true) {
            
        }
    }
}

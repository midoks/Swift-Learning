//
//  GsOrgHomeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/16.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsOrgHomeViewController: GsHomeViewController {
    
    var _tableData:JSON?
    var _fixedUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initView(){
        
        if _tableData != nil {
            self.setAvatar(url: _tableData!["avatar_url"].stringValue)
            self.setName(name: _tableData!["login"].stringValue)
            
            if _tableData!["description"].stringValue != "" {
                self.setDesc(desc: _tableData!["description"].stringValue)
            }
        }
    }
    
    func updateData(){
        
        self.startRefresh()
        
        GitHubApi.instance.webGet(absoluteUrl: _fixedUrl) { (data, response, error) in
            self.endRefresh()
            
            if data != nil {
                
                let _dataJson = self.gitJsonParse(data: data!)
                self._tableData = _dataJson
                self.initView()
                self._tableView?.reloadData()
                
                //print(self._tableData)
            }
        }
    }
    
    func setUrlData(data:JSON){
        //print(data)
        
        self.setAvatar(url: data["avatar_url"].stringValue)
        self.setName(name: data["login"].stringValue)
        _fixedUrl = data["url"].stringValue
    }
    
    override func refreshUrl() {
        super.refreshUrl()
        
        if _fixedUrl != "" {
            updateData()
        }
    }
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource -
extension GsOrgHomeViewController {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if _tableData ==  nil {
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
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Members"
                cell.imageView?.image = UIImage(named: "repo_assigned")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Teams"
                cell.imageView?.image = UIImage(named: "repo_organizations")
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Events"
                cell.imageView?.image = UIImage(named: "repo_events")
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Repositories"
                cell.imageView?.image = UIImage(named: "repo_repos")
            }
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let member = GsUserListViewController()
                member.setUrlData( url: "/orgs/" + self._tableData!["login"].stringValue + "/members")
                self.push(v: member)
            } else if indexPath.row == 1 {
                
            } else if indexPath.row == 2 {
                let event = GsEventsViewController()
                event.setUrlData(url: "/orgs/" + self._tableData!["login"].stringValue + "/events")
                self.push(v: event)
            } else if indexPath.row == 3 {
                let repo = GsRepoListViewController()
                repo.setUrlData(url: "/orgs/" + self._tableData!["login"].stringValue + "/repos")
                self.push(v: repo)
            }
        }
    }
}

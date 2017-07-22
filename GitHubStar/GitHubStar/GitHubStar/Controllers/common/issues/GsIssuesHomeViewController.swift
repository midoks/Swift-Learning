//
//  GsIssuesHomeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/3.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsIssuesHomeViewController: GsHomeViewController {
    
    var _resultData:JSON?
    var _participantsData = Array<JSON>()
    var _commentData = Array<JSON>()
    
    var _fixedUrl = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNotify()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotify()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initView(){
        if _resultData != nil {
            
            self.setAvatar(url: _resultData!["user"]["avatar_url"].stringValue)
            self.setName(name: _resultData!["title"].stringValue)
            self.setDesc(desc: _resultData!["updated_at"].stringValue)
            
            var v = Array<GsIconView>()
            
            let comments = GsIconView()
            comments.key.text = _resultData!["comments"].stringValue
            comments.desc.text = "Comments"
            v.append(comments)
            
            let participants = GsIconView()
            
            var num = Array<String>()
            for i in _participantsData {
                let id = i["actor"]["id"].stringValue
                if !num.contains(id) {
                    num.append(id)
                }
            }
            participants.key.text = String(num.count)
            participants.desc.text = "Participants"
            v.append(participants)
            
            self.setIconView(icon: v)
        }
    }
    
    func setUrlData(data:JSON){
        
        self.title = "#" + data["number"].stringValue
        self.setAvatar(url: data["user"]["avatar_url"].stringValue)
        self.setName(name: "Issues #" + data["number"].stringValue)
        _fixedUrl = data["url"].stringValue
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        if _fixedUrl != "" {
            
            self.startRefresh()
            GitHubApi.instance.webGet(absoluteUrl: _fixedUrl) { (data, response, error) -> Void in
                self.endRefresh()
                
                if data != nil {
                    self._resultData = self.gitJsonParse(data: data!)
                    self.reloadTable()
                }
            }
        }
    }
    
    func reloadTable(){
        
        initView()
        
        _tableView?.reloadData()
        if _resultData!["body"].stringValue != "" {
            _tableView?.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableViewRowAnimation.middle)
        }
        
        self.asynTask {
           self.postNotify()
        }
    }
    
}

extension GsIssuesHomeViewController {
    
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.initView()
    }
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsIssuesHomeViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if  _resultData != nil {
            return 3
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _resultData != nil {
            if section == 1 {
                if _resultData!["body"].stringValue == "" {
                    return 3
                }
                return 4
            } else if section == 2 {
                return  _commentData.count + 1
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if _resultData != nil {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    if _resultData!["body"].stringValue != "" {
                        let v = _resultData!["body"].stringValue
                        let size = v.textSizeWithFont(font: UIFont.systemFont(ofSize: 14),
                                                      constrainedToSize: CGSize(width : self.view.frame.width - 20, height: CGFloat.greatestFiniteMagnitude))
                        return size.height + 10
                    }
                    
                }
                
            } else if indexPath.section == 2 {
                
                if _commentData.count == indexPath.row {
                } else {
                    
                    let indexData = _commentData[indexPath.row];
                    let cell = GsUserCommentCell(style: .default, reuseIdentifier: nil)
                    let size = cell.getCommentSize(text: indexData["body"].stringValue)
            
                    return 45 + size.height
                }
            }
        }
        
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if _resultData != nil {
            
            if indexPath.section == 1 {
                
                var i:Int
                if _resultData!["body"].stringValue == "" {
                    i = indexPath.row + 1
                } else {
                    i = indexPath.row
                }
                
                if i == 0 {
                    
                    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    
                    cell.textLabel?.text = _resultData!["body"].stringValue
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                    cell.textLabel?.frame.size.width = self.view.frame.width
                    cell.textLabel?.numberOfLines = 0
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    
                    return cell
                    
                } else if i == 1 {
                    
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                    cell.textLabel?.text = "Assigned"
                    cell.imageView?.image = UIImage(named: "repo_assigned")
                    cell.detailTextLabel?.text = _resultData!["assignee"].stringValue == "" ? "Unassigned" : "assigned"
                    return cell
                } else if i == 2 {
                    
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                    cell.textLabel?.text = "Milestone"
                    cell.imageView?.image = UIImage(named: "repo_milestone")
                    let milestone = _resultData!["milestone"].count == 0 ? "No Milestone" : _resultData!["milestone"]["title"].stringValue
                    cell.detailTextLabel?.text = milestone
                    return cell
                } else if i == 3 {
                    
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                    cell.textLabel?.text = "Labels"
                    cell.imageView?.image = UIImage(named: "repo_labels")
                    cell.detailTextLabel?.text = _resultData!["labels"].count == 0 ? "None" : _resultData!["labels"][0]["name"].stringValue
                    return cell
                    
                }
                
            } else if indexPath.section == 2 {
                
                if _commentData.count == indexPath.row {
                
                    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                    cell.textLabel?.text = "Add Comment"
                    cell.imageView?.image = UIImage(named: "repo_pen")
                    cell.accessoryType = .disclosureIndicator
                    return cell
                    
                } else {
                    
                    let indexData = _commentData[indexPath.row]
                    
                    let cell = GsUserCommentCell(style: .default, reuseIdentifier: nil)
                    cell.userIcon.MDCacheImage(url: indexData["user"]["avatar_url"].stringValue, defaultImage: "avatar_default")
                    
                    cell.userName.text = indexData["user"]["login"].stringValue
                    cell.userCommentTime.text = gitNowBeforeTime(gitTime: indexData["updated_at"].stringValue)
                    cell.userCommentContent.text = indexData["body"].stringValue
                    
                    return cell
                }
            }
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "home"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
}

//MARK: - 通知相关方法 -
extension GsIssuesHomeViewController{
    
    func registerNotify(){
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: Selector(("getIssuesEvents:")), name: NSNotification.Name(rawValue: "getIssuesEvents"), object: nil)
        center.addObserver(self, selector: Selector(("getIssuesComments:")), name: NSNotification.Name(rawValue: "getIssuesComments"), object: nil)
        
    }
    
    func removeNotify(){
        
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: "getIssuesEvents"), object: nil)
        center.removeObserver(self, name: NSNotification.Name(rawValue: "getIssuesComments"), object: nil)
    }
    
    //添加通知
    func postNotify(){
        
        let center = NotificationCenter.default
        center.post(name: NSNotification.Name(rawValue: "getIssuesEvents"), object: nil)
        center.post(name: NSNotification.Name(rawValue: "getIssuesComments"), object: nil)
    }
    
    func getIssuesEvents(notify:NSNotification){
        
        let url = _resultData!["events_url"].stringValue
        _participantsData = Array<JSON>()
        
        GitHubApi.instance.webGet(absoluteUrl: url) { (data, response, error) -> Void in
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                for i in _dataJson {
                    self._participantsData.append(i.1)
                }
                self.initView()
            }
        }
    }
    
    func getIssuesComments(notify:NSNotification){
        
        let url = _resultData!["comments_url"].stringValue
        _commentData = Array<JSON>()
        
        GitHubApi.instance.webGet(absoluteUrl: url) { (data, response, error) -> Void in
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                for i in _dataJson {
                    self._commentData.append(i.1)
                }
                self._tableView?.reloadData()
            }
        }
    }
}

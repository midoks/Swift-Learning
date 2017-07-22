//
//  GsPullHomeViewController
//  GitHubStar
//
//  Created by midoks on 16/4/3.
//  Copyright © 2016年 midoks. All rights reserved.
//


//https://api.github.com/repos/midoks/GitHubStar/issues/8/events

import UIKit
import SwiftyJSON

class GsPullHomeViewController: GsHomeViewController {
    
    var _resultData:JSON?
    var _fixedUrl = ""
    
    var _commentData = Array<JSON>()
    
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
            
            let additions = GsIconView()
            additions.key.text = _resultData!["additions"].stringValue
            additions.desc.text = "Additions"
            v.append(additions)
            
            let deletions = GsIconView()
            deletions.key.text = _resultData!["deletions"].stringValue
            deletions.desc.text = "Deletions"
            v.append(deletions)
            
            let changes = GsIconView()
            changes.key.text = _resultData!["changed_files"].stringValue
            changes.desc.text = "Changes"
            v.append(changes)
            
            self.setIconView(icon: v)
            
        }
    }
    
    func setPullUrlData(data:JSON){
        
        self.title = "#" + data["number"].stringValue
        self.setAvatar(url: data["user"]["avatar_url"].stringValue)
        self.setName(name: "Pull Request #" + data["number"].stringValue)
        _fixedUrl = data["_links"]["self"]["href"].stringValue
    }
    
    func setIssueUrlData(data:JSON){
        
        self.title = "#" + data["number"].stringValue
        self.setAvatar(url: data["user"]["avatar_url"].stringValue)
        self.setName(name: "Pull Request #" + data["number"].stringValue)
        _fixedUrl = data["pull_request"]["url"].stringValue
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        if _fixedUrl != "" {
            self.startRefresh()
            GitHubApi.instance.webGet(absoluteUrl: _fixedUrl) { (data, response, error) -> Void in
                self.endRefresh()
                
                if data != nil {
                    self._resultData = self.gitJsonParse(data: data!)
                    self.initView()
                    self.reloadTable()
                }
            }
        }
        
    }
    
    func reloadTable(){
        _tableView?.reloadData()
        
        //print(_resultData)
        
        if _resultData!["body"].stringValue != "" {
            _tableView?.reloadRows(at: [IndexPath(row: 0, section: 1) ], with: UITableViewRowAnimation.middle)
        }
        
        self.postNotify()
    }
    
}

extension GsPullHomeViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.initView()
    }
    
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsPullHomeViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if _resultData != nil {
            return 4
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        
        if section == 1 {
            if _resultData!["body"].stringValue != "" {
                return 6
            }
            return 5
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return _commentData.count + 1
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if _resultData != nil {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    if _resultData!["body"].stringValue != "" {
                        //let v = _resultData!["body"].stringValue
                        //let size = v.textSize(UIFont.systemFont(ofSize: 14),constrainedToSize: CGSize(width: self.view.frame.width-10, height: CGFloat.max))
                        return  20
                    }
                }
                
            } else if indexPath.section == 2 {
            } else if indexPath.section == 3 {
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
        
        if _resultData != nil  {
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
                    cell.textLabel?.numberOfLines = 0
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                    return cell
                } else if i == 1 {
                    
                    let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                    
                    cell.row1.setImage(UIImage(named: "repo_setting"), for: .normal)
                    cell.row1.setTitle(_resultData!["state"].stringValue , for: .normal)
                    
                    cell.row2.setImage(UIImage(named: "repo_merge"), for: .normal)
                    
                    if _resultData!["merged_at"].stringValue == "" {
                        cell.row2.setTitle("Not Merged", for: .normal)
                    } else {
                        cell.row2.setTitle("Merged", for: .normal)
                    }
                    
                    return cell
                } else if i == 2 {
                    let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                    
                    cell.row1.setImage(UIImage(named: "repo_assigned"), for: .normal)
                    cell.row1.setTitle(_resultData!["user"]["login"].stringValue, for: .normal)
                    
                    cell.row2.setImage(UIImage(named: "repo_calendar"), for: .normal)
                    cell.row2.setTitle(self.gitTimeYmd(ctime: _resultData!["updated_at"].stringValue), for: .normal)
                    
                    return cell
                } else if i == 3 {
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                    cell.textLabel?.text = "Assigned"
                    cell.imageView?.image = UIImage(named: "repo_assigned")
                    cell.detailTextLabel?.text = _resultData!["assignee"].stringValue == "" ? "Unassigned" : "assigned"
                    cell.accessoryType = .disclosureIndicator
                    return cell
                } else if i == 4 {
                    
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                    cell.textLabel?.text = "Milestone"
                    cell.imageView?.image = UIImage(named: "repo_milestone")
                    cell.detailTextLabel?.text = _resultData!["milestone"].stringValue == "" ? "No Milestone" : _resultData!["milestone"].stringValue
                    cell.accessoryType = .disclosureIndicator
                    return cell
                } else if i == 5 {
                    
                    let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                    cell.textLabel?.text = "Labels"
                    cell.imageView?.image = UIImage(named: "repo_labels")
                    cell.detailTextLabel?.text = _resultData!["labels"].count == 0 ? "None" : _resultData!["labels"][0].stringValue
                    cell.accessoryType = .disclosureIndicator
                    return cell
                }
                
            } else if indexPath.section == 2 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Commits"
                    cell.imageView?.image = UIImage(named: "repo_commits")
                } else if indexPath.row == 1 {
                    cell.textLabel?.text = "Files"
                    cell.imageView?.image = UIImage(named: "repo_files")
                }
                
                cell.accessoryType = .disclosureIndicator
                
                return cell
            } else if indexPath.section == 3 {
                
                if indexPath.row == _commentData.count {
                    
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
        
        
        if indexPath.section == 2 {
            
            if indexPath.row == 0 {
            
                let url = _resultData!["commits_url"].stringValue
                let repoCommitMaster = GsCommitsListViewController()
                repoCommitMaster.setUrlData(url: url)
                self.push(v: repoCommitMaster)
            
            } else if indexPath.row == 1 {
            
                let file = GsPullFilesViewController()
                file.setUrlData(data: _resultData!)
                self.push(v: file)
            }
            
        }
    }
    
}



//MARK: - 通知相关方法 -
extension GsPullHomeViewController{
    
    func registerNotify(){
        //print("registerNotify")
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: Selector(("getPullEvents:"))
            , name: NSNotification.Name(rawValue: "getPullComments"), object: nil)
    }
    
    func removeNotify(){
        //print("removeNotify")
        
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: "getPullComments"), object: nil)
    }
    
    //添加通知
    func postNotify(){
        //print("postNotify")
        
        let center = NotificationCenter.default
        center.post(name: NSNotification.Name(rawValue: "getPullComments"), object: nil)
    }
    
    func getPullEvents(notify:NSNotification){
        
        let url = _resultData!["comments_url"].stringValue
        _commentData = Array<JSON>()
        
        GitHubApi.instance.webGet(absoluteUrl: url) { (data, response, error) -> Void in
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data:
                    data!)
                for i in _dataJson {
                    self._commentData.append(i.1)
                }
                self._tableView?.reloadData()
            }
        }
    }
}

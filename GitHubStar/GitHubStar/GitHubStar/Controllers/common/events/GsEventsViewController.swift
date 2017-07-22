//
//  GsEventsViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/17.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON


struct GsEventData {
    var title:String
    var list:Array<String>
    var listCount:Int = 0
    var content:String
}

class GsEventsViewController: GsListViewController {
    
    var current = NSDate()
    var List = Array<GsEventData>()

    override func viewDidLoad() {
        self.showSearch = false
        self.delegate = self
        
        super.viewDidLoad()
    }
    
    func updateData(){
        self.startPull()
        
        GitHubApi.instance.urlGet(url: _fixedUrl) { (data, response, error) -> Void in
            self.pullingEnd()
            self._tableData = Array<JSON>()
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                for i in _dataJson {
                    self._tableData.append(i.1)
                }
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    self.pageInfo  = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                }
            }
            self._tableView?.reloadData()
        }
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        if _fixedUrl != "" {
            updateData()
        }
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
    
}

extension GsEventsViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var default_h:CGFloat = 70
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        print(List.count)
        
        
        let cell = GsEventsCell(style: .default, reuseIdentifier: cellIdentifier)
        //let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        //        if indexData["type"].stringValue == "PushEvent" {
        //            let s = cell.getCommitHeight()
        //            default_h += s.height
        //        }
        if indexData["type"].stringValue == "CommitCommentEvent" {
            
            let v = UILabel(frame: CGRect.zero
            )
            v.text = indexData["payload"]["comment"]["body"].stringValue
            let size = cell.getSize(label: v)
            default_h += size.height
            
            if default_h > 140 {
                default_h = 140
            }
            
            
        } else if indexData["type"].stringValue == "CreateEvent"{
            
        } else if indexData["type"].stringValue == "DeleteEvent" {
        } else if indexData["type"].stringValue == "DeploymentEvent" {
        } else if indexData["type"].stringValue == "DeploymentStatusEvent" {
        } else if indexData["type"].stringValue == "DownloadEvent" {
        } else if indexData["type"].stringValue == "FollowEvent" {
        } else if indexData["type"].stringValue == "ForkEvent" {
        } else if indexData["type"].stringValue == "ForkApplyEvent" {
        } else if indexData["type"].stringValue == "GistEvent" {
            
        } else if indexData["type"].stringValue == "GollumEvent" {
            
            let c = indexData["payload"]["pages"].count * 15
            default_h += CGFloat(c)
            
        }else if indexData["type"].stringValue == "IssueCommentEvent" {
            
            //print("2")
            //print(indexData["payload"]["comment"]["body"].stringValue)
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["comment"]["body"].stringValue
            //print(v.text)
            let size = cell.getSize(label: v)
            default_h += size.height
            
            //default_h += 40
            //print(ceil(size.height))
            
        } else if indexData["type"].stringValue == "IssuesEvent" {
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["issue"]["title"].stringValue
            
            let size = cell.getSize(label: v)
            default_h += size.height
            
            
        } else if indexData["type"].stringValue == "MemberEvent"{
        } else if indexData["type"].stringValue == "MembershipEvent"{
        } else if indexData["type"].stringValue == "PageBuildEvent"{
        } else if indexData["type"].stringValue == "PublicEvent"{
            
        } else if indexData["type"].stringValue == "PullRequestEvent" {
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["pull_request"]["title"].stringValue
            let size = cell.getSize(label: v)
            default_h += size.height
            
        } else if indexData["type"].stringValue == "PullRequestReviewCommentEvent"{
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["comment"]["body"].stringValue
            let size = cell.getSize(label: v)
            default_h += size.height
            
        } else if indexData["type"].stringValue == "PushEvent" {
            
            let c = indexData["payload"]["commits"].count * 15
            default_h += CGFloat(c)
        } else if indexData["type"].stringValue == "ReleaseEvent"{
        } else if indexData["type"].stringValue == "RepositoryEvent"{
            
        } else if indexData["type"].stringValue == "StatusEvent"{
        } else if indexData["type"].stringValue == "TeamAddEvent"{
        } else if indexData["type"].stringValue == "WatchEvent" {
        }
        
        print(indexPath, default_h)
        
        
        return default_h
    }
}

extension GsEventsViewController:GsListViewDelegate {
    
    //event name
    private func actionName(type:String) -> String {
        //print(type)
        switch(type){
        case "CommitCommentEvent": return "CommitCommentEvent"
        case "CreateEvent": return "created branch"
        case "DeleteEvent": return "DeleteEvent"
        case "DeploymentEvent": return "DeploymentEvent"
        case "DeploymentStatusEvent": return "DeploymentStatusEvent"
        case "DownloadEvent": return "DownloadEvent"
        case "FollowEvent": return "FollowEvent"
        case "ForkEvent": return "ForkEvent"
        case "ForkApplyEvent": return "ForkApplyEvent"
        case "GistEvent": return "GistEvent"
        case "GollumEvent": return "GollumEvent"
        case "IssueCommentEvent": return "IssueCommentEvent"
        case "IssuesEvent": return "IssuesEvent"
        case "MemberEvent": return "MemberEvent"
        case "MembershipEvent": return "MembershipEvent"
        case "PageBuildEvent": return "PageBuildEvent"
        case "PublicEvent": return "PublicEvent"
        case "PullRequestEvent": return "PullRequestEvent"
        case "PullRequestReviewCommentEvent": return "PullRequestReviewCommentEvent"
        case "PushEvent": return "pushed to"
        case "ReleaseEvent": return "ReleaseEvent"
        case "RepositoryEvent": return "RepositoryEvent"
        case "StatusEvent": return "StatusEvent"
        case "TeamAddEvent": return "TeamAddEvent"
        case "WatchEvent": return "starred"
        default:return ""
        }
    }
    
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let indexData = self.getSelectTableData(indexPath: indexPath)
        let cell = GsEventsCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.authorIcon.MDCacheImage(url: indexData["actor"]["avatar_url"].stringValue, defaultImage: "avatar_default")
        cell.eventTime.text = gitNowBeforeTime(gitTime: indexData["created_at"].stringValue)
        
        let author = indexData["actor"]["login"].stringValue
        let repo = indexData["repo"]["name"].stringValue
        
        //List[indexPath.row].title = ""
        
        if indexData["type"].stringValue == "CommitCommentEvent" {
            
            //计算高度有问题
            var commitCommentEvent = author
            //commitCommentEvent +=  " commented on commit " + indexData["payload"]["comment"]["commit_id"].stringValue.substring(0, end: 5)
            commitCommentEvent +=  " in " + repo
            cell.actionContent.text = commitCommentEvent
            
            //let v = UILabel(frame: CGRectZero)
            //v.text = indexData["payload"]["comment"]["body"].stringValue
            //v.
            cell.nextContent.text = indexData["payload"]["comment"]["body"].stringValue
            
            List[indexPath.row].title = indexData["payload"]["comment"]["body"].stringValue
            
        } else if indexData["type"].stringValue == "CreateEvent"{
            
            var createEvent = author
            createEvent += " created " + indexData["payload"]["ref_type"].stringValue
            createEvent += " " + indexData["payload"]["ref"].stringValue + " in "
            createEvent += repo
            
            cell.actionContent.text = createEvent
        } else if indexData["type"].stringValue == "DeleteEvent"{
            
            var createEvent = author
            createEvent += " deleted " + indexData["payload"]["ref_type"].stringValue
            createEvent += " " + indexData["payload"]["ref"].stringValue
            createEvent += " " + repo
            
            cell.actionContent.text = createEvent
        } else if indexData["type"].stringValue == "DeploymentEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "DeploymentStatusEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "DownloadEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "FollowEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "ForkEvent" {
            
            var forkevent = author
            
            forkevent += " forked " + indexData["repo"]["name"].stringValue
            forkevent += " to " + indexData["payload"]["forkee"]["full_name"].stringValue
            
            cell.actionContent.text = forkevent
            
        } else if indexData["type"].stringValue == "ForkApplyEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "GistEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "GollumEvent" {
            
            var gollumEventContent = author
            gollumEventContent += " modified the wiki the in " + repo
            cell.actionContent.text = gollumEventContent
            
            for i in indexData["payload"]["pages"] {
                let v = i.1
                let msg = v["page_name"].stringValue + " - " + v["action"].stringValue
                let labelList = UILabel()
                labelList.text = msg
                cell.nextList.append(labelList)
            }
            cell.showList()
            
        } else if indexData["type"].stringValue == "IssueCommentEvent" {
            var issueCommentEvent = author
            
            if indexData["payload"]["issue"].count > 0 {
                issueCommentEvent += " commented on issue #"
            } else {
                issueCommentEvent += " commented on pull request #"
            }
            
            
            issueCommentEvent += indexData["payload"]["issue"]["number"].stringValue + " "
            issueCommentEvent += repo
            cell.actionContent.text = issueCommentEvent
            
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["comment"]["body"].stringValue
            cell.nextContent = v
            
        } else if indexData["type"].stringValue == "IssuesEvent" {
            var issueCommentEvent = author
            
            if indexData["payload"]["action"].stringValue == "reopened" {
                issueCommentEvent += " reopened issue #"
            } else if indexData["payload"]["action"].stringValue == "opened"{
                issueCommentEvent += " opened issue #"
            } else {
                issueCommentEvent += " closed issue #"
            }
            issueCommentEvent += indexData["payload"]["issue"]["number"].stringValue + " "
            issueCommentEvent += repo
            
            cell.actionContent.text = issueCommentEvent
            
            //print("1")
            //print(indexData["payload"]["comment"]["body"].stringValue)
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["issue"]["title"].stringValue
            cell.nextContent = v
            
            
        } else if indexData["type"].stringValue == "MemberEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "MembershipEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "PageBuildEvent" {
            print(indexData)
        } else if indexData["type"].stringValue == "PublicEvent" {
            
            
            print(indexData)
            
            
        } else if indexData["type"].stringValue == "PullRequestEvent" {
            
            var pullRequestEventContent = author
            
            if indexData["payload"]["action"].stringValue == "closed" {
                pullRequestEventContent += " " + "closed pull request"
            } else {
                pullRequestEventContent += " " + "opened pull request"
            }
            
            pullRequestEventContent += " #" + indexData["payload"]["number"].stringValue
            pullRequestEventContent += " " + repo
            cell.actionContent.text = pullRequestEventContent
            
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["pull_request"]["title"].stringValue
            cell.nextContent = v
            
        } else if indexData["type"].stringValue == "PullRequestReviewCommentEvent"{
            
            var pullRequestReviewCommentEvent = author
            pullRequestReviewCommentEvent += " commented on pull request in "
            pullRequestReviewCommentEvent += repo
            
            cell.actionContent.text = pullRequestReviewCommentEvent
            
            
            let v = UILabel(frame: CGRect.zero)
            v.text = indexData["payload"]["comment"]["body"].stringValue
            cell.nextContent = v
            
        } else if indexData["type"].stringValue == "PushEvent" {
            
            var content = author
            content += " " + actionName(type: indexData["type"].stringValue)
            
            let ref = indexData["payload"]["ref"].stringValue
            
            let refs = ref.components(separatedBy: "/")
            content += " " + refs[refs.count - 1]
            content += " " + repo
            cell.actionContent.text = content
            
            
            for _ in indexData["payload"]["commits"] {
                //let v = i.1
                //let msg = v["sha"].stringValue.substring(0, end: 5) + " - " + v["message"].stringValue.components(separatedBy: "\n\n")[0]
                let labelList = UILabel()
                labelList.text = "--"
                cell.nextList.append(labelList)
            }
            cell.showList()
        } else if indexData["type"].stringValue == "ReleaseEvent"{
            
            var releaseEvent = author
            releaseEvent += " published release"
            cell.actionContent.text = releaseEvent
            
        } else if indexData["type"].stringValue == "RepositoryEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "StatusEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "TeamAddEvent"{
            print(indexData)
        } else if indexData["type"].stringValue == "WatchEvent" {
            var content = author
            content += " " + actionName(type: indexData["type"].stringValue)
            
            let ref = indexData["payload"]["ref"].stringValue
            let refs = ref.components(separatedBy: "/")
            content += " " + refs[refs.count - 1]
            content += " " + repo
            cell.actionContent.text = content
            
            cell.actionContent.addLink(to: NSURL(string: "scheme://?type=1&business_id=2") as URL!, with: NSRange(location: 0, length: author.length))
        }
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        return false
    }
    
    func pullUrlLoad(url: String){
        
        GitHubApi.instance.webGet(absoluteUrl: url) { (data, response, error) -> Void in
            self.pullingEnd()
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                for i in _dataJson {
                    self._tableData.append(i.1)
                }
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
                
                self._tableView?.reloadData()
            }
        }
    }
}

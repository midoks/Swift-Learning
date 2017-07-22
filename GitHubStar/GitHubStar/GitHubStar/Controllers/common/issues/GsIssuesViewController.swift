//
//  GsIssuesViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/31.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsIssuesViewController: GsListViewController {
    
    var _segmentedControl:UISegmentedControl?
    var _buttomView:UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        _tableFooterHeight = 44
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        _tableFooterHeight = 44
        
        super.viewDidLoad()
        self.delegate = self
        self.title = "Issues"
        
        initSegmentedControl()
    }
    
    func initSegmentedControl(){
        
        //print(_tableFooterHeight)
        
        let items = ["Open", "Closed", "Mine", "Custom"]
        _segmentedControl = UISegmentedControl(items: items)
        _segmentedControl?.selectedSegmentIndex = 0
        _segmentedControl?.isMomentary = false
        _segmentedControl?.frame = CGRect(x: 5, y: 5, width: self.view.frame.width - 10, height: _tableFooterHeight - 10)
        _segmentedControl?.tintColor = UIColor.gray
        
        let textAttrs = NSMutableDictionary()
        textAttrs[NSForegroundColorAttributeName] = UIColor.white
        _segmentedControl?.setTitleTextAttributes(textAttrs as [NSObject : AnyObject], for: UIControlState.selected)
        _segmentedControl?.addTarget(self, action: Selector(("segmentDidchange:")), for: .valueChanged)
        
        
        _buttomView = UIView(frame: CGRect(x:0, y: self.view.frame.height-_tableFooterHeight, width: self.view.frame.width, height: _tableFooterHeight))
        _buttomView!.backgroundColor = UIColor.useColor(red: 245, green: 245, blue: 245)
        _buttomView!.addSubview(_segmentedControl!)
        
        self.view.addSubview(_buttomView!)
    }
    
    func segmentDidchange(segmented:UISegmentedControl){
        let v = segmented.selectedSegmentIndex

        //print(v,_fixedUrl)
        _tableView?.contentOffset.y = -60
        if v == 0 {
            reloadDataUrl(url: _fixedUrl + "?state=open")
        } else if v == 1 {
            _tableView?.scrollsToTop = true
            reloadDataUrl(url: _fixedUrl + "?state=closed")
        } else if v == 2 {
            
            if self.isLogin() {
                let userName = self.getUserName()
                reloadDataUrl( url: _fixedUrl + "?state=open&assignee=" + userName )
            } else {
                
                _tableData = Array<JSON>()
                _tableView?.reloadData()
            }
        }
    
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        reloadDataUrl(url: _fixedUrl)
    }
    
    func reloadDataUrl(url:String) {
        self.startPull()
        GitHubApi.instance.webGet(absoluteUrl: url, callback: { (data, response, error) -> Void in
            
            self.pullingEnd()
            self._tableData = Array<JSON>()
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                //print(_dataJson)
                for i in _dataJson {
                    self._tableData.append(i.1)
                }
                //print(response)
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    self.pageInfo = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                }
                
                self._tableView?.reloadData()
            }
        })
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
}

extension GsIssuesViewController{
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        _segmentedControl?.frame = CGRect(x: 5, y: 5, width: size.width - 10, height: _tableFooterHeight - 10)
        _buttomView?.frame = CGRect(x: 0, y: size.height-_tableFooterHeight, width: size.width, height: _tableFooterHeight)
    }

    
}

extension GsIssuesViewController {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
}
extension GsIssuesViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let cell = GsIssuesCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.issuesNumber.text = "#" + indexData["number"].stringValue
        cell.issuesTitle.text = indexData["title"].stringValue
        
        if indexData["pull_request"].count > 0 {
            cell.issuesType.text = "Pull"
        } else {
            cell.issuesType.text = "Issue"
        }
        
        cell.issuesIconList[0].title.text = indexData["state"].stringValue
        cell.issuesIconList[0].imageView.image = UIImage(named: "repo_setting")
        
        cell.issuesIconList[1].title.text = indexData["comments"].stringValue + " comments"
        cell.issuesIconList[1].imageView.image = UIImage(named: "repo_comment")
        
        
        if indexData["assignee"].count > 0  {
            cell.issuesIconList[2].title.text = indexData["assignee"]["login"].stringValue
        } else {
            cell.issuesIconList[2].title.text = "unassignee"
        }
        cell.issuesIconList[2].imageView.image = UIImage(named: "repo_author_min")
        
        cell.issuesIconList[3].title.text = self.gitNowBeforeTime(gitTime: indexData["updated_at"].stringValue)
        cell.issuesIconList[3].imageView.image = UIImage(named: "repo_pen")
        
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        //print(indexData)
        if indexData["pull_request"].count > 0 { //Pull
            let v = GsPullHomeViewController()
            v.setIssueUrlData(data: indexData)
            self.push(v: v)
        } else { //Issue
            let v = GsIssuesHomeViewController()
            v.setUrlData(data: indexData)
            self.push(v: v)
        }
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let v = data["title"].stringValue.lowercased()
        if v.contains(searchKey.lowercased()) {
            return true
        }
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

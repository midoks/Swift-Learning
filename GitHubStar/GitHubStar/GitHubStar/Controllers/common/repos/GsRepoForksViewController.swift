//
//  GsRepoForksViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/13.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsRepoForksViewController: GsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        self.startPull()
        GitHubApi.instance.urlGet(url: _fixedUrl) { (data, response, error) -> Void in
            self.pullingEnd()
            if data != nil {
                
                let _dataJson = self.gitJsonParse(data: data!)
                for i in _dataJson {
                    self._tableData.append(i.1)
                }
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    self.pageInfo = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                }
                
                self._tableView!.reloadData()
            }
        }
    }

    func setUrlData(url:String){
        _fixedUrl = url
    }
    
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsRepoForksViewController{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GsRepoJCell
        let cell = GsRepoJCell(style: .default, reuseIdentifier: cellIdentifier)
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as? GsRepoJCell
        
        var h = cell.frame.height
        
        let indexData = self._tableData[indexPath.row]
        let s = indexData["description"].stringValue
        let size = cell.setDesc(text: s)
        let rh = size.height
        h = h + rh
        
        return h
    }
}

extension GsRepoForksViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = GsRepoJCell(style: .default, reuseIdentifier: cellIdentifier)
        
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        cell.repoIcon.MDCacheImage(url: indexData["owner"]["avatar_url"].stringValue, defaultImage: "avatar_default")
        
        cell.repoName.text = indexData["name"].stringValue
        cell.repoCreateTime.text = "create at:" + gitTime(time: indexData["created_at"].stringValue)
        cell.repoUpdateTime.text = "update at:" + gitTime(time: indexData["updated_at"].stringValue)
        
        //desc show
        let desc = indexData["description"].stringValue
        _ = cell.setDesc(text: desc)
        
        let stargazers_count = indexData["stargazers_count"].stringValue
        let stargazers = UIButton()
        stargazers.setTitle(stargazers_count, for: .normal)
        stargazers.setImage(UIImage(named: "repo_stars_min"), for: .normal)
        cell.addList(i: stargazers)
        
        let forks_count = indexData["forks_count"].stringValue
        let forks = UIButton()
        forks.setTitle(forks_count, for: .normal)
        forks.setImage(UIImage(named: "repo_branch_min"), for: .normal)
        cell.addList(i: forks)
        
        let owner = indexData["owner"]["login"].stringValue
        let author = UIButton()
        author.setTitle(owner, for: .normal)
        author.setImage(UIImage(named: "repo_author_min"), for: .normal)
        cell.addList(i: author)
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let indexData = self.getSelectTableData(indexPath: indexPath)
        let repo = GsRepoDetailViewController()
        repo.setUrlWithData(data: indexData)
        self.push(v: repo)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let login = data["name"].stringValue.lowercased()
        if login.contains(searchKey.lowercased()) {
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
            } else {
                print("error")
            }
        }
        
    }
}

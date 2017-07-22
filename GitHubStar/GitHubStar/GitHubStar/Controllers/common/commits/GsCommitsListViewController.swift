//
//  GsRepoCommitsListViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsCommitsListViewController: GsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        self.startPull()
        GitHubApi.instance.webGet(absoluteUrl: _fixedUrl, callback: { (data, response, error) -> Void in
            
            self.pullingEnd()
            self._tableData = Array<JSON>()
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
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

extension GsCommitsListViewController{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var h:CGFloat = 50
        let indexData = self.getSelectTableData(indexPath: indexPath)
        let msg = indexData["commit"]["message"].stringValue.components(separatedBy: "\n")
        if msg[0] != "" {
            let cell = GsGistsCell(style: .default, reuseIdentifier: cellIdentifier)
            let size = cell.getDescSize(text: msg[0])
            
            h += size.height
        }
        return h
    }
}

extension GsCommitsListViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let cell = GsCommitsCell(style: .default, reuseIdentifier: cellIdentifier)
        
        if indexData["author"]["avatar_url"].stringValue != "" {
            cell.imageView?.MDCacheImage(url: indexData["author"]["avatar_url"].stringValue, defaultImage: "github_default_28")
        }else {
            cell.imageView?.MDCacheImage(url: "", defaultImage: "github_default_28")
        }
        
        if indexData["commit"]["author"]["name"].stringValue != "" {
            cell.authorName.text = indexData["commit"]["author"]["name"].stringValue
        } else {
            cell.authorName.text = "Unknown"
        }
        cell.timeShow.text = self.gitNowBeforeTime(gitTime: indexData["commit"]["author"]["date"].stringValue)
        
        let msg = indexData["commit"]["message"].stringValue.components(separatedBy: "\n")
        if msg[0] != "" {
            cell.setDesc(text: msg[0])
        }
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let vc = GsCommitsHomeViewController()
        vc.setUrlData(data: indexData)
        self.push(v: vc)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let name = data["commit"]["author"]["name"].stringValue.lowercased()
        if name.contains(searchKey) {
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



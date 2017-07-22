//
//  GsGistsViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/17.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsGistsViewController: GsListViewController {
    
    var isStar = false
    
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
                
                self._tableView?.reloadData()
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    self.pageInfo = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                }
            }
        }
        
    }
    
    func setUrlData(url:String){
        if url == "/gists/starred" {
            isStar = true
        }
        _fixedUrl = url
    }
}

extension GsGistsViewController{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var h:CGFloat = 50
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        if indexData["description"].stringValue != "" {
            let cell = GsGistsCell(style: .default, reuseIdentifier: cellIdentifier)
            let size = cell.getDescSize(text: indexData["description"].stringValue)
            
            h += size.height
        }
        return h
    }
}


extension GsGistsViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        //print(indexData)
        let cell = GsGistsCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.imageView?.MDCacheImage(url: indexData["owner"]["avatar_url"].stringValue, defaultImage: "avatar_default")
        for i in indexData["files"] {
            cell.gistsName.text = i.0
        }
        //print(indexData["create_at"].stringValue)
        cell.timeShow.text = self.gitNowBeforeTime(gitTime: indexData["created_at"].stringValue)
        
        if indexData["description"].stringValue != "" {
            cell.setDesc(text: indexData["description"].stringValue)
        }
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let gsHome = GsGistsHomeViewController()
        gsHome.setUrlData(data: indexData)
        gsHome.isStar = isStar
        self.push(v: gsHome)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        
        for i in data["files"] {
            let keyWord = i.0
            if keyWord.lowercased().contains(searchKey.lowercased()) {
                return true
            }
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
                self._tableView?.reloadData()
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
            }
        }
    }
}

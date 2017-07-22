//
//  GsUsersViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/13.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsUserListViewController: GsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func updateData() {
        
        if _fixedUrl != "" {
            
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
                        self.pageInfo = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    }
                    
                    self._tableView?.reloadData()
                }
            }
        }
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        self.updateData()
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
}

extension GsUserListViewController:GsListViewDelegate {
    
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = GsUsersIconTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        let indexData = self.getSelectTableData(indexPath: indexPath)
        let url = indexData["avatar_url"].stringValue
        let login = indexData["login"].stringValue
        
        cell.imageView?.MDCacheImage(url: url, defaultImage: "avatar_default")
        cell.textLabel?.text = login
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let author = GsUserHomeViewController()
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        author.setUrlWithData(data: indexData)
        self.push(v: author)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let login = data["login"].stringValue.lowercased()
        
        if login.contains(searchKey.lowercased()) {
            return true
        }
        return false
    }
    
    func pullUrlLoad(url: String){
        //print(url)
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

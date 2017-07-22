//
//  GsOrgViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/17.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsOrgListViewController: GsListViewController {
    
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
                    let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
            }
        }
        
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
    
}

extension GsOrgListViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let cell = GsOrgIconTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.imageView?.MDCacheImage(url: indexData["avatar_url"].stringValue, defaultImage: "github_default_28")
        cell.textLabel?.text = indexData["login"].stringValue
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let orgHome = GsOrgHomeViewController()
        orgHome.setUrlData(data: indexData)
        self.push(v: orgHome)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        if data["login"].stringValue.lowercased().contains(searchKey.lowercased()) {
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
                self._tableView?.reloadData()
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
            } else {
                print("error")
            }
        }
        
    }
}

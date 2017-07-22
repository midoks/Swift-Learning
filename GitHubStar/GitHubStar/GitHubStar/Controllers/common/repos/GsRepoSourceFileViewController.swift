//
//  GsRepoSourceFileViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/15.
//  Copyright © 2016年 midoks. All rights reserved.
//
//#url:https://developer.github.com/v3/git/trees/#get-a-tree

import UIKit
import SwiftyJSON

class GsRepoSourceFileViewController: GsListViewController {
    
    
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
                for i in _dataJson["tree"] {
                    self._tableData.append(i.1)
                }
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
                
                self.asynTask(callback: { () -> Void in
                    self._tableView?.reloadData()
                })
            }
        })
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
    
    func setPathUrlData(url:String){
        _fixedUrl = url
    }
}

extension GsRepoSourceFileViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        if indexData["type"].stringValue == "tree" {
            cell.imageView?.image = UIImage(named: "repo_file")
            cell.textLabel?.text = indexData["path"].stringValue
        } else if indexData["type"].stringValue == "blob" {
            cell.imageView?.image = UIImage(named: "repo_gists")
            cell.textLabel?.text = indexData["path"].stringValue
        } else if indexData["type"] == "commit" {
            cell.imageView?.image = UIImage(named: "repo_gists")
            cell.textLabel?.text = indexData["path"].stringValue
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        if indexData["type"].stringValue == "tree" {
            let path = GsRepoSourceFileViewController()
            path.setPathUrlData(url: indexData["url"].stringValue)
            self.push(v: path)
        } else if indexData["type"].stringValue == "blob" {
            //TODO
            let code = GsRepoSourceCodeViewController()
            code.setUrlData(url: indexData["url"].stringValue)
            self.push(v: code)
        } else if indexData["type"].stringValue == "commit" {
            print("commit")
        }
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let name = data["path"].stringValue.lowercased()
        if name.contains(searchKey.lowercased()) {
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

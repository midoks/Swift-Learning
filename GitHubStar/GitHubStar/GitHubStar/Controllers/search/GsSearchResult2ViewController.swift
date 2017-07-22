//
//  GsSearchResult2ViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/10.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsSearchResult2ViewController: GsListViewController {
    
    var _keyWords:String?

    override func viewDidLoad() {
        self.showSearch = false
        
        super.viewDidLoad()
        self.delegate = self
    }
    
    func searchingKeyWords(keyWords:String){
        _keyWords = keyWords
    }
    
    func searchUrl(){
        
        self.startPull()
        let url = "/search/repositories?q=" + _keyWords! + "&sort=stars&order=desc"
        GitHubApi.instance.urlGet(url, callback: { (data, response, error) -> Void in
            self.pullingEnd()
            self._tableData = Array<JSON>()
            
            if data != nil {
                
                let _dataJson = self.gitJsonParse(data)
                
                for i in _dataJson["items"] {
                    self._tableData.append(i.1)
                }
                
                self._tableView!.reloadData()
                
            }
            
        })
    }
    
    
    override func refreshUrl(){
        
        self.startPull()
        
        GitHubApi.instance.urlGet(_fixedUrl) { (data, response, error) -> Void in
            self.pullingEnd()
            self._tableData = Array<JSON>()
            
            if data != nil {
                
                let _dataJson = self.gitJsonParse(data)
                for i in _dataJson {
                    self._tableData.append(i.1)
                }
                
                let rep = response as! NSHTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
                
                self.asynTask({ () -> Void in
                    self._tableView?.reloadData()
                })
            }
        }
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
        refreshUrl()
    }

}

extension GsSearchResult2ViewController:GsListViewDelegate {
    
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = GsUsersIconTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        
        let indexData = self.getSelectTableData(indexPath)
        let url = indexData["avatar_url"].stringValue
        let login = indexData["login"].stringValue
        
        cell.imageView?.MDCacheImage(url, defaultImage: "github_default_28")
        cell.textLabel?.text = login
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let author = GsUserHomeViewController()
        let indexData = self.getSelectTableData(indexPath)
        author.setUrlWithData(indexData)
        self.push(author)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let login = data["login"].stringValue.lowercaseString
        if login.containsString(searchKey.lowercaseString) {
            return true
        }
        return false
    }
    
    func pullUrlLoad(url: String){
        GitHubApi.instance.webGet(url) { (data, response, error) -> Void in
            self.pullingEnd()
            if data != nil {
                let _dataJson = self.gitJsonParse(data)
                //print(_dataJson)
                for i in _dataJson {
                    self._tableData.append(i.1)
                }
                self._tableView?.reloadData()
                
                let rep = response as! NSHTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
            } else {
                
                self.showAlertNotice("", msg: self.sysLang("network is not good!!!"), ok: {() -> Void in
                    
                })
            }
        }
        
    }
}

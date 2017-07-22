//
//  GsCommitsViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/27.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsCommitsViewController: GsListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func refreshUrl(){
        super.refreshUrl()
        
        self.startPull()
        GitHubApi.instance.webGet(absoluteUrl: _fixedUrl) { (data, response, error) -> Void in
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
    
    func setUrlData(url:String){
        _fixedUrl = url
    }

}

extension GsCommitsViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        let indexData = self.getSelectTableData(indexPath: indexPath)
        cell.textLabel?.text = indexData["name"].stringValue
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let list = _fixedUrl.components(separatedBy: "/")
        let repoAddr = list[4] + "/" + list[5]
        
        var url = "/repos/" + repoAddr + "/commits?sha=" + indexData["name"].stringValue
        url = GitHubApi.instance.buildUrl(path: url)
        let file = GsCommitsListViewController()
        file.setUrlData(url: url)
        self.push(v: file)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let commit = data["name"].stringValue.lowercased()
        if commit.contains(searchKey.lowercased()) {
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
                
                //print(response)
                
                let rep = response as! HTTPURLResponse
                let link = rep.allHeaderFields["Link"] as! String
                if link != "" {
                    let r = self.gitParseLink(urlLink: link)
                    self.pageInfo = r
                }
                
                self._tableView?.reloadData()
            }
        }
        
    }
}

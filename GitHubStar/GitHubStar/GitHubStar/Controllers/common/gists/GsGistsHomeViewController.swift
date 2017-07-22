//
//  GsGistsHomeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/3.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsGistsHomeViewController: GsHomeViewController {
    
    var _tableData:JSON?
    
    var _fixedUrl = ""
    
    var _files = Array<JSON>()
    
    var _iconFiles = 1
    var _iconComments = 0
    var _iconForks = 0
    
    var isStar = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUrlData(data:JSON){
        
        self.setName( name: "Gist #" + data["id"].stringValue )
        self.setAvatar(url: data["owner"]["avatar_url"].stringValue)
        
        _fixedUrl = data["url"].stringValue
    }
    
    func initHeadIconView(){
        
        var v = Array<GsIconView>()
        
        let files = GsIconView()
        files.key.text = String(_iconFiles)
        files.desc.text = "Files"
        v.append(files)
        
        let comments = GsIconView()
        comments.key.text = String(_iconComments)
        comments.desc.text = "Comments"
        v.append(comments)
        
        let fork = GsIconView()
        fork.key.text = String(_iconForks)
        fork.desc.text = "Fork"
        v.append(fork)
        
        self.setIconView(icon: v)
    }
    
    override func refreshUrl() {
        super.refreshUrl()
        
        if _fixedUrl != "" {
            self.startRefresh()
            GitHubApi.instance.webGet(absoluteUrl: _fixedUrl, callback: { (data, response, error) in
                self.endRefresh()
                
                let _dataJson = self.gitJsonParse(data: data!)
                self._tableData = _dataJson
                self.reloadTableView()
            })
        }
    }
    
    func reloadTableView(){
        
        let name = _tableData!["owner"]["login"].stringValue
        let desc = _tableData!["description"].stringValue
        
        if name != "" {
            self.setName(name: name)
            self.setDesc(desc: desc)
        } else {
            self.setName(name: desc)
        }
        
        //files
        _iconFiles = _tableData!["files"].count
        _iconComments = _tableData!["comments"].count
        _iconForks = _tableData!["forks"].count
        
        for f in _tableData!["files"] {
            _files.append(f.1)
        }
        
        self.initHeadIconView()
        _tableView?.reloadData()
    }
}

extension GsGistsHomeViewController {
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if _tableData != nil {
            return 3
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 3
        } else if section == 2 {
            return _iconFiles
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                
                cell.row1.setImage(UIImage(named: "repo_access"), for: .normal)
                let v1 = _tableData!["public"].boolValue ? "Private" : "Public"
                cell.row1.setTitle(v1, for: .normal)
                
                cell.row2.setImage(UIImage(named: "repo_box"), for: .normal)
                cell.row2.setTitle("1 Revisions", for: .normal)
                return cell
                
            } else if indexPath.row == 1  {
                let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                
                cell.row1.setImage(UIImage(named: "repo_date"), for: .normal)
                let data = self.gitTimeYmd(ctime: _tableData!["updated_at"].stringValue)
                cell.row1.setTitle(data, for: .normal)
                
                cell.row2.setImage(UIImage(named: "github_starred"), for: .normal)
                let starStatus = isStar ? "Starred" : "Not Starred"
                cell.row2.setTitle(starStatus, for: .normal)
                return cell
                
            } else if indexPath.row == 2 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = "Owner"
                cell.imageView?.image = UIImage(named: "repo_owner")
                let name = _tableData!["owner"]["login"].stringValue == ""
                    ? "Unknown" : _tableData!["owner"]["login"].stringValue
                cell.detailTextLabel?.text = name
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        } else if indexPath.section == 2 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = _files[indexPath.row]["filename"].stringValue
            cell.imageView?.image = UIImage(named: "repo_source")
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.section == 1 {
            
            if indexPath.row == 2 {
                let name = _tableData!["owner"]["login"].stringValue
                if name != "" {
                    let author = GsUserHomeViewController()
                    author.setUrlWithData(data: _tableData!["owner"])
                    self.push(v: author)
                }
            }
            
        } else if indexPath.section == 2 {
            
            let code = GsGistsCodeViewController()
            code.setUrlData(data: _files[indexPath.row])
            self.push(v: code)
        }
    }
    
}

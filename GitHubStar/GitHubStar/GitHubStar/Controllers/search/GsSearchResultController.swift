//
//  GsSearchResultTableViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/1/22.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsSearchResultController: UIViewController {
    
    var _tableView: UITableView?
    var _tableData = Array<JSON>()
    
    private let cellIdentifier = "GsSearchResultCell"
    
    var _refreshView = UIRefreshControl()
    
    var pageInfo:GitResponseLink?

    var _keyWords:String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _tableView?.frame = self.view.frame
        _tableView?.frame.size.height += 44
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    func initView(){
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.plain)
        _tableView?.register(GsRepoJCell.self, forCellReuseIdentifier: cellIdentifier)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        self.view.addSubview(_tableView!)
        
        _tableView?.frame.size.height += 44
    }
    
    func searchingKeyWords(keyWords:String){
        _keyWords = keyWords
    }
    
    func clearSearchData(){
        _tableData.removeAll()
    }
    
    func searchUrl(){
        print(_keyWords)
        
        let url = "/search/repositories?q=" + _keyWords + "&sort=stars&order=desc"
        GitHubApi.instance.urlGet(url: url, callback: { (data, response, error) -> Void in
            self._tableData = Array<JSON>()
            if data != nil {
                self._tableData = Array<JSON>()
                let _dataJson = self.gitJsonParse(data: data!)
                
                for i in _dataJson["items"] {
                    self._tableData.append(i.1)
                }
                
                let rep = response as! HTTPURLResponse
                if rep.allHeaderFields["Link"] != nil {
                    let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                    self.pageInfo = r
                }
                self._tableView!.reloadData()
            }
            
        })
    }
    
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsSearchResultController:UITableViewDataSource, UITableViewDelegate{
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        return cell
    }

    
    @nonobjc public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _tableData.count > 0 {
            return _tableData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self._tableData.count > 0 {
            //let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GsRepoJCell
            let cell = GsRepoJCell(style: .default, reuseIdentifier:nil)
            //let cell = tableView.cellForRowAtIndexPath(indexPath) as? GsRepoJCell
            
            var h = cell.frame.height
            
            let indexData = self._tableData[indexPath.row]
            let s = indexData["description"].stringValue
            let size = cell.setDesc(text: s)
            let rh = size.height
            h = h + rh
            
            return h
        }
        return 44
    }
    
    @nonobjc public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        
        if self._tableData.count > 0 {
            
            let cell = GsRepoJCell(style: .default, reuseIdentifier: nil)
            
            let indexData = self._tableData[indexPath.row]
            
            cell.repoIcon.MDCacheImage(url: indexData["owner"]["avatar_url"].stringValue, defaultImage: "avatar_default")
            
            cell.repoName.text = indexData["name"].stringValue
            cell.repoCreateTime.text = "create at:" + gitTime(time: indexData["created_at"].stringValue)
            cell.repoUpdateTime.text = "update at:" + gitTime(time: indexData["updated_at"].stringValue)
            
            //desc show
            let desc = indexData["description"].stringValue
            _ = cell.setDesc(text: desc)
            
            //data show
            let stargazers_count = indexData["stargazers_count"].stringValue
            let stargazers = UIButton()
            stargazers.setTitle(stargazers_count, for: .normal)
            stargazers.setImage(UIImage(named: "repo_stars_min"), for: .normal)
            cell.addList(i: stargazers)
            
            let forks_count = indexData["forks_count"].stringValue
            let forks = UIButton()
            forks.setTitle(forks_count, for: .normal)
            forks.setImage(UIImage(named: "repo_branch_min"), for: .normal
            )
            cell.addList(i: forks)
            
            let owner = indexData["owner"]["login"].stringValue
            let author = UIButton()
            author.setTitle(owner, for: .normal)
            author.setImage(UIImage(named: "repo_author_min"), for: .normal)
            cell.addList(i: author)
            
            return cell
        } else {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
            cell.textLabel?.text = "点击搜索"
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if self._tableData.count > 0 {
            let indexData = self._tableData[indexPath.row]
            
            let repo = GsRepoDetailViewController()
            repo.setUrlWithData(data: indexData)
            repo.setSearchCloseButton()
            let repoNav = GsBaseNavViewController(rootViewController: repo)
            self.show(repoNav, sender: self)
        }
    }
}

extension GsSearchResultController{
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        _tableView?.frame.size = CGSize(width: size.width, height: size.height + 44)
        _tableView?.reloadData()
    }
}

extension GsRepoDetailViewController{
    
    func setSearchCloseButton(){
        
        let left = UIBarButtonItem(title: sysLang(key: "Cancel"), style: UIBarButtonItemStyle.plain, target: self, action: Selector(("dissmSearchCloseButton:")))
        self.navigationItem.leftBarButtonItem = left
        
    }
    
    func dissmSearchCloseButton(button: UIButton){
        self.dismiss(animated: true) { () -> Void in
        }
    }
}



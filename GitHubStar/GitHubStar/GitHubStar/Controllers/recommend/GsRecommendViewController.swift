//
//  RecommendViewController.swift
//  GitHubStar
//
//  Created by midoks on 15/11/30.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsRecommendViewController: UIViewController, GsRepoJCellDelegate {
    
    var _tableView: UITableView?
    var _tableData = Array<JSON>()
    var _tableRefreshData = Array<JSON>()
    
    let cellIdentifier = "RecommendCell"
    var _listData = ["torvalds/linux"]
    
    var _refreshControl = UIRefreshControl()
    var _progress: UIProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "Recommend")
        
        _listData.insert("php/php-src", at: 1)
        _listData.insert("golang/go", at: 2)
        _listData.insert("apple/swift", at: 3)
        _listData.insert("cocos2d/cocos2d-x", at: 4)
        _listData.insert("rails/rails", at: 5)
        _listData.insert("mackyle/sqlite", at: 6)
        _listData.insert("antirez/redis", at: 7)
        
        _listData.insert("nodejs/node", at: 8)
        _listData.insert("apache/tomcat", at: 9)
        _listData.insert("jquery/jquery", at: 10)
        
        initTable()
        initRefreshControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let root = self.getRootVC()
        self._tableView?.frame = root.view.frame
    }
    
    
    func getNavBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if _refreshControl.isRefreshing {
            _refreshControl.endRefreshing()
        }
        
        //"打分提示"功能
        MDAppNotice.singleton().setAppId(appId: "1078637806")
        MDAppNotice.singleton().setDebug(status: false)
        MDAppNotice.singleton().setDaysUnitilPormpt(daysUnitilPormpt: 1)
        MDAppNotice.singleton().setTimeBeforeReminding(timeBeforeReminding: 1)
        MDAppNotice.singleton().appLaunched()
    }
    
    //Mark: - 初始化数据 -
    func initData(){
        
        
        
    }
    
    //Mark: - 初始化table -
    func initTable(){
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.plain)
        _tableView?.register(GsRepoJCell.self, forCellReuseIdentifier: cellIdentifier)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        self.view.addSubview(_tableView!)
        
        //let status = MDGitHubWait(frame: self.view.frame)
        //self.view.addSubview(status)
        
        _progress = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
        _progress!.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: 0.5)
        _progress!.progress = 0
        _progress!.isHidden = false
        self.view.addSubview(_progress!)
        
        print("12312")
    }
    
    func initRefreshControl(){
        
        _refreshControl.tintColor = UIColor.gray
        _refreshControl.addTarget(self, action: #selector(self.refreshControlData), for: UIControlEvents.valueChanged)
        _tableView!.addSubview(_refreshControl)
        
        refreshData()
    }
    
    func refreshControlData(){
        _refreshControl.beginRefreshing()
        _tableRefreshData = Array<JSON>()
        initData()
    }
    
    func refreshData(){
        
        if !_refreshControl.isRefreshing {
            _refreshControl.beginRefreshing()
            _tableView?.contentOffset.y -= 60
            _tableRefreshData = Array<JSON>()
            
            self.asynTask { () -> Void in
                self.getAsynData(pos: 0)
            }
        }
        getUrlData()
    }
    
    func getUrlData(){
        //Github.instance.get(url: "https://api.github.com/repos/torvalds/linux", callback: <#(NSData?, URLResponse?, NSError?) -> Void#>)
    }
    
    
    //MARK: - 获取异步数据 -
    func getAsynData(pos:Int){
        
        if pos >= self._listData.count {
            return;
        }
        
        print(self._listData[pos])
        GitHubApi.instance.getRepo(name: self._listData[pos]) { (data) in
            
           
            if (data.null != nil) {
                self._tableRefreshData.append(data)
            }
            let ii = pos + 1
            
            self._progress!.progress = Float(CGFloat(ii)/CGFloat(self._listData.count))
            if ii >= self._listData.count {
                
                self._progress!.progress = 0
                //fix: large memory changes
                if self._tableRefreshData != self._tableData {
                    self._tableData = self._tableRefreshData
                    self._tableView?.reloadData()
                }
                
                self._refreshControl.endRefreshing()
                return;
            }
            
            self.getAsynData(pos: ii)
        }        
    }
    
    //MARK: - GsRepoJCellDelegate -
    func GsRepoJCellRepoIcon(indexPath: NSIndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        let GsAuthor = GsUserHomeViewController()
        self.push(v: GsAuthor)
    }
    
}

//Mark: - UITableViewDataSource && UITableViewDelegate{ -
extension GsRecommendViewController: UITableViewDataSource, UITableViewDelegate{
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self._tableData.count > 0 {
            return self._tableData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GsRepoJCell
        let cell = GsRepoJCell(style: .default
            
            , reuseIdentifier: cellIdentifier)
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as? GsRepoJCell
        
        var h = cell.frame.height
        
        let indexData = self._tableData[indexPath.row]
        let s = indexData["description"].stringValue
        let size = cell.setDesc(text: s)
        let rh = size.height
        h = h + rh
        
        return h
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! GsRepoJCell
        let cell = GsRepoJCell(style: .default, reuseIdentifier: cellIdentifier)
        
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
        forks.setImage(UIImage(named: "repo_branch_min"), for: .normal)
        cell.addList(i: forks)
        
        let watchers_count = indexData["subscribers_count"].stringValue
        let watchers = UIButton()
        watchers.setTitle(watchers_count, for: .normal)
        watchers.setImage(UIImage(named: "repo_watch_min"), for: .normal)
        cell.addList(i: watchers)
        
        let owner = indexData["owner"]["login"].stringValue
        let author = UIButton()
        author.setTitle(owner, for: .normal)
        author.setImage(UIImage(named: "repo_author_min"), for: .normal)
        cell.addList(i: author)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let indexData = self._tableData[indexPath.row]
        //print(indexData)

        let repo = GsRepoDetailViewController()//.instance()
        repo.setTableData(data: indexData)
        self.push(v: repo)
    }
}

extension GsRecommendViewController {
    
//    func canBecomeFirstResponder() -> Bool {
//        return true
//    }
//    
//    func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
//        refreshData()
//    }
}

extension GsRecommendViewController{
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self._tableView?.frame.size = size
        self._tableView?.reloadData()
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
        }) { (UIViewControllerTransitionCoordinatorContext) in
            self._progress!.frame = CGRect(x: 0, y: self.getNavBarHeight(), width: size.width, height: 0.5)
        }
    }
    
}

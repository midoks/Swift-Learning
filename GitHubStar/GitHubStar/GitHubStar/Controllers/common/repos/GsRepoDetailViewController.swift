//
//  GsRepoDViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/1/28.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON


//项目详情页
class GsRepoDetailViewController: GsHomeViewController {
    
    var _tableData:JSON = JSON.parse("")
    
    var _repoBranchNum = 1
    var _repoReadmeData:JSON = JSON.parse("")
    
    var _fixedUrl = ""
    
    var isStar = false
    var asynGetStar = false
    
    var _rightButton:GsRepoButton?
    
    deinit {
        print("deinit GsRepoDetailViewController")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotify()
        
        //GitHubApi.instance.close()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNotify()
        
        self.initView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _rightButton = GsRepoButton()
        self.navigationItem.rightBarButtonItem  = _rightButton?.createButton(target: self)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.initView()
    }
    
    func initShareButton(){
        print("test")
    }
    
    func initView(){
        
        if _tableData != nil {
            initHeadView()
            initHeadIconView()
        }
    }
    
    func initHeadView(){
        
        self.setAvatar(url: _tableData["owner"]["avatar_url"].stringValue)
        self.setName(name: _tableData["name"].stringValue)
        self.setDesc(desc: _tableData["description"].stringValue)
        
    }
    
    func initHeadIconView(){
        
        var v = Array<GsIconView>()
        
        let stargazerts = GsIconView()
        stargazerts.key.text = _tableData["stargazers_count"].stringValue
        stargazerts.desc.text = "Stargazers"
        v.append(stargazerts)
        
        let watchers = GsIconView()
        
        //let subscribers_count = _tableData["subscribers_count"].int
        watchers.key.text = _tableData["subscribers_count"].stringValue
        watchers.desc.text = "Watchers"
        v.append(watchers)
        
        let forks = GsIconView()
        forks.key.text = _tableData["forks_count"].stringValue
        forks.desc.text = "Forks"
        v.append(forks)
        self.setIconView(icon: v)
        
        _headView.listClick = {(type) -> () in
            
            switch type {
                
            case 0:
                let stargazers = GsUserListViewController()
                stargazers.title = self.sysLang(key: "Stargazerts")
                let url = "/repos/" + self._tableData["full_name"].stringValue + "/stargazers"
                stargazers.setUrlData(url: url)
                self.push(v: stargazers)
                break
                
            case 1:
                let watchers = GsUserListViewController()
                watchers.title = self.sysLang(key: "Watchers")
                //watchers_count
                watchers.setUrlData(url: "/repos/" + self._tableData["full_name"].stringValue + "/subscribers")
                self.push(v: watchers)
                break
                
            case 2:
                let forks = GsRepoForksViewController()
                forks.title = self.sysLang(key: "Forks")
                forks.setUrlData(url: "/repos/" + self._tableData["full_name"].stringValue + "/forks")
                self.push(v: forks)
                break
            default:break
            }
        }
    }
    
    //MARK: - Private Method -
    func setTableData(data:JSON){
        
        self.endRefresh()
        self._tableData = data
        self.initView()
        
        self.reloadData()
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
    
    func setUrlWithData(data:JSON){
        
        _fixedUrl = data["full_name"].stringValue
        //print(data["owner"]["avatar_url"].stringValue, data["name"].stringValue)
        self.setAvatar(url: data["owner"]["avatar_url"].stringValue)
        self.setName(name: data["name"].stringValue)
    }
    
    func setPUrlWithData(data:JSON){
        _fixedUrl = data["parent"]["full_name"].stringValue
        self.setAvatar(url: data["owner"]["avatar_url"].stringValue)
        self.setName(name: data["name"].stringValue)
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        if _fixedUrl != "" {
            self.startRefresh()
            
            GitHubApi.instance.getRepo(name: _fixedUrl, callback: { (data) in
                self.endRefresh()
                self._tableData = data
                self.initView()
                
                self.reloadData()
            })
        }
    }

    func reloadData(){
        
        self.asynTask {
            self._tableView?.reloadData()
            self.postNotify()
        }
        
    }
}

extension GsRepoDetailViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.initView()

    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource -
extension GsRepoDetailViewController {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if _tableData.count == 0 {
            return 0
        }
        
        if _tableData["homepage"].stringValue != "" {
            return 5
        }
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            
            var i1 = 4
            let v = self._tableData["parent"]
            if v.count>0 {
                i1 += 1
            }
            return i1
            
        } else if section == 2 {
            var i2 = 1
            
            if self._tableData["has_issues"].boolValue || _tableData["open_issues"].intValue > 0 {
                i2 += 1
            }
            
            if self._tableData.count > 0 {
                i2 += 1
            }
            return i2
        } else if section == 3 {
            return 3
        } else if section ==  4{
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                
                cell.row1.setImage(UIImage(named: "repo_access"), for: .normal)
                let v1 = _tableData["private"].boolValue ? sysLang(key: "Private") : sysLang(key: "Public")
                cell.row1.setTitle(v1, for: .normal)
                
                cell.row2.setImage(UIImage(named: "repo_language"), for: .normal)
                
                let lang = _tableData["language"].stringValue == "" ? "N/A" : _tableData["language"].stringValue
                cell.row2.setTitle(lang, for: .normal)
                return cell
                
            } else if indexPath.row == 1 {
                let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                
                cell.row1.setImage(UIImage(named: "repo_issues"), for: .normal)
                cell.row1.setTitle(_tableData["open_issues"].stringValue + sysLang(key: " Issues"), for: .normal
                )
                
                cell.row2.setImage(UIImage(named: "repo_branch"), for: .normal)
                cell.row2.setTitle(String(_repoBranchNum) + sysLang(key: " Branches"), for: .normal)
                
                return cell
            } else if indexPath.row == 2 {
                let cell = GsRepo2RowCell(style: .default, reuseIdentifier: nil)
                
                cell.row1.setImage(UIImage(named: "repo_date"), for: .normal)
                
                let date = _tableData["created_at"].stringValue
                cell.row1.setTitle(gitTimeYmd(ctime: date), for: .normal)
                
                cell.row2.setImage(UIImage(named: "repo_size"), for: .normal)
                _ = _tableData["size"].float
                cell.row2.setTitle(gitSize(s: 1, i: _tableData["size"].int!), for: .normal)
                return cell
            } else if indexPath.row == 3 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = sysLang(key: "Owner")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell.imageView?.image = UIImage(named: "repo_owner")
                cell.detailTextLabel?.text = _tableData["owner"]["login"].stringValue
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 4 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.imageView?.image = UIImage(named: "repo_branch")
                cell.textLabel?.text =  sysLang(key: "Forked from")
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                
                cell.detailTextLabel?.text = _tableData["parent"]["owner"]["login"].stringValue
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            
        } else if indexPath.section == 2 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            if  indexPath.row == 0 {
                cell.textLabel?.text = sysLang(key: "Events")
                cell.imageView?.image = UIImage(named: "repo_events")
            } else {
                
                if _tableData["has_issues"].boolValue || _tableData["open_issues"].intValue > 0 {
                    
                    if indexPath.row == 1 {
                        cell.textLabel?.text = sysLang(key: "Issues")
                        cell.imageView?.image = UIImage(named: "repo_issues")
                    } else if indexPath.row == 2 {
                        cell.textLabel?.text = sysLang(key: "Readme")
                        cell.imageView?.image = UIImage(named: "repo_readme")
                    }
                    
                } else {
                    cell.textLabel?.text = sysLang(key: "Readme")
                    cell.imageView?.image = UIImage(named: "repo_readme")
                    
                }
                
            }
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        } else if indexPath.section == 3 {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Commits"
                cell.imageView?.image = UIImage(named: "repo_commits")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Pull Requests"
                cell.imageView?.image = UIImage(named: "repo_pullrequests")
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Source"
                cell.imageView?.image = UIImage(named: "repo_source")
            }
            
            cell.accessoryType = .disclosureIndicator
            return cell
        } else if indexPath.section == 4 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.imageView?.image = UIImage(named: "repo_website")
            cell.textLabel?.text = "Website"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            
            if indexPath.row == 3 {
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                
                let author = GsUserHomeViewController()
                author.setUrlWithData(data: _tableData["owner"])
                self.push(v: author)
            } else if indexPath.row == 4 {
                tableView.deselectRow(at: indexPath as IndexPath, animated: true)
                let forked_from = GsRepoDetailViewController()
                forked_from.setPUrlWithData(data: _tableData)
                self.push(v: forked_from)
                
            }
        } else {
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            
            if indexPath.section == 2 {
                let cell = tableView.cellForRow(at: indexPath as IndexPath)
                let cellText = cell?.textLabel?.text
                
                if cellText == sysLang(key: "Events") {
                    let event = GsEventsViewController()
                    event.setUrlData(url: "/repos/" + _tableData["full_name"].stringValue + "/events")
                    self.push(v: event)
                    
                } else if cellText == sysLang(key: "Issues") {
                    let issue = GsIssuesViewController()
                    let url = GitHubApi.instance.buildUrl(path: "/repos/" + _tableData["full_name"].stringValue + "/issues")
                    issue.setUrlData(url: url)
                    self.push(v: issue)
                    
                } else if cellText == sysLang(key: "Readme") {
                    let repoReadme = GsRepoReadmeViewController()
                    repoReadme.setReadmeData(data: _repoReadmeData)
                    self.push(v: repoReadme)
                }
            } else if indexPath.section == 3 {
                if indexPath.row == 0 {
                    
                    //go to commit list info page,if have only one branch.
                    //                    if _repoBranchNum == 1 {
                    //                        let repoCommitMaster = GsCommitsListViewController()
                    //                        let url = GitHubApi.instance().buildUrl("/repos/" + _tableData["full_name"].stringValue + "/commits?sha=master")
                    //                        repoCommitMaster.setUrlData(url)
                    //                        self.push(repoCommitMaster)
                    //                    } else { //go to commit branch page
                    
                    let repoCommits = GsCommitsViewController()
                    let url = GitHubApi.instance.buildUrl(path: "/repos/" + _tableData["full_name"].stringValue + "/branches")
                    repoCommits.setUrlData( url: url )
                    self.push(v: repoCommits)
                    //}
                    
                } else if indexPath.row == 1 {
                    
                    let repoPull = GsPullListViewController()
                    repoPull.setUrlData( url: "/repos/" + _tableData["full_name"].stringValue + "/pulls" )
                    
                    self.push(v: repoPull)
                } else if indexPath.row == 2 {
                    
                    let repoSource = GsRepoSourceViewController()
                    repoSource.setUrlData( url: "/repos/" + _tableData["full_name"].stringValue + "/branches" )
                    
                    self.push(v: repoSource)
                }
                
            } else if indexPath.section == 4 {
                
                if indexPath.row == 0 {
                    let url = _tableData["homepage"].stringValue
                    UIApplication.shared.openURL(NSURL(string: url)! as URL)
                }
            }
        }
    }
}

//MARK: - 通知相关方法 -
extension GsRepoDetailViewController{

    func registerNotify(){
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: Selector(("getRepoBranch:")), name: NSNotification.Name(rawValue: "getRepoBranch"), object: nil)
        center.addObserver(self, selector: Selector(("getRepoReadme:")), name: NSNotification.Name(rawValue: "getRepoReadme"), object: nil)
        center.addObserver(self, selector: Selector(("getRepoStarStatus:")), name: NSNotification.Name(rawValue: "getRepoStarStatus"), object: nil)
    }
    
    func removeNotify(){
        
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: "getRepoBranch"), object: nil)
        center.removeObserver(self, name: NSNotification.Name(rawValue: "getRepoReadme"), object: nil)
        center.removeObserver(self, name: NSNotification.Name(rawValue: "getRepoStarStatus"), object: nil)
    }
    
    //添加通知
    func postNotify(){
        
        let center = NotificationCenter.default
        center.post(name: NSNotification.Name(rawValue: "getRepoBranch"), object: nil)
        center.post(name: NSNotification.Name(rawValue: "getRepoReadme"), object: nil)
        
        if self.isLogin() {
            center.post(name: NSNotification.Name(rawValue: "getRepoStarStatus"), object: nil)
        }
    }
    
    
    //获取项目分支数据
    func getRepoBranch(notify:NSNotification){
        
        
        let branchValue = self._tableData["full_name"].stringValue
        let repoBranch = "/repos/" + branchValue + "/branches"
        //print(repoBranch)
        GitHubApi.instance.urlGet(url: repoBranch) { (data, response, error) -> Void in
            
            if data != nil {
                var count = self.gitJsonParse(data: data!).count
                if response != nil {
                    let rep = response as! HTTPURLResponse
                    if rep.allHeaderFields["Link"] != nil {
                        
                        let r = self.gitParseLink(urlLink: rep.allHeaderFields["Link"] as! String)
                        if r.lastPage != "" {
                            
                            let pageCount = r.lastNum - 1
                            
                            GitHubApi.instance.webGet(absoluteUrl: r.lastPage, callback: { (data, response, error) -> Void in
                                
                                if data != nil {
                                    count = pageCount*30 + self.gitJsonParse(data: data!).count
                                }
                                
                                self._repoBranchNum = count
                                self._tableView?.reloadData()
                                
                                self.asynIsLoadSuccessToEnableEdit()
                            })
                        }
                    } else {
                        
                        self._repoBranchNum = count
                        self._tableView?.reloadData()
                    }
                }
            }
        }
    }
    
    //get repo readme
    func getRepoReadme(notify:NSNotification){
        let repoReadme = "/repos/" + _tableData["full_name"].stringValue + "/readme"
        GitHubApi.instance.urlGet(url: repoReadme) { (data, response, error) -> Void in
            
            if data != nil {
                let _dataJson = self.gitJsonParse(data: data!)
                self._repoReadmeData = _dataJson
                self._tableView?.reloadData()
            }
        }
    }
    
    //get repo star status
    func getRepoStarStatus(notify:NSNotification){
        self.isStar = false
        self.asynGetStar = false
        
        let args = "/user/starred/" + _tableData["full_name"].stringValue
        let url = GitHubApi.instance.buildUrl(path: args)
        //print(url)
        GitHubApi.instance.webGet(absoluteUrl: url, callback: { (data, response, error) in
            self.asynGetStar = true
            self.asynIsLoadSuccessToEnableEdit()
            
            if data != nil {
                //print(response)
                let resp = response as! HTTPURLResponse
                if resp.statusCode == 204 {
                    if !self.isStar {
                        self.isStar = true
                        self.setStarStatus(status: true)
                    }
                }
            }
        })
    }
    
    func asynIsLoadSuccessToEnableEdit(){
        if (self.asynGetStar){
            MDTask.shareInstance.asynTaskFront(callback: {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            })
        }
    }
    
}

class GsRepoButton: NSObject {
    
    var _target: GsRepoDetailViewController?
    
    func createButton(target: GsRepoDetailViewController) -> UIBarButtonItem {
        _target = target
        let button = UIButton()
        button.frame = CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0)
        button.setImage(UIImage(named: "repo_share"), for: .normal)
        button.addTarget(self, action: Selector(("buttonTouched:")), for: UIControlEvents.touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    func buttonTouched(sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if _target!.isStar {
            
            let unstar = UIAlertAction(title: "Unstar This Repo", style: .default) { (UIAlertAction) in
                let args = "/user/starred/" + self._target!._tableData["full_name"].stringValue
                let url = GitHubApi.instance.buildUrl(path: args)
                GitHubApi.instance.delete(url: url, callback: { (data, response, error) in
                    
                    if data != nil {
                        let resp = response as! HTTPURLResponse
                        if resp.statusCode == 204 {
                            self._target?.isStar = false
                            self._target?.removeStarStatus()
                            self._target?.showTextWithTime(msg: "SUCCESS", time: 2)
                        } else {
                            self._target?.isStar = true
                            self._target?.showTextWithTime(msg: "FAIL", time: 2)
                        }
                    }
                    self._target!.asynIsLoadSuccessToEnableEdit()
                })
                
            }
            alert.addAction(unstar)
            
        } else {
            
            let star = UIAlertAction(title: "Star This Repo", style: .default) { (UIAlertAction) in
                let args = "/user/starred/" + self._target!._tableData["full_name"].stringValue
                let url = GitHubApi.instance.buildUrl(path: args)
                GitHubApi.instance.put(url: url, callback: { (data, response, error) in
                    
                    if data != nil {
                        let resp = response as! HTTPURLResponse
                        if resp.statusCode == 204 {
                            self._target?.isStar = true
                            self._target?.setStarStatus(status: true)
                            self._target?.showTextWithTime(msg: "SUCCESS", time: 2)
                        } else {
                            self._target?.isStar = false
                            self._target?.showTextWithTime(msg: "FAIL", time: 2)
                        }
                    }
                    self._target!.asynIsLoadSuccessToEnableEdit()
                })
            }
            alert.addAction(star)
        }
        
        let cancal = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
        }
        alert.addAction(cancal)
        
        _target!.present(alert, animated: true) {
            
        }
    }
}

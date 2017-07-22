//
//  GsCommitsHomeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/25.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsCommitsHomeViewController: GsHomeViewController {
    
    
    var _resultData:JSON?
    var _file = Array<Array<JSON>>()
    
    var _fixedUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView(){
        if _resultData != nil {
            
            self.setAvatar(url: _resultData!["author"]["avatar_url"].stringValue)
            
            let msg = _resultData!["commit"]["message"].stringValue
            let msgArr = msg.components(separatedBy: "\n")
            self.setName(name: msgArr[0])
            
            self.setDesc(desc: _resultData!["commit"]["committer"]["date"].stringValue)
            
            var v = Array<GsIconView>()
            
            let additions = GsIconView()
            additions.key.text = _resultData!["stats"]["additions"].stringValue
            additions.desc.text = "Additions"
            v.append(additions)
            
            let deletions = GsIconView()
            deletions.key.text = _resultData!["stats"]["deletions"].stringValue
            deletions.desc.text = "Deletions"
            v.append(deletions)
            
            let parents = GsIconView()
            parents.key.text = String(_resultData!["parents"].count)
            parents.desc.text = "Parents"
            v.append(parents)
            
            self.setIconView(icon: v)
        }
    }
    
    func  setUrlData(data:JSON)  {
        self.setAvatar(url: data["author"]["avatar_url"].stringValue)
        _fixedUrl = data["url"].stringValue
    }
    
    override func refreshUrl(){
        super.refreshUrl()
        
        if _fixedUrl != "" {
            self.startRefresh()
            GitHubApi.instance.webGet(absoluteUrl: _fixedUrl) { (data, response, error) -> Void in
                self.endRefresh()
                
                if data != nil {
                    self._resultData = self.gitJsonParse(data: data!)
                    self.reloadTable()
                }
            }
        }
    }
    
    func filterFileData(){
        let file = _resultData!["files"]
        var tmpFile = Array<String>()
        
        var k = Array<Array<JSON>>()
        var kk = Array<JSON>()
        for i in file {
            var iValue = i.1
            var tmpValue = iValue["filename"].stringValue.components(separatedBy: "/")
            _ = tmpValue.popLast()
            let fileName = "/" + tmpValue.joined(separator: "/").uppercased()
            
            if tmpFile.contains(fileName) {
                kk.append(iValue)
            } else {
                
                if tmpFile.count > 0 {
                    k.append(kk)
                }
                
                kk = Array<JSON>()
                iValue["dir"] = JSON(fileName)
                kk.append(iValue)
                
                tmpFile.append(fileName)
            }
        }
        _file = k
    }
    
    func reloadTable(){
        filterFileData()
        
        //print(_resultData)
        //print(_file)
        
        initView()
        _tableView?.reloadData()
    }
    
}

extension GsCommitsHomeViewController {
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.reloadTable()
        //_tableView?.reloadSectionIndexTitles()
    }
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsCommitsHomeViewController{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if  _resultData != nil {
            //print("_file:",_file.count)
            var r = 3
            if _file.count > 0 {
                r += _file.count
            }
            return r
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("section:",section)
        if _resultData != nil {
            if section == 0 {
                return 0
            } else if section == 1 {
                return 1
            } else if (section>1 && section<_file.count+2) {
                return  _file[section - 2].count
            }
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if _resultData != nil {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    let v = _resultData!["commit"]["message"].stringValue
                    if v != "" {
                        let h = v.textSize(font: UIFont.systemFont(ofSize: 14), width: self.view.frame.width - 20)
                        return h + 20
                    }
                }
            } else if indexPath.section == 2 {
            }
        }
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if _resultData != nil {
            
            if indexPath.section == 1 {
                
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = _resultData!["commit"]["message"].stringValue
                cell.textLabel?.numberOfLines = 0
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                return cell
            } else if (indexPath.section>1 && indexPath.section<_file.count+2) {
                let data = _file[indexPath.section - 2]
                
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "/" + data[indexPath.row]["filename"].stringValue
                //cell.textLabel?.font = UIFont.systemFontOfSize(12)
                cell.accessoryType = .disclosureIndicator
                
                return cell
                
            } else  {
                
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "Add Comment"
                cell.imageView?.image = UIImage(named: "repo_pen")
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "home"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
        } else if (indexPath.section>1 && indexPath.section<_file.count+2) {
            let data = _file[indexPath.section - 2][indexPath.row]
            
            let code = GsCommitsCodeViewController()
            code.setUrlData(data: data)
            self.push(v: code)
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
        } else if section == 1 {
        } else if (section>1 && section<_file.count+2) {
            let data = _file[section - 2]
            let root = self.getRootVC()
            let w = root.view.frame.width < root.view.frame.height
                ? root.view.frame.width : root.view.frame.height
            //此处有问题,w暂时取最小值
            let h = data[0]["dir"].stringValue.textSize(font: UIFont.systemFont(ofSize: 14), width: w)
            return h
            
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
        } else if section == 1 {
        } else if (section>1 && section<_file.count+2) {
            let data = _file[section - 2]
            return data[0]["dir"].stringValue
        }
        return ""
    }
    
}

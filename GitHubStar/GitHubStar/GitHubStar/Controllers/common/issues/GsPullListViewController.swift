
//
//  GsRepoPullViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/28.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsPullListViewController: GsListViewController {
    
    var _segmentedControl:UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.initSegmentedControl()
    }
    
    func initSegmentedControl(){
        
        let items = ["open", "closed"]
        _segmentedControl = UISegmentedControl(items: items)
        _segmentedControl?.selectedSegmentIndex = 0
        _segmentedControl?.addTarget(self, action: Selector(("segmentDidchange:")), for: .valueChanged)
        self.navigationItem.titleView = _segmentedControl
    }
    
    func segmentDidchange(segmented:UISegmentedControl){
        
        let v = segmented.selectedSegmentIndex
        
        _tableView?.contentOffset.y = -(self.getNavBarHeight())
        
        
        var url:String!
        if v == 0 {
            url = _fixedUrl + "?state=open"
        } else {
            url = _fixedUrl + "?state=closed"
        }
        self.refreshUrlFunc(url: url)
    }
    
    override func refreshUrl(){
        super.refreshUrl()

        
        var url:String!
        if _segmentedControl?.selectedSegmentIndex == 0 {
            url = _fixedUrl + "?state=open"
        } else if _segmentedControl?.selectedSegmentIndex == 1 {
            url = _fixedUrl + "?state=closed"
        } else {
            url = _fixedUrl + "?state=open"
        }
        self.refreshUrlFunc(url: url)
    }
    
    func refreshUrlFunc(url:String){
        self.startPull()
        GitHubApi.instance.urlGet(url: url) { (data, response, error) -> Void in
            self.pullingEnd()
            self._tableData = Array<JSON>()
            
            if data != nil {
                
                let _dataJson = self.gitJsonParse(data: data!)
                //print(_dataJson)
                for i in _dataJson {
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
        }
    }
    
    func setUrlData(url:String){
        _fixedUrl = url
    }
    
}

extension GsPullListViewController {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var h:CGFloat = 50
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let cell = GsRepoPullCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.pullName.text = indexData["title"].stringValue
        let size = cell.getSize(label: cell.pullName)
        
        if size.height > 18 {
            h += size.height - 18
        }
        
        return h
    }
}

extension GsPullListViewController:GsListViewDelegate {
    
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let cell = GsRepoPullCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.imageView?.MDCacheImage(url: indexData["user"]["avatar_url"].stringValue, defaultImage: "avatar_default")
        cell.setPullNameText(text: indexData["title"].stringValue)
        cell.timeShow.text = self.gitNowBeforeTime(gitTime: indexData["created_at"].stringValue)
        
        return cell
    }
    
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let indexData = self.getSelectTableData(indexPath: indexPath)
        
        let v = GsPullHomeViewController()
        v.setPullUrlData(data: indexData)
        self.push(v: v)
    }
    
    func applyFilter(searchKey:String, data:JSON) -> Bool {
        let title = data["title"].stringValue.lowercased()
        if title.contains(searchKey.lowercased()
            
            ) {
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

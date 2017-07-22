//
//  GsListViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/3/17.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsListViewController: UIViewController {
    
    var _tableView: UITableView?
    var _tableData = Array<JSON>()
    let cellIdentifier = "GsListCell"
    var _tableFooterHeight:CGFloat = 0
    
    var _tableSearchData = Array<JSON>()
    var _searchView = UISearchBar()
    var _searchValue = ""
    
    var _refreshView = UIRefreshControl()
    var _footerView = UIView()
    var _refreshing = false
    
    var _fixedUrl = ""
    var pageInfo:GitResponseLink?
    
    var delegate:GsListViewDelegate?
    
    var showSearch = true
    
    deinit {
        print("GsListViewController deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.resetView()
        
        if !_refreshView.isRefreshing {
            _refreshView.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        
        if self.showSearch {
            initSearchView()
        }
        
        initRefreshView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initTableView(){
        
        var vf = self.view.frame
        if _tableFooterHeight > 0 {
            vf.size.height -= _tableFooterHeight
        }
        
        _tableView = UITableView(frame: vf, style: UITableViewStyle.plain)
        _tableView?.register(GsUsersIconTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    
    func initSearchView(){
        
        _searchView.frame = CGRect.zero
        _searchView.placeholder = sysLang(key: "Search")
        _searchView.delegate = self
        _searchView.sizeToFit()
        
        _tableView!.tableHeaderView  = _searchView
    }
    
    func initRefreshView(){
        
        _refreshView.addTarget(self, action: #selector(self.refreshUrl), for: .valueChanged)
        _tableView!.addSubview(_refreshView)
        
        _tableView?.contentOffset.y -= 60
        _refreshView.beginRefreshing()
        refreshUrl()
    }
    
    func refreshUrl(){
        _refreshView.endRefreshing()
    }
    
    func pullRefreshView(){
        
        _tableView?.tableFooterView = nil
        
        _footerView = UIView(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: 44))
        
        //        let footerTopLine = UIView(frame: CGRectMake(0, 0, _footerView.frame.width, 0.5))
        //        footerTopLine.backgroundColor = UIColor.grayColor()
        //        footerTopLine.layer.opacity = 0.4
        //        _footerView.addSubview(footerTopLine)
        
        let footerBottomLine = UIView(frame: CGRect(x: _footerView.frame.width*0.04, y: _footerView.frame.height - 1, width: _footerView.frame.width*0.96, height: 0.5))
        footerBottomLine.backgroundColor = UIColor.gray
        footerBottomLine.layer.opacity = 0.3
        _footerView.addSubview(footerBottomLine)
        
        let loadMoreText =  UILabel(frame: CGRect(x: 0,y: 0, width: 110, height: 40))
        loadMoreText.textAlignment = .center
        loadMoreText.center = _footerView.center
        loadMoreText.text = sysLang(key: "Loading")
        _footerView.addSubview(loadMoreText)
        
        let upLoading = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width:30,height: 30))
        upLoading.tintColor = UIColor.gray
        upLoading.activityIndicatorViewStyle = .gray
        upLoading.center.y = _footerView.center.y
        upLoading.frame.origin.x = _footerView.center.x - 55 - 15
        upLoading.startAnimating()
        _footerView.addSubview(upLoading)
        
        _tableView?.tableFooterView = _footerView
        self.startPull()
    }
    
    //MARK: - Methods -
    func applyFilter(searchKey:String){
        _searchValue = searchKey
        for i in _tableData {
            let ok = self.delegate!.applyFilter(searchKey: searchKey, data: i)
            if ok {
                _tableSearchData.append(i)
            }
        }
    }
    
    func getSelectTableData(indexPath:NSIndexPath) -> JSON {
        if _searchValue != "" {
            if _tableSearchData.count > 0 {
                return _tableSearchData[indexPath.row]
            }
        }
        return _tableData[indexPath.row]
    }
    
    func startPull(){
        _refreshView.beginRefreshing()
        
        if !_refreshing {
            _tableView?.contentOffset.y -= 64
        }
        _refreshing = true
    }
    
    func pullingEnd(){
        
        _refreshing = false
        _refreshView.endRefreshing()
        _tableView?.tableFooterView = nil
    }
    
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsListViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _searchValue != "" {
            if _tableSearchData.count > 0 {
                return _tableSearchData.count
            } else {
                return 1
            }
        }
        return _tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if _searchValue != "" {
            if _tableSearchData.count == 0 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.text = sysLang(key: "Can`t find it")
                return cell
            }
        }
        
        let cell = self.delegate?.listTableView(tableView: tableView, cellForRowAtIndexPath: indexPath as NSIndexPath)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if _searchValue != "" {
            if _tableSearchData.count == 0 {
            } else {
                self.delegate!.listTableView(tableView: tableView, didSelectRowAtIndexPath: indexPath as NSIndexPath)
            }
        } else {
            self.delegate!.listTableView(tableView: tableView, didSelectRowAtIndexPath: indexPath as NSIndexPath)
        }
    }
    
}

extension GsListViewController:UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        searchBar.showsCancelButton = false
        _searchValue = ""
        
        self._tableSearchData = Array<JSON>()
        self._tableView!.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        _tableSearchData = Array<JSON>()
        
        if let searchKey = searchBar.text {
            self.applyFilter(searchKey: searchKey)
        }
        
        _tableView!.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        _tableSearchData = Array<JSON>()
        
        if let searchKey = searchBar.text {
            self.applyFilter(searchKey: searchKey)
        }
        
        _tableView!.reloadData()
    }
}

extension GsListViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom -
            scrollView.frame.height// - _tableView!.tableFooterView!.frame.height
        if (offsetY > judgeOffsetY)  && !_refreshing && (offsetY > (_tableView?.frame.height)!) {
            let url = pageInfo?.nextPage
            if (url != nil && _searchValue == "" && pageInfo?.nextNum != 1) {
                self.pullRefreshView()
                self.delegate!.pullUrlLoad(url: url!)
            }
        }
    }
}

extension GsListViewController {
    
    
    func resetView(){
        
        let root = self.getRootVC()
        
        let w = root.view.frame.width < root.view.frame.height
            ? root.view.frame.width : root.view.frame.height
        
        let h = root.view.frame.height > root.view.frame.width
            ? root.view.frame.height : root.view.frame.width
        
        if UIDevice.current.orientation.isPortrait {
            _tableView?.frame = CGRect(x: 0, y: 0, width: w, height: h - _tableFooterHeight)
        } else if UIDevice.current.orientation.isLandscape {
            _tableView?.frame = CGRect(x: 0, y: 0, width: h, height: w - _tableFooterHeight)
        }
        self._tableView?.reloadData()
    }
    
}

extension GsListViewController{
    
    func getNavBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        var tsize = size
        if _tableFooterHeight > 0 {
            tsize.height -= _tableFooterHeight
        }
        
        _tableView?.frame.size = tsize
        _tableView?.reloadData()
    }
    
}

protocol  GsListViewDelegate : NSObjectProtocol{
    func listTableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    func listTableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void
    func applyFilter(searchKey:String, data:JSON) -> Bool
    func pullUrlLoad(url:String) -> Void
}

//
//  SearchViewController.swift
//  GitHubStar
//
//  Created by midoks on 15/11/30.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
import SwiftyJSON

class GsSearchViewController: UIViewController{
    
    var _tableView: UITableView?
    
    var _searchResultController:GsSearchResultController?
    var _searchController:UISearchController?
    
    let cellIdentifier = "GsSearchCell"
    
    var status:UIActivityIndicatorView?
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _tableView?.frame = self.view.frame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = sysLang(key: "Discover")
        self.initView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func initView(){
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView?.dataSource = self
        _tableView?.delegate = self
        self.view.addSubview(_tableView!)
        
        
        _searchResultController = GsSearchResultController()
        _searchController = UISearchController(searchResultsController: _searchResultController)
        _searchController?.searchResultsUpdater = self
        _searchController?.delegate = self
        _searchController?.dimsBackgroundDuringPresentation = true
        
        _searchController?.searchBar.delegate = self
        _searchController?.searchBar.placeholder = sysLang(key: "Search Projects")
        _tableView!.tableHeaderView = self._searchController!.searchBar
        
        _searchController?.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        
        status = UIActivityIndicatorView(activityIndicatorStyle: .gray);
        view.addSubview(status!)
        status?.startAnimating()
    }
}

extension GsSearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        //print("搜索Begin")
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        //print("搜索End")
        return true
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        //print("bookmakr")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //print("staring")
        _searchResultController?.searchUrl()
    }
}

//MARK:  - UISearchControllerDelegate & UISearchResultsDelegate -
extension GsSearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        
    }

    
    func willPresentSearchController(_ searchController: UISearchController) {
        //print("willPresentSearchController")
        self.tabBarController?.tabBar.isHidden = true
        //_searchResultController = GsSearchResultController()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //print("didPresentSearchController")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tabBarController?.tabBar.isHidden = false
        _tableView?.frame = self.view.frame
        _searchResultController?.clearSearchData()
        _searchResultController?._tableData = Array<JSON>()
    }
    
    //搜索内容更新时
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self._searchController!.searchBar.text
        //print(searchText)
        if searchText != "" {
            self._searchResultController?.searchingKeyWords(keyWords: searchText!)
        }
    }
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsSearchViewController:UITableViewDataSource, UITableViewDelegate{
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = sysLang(key: "Public Events") //:/event
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.textLabel?.text = sysLang(key: "Public Gists") //:/gists/public
                cell.accessoryType = .disclosureIndicator
            }
            
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "自由号"
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let event = GsEventsViewController()
                event.hidesBottomBarWhenPushed = true
                event.setUrlData(url: "/events")
                self.push(v: event)
            } else if indexPath.row == 1 {
                let gists = GsGistsViewController()
                gists.hidesBottomBarWhenPushed = true
                gists.setUrlData(url: "/gists/public")
                self.push(v: gists)
            }
            
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                self.tabBarController?.tabBar.isHidden = true
                let free = GsFreeCardViewController()
                self.push(v: free)
            }
            
        }
    }
}

extension GsSearchViewController{
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        _tableView?.frame.size = size
    }
}


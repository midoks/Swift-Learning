//
//  GsHomeViewController.swift
//  GitHubStar
//
//  Created by midoks on 16/4/5.
//  Copyright © 2016年 midoks. All rights reserved.
//

import UIKit

class GsHomeViewController: UIViewController {
    
    var _tableView: UITableView?
    
    var _refresh = UIRefreshControl()
    
    var _headView = GsHomeHeadView()
    var _backView = UIView()
    
    var _tabBarH:CGFloat = 0
    
    
    deinit {
        print("deinit GsHomeViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.resetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTableView()
        initTableHeadView()
        initRefreshView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initTableView(){
        
        _tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.grouped)
        _tableView?.frame.size.height -= 64
        _tableView?.dataSource = self
        _tableView?.delegate = self
        
        self.view.addSubview(_tableView!)
    }
    
    private func initRefreshView(){
        
        _refresh.addTarget(self, action: #selector(self.refreshUrl), for: .valueChanged)
        _refresh.tintColor = UIColor.white
        _tableView!.addSubview(_refresh)
        
        _tableView?.contentOffset.y -= 64
        _refresh.beginRefreshing()
        refreshUrl()
    }
    
    func startRefresh(){
        _tableView?.contentOffset.y -= 64
        _refresh.beginRefreshing()
    }
    
    func endRefresh(){
        _refresh.endRefreshing()
    }
    
    
    private func initTableHeadView(){
        
        _backView = UIView(frame: CGRect(x: 0, y: -self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        _backView.backgroundColor = UIColor.primaryColor()
        _tableView?.addSubview(_backView)
        
        _headView = GsHomeHeadView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        _headView.backgroundColor = UIColor.primaryColor()
        
        _headView.icon.backgroundColor = UIColor.white
        _tableView?.tableHeaderView = _headView
        
    }
    
    func refreshUrl(){
        _refresh.endRefreshing()
    }
    
}

extension GsHomeViewController {
    
    func getNavBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
    }
    
    func resetView(){
        
        let root = self.getRootVC()
        _tabBarH = self.getNavBarHeight()
        
        let w = root.view.frame.width < root.view.frame.height
            ? root.view.frame.width : root.view.frame.height
        
        let h = root.view.frame.height > root.view.frame.width
            ? root.view.frame.height : root.view.frame.width
        
        if UIDevice.current.orientation.isPortrait {
            _tableView?.frame = CGRect(x: 0, y: 0, width: w, height: h - _tabBarH)
        } else if UIDevice.current.orientation.isLandscape {
            _tableView?.frame = CGRect(x: 0, y: 0, width: h, height: w - _tabBarH)
        }
        
        _backView.frame = CGRect(x: 0, y: -root.view.frame.height, width: root.view.frame.width, height: root.view.frame.height)
    }

}


extension GsHomeViewController {
    
    func setAvatar(url:String){
        self.asynTask { 
            self._headView.icon.MDCacheImage(url: url, defaultImage: "avatar_default")
        }
    }
    
    func setName(name:String){
        self.asynTask {
            self._headView.name.text = name
            let size = self._headView.getLabelSize(label: self._headView.name)
            self._headView.name.frame.size.height = size.height
            
            self._headView.frame.size.height = 90 + size.height + 5
            self._tableView?.tableHeaderView = self._headView
        }
    }
    
    func setDesc(desc:String){
        
        self.asynTask {
            
            self._headView.desc.text = desc
            self._headView.desc.frame.origin.y = self._headView.frame.size.height
            let size = self._headView.getLabelSize(label: self._headView.desc)
            
            self._headView.frame.size.height = self._headView.frame.size.height + size.height + 5
            self._tableView?.tableHeaderView = self._headView
        }
        
    }
    
    func setStarStatus(status:Bool){
        self.asynTask {
            self._headView.addIconStar()
        }
    }
    
    func removeStarStatus(){
        self.asynTask { 
            self._headView.removeIconStar()
        }
    }
    
    func setIconView(icon:[GsIconView]){
        
        self.asynTask {
            
            for i in self._headView.listIcon {
                i.removeFromSuperview()
            }
            
            for i in self._headView.listLine {
                i.removeFromSuperview()
            }
            
            self._headView.listIcon.removeAll()
            self._headView.listLine.removeAll()
            
            for i in icon {
                self._headView.addIcon(icon: i)
            }
            
            self._headView.frame.size.height = self._headView.frame.size.height + 70
            self._tableView?.tableHeaderView = self._headView
            
        }
    }
}

extension GsHomeViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 0 {
            self.navigationController?.navigationBar.shadowImage = nil
        } else {
            self.navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}

extension GsHomeViewController{
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        _backView.frame = CGRect(x: 0, y: -size.height, width: size.width, height: size.height)
        _tabBarH = self.getNavBarHeight()
        
        if _tabBarH > 32 { //print("竖屏")
            _tableView?.frame.size = CGSize(width: size.width, height: size.height + _tabBarH / 2)
        } else { //print("横屏")
            _tableView?.frame.size = CGSize(width: size.width, height: size.height - _tabBarH)
        }
        
    }
    
}

//Mark: - UITableViewDataSource && UITableViewDelegate -
extension GsHomeViewController:UITableViewDataSource, UITableViewDelegate {
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "home"
        return cell
    }
    
}

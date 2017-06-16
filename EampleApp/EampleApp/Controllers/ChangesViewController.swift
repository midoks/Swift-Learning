//
//  ChangeViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/19.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



enum RefreshStatus{
    case uping
    case upEnd
    case downing
    case downEnd
}


class ChangesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var _tableView: UITableView?
    var _tableData: NSMutableArray?
    
    
    //
    var _pullRefresh: UIRefreshControl?
    
    //加载更多相关
    var _footerView: UIView?
    var _footerButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.title = "变动日志"
        
        
        //log列表页
        _tableView              = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height),
            style: UITableViewStyle.plain)
        _tableView!.dataSource  = self
        _tableView!.delegate    = self
        
        
        self.initTableData()
        self.view.addSubview(_tableView!)
        
        setupUpRefresh()
        setupDownRefresh()
    }
    
    //初始化数据
    func initTableData(){
        
        self._tableData = NSMutableArray()
        
        
        for _ in 0 ..< 20 {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss.S"
            
            let s = timeFormatter.string(from: date)
            _tableData?.add(s)
        }
        
        self._tableView!.reloadData()
    }
    
    //下拉刷新
    func setupUpRefresh(){
        _pullRefresh = UIRefreshControl(frame: CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: 20))
        _pullRefresh!.addTarget(self, action: #selector(ChangesViewController.refreshData(_:)), for: UIControlEvents.valueChanged)
        _pullRefresh!.attributedTitle = NSAttributedString(string: "下拉刷新")
        _pullRefresh?.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        _tableView!.addSubview(_pullRefresh!)
        
        //_pullRefresh!.beginRefreshing()
        //self.refreshData(_pullRefresh!)
    }
    
    //刷新数据方法
    func refreshData(_ control:UIRefreshControl){
        _pullRefresh!.attributedTitle = NSAttributedString(string: "下拉刷新中...")
        _tableView!.reloadData()
        
        mThreadTool.mdispatch(3) { () -> () in
            self._pullRefresh!.attributedTitle = NSAttributedString(string: "下拉刷新")
            self._pullRefresh!.endRefreshing()
        }
        
    }
    
    //加载更多 start
    func setupDownRefresh(){
        _footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        _footerView!.backgroundColor = UIColor.clear
        
        _footerButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        _footerButton!.setTitle("加载更多", for: UIControlState())
        _footerButton!.addTarget(self, action: #selector(ChangesViewController.addList(_:)), for: UIControlEvents.touchUpInside)
        _footerButton!.setTitleColor(UIColor.black, for: UIControlState())
        _footerButton!.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        _footerView?.addSubview(_footerButton!)
        _tableView!.tableFooterView = _footerView
    }
    
    
    //添加数据
    func addList(_ sender: UIButton){
        
        
        if(_tableData?.count < 23){
            
            _footerButton?.setTitle("加载中...", for: UIControlState())
            
            mThreadTool.mdispatch(1) { () -> () in
                
                self._footerButton?.setTitle("加载更多", for: UIControlState())
                
                let date = Date()
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss.S"
                
                let s = timeFormatter.string(from: date)
                
                
                self._tableData!.add(s)
                self._tableView!.reloadData()
            }
            
        }else{
            _footerButton?.setTitle("没有更多了", for: UIControlState())
        }
    }
    
    //通过滚动条,判断是否到了底部
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        //当最后一个,显示在屏幕上
        let cellLast = scrollView.contentSize.height
            + scrollView.contentInset.bottom - scrollView.frame.size.height - 40
        
        if(offsetY > cellLast){
            //print("加载更多")
        }
    }
    
    //加载更多 end
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //每组多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self._tableData != nil && self._tableData!.count > 0){
            //print(self._tableData?.count)
            return self._tableData!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "sign")
        let s = self._tableData!.object(at: indexPath.row) as! String
        cell.textLabel!.text = s + " - 测试"
        
        return cell
    }
    
    //点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

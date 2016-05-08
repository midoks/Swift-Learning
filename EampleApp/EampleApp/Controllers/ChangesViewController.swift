//
//  ChangeViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/19.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit


enum RefreshStatus{
    case Uping
    case UpEnd
    case Downing
    case DownEnd
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
        _tableView              = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height),
            style: UITableViewStyle.Plain)
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
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss.S"
            
            let s = timeFormatter.stringFromDate(date)
            _tableData?.addObject(s)
        }
        
        self._tableView!.reloadData()
    }
    
    //下拉刷新
    func setupUpRefresh(){
        _pullRefresh = UIRefreshControl(frame: CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: 20))
        _pullRefresh!.addTarget(self, action: #selector(ChangesViewController.refreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        _pullRefresh!.attributedTitle = NSAttributedString(string: "下拉刷新")
        _pullRefresh?.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        _tableView!.addSubview(_pullRefresh!)
        
        //_pullRefresh!.beginRefreshing()
        //self.refreshData(_pullRefresh!)
    }
    
    //刷新数据方法
    func refreshData(control:UIRefreshControl){
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
        _footerView!.backgroundColor = UIColor.clearColor()
        
        _footerButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        _footerButton!.setTitle("加载更多", forState: UIControlState.Normal)
        _footerButton!.addTarget(self, action: #selector(ChangesViewController.addList(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        _footerButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        _footerButton!.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        _footerView?.addSubview(_footerButton!)
        _tableView!.tableFooterView = _footerView
    }
    
    
    //添加数据
    func addList(sender: UIButton){
        
        
        if(_tableData?.count < 23){
            
            _footerButton?.setTitle("加载中...", forState: UIControlState.Normal)
            
            mThreadTool.mdispatch(1) { () -> () in
                
                self._footerButton?.setTitle("加载更多", forState: UIControlState.Normal)
                
                let date = NSDate()
                let timeFormatter = NSDateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss.S"
                
                let s = timeFormatter.stringFromDate(date)
                
                
                self._tableData!.addObject(s)
                self._tableView!.reloadData()
            }
            
        }else{
            _footerButton?.setTitle("没有更多了", forState: UIControlState.Normal)
        }
    }
    
    //通过滚动条,判断是否到了底部
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        //当最后一个,显示在屏幕上
        let cellLast = scrollView.contentSize.height
            + scrollView.contentInset.bottom - scrollView.frame.size.height - 40
        
        if(offsetY > cellLast){
            //print("加载更多")
        }
    }
    
    //加载更多 end
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //每组多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self._tableData != nil && self._tableData!.count > 0){
            //print(self._tableData?.count)
            return self._tableData!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "sign")
        let s = self._tableData!.objectAtIndex(indexPath.row) as! String
        cell.textLabel!.text = s + " - 测试"
        
        return cell
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

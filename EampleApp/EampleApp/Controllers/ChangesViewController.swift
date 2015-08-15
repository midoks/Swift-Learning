//
//  ChangeViewController.swift
//  MovieSSS
//
//  Created by midoks on 15/7/19.
//  Copyright © 2015年 midoks. All rights reserved.
//

import UIKit

class ChangesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var _tableView: UITableView?
    var _tableData: NSMutableArray?
    var _pullRefresh: UIRefreshControl?
    var _footerView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.title = "变动日志"
        
        _tableView              = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        _tableView!.dataSource  = self
        _tableView!.delegate    = self
        
        //_tableView!.registerClass(UITableViewCell.classForCoder(), forHeaderFooterViewReuseIdentifier: "sign")
        
        
        self.initTableData()
        self.view.addSubview(_tableView!)
        
        setupUpRefresh()
        setupDownRefresh()
    }
    
    //初始化数据
    func initTableData(){
        
        self._tableData = NSMutableArray()
        
        
        for(var i=0;i<10; i++){
            
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
        _pullRefresh = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
        _pullRefresh!.addTarget(self, action: Selector("refreshData:"), forControlEvents: UIControlEvents.ValueChanged)
        //_pullRefresh!.attributedTitle = NSAttributedString(string: "下拉刷新")
        
        _tableView!.addSubview(_pullRefresh!)
        
        _pullRefresh!.beginRefreshing()
        self.refreshData(_pullRefresh!)
    }
    
    //刷新数据方法
    func refreshData(control:UIRefreshControl){
        print("refresh")
        _tableView?.reloadData()
        _pullRefresh!.endRefreshing()
        
    }
    
    //加载更多 start
    func setupDownRefresh(){
        
        _footerView = UIView(frame: CGRect(x: 0, y: 1, width: self.view.frame.width, height: 20))
        //_footerView!.backgroundColor = UIColor.clearColor()
        //footerView.hidden = true
        
        //        let more = UILabel(frame: CGRect(x: 0, y: 1, width: self.view.frame.width, height: 20))
        //        more.textAlignment = NSTextAlignment.Center
        //        more.text = "加载更多"
        
        let moreButton = UIButton(frame: CGRect(x: 0, y: 1, width: self.view.frame.width, height: 20))
        moreButton.setTitle("加载更多", forState: UIControlState.Normal)
        moreButton.backgroundColor = UIColor.redColor()
        
        _footerView?.addSubview(moreButton)
        
        _tableView!.tableFooterView = _footerView
    }
    
    //通过滚动条,判断是否到了底部
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        //当最后一个,显示在屏幕上
        let cellLast = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.size.height - 20
        
        if(offsetY > cellLast){
            print("加载更多")
            
//            let date = NSDate()
//            let timeFormatter = NSDateFormatter()
//            timeFormatter.dateFormat = "HH:mm:ss.S"
//            
//            let s = timeFormatter.stringFromDate(date)
//            self._tableData?.addObject(s)
//            self._tableView!.reloadData()
            
            
        }else{
            print(offsetY)
            print(cellLast)
        }
    }
    
    //加载更多 end
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //每组多少行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self._tableData != nil && self._tableData!.count > 0){
            print(self._tableData?.count)
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

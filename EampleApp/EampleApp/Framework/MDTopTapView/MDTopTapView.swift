//
//  MDTopTapView.swift
//  EampleApp
//
//  Created by midoks on 15/9/3.
//  Copyright © 2015年 midoks. All rights reserved.
//

import Foundation
import UIKit


class MDTopTapView :UIView, UITableViewDataSource,UITableViewDelegate {
    
    //顶部菜单栏横向滑动的table
    var topMenuTableView: UITableView?
    //菜单下面横向滑动内容的table
    var contentTableView: UITableView?
    //指示器view
    var indicatorView: UIView?
    //页数
    var pageIndex:Int?
    
    var _angle:CGFloat?
    
    
    //MARK: - 初始化 -
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.pageIndex = 0
        
        self.initTopTapTableView()
        self.initContentTableView()
        self.initIndicatorView()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化指示器
    func initIndicatorView() ->UIView {
        if(nil == indicatorView){
            
            let width = self.getMenuWidth()
            let height:CGFloat = 2
            
            indicatorView = UIView(frame: CGRect(x:0 , y: 0, width: height, height: width))
            indicatorView?.backgroundColor = UIColor.blueColor()
            
            topMenuTableView?.addSubview(indicatorView!)
            topMenuTableView?.bringSubviewToFront(indicatorView!)
        }
        return indicatorView!
    }
    
    //TopTapTableView
    func initTopTapTableView() -> UITableView{
        
        if(nil == topMenuTableView ){
            //print(self.frame)
            
            let topMenuHeight:CGFloat = self.getMenuHeight()
            let topMenuWidth:CGFloat = CGRectGetWidth(self.frame) + 64 + 49
            
            //before rotate bounds = (0, 0, width, height)
            //rototate -90 bounds = (0, 0, height, width)
            
            let x = topMenuWidth / 2.0 - topMenuHeight / 2.0 - 64
            let y = -topMenuWidth / 2.0  + topMenuHeight / 2.0
            
            
            //print(CGRectGetWidth(self.frame))
            //print(topMenuHeight)
            
            topMenuTableView     = UITableView(frame: CGRect(x: x, y: y,
                width: topMenuHeight, height: topMenuWidth),
                style: UITableViewStyle.Plain)
            topMenuTableView!.dataSource  = self
            topMenuTableView!.delegate    = self
            self.addSubview(topMenuTableView!)
            
            
            //不显示滚动条
            topMenuTableView?.showsVerticalScrollIndicator = false
            //不显示分割线
            topMenuTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
            _angle = (CGFloat)(-M_PI/2)
            topMenuTableView?.transform = CGAffineTransformMakeRotation(_angle!)
        
            
            //NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timeRotationTest"), userInfo: nil, repeats: true)
        }
        return topMenuTableView!
    }
    
    func initContentTableView() -> UITableView {
        if( nil == contentTableView){
        
            let cHeight = CGRectGetWidth(self.frame)
            let cWidth = CGRectGetHeight(self.frame) - self.getMenuHeight()
            
            let x = CGRectGetWidth(self.frame)/2 - cWidth/2
            let y_abs = (Float)(cHeight/2.0 - cWidth/2.0)
            let y = (CGFloat)(fabsf(y_abs)) + self.getMenuHeight()
            
            contentTableView = UITableView(frame: CGRect(x: x, y: y, width: cWidth, height: cHeight), style: UITableViewStyle.Plain)
            self.addSubview(contentTableView!)
            
            contentTableView?.delegate = self
            contentTableView?.dataSource = self
            contentTableView?.showsVerticalScrollIndicator = false
            contentTableView?.pagingEnabled = true
            contentTableView?.separatorStyle = UITableViewCellSeparatorStyle.None
            
            let _angle = (CGFloat)(-M_PI/2.0)
            contentTableView?.transform = CGAffineTransformMakeRotation(_angle)
        }
        return contentTableView!
    }
    
    func timeRotationTest(){
        _angle = _angle! + 0.01;//angle角度 double angle;
        if (_angle > 6.28) {//大于 M_PI*2(360度) 角度再次从0开始
            _angle = 0;
        }
        
        let transform=CGAffineTransformMakeRotation(_angle!)
        topMenuTableView!.transform = transform
    }
    
    
    //MARK: - UITableViewDataSource -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == self.topMenuTableView){
            return self.getMenuWidth()
        }else if(tableView == self.contentTableView){
            return CGRectGetWidth(self.frame)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == self.topMenuTableView){
            //var cell = tableView.dequeueReusableCellWithIdentifier("TopMenuCell")
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TopMenuCell")
            cell.frame = CGRectMake(0, 0, self.getMenuWidth(), self.getMenuHeight())
            
            
            cell.contentView.removeFromSuperview()
            //cell!.backgroundColor = self.randomColor()
            
            let textView = UIView(frame: CGRect(x: 0, y: 0, width: self.getMenuWidth(), height: self.getMenuHeight()))
            let text = UILabel(frame: textView.frame)
            text.text = "测试" + String(indexPath.row)
            text.textAlignment = NSTextAlignment.Center
            textView.addSubview(text)
            cell.addSubview(textView)
            
            let _angleView = (CGFloat)(M_PI/2)
            
            let x = self.getMenuWidth() / 2.0 - CGRectGetWidth(textView.frame) / 2.0
            let y = self.getMenuHeight() / 2.0  - CGRectGetHeight(textView.frame) / 2.0
            
            textView.transform = CGAffineTransformMakeRotation(_angleView)
            textView.frame = CGRectMake(x, y, CGRectGetWidth(textView.frame), CGRectGetHeight(textView.frame))
            textView.backgroundColor = UIColor.yellowColor()
            
            
            return cell
        }else if(tableView == contentTableView){
            //var cell = tableView.dequeueReusableCellWithIdentifier("ContentPageCell")
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ContentPageCell")
            cell.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame)-self.getMenuHeight(), CGRectGetWidth(self.frame))
            cell.contentView.removeFromSuperview()
            cell.backgroundColor = UIColor.clearColor()
            
            let textView = UIView(frame: CGRect(x: 0, y: 0, width: CGRectGetHeight(self.frame)-self.getMenuHeight(), height: CGRectGetWidth(self.frame)))
            //textView.backgroundColor = self.randomColor()
            let text = UILabel(frame: textView.frame)
            text.text = "测试" + String(indexPath.row)
            text.textAlignment = NSTextAlignment.Center
            textView.addSubview(text)
            let _angleView = (CGFloat)(M_PI/2.0)
            textView.transform = CGAffineTransformMakeRotation(_angleView)
            cell.addSubview(textView)
            
            return cell
        }else{
            
            let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TopMenuCell")
            cell.textLabel!.text = "测试"
            return cell
        }
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if(tableView == self.topMenuTableView){
            self.pageIndex = indexPath.row
            self.contentTablesScrollToIndexPath(indexPath)
        }
    }
    
    //MARK: - scrollView -
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(scrollView == self.contentTableView ){
            let tmpPage = ((self.contentTableView?.contentOffset.y)! + 0.5 * CGRectGetWidth(self.frame))/CGRectGetWidth(self.frame)
            if(tmpPage != (CGFloat)(self.pageIndex!)){
                self.pageIndex = (Int)(tmpPage)
            }
            self.updateIndicatorPosition()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView == self.contentTableView ){
            self.handleEndScroll()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(scrollView == self.contentTableView)
        {
            if(!decelerate)
            {
                self.handleEndScroll();
            }
        }

    }
    
    //MARK: - Public Methods -
    
    
    func reloadData(){
        self.topMenuTableView?.reloadData()
        self.contentTableView?.reloadData()
    }
    
    func updateIndicatorPosition() {
        let y = (self.contentTableView?.contentOffset.y)! / (self.contentTableView?.contentSize.height)!
        
        self.indicatorView!.frame = CGRectMake(self.indicatorView!.frame.origin.x,
            (y * self.topMenuTableView!.contentSize.height),
            self.indicatorView!.frame.size.width,
            self.indicatorView!.frame.size.height)
    }
    
    func contentTablesScrollToIndexPath(indexPath: NSIndexPath){
        self.contentTableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
        self.handleEndScroll()
    }
    
    //MARK: - Private Methods -
    
    func handleEndScroll(){
        let indexPath = NSIndexPath(forRow: self.pageIndex!, inSection: 0)
        self.topMenuTableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    func randomColor()->UIColor{
        let hue = (CGFloat)(arc4random() % 256) / 256.0
        let saturation = (CGFloat)(arc4random() % 256) / 256.0
        let brightness = (CGFloat)(arc4random() % 256) / 256.0
        
        let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        return color
    }
    
    //顶部菜单的高度
    func getMenuHeight()->CGFloat{
        return 40
    }
    
    //顶部菜单的宽度
    func getMenuWidth()->CGFloat{
        return 80
    }
    
    
}

@objc protocol MDTopTapViewDelegate{
    
    
    
    
    
}

